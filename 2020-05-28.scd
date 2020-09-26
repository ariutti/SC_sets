TempoClock.default.tempo_(135/60)

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1.25, 0.5,0.75,1.5],inf),\amp,4,\rel,0.25,\rate,0.6,\addAction,1, \lag,Pwhite(0.0, 0.02, inf)).quant_(4).play;

Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pseq([0.5, 1.5,2],inf),\amp,2,\rel,0.6,\rate,0.7,\addAction,Pwrand([1,0],[5,1].normalizeSum,inf),\lag, Pwhite(0.0, 0.02, inf)).quant_([4,1]).play;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,Pseq([0.5,0.5,0.25,0.5,0.25,0.25,0.75,1], inf),\amp,1, \rate, Pseq([1,1,1,0.5,0.5,1,0.5,0.45],inf), \rel, 0.02,\lag, Pwhite(0.0, 0.02, inf),\addAction, 0).quant_([4,0.5]).play;
)

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,4,\rel,0.25,\rate,0.6,\addAction,1,\lag, 0.0).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,0.7,\rel,0.1,\rate,0.7,\addAction,1,\lag, 0.0).quant_([4,1]).play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)*0.7,\lag, 0.0).quant_(4).play;
)


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1.25, 0.5,0.75,1.5],inf),\amp,1,\rel,0.25,\rate,0.6,\addAction,1, \lag,Pwhite(0.0, 0.02, inf)).quant_(4).play;



(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\lo).stop;
)

s.plotTree;
StageLimiter.activate;


(
Pbindef(\pads,
	\instrument, \fm4,
	\scale, Scale.minor,
	\octave, Prand([[3,4,5], [3,5,6]], inf),
	\root, 5,
	\degree, Pseq([
		[0,2,4],
		Prand([[-1,1,3],[-1,2,6]],1),
		Pseq([[-3,-1,2]],1),
		Prand([[-2,0,2]], 1)
	], inf),
	\n1,1,
	\n2, Prand((1..10),inf).clump(3),
	\mi, Pexprand(500, 5000, inf).clump(3),
	\iatk,0.01,\irel,2,
	\iAdd, Pwhite(1,3,inf).clump(3),
	\dur, Pseq([4,4,4,8], inf),
	\atk, Pkey(\dur)*0.5,
	\rel, Pkey(\dur)*1.5,
	\amp, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\pads).stop;
(
Pbindef(\pads, 	\n2, 2, //Prand((1..10),inf).clump(3),
	\mi, 100, //Pexprand(500, 5000, inf).clump(3),
	\iatk,0.01,\irel,2,
	\iAdd, 0, //Pwhite(1,3,inf).clump(3),)
	\amp, 0.4,
	\octave, [4,5,6]
)
)

(
Pbindef(\lead,
	\instrument, \fm4_perc,
	\scale, Scale.minor,
	\octave, Prand([4,5,6], inf),
	\root, 5,
	\n1,1,\n2,Prand([2,5,6,7,8,9],inf),
	\degree, Pseq([4], inf),
	\mi, 5000,\iatk,0.01,\irel,0.01,\iAdd,0,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.2,
	\dur, Pwrand([1, Pn(0.25,4)],[5,1].normalizeSum,inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction, Pwrand([1,0],[10,1].normalizeSum,inf)
).quant_([4,0]).play;
)
Pbindef(\lead).stop;
s.meter

t = TempoClock.default;
~delay = Synth(\delay1, [\lpf, 500, \delaytime, t.beatDur*0.25, \decaytime,1.0, \wet,1.0]);
~delay.free

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);


s.scope


(
Pbindef(\lo,
	\instrument, \distSin,
	\octave, 3,
	\root, 5,
	\degree, 0,
	\atk, 1 * t.beatDur,
	\rel, 0.0 * t.beatDur,
	\dist, 20,
	\amp, 1,
	\dur, 8,
	\addAction, 0
).quant_([4,3]).stop.play;
);
Pbindef(\lo).play;


(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\octave, [4,5,6],
	\root, 5,
	\degree, Pseq([
		[0,2,4],
		Prand([[-1,1,3],[-1,2,6]],1),
		Pseq([[-3,-1,2]],1),
		Prand([[-2,0,2]], 1)
	], inf),
	\fb, Pseq([0,0.25, 0.5, 1], inf), //Pwhite(0.1, 1.1, inf).clump(3),
	\dur, Pseq([4,4,4,4], inf),
	\atk, Pkey(\dur)*0.5,
	\rel, Pkey(\dur)*1.5,
	\amp, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 0
).quant_([4,0]).play;
)



(
Pbindef(\lead,
	\instrument, \squarebass,
	\scale, Scale.minor,
	\octave, Prand([3,4,5,6,7], inf),
	\degree, Prand([-1,0,4], inf),
	\root, 5,
	\width, Pseg([0.5,0.1], [4], \lin, inf), //Pwhite(1, 5, inf),
	\detune, Pseg([1,20], [4], \lin, inf), //Pwhite(1, 5, inf),
	\atk, 0.0,
	\rel, 0.25,
	\amp, 0.8,
	\dur, Pwrand([1, Pn(0.25,4)],[1,10].normalizeSum,inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction, Pwrand([1,0],[1,10].normalizeSum,inf),
).quant_([4,0]).play;
)

(
Pbindef(\lead,
	\instrument, \squarebass,
	\scale, Scale.minor,
	\octave, Prand([3,4,5,6,7], inf),
	\degree, Prand([-1,0,4], inf),
	\detune, 0,
	\width, 0.5,
	\dur, 0.25,
	\rel, 0.125,
	\addAction, 1,
	\pan, 1
)
)

Pbindef(\lead).stop;