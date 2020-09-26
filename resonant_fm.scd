(
SynthDef(\fm1, {
	|
	out=0, amp=1.0, freq=440, pan=0.0,
	atk=0.01, rel=0.25,
	mi=0, ma=1, rq=1.0, rf=6
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = SinOsc.ar(freq + SinOsc.ar(freq*ma, mul:mi));
	sig = RLPF.ar(sig, SinOsc.kr( rf ).range(freq, freq*8), rq);
	sig = (sig.tanh * env * amp);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\fm,
	\instrument, \fm1,
	\scale, Scale.minor,
	\octave, Prand([[2,3,4]], inf),
	\root, 0,
	\degree, 0, //Pslide([0,4,0,5,0,6,0,7], inf, 1),
	\atk, 0.0,
	\dur, 0.125, //Pbjorklund2(Prand((1..3),inf), 8, inf)/8,
	\rel, 0.6, //1/(Pkey(\dur)*8),
	\rq, 0.1,
	\rf, 0.125,
	\mi, Pslide((10..1000),inf,1), //Pwhite(0.0, 1000, inf).clump(4),
	\ma, Prand([1,2,3,4], inf).clump(4), //Pwhite(1, 1000, inf),
	\pan, Pwhite(-0.8, 0.8,inf).clump(4),
	\amp, Pgauss(0.2, 0.01,inf).clump(4)
);
)

Pbindef(\fm, \amp, Pseg(Pseq([0.6, 0.8],inf), Pseq([3,7],inf), \linear)*0.5);
Pbindef(\fm, \mi, Pseg(Pseq([10, 1000],inf), Pseq([7,2],inf), \linear));
Pbindef(\fm, \rf, Pseg(Pseq([1.0, 0.01],inf), Pseq([4,5],inf), \linear));

s.meter;
s.freqscope
s.scope

Pbindef(\fm).play;


