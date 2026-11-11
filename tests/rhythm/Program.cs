using XivSpell;

static void Check(bool ok, string why) { if (!ok) throw new Exception(why); }
RhythmRound.Spell[] deck = [new("ruin", "ruin", "Ruin"), new("raise","raise","Raise"), new("ruby","ruby","Ruby"), new("physick","physick","Physick")];

var clock = new RhythmClock();
clock.SetTempo(120, 0);
Check(clock.NextBeat(.25) == .5, "Guide beat aligns to its epoch");
for (var i = 0; i < 6; i++) {
    clock.Observe(1, i + 1, true, true, .01, .7f, .2f, i * .5);
    clock.Observe(1, i + 1, true, true, .01, 1, .2f, i * .5 + .02);
}
Check(clock.Locked && Math.Abs(clock.Bpm - 120) < .01, "Repeated frames cannot bias the onset estimate");
Check(clock.MusicFresh(2.6) && !clock.MusicFresh(3), "Paused/missing music becomes stale");
clock.Observe(2, 1, true, true, .01, .5f, .1f, 3);
Check(!clock.Locked, "New streams cannot inherit old beat evidence");
var bpm = clock.Bpm;
clock.Observe(2,2,true,true,double.NaN,float.NaN,0,4);
Check(clock.Bpm == bpm && !clock.Locked, "Malformed audio cannot corrupt timing");
clock.SetTempo(double.NaN, 4);
Check(double.IsFinite(clock.Bpm), "Non-finite tempo rejected");
clock.SetTempo(100, 10);
for (var i = 0; i < 5; i++) clock.Tap(10 + i * .6);
Check(Math.Abs(clock.Bpm - 100) < .01, "Tap tempo follows game music without capturing it");

var r = new RhythmRound();
Check(r.Start(deck,4,.5), "Free spelling starts without selecting a spell");
Check(r.Press('p',4)==RhythmRound.Grade.Perfect && r.Prefix=="p", "Any spell's first letter is accepted on the shared beat");
r.Press('h',4.5);r.Press('z',5);
Check(r.Prefix=="" && r.Misses==1 && !r.Completed,"An invalid continuation resets the whole word");
r.Press('r',5.5);r.Press('a',6);r.Press('i',6.5);r.Press('s',7);r.Press('e',7.5);
Check(r.Completed && r.Target?.Id=="raise", "After a reset, a different spell can be chosen freely");
var queued=r.TakeCompleted(7.5);
Check(queued?.Id=="raise" && r.Active && r.Prefix=="", "A full word becomes one rune and keeps free spelling active");
r.Press('r',8);r.Press('u',8.5);r.Tick(9.3);
Check(r.Prefix=="" && r.LastGrade==RhythmRound.Grade.Miss && !r.Completed,"Missing a character resets from the first letter");
var misses=r.Misses;r.Tick(10.8);
Check(r.Misses==misses,"Unstarted spells do not penalize optional idle pulses");
r.Press('r',11);r.Press('u',11.5);r.Press('i',12);r.Press('n',12.5);
Check(r.Completed && r.Target?.Id=="ruin","Restart requires every letter, including the initial letter");
r.TakeCompleted(12.5);r.Press('r',13);r.Press('u',13.1);
Check(r.Prefix=="" && !r.Completed,"Off-beat typing breaks an unfinished word");

RhythmRound.Spell[] branching=[new("ruin","ruin","Ruin"),new("ruinii","ruin ii","Ruin II")];
r.Start(branching,20,.5);r.Press('r',20);r.Press('u',20.5);r.Press('i',21);r.Press('n',21.5);
Check(!r.Completed && r.Prefix=="ruin" && r.NextLetters.Contains("SPACE"),"Short names remain open when a longer name shares the prefix");
r.Press(' ',22);r.Press('i',22.5);r.Press('i',23);
Check(r.Completed && r.Target?.Id=="ruinii","Multiword spells use timed spaces");
r.TakeCompleted(23);r.Press('r',23.5);r.Press('u',24);r.Press('i',24.5);r.Press('n',25);
Check(r.Commit(25.1) && r.Target?.Id=="ruin","Enter queues an exact shorter spell without forcing the longer name");
r.TakeCompleted(25.1);r.Press('r',25.5);
Check(!r.Commit(25.6) && r.Prefix=="r" && !r.Completed,"Enter cannot bypass missing letters");
r.Restart(25.7);Check(r.Prefix=="" && r.Misses==0,"Backspace deliberately clears the word without a timing penalty");
r.Tick(26.3);r.Press('r',26.5);r.Pause(26.6);r.Tick(100);
Check(r.Prefix=="r" && r.Press('u',100)==RhythmRound.Grade.None,"Pause preserves a word and consumes no input");
r.Resume(101,[101,101.4,102,102.6]);r.LatencyMs=100;
Check(r.Press('u',101.1)==RhythmRound.Grade.Perfect && r.Prefix=="ru","Resume re-arms real future timings with latency compensation");
Check(r.Press('i',100)==RhythmRound.Grade.None,"Out-of-order inputs are ignored");
r.LatencyMs=0;r.Restart(101.2);var before=r.Notes[r.Cursor].Due;
r.Extend([103,103.4,103.9]);
Check(r.Notes[0].Due==before && r.Notes.Select(n=>n.Due).SequenceEqual(r.Notes.Select(n=>n.Due).Order()),"Extending a song map preserves already visible pulses");
Check(!r.Start(deck,1,double.NaN),"Malformed timing is rejected");
Check(!r.Start([deck[0] with { Phrase="\n" }],1,.5),"Control characters cannot become spells");

