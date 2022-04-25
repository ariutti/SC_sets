~scale = Scale.major;
Pbindef(\mel).stop;

s.scope
(
Pbindef(\mel,
	\instrument, \fm4_perc,
	\scale, Pfunc({~scale}),
	\root, 0,
	\octave, Prand([5,6,7],inf),
	\degree, Prand([0,4,3], inf), //0 + Pseq([[0,4]],inf),
	\dur, Prand([1, 0.5],inf),
	\n1, Prand([2,3,4,5],inf),
	\n2, Prand([3,4,5],inf),
	\mi, 500,
	\atk, 0.1, \rel, 1,
	\amp, 0.3, //0.05, //Pseq([1,0.5, 0.5], inf) * 0.4,
	\pan, Pwhite(-1.0, 1.0, inf), //Pseg([-1.0, 1.0, -10], [2,2], \lin, inf),
	\addAction, 0, //Prand([0,1],inf)
).quant_([4,1]).play;
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)
)

Pbindef(\mel).clear;

Pbindef(\mel, \amp, 0.7, \addAction, 0, \rel, 1,\octave, \atk,0.0, \degree, Prand([-1,0,1,2,], inf) );



(
Pbindef(\bass,
	\instrument, \bassline4,
	\scale, Scale.major,
	\octave, 5,
	\degree, 0, //Pseq([0,2,4], inf),
	\dur, 1,
	\atk, 0.01, \rls,8,
	\amp, 3,
	\sub, 0.0,
	\subwidth, 0.3,
	\sync, 60.0, // this is a sync ratio going from 0.0 (no effect) to 60 semitones (5 octave above)
	\voices,1,
	\det,0.06,
	\cf,1000,
	\rq,0.1,
	\addAction, 1
).quant_([4]).play;

)
Pbindef(\bass).stop;
s.scope

~dirt.keys
~dirt["sundance"][0]

~dirt["metal"]


Pbindef(\metal,\instrument,\bplaym,\buf,~dirt["made"][0],\dur,4,\amp,0.6,\rel,0.5,\rate,1,\addAction,1).quant_(4).play;
Pbindef(\metal).stop;
Pbindef(\k).stop;


48.midiratio

d["s"][0]

(
Pbindef(\mel, \addAction,1, \atk, 0.0, \rel, 0.1).play;
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,Pwrand([1, Pn(0.5,2)],[5,1].normalizeSum,inf),\amp,8,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\hh,\instrument,\bplaym,\buf,d["ch"][1],\dur,0.5,\rel,0.5, \rate, 2,\amp, Pgauss(0.9,0.1, inf) * 0.9).quant_([4,0]).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["s"][1],\dur,2,\amp,4,\rate,1,\rel,0.2,\addAction, 1).quant_([4,1]).stop.play;
)
(
Pbindef(\mel).play;
Pbindef(\mel).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)


Pbindef(\tom1,\instrument,\bplaym,\buf,d["k"][2],\dur,Pbjorklund2(3,4,inf,0)/4,\amp,1,\rel,0.1,\rate,2,\addAction,1).quant_(4).play;
Pbindef(\tom1).stop;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,2.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,2);