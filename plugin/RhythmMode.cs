using System.Text.Json;

namespace XivSpell;

public sealed partial class Plugin
{
    private readonly RhythmClock rhythmClock = new();
    private readonly RhythmRound rhythm = new();
    private NativeRhythmHud? rhythmHud;
    private bool rhythmShown;
    private bool rhythmStartPending;
    private bool rhythmSongChart;
    private const double RhythmApproach = 1.2;
    private bool rhythmQueued, rhythmAvailable;
    private bool RhythmPadOwned => false; // Controller rhythm is deferred; never lease the pad.
    private long rhythmPoll;
    private readonly float[] rhythmSpectrum = new float[32];
    private string rhythmMusic = "Tempo guide · start Piano or tap along with game music";
    private static double RhythmNow => Environment.TickCount64 / 1000d;
    private readonly RhythmSound rhythmSound = new();
    private sealed record FuturePulse(double Seconds,float Strength);
    private FuturePulse[] futurePulses = [];
    private double songPosition, songSampleAt;
    private long songStream, timelinePoll;
    private bool songReady, songPlaying;
    private double[]? MusicTimes(int count=64,double lead=1.2)
    {
        if (!config.RhythmUsePiano || !songReady || !songPlaying) return null;
        var now=RhythmNow;
        var position=songPosition+Math.Max(0,now-songSampleAt);
        var result=new List<double>();var last=double.NegativeInfinity;
        foreach (var pulse in futurePulses) {
            if (pulse.Seconds<position+lead) continue;
            if (pulse.Seconds-last < (config.RhythmSubdivision==2 ? .22 : .32)) continue;
            result.Add(now+pulse.Seconds-position);last=pulse.Seconds;
            if (result.Count==count) return result.ToArray();
        }
        return result.Count>=2 ? result.ToArray() : null;
    }

