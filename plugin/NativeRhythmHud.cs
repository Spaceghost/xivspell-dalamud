using System.Numerics;
using KamiToolKit;
using KamiToolKit.Nodes;
using KamiToolKit.UiOverlay;
using KamiToolKit.Enums;
using FFXIVClientStructs.FFXIV.Component.GUI;

namespace XivSpell;

// The same native node/overlay system as the spell runes. No ImGui window,
// input rectangle or scene-wide mouse capture is involved.
internal sealed class NativeRhythmHud : OverlayNode
{
    // XivHud can hide native nameplates while keeping custom HUDs active.
    // The global UI-display toggle is still respected independently below.
    public override bool HideWithNativeUi => false;
    public override bool HideWithUiToggled => true;
    public override OverlayLayer OverlayLayer => OverlayLayer.AboveUserInterface;
    protected override void OnUpdate() { }
    private static readonly Vector4 Gold = new(1,.89f,.61f,1), Ice = new(.82f,.97f,1,1);
    private static readonly Vector4[] Hands = [new(.45f,.94f,.89f,1),new(1,.65f,.82f,1)];
    private readonly ColorImageNode[] road = new ColorImageNode[64], edges = new ColorImageNode[96];
    private readonly ColorImageNode[] notes = new ColorImageNode[40], glows = new ColorImageNode[40];
    private readonly TextNode[] prompts = new TextNode[40], spellLetters = new TextNode[40];
    private readonly ColorImageNode[] strike = new ColorImageNode[2];
    private readonly TextNode[] next = new TextNode[2], choices = new TextNode[2];
    private readonly TextNode title, song, spell, score, feedback, controls;
    private readonly TextButtonNode previous, following, toggle, cast, mode, tap, source;
    public Action<int>? SelectSpell { get; init; }
    public Action? Toggle { get; init; }
    public Action? Cast { get; init; }
    public Action? ChangeMode { get; init; }
    public Action? Tap { get; init; }
    public Action? Source { get; init; }

