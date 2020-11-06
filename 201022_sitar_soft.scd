t = TempoClock.default
t.tempo_(60/60)

(
~tonica = 0;
~root = 2; // D
)


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);
s.meter

// it seems to me that major sitar arpeggio are those with indexes:
// 1, 2, 4, 6
(
Pbindef(\sitar,
	\instrument,\bplaym,
	\buf, Pindex( ~dirt["sitar"], Prand([1,2,4,6],inf), inf),
	\dur, Prand([7,11,13],inf),
	\amp, 0.5,
	\rel, 15,
	\rate, 1,
	\addAction,0
).quant_(4).play;
)
Pbindef(\sitar).stop;


(
Pbindef(\tabla,
	\instrument,\bplay,
	\buf, Pindex(~dirt["tabla"], Prand((0..~dirt["tabla"].size-1),inf), inf),
	\dur, Prand([1,2,4], inf) * 4,
	\amp, Pgauss(0.5, 0.1, inf),
	\rel,15,
	\rate,1,
	\addAction,1
).quant_([4, 0.5] ).stop.play;
)

//some sort of glithes
(
Pbindef(\yeah,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["yeah"], Prand((0..~dirt["yeah"].size-1),inf), inf),
	\dur, 0.25,
	\amp, Pgauss(0.5, 0.1, inf),
	\rel,1,
	\rate,1,
	\addAction,1
).quant_(4).play;
)
Pbindef(\yeah).stop;


(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Prand([4,5,6], inf),
	\degree, Pfunc({~tonica}) + Pseq([0,4],inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf),
	\fb, 0.5,
	\amp, 0.02,
	\atk, 2,
	\rel, 2,
	\dur, 0.125,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).play;
)

Pbindef(\pads).stop
Pbindef(\pads, \fb, 1.3);

Control

(
Pbindef(\bass,
	\instrument, \ring1,
	\root, Pfunc({~root}),
	\octave, 1 + [3,4,7],
	\degree, Pfunc({~tonica}) + Pseq([
		Pseq([-2,-5,-4], 1), // Bm7 | F#m7 | G
		Pseq([0,-3,-4], 1),  // D   | A    | G
		Pseq([0,-3,-6], 1),  // D   | A    | Em
	],inf),
	\mtranspose, Pwhite(0.0, 0.02, inf) * [0, 0, 1],
	\dist, 4,
	\amp, 0.3 * [1,1,0.125],
	\atk, 0.01,
	\dur, Pseq([2,2,8], inf),
	\rel, Pkey(\dur) * t.beatDur * 2,
	\pan, [0, 0, Pseq([-1, 1], inf).asStream],
	\addAction,0
).quant_([4,0]).play;
)
Pbindef(\bass).stop




(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,0.5,\rel,0.4,\rate,0.7,\addAction,0).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,2,\amp,0.6,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,2,\rel, 0.05, \rate, 2,\amp, Pgauss(0.4,0.01, inf)).quant_([4, 0.5]).play;
)

Pbindef(\k).stop; Pbindef(\s).stop;



(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.5,\rel,0.4,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,2,\amp,0.6,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,2,\rel, 0.05, \rate, 2,\amp, Pgauss(0.4,0.01, inf)).quant_([4, 0.5]).play;
)

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pwrand([1, Pn(0.5, 2), Pseq([0.25, 0.75],1)],[10,1,3].normalizeSum, inf),\amp,0.5,\rel,0.4,\rate,0.7,\addAction,1).quant_(4).play;




(
Pbindef(\melody,
	\instrument, \fm4_perc,
	\root, Pfunc({~root}),
	\octave, Prand([5,6], inf),
	\degree, Pfunc({~tonica}) + Pseq([0,1],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, Pseg([0.1, 0.3], [4],\lin, inf),
	\atk, 0.2,
	\rel, 0.01,
	\dur, 0.25,
	\n1, Prand([1,2], inf), //Pseg([1,4], [8], \lin, inf).round(0.125),
	\n2, Prand([2,3,4,5,6,7,8], inf),
	\mi, Pseg([10, 5000], [2], \exp, inf),
	\iatk, 0.0,
	\irel, 0.05,
	\iAdd, 0,
	\pan, Pseq([-1.0, 1.0], inf),
	\lag, Pwhite(0.0, 0.025, inf),
	\addAction, 0
).quant_([4,0.5]).stop.play;
)


Pbindef(\melody).stop;


(
Pbindef(\speak,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["speech"], Prand((0..~dirt["speech"].size-1),inf), inf),
	\dur, Prand([0.25, 0.5], inf),
	\amp,0.125,
	\rel,10,
	\rate,1.3,
	\addAction, 0 //Prand([0,1], inf)
).quant_(4).play;
)
Pbindef(\speak).stop;

(
Pbindef(\sinfb, \fb, 0.6);
Pbindef(\melody).stop;
Pbindef(\k).stop; Pbindef(\s).stop;Pbindef(\hh).stop;
Pbindef(\speak).stop;
Pbindef(\bass).stop;
)

Pbindef.gui
