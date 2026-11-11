using XivSpell;

internal static class RadialTests
{
    private static void Check(bool ok, string message) { if (!ok) throw new Exception(message); }
    private static GrimoirePadFrame Aim(char ch, ulong sequence, long at, uint pressed = 512, uint held = 512)
    {
        var group = Array.FindIndex(RadialSpeller.Groups, letters => letters.Contains(ch));
        var letter = RadialSpeller.Groups[group].IndexOf(ch);
        var a = group * Math.Tau / RadialSpeller.Groups.Length;
        var b = letter * Math.Tau / RadialSpeller.Groups[group].Length;
        return new(1, "Active", sequence, held, pressed, 0,
            (float)Math.Sin(a) * .9f, -(float)Math.Cos(a) * .9f,
            (float)Math.Sin(b) * .9f, -(float)Math.Cos(b) * .9f, InputTime: at);
    }
    internal static void Run()
    {
        var radial = new RadialSpeller(); radial.Open(); ulong seq = 1;
        foreach (var ch in string.Concat(RadialSpeller.Groups)) {
            var frame = Aim(ch, seq++, 12345);
            var input = radial.Read(frame);
            Check(input.Action == RadialAction.Character && input.Character == ch && input.At == 12345, "Every radial character uses its press timestamp: " + ch);
            Check(radial.Read(frame).Action == RadialAction.None, "A duplicate frame cannot repeat a letter");
            Check(radial.Read(frame with { Sequence = seq++, Pressed = 0 }).Action == RadialAction.None, "Holding confirmation cannot repeat a letter");
        }
        var hover = Aim('t', seq++, 0, 0, 0);
        Check(radial.Read(hover).Action == RadialAction.None && radial.Hovered == 't', "Hover selects without typing or casting");
        Check(radial.Read(hover with { Sequence = seq++, Held = 4096, Pressed = 4096 }).Action == RadialAction.None, "R2 alone is reserved for playback chords");
        Check(radial.Read(hover with { Sequence = seq++, Held = 4096 | 128, Pressed = 128 }).Action == RadialAction.None, "R2+B cannot become a close or character action");
        Check(radial.Read(hover with { Sequence = seq++, Held = 256, Pressed = 256 }).Character == ' ', "LB enters a timed space");
        Check(radial.Read(hover with { Sequence = seq++, Held = 64, Pressed = 64 }).Action == RadialAction.Backspace, "X erases");
        Check(radial.Read(hover with { Sequence = seq++, Held = 16, Pressed = 16 }).Action == RadialAction.Commit, "Y commits an exact shorter name");
        Check(radial.Read(hover with { Sequence = seq++, Held = 128, Pressed = 128 }).Action == RadialAction.Close, "B closes without playback");
        Check(radial.Read(hover with { Sequence = seq++, Held = 512, Pressed = 512, RightX = 0, RightY = 0 }).Action == RadialAction.None, "A lifted pad cannot enter a stale letter");
        Check(RadialSpeller.Sector(float.NaN, 1, 8) == -1 && RadialSpeller.Sector(2, 0, 8) == -1, "Malformed axes cannot select a character");
        var boundary = Math.PI / 8 + .03;
        Check(RadialSpeller.Sector((float)Math.Sin(boundary), -(float)Math.Cos(boundary), 8, 0) == 0, "Hysteresis prevents group chatter at a wedge boundary");
        radial.Close(); Check(radial.Read(Aim('a', seq++, 1)).Action == RadialAction.None, "Closed wheels own no input");
        radial.Open(); Check(radial.Read(Aim('a', seq++, 1) with { Phase = "WaitingForNeutral" }).Action == RadialAction.None, "Focus recovery requires neutral input");

        const string owner = "XivHud.Grimoire";
        var lease = new GrimoirePadLease(); Check(lease.Renew(owner, 1, 0), "Radial lease is available");
        lease.Poll(new(1, 0, 0, 0, 0, 0), true, .001); lease.Poll(new(1, 0, 0, 0, 0, 0), true, .002);
        lease.Read(owner, 1, .003);
        lease.Poll(new(1, 512, 0, -.9f, 0, -.9f, InputTime: 12000), true, .01);
        lease.Poll(new(1, 512, 0, -.9f, .9f, 0, InputTime: 12010), true, .02);
        radial.Open(); var captured = radial.Read(lease.Read(owner, 1, .021)!.Value);
        Check(captured.Character == 'a' && captured.At == 12000 && radial.Hovered == 'b', "Later thumb motion cannot change the letter selected at trigger-down");
        lease.Release(owner, 1, .03);
        Check(!lease.Poll(new(1, 512, .8f, 0, .8f, 0), true, .04).All, "Closing immediately releases analog movement");
        lease.Release(owner, 1, .1);
        Check(lease.Read(owner, 1, .14) == null, "Repeated release cannot hold native buttons beyond the bounded drain");
        Check(lease.Read(owner, 1, .2) == null, "Expired focus cannot deliver stale spelling input");

        var round = new RhythmRound(); round.Start(RhythmTargetPhrases.Expand([new("physick", "physick", "Physick")]), 10, .5);
        radial.Open(); seq = 1;
        var weave = new SpellWeave(); var at = 10d;
        foreach (var phrase in new[] { "tank physick", "physick", "self physick", "physick" }) {
            foreach (var ch in phrase) {
                var input = radial.Read(Aim(ch, seq++, (long)(at * 1000)));
                Check(round.Press(input.Character, input.At / 1000d) == RhythmRound.Grade.Perfect, "Radial input uses the same rhythm grading");
                radial.Read(Aim(ch, seq++, (long)(at * 1000), 0, 0));
                at += .5;
            }
            var spell = round.TakeCompleted(at)!;
            Check(spell != null && weave.Add(spell.Command ?? spell.Phrase, spell.Id), "A full radial phrase queues one spell");
            weave.Interrupt("Queued");
        }
        Check(weave.Runes.Select(rune => rune.TargetOverride).SequenceEqual(new[] { "tank", "tank", "self", "self" }), "Radial spells and later bare spells share the intended target");
        Check(weave.Next == null && weave.InFlight == null, "Radial spelling cannot cast before playback");
        Console.WriteLine("PASS radial alphabet/digits, hover, confirmation edges, focus, timestamps, rhythm and retained targets");
    }
}
