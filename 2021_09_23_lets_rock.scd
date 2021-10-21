// 136 BPM
t = TempoClock.default;
t.tempo_(136/60);


Scale.directory



//~scale = Scale.iwato;
//~scale = Scale.whole;
~scale = Scale.iraq;


Pbindef(\agogo,\instrument,\bplaym,\buf,~dirt["drumtraks"][2],\dur,Pbjorklund2(5,8,inf,0)/2,\amp,0.7,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,1).quant_(4).play;
Pbindef(\agogo).stop;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,Pbjorklund2(5,8,inf,0)/4,\amp,0.3,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,1).quant_(4).play;
Pbindef(\hh).stop;

Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,4,\amp,2,\rel,0.1,\rate,1,\addAction,1).quant_(4).play;
Pbindef(\k).stop;
Pbindef(\s).stop;



Pbindef.gui;



~dirt.keys.do({|key| key.postln});

// more agressive
(
Pbindef(\agogo,\instrument,\bplaym,\buf,~dirt["drumtraks"][2],\dur,Pbjorklund2(5,8,inf,0)/2,\amp,0.7,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,1).quant_(4).play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,Pbjorklund2(5,8,inf,0)/4,\amp,0.3,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,1).quant_(4).play;
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,2,\amp,2,\rel,0.1,\rate,1,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][7],\dur,2,\amp,0.4,\rel,0.1,\rate,0.6,\addAction,1).quant_([4,1]).play;
)


~dirt["drumtraks"].size
Pbindef(\agogo).stop;
Pbindef(\agogo).play;


Pbindef(\r1,\instrument,\bplaym,\buf,~dirt["drumtraks"][9],\dur,Pseq([2, 2, Pn(0.5,4)], inf),\amp,0.9,\rel,0.1,\rate,1,\addAction,1).quant_([4,1]).play;
Pbindef(\r1).stop;

Pbindef(\r2,\instrument,\bplaym,\buf,~dirt["drumtraks"][11],\dur,Pseq([0.5,0.5,7], inf),\amp,0.5,\rel,0.1,\rate,Pseq([1,0.7,0.5],inf),\addAction,0, \stretch, 4).quant_([4,1]).play;
Pbindef(\r2).stop;



// starting bass
(
Pbindef(\bass,
	\instrument, \sinfb,
	\octave, Prand([3], inf).clump(3),
	\scale, Pfunc({~scale}),
	\degree, Prand([0, -1], inf),
	\fb, Pseg([0.9, 1.1, 0.9],[4,4], \lin, inf), //Pwhite(0.1, 0.9,inf).clump(3),
	\dur, Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.01,
	\rel, 0.1,
	\amp, 1.0,
	\addAction, 1
).quant_([4,0]).play;
)






(
Pbindef(\bass,
	\instrument, \sinfb,
	\octave, Prand([3], inf).clump(3),
	\scale, Pfunc({~scale}),
	\degree, Prand([0], inf),
	\fb, Pseg([0.9, 1.1, 0.9],[4,4], \lin, inf), //Pwhite(0.1, 0.9,inf).clump(3),
	\dur, 1, //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.01,
	\rel, 0.1,
	\amp, 1.0,
	\addAction, 1
).quant_([4,0]).play;
)
Pbindef(\bass).stop;



(
Pbindef(\agogo).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\r1).stop;
Pbindef(\r2).stop;
)