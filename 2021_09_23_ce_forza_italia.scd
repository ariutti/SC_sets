// 136 BPM
t = TempoClock.default;
t.tempo_(136/60);
~scale = Scale.iraq;

// start with a dark and gloomy pad
(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0
	|
	var env = EnvGen.ar(Env.triangle(dur*1.2), doneAction:2);
	var mamp = LFTri.kr(freq*0.0125*LFNoise0.kr(5).range(0.8,1.2)).range(0.5,5); //modulated amp
	var mwidth   = LFTri.kr(
		LFNoise1.kr(2).exprange(0.1, 2)
	).range(0.4, 0.6);
	var sig = VarSaw.ar(freq, width:mwidth, mul:mamp).squared.softclip;
	sig = LPF.ar( sig+WhiteNoise.ar(0.2), freq*4);
	//sig = HPF.ar(sig, freq * 0.25);
	//sig = CombN.ar(sig, 0.8, 0.2, 0.5);
	sig = LeakDC.ar(sig) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\pads,
	\instrument, \dist,
	\scale, Pfunc({~scale}),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, Prand([3,4], inf).clump(6),
	\degree, Pseq([3.1,4],inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.3, 0.01, inf).clump(6) * 1,
	\dur, Pseq([4,8],inf),
	\addAction,0
).quant_(4).play;
)

Pbindef(\pads).stop;


Pbindef(\r1,\instrument,\bplaym,\buf,~dirt["jazz"][0],\dur,2,\amp,Pseg([0.0, 2, 0.0],[4,4],\lin,inf),\rel,0.1,\rate,1,\addAction,1).quant_([4,0]).stop.play;
~dirt["jazz"].size
Pbindef(\r1).stop;
jazz

Pbindef.gui

// then add a crazy bouncing ball
(
Pbindef(\lead,
	\instrument, \dfm1,
	\octave, Pseq([[5,6]], inf).clump(3),
	\scale, Pfunc({~scale}),
	\degree, 0+Pseq([3.1, 4], inf),
	\mtranspose, Pseg([0, 0.2, 0],[4,4],\lin, inf),
	\fb, 0.5, //Pseg([0.9, 1.1, 0.9],[4,4], \lin, inf), //Pwhite(0.1, 0.9,inf).clump(3),
	\dur, 0.5, //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.0,
	\rel, Pseg([0.5, 0.1, 0.5],[4,4], \lin, inf),
	\type, 2,
	\noise, 0.1,
	\amp, Pseg([0.0, 0.4, 0.0], [4, 4], \lin, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\lead).stop;

// four on the floor with some variation
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([Pn(2,7),0.5, 1.5],inf),\amp,6,\rel,0.1,\rate,[2,1],\addAction,1, \stretch, 0.5).quant_(4).play;
Pbindef(\k).stop;


// and now a super saw bass
(
Pbindef(\bass,
	\instrument, \sinfb,
	\octave, Prand([3,4], inf).clump(3),
	\scale, Pfunc({~scale}),
	\degree, Prand([4, 3.1], inf),
	\fb, 1.5, //Pwhite(0.1, 0.9,inf).clump(3),
	\dur, Pseq([Pn(0.5,7), 0.25, 0.75],inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.2,
	\addAction, 1
).quant_([4,0]).play;
)


Pbindef.gui;