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
        var detected = now - age;
        if (onset < .3f || double.IsFinite(lastOnset) && detected - lastOnset < .24) return;
        if (double.IsFinite(lastOnset)) ObserveInterval(detected - lastOnset);
        lastOnset = detected;
        if (Locked) {
            var nearest = anchor + Math.Round((detected - anchor) / Period) * Period;
            anchor += Math.Clamp(detected - nearest, -.025, .025);
        } else anchor = detected;
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

// A shared timing stream: the player chooses the spell by typing it.
// Empty beats are optional; only an unfinished word can be broken by a miss.
public sealed class RhythmRound
{
    public sealed record Spell(string Id, string Phrase, string Name);
    public sealed record Note(double Due);
    public enum Phase { Idle, Playing, Paused, Ready }
    public enum Grade { None, Perfect, Great, Good, Early, Wrong, Miss }
    public Phase State { get; private set; }
    public Spell? Target { get; private set; }
    public Note[] Notes { get; private set; } = [];
    public int Cursor { get; private set; }
    public int Score { get; private set; }
    public int Combo { get; private set; }
    public int Hits { get; private set; }
    public int Misses { get; private set; }
    public string Prefix { get; private set; } = "";
    public string LastSpell { get; private set; } = "";
    public Grade LastGrade { get; private set; }
    public double LastFeedback { get; private set; } = double.NegativeInfinity;
    public string Feedback { get; private set; } = "";
    public double PausedAt { get; private set; }
    public double LatencyMs { get; set; }
    public double HitWindow { get; set; } = .18;
    public bool Active => State == Phase.Playing;
    public bool Completed => State == Phase.Ready && Target != null;
    public IEnumerable<Spell> Matches => deck.Where(s => s.Phrase.StartsWith(Prefix, StringComparison.OrdinalIgnoreCase));
    public string NextLetters => string.Join("  ", Matches.Where(s => s.Phrase.Length > Prefix.Length)
        .Select(s => s.Phrase[Prefix.Length]).Distinct().Order().Select(c => c == ' ' ? "SPACE" : char.ToUpperInvariant(c).ToString()));
    private Spell[] deck = [];
    private double period = .5, lastInput = double.NegativeInfinity;