RhythmRound.Spell[] summons=[new("carbuncle","summon carbuncle","Summon Carbuncle","summon carbuncle"),new("ruby","summon ruby","Summon Ruby","summon ruby"),
    new("carbuncle","sc","Summon Carbuncle","summon carbuncle"),new("carbuncle","carbuncle","Summon Carbuncle","summon carbuncle"),new("ruby","summon ruby","Ruby duplicate","x")];
r.Start(summons,30,.5);r.Press('s',30);r.Press('c',30.5);
Check(r.Completed && r.Target?.Id=="carbuncle" && r.Target.Command=="summon carbuncle","A two-letter shortcut queues the full multiword spell");
r.TakeCompleted(30.5);foreach(var (ch,i) in "carbuncle".Select((ch,i)=>(ch,i))) r.Press(ch,31+i*.5);
Check(r.Completed && r.Target?.Command=="summon carbuncle","A card id is a rhythm word for its spell");
r.TakeCompleted(35.5);r.Press('s',36);r.Press('u',36.5);
Check(r.Matches.Count(m=>m.Phrase=="summon ruby")==1 && r.Matches.First(m=>m.Phrase=="summon ruby").Name=="Summon Ruby","Duplicate words keep the first (full phrase) entry");

var targetDeck = RhythmTargetPhrases.Expand(deck.Concat(summons).Concat(branching));
RhythmRound TypeTargetPhrase(string phrase)
{
    var round = new RhythmRound();
    Check(round.Start(targetDeck, 10, .5), "Targeted rhythm deck starts");
    for (var i = 0; i < phrase.Length; i++) {
        Check(round.Press(phrase[i], 10 + i * .5) == RhythmRound.Grade.Perfect, "Target, space and spell all use the beat: " + phrase);
        if (i < phrase.Length - 1) Check(!round.Completed, "A partial target phrase cannot queue a rune: " + phrase);
    }
    return round;
}
var tankPhrase = TypeTargetPhrase("tank physick");
Check(tankPhrase.Completed && tankPhrase.Target?.Command == "on tank physick" && tankPhrase.Target.Id == "physick",
    "The whole target and spell produce one explicitly aimed command");
Check(tankPhrase.Hits == 12 && tankPhrase.Score == 1200 && tankPhrase.Target!.Name.Contains("TANK"),
    "The target and separator count toward the rhythm score and appear in the completion label");
var aimedWeave = new SpellWeave(); aimedWeave.SelectNextTarget("party3");
var tankSpell = tankPhrase.TakeCompleted(15.5)!;
Check(aimedWeave.Add(tankSpell.Command!, tankSpell.Id), "Completed target phrase fits in the queue");
aimedWeave.Interrupt("Queued");
Check(aimedWeave.Runes.Count == 1 && aimedWeave.Next == null && aimedWeave.InFlight == null && aimedWeave.NextTarget == "tank",
    "Targeted rhythm completion queues exactly one rune and remembers its target without casting");
aimedWeave.Add("physick", "physick");
Check(aimedWeave.Runes[1].Command == "physick" && aimedWeave.Runes[1].TargetOverride == "tank",
    "The next untargeted spell reuses the previous target");
var restoredAim = new SpellWeave(); restoredAim.Restore(aimedWeave.SaveState()); restoredAim.Repeat();
Check(restoredAim.Runes[0].Command == "on tank physick" && restoredAim.Next?.CardId == "physick",
    "The target remains part of the spell through reload and repeat");
foreach (var (phrase, command) in new[] { ("party2 physick", "on party2 physick"), ("on focus physick", "on focus physick"),
    ("self sc", "on self summon carbuncle"), ("ot physick", "on tank2 physick"), ("tot physick", "on targetOfTarget physick") }) {
    var round = TypeTargetPhrase(phrase);
    Check(round.Completed && round.Target?.Command == command, "Targeting preserves aliases, ids and canonical spell commands: " + phrase);
}
var shortTarget = TypeTargetPhrase("enemy ruin");
Check(!shortTarget.Completed && shortTarget.NextLetters.Contains("SPACE"), "Targeted spells preserve longer-name disambiguation");
Check(shortTarget.Commit(15) && shortTarget.Target?.Command == "on enemy ruin", "Enter commits an exact targeted shorter spell");
var longTarget = TypeTargetPhrase("enemy ruin ii");
Check(longTarget.Completed && longTarget.Target?.Command == "on enemy ruin ii", "The longer targeted spell requires every timed character");
var brokenTarget = TypeTargetPhrase("tank phy");
Check(brokenTarget.Press('x', 14) == RhythmRound.Grade.Wrong && brokenTarget.Prefix == "" && brokenTarget.Target == null,
    "A wrong spell letter clears the target too");