    public NativeRhythmHud()
    {
        Size = new(700,500);
        for (var i=0;i<road.Length;i++) road[i] = Fill(new(.008f,.018f,.035f,1), .27f);
        for (var i=0;i<edges.Length;i++) edges[i] = Fill(Gold,.35f);
        for (var i=0;i<2;i++) {
            strike[i] = Fill(Hands[i],.85f);
            next[i] = Text(28,Hands[i]); choices[i] = Text(13,Ice);
        }
        for (var i=0;i<notes.Length;i++) {
            glows[i] = Fill(Gold,.22f); notes[i] = Fill(Hands[0],.8f);
            prompts[i] = Text(32,Ice); spellLetters[i] = Text(16,Gold);
        }
        title = Text(17,Gold); song = Text(13,Ice); spell = Text(21,Ice);
        score = Text(14,Gold); feedback = Text(22,Ice); controls = Text(13,Gold);
        previous = Button("‹",()=>SelectSpell?.Invoke(-1),36);
        following = Button("›",()=>SelectSpell?.Invoke(1),36);
        toggle = Button("WEAVE",()=>Toggle?.Invoke(),80);
        cast = Button("CAST + MOVE",()=>Cast?.Invoke(),120);
        mode = Button("KEYBOARD",()=>ChangeMode?.Invoke(),110);
        tap = Button("TAP BEAT",()=>Tap?.Invoke(),85);
        source = Button("PIANO",()=>Source?.Invoke(),85);
    }
    private ColorImageNode Fill(Vector4 color,float alpha)
    {
        var node = new ColorImageNode { Color=color, Alpha=alpha, IsVisible=true };
        node.AttachNode(this,NodePosition.AsLastChild); return node;
    }
    private TextNode Text(uint size,Vector4 color)
    {
        var node = new TextNode { FontSize=size,TextColor=color,TextOutlineColor=new(0,0,.015f,1),
            TextFlags=TextFlags.Edge|TextFlags.Bold,Size=new(700,40),IsVisible=true };
        node.AttachNode(this,NodePosition.AsLastChild); return node;
    }
    private TextButtonNode Button(string label,Action action,float width)
    {
        var node = new TextButtonNode { String=label,Size=new(width,24),OnClick=action,IsVisible=true };
        node.AttachNode(this,NodePosition.AsLastChild); return node;
    }
    public void Render(RhythmRound round,bool controller,string selected,string music,double bpm,
        int queued,double approach,float energy,bool piano)
    {
        var viewport = Dalamud.Bindings.ImGui.ImGui.GetMainViewport().Size;
        var width = Math.Clamp(viewport.X*.43f,440,760);
        var height = Math.Clamp(viewport.Y*.36f,250,400);
        Size = new(width,height+220);
        Position = new((viewport.X-width)/2,MathF.Max(54,viewport.Y*.09f));
        var now = round.State==RhythmRound.Phase.Paused ? round.PausedAt : Environment.TickCount64/1000d;
        const float top=80;
        var horizon = width*.12f;
        for (var row=0;row<32;row++) {
            var t=(float)row/32; var y=top+height*t*t; var nextY=top+height*((row+1)/32f)*((row+1)/32f);
            var half=(horizon+(width*.84f-horizon)*t)/2;
            for (var hand=0;hand<2;hand++) {
                var node=road[row*2+hand];
                node.Position=new(width/2+(hand-1)*half,y); node.Size=new(half,nextY-y+1);
                node.Alpha=.16f+.1f*t;
            }
            for (var edge=0;edge<3;edge++) {
                var node=edges[row*3+edge];node.Position=new(width/2+(edge-1)*half,y);
                node.Size=new(edge==1 ? 1 : 2,nextY-y+1);node.Alpha=.12f+.45f*t;
            }
        }
        var bottom = top+height;
        var laneWidth=width*.42f;
        for (var hand=0;hand<2;hand++) {
            var left=width/2+(hand-1)*laneWidth;
            strike[hand].Position=new(left+3,bottom);strike[hand].Size=new(laneWidth-6,3);
            strike[hand].Alpha=.6f+energy*.3f;
            next[hand].Position=new(left+6,bottom+8);next[hand].Size=new(laneWidth-8,38);
            next[hand].String=hand==0 ? "LEFT" : "RIGHT";next[hand].Alpha=.4f;
            choices[hand].Position=new(left-36,bottom+48);choices[hand].Size=new(laneWidth+72,26);
            choices[hand].String="";
        }
        if (round.Cursor<round.Notes.Length) {
            var note=round.Notes[round.Cursor];var hand=RhythmHands.Hand(note,controller);
            next[hand].String="PRESS  "+RhythmHands.Prompt(note,controller);next[hand].Alpha=1;
            if (controller) for (var h=0;h<2;h++)
                choices[h].String=string.Join("   ",Enumerable.Range(h*4,4).Select(i=>RhythmHands.Button(i)+" "+char.ToUpperInvariant(note.Choices[i])));
        }
        var slot=0;
        for (var i=round.Cursor;i<round.Notes.Length && slot<notes.Length;i++) {
            var note=round.Notes[i];var remaining=note.Due-now;
            if (remaining>approach || remaining<-.4) continue;
            var t=(float)Math.Clamp(1-remaining/approach,0,1.04);
            var hand=RhythmHands.Hand(note,controller);
            var half=(horizon+(width*.84f-horizon)*t)/2;
            var left=width/2+(hand-1)*half;
            var x=left+half*(.17f+.66f*RhythmHands.Alignment(note,controller));
            var y=top+height*t*t;
            var scale=.32f+.68f*t;
            var label=RhythmHands.Prompt(note,controller);
            var keyWidth=(label.Length>2 ? 100 : 60)*scale;
            glows[slot].IsVisible=notes[slot].IsVisible=prompts[slot].IsVisible=spellLetters[slot].IsVisible=true;
            glows[slot].Position=new(x-keyWidth/2-4,y-23*scale);glows[slot].Size=new(keyWidth+8,48*scale);
            glows[slot].Color=Hands[hand];glows[slot].Alpha=.12f+.18f*t;
            notes[slot].Position=new(x-keyWidth/2,y-20*scale);notes[slot].Size=new(keyWidth,3*scale);notes[slot].Color=Hands[hand];
            prompts[slot].Position=new(x-keyWidth/2+6*scale,y-18*scale);prompts[slot].Size=new(keyWidth,38*scale);
            prompts[slot].FontSize=(uint)Math.Clamp(32*scale,12,36);prompts[slot].String=label;prompts[slot].TextColor=Hands[hand];
            spellLetters[slot].Position=new(x-keyWidth/2+4*scale,y+17*scale);spellLetters[slot].Size=new(keyWidth+24,24);
            spellLetters[slot].FontSize=(uint)Math.Clamp(15*scale,10,17);
            spellLetters[slot].String=controller ? (note.Letter==' ' ? "SPACE" : char.ToUpperInvariant(note.Letter).ToString()) : "";
            slot++;
        }
        for (;slot<notes.Length;slot++) glows[slot].IsVisible=notes[slot].IsVisible=prompts[slot].IsVisible=spellLetters[slot].IsVisible=false;
        title.Position=new(0,0);title.String="GRIMOIRE  ◇  SPELLSTRINGS";
        song.Position=new(0,24);song.Size=new(width,22);song.String=WeavePresentation.Clip(music+"  ·  "+bpm.ToString("F0")+" BPM  ·  "+approach.ToString("F0")+"s approach",(int)(width/7));
        spell.Position=new(0,50);spell.Size=new(width,30);spell.String=(round.Target?.Phrase ?? selected).ToUpperInvariant();
        score.Position=new(width*.55f,52);score.Size=new(width*.45f,26);score.String=$"{round.Score:N0}  ·  {round.Combo}x  ·  {round.Stars}/5  ·  {queued} RUNES";
        feedback.Position=new(width/2-100,bottom-80);feedback.Size=new(250,40);
        feedback.IsVisible=Environment.TickCount64/1000d-round.LastFeedback<.7;
        feedback.String=round.LastGrade.ToString().ToUpperInvariant();
        if (round.Active && round.Cursor==0 && round.Notes.Length>0 && round.Notes[0].Due-now>1) {
            feedback.IsVisible=true;feedback.String="IN "+Math.Ceiling(round.Notes[0].Due-now).ToString("F0");
        }
        controls.Position=new(0,bottom+78);controls.Size=new(width,24);
        controls.String=controller ? "L1/R1 spell  ·  both sticks weave/pause  ·  R3 cast + move" : "Type the key  ·  Esc pause  ·  > cast + move  ·  i weave";
        previous.Position=new(0,bottom+106);following.Position=new(38,bottom+106);toggle.Position=new(80,bottom+106);
        cast.Position=new(164,bottom+106);mode.Position=new(288,bottom+106);tap.Position=new(402,bottom+106);source.Position=new(491,bottom+106);
        toggle.String=round.Active ? "PAUSE" : round.State==RhythmRound.Phase.Paused ? "RESUME" : "WEAVE";
        mode.String=controller ? "CONTROLLER" : "KEYBOARD";source.String=piano ? "PIANO" : "GUIDE";
    }
}
