t = TempoClock.default
t.tempo_(120/60)

(
Pbindef(\notes,
	\instrument, \ring1,
	\scale, Scale.minor,
	\octave, [4,5],
	\root, 2,
	\degree, Pseq([0,1,2,3],inf),
	\amp, 0.05,
	\atk, 0.01,
	\rel, 0.25, //t.beatDur * 0.3,
	\dist, 8.0,
	\dur, 1,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).play;
)


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1000, \wet,0.3);


~inout = Synth(\inout, [\in,2,\out,0,\amp,0.5],addAction:1);
~inout.set(\amp, 1);
~inout.free;





(
SynthDef(\myADSRsynth, {
	|
	amp=0.5, freq=300, rq=0.1, gate=0, out=0,
	atk=3, rel=3
	|
	var sig, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate:gate, doneAction:2);
	sig = PinkNoise.ar();
	sig = BPF.ar( sig , freq, rq);
	sig = sig * env * amp * 10;
	Out.ar(out, Pan2.ar(sig));
}).add;
)

(
// global variable to be used in other Pbinds
~note = 60;
// an array to keep track of instantiated synths
~keys = Array.newClear(128);
~damper = false;

MIDIIn.connectAll;
)
(
MIDIdef.noteOn(\noteOnDef, {
	arg vel, note, ch, src;
	~note = note;
	postln( note );
	~keys[note] = Synth.new(\myADSRsynth, [
		\gate, 1,
		\freq, (note).midicps,
		\rq, 0.01,
		\amp, vel/127.0,
		\atk, 0.5,
		\rel, 2,
		\out, 0
	], addAction:0
	);
});

MIDIdef.noteOff(\noteOffDef, {
	arg vel, note, ch, src;
	if( ~damper == false, {
		~keys[note].set(\gate, 0);
	});
});
)

MIDIdef.noteOn(\noteOnDef).free;
MIDIdef.noteOff(\noteOffDef).free;


(
MIDIdef.cc(\sustain, {
	arg ...args;
	postln( args );
	if( args[0] == 127, {
		~damper = true;
	},
	{
		~damper = false;
		~keys.do({
			arg key;
			postln(key);
			key.free;
		});
	});
}, 64
)
)

~panic = {
}

MIDIdef.cc(\sustain).free

