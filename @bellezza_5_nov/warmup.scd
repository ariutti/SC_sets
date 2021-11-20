TempoClock.default.tempo_(96/60);

s.plotTree

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,0.5);

s.plotTree;
s.meter;

(
~scale = Scale.minor;
~root = 0;
)


(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0,rq=0.1
	|
	var env = EnvGen.ar(Env.triangle(dur*1.2), doneAction:2);
	var mamp = LFTri.kr(freq*0.0125*LFNoise0.kr(5).range(0.8,1.2)).range(0.5,5); //modulated amp
	var mwidth   = LFTri.kr(
		LFNoise1.kr(2).exprange(0.1, 2)
	).range(0.4, 0.6);
	var sig = VarSaw.ar(freq, width:mwidth, mul:mamp).squared.softclip;
	sig = RLPF.ar( sig+WhiteNoise.ar(0.2), freq*4,rq);
	//sig = HPF.ar(sig, freq * 0.25);
	//sig = CombN.ar(sig, 0.8, 0.2, 0.5);
	sig = LeakDC.ar(sig) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\pads,
	\instrument, \dist,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(5),
	\octave, Prand([3,4,5],inf).clump(5),
	\degree, Pseq([0,2,4,7], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(5),
	\amp, Pgauss(0.1, 0.01, inf).clump(5) * 1.5,
	\rq, Pwhite(2, 0.5, inf),
	\dur, Pseq([8, 4,4], inf),
	\addAction,0
).quant_(4).stop.play;
)

Pbindef(\pads).stop;
Pbindef(\pads).clear;


(
Pbindef(\melody,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, 0,
	\octave, Prand([5,6,7],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pseq([Pn(0, 7) ,[7,2], [7,3]],inf),
	\fb, Pseg([0.2, 2.5, 0.2], [8,8], \lin, inf),
	\amp, 0.3, //Pseg([0.0, 0.5, 0.0], [8,8],\lin, inf),
	\atk, 0.0,
	\rel, 0.1, //Prand([0.2, 0.05], inf),
	\dur, 0.5, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, Prand([-0.8, 0.8], inf),
	\addAction, 0//Pwrand([1, 0], [7,1].normalizeSum, inf)
).quant_([4,0]).play;
)

s.scope;
s.meter;
Pbindef(\melody).stop;


"espeak -v it \"benvenuti \"".unixCmd;

// DRUMS below

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,3,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\k).stop;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.25,\amp,0.3,\rel,Pseq([Pn(0.02,16+15), 2],inf),\rate,1,\addAction,1).quant_([4]).stop.play;
Pbindef(\hh).stop;

Pbindef(\s,\instrument,\bplay,\buf,d["s"][1],\dur,2,\amp,0.4,\rel,0.1,\rate,0.4,\addAction,1).quant_([4, 1]).stop.play;
Pbindef(\s).stop;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][2],\dur,2,\amp,3,\rel,0.2,\rate,1,\addAction,1 ).quant_([4,1]).play;


Pbindef.gui


// TODO

// midi definitions