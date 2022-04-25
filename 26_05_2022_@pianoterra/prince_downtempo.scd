t = TempoClock.default
t.tempo_(120/60)

~rs_Kick = Buffer.readChannel(s, "/home/nicola/Musica/samples/CC0/BVKER - Aesthetic Vaporwave Drums/Kicks/BVKER - Voyage - Kick 03.wav", channels:0);
~rs_Snare = Buffer.readChannel(s, "/home/nicola/Musica/samples/CC0/BVKER - Aesthetic Vaporwave Drums/Snares/BVKER - Synthwave - Snare - 01.wav", channels:0);
~rs_HiHat = Buffer.readChannel(s, "/home/nicola/Musica/samples/CC0/BVKER - Aesthetic Vaporwave Drums/Cymbals/Hats Closed/BVKER - Synthwave - Closed Hat - 12.wav", channels:0);


(
Pbindef(\k,\instrument,\bplaym,\buf, ~rs_Kick, \dur,1,\amp,1,\rel,1,\rate,1,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf, ~rs_Snare,\dur,2,\amp,1,\rel,1,\rate,1,\addAction,1).quant_([4,1]).play;
Pbindef(\hh,\instrument,\bplaym,\buf,~rs_HiHat,\dur,0.5,\amp,0.2,\rel,1,\rate,1,\addAction,0).quant_([4,0.5]).play;

)
(
Pbindef(\k).stop;
Pbindef(\s).stop;
)

(
Pbindef(\prince_bones,
	\instrument,\bplaym,
	\buf, d["prince"][0],
	\dur,Pgeom(0.25, 0.7, 3),
	\amp, 2, //Pgauss(0.5, 0.1, inf), //Pexprand(0.05,0.5,1)*0.7,
	\rate, 1, //Pwhite(0.6, 2, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, 1
).quant_(1).play;
)

(
Pbindef(\prince_gluglu,
	\instrument,\bplaym,
	\buf, d["prince"][3],
	\dur, Pseq([1],inf),
	\amp, 1.1, //Pgauss(0.3, 0.1, inf), //Pexprand(0.05,0.5,1)*0.7,
	\rate, 1, //Pwhite(0.6, 2, inf),
	\addAction, 1
).quant_([1, 0.45]).stop.play;
)

(
Pbindef(\prince_gate,
	\instrument,\bplaym,
	\buf, d["prince"][4],
	\dur,Pgeom(0.25, 0.7, 3),
	\amp, Pgeom(0.7, 1.5, 3) * 0.3,
	\rate, 1, //Pwhite(0.6, 2, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pseq([1,1,0], 3)
).quant_(1).play;
)

Pbindef(\chords).stop;

(
Pbindef(\prince_grain,
	\instrument,\glinem,
	\buf, d["prince"][9],
	\density, 50, \caos, 0.5,
	\dur, 5.25,
	\amp, Pgauss(0.2, 0.1, inf), //Pexprand(0.05,0.5,1)*0.7,
	\rate, Pwhite(0.6, 2, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pseq([1,1,0], inf)
).quant_(1).play;
)

(
Pbindef(\prince_bones).stop;
Pbindef(\prince_gluglu).stop;
Pbindef(\prince_gate).stop;
Pbindef(\prince_grain).stop;
)


(
Pbindef(\g1,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([3],1),inf),
	\dur,7,
	\amp,0.25,
	\rate,1,
	\addAction,0
).quant_(4).stop.play;

Pbindef(\g2,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([4],1),inf),
	\dur,9,
	\amp,0.25,
	\rate,0.5,
	\addAction,0,
	\pan, Pwhite(0.0, 1.0, inf)
).quant_(4).stop.play;

Pbindef(\g3,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([1],1),inf),
	\dur,11*2,
	\amp,0.25,
	\rate,1,
	\addAction,0,
	\pan, Pwhite(-1.0, 0.0, inf)
).quant_(4).stop.play;
)
(
Pbindef(\g1).stop;
Pbindef(\g2).stop;
Pbindef(\g3).stop;
)

