// used to record the SC_190719_232809 audiofile
// used for the piece "Talk to me baby"

p = ProxySpace.push(s.boot);

s.meter;
(
SynthDef(\chime, {
	|
	freq=64, amp=0.125,	out=0, dur=1, pan=0.0, rq=0.1,gate=1
	atk=3,
	dcy=0.1,
	sus=0.7,
	rel=3
	|
	var sig, env;

	env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);

	sig = SinOsc.ar(freq);
	sig = sig * amp * env;
	sig = sig.softclip();
	Out.ar(out, Pan2.ar(sig,pan));
}).add;
)
(
~chimes = Pbind(
	\instrument, \chime,
	\octave, Prand([3,4,5,6,7],inf),
	\degree, Prand([0,4,7,2, 0,2,7,5, 0,3,5, 7], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, 0.125,
	\rq, 0.01, //Pseries(0.001, 0.001, inf).fold(0.001, 0.005),
	\dur, 0.0125,
	\atk, 0.1,
	\dcy, 0.01,
	\sus, 0.3,
	\rel, 1,
	\pan, Pwhite(-0.8, 0.8, inf),
	\lag, Pwhite(0.0, 0.02, inf)
);
)

~chimes.play(fadeTime:10);

(
SynthDef(\whistle, {
	|freq=256, amp=0.5, out=0, pan=0.0, atk=0.01, rel=3, mul=1, det=0.0|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(
		freq *
		Line.kr(0.0, 1.0, atk+rel).range(1,mul) +
		SinOsc.kr(10, mul:XLine.kr(0.001,det))
	) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
~whistles = Pbind(
	\instrument, \whistle,
	\amp, 0.1,
	\dur, 3,
	\mtranspose, Pwhite(-0.3, 0.3, inf),
	\octave, Prand([5,6,7], inf),
	\degree, Prand([0,2,4,6,7], inf),
	\mul, Pwhite(1.1, 9,inf),
	\det, 200,
	\pan, Pseq([-1, 1], inf)
)
)
~whistles.play;


(
SynthDef(\firefly, {
	|freq=256, amp=0.5, out=0, pan=0.0, atk=0.01, rel=3|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)
(
~firefly = Pbind(
	\instrument, \firefly,
	\octave, 6,
	\degree, Pseq([0, 2,4].pyramid(4), inf),
	\atk, 0.01, //Pwhite(0.01, 2, inf),
	\rel, 2,
	\dur, 0.5,
	\amp, 0.3
)
);
~firefly.quant_(4);
~firefly.play(fadeTime:10);
~firefly.stop(10);

(
SynthDef(\sad, {
	|
	freq=64, amp=0.125,	out=0, dur=1, pan=0.0, rq=0.1,gate=1
	atk=3,
	dcy=0.1,
	sus=0.7,
	rel=3
	|
	var sig, env;

	env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);
	sig = Pulse.ar(freq, 0.2) + SinOsc.ar(freq*2+1);
	sig = RLPF.ar(sig, freq*6, 2);
	sig = sig * amp * env;
	sig = sig.softclip();
	Out.ar(out, Pan2.ar(sig,pan));
}).add;
)

(
~bass = Pbind(
	\instrument, \sad,
	\octave, 3,
	\degree, Pseq([Pn(0,4), Pn(2,4), Pn(3,12) ], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, 0.5,
	\rq, 0.01, //Pseries(0.001, 0.001, inf).fold(0.001, 0.005),
	\dur, Pseq([0.5, 1], inf),
	\atk, 0.01,
	\dcy, 0.01,
	\sus, 0.7,
	\rel, 1,
	\pan, 0.0,
	\lag, Pwhite(0.0, 0.02, inf)
);
)
~bass.quant_(4);
~bass.play(fadeTime:10);

(
SynthDef(\noise, {
	|
	freq=64, amp=0.125,	out=0, dur=1, pan=0.0, rq=0.1,gate=1
	atk=3,
	dcy=0.1,
	sus=0.7,
	rel=3
	|
	var sig, env;

	env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);

	sig = PinkNoise.ar();
	sig = BPF.ar(sig, freq, rq);
	sig = sig * amp * env;
	sig = sig.softclip();
	Out.ar(out, Pan2.ar(sig,SinOsc.kr(0.1).range(-0.8, 0.8)));
}).add;
)

(
~solo = Pbind(
	\instrument, \noise,
	\octave, 7,
	\degree, Pseq([0, -1, -2], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, 40,
	\rq, 0.005, //Pseries(0.001, 0.001, inf).fold(0.001, 0.005),
	\dur, Pseq([3,3,9], inf),
	\atk, 1,
	\dcy, 0.1,
	\sus, 0.7,
	\rel, 4,
	\pan, 0.0,
	\lag, Pwhite(0.0, 0.02, inf)
);
)
~solo.quant_(4);
~solo.play(fadeTime:10);
~solo.stop(0.0);

(
~bass.play;
~firefly.play;
~chimes.play;
)

(
~bass.stop(0);
~firefly.stop;
~chimes.stop;
)
p.stop
p.gui
