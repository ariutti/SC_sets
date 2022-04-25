// willi wonka - campo miniato - ho fatto un sogno
~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,7000, \wet,1);

// F, C, CM7

s.plotTree
(
Pbindef(\test,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, 0,
	\octave, 5, // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, 0 + Pseq([[0,4,7]],inf),
	\fb, 0.0, //Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, 0.1,
	\atk, 3,
	\rel, 4, //Prand([0.2, 0.05], inf),
	\dur, 0.5, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, Prand([-1.0, 1.0], inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\test).set(\amp, 0.1);
Pbindef(\test).stop;

(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,3,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,1,\amp,2,\rel,Pwrand([0.1, 0.3],[5,1].normalizeSum,inf),\rate,Prand([1,1], inf),\addAction,1).quant_([4,0.5]).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][2],\dur,2,\amp,1,\rel,0.2,\rate,1,\addAction,1 ).quant_([4,1]).play;
)

(
Pbindef(\s).stop;
Pbindef(\k).stop;
Pbindef(\hh).stop;
)


Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][2],\dur,2,\amp,1,\rel,0.2,\rate,1,\addAction,1 ).quant_([4,1]).play;

Pbindef(\test).stop;


(
Pbindef(\mel,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, 0,
	\octave, [7], //Pseq([Pn(7,3), 6],inf), // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, 0, // + Pseq([7,4, 0],inf),
	\fb, 0.2, //Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, 1, // Pseq([1, 0.5, 0.5],inf) * 0.3,
	\atk, t.beatDur*4,
	\rel, 0.01, //Prand([0.2, 0.05], inf),
	\dur, 4, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, 0.0, //Prand([-1.0, 1.0], inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\mel).stop;

(
Pbindef(\mel,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, 0,
	\octave, [6,7], // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pseq([
		Pseq([7,6,0],2),
		//Pseq([7,5,0],2),
		//Pseq([7,4,0],6),
	],inf),
	\fb, 0.1, //Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, Pseq([1, 0.5, 0.5],inf) * 0.7,
	\atk, 0.0,
	\rel, 0.1, //Prand([0.2, 0.05], inf),
	\dur, 0.5, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, Prand([-1.0, 1.0], inf),
	\addAction, 0
).quant_([4,0]).play;
)

(
Pbindef(\mel).stop;
Pbindef(\test).stop;
)

s.meter


(
Pbindef(\mel,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, 0,
	\octave, [6,5], //Pseq([Pn(7,3), 6],inf), // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pseq([0,1,2,3],inf), // + Pseq([7,4, 0],inf),
	\mtranspose, Pseg([0, 0.2, 0.0],[8,8],\lin,inf),
	\fb, Pseg([0.1, 2.1, 0.1], [8,8], \lin, inf),
	\amp, 0.7, // Pseq([1, 0.5, 0.5],inf) * 0.3,
	\atk, 0.0,
	\rel, 0.25, //Prand([0.2, 0.05], inf),
	\dur, 0.25, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, 0.0, //Prand([-1.0, 1.0], inf),
	\addAction, 1,
	\strum, 0.01,
).quant_([4,0.5]).play;
)


(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,0, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,1]).stop.play;
)


Pbindef(\snap).stop