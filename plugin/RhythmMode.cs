using System.Numerics;
using System.Text.Json;
using Dalamud.Bindings.ImGui;

namespace XivSpell;

public sealed partial class Plugin
{
    private readonly RhythmClock rhythmClock = new();
    private readonly RhythmRound rhythm = new();
    private bool rhythmQueued, rhythmAvailable, rhythmPadReleased = true;
    private bool RhythmPadOwned => !rhythmPadReleased && config.RhythmEnabled && config.RhythmController && rhythm.State is RhythmRound.Phase.Playing or RhythmRound.Phase.Ready;
    private long rhythmPoll;
    private readonly float[] rhythmSpectrum = new float[32];
    private int rhythmCard;
    private string rhythmMusic = "Tempo guide · start Piano or tap along with game music";
    private static double RhythmNow => Environment.TickCount64 / 1000d;
    private static readonly Vector4[] RhythmColors = [new(.96f,.36f,.72f,1), new(.47f,.93f,.56f,1), new(.27f,.76f,1,1), new(1,.59f,.32f,1)];
    private static readonly string[] RhythmButtons = ["Square / X", "Triangle / Y", "Cross / A", "Circle / B"];
    private readonly RhythmSound rhythmSound = new();

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
        if (rhythm.State == RhythmRound.Phase.Paused) rhythm.Resume(rhythmClock.NextBeat(RhythmNow) + rhythmClock.Period * 3);
        else {
            rhythm.Start(deck[Math.Clamp(rhythmCard, 0, deck.Length - 1)], deck,
                rhythmClock.NextBeat(RhythmNow) + rhythmClock.Period * 3, rhythmClock.Period / config.RhythmSubdivision);
            rhythmQueued = false;
        }
        rhythmPadReleased = false; composer.Active = false; barVisible = true;
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
            rhythmMusic = rhythmClock.MusicFresh(now) ? rhythmClock.Source : "Piano unavailable / paused · tempo guide";
        } else if (!config.RhythmUsePiano) rhythmMusic = rhythmClock.Source;
        rhythm.LatencyMs = config.RhythmLatencyMs;
    }
    private void TickRhythm()
    {
        if (!config.RhythmEnabled || !rhythmAvailable) return;
        rhythm.Tick(RhythmNow);
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
            rhythmSound.Play(rhythm.Notes[Math.Max(0, rhythm.Cursor - 1)].Lane, config.RhythmVolume);
    }
    private bool RhythmController(uint pressed, long inputTime)
    {
        if (!RhythmPadOwned) return false;
        if ((pressed & (32768u | 16384u)) != 0) { SuspendRhythm(); StartPlayback((pressed & 16384) != 0); return true; }
        if ((pressed & (4u | 8u)) != 0) {
            var deck = RhythmDeck();
            if (deck.Length > 0) {
                rhythmCard = (rhythmCard + ((pressed & 4) != 0 ? deck.Length - 1 : 1)) % deck.Length;
                rhythm.Stop(); BeginRhythm();
            }
            return true;
        }
        if (!rhythm.Active) return true;
        var face = pressed & 240;
        if (face != 0 && (face & (face - 1)) == 0) {
            var lane = face switch { 16 => 0, 128 => 1, 32 => 2, 64 => 3, _ => -1 };
            var at = inputTime > 0 ? inputTime / 1000d : RhythmNow;
            RhythmFeedback(rhythm.PressLane(lane, at));
        }
        return true;
    }
    private void DrawRhythm()
    {
        if (!config.RhythmEnabled || !barVisible || gameGui.GameUiHidden) return;
        ImGui.SetNextWindowSize(new Vector2(560, 570), ImGuiCond.FirstUseEver);
        ImGui.SetNextWindowSizeConstraints(new Vector2(440, 440), new Vector2(900, 900));
        if (!ImGui.Begin("GRIMOIRE / RHYTHM###XivSpellRhythm", ImGuiWindowFlags.NoNavInputs)) { ImGui.End(); return; }
        ImGui.TextColored(new Vector4(.6f,.88f,1,1), "SPELLSTRINGS");
        ImGui.SameLine(); ImGui.TextDisabled($"{rhythmMusic} · {rhythmClock.Bpm:F0} BPM");
        var padMode = config.RhythmController;
        if (ImGui.Checkbox("Controller", ref padMode)) { config.RhythmController = padMode; SuspendRhythm(); pi.SavePluginConfig(config); }
        ImGui.SameLine();
        var usePiano = config.RhythmUsePiano;
        if (ImGui.Checkbox("Follow Piano", ref usePiano)) { config.RhythmUsePiano = usePiano; pi.SavePluginConfig(config); }
        ImGui.SameLine();
        if (ImGui.Button("Tap beat")) { config.RhythmUsePiano = false; rhythmClock.Tap(RhythmNow); }
        var deck = RhythmDeck();
        if (deck.Length > 0) {
            ImGui.BeginDisabled(rhythm.Active);
            if (ImGui.ArrowButton("previous-spell", ImGuiDir.Left)) { rhythm.Stop(); rhythmCard = (rhythmCard + deck.Length - 1) % deck.Length; }
            ImGui.SameLine(); ImGui.TextUnformatted(deck[Math.Clamp(rhythmCard,0,deck.Length-1)].Name); ImGui.SameLine();
            if (ImGui.ArrowButton("next-spell", ImGuiDir.Right)) { rhythm.Stop(); rhythmCard = (rhythmCard + 1) % deck.Length; }
            ImGui.EndDisabled();
            ImGui.SameLine();
            if (rhythm.Active) { if (ImGui.Button("Pause")) { SuspendRhythm(); InterruptWeave("Rhythm paused", true); } }
            else if (ImGui.Button(rhythm.State == RhythmRound.Phase.Paused ? "Resume" : "Weave")) BeginRhythm();
            ImGui.SameLine(); if (ImGui.Button("Cast + move  >")) { SuspendRhythm(); StartPlayback(); }
        }
        ImGui.TextUnformatted($"{rhythm.Score:N0}   {rhythm.Combo}x COMBO   BEST {rhythm.BestCombo}   {rhythm.Stars}/5 STARS");
        ImGui.SameLine(); ImGui.TextDisabled($"{rhythm.Accuracy:P0}  ·  {weave.Runes.Count} runes queued");
        ImGui.TextColored(new Vector4(.94f,.89f,.65f,1), rhythm.Target == null ? "Choose a spell, then weave to the music." : rhythm.Target.Phrase.ToUpperInvariant());
        var origin = ImGui.GetCursorScreenPos();
        var size = new Vector2(ImGui.GetContentRegionAvail().X, Math.Max(160, ImGui.GetContentRegionAvail().Y - 112));
        var draw = ImGui.GetWindowDrawList();
        static uint Color(Vector4 c) => ImGui.ColorConvertFloat4ToU32(c);
        draw.AddRectFilled(origin, origin + size, Color(new(.025f,.035f,.075f,.96f)), 12);
        var laneWidth = size.X / 4;
        var hitY = origin.Y + size.Y - 44;
        var now = rhythm.State == RhythmRound.Phase.Paused ? rhythm.PausedAt : RhythmNow;
        var preview = rhythmClock.Period * 4;
        if (rhythmClock.MusicFresh(RhythmNow)) for (var band = 0; band < rhythmSpectrum.Length; band++) {
            var width = size.X / rhythmSpectrum.Length;
            var left = origin.X + band * width;
            draw.AddRectFilled(new(left,origin.Y + size.Y),new(left + width - 2,origin.Y + size.Y - rhythmSpectrum[band] * size.Y * .5f),
                Color(RhythmColors[band / 8] with { W = .10f }));
        }
        for (var lane = 0; lane < 4; lane++) {
            var x = origin.X + laneWidth * lane;
            draw.AddLine(new(x, origin.Y + 8), new(x, origin.Y + size.Y - 4), Color(new(.3f,.36f,.5f,.3f)));
            var c = RhythmColors[lane];
            draw.AddRectFilled(new(x + 5, hitY - 10), new(x + laneWidth - 5, hitY + 10), Color(c with { W = .15f + rhythmClock.Energy * .15f }), 5);
            draw.AddLine(new(x + 5,hitY), new(x + laneWidth - 5,hitY), Color(c), 3);
            var choice = rhythm.Cursor < rhythm.Notes.Length ? rhythm.Notes[rhythm.Cursor].Choices[lane] : '\0';
            var text = choice == ' ' ? "SPACE" : choice == 0 ? "" : char.ToUpperInvariant(choice).ToString();
            draw.AddText(new(x + 14, hitY + 14), Color(c), text);
        }
        for (var i = rhythm.Cursor; i < rhythm.Notes.Length; i++) {
            var note = rhythm.Notes[i];
            var remaining = note.Due - now;
            if (remaining > preview || remaining < -.4) continue;
            var y = hitY - (float)(remaining / preview) * (size.Y - 60);
            var x = origin.X + note.Lane * laneWidth;
            var c = RhythmColors[note.Lane];
            draw.AddRectFilled(new(x + 8,y - 15), new(x + laneWidth - 8,y + 15), Color(c with { W = .9f }), 8);
            var text = note.Letter == ' ' ? "SPACE" : char.ToUpperInvariant(note.Letter).ToString();
            var fontSize = ImGui.GetFontSize() * 1.5f;
            draw.AddText(ImGui.GetFont(), fontSize, new(x + laneWidth / 2 - ImGui.CalcTextSize(text).X * .75f,y - fontSize / 2), Color(new(.025f,.04f,.08f,1)), text);
        }
        if (now - rhythm.LastFeedback < .7) {
            var good = rhythm.LastGrade is RhythmRound.Grade.Perfect or RhythmRound.Grade.Great or RhythmRound.Grade.Good;
            var text = rhythm.LastGrade.ToString().ToUpperInvariant() + (good ? $"  {rhythm.LastErrorMs:+0;-0;0}ms" : " · keep your letter");
            draw.AddText(origin + new Vector2(18,14), Color(good ? new(.5f,1,.8f,1) : new(1,.63f,.5f,1)), text);
        }
        if (rhythm.Active && rhythm.Cursor == 0 && rhythm.Notes.Length > 0 && rhythm.Notes[0].Due - now > rhythmClock.Period) {
            var count = Math.Ceiling((rhythm.Notes[0].Due - now) / rhythmClock.Period);
            draw.AddText(origin + new Vector2(size.X / 2 - 28, size.Y / 2), Color(new(1,1,1,1)), $"IN {count:0}");
        }
        ImGui.Dummy(size);
        if (config.RhythmController) {
            for (var lane = 0; lane < 4; lane++) {
                if (lane > 0) ImGui.SameLine();
                ImGui.TextColored(RhythmColors[lane], RhythmButtons[lane]);
            }
            ImGui.TextDisabled("D-pad Left/Right: spell · R3: cast + move · both sticks: weave / pause");
        } else ImGui.TextDisabled("Type each letter as it crosses the line. Space is a note too.");
        ImGui.TextWrapped(rhythm.State == RhythmRound.Phase.Ready ? "WOVEN! > casts while you move · i weaves another · Escape keeps your queue." :
            rhythm.State == RhythmRound.Phase.Paused ? "PAUSED · Resume keeps your place. Escape returns movement." :
            "Esc pauses and releases movement. > casts the prepared runes. No rhythm hit casts a spell.");
        if (ImGui.TreeNode("Timing + sound")) {
            if (ImGui.SliderFloat("Input offset (ms)", ref config.RhythmLatencyMs, -250, 250)) pi.SavePluginConfig(config);
            if (ImGui.SliderFloat("Guide BPM", ref config.RhythmBpm, 50, 220)) { rhythmClock.SetTempo(config.RhythmBpm, now); pi.SavePluginConfig(config); }
            if (ImGui.Checkbox("Plucked hit sounds", ref config.RhythmSound)) pi.SavePluginConfig(config);
            if (ImGui.SliderFloat("Hit volume", ref config.RhythmVolume, 0, .3f)) pi.SavePluginConfig(config);
            ImGui.TextDisabled("Positive offset compensates late audio/display. Tempo changes apply next round.");
            ImGui.TreePop();
        }
        ImGui.End();
    }
}
