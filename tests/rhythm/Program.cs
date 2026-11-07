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
Check(r.Start(deck[0], deck, 4, .5), "Valid spell chart starts");
Check(r.Notes.All(n => n.Choices.Length == 4 && n.Choices.Distinct().Count() == 4 && n.Choices[n.Lane] == n.Letter), "Every note has exactly four unique lanes and one target");
Check(RhythmRound.Choices("r",'u',deck).Contains('a'), "Available completion branches precede decoys");
Check(RhythmRound.Choices("ruin",'x',[]).Distinct().Count() == 4, "No completions still supplies three distinct decoys");
Check(r.Press('r',3) == RhythmRound.Grade.Early && r.Cursor == 0, "Early typing never spends a note");
Check(r.Press('r',4) == RhythmRound.Grade.Perfect, "Keyboard spelling earns timing grades");
Check(r.Press('z',4.5) == RhythmRound.Grade.Wrong && r.Cursor == 1 && r.Combo == 0, "Wrong letter preserves the expected letter");
Check(r.PressLane(r.Notes[1].Lane,4.5) == RhythmRound.Grade.Perfect, "Controller chooses the correct letter in time");
r.Tick(5.3);
var retry = r.Notes[2].Due;
Check(r.Cursor == 2 && r.Misses == 2 && retry > 5.3, "Missing a beat reschedules the untyped letter");
r.Press('i',retry); r.Press('n',r.Notes[3].Due);
Check(r.Completed && r.Hits == 4 && r.BestCombo >= 2, "A recovered round completes only after every letter is hit");
Check(r.Press('n',20) == RhythmRound.Grade.None, "Completed notes cannot be replayed by duplicate inputs");

r.Start(deck[0],deck,30,.5); r.Press('r',30); r.Pause(30.1);
Check(r.Press('u',30.5) == RhythmRound.Grade.None, "Paused mode cannot consume input");
r.Tick(100); Check(r.Misses == 0, "A suspended chart cannot accumulate misses");
r.Resume(101); Check(r.Cursor == 1 && r.Notes[1].Due == 101 && r.Notes[3].Due == 102, "Resume preserves prefix and re-arms the future chart");
r.LatencyMs = 100;
Check(r.Press('u',101.1) == RhythmRound.Grade.Perfect, "Latency compensation applies to keyboard and pad scoring");
Check(r.Press('i',100) == RhythmRound.Grade.None, "Out-of-order events cannot consume later notes");
r.Tick(102); var next = r.Notes[2].Due; r.Tick(next + .3);
Check(Math.Abs((r.Notes[3].Due - r.Notes[2].Due) - .5) < 1e-6, "Repeated late frames retain chart spacing");
Check(!r.Start(deck[0] with { Phrase = "\n" },deck,1,.5), "Control characters rejected");
Check(!r.Start(deck[0],deck,1,double.NaN), "Invalid timing rejected");

// Musical construction cannot authorize gameplay. The real adapter uses this
// same queue path; only explicit playback transitions expose a queued rune.
var weave = new SpellWeave();
weave.Add("ruin","ruin"); weave.Interrupt("Rhythm woven"); weave.EnterControl();
Check(weave.Next == null && weave.InFlight == null, "Completed spelling stays paused");
weave.Resume();
Check(!weave.InputMode && weave.Next?.CardId == "ruin", "Explicit continuation keeps keyboard free for movement");
Console.WriteLine("PASS music onset estimation, source reset, tap tempo, four-lane completion choices, timing grades, retry, pause, calibration and modal casting");
