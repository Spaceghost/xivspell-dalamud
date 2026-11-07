namespace XivSpell;

// Pure monotonic clock and chart logic. Music observation never casts or sends input.
public sealed class RhythmClock
{
    private readonly Queue<double> intervals = new();
    private long stream, sequence;
    private double lastOnset = double.NaN, lastTap = double.NaN, anchor, lastFresh = double.NegativeInfinity;
    public double Bpm { get; private set; } = 120;
    public double Period => 60 / Bpm;
    public bool Locked => intervals.Count >= 3;
    public string Source { get; private set; } = "Tempo guide";
    public float Energy { get; private set; }
    public bool MusicFresh(double now) => now - lastFresh < .35;
    public void SetTempo(double bpm, double now)
    {
        if (!double.IsFinite(bpm) || !double.IsFinite(now)) return;
        Bpm = Math.Clamp(bpm, 50, 220); anchor = now; intervals.Clear(); lastTap = lastOnset = double.NaN;
        Source = "Tempo guide";
    }
    public void Tap(double now)
    {
        if (!double.IsFinite(now)) return;
        if (double.IsFinite(lastTap)) ObserveInterval(now - lastTap);
        lastTap = now; anchor = now; Source = "Tap tempo / game music";
    }
    public void Observe(long streamId, long seq, bool playing, bool fresh, double age, float onset, float rms, double now)
    {
        if (!double.IsFinite(now) || !double.IsFinite(age) || age < 0 || age > .2 || !playing || !fresh ||
            !float.IsFinite(onset) || !float.IsFinite(rms)) return;
        if (streamId != stream) {
            stream = streamId; sequence = 0; lastOnset = double.NaN; intervals.Clear();
        }
        if (seq <= sequence) return;
        sequence = seq; lastFresh = now; Energy = Math.Clamp(rms * 3, 0, 1);
        Source = "XivPiano / " + (Locked ? "estimated beat" : "learning beat");
        // The producer reports an onset envelope, not a beat. Ignore its decay
        // and estimate a stable grid only after several plausible intervals.
        if (onset < .3f || double.IsFinite(lastOnset) && now - lastOnset < .24) return;
        if (double.IsFinite(lastOnset)) ObserveInterval(now - lastOnset);
        lastOnset = now;
        if (Locked) {
            var nearest = anchor + Math.Round((now - anchor) / Period) * Period;
            anchor += Math.Clamp(now - nearest, -.025, .025);
        } else anchor = now;
    }
    private void ObserveInterval(double value)
    {
        if (value < .27 || value > 1.2) return;
        intervals.Enqueue(value);
        while (intervals.Count > 8) intervals.Dequeue();
        var sorted = intervals.Order().ToArray();
        var median = sorted[sorted.Length / 2];
        if (sorted.Count(x => Math.Abs(x - median) <= median * .18) >= Math.Min(3, sorted.Length))
            Bpm = Math.Clamp(60 / median, 50, 220);
    }
    public double NextBeat(double now) => anchor + (Math.Floor((now - anchor) / Period) + 1) * Period;
}

public sealed class RhythmRound
{
    public sealed record Spell(string Id, string Phrase, string Name);
    public sealed record Note(char Letter, int Lane, char[] Choices, double Due, int LetterIndex);
    public enum Phase { Idle, Playing, Paused, Ready }
    public enum Grade { None, Perfect, Great, Good, Early, Wrong, Miss }
    public Phase State { get; private set; }
    public Spell? Target { get; private set; }
    public Note[] Notes { get; private set; } = [];
    public int Cursor { get; private set; }
    public int Score { get; private set; }
    public int Combo { get; private set; }
    public int BestCombo { get; private set; }
    public int Hits { get; private set; }
    public int Misses { get; private set; }
    public int Perfects { get; private set; }
    public int Stars => Hits == 0 ? 0 : Accuracy >= .98 ? 5 : Accuracy >= .9 ? 4 : Accuracy >= .75 ? 3 : Accuracy >= .55 ? 2 : 1;
    public double Accuracy => Hits + Misses == 0 ? 0 : (double)Hits / (Hits + Misses);
    public string Prefix => Target == null ? "" : new string(Notes.Take(Cursor).Select(n => n.Letter).ToArray());
    public Grade LastGrade { get; private set; }
    public double LastFeedback { get; private set; } = double.NegativeInfinity;
    public double LastErrorMs { get; private set; }
    public double PausedAt { get; private set; }
    public double LatencyMs { get; set; }
    public double HitWindow { get; set; } = .16;
    public bool Active => State == Phase.Playing;
    public bool Completed => State == Phase.Ready && Hits == Notes.Length && Notes.Length > 0;
    private double notePeriod = .5, lastInput = double.NegativeInfinity;

