(
Pbindef(\mel,
	\instrument, \fm4_perc,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Prand([3,4],inf).clump(3),
	\degree, Prand([0,4], inf), //0 + Pseq([[0,4]],inf),
	\dur, 8,
	\n1, 2, //Prand([2,3,4,5],inf),
	\n2, Prand([3,4,5],inf),
	\mi, 500,
	\atk, 1, \rel, 6,
	\amp, 0.05, //Pseq([1,0.5, 0.5], inf) * 0.4,
	\pan, Pseq([-1.0, 1.0], inf), //Pseg([-1.0, 1.0, -10], [2,2], \lin, inf),
	\addAction, 0, //Prand([0,1],inf)
).quant_([4,1]).play;
)
Pbindef(\mel).stop;

s.scope

~scale = Scale.minor;
~root = 4;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,1.0);

(
Pbindef(\voice,
	\instrument, \squarebass,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, 4, //Prand([3,4,5],inf),
	\width, Pseg([0.1, 0.5, 0.1], [4,4], \lin, inf),
	\mtranspose, Pseg([0, 2],[8], \lin, inf),
	\detune, 0.0, //Pseg([0, 12],[8], \lin, inf),//Pseg([0, 12],[8], \lin, inf),
	\degree, Pseq([Pn(0,7),7], inf), //Pseq([0,4], inf).collect({|n| [n, n+4]}), //0 + Pseq([[0,4]],inf),
	\dur, 0.25,
	\atk, 0.01, \rel, 0.3,
	\amp, 0.25, //Pseq([1,0.5, 0.5], inf) * 0.4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(2), //Pseq([-1.0, 1.0], inf), //Pseg([-1.0, 1.0, -10], [2,2], \lin, inf),
	\addAction, 1
).quant_([4,1]).play;
)


Pbindef(\voice).stop;

Pbindef(\voice).stop;


(
Pbindef(\voice,
	\instrument, \fm4_perc,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Prand([3,4,5,6],inf),
	\degree, 0 + Pseq([0,1,[4,7]],inf).collect({|n| [n, n+2, n+7, n+2]}), //0 + Pseq([[0,4]],inf),
	\dur, 0.5,//Prand([0.5, Pn(0.25,2), Pn(0.125, 4)], inf),
	\n1, 4, //Prand([2,3,4,5],inf),
	\n2, 2, //Prand([3,4,5],inf),
	\mi, Pseg([500, 1000], [4], \lin, inf),
	\atk, 0.0, \rel, 0.1,
	\amp, 0.125 * 1, //Pseq([1,0.5, 0.5], inf) * 0.4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(4), //Pseq([-1.0, 1.0], inf), //Pseg([-1.0, 1.0, -10], [2,2], \lin, inf),
	\addAction, Prand([0,1], inf).clump(4),
	\strum, Pwhite(0.0, 0.01, inf)
).quant_([4,0]).play;
)




(
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,1,\amp,8,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][1],\dur,1,\atk, 0.0, \rel,0.1, \rate, 2,\amp, Pgauss(0.9,0.1, inf) * 0.5, \addAction, 1).quant_([4,0.5]).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,2,\amp,1,\rate,0.5,\rel,0.1,\addAction, 1).quant_([4,1]).play;
)

(
Pbindef(\k).stop;
Pbindef(\voice).stop;
Pbindef(\hh).stop;
Pbindef(\s).stop;
)

(



Pbindef(\voice).play;
Pbindef(\hh).play;
Pbindef(\s).play;
)


(
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 0.7,\rel,0.125,\rate,1.1 * Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.0, inf),\strum, Pwhite(0.0, 0.05, inf), \pan, [-1, 1]).quant_([4,1]).stop.play;
)

Pbindef(\clap).stop;



(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5, detune=0.1,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	sig = LFPulse.ar(freq + LFNoise1.ar(10, detune), width:width).bipolar;
	sig = sig * env * amp;
	//sig = Decimator.ar(sig, 11025, 8);
	sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


(
SynthDef(\doublebass, {
	|freq=440, pan=0.0, amp=1.0, out=0
	atk=0.05, rel=0.2, fc=67|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = Pulse.ar(freq, 0.3);
	sig = LPF.ar(sig, fc);
	sig = sig * env * amp * 2;
	sig = LeakDC.ar(sig);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);



(
Pbindef(\voice,
	\instrument, \doublebass,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, 3, //Prand([3,4,5],inf),
	\mtranspose, 0,
	\degree, 0 , //Pseq([0,4], inf).collect({|n| [n, n+4]}), //0 + Pseq([[0,4]],inf),
	\dur, 0.5,
	\atk, 0.01, \rel, 0.5,
	\amp, 5, //Pseq([1,0.5, 0.5], inf) * 0.4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(2), //Pseq([-1.0, 1.0], inf), //Pseg([-1.0, 1.0, -10], [2,2], \lin, inf),
	\addAction, 1
).quant_([4,1]).stop.play;
)

Pbindef(\voice).stop;

t.tempo_(116/60)
(
Pbindef(\acid,
	\instrument, \acid,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Prand([3], inf),
	\mtranspose, 0, //Pseg([0,1], [8], \lin, inf),
	\degree, 0, //Pseq([0,1,7,-1],inf), //, //[0,2,4], //[0, 3,6], //Pseq([0,7],inf),
	\amp, 1,
	\atk, 0.0, \rel, 1,
	\fatk, 0.0,  \frel, 0.05,
	\dur, 1,
	\famp, 18, //Prand([2,3,4,5,6], inf) , //Pseries(1,0.25, inf).fold(1,8),
	\legato, 0.125,
	\addAction,1
).quant_(1).play;
)

(
Pbindef(\hh).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,2,\amp,0.5,\rate,0.5,\rel,0.1,\addAction, 1).quant_([4,1]).play;
)

s.scope

(
Pbindef(\acid).clear;
Pbindef(\k).stop;
Pbindef(\voice).stop;
)
(
Pbindef(\hh).stop;
Pbindef(\s).stop;
)