foreach (var (ch, i) in "physick".Select((ch, i) => (ch, i))) brokenTarget.Press(ch, 14.5 + i * .5);
Check(brokenTarget.Completed && brokenTarget.Target?.Command == null && brokenTarget.Target?.Phrase == "physick",
    "A failed target phrase cannot aim a later plain spell");
var missedSpace = TypeTargetPhrase("tank");
Check(!missedSpace.Commit(11.6), "Typing just a target cannot queue or select anything");
Check(missedSpace.Press(' ', 11.7) == RhythmRound.Grade.Early && missedSpace.Prefix == "", "The separator has the same timing requirement as letters");
var missedTarget = TypeTargetPhrase("tank phy"); missedTarget.Tick(14.3);
Check(missedTarget.LastGrade == RhythmRound.Grade.Miss && missedTarget.Prefix == "" && missedTarget.Target == null,
    "A missed pulse resets the entire targeted spell");
var pausedTarget = TypeTargetPhrase("tank "); pausedTarget.Pause(12.1); pausedTarget.Resume(30);
foreach (var (ch, i) in "physick".Select((ch, i) => (ch, i))) pausedTarget.Press(ch, 30 + i * .5);
Check(pausedTarget.Completed && pausedTarget.Target?.Command == "on tank physick", "Pause preserves the target within the unfinished phrase");
var erasedTarget = TypeTargetPhrase("party2 phy"); erasedTarget.Restart(15);
Check(erasedTarget.Prefix == "" && erasedTarget.Target == null && erasedTarget.Misses == 0, "Backspace resets the target and spell together");
var collision = RhythmTargetPhrases.Expand([new("custom", "tank physick", "Custom"), new("physick", "physick", "Physick")]);
Check(collision.Single(s => s.Phrase == "tank physick").Id == "custom", "Generated target phrases cannot shadow a full spell name");
var maximumName = new string('x', 64);
var longDeck = RhythmTargetPhrases.Expand([new("long", maximumName, "Long")]);
var longRound = new RhythmRound(); longRound.Start(longDeck, 1, .5);
Check(longRound.Matches.Any(s => s.Phrase == "on targetoftarget " + maximumName), "Every existing maximum-length spell can still receive a target prefix");
Console.WriteLine("PASS rhythm target phrases, timed spaces, whole-phrase resets, aliases, ambiguity and repeat/reload persistence");

var weave=new SpellWeave();
weave.Add("ruin","ruin");weave.Interrupt("Queued");
Check(weave.Next==null && weave.InFlight==null,"Completing rhythm spelling never casts");
weave.Backspace();Check(weave.Runes.Count==0,"The visible undo action removes the last queued spell");
weave.Add("raise","raise");weave.Interrupt("Queued");weave.Resume();
Check(!weave.InputMode && weave.Next?.CardId=="raise","Only explicit continuation releases movement and starts casting");

Check(RhythmPulse.Radius(0,.5)==1,"The reverse pulse meets the receptor exactly at the beat timestamp");
Check(Math.Abs(RhythmPulse.Radius(.5,.5)-1.9)<.00001,"The approach begins outside the target ring");
Check(RhythmPulse.Radius(.2,.5)>RhythmPulse.Radius(.1,.5) && RhythmPulse.Radius(-.05,.5)<1,"The pulse contracts through the target, rather than freezing short of it");
Check(Math.Abs(RhythmPulse.Radius(.2,.4)-RhythmPulse.Radius(.4,.8))<.00001,"Irregular musical intervals retain the same visual timing phase");
Check(Math.Abs(RhythmPulse.Radius(10-(10.1-.1),.5)-1)<.00001,"Visual contact uses the same latency-calibrated clock as key grading");
Check(double.IsFinite(RhythmPulse.Radius(1,double.NaN)),"Missing tempo cannot corrupt native ring geometry");
var zone=RhythmPulse.SafeZone(.18,.5);
Check(zone.Inner<1 && zone.Outer>1 && zone.Outer-zone.Inner>.6,"The full valid timing band is visibly broad around the perfect ring");
foreach(var offset in new[]{-.21,-.179,-.1,0,.1,.179,.21}) {
 var radius=RhythmPulse.Radius(-offset,.5);
 var depicted=radius>=zone.Inner && radius<=zone.Outer;
 var sample=new RhythmRound();sample.Start(deck,10,.5);
 var grade=sample.Press('r',10+offset);
 var accepted=grade is RhythmRound.Grade.Perfect or RhythmRound.Grade.Great or RhythmRound.Grade.Good;
 Check(depicted==accepted,"Shaded safe zone and key grading agree before and after the ideal time");
}
Console.WriteLine("PASS free spelling, whole-word resets, pause, future music, reverse pulse and accurate full-window safe-zone depiction");
RadialTests.Run();