(
Pbindef(\chords,
	\instrument, \sinfb,
	\octave, 4,
	\degree, Pseq([
		[0,4,   9,13,15,  18],
		[1,5,10.1,11,15,17.1],
		[2,6,  11,12,15, 18]
		//Prand([[6,10.1,14.1,15,16,19], [5,9,13,15,18]],1)
	],inf),
	\dur, Pseq([4,4,8],inf),
	\amp, 0.1,
	\atk, 0.5,
	\sus, 1.0,
	\rel, Pkey(\dur, inf),
	\fb,  Pexprand(0.01, 0.7, inf).clump(6),
	\pan, Pwhite(-1.0, 1.0, inf).clump(6),
	\strum, Pwhite(-0.01, 0.01, inf),
	\addAction,0
).quant_([4,0]).play;
)
Pbindef(\chords).stop;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);


(
Pbindef(\heaterial,
	\instrument, \fm4,
	\octave, 5,
	\degree, Pseq([9,8,1,2],4),
	\dur, Pseq([0.5],4),
	\amp, 0.2,
	\atk, 0.01,
	\sus, 1.0,
	\rel, 0.25,
	\n1, 2,\n2, 8,
	\mi, 1000, \iatk,0.01,\irel,0.1,\iAdd,10.0,
	\pan, Pseg([-0.7, 0.7],[2], \lin, 4),
	\addAction,0,
	\lag, Pgeom(0.01, 1.8, 4),
	\addAction,0
).quant_([4,2]).stop.play;
)
Pbindef(\heaterial).stop;



(
Pbindef(\melody,
	\instrument, \fm4,
	\octave, Prand([5,6,7],inf).clump(2),
	\degree, Pseq([Pn([2, 4],8), Pn([3.1,5],8), Pn([4,6],14),Pn([-1,2],2)],inf),
	\dur, 0.5,
	\amp, 0.2,
	\atk, 0.01,
	\rel, 0.1,
	\n1, 1,\n2, Prand((3..8), inf).clump(2),
	\mi, 700, \iatk,0.01,\irel,0.1,\iAdd,0.0,
	\pan, Pwhite(-1.0, 1.0, inf).clump(2),
	\addAction,1,
	\lag, Pwhite(0.0, 0.02, inf),
	\strum, Pwhite(-0.01, 0.01, inf),
	\addAction, Prand([0,1],inf)
).quant_([4,0]).play;
)


Pbindef(\melody).clear;
Pbindef(\melody).stop;
Pbindef(\melody,\amp, 0.2,\mi, 1000,\addAction,0,\atk,0,\iAdd,0)
Pbindef(\melody, \n1,2,\n2,8);
Pbindef(\melody, \atk, 0.0,\rel,1.1)
Pbindef(\melody, \atk, 0.0,\rel,1.1)


(
SynthDef(\simpleSquare, {
	|freq=440, amp=1.0, pan=0.0,
	atk=0.01, rel=0.1,width=0.5,
	cf=440, rq=0.1
	|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = Pulse.ar(freq, width:width);
	sig = RLPF.ar(sig, freq*4, rq);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\bass,
	\instrument, \acid,
	\octave, [2, 3,4],
	\scale, Scale.major,
	\root, 0,
	\degree, Pseq([Pn([0, 4],4), Pn([1,5],4), Pn([2,6],6), Pn([1,6],2)],inf),
	\amp, 0.3,
	\atk, 0.01,
	\width, 0.2,
	\rel, 0.3,
	\rq, 0.1,
	\dur,1,
	\pan, 0.0,
	\addAction,1
).quant_([4,1]).stop.play;
)
Pbindef(\bass).stop;

Pbindef(\bass, \cf,5000, \rq, 0.1)