    public bool Start(IReadOnlyList<Spell> spells, double firstBeat, double beatPeriod, IReadOnlyList<double>? times = null)
    {
        if (!double.IsFinite(firstBeat) || !double.IsFinite(beatPeriod) || beatPeriod is < .12 or > 1.5) return false;
        deck = spells.Where(s => !string.IsNullOrWhiteSpace(s.Id) && !string.IsNullOrWhiteSpace(s.Phrase)
            && s.Phrase.Length <= 64 && !s.Phrase.Any(char.IsControl))
            .Select(s => s with { Phrase = s.Phrase.ToLowerInvariant() }).ToArray();
        if (deck.Length == 0) return false;
        period = beatPeriod; Prefix = LastSpell = ""; Target = null;
        Score = Combo = Hits = Misses = 0; lastInput = LastFeedback = double.NegativeInfinity;
        LastGrade = Grade.None; Feedback = "Type any spell on the pulses";
        SetTimeline(firstBeat, times); State = Phase.Playing; return true;
    }
    private static bool ValidTimes(IReadOnlyList<double>? times) => times is { Count: >= 2 }
        && times.All(double.IsFinite) && times.Zip(times.Skip(1), (a,b) => b-a).All(g => g >= .2);
    private void SetTimeline(double firstBeat, IReadOnlyList<double>? times)
    {
        Notes = ValidTimes(times) ? times!.Select(t => new Note(t)).ToArray()
            : Enumerable.Range(0,64).Select(i => new Note(firstBeat+i*period)).ToArray();
        Cursor = 0;
    }
    // Append instead of moving visible pulses when Piano refreshes its map.
    public void Extend(IReadOnlyList<double>? times = null)
    {
        if (Notes.Length == 0) return;
        var last = Notes[^1].Due;
        var future = ValidTimes(times) ? times!.Where(t => t-last >= .2).Take(64).Select(t => new Note(t)).ToArray()
            : Enumerable.Range(1,32).Select(i => new Note(last+i*period)).ToArray();
        Notes = Notes.Skip(Cursor).Concat(future).Take(128).ToArray(); Cursor = 0;
    }
    private void ResetWord(Grade grade, double at, string message, bool penalty)
    {
        Prefix = ""; Target = null; Combo = 0;
        if (penalty) Misses++;
        LastGrade = grade; LastFeedback = at; Feedback = message;
    }
    public void Restart(double at) => ResetWord(Grade.None, at, "Word cleared · start any spell", false);
    public void Notice(string message, double at) { Feedback = message; LastFeedback = at; LastGrade = Grade.None; }
    public void Tick(double now)
    {
        if (!Active || !double.IsFinite(now)) return;
        // Compare the same calibrated clock used for event timestamps.
        var calibrated = now - Math.Clamp(double.IsFinite(LatencyMs) ? LatencyMs : 0,-250,250)/1000;
        if (Cursor >= Notes.Length || calibrated - Notes[Cursor].Due <= HitWindow) return;
        if (Prefix.Length > 0) ResetWord(Grade.Miss, now, "MISSED · restart from the first letter", true);
        while (Cursor < Notes.Length && calibrated - Notes[Cursor].Due > HitWindow) Cursor++;
    }
    public Grade Press(char letter, double at)
    {
        if (!Active || !double.IsFinite(at) || at < lastInput) return Grade.None;
        lastInput = at; var missesBefore=Misses; Tick(at);
        if (Misses>missesBefore) return LastGrade;
        if (letter == ' ' && Prefix.Length == 0) return Grade.None;
        var error = Cursor < Notes.Length ? at - Math.Clamp(double.IsFinite(LatencyMs) ? LatencyMs : 0,-250,250)/1000 - Notes[Cursor].Due : double.PositiveInfinity;
        if (Math.Abs(error) > HitWindow) {
            ResetWord(Grade.Early, at, "OFF BEAT · restart from the first letter", Prefix.Length > 0); return LastGrade;
        }
        var next = Prefix + char.ToLowerInvariant(letter);
        if (!deck.Any(s => s.Phrase.StartsWith(next, StringComparison.OrdinalIgnoreCase))) {
            Cursor++; ResetWord(Grade.Wrong, at, "WRONG LETTER · restart from the first letter", true); return LastGrade;
        }
        Prefix = next; Cursor++; Hits++; Combo++;
        LastGrade = Math.Abs(error) <= .045 ? Grade.Perfect : Math.Abs(error) <= .1 ? Grade.Great : Grade.Good;
        Score += LastGrade == Grade.Perfect ? 100 : LastGrade == Grade.Great ? 70 : 40;
        LastFeedback = at; Feedback = LastGrade.ToString().ToUpperInvariant();
        var exact = deck.FirstOrDefault(s => s.Phrase == Prefix);
        if (exact != null && !deck.Any(s => s.Phrase.Length > Prefix.Length && s.Phrase.StartsWith(Prefix, StringComparison.OrdinalIgnoreCase)))
            Complete(exact);
        return LastGrade;
    }
    private void Complete(Spell spell) { Target = spell; State = Phase.Ready; }
    public bool Commit(double at)
    {
        if (!Active) return false;
        var exact = deck.FirstOrDefault(s => s.Phrase == Prefix);
        if (exact == null) { Notice("Finish spelling before Enter", at); return false; }
        Complete(exact); return true;
    }
    public Spell? TakeCompleted(double now)
    {
        if (!Completed) return null;
        var spell = Target!; LastSpell = spell.Name; Prefix = ""; Target = null; State = Phase.Playing;
        Notice("QUEUED  " + spell.Name.ToUpperInvariant(), now); return spell;
    }
    public void Pause(double now) { if (!Active) return; State = Phase.Paused; PausedAt = now; }
    public void Resume(double firstBeat, IReadOnlyList<double>? times = null)
    {
        if (State != Phase.Paused || !double.IsFinite(firstBeat)) return;
        SetTimeline(firstBeat,times); State = Phase.Playing;
    }
    public void Align(double firstBeat,IReadOnlyList<double>? times)
    { if (Active && Prefix.Length==0 && double.IsFinite(firstBeat)) SetTimeline(firstBeat,times); }
    public void Stop() { State = Phase.Idle; Prefix = ""; Target = null; }
}

// Radius is relative to the fixed receptor. The reverse pulse meets it at
// the exact event timestamp, independently of frame rate and song interval.
public static class RhythmPulse
{
    public static double Radius(double remaining,double interval)
    {
        if (!double.IsFinite(remaining)) return 1.9;
        if (!double.IsFinite(interval)) interval=.5;
        return 1+.9*Math.Clamp(remaining/Math.Clamp(interval,.25,1.2),-.12,1);
    }
}
