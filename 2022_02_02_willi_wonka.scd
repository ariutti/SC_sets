// willi wonka
~verb.set(\dec,1, \lpf,7000, \wet,1);

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
Pbindef(\test).set(\amp, 1);
Pbindef(\test).stop;

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,2,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.5,\amp,0.7,\rel,0.2,\rate,Prand([1, 2], inf),\addAction,1).quant_([4,0.5]).stop.play;
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
	\octave, [5,6,7], //Pseq([Pn(7,3), 6],inf), // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, 0, // + Pseq([7,4, 0],inf),
	\fb, 0.2, //Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, 0.25, // Pseq([1, 0.5, 0.5],inf) * 0.3,
	\atk, t.beatDur*2,
	\rel, 0.0, //Prand([0.2, 0.05], inf),
	\dur, 16, //Prand([0.5, Pn(0.25, 2)], inf),
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
	\octave, 6, // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pseq([7,4, 0],inf),
	\fb, 0.0, //Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, Pseq([1, 0.5, 0.5],inf) * 0.2,
	\atk, 0.0,
	\rel, 0.1, //Prand([0.2, 0.05], inf),
	\dur, 0.5, //Prand([0.5, Pn(0.25, 2)], inf),
	\pan, Prand([-1.0, 1.0], inf),
	\addAction, 0
).quant_([4,0]).play;
)

Pbindef(\mel).stop;






