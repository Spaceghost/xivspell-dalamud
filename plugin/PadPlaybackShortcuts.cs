namespace XivSpell;

public enum PadPlaybackCommand { None, Repeat, Continue }
public readonly record struct PadPlaybackShortcut(PadPlaybackCommand Command, bool ConsumeCross, bool ConsumeCircle);

// Playback shortcuts never own the sticks or the rest of the controller.
// A new focus needs neutral shortcut buttons, and a captured face press stays
// captured through release even if R2 or Grimoire's focus is released first.
public sealed class PadPlaybackShortcuts
{
    private bool ready, crossWasDown, circleWasDown, ownCross, ownCircle;

    public PadPlaybackShortcut Poll(bool eligible, bool r2, bool cross, bool circle)
    {
        var command = PadPlaybackCommand.None;
        if (!eligible) ready = false;
        else if (!r2 && !cross && !circle) ready = true;

        if (eligible && ready && r2)
        {
            ownCross |= cross;
            ownCircle |= circle;
            // Both face buttons together are ambiguous: consume them without
            // starting either action, including when one is released first.
            if (cross && !circle && !crossWasDown) command = PadPlaybackCommand.Repeat;
            if (circle && !cross && !circleWasDown) command = PadPlaybackCommand.Continue;
        }

        var result = new PadPlaybackShortcut(command, ownCross, ownCircle);
        ownCross &= cross; ownCircle &= circle;
        crossWasDown = cross; circleWasDown = circle;
        return result;
    }

    public void Suspend() => ready = false;
    public void Reset() => ready = crossWasDown = circleWasDown = ownCross = ownCircle = false;
}
