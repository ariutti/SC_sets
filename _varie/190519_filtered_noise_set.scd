// SET NOISE FILTERED

(
SynthDef(\fnoise, {
	|out=0, freq=440, rq=0.1, amp=1.0, pan=0.0, dur=1|
	var sig, env;
	env = EnvGen.ar(Env.triangle(dur), doneAction:2);
	sig = Decay2.ar(Dust.ar(1), 0.01, 0.1);
	sig = sig * BPF.ar(PinkNoise.ar(), freq, rq);
	//sig = BPF.ar(PinkNoise.ar(), freq, rq);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

s.plotTree;
p.push
(
~e[0] = Ppar(Pbind(
	\instrument, \fnoise,
	\octave, Prand((2..8),inf),
	\scale, Scale.minor,
	\degree, 0, //Pwrand([0,3,5],[2,1,0.5].normalizeSum, inf), //Prand([1,5],inf)-1,
	\detune, Pwhite(-10, 10, inf),
	\dur, 5,
	\pan, Pwhite(-0.8, 0.8, inf),
	\amp, 20,
	\rq, Pwhite(0.001, 0.005)).dup(1)
,inf);
)
~e.play;
~e.clear
~e[1] = \filter -> {|in| GVerb.ar(in, 100, 1)}
