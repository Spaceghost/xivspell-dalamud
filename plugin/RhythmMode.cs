using System.Text.Json;
using FFXIVClientStructs.FFXIV.Client.System.Input;

namespace XivSpell;

public sealed partial class Plugin
{
    private readonly RhythmClock rhythmClock = new();
    private readonly RhythmRound rhythm = new();
    private NativeRhythmHud? rhythmHud;
    private bool rhythmShown;
    private bool rhythmSongChart;
    private const double RhythmApproach = 8;
    private bool rhythmQueued, rhythmAvailable, rhythmPadReleased = true;
    private bool RhythmPadOwned => !rhythmPadReleased && config.RhythmEnabled && config.RhythmController && rhythm.State is RhythmRound.Phase.Playing or RhythmRound.Phase.Ready;
    private long rhythmPoll;
    private readonly float[] rhythmSpectrum = new float[32];
    private int rhythmCard;
    private string rhythmMusic = "Tempo guide · start Piano or tap along with game music";
    private static double RhythmNow => Environment.TickCount64 / 1000d;
    private readonly RhythmSound rhythmSound = new();
    private sealed record FuturePulse(double Seconds,float Strength);
    private FuturePulse[] futurePulses = [];
    private double songPosition, songSampleAt;
    private long songStream, timelinePoll;
    private bool songReady, songPlaying;
    private double[]? MusicTimes(int count,double lead=RhythmApproach)
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
        return null;
    }

    private bool RhythmCommand(string args)
    {
        if (!args.StartsWith("rhythm", StringComparison.OrdinalIgnoreCase)) return false;
        var words = args.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (words.Length == 1 || words[1] == "on") {
            config.RhythmEnabled = true; barVisible = true; BeginRhythm();
        } else if (words[1] == "off") {
            config.RhythmEnabled = false; rhythm.Stop(); composer.Active = false;
            InterruptWeave("Rhythm off", true);
        } else if (words[1] == "tap") rhythmClock.Tap(RhythmNow);
        else if (words[1] == "tempo" && words.Length == 3 && double.TryParse(words[2], System.Globalization.NumberStyles.Float,
            System.Globalization.CultureInfo.InvariantCulture, out var bpm) && double.IsFinite(bpm)) {
            config.RhythmBpm = (float)Math.Clamp(bpm, 50, 220); config.RhythmUsePiano = false;
            rhythmClock.SetTempo(config.RhythmBpm, RhythmNow);
        } else if (words[1] is "pad" or "keyboard") config.RhythmController = words[1] == "pad";
        else if (words[1] == "piano") config.RhythmUsePiano = true;
        else if (words[1] == "offset" && words.Length==3 && float.TryParse(words[2],out var offset) && float.IsFinite(offset))
            config.RhythmLatencyMs=Math.Clamp(offset,-250,250);
        else if (words[1] == "volume" && words.Length==3 && float.TryParse(words[2],out var volume) && float.IsFinite(volume))
            config.RhythmVolume=Math.Clamp(volume,0,.3f);
        else if (words[1] == "speed" && words.Length==3 && int.TryParse(words[2],out var speed)) config.RhythmSubdivision=Math.Clamp(speed,1,2);
        else if (words[1] == "sound" && words.Length==3 && words[2] is "on" or "off") config.RhythmSound=words[2]=="on";
        else if (words[1] == "next") ChangeRhythmSpell(1);
        else if (words[1] == "previous") ChangeRhythmSpell(-1);
        else { weave.Hint = "rhythm on|off|pad|keyboard|piano|tap|tempo BPM"; return true; }
        pi.SavePluginConfig(config); return true;
    }
    private RhythmRound.Spell[] RhythmDeck() => cards.Where(c => c.Phrase.Length is > 0 and <= 64)
        .Select(c => new RhythmRound.Spell(c.Id, c.Phrase, c.Name)).ToArray();
    private void BeginRhythm()
    {
        var deck = RhythmDeck();
        if (deck.Length == 0) { weave.Hint = "Rhythm needs a connected Lua spell deck"; return; }
        if (weave.Runes.Count >= SpellWeave.Capacity) { weave.Hint = "Weave full · cast or remove a rune first"; return; }
        if (weave.Draft.Length > 0) { weave.Hint = "Finish or save your current draft before a rhythm round"; return; }
        if (weave.InFlight != null || castPlayback.Request != null) { weave.Hint = "Finish the current cast before starting a rhythm round"; return; }
        InterruptWeave("Rhythm composing", false);
        weave.EnterInput();
        rhythm.LatencyMs = config.RhythmLatencyMs;
        if (rhythm.State == RhythmRound.Phase.Paused) {
            var times=MusicTimes(rhythm.Notes.Length-rhythm.Cursor);rhythmSongChart=times!=null;
            if (times!=null) rhythm.Resume(times);
            else rhythm.Resume(rhythmClock.NextBeat(RhythmNow+RhythmApproach));
        }
        else {
            var selected=deck[Math.Clamp(rhythmCard,0,deck.Length-1)];var times=MusicTimes(selected.Phrase.Length);rhythmSongChart=times!=null;
            rhythm.Start(selected, deck,
                rhythmClock.NextBeat(RhythmNow+RhythmApproach), rhythmClock.Period / config.RhythmSubdivision,
                times);
            rhythmQueued = false;
        }
        rhythmShown=true; rhythmPadReleased = false; composer.Active = false; barVisible = true;
    }
    private void ChangeRhythmSpell(int direction)
    {
        var deck=RhythmDeck();if (deck.Length==0) return;
        rhythmCard=(rhythmCard+direction+deck.Length)%deck.Length;rhythm.Stop();BeginRhythm();
    }
    private void CreateRhythmHud()
    {
        rhythmHud=new NativeRhythmHud {
            SelectSpell=ChangeRhythmSpell,
            Toggle=()=>{ if (rhythm.Active) { SuspendRhythm();InterruptWeave("Rhythm paused",true); } else BeginRhythm(); },
            Cast=()=>StartPlayback(),
            ChangeMode=()=>{ config.RhythmController=!config.RhythmController;SuspendRhythm();pi.SavePluginConfig(config);BeginRhythm(); },
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
        var deck=RhythmDeck();
        rhythmHud.Render(rhythm,config.RhythmController,deck.Length>0 ? deck[Math.Clamp(rhythmCard,0,deck.Length-1)].Name : "Connect your Lua deck",
            rhythmMusic,rhythmClock.Bpm,weave.Runes.Count,RhythmApproach,rhythmClock.Energy,config.RhythmUsePiano);
    }
    private void SuspendRhythm()
    {
        rhythm.Pause(RhythmNow); rhythmAvailable = false; rhythmPadReleased = true;
    }
    private void UpdateRhythm(bool eligible)
    {
        rhythmAvailable = eligible && config.RhythmEnabled;
        if (!rhythmAvailable) { SuspendRhythm(); return; }
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
        rhythm.LatencyMs = config.RhythmLatencyMs;
    }
    private void TickRhythm()
    {
        if (!config.RhythmEnabled || !rhythmAvailable) return;
        var misses=rhythm.Misses;rhythm.Tick(RhythmNow);
        if (rhythm.Misses>misses && MusicTimes(rhythm.Notes.Length-rhythm.Cursor,.5) is { } retry) rhythm.Rechart(retry);
        if (rhythm.Completed && !rhythmQueued && rhythm.Target is { } spell) {
            rhythmQueued = true;
            if (weave.Add(spell.Phrase, spell.Id)) {
                CancelWeaveTicket(weave.Interrupt("Rhythm woven · > cast and move · i weave another", false));
                weave.EnterControl(); composer.Active = false; keyboard.Capture = false;
            }
        }
    }
    private bool RhythmKeyboard(SpellKeyboard.Input input)
    {
        if (!config.RhythmEnabled) return false;
        if (input.Type is SpellKeyboard.Kind.Escape or SpellKeyboard.Kind.Movement) { SuspendRhythm(); return false; }
        if (input.Type == SpellKeyboard.Kind.Input) { BeginRhythm(); return true; }
        if (!rhythm.Active) return false;
        var at = input.At / 1000d;
        if (input.Type == SpellKeyboard.Kind.Character) {
            if (input.Character is '.' or '>') { SuspendRhythm(); StartPlayback(input.Character == '.'); return true; }
            if (!config.RhythmController) RhythmFeedback(rhythm.Press(input.Character, at));
            return true;
        }
        if (input.Type is SpellKeyboard.Kind.Commit or SpellKeyboard.Kind.Complete or SpellKeyboard.Kind.Backspace or SpellKeyboard.Kind.ClearLine or SpellKeyboard.Kind.TextBackspace)
            return true;
        return false;
    }
    private void RhythmFeedback(RhythmRound.Grade grade)
    {
        if (config.RhythmSound && grade is RhythmRound.Grade.Perfect or RhythmRound.Grade.Great or RhythmRound.Grade.Good)
            rhythmSound.Play(rhythm.Notes[Math.Max(0, rhythm.Cursor - 1)].Lane%4, config.RhythmVolume);
    }
    private bool RhythmController(uint pressed, long inputTime)
    {
        if (!RhythmPadOwned) return false;
        if ((pressed & (32768u | 16384u)) != 0) { SuspendRhythm(); StartPlayback((pressed & 16384) != 0); return true; }
        if ((pressed & (uint)(GamepadButtonsFlags.L1|GamepadButtonsFlags.R1)) != 0) {
            ChangeRhythmSpell((pressed & (uint)GamepadButtonsFlags.L1)!=0 ? -1 : 1);
            return true;
        }
        if (!rhythm.Active) return true;
        var face = pressed & 255;
        if (face != 0 && (face & (face - 1)) == 0) {
            var lane = face switch { 4 => 0, 1 => 1, 2 => 2, 8 => 3, 16 => 4, 128 => 5, 32 => 6, 64 => 7, _ => -1 };
            var at = inputTime > 0 ? inputTime / 1000d : RhythmNow;
            RhythmFeedback(rhythm.PressLane(lane, at));
        }
        return true;
    }
}
