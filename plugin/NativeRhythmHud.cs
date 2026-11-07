using System.Numerics;
using KamiToolKit;
using KamiToolKit.Nodes;
using KamiToolKit.UiOverlay;
using KamiToolKit.Enums;
using FFXIVClientStructs.FFXIV.Component.GUI;

namespace XivSpell;

// A native reverse pulse meets a fixed receptor ring at the song timestamp.
// Text stays upright and no lane or preselected spell is involved.
internal sealed class NativeRhythmHud : OverlayNode
{
    public override bool HideWithNativeUi => false;
    public override bool HideWithUiToggled => true;
    public override OverlayLayer OverlayLayer => OverlayLayer.AboveUserInterface;
    protected override void OnUpdate() { }
    private static readonly Vector4 Gold=new(.91f,.78f,.49f,1), Cyan=new(.43f,.94f,.93f,1),
        Ink=new(.012f,.025f,.041f,1), White=new(.9f,.97f,1,1), Red=new(1,.43f,.42f,1);
    private readonly ColorImageNode[] ticks=new ColorImageNode[12];
    private readonly ColorImageNode[] receptor=new ColorImageNode[96], pulse=new ColorImageNode[96], halo=new ColorImageNode[96];
    private readonly ColorImageNode header, panel, topRule;
    private readonly TextNode title, song, status, tally, centerCue, timingCue, instruction, word, matches, feedback, queue, deletion, controls;
    private readonly TextButtonNode toggle, cast, undo, reset, tap, source;
    public Action? Toggle { get; init; }
    public Action? Cast { get; init; }
    public Action? Delete { get; init; }
    public Action? Reset { get; init; }
    public Action? Tap { get; init; }
    public Action? Source { get; init; }
    public NativeRhythmHud()
    {
        Size=new(620,650);
        header=Fill(Ink,.92f);
        for(var i=0;i<ticks.Length;i++) ticks[i]=Fill(Gold,.45f);
        for(var i=0;i<pulse.Length;i++) {
            receptor[i]=Fill(Gold,.65f);halo[i]=Fill(Cyan,.16f);pulse[i]=Fill(Cyan,.9f);
        }
        panel=Fill(Ink,.94f);topRule=Fill(Gold,.9f);
        centerCue=Text(28,White);timingCue=Text(12,Gold);
        centerCue.AlignmentType=timingCue.AlignmentType=AlignmentType.Center;
        title=Text(16,Gold);song=Text(12,White);status=Text(12,Cyan);tally=Text(12,Gold);
        instruction=Text(12,Gold);word=Text(34,White);matches=Text(13,White);
        feedback=Text(15,Cyan);queue=Text(13,Gold);deletion=Text(12,White);controls=Text(12,Gold);
        toggle=Button("WEAVE",()=>Toggle?.Invoke(),86);
        cast=Button("CAST + MOVE",()=>Cast?.Invoke(),124);
        undo=Button("UNDO SPELL",()=>Delete?.Invoke(),112);
        reset=Button("RESET WORD",()=>Reset?.Invoke(),112);
        tap=Button("TAP",()=>Tap?.Invoke(),54);source=Button("PIANO",()=>Source?.Invoke(),68);
    }
    private ColorImageNode Fill(Vector4 color,float alpha)
    {
        var n=new ColorImageNode {Color=color,Alpha=alpha,IsVisible=true};n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private TextNode Text(uint size,Vector4 color)
    {
        var n=new TextNode {FontSize=size,TextColor=color,TextOutlineColor=new(0,0,.015f,1),
            TextFlags=TextFlags.Edge|TextFlags.Bold,Size=new(620,40),IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private TextButtonNode Button(string label,Action action,float width)
    {
        var n=new TextButtonNode {String=label,Size=new(width,26),OnClick=action,IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private static void Box(ColorImageNode n,float x,float y,float w,float h) {n.Position=new(x,y);n.Size=new(w,h);}
    private static void Label(TextNode n,float x,float y,float w,string value) {n.Position=new(x,y);n.Size=new(w,(float)n.FontSize+8);n.String=value;}
    private static void Segment(ColorImageNode node,Vector2 from,Vector2 to,float thickness)
    {
        var delta=to-from;node.Position=from;node.Size=new(thickness,delta.Length()+.5f);
        node.RotationDegrees=-MathF.Atan2(delta.X,delta.Y)*180/MathF.PI;
    }
    private static void Ring(ColorImageNode[] nodes,Vector2 center,float radius,float thickness,Vector4 color,float alpha)
    {
        for(var i=0;i<nodes.Length;i++) {
            var a=i*MathF.Tau/nodes.Length;var b=(i+1)*MathF.Tau/nodes.Length;
            Segment(nodes[i],center+new Vector2(MathF.Cos(a),MathF.Sin(a))*radius,
                center+new Vector2(MathF.Cos(b),MathF.Sin(b))*radius,thickness);
            nodes[i].Color=color;nodes[i].Alpha=alpha;
        }
    }
    public void Render(RhythmRound round,string music,double bpm,string[] queued,double energy,bool piano)
    {
        var viewport=Dalamud.Bindings.ImGui.ImGui.GetMainViewport().Size;
        var width=Math.Clamp(viewport.X*.32f,590,640);
        Size=new(width,622);
        Position=new((viewport.X-width)/2,MathF.Max(50,viewport.Y*.09f));
        var center=new Vector2(width/2,196);
        const float targetRadius=64, rim=125, panelY=342;
        var now=(round.State==RhythmRound.Phase.Paused ? round.PausedAt : Environment.TickCount64/1000d)
            -Math.Clamp(double.IsFinite(round.LatencyMs) ? round.LatencyMs : 0,-250,250)/1000;
        var remaining=round.Cursor<round.Notes.Length ? round.Notes[round.Cursor].Due-now : 1;
        var interval=round.Cursor>0 && round.Cursor<round.Notes.Length
            ? round.Notes[round.Cursor].Due-round.Notes[round.Cursor-1].Due : 60/bpm;
        var radius=targetRadius*(float)RhythmPulse.Radius(remaining,interval);
        var inWindow=round.Active && Math.Abs(remaining)<=round.HitWindow;
        var onBeat=round.Active && Math.Abs(remaining)<=.065;
        var fail=round.LastGrade is RhythmRound.Grade.Miss or RhythmRound.Grade.Wrong or RhythmRound.Grade.Early;
        var recent=Environment.TickCount64/1000d-round.LastFeedback<1.8;
        var accent=recent && fail ? Red : Cyan;
        Box(header,0,0,width,64);
        Label(title,18,9,width-150,"GRIMOIRE   /   SPELLSTRINGS");
        Label(status,width-132,12,120,round.Active ? "●  SPELLING" : "Ⅱ  PAUSED");
        status.TextColor=round.Active ? Cyan : Gold;
        Label(song,18,36,width-168,WeavePresentation.Clip(music+"   ·   "+bpm.ToString("F0")+" BPM",(int)((width-170)/6.5f)));
        Label(tally,width-132,36,120,$"{round.Score:N0}  ·  {round.Combo}x");
        for(var i=0;i<ticks.Length;i++) {
            var a=i*MathF.Tau/ticks.Length;var direction=new Vector2(MathF.Cos(a),MathF.Sin(a));
            Segment(ticks[i],center+direction*(rim-7),center+direction*(rim+1),i%3==0 ? 2 : 1);
        }
        Ring(receptor,center,targetRadius,inWindow ? 2.5f : 1.3f,inWindow ? Cyan : Gold,inWindow ? .95f : .6f);
        Ring(halo,center,radius,onBeat ? 14 : 7,accent,onBeat ? .34f : .12f);
        Ring(pulse,center,radius,2.5f,accent,round.Active ? .9f : .4f);
        Label(centerCue,center.X-55,center.Y-24,110,onBeat ? "NOW" : inWindow ? "TYPE" : round.Active ? "WAIT" : "PAUSE");
        centerCue.TextColor=onBeat ? White : inWindow ? Cyan : new(.6f,.76f,.79f,1);
        Label(timingCue,center.X-51,center.Y+15,110,onBeat ? "ON THE BEAT" : "RINGS MEET");
        Box(panel,0,panelY,width,208);Box(topRule,0,panelY,width,1);
        Label(instruction,18,panelY+12,width-30,"TYPE ANY SPELL   /   WHEN THE RINGS MEET");
        word.FontSize=(uint)(round.Prefix.Length>22 ? 24 : 34);
        Label(word,18,panelY+37,width-32,round.Prefix.Length==0 ? "Type a spell…" : round.Prefix.ToUpperInvariant()+"_");
        word.TextColor=round.Prefix.Length>0 ? White : new(.52f,.66f,.7f,1);
        var candidates=round.Matches.Take(4).Select(s=>s.Name).ToArray();
        var candidateText=round.Prefix.Length>0 ? string.Join("   /   ",candidates) : "No spell selection. Begin on any pulse.";
        Label(matches,18,panelY+82,width-32,WeavePresentation.Clip(candidateText,74));
        Label(feedback,18,panelY+108,width-32,recent ? round.Feedback : round.Prefix.Length>0 ? "NEXT   "+round.NextLetters : "Let the outer ring meet the inner ring, then type.");
        feedback.TextColor=recent && fail ? Red : Cyan;
        Label(queue,18,panelY+144,width-32,$"{queued.Length} / {SpellWeave.Capacity} QUEUED"+(queued.Length>0 ? "   ·   LAST: "+WeavePresentation.Clip(queued[^1].ToUpperInvariant(),38) : "   ·   Spelling queues; it never casts."));
        Label(deletion,18,panelY+173,width-32,round.Prefix.Length>0 ? "BACKSPACE  restart this word   ·   press again to undo the last queued spell" : "BACKSPACE  undo last queued spell   ·   HOLD BACKSPACE  clear the queue");
        toggle.Position=new(0,panelY+220);undo.Position=new(90,panelY+220);reset.Position=new(206,panelY+220);
        cast.Position=new(322,panelY+220);tap.Position=new(450,panelY+220);source.Position=new(508,panelY+220);
        toggle.String=round.Active ? "PAUSE" : round.State==RhythmRound.Phase.Paused ? "RESUME" : "WEAVE";
        source.String=piano ? "PIANO" : "GUIDE";
        Label(controls,0,panelY+254,width,"ESC  pause / move    ·    i  weave    ·    >  cast + move    ·    ENTER  queue exact name");
    }
}
