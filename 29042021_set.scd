

(
Pbindef(\bird,
	\instrument,\bplay_distm,
	\buf, Pindex(~dirt["chin"], Prand((0..(~dirt["chin"].size-1)), inf), inf),
	\dur, Pseq([0.5, Pn(2, 0.25)], inf) ,
	\rel, 5,
	\rate, 1,
	\dist, 1, //Prand([6,100],inf),
	\amp, 0.5,
	\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)
).quant_([4,0]).play;
)
Pbindef(\bird).stop;


~dirt.keys;



(
Pbindef(\s,
	\instrument,\bplaym,
	\buf, d["sstick"][0],
	\dur, ,
	\amp, Pseq([0.5,1, 0.7], inf) * 2,
	\rel,0.6,
	\rate,0.7,
	\addAction, 1,
	\lag, Pwhite(0.0, 0.02, inf)
).quant_([4,0.85]).play;
)
Pbindef(\s).stop;


(
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 2,\rel,0.125,\rate,1.1 * Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\strum, Pwhite(0.0, 0.15, inf), \pan, [-1, 1]).quant_([4,0.85]).stop.play;
)

(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,0.5+0.85]).stop.play;
)

Pbindef(\clap).play;
Pbindef(\snap).play;

(
Pbindef(\clap).stop;
Pbindef(\snap).stop;
)


(
SynthDef(\hh, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,rq=0.1|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = BPF.ar(WhiteNoise.ar(), freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)
(
Pbindef(\hh,
	\instrument,\hh,
	//\buf, Pseq([~dirt["tech"][0], ~dirt["tech"][7], Pn(~dirt["tech"][0],3)], inf),
	\freq, [7000, 9000],
	\rq, 0.05,
	\dur, Pseq([
		0.5,0.5,0.25,0.25,0.5
		//0.5,Prand([0.5, Pn(0.25,2)],1),0.25,0.25,0.5
	], inf),
	\amp, Pgauss(1, 0.2, inf) * 5,
	\atk, 0.0,
	\rel, Pseq([
		0.01,
		0.1,
		Pn(0.01,3)
	],inf),
	\rate, 1, // Pseq([1, 2, Pn(1,3)], inf),
	\addAction,1
).quant_([4, 0.85]).play;
)
Pbindef(\hh).stop;

Pbindef.gui
s.meter;

(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, 0,
	\octave, Prand([3], inf),
	\degree, Pseq([0,2,7], inf),
	\fb, 1.5, //Pwhite(0.7, 1.1, inf),
	\atk, 0.0,
	\rel, 0.1,
	\dur, 0.5, //Prand([0.5, Pn(2,0.25), Pn(4,0.125)], inf),
	\amp, 1.5,
	\addAction, 0, //Prand([1,0],inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).quant_([4, 0.85], inf).play;
)
Pbindef(\bass).stop;