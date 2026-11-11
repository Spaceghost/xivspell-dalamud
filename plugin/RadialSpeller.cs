namespace XivSpell;

internal enum RadialAction { None, Character, Backspace, Commit, Close }
internal readonly record struct RadialInput(RadialAction Action, char Character = '\0', long At = 0);

// Steam Input maps the two trackpads to the two stick axes. Hovering only
// selects; a fresh trigger/pad press supplies the rhythm timestamp.
internal sealed class RadialSpeller
{
    internal static readonly string[] Groups = ["abcd", "efgh", "ijkl", "mnop", "qrst", "uvwx", "yz -", "1234567890"];
    internal bool Active { get; private set; }
    internal bool Ready { get; private set; }
    internal int Group { get; private set; }
    internal int Letter { get; private set; } = -1;
    internal string Characters => Groups[Group];
    internal char? Hovered => Letter >= 0 ? Characters[Letter] : null;
    private ulong session, sequence;
    internal void Open() { Active = true; Ready = false; Group = 0; Letter = -1; session = sequence = 0; }
    internal void Close() { Active = Ready = false; Letter = -1; session = sequence = 0; }

    internal static int Sector(float x, float y, int count, int previous = -1)
    {
        if (!float.IsFinite(x) || !float.IsFinite(y) || Math.Abs(x) > 1 || Math.Abs(y) > 1 || count <= 0 || x*x + y*y < .09f) return -1;
        var angle = Math.Atan2(x, -y); // North, clockwise; the pad lease normalizes Y.
        if (angle < 0) angle += Math.Tau;
        var step = Math.Tau / count;
        if (previous >= 0 && previous < count) {
            var distance = Math.Abs(Math.IEEERemainder(angle - previous * step, Math.Tau));
            if (distance <= step / 2 + .07) return previous;
        }
        return (int)Math.Floor(angle / step + .5) % count;
    }

    internal RadialInput Read(GrimoirePadFrame frame)
    {
        if (!Active) return default;
        if (frame.Phase != "Active") { Ready = false; Letter = -1; session = sequence = 0; return default; }
        Ready = true;
        if (frame.Session != session) { session = frame.Session; sequence = 0; Letter = -1; }
        if (frame.Sequence == 0 || frame.Sequence <= sequence) return default;
        sequence = frame.Sequence;
        var priorGroup = Group;
        var group = Sector(frame.LeftX, frame.LeftY, Groups.Length, Group);
        if (group >= 0 && group != Group) { Group = group; Letter = -1; }
        Letter = Sector(frame.RightX, frame.RightY, Characters.Length, Letter);
        var at = frame.InputTime;
        // Playback's R2+A / R2+B belongs to the shared shortcut handler.
        // R2 is never a letter confirmation, including while preparing a chord.
        if ((frame.Held & 4096) != 0) return default;
        if ((frame.Pressed & 128) != 0) return new(RadialAction.Close, At: at);
        if ((frame.Pressed & 64) != 0) return new(RadialAction.Backspace, At: at);
        if ((frame.Pressed & 16) != 0) return new(RadialAction.Commit, At: at);
        if ((frame.Pressed & 256) != 0) return new(RadialAction.Character, ' ', at);
        if ((frame.Pressed & (512 | 8192)) != 0) {
            if (frame.PressSample is { } edge) {
                var edgeGroup = Sector(edge.LeftX, edge.LeftY, Groups.Length, priorGroup);
                if (edgeGroup < 0) edgeGroup = priorGroup;
                var edgeLetter = Sector(edge.RightX, edge.RightY, Groups[edgeGroup].Length);
                if (edgeLetter >= 0) return new(RadialAction.Character, Groups[edgeGroup][edgeLetter], at);
            } else if (Hovered is { } ch) return new(RadialAction.Character, ch, at);
        }
        return default;
    }
}
