TempoClock.default.tempo_(120/60);


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,0.5);


s.meter
(
Pbindef(\test,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, 2,
	\octave, Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pseq([0,4,7],inf),
	\fb, Pseg([0.2, 2.5, 0.2], [8,8], \lin, inf),
	\amp, 0.125,
	\atk, 0.0,
	\rel, 0.1, //Prand([0.2, 0.05], inf),
	\dur, 1, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, Prand([-0.8, 0.8], inf),
	\addAction, 0
).quant_([4,0]).play;
)

s.meter;
Pbindef(\test).stop;

Pbindef(\test)

"espeak -v it \"benvenuti \"".unixCmd;

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,3,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\k).stop;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.25,\amp,0.5,\rel,Pseq([Pn(0.02,16+15), 2],inf),\rate,1,\addAction,1).quant_([4]).stop.play;
Pbindef(\hh).stop;

Pbindef(\s,\instrument,\bplay,\buf,d["s"][1],\dur,2,\amp,1,\rel,0.1,\rate,0.6,\addAction,1).quant_([4, 1]).stop.play;
Pbindef(\s).stop;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][2],\dur,2,\amp,3,\rel,0.2,\rate,1,\addAction,1 ).quant_([4,1]).play;
