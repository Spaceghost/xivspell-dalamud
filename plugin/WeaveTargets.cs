using System.Numerics;
using Dalamud.Game.ClientState.Objects.Types;
using FFXIVClientStructs.FFXIV.Component.GUI;
using KamiToolKit;
using KamiToolKit.Enums;
using KamiToolKit.Nodes;
using KamiToolKit.UiOverlay;

namespace XivSpell;

internal sealed record WeaveTargetChoice(string Selector, string Label, string Detail, bool Available);

public sealed partial class Plugin
{
    private NativeWeaveTargets? weaveTargets;
    private bool resumeRhythmAfterTargets;
    private long targetChoicesAt;
    private WeaveTargetChoice[] targetChoices = [];
    private readonly KeyboardLease targetKeys = new();
    private bool WeaveTargetsOpen => weaveTargets?.Open == true;
    private static readonly HashSet<string> WeaveSelectors = ["card", "friendly", "self", "current", "focus", "lowest",
        "tank", "healer", "targetOfTarget", "enemy", "nearest", "nearestmob", "mob", "boss", "ally", "role",
        "party1", "party2", "party3", "party4", "party5", "party6", "party7", "party8"];

    private void ChooseWeaveTarget(string selector)
    {
        if (!WeaveSelectors.Contains(selector)) throw new InvalidOperationException("Choose card, friendly, self, current, focus, a party slot/role or an enemy selector");
        weave.SelectNextTarget(selector == "card" ? null : selector);
        weave.Hint = selector == "card" ? "Target memory cleared · use card defaults" : "Target retained → " + WeavePresentation.TargetLabel(selector) + " · " + TargetDescription(selector);
        CloseWeaveTargets(true);
    }
    private string TargetDescription(string selector)
    {
        if (selector == "card") return "Use the spell's default; Physick heals selected friendly / self";
        try {
            var actor = Resolve(selector);
            if (actor == null) return selector == "boss" ? "Select an enemy and MARK BOSS" : "No matching target available";
            return actor.Name.TextValue + (actor is ICharacter { MaxHp: > 0 } c ? $" · {100d * c.CurrentHp / c.MaxHp:F0}% HP" : "");
        } catch { return "Target is ambiguous; select a party slot"; }
    }
    private void CreateWeaveTargets()
    {
        weaveTargets = new NativeWeaveTargets {
            Choose = ChooseWeaveTarget,
            Close = () => CloseWeaveTargets(true),
            Focus = () => {
                if (targets.Target == null) { weave.Hint = "Select a teammate or enemy to set focus"; return; }
                targets.FocusTarget = targets.Target; targetChoicesAt = 0;
                weave.Hint = "Focus: " + targets.FocusTarget.Name.TextValue;
            },
            Boss = () => { MarkBoss(); targetChoicesAt = 0; },
            Enemy = () => {
                var enemy = ResolveEnemy(false, true);
                if (enemy == null) { weave.Hint = "No living enemy nearby"; return; }
                targets.Target = enemy; targetChoicesAt = 0;
                weave.Hint = "Selected " + enemy.Name.TextValue;
            },
        };
        hudController!.AddNode(weaveTargets);
    }
    private void ToggleWeaveTargets()
    {
        if (weaveTargets == null) return;
        if (weaveTargets.Open) { CloseWeaveTargets(true); return; }
        resumeRhythmAfterTargets = rhythm.Active;
        if (rhythm.Active) rhythm.Pause(RhythmNow);
        weaveTargets.Open = true; targetChoicesAt = 0; keyboard.Capture = true;
    }
    private void CloseWeaveTargets(bool resume)
    {
        if (weaveTargets != null) { weaveTargets.Open = false; weaveTargets.IsVisible = false; }
        if (resume && resumeRhythmAfterTargets && config.RhythmEnabled && rhythmShown) {
            var times = MusicTimes(); rhythmSongChart = times != null;
            rhythm.Resume(times?[0] ?? rhythmClock.NextBeat(RhythmNow + 1.2), times);
            weave.EnterInput();
        }
        resumeRhythmAfterTargets = false; keyboard.Capture = weave.InputMode;
    }
    private bool WeaveTargetKeyboard(SpellKeyboard.Input input)
    {
        if (!WeaveTargetsOpen) return false;
        if (input.Type is SpellKeyboard.Kind.Escape or SpellKeyboard.Kind.Movement ||
            input.Type == SpellKeyboard.Kind.Character && input.Character is '.' or '>') {
            CloseWeaveTargets(false); return false;
        }
        if (input.Type == SpellKeyboard.Kind.Character && input.Character is >= '1' and <= '8') {
            targetKeys.Hold(input.Character);
            var selector = "party" + input.Character;
            if (Resolve(selector) == null) { weave.Hint = "That party slot is empty"; return true; }
            ChooseWeaveTarget(selector); return true;
        }
        if (input.Type == SpellKeyboard.Kind.Character && char.ToLowerInvariant(input.Character) == 't') {
            targetKeys.Hold('T');
            if (Resolve("tank") == null) { weave.Hint = "No living party tank available"; return true; }
            ChooseWeaveTarget("tank"); return true;
        }
        if (input.Type == SpellKeyboard.Kind.Character && char.ToLowerInvariant(input.Character) is 'w' or 'a' or 's' or 'd') {
            CloseWeaveTargets(false); SuspendRhythm(); MovementControl();
        }
        return true;
    }
    private void RenderWeaveTargets()
    {
        if (weaveTargets == null || !WeaveTargetsOpen) return;
        var now = Environment.TickCount64;
        if (now >= targetChoicesAt) {
            targetChoicesAt = now + 250;
            var choices = new List<WeaveTargetChoice>();
            foreach (var (selector, label) in new[] { ("card","DEFAULT"), ("friendly","ALLY / SELF"), ("self","SELF"), ("current","SELECTED"),
                ("focus","FOCUS"), ("lowest","LOWEST HP"), ("tank","TANK"), ("targetOfTarget","TARGET'S TARGET"),
                ("enemy","ENEMY"), ("nearest","NEAREST ENEMY"), ("mob","TRASH / ADD"), ("boss","BOSS") }) {
                bool available;
                try { available = selector == "card" || Resolve(selector) != null; } catch { available = false; }
                choices.Add(new(selector, label, TargetDescription(selector), available));
            }
            for (var i = 0; i < 8; i++) {
                var actor = i < party.Length ? party[i]?.GameObject : null;
                var name = actor?.Name.TextValue;
                choices.Add(new("party" + (i+1), (i+1) + " · " + (name == null ? "empty slot" : WeavePresentation.Clip(name, 15)),
                    TargetDescription("party" + (i+1)), actor != null));
            }
            targetChoices = choices.ToArray();
        }
        weaveTargets.IsVisible = true;
        weaveTargets.Render(hud!.SpellEntryPosition, hud.Size.X, targetChoices, weave.NextTarget, targets.Target != null, IsEnemy(targets.Target));
    }
}

