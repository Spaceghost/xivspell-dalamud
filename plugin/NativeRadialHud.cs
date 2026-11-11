using System.Numerics;
using KamiToolKit;
using KamiToolKit.Enums;
using KamiToolKit.Nodes;
using KamiToolKit.UiOverlay;
using FFXIVClientStructs.FFXIV.Component.GUI;

namespace XivSpell;

internal sealed class NativeRadialHud : OverlayNode
{
    public override bool HideWithNativeUi => false;
    public override bool HideWithUiToggled => true;
    public override OverlayLayer OverlayLayer => OverlayLayer.AboveUserInterface;
    protected override void OnUpdate() { }
    private static readonly Vector4 Gold = new(1, .89f, .61f, 1), Cyan = new(.55f, .91f, .89f, 1), White = new(.9f, .97f, 1, 1);
    private readonly TextNode[] groups = new TextNode[8], letters = new TextNode[10];
    private readonly ColorImageNode[] rings = new ColorImageNode[96];
    private readonly TextNode groupTitle, letterTitle, groupCenter, letterCenter, help, playback;
    public NativeRadialHud()
    {
        IsVisible = false; Size = new(560, 270);
        var backing = new ColorImageNode { Color = new(.008f, .018f, .045f, 1), Alpha = .78f, Size = Size, IsVisible = true };
        backing.AttachNode(this, NodePosition.AsLastChild);
        for (var i = 0; i < rings.Length; i++) {
            rings[i] = new ColorImageNode { Color = Cyan, Alpha = .24f, Size = new(3, 3), IsVisible = true };
            rings[i].AttachNode(this, NodePosition.AsLastChild);
        }
        groupTitle = Text(12, Gold); letterTitle = Text(12, Gold);
        groupCenter = Text(18, Cyan); letterCenter = Text(28, Gold);
        help = Text(11, White); playback = Text(11, White);
        for (var i = 0; i < groups.Length; i++) groups[i] = Text(13, White);
        for (var i = 0; i < letters.Length; i++) letters[i] = Text(19, White);
    }
    private TextNode Text(uint size, Vector4 color)
    {
        var node = new TextNode { FontSize = size, TextColor = color, TextOutlineColor = new(0, 0, 0, 1),
            TextFlags = TextFlags.Edge | TextFlags.Bold, AlignmentType = AlignmentType.Center, IsVisible = true };
        node.AttachNode(this, NodePosition.AsLastChild); return node;
    }
    private static string Label(char ch) => ch == ' ' ? "SPACE" : char.ToUpperInvariant(ch).ToString();
    private static void Place(TextNode node, Vector2 center, float width, string text)
    { node.Size = new(width, node.FontSize + 10); node.Position = center - new Vector2(width / 2, node.FontSize / 2); node.String = text; }

    public void Render(RadialSpeller radial, Vector2 entry, float width)
    {
        var viewport = Dalamud.Bindings.ImGui.ImGui.GetMainViewport();
        Position = new(Math.Clamp(entry.X + (width - Size.X) / 2, viewport.Pos.X + 8, Math.Max(viewport.Pos.X + 8, viewport.Pos.X + viewport.Size.X - Size.X - 8)),
            Math.Clamp(entry.Y - 450, viewport.Pos.Y + 40, Math.Max(viewport.Pos.Y + 40, viewport.Pos.Y + viewport.Size.Y - Size.Y - 8)));
        Vector2 left = new(140, 128), right = new(420, 128);
        Place(groupTitle, new(140, 16), 250, "LEFT PAD · LETTER GROUP");
        Place(letterTitle, new(420, 16), 250, "RIGHT PAD · CHARACTER");
        for (var i = 0; i < rings.Length; i++) {
            var angle = i % 48 * MathF.Tau / 48;
            rings[i].Position = (i < 48 ? left : right) + new Vector2(MathF.Sin(angle), -MathF.Cos(angle)) * 60 - new Vector2(1.5f);
        }
        for (var i = 0; i < groups.Length; i++) {
            var angle = i * MathF.Tau / groups.Length;
            var text = i == 7 ? "0–9" : i == 6 ? "YZ ␣ -" : RadialSpeller.Groups[i].ToUpperInvariant();
            Place(groups[i], left + new Vector2(MathF.Sin(angle), -MathF.Cos(angle)) * 84, 78, text);
            groups[i].TextColor = i == radial.Group ? Gold : White;
            groups[i].Alpha = i == radial.Group ? 1 : .65f;
        }
        for (var i = 0; i < letters.Length; i++) {
            letters[i].IsVisible = i < radial.Characters.Length;
            if (!letters[i].IsVisible) continue;
            var angle = i * MathF.Tau / radial.Characters.Length;
            Place(letters[i], right + new Vector2(MathF.Sin(angle), -MathF.Cos(angle)) * 84, 75, Label(radial.Characters[i]));
            letters[i].TextColor = i == radial.Letter ? Gold : White;
            letters[i].Alpha = i == radial.Letter ? 1 : .7f;
        }
        Place(groupCenter, left, 110, radial.Group == 7 ? "DIGITS" : RadialSpeller.Groups[radial.Group].ToUpperInvariant());
        Place(letterCenter, right, 110, radial.Hovered is { } ch ? Label(ch) : "◇");
        Place(help, new(280, 235), 548, radial.Ready ? "L2 / pad press: letter · LB: space · X: undo · Y: finish · B: close" : "Lift both thumbs and release buttons to begin");
        Place(playback, new(280, 254), 548, "R2+A repeat · R2+B continue · F8 / L3+R3 close");
    }
}
