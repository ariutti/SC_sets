/*
* This sketch uses MIDI "noteOn" messages
* coming in to play some sounds
* using a SynthDef
*/

s.boot;


MIDIClient.init;
MIDIIn.connectAll;

// ADSR sounds ////////////////////////////////////////////////////////////////////////////
// for sustained sound we must keep track also of note off messages
// in order to send the "gate=0" message to the corresponding sounding synth

// in order to do that we need an array to keep track of all the instanciated synths
~notes = Array.newClear(128); // an array to store Synth refs
~midinotes_grp = Group(s, addAction:1);
s.plotTree

(
SynthDef.new(\susSynth, {
	arg freq=440, amp=0.5, gate=0, det=0.0, pan=0.0, dist=1, atk=0.01, dcy=0.1, sus=0.7, rel=0.1;
	var sig, env;
	sig = LFTri.ar( freq * det.midiratio); // stereo sound
	env = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction: 2);
	sig = sig * env;
	sig = (sig*dist).tanh * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

x = Synth.new(\susSynth, [\gate, 1]);
x.set(\gate, 0);
x.free;

(
MIDIdef.noteOn(\noteOnDef, {
	arg vel, note, ch, src;
	[note, vel, "on"].postln;
	~notes[note] = Synth.new(\susSynth, [
		\freq, note.midicps,
		\amp, vel.linlin(1, 127, 0.3, 0.09) * 0.5,
		\dist, vel.linexp(1, 127, 1, 20),
		\det, rrand(-0.05, 0.05),
		\pan, rrand(-1.0, 1.0),
		\rel, 0.1,
		\gate, 1
	],~midinotes_grp);
});

MIDIdef.noteOff(\noteOffDef, {
	arg vel, note, ch, src;
	[note, vel, "off"].postln;
	~notes[note].set(\gate, 0);
	~notes[note] = nil;
});
)

s.plotTree
~midinotes_grp.freeAll;
~midinotes_grp.free

(
a = Synth.basicNew(\susSynth, nodeID:1800);
a.free;
)