    private bool RhythmCommand(string args)
    {
        if (!args.StartsWith("rhythm", StringComparison.OrdinalIgnoreCase)) return false;
        var words = args.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (words.Length == 1 || words[1] == "on") {
            config.RhythmEnabled = true; barVisible = true; BeginRhythm();
        } else if (words[1] == "off") {
            config.RhythmEnabled = false; keyboard.AllowRuneDelete=false; rhythm.Stop(); composer.Active = false;
            InterruptWeave("Rhythm off", true);
        } else if (words[1] == "tap") rhythmClock.Tap(RhythmNow);
        else if (words[1] == "tempo" && words.Length == 3 && double.TryParse(words[2], System.Globalization.NumberStyles.Float,
            System.Globalization.CultureInfo.InvariantCulture, out var bpm) && double.IsFinite(bpm)) {
            config.RhythmBpm = (float)Math.Clamp(bpm, 50, 220); config.RhythmUsePiano = false;
            rhythmClock.SetTempo(config.RhythmBpm, RhythmNow);
        } else if (words[1] is "pad" or "keyboard") {
            config.RhythmController = false;
            if (words[1] == "pad") weave.Hint = "Rhythm is keyboard-first · controller spelling is deferred";
        }
        else if (words[1] == "piano") config.RhythmUsePiano = true;
        else if (words[1] == "offset" && words.Length==3 && float.TryParse(words[2],out var offset) && float.IsFinite(offset))
            config.RhythmLatencyMs=Math.Clamp(offset,-250,250);
        else if (words[1] == "volume" && words.Length==3 && float.TryParse(words[2],out var volume) && float.IsFinite(volume))
            config.RhythmVolume=Math.Clamp(volume,0,.3f);
        else if (words[1] == "speed" && words.Length==3 && int.TryParse(words[2],out var speed)) config.RhythmSubdivision=Math.Clamp(speed,1,2);
        else if (words[1] == "sound" && words.Length==3 && words[2] is "on" or "off") config.RhythmSound=words[2]=="on";
        else if (words[1] is "next" or "previous") weave.Hint = "Type any spell · no selection needed";
        else { weave.Hint = "rhythm on|off|keyboard|piano|tap|tempo BPM"; return true; }
        pi.SavePluginConfig(config); return true;
    }
    // Full phrases first, then each card's id, aliases and grimoire expansions
    // ("sc" → Summon Carbuncle), so long multiword spells have a short rhythm word.
    // A shortcut never shadows another card's full phrase.
    private RhythmRound.Spell[] RhythmDeck()
    {
        var usable = cards.Where(c => c.Phrase.Length is > 0 and <= 64).ToArray();
        var words = usable.Select(c => new RhythmRound.Spell(c.Id, Normalize(c.Phrase), c.Name, c.Phrase)).ToList();
        var taken = words.Select(w => w.Phrase).ToHashSet();
        void Add(string word, Card card)
        {
            word = Normalize(word);
            if (word.Length is > 0 and <= 64 && taken.Add(word)) words.Add(new(card.Id, word, card.Name, card.Phrase));
        }
        foreach (var card in usable) { Add(card.Id, card); foreach (var alias in card.Aliases ?? []) Add(alias, card); }
        foreach (var shortcut in expansions.Keys.Order(StringComparer.Ordinal))
            if (ResolveRune(shortcut) is { } rune && usable.FirstOrDefault(c => c.Id == rune.CardId) is { } card) Add(shortcut, card);
        return RhythmTargetPhrases.Expand(words);
    }
    private void BeginRhythm()
    {
        if (disposed) return;
        rhythmShown=true;
        var deck = RhythmDeck();
        if (deck.Length == 0) { rhythmStartPending=true; weave.Hint = "Rhythm is waiting for the Lua spell deck"; return; }
        rhythmStartPending=false;
        if (weave.Runes.Count >= SpellWeave.Capacity) { weave.Hint = "Weave full · cast or remove a rune first"; return; }
        if (weave.Draft.Length > 0) { weave.Hint = "Finish or save your current draft before a rhythm round"; return; }
        if (weave.InFlight != null || castPlayback.Request != null) { weave.Hint = "Finish the current cast before starting a rhythm round"; return; }
        InterruptWeave("Rhythm composing", false);
        weave.EnterInput();
        rhythm.LatencyMs = config.RhythmLatencyMs;
        config.RhythmController = false;
        var times=MusicTimes(); rhythmSongChart=times!=null;
        var first=times?[0] ?? rhythmClock.NextBeat(RhythmNow+1.2);
        if (rhythm.State == RhythmRound.Phase.Paused) rhythm.Resume(first,times);
        else {
            rhythm.Start(deck, first, rhythmClock.Period/config.RhythmSubdivision,times);
            rhythmQueued=false;
        }
        rhythmShown=true; composer.Active=false; barVisible=true;
    }
    private void CreateRhythmHud()
    {
        rhythmHud=new NativeRhythmHud {
            Toggle=()=>{ if (rhythm.Active) { SuspendRhythm();InterruptWeave("Rhythm paused",true); } else BeginRhythm(); },
            Cast=()=>StartPlayback(),
            Delete=DeleteRhythmSpell,
            Reset=()=>rhythm.Restart(RhythmNow),
            Tap=()=>{ config.RhythmUsePiano=false;rhythmClock.Tap(RhythmNow);pi.SavePluginConfig(config); },
            Source=()=>{ config.RhythmUsePiano=!config.RhythmUsePiano;pi.SavePluginConfig(config); },
        };
        hudController!.AddNode(rhythmHud);
    }
    private void RenderRhythmHud()
    {
        if (rhythmHud==null) return;
        rhythmHud.IsVisible=config.RhythmEnabled && rhythmShown && barVisible && objects.LocalPlayer!=null && !gameGui.GameUiHidden;
        if (!rhythmHud.IsVisible) return;
        rhythmHud.Render(rhythm,rhythmMusic,rhythmClock.Bpm,
            hud!.SpellEntryPosition,hud.Size.X,config.RhythmUsePiano);
    }
    private void SuspendRhythm()
    {
        if (config.RhythmEnabled && (rhythm.Active || rhythm.Completed)) {
            weave.EnterControl();keyboard.Capture=false;
        }
        rhythm.Pause(RhythmNow); rhythmAvailable = false;rhythmStartPending=false;
    }
    private void UpdateRhythm(bool eligible)
    {
        rhythmAvailable = eligible && config.RhythmEnabled;
        if (!rhythmAvailable) { SuspendRhythm(); return; }
        if (rhythmStartPending && cards.Length>0) BeginRhythm();
        var now = RhythmNow;
        if (config.RhythmUsePiano && Environment.TickCount64-timelinePoll>=250) {
            timelinePoll=Environment.TickCount64;
            try {
                var json=pi.GetIpcSubscriber<double,string>("XivPiano.RhythmTimeline.v1").InvokeFunc(30);
                if (json.Length<=32768) {
                    using var doc=JsonDocument.Parse(json);var x=doc.RootElement;
                    if (x.GetProperty("version").GetInt32()==1) {
                        var stream=x.GetProperty("streamId").GetInt64();
                        var playing=x.GetProperty("playing").GetBoolean();
                        var position=x.GetProperty("positionSeconds").GetDouble();
                        if (songStream!=0 && (songStream!=stream || !playing) && rhythm.Active) SuspendRhythm();
                        if (songStream==stream && songPlaying && playing && Math.Abs(position-(songPosition+Math.Max(0,now-songSampleAt)))>.75 && rhythm.Active)
                            SuspendRhythm();
                        songStream=stream;songPlaying=playing;songReady=x.GetProperty("ready").GetBoolean();
                        songPosition=position;songSampleAt=now;
                        var pulses=x.GetProperty("pulses");
                        if (pulses.GetArrayLength()<=128)
                            futurePulses=pulses.EnumerateArray().Select(p=>new FuturePulse(p.GetProperty("seconds").GetDouble(),p.GetProperty("strength").GetSingle()))
                                .Where(p=>double.IsFinite(p.Seconds)&&float.IsFinite(p.Strength)).OrderBy(p=>p.Seconds).ToArray();
                    }
                }
            } catch { songReady=false;futurePulses=[];if (rhythmSongChart && rhythm.Active) SuspendRhythm(); }
        }
        if (config.RhythmUsePiano && Environment.TickCount64 - rhythmPoll >= 40) {
            rhythmPoll = Environment.TickCount64;
            try {
                var json = pi.GetIpcSubscriber<string>("XivPiano.AudioFeatures.v1").InvokeFunc();
                // Bound an optional third-party IPC response before parsing it.
                if (json.Length <= 16384) {
                    using var doc = JsonDocument.Parse(json);
                    var x = doc.RootElement;
                    if (x.GetProperty("version").GetInt32() == 1)
                        rhythmClock.Observe(x.GetProperty("streamId").GetInt64(), x.GetProperty("sequence").GetInt64(),
                            x.GetProperty("playing").GetBoolean(), x.GetProperty("fresh").GetBoolean(), x.GetProperty("ageSeconds").GetDouble(),
                            x.GetProperty("onset").GetSingle(), x.GetProperty("rms").GetSingle(), now);
                    if (x.TryGetProperty("spectrum",out var spectrum) && spectrum.ValueKind == JsonValueKind.Object &&
                        spectrum.TryGetProperty("bands", out var bands) && bands.ValueKind == JsonValueKind.Array && bands.GetArrayLength() == 32) {
                        var i = 0;
                        foreach (var band in bands.EnumerateArray()) {
                            var value = band.GetSingle(); rhythmSpectrum[i++] = float.IsFinite(value) ? Math.Clamp(value * 5,0,1) : 0;
                        }
                    }
                }
            } catch { /* Piano is optional; never start, pause or change its volume. */ }
            rhythmMusic = rhythmSongChart && songReady ? "Piano · future song chart" : rhythmClock.MusicFresh(now) ? rhythmClock.Source+" · tempo guide" : "Piano unavailable / paused · tempo guide";
        } else if (!config.RhythmUsePiano) rhythmMusic = rhythmClock.Source;
        if (!rhythmSongChart && rhythm.Active && rhythm.Prefix.Length==0 && MusicTimes() is { } readyTimes) {
            rhythm.Align(readyTimes[0],readyTimes);rhythmSongChart=true;
        }
        rhythm.LatencyMs = config.RhythmLatencyMs;
    }
    private void TickRhythm()
    {
        if (!config.RhythmEnabled || !rhythmAvailable) return;
        rhythm.Tick(RhythmNow);
        QueueRhythmSpell();
        if (rhythm.Active && rhythm.Cursor>=rhythm.Notes.Length) {
            var next=MusicTimes();rhythm.Align(next?[0] ?? rhythmClock.NextBeat(RhythmNow+.5),next);
            rhythmSongChart=next!=null;
        }
        else if (rhythm.Active && rhythm.Notes.Length-rhythm.Cursor<12) {
            var times=MusicTimes(64,.25);
            rhythm.Extend(times);
            if (times==null) rhythmSongChart=false;
        }
    }
    private void QueueRhythmSpell()
    {
        if (!rhythm.Completed || rhythm.Target is not { } spell) return;
        if (!weave.Add(spell.Command ?? spell.Phrase,spell.Id)) { SuspendRhythm(); return; }
        rhythmQueued=true;rhythm.TakeCompleted(RhythmNow);
        CancelWeaveTicket(weave.Interrupt("Spell queued · keep spelling, or > cast + move",false));
        if (weave.Runes.Count>=SpellWeave.Capacity) {
            SuspendRhythm();rhythm.Notice("WEAVE FULL · Backspace removes a spell · > casts",RhythmNow);
        }
    }
    private void DeleteRhythmSpell()
    {
        if (weave.Runes.Count==0) { rhythm.Notice("QUEUE IS ALREADY EMPTY",RhythmNow);return; }
        CancelWeaveTicket(weave.Backspace());
        rhythm.Notice("REMOVED LAST QUEUED SPELL",RhythmNow);
        StopFollowing("Spell removed");
    }
    private bool RhythmKeyboard(SpellKeyboard.Input input)
    {
        if (!config.RhythmEnabled) return false;
        if (input.Type == SpellKeyboard.Kind.Input) { BeginRhythm();return true; }
        if (!rhythmShown) return false;
        if (input.Type is SpellKeyboard.Kind.Escape or SpellKeyboard.Kind.Movement) { SuspendRhythm(); return false; }
        if (input.Type == SpellKeyboard.Kind.Backspace) {
            if (rhythm.Prefix.Length>0) rhythm.Restart(RhythmNow);
            else DeleteRhythmSpell();
            return true;
        }
        if (input.Type == SpellKeyboard.Kind.ClearLine) {
            rhythm.Restart(RhythmNow);CancelWeaveTicket(weave.ClearLine());StopFollowing("Weave cleared");
            if (rhythm.Active) weave.EnterInput();
            rhythm.Notice("ALL QUEUED SPELLS CLEARED",RhythmNow);return true;
        }
        if (input.Type==SpellKeyboard.Kind.TextBackspace) return true;
        if (!rhythm.Active) return false;
        var at=input.At/1000d;
        if (input.Type==SpellKeyboard.Kind.Character) {
            if (input.Character is '.' or '>') { SuspendRhythm();StartPlayback(input.Character=='.');return true; }
            var grade=rhythm.Press(input.Character,at);
            if (config.RhythmSound && grade is RhythmRound.Grade.Perfect or RhythmRound.Grade.Great or RhythmRound.Grade.Good)
                rhythmSound.Play(rhythm.Prefix.Length%4,config.RhythmVolume);
            QueueRhythmSpell();return true;
        }
        if (input.Type==SpellKeyboard.Kind.Commit) { rhythm.Commit(at);QueueRhythmSpell();return true; }
        if (input.Type==SpellKeyboard.Kind.Complete) {
            rhythm.Notice("Type tank physick, party2 physick or any spell · Enter queues an exact shorter name",RhythmNow);return true;
        }
        return false;
    }
}
