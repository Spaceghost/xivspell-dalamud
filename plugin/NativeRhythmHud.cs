using System.Numerics;
using KamiToolKit;
using KamiToolKit.Nodes;
using KamiToolKit.UiOverlay;
using KamiToolKit.Enums;
using FFXIVClientStructs.FFXIV.Component.GUI;

namespace XivSpell;

// A small sigil embedded in Grimoire's existing spell-entry row. The tinted
// annulus depicts the whole accepted timing window, not only its perfect center.
internal sealed class NativeRhythmHud : OverlayNode
{
    public override bool HideWithNativeUi => false;
    public override bool HideWithUiToggled => true;
    public override OverlayLayer OverlayLayer => OverlayLayer.AboveUserInterface;
    protected override void OnUpdate() { }
    private static readonly Vector4 Gold=new(1,.89f,.61f,1), Cyan=new(.55f,.91f,.89f,1),
        White=new(.9f,.97f,1,1), Red=new(1,.55f,.48f,1);
    private readonly ColorImageNode[] safeZone=new ColorImageNode[64], receptor=new ColorImageNode[64],
        pulse=new ColorImageNode[64], halo=new ColorImageNode[64];
    private readonly TextNode centerCue, title, word, matches, feedback, deletion, controls;
    private readonly TextButtonNode toggle, cast, undo, reset, tap, source;
    public Action? Toggle { get; init; }
    public Action? Cast { get; init; }
    public Action? Delete { get; init; }
    public Action? Reset { get; init; }
    public Action? Tap { get; init; }
    public Action? Source { get; init; }
    public NativeRhythmHud()
    {
        Size=new(560,200);
        for(var i=0;i<pulse.Length;i++) {
            safeZone[i]=Fill(Cyan,.13f);receptor[i]=Fill(Gold,.4f);
            halo[i]=Fill(Cyan,.08f);pulse[i]=Fill(Cyan,.65f);
        }
        centerCue=Text(21,Gold);centerCue.AlignmentType=AlignmentType.Center;
        title=Text(11,Gold);word=Text(25,White);matches=Text(12,White);
        feedback=Text(12,Cyan);deletion=Text(11,Gold);controls=Text(11,White);
        toggle=Button("WEAVE",()=>Toggle?.Invoke(),60);
        undo=Button("UNDO SPELL",()=>Delete?.Invoke(),98);
        reset=Button("RESET SPELL",()=>Reset?.Invoke(),98);
        cast=Button("CAST + MOVE",()=>Cast?.Invoke(),112);
        source=Button("PIANO",()=>Source?.Invoke(),60);tap=Button("TAP",()=>Tap?.Invoke(),42);
    }
    private ColorImageNode Fill(Vector4 color,float alpha)
    {
        var n=new ColorImageNode {Color=color,Alpha=alpha,IsVisible=true};n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private TextNode Text(uint size,Vector4 color)
    {
        var n=new TextNode {FontSize=size,TextColor=color,TextOutlineColor=new(0,0,.015f,1),
            TextFlags=TextFlags.Edge|TextFlags.Bold,Size=new(560,30),IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private TextButtonNode Button(string label,Action action,float width)
    {
        var n=new TextButtonNode {String=label,Size=new(width,22),OnClick=action,IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private static void Label(TextNode n,float x,float y,float w,string value)
    {n.Position=new(x,y);n.Size=new(w,(float)n.FontSize+8);n.String=value;}
    private static void Ring(ColorImageNode[] nodes,Vector2 center,float radius,float thickness,Vector4 color,float alpha)
    {
        for(var i=0;i<nodes.Length;i++) {
            var a=i*MathF.Tau/nodes.Length;var b=(i+1)*MathF.Tau/nodes.Length;
            var from=center+new Vector2(MathF.Cos(a),MathF.Sin(a))*radius;
            var to=center+new Vector2(MathF.Cos(b),MathF.Sin(b))*radius;
            var delta=to-from;var length=delta.Length();
            nodes[i].Position=from-new Vector2(delta.Y,-delta.X)/length*(thickness/2);
            nodes[i].Size=new(thickness,length+.4f);
            nodes[i].RotationDegrees=-MathF.Atan2(delta.X,delta.Y)*180/MathF.PI;
            nodes[i].Color=color;nodes[i].Alpha=alpha;
        }
    }
    public void Render(RhythmRound round,string music,double bpm,Vector2 entry,float width,bool piano)
    {
        Position=entry;Size=new(width,200);
        var center=new Vector2(64,57);const float targetRadius=34;
        var rawNow=Environment.TickCount64/1000d;
        var now=(round.State==RhythmRound.Phase.Paused ? round.PausedAt : rawNow)
            -Math.Clamp(double.IsFinite(round.LatencyMs) ? round.LatencyMs : 0,-250,250)/1000;
        var remaining=round.Cursor<round.Notes.Length ? round.Notes[round.Cursor].Due-now : 1;
        var interval=round.Cursor>0 && round.Cursor<round.Notes.Length
            ? round.Notes[round.Cursor].Due-round.Notes[round.Cursor-1].Due : 60/bpm;
        var radius=targetRadius*(float)RhythmPulse.Radius(remaining,interval);
        var band=RhythmPulse.SafeZone(round.HitWindow,interval);
        var inner=targetRadius*(float)band.Inner;var outer=targetRadius*(float)band.Outer;
        var inWindow=round.Active && Math.Abs(remaining)<=round.HitWindow;
        var contact=round.Active ? (float)Math.Exp(-Math.Pow(remaining/.085,2)) : 0;
        var fail=round.LastGrade is RhythmRound.Grade.Miss or RhythmRound.Grade.Wrong or RhythmRound.Grade.Early;
        var recent=rawNow-round.LastFeedback<1.6;
        Ring(safeZone,center,(inner+outer)/2,outer-inner,Cyan,round.Active ? .20f+.06f*contact : .10f);
        Ring(receptor,center,targetRadius,1.2f,Gold,.35f+.3f*contact);
        Ring(halo,center,radius,5,Cyan,.04f+.12f*contact);
        Ring(pulse,center,radius,1.6f,Cyan,round.Active ? .55f+.25f*contact : .25f);
        var glyph=round.Prefix.Length>0 ? (round.Prefix[^1]==' ' ? "·" : char.ToUpperInvariant(round.Prefix[^1]).ToString()) : "◇";
        Label(centerCue,center.X-20,center.Y-17,40,glyph);
        centerCue.TextColor=inWindow ? White : Gold;centerCue.Alpha=.55f+.45f*contact;
        var textWidth=MathF.Max(180,width-144);
        Label(title,136,0,textWidth,WeavePresentation.Clip("SPELLSTRINGS  ·  "+(round.Active ? "WEAVING" : "PAUSED")+"  ·  "+music+"  ·  "+bpm.ToString("F0")+" BPM",(int)(textWidth/6)));
        word.FontSize=round.Prefix.Length>23 ? 18u : 25u;
        Label(word,136,21,textWidth,round.Prefix.Length>0 ? round.Prefix.ToUpperInvariant()+"│" : "◇  weave any spell");
        word.TextColor=round.Prefix.Length>0 ? White : new(.72f,.83f,.86f,1);
        var candidates=round.Prefix.Length>0 ? string.Join(" / ",round.Matches.Select(s=>s.Name).Distinct().Take(3)) : "tank physick · party2 physick · or any spell";
        Label(matches,136,57,textWidth,WeavePresentation.Clip(candidates,(int)(textWidth/6)));
        Label(feedback,136,80,textWidth,WeavePresentation.Clip(recent ? round.Feedback : "Center of the band = perfect timing",(int)(textWidth/6)));
        feedback.TextColor=recent && fail ? Red : Cyan;
        Label(deletion,8,114,width-16,round.Prefix.Length>0 ? "BACKSPACE  restart whole spell · press again to undo spell · HOLD to clear queue" : "BACKSPACE  undo spell · HOLD to clear queue · ENTER queues an exact name");
        toggle.Position=new(8,140);undo.Position=new(72,140);reset.Position=new(174,140);
        cast.Position=new(276,140);source.Position=new(392,140);tap.Position=new(456,140);
        toggle.String=round.Active ? "PAUSE" : round.State==RhythmRound.Phase.Paused ? "RESUME" : "WEAVE";
        source.String=piano ? "PIANO" : "GUIDE";
        Label(controls,8,171,width-16,"Esc pause / move  ·  i weave  ·  > cast + move  ·  "+round.Score.ToString("N0")+" points  ·  "+round.Combo+"x");
    }
}
