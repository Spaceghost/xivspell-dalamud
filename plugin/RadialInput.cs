namespace XivSpell;

public sealed partial class Plugin
{
    private readonly RadialSpeller radial = new();
    private NativeRadialHud? radialHud;

    private void ToggleRadial()
    {
        if (radial.Active) { SuspendRhythm(); radial.Close(); InterruptWeave("Radial spelling paused", true); return; }
        CloseWeaveTargets(false);
        if (config.RhythmEnabled) {
            BeginRhythm();
            if (!rhythm.Active) return;
            config.RhythmController = true;
        } else {
            InterruptWeave("Radial spelling", false);
            weave.EnterInput();
        }
        composer.Active = false; barVisible = true; keyboard.Capture = true;
        radial.Open();
    }

    private void ReadRadial(GrimoirePadFrame? frame)
    {
        if (frame is not { } sample) return;
        var input = radial.Read(sample);
        if (input.Action == RadialAction.None) return;
        var kind = input.Action switch {
            RadialAction.Backspace => SpellKeyboard.Kind.Backspace,
            RadialAction.Commit => SpellKeyboard.Kind.Commit,
            RadialAction.Close => SpellKeyboard.Kind.Escape,
            _ => SpellKeyboard.Kind.Character,
        };
        // Empty Enter is playback in ordinary weaving; this button only
        // disambiguates a typed spell. Playback keeps its explicit R2 chords.
        if (input.Action == RadialAction.Commit && !config.RhythmEnabled && weave.Draft.Length == 0) return;
        keyboard.Events.Enqueue(new(kind, input.Character) { At = input.At > 0 ? input.At : Environment.TickCount64 });
        ReadWeaveKeyboard(); // Grade before TickRhythm, with the button timestamp.
    }

    private void RenderRadialHud()
    {
        if (radialHud == null) return;
        radialHud.IsVisible = radial.Active && hud?.IsVisible == true;
        if (radialHud.IsVisible) radialHud.Render(radial, hud!.SpellEntryPosition, hud.Size.X);
    }
}
