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
Console.WriteLine("PASS free spell branching, whole-word resets, idle beats, timing, queue/delete, pause, future music and reverse-pulse alignment");