// Native popover; selecting a target prepares one rune and never casts.
internal sealed class NativeWeaveTargets : OverlayNode
{
    public override bool HideWithNativeUi => false;
    public override OverlayLayer OverlayLayer => OverlayLayer.AboveUserInterface;
    protected override void OnUpdate() { }
    public bool Open { get; set; }
    public Action<string>? Choose { get; init; }
    public Action? Close { get; init; }
    public Action? Focus { get; init; }
    public Action? Boss { get; init; }
    public Action? Enemy { get; init; }
    private readonly ColorImageNode[] ink = new ColorImageNode[12];
    private readonly TextNode title, detail, instructions;
    private readonly TextButtonNode[] choices = new TextButtonNode[20];
    private readonly TextButtonNode focus, boss, enemy, close;
    private WeaveTargetChoice[] options = [];
    private int hovered = -1;
    private static readonly Vector4 Gold = new(1,.89f,.61f,1), Ice = new(.82f,.97f,1,1);
    public NativeWeaveTargets()
    {
        IsVisible = false;
        for (var i=0;i<ink.Length;i++) {
            ink[i]=new ColorImageNode { Color=new(.008f,.018f,.045f,1), Alpha=.1f, IsVisible=true };
            ink[i].AttachNode(this,NodePosition.AsLastChild);
        }
        title=Text(14,Gold); detail=Text(12,Ice); instructions=Text(11,Ice);
        for (var i=0;i<choices.Length;i++) {
            var slot=i;
            choices[i]=Button("",()=>{ if (slot<options.Length && options[slot].Available) Choose?.Invoke(options[slot].Selector); });
            choices[i].AddEvent(AtkEventType.MouseOver,()=>hovered=slot);
            choices[i].AddEvent(AtkEventType.MouseOut,()=>{if(hovered==slot)hovered=-1;});
        }
        focus=Button("FOCUS SELECTED",()=>Focus?.Invoke());
        boss=Button("MARK BOSS",()=>Boss?.Invoke());
        enemy=Button("SELECT ENEMY",()=>Enemy?.Invoke());
        close=Button("CLOSE",()=>Close?.Invoke());
    }
    private TextNode Text(uint size,Vector4 color)
    {
        var n=new TextNode {FontSize=size,TextColor=color,TextOutlineColor=new(0,0,.015f,1),TextFlags=TextFlags.Edge|TextFlags.Bold,IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    private TextButtonNode Button(string text,Action action)
    {
        var n=new TextButtonNode {String=text,OnClick=action,IsVisible=true};
        n.AttachNode(this,NodePosition.AsLastChild);return n;
    }
    public void Render(Vector2 anchor,float width,WeaveTargetChoice[] items,string? selected,bool canFocus,bool canMark)
    {
        options=items; const float height=260;
        Size=new(width,height);Position=anchor-new Vector2(0,height+16);
        for(var i=0;i<ink.Length;i++) {var inset=i*1.3f;ink[i].Position=new(inset-8,inset-8);ink[i].Size=new(width+16-inset*2,height+16-inset*2);}
        title.Position=new(10,6);title.Size=new(width-20,24);
        title.String="SPELL TARGET · "+(selected==null ? "DEFAULT" : WeavePresentation.TargetLabel(selected));
        detail.Position=new(10,31);detail.Size=new(width-20,22);
        detail.String=WeavePresentation.Clip(hovered>=0 && hovered<items.Length ? items[hovered].Detail : "1–8 party · T tank · Esc close · Reused until changed",(int)((width-20)/6));
        var cell=(width-38)/4;
        for(var i=0;i<choices.Length;i++) {
            choices[i].Position=new(10+(i%4)*(cell+6),58+(i/4)*28);choices[i].Size=new(cell,24);
            choices[i].IsVisible=i<items.Length;
            if(i>=items.Length)continue;
            choices[i].IsEnabled=items[i].Available;
            choices[i].String=WeavePresentation.Clip((items[i].Selector==(selected??"card") ? "◇ " : "")+items[i].Label,
                Math.Max(5,(int)((cell-14)/7)));
        }
        TextButtonNode[] footer=[focus,boss,enemy,close];
        for(var i=0;i<footer.Length;i++) {footer[i].Position=new(10+i*(cell+6),204);footer[i].Size=new(cell,24);}
        focus.IsEnabled=canFocus;boss.IsEnabled=canMark;
        instructions.Position=new(10,234);instructions.Size=new(width-20,20);
        instructions.String="1–8 choose party · Esc stops · selection never casts";
    }
}
