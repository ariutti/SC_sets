~dirt[\foldernames].do({|f| f.postln; });
~dirt["sitar"][0]//.do({|f| f.postln; });

~dirt["tabla"]

(
Pbindef(\sitar,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["sitar"], Prand((0..~dirt["sitar"].size-1),inf), inf),
	\dur,6,
	\amp,0.5,
	\rel,15,
	\rate,1,
	\addAction,1
).quant_(4).play;
)


(
Pbindef(\tabla,
	\instrument,\bplay,
	\buf, Pindex(~dirt["tabla"], Prand((0..~dirt["tabla"].size-1),inf), inf),
	\dur, Prand([1,2,4], inf),
	\amp, Pgauss(0.5, 0.1, inf),
	\rel,15,
	\rate,1,
	\addAction,1
).quant_(4).play;
)

(
Pbindef(\yeah,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["yeah"], Prand((0..~dirt["yeah"].size-1),inf), inf).trace,
	\dur, 0.25,
	\amp, Pgauss(0.5, 0.1, inf),
	\rel,1,
	\rate,1,
	\addAction,1
).quant_(4).play;
)

s.meter;


(
Pbindef(\sinfb,
	\instrument, \sinfb,
	\octave, Prand([4,5,6], inf),
	\degree, 1 + Pseq([0,4],inf),
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

Pbindef(\sinfb, \fb, 1.3);

(
Pbindef(\bass,
	\instrument, \ring1,
	\octave, [3,4],
	\degree, Pseq([1,1,-1,-2], inf),
	\dist, 4,
	\amp, 0.3,
	\atk, 0.01,
	\rel, 8,
	\dur,4,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).play;
)


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,0.5,\amp,0.5,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,1,\amp,0.6,\rel,0.2,\rate,0.7,\addAction,0).quant_([4,1]).play;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.125,\amp,Pexprand(0.05,1)*0.5).quant_(4).play;


Pbindef(\k).stop; Pbindef(\s).stop;

(
Pbindef(\melody,
	\instrument, \sinfb,
	\octave, Prand([5,6], inf),
	\degree, 1 + Pseq([0,1,7],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, 0.1,
	\atk, 0.01,
	\rel, 0.1,
	\dur, 0.125,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).play;
)


Pbindef(\melody).stop;


(
Pbindef(\speak,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["speech"], Prand((0..~dirt["speech"].size-1),inf), inf),
	\dur,0.25,
	\amp,0.25,
	\rel,10,
	\rate,1.3,
	\addAction, 0 //Prand([0,1], inf)
).quant_(4).play;
)

(
Pbindef(\sinfb, \fb, 0.6);
Pbindef(\melody).stop;
Pbindef(\k).stop; Pbindef(\s).stop;Pbindef(\hh).stop;
Pbindef(\speak).stop;
Pbindef(\bass).stop;
)

Pbindef.gui