    public bool Start(Spell spell, IReadOnlyList<Spell> deck, double firstBeat, double period)
    {
        if (string.IsNullOrWhiteSpace(spell.Id) || string.IsNullOrWhiteSpace(spell.Phrase) ||
            spell.Phrase.Length > 64 || spell.Phrase.Any(char.IsControl) ||
            !double.IsFinite(firstBeat) || !double.IsFinite(period) || period is < .12 or > 1.5) return false;
        Target = spell with { Phrase = spell.Phrase.ToLowerInvariant() };
        var notes = new List<Note>();
        var prefix = "";
        foreach (var ch in Target.Phrase) {
            var choices = Choices(prefix, ch, deck);
            notes.Add(new(ch, Array.IndexOf(choices, ch), choices, firstBeat + notes.Count * period, notes.Count));
            prefix += ch;
        }
        Notes = notes.ToArray(); notePeriod = period; Cursor = Score = Combo = BestCombo = Hits = Misses = Perfects = 0;
        LastGrade = Grade.None; LastFeedback = lastInput = double.NegativeInfinity;
        State = Phase.Playing;
        return true;
    }
    public static char[] Choices(string prefix, char required, IReadOnlyList<Spell> deck)
    {
        var possible = deck.Select(s => s.Phrase.ToLowerInvariant())
            .Where(p => p.Length > prefix.Length && p.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
            .Select(p => p[prefix.Length]).Where(c => !char.IsControl(c)).Distinct().Order().ToList();
        possible.Remove(required);
        // Stable per-prefix permutation; fills empty lanes with distinct decoys.
        uint seed = 2166136261;
        foreach (var c in prefix) seed = (seed ^ c) * 16777619;
        seed = (seed ^ required) * 16777619;
        var result = new char[4]; var lane = (int)(seed % 4); result[lane] = required;
        var used = new HashSet<char> { required };
        for (var i = 0; i < result.Length; i++) {
            if (i == lane) continue;
            var next = possible.FirstOrDefault(c => !used.Contains(c));
            if (next == default) {
                for (var j = 0; j < 26; j++) {
                    var candidate = (char)('a' + (seed + (uint)j * 7) % 26);
                    if (!used.Contains(candidate)) { next = candidate; break; }
                }
            }
            result[i] = next; used.Add(next);
        }
        return result;
    }
    public void Tick(double now)
    {
        if (!Active || !double.IsFinite(now)) return;
        // A miss retains its letter and schedules it on a later beat. It cannot
        // silently turn an incomplete spell into a castable rune.
        if (Cursor < Notes.Length && now - Notes[Cursor].Due > HitWindow) {
            LastGrade = Grade.Miss; LastFeedback = now; Combo = 0; Misses++;
            Shift(Math.Max(notePeriod, Math.Ceiling((now - Notes[Cursor].Due + notePeriod) / notePeriod) * notePeriod));
        }
    }
    public Grade PressLane(int lane, double at) =>
        lane is >= 0 and < 4 && Cursor < Notes.Length ? Press(Notes[Cursor].Choices[lane], at) : Grade.None;
    public Grade Press(char letter, double at)
    {
        if (!Active || Cursor >= Notes.Length || !double.IsFinite(at) || at < lastInput) return Grade.None;
        lastInput = at;
        var error = at - Math.Clamp(double.IsFinite(LatencyMs) ? LatencyMs : 0, -250, 250) / 1000 - Notes[Cursor].Due;
        LastErrorMs = error * 1000;
        if (Math.Abs(error) > HitWindow) {
            if (at - LastFeedback >= .06) { LastGrade = Grade.Early; LastFeedback = at; }
            return Grade.Early;
        }
        LastFeedback = at;
        if (char.ToLowerInvariant(letter) != Notes[Cursor].Letter) {
            Combo = 0; Misses++; LastGrade = Grade.Wrong; return LastGrade;
        }
        LastGrade = Math.Abs(error) <= .045 ? Grade.Perfect : Math.Abs(error) <= .09 ? Grade.Great : Grade.Good;
        if (LastGrade == Grade.Perfect) Perfects++;
        Hits++; Combo++; BestCombo = Math.Max(BestCombo, Combo);
        Score += (LastGrade == Grade.Perfect ? 100 : LastGrade == Grade.Great ? 70 : 40) * Math.Min(4, 1 + Combo / 8);
        if (++Cursor == Notes.Length) State = Phase.Ready;
        return LastGrade;
    }
    public void Pause(double now)
    {
        if (!Active) return;
        State = Phase.Paused; PausedAt = now;
    }
    public void Resume(double firstBeat)
    {
        if (State != Phase.Paused || Cursor >= Notes.Length || !double.IsFinite(firstBeat)) return;
        Shift(firstBeat - Notes[Cursor].Due); State = Phase.Playing;
    }
    public void Stop() { State = Phase.Idle; }
    private void Shift(double amount)
    {
        for (var i = Cursor; i < Notes.Length; i++) Notes[i] = Notes[i] with { Due = Notes[i].Due + amount };
    }
}
