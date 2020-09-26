(
SynthDef(\saw, {
	|out=0, amp=1.0, dur=1, freq=440, width=0.5, pan=0.0,atk=1, rel=1|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = RLPF.ar(Pulse.ar(freq, LFNoise2.kr(1).range(0.1,0.5)),freq*LFNoise2.kr(1).range(2,7), 0.9);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)



[-1,2,4], [-1,2,5],[-1,2,3]//[0,2,4], //[0, 3,6],
(
Pbindef(\pads,
	\instrument, \saw,
	\scale, Scale.minor,
	\octave, Pseq([[3,4,5]],inf),
	\degree, 0, //Pstutter(8, Pseq([0,-1,-2,-1],inf)) + Pseq([[0,2,4]],inf), // [-2,2,4]
	\detune, Pwhite(0.0, 1).clump(3),
	\atk, Pwhite(2,4,inf).clump(3),
	\rel, Pwhite(2,4,inf).clump(3),
	\amp, 0.1,
	\dur, 1,
	\width, Pwhite(0.1, 0.5, inf).clump(3),
	\pan, Pwhite(-1.0 ,1.0 ,inf).clump(3),
	\addAction, 1
).quant_(4);
)
Pbindef(\pads).play
Pbindef(\pads).stop
Pbindef(\pads).clear

s.plotTree
s.scope
s.meter


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,3, \lpf,1500, \wet,1.0);

Pbindef.gui;