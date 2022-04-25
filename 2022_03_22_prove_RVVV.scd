Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,Pseq([2.25, 1.75], inf),\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,0.5,\addAction,1).quant_([4,1]).play;


Pbindef.gui


(
Pbindef(\k).stop;
Pbindef(\hh).stop;
Pbindef(\s).stop;
Pbindef(\A).stop;
Pbindef(\B).stop;
)



(
Pbindef(\k).play;
Pbindef(\hh).play;
Pbindef(\s).play;
Pbindef(\A).play;
Pbindef(\B).play;
)

Pbindef(\B).play;
Pbindef(\B).stop;

Pbindef(\pads).stop;

Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1], \amp, 24, \rel, 0.6);//,\dur,8,\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(4).stop.play;

Pbindef(\pads).stop;


(
Pbindef(\pads).stop;
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\octave, Pseq([[5,6,7]], inf).clump(3),
	\root, 0,
	\mtranspose, Pwhite(0.0, 0.02, inf).clump(3),
	\degree, Pseq(
		[
			Pseq([[0,4,7]], 4), // Cm
			Pseq([[-1,1,3]],4), // Bb
			//Pseq([[0,3,5]],8), // Dm II rivolto
			//Pseq([[1,4,6]],2), // C
		]
	,inf),
	\fb, Pwhite(0.2, 0.6, inf).clump(3),
	\amp, 0.1,
	\atk, 0.01,
	\rel, 1,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\dur, 1,
	\addAction,0
).quant_([4]).play;
)
Pbindef(\pads,\degree, Pseq([[0,4,7]],inf)).play; // Cm
Pbindef(\pads,\degree, Pseq([[-1,1,3]],inf)).play; // Bb
Pbindef(\pads,\degree, Pseq([[1,4,6]],inf)).play; // Gm