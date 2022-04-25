


(
Pbindef(\B,
	\instrument, \glitch2,
	\dur, Pbjorklund2(3,4,inf,Prand([2,4],inf).asStream)/4,
	\amp, 5,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf),
	\lag, 0.0 //0.112
).quant_(1);
);

(
SynthDef(\glitch2, {
	|amp=1.0,out=0, pan=0.0|
	var sig = Resonz.ar(Impulse.ar(0), freq:77, bwr:300) * amp;
	sig = sig.softclip;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

Pbindef(\B).stop;
Pbindef(\B).play;

~verb = Synth(\verb, [\dec,4, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

s.plotTree

(
Pbindef(\A,
	\instrument, \glicth1,
	\scale, Scale.minor,
	\octave, 3,
	\degree, 0, //Pxrand([0,2,4],inf),
	\dur, Prand([0.25, 0.125],inf), //Prand([Pn(0.25,2),Pn(0.125,2)],inf),
	\decay, Pexprand(0.1, 0.001, inf),
	\amp, 1, //Pwhite(0.3, 0.9, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf)
).quant_(1);
);

(
SynthDef(\glicth1, {
	|freq=440,amp=1.0
	rf=1000, q=1,
	decay=1,
	out=0, pan=0.0
	|
	var sig = Impulse.ar(0);
	sig = Ringz.ar(sig, freq, decay) * amp;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

Pbindef(\A).clear;
Pbindef(\A).play;
Pbindef(\A).stop;

(
SynthDef(\hiSin, {
	|freq=16000, atk=1,rel=0, out=0, amp=1.0|
	var env =EnvGen.ar(Env.perc(atk, rel, curve:[4,-4]), doneAction:2);
	var sig = SinOsc.ar(freq, [0.0, 0.5pi], mul:env) * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\hiSin)

(
Pbindef(\hi,
	\instrument, \hiSin,
	\freq, 16000,
	\amp, 0.4,
	\dur, 2,
	\atk, Pkey(\dur),
	\rel, 0.0,
	\pan, Pseq([-1.0, 1.0], inf)
)
)
Pbindef(\hi).play;
Pbindef(\hi).stop;

(
Pbindef(\lo,
	\instrument, \hiSin,
	\freq, 60,
	\amp, 1,
	\dur, 6,
	\addAction,1
)
)
Pbindef(\lo).play;
Pbindef(\lo).stop;


(
Pbindef(\chirp,
	\instrument, \hiSin,
	\freq, 14000, //Pexprand(14000, 17000, inf),
	\amp, 0.8,
	\atk,0.0,
	\rel, 0.001,
	\dur, Pseq([Pn(0.125,Prand((3..5),inf).asStream), 4], inf)
)
)
Pbindef(\chirp).play;
Pbindef(\chirp).stop;


(
SynthDef(\movingnoise, {
	|amp=0.1, out=0,dur=1|
	var env = EnvGen.ar(Env.perc(0, dur, curve:[-4,4]), doneAction:2);
	var sig = RLPF.ar(LFNoise0.ar(1000,mul: env) * amp, 10000, 0.001);
	var start = [-1, 1].choose;
	var end   = start * (-1);
	Out.ar(out, Pan2.ar(sig, Line.kr(start, end, dur)));
}).add;
)

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

(
Pbindef(\mnoise,
	\instrument, \movingnoise,
	\amp, 0.1,
	\dur, 0.125,
	\addAction, 0
)
)

StageLimiter.activate
Pbindef(\mnoise).stop;
Pbindef(\mnoise).play

Pbindef.gui