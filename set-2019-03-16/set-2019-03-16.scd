// SET 2019-03-16
t = TempoClock.default;
t.tempo_(120/60);

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

(
Pbindef(\pads,
	\instrument,\bpfsaw,
    \dur,Pwhite(4.5,7.0,inf),
    \scale, Scale.minor,
    \degree,Pwrand([[0,2,4],[3,5,7],[4,6,8]],[0.5,0.25,0.25],inf),
    \cfmin,100,
    \cfmax,1500,
    \rqmin,Pexprand(0.02,0.15,inf),
    \atk,Pwhite(2.0,4.5,inf),
    \rel,Pwhite(6.5,10.0,inf),
    \ldb,6,
    \lsf,1000,
    \octave,Pwrand([4,3,5],[0.6,0.3,0.1],inf),
    \amp,Pwhite(0.6,0.9),
	\out,[0,1],
	\addAction, 0
).quant_([4]).stop.play;
)
Pbindef(\pads).stop;

(
Pbindef(\arpeggio,
	\instrument,\sinfb,
	\scale,Scale.minor,
	\root,0,
	\octave,[4,5],
	\degree,Place([0,0,2,[4,5,6],[7,1,2],[6,7,8,9],[10,12,14,15],7,6,5],inf),
	\dur,Pbjorklund2(Pwhite(6,8),8)/4,
	\amp,0.1,
	\fb,0.9,
	\rel,0.3,
	\pan, Pwhite(-0.8, 0.8),
	\addAction, 1
).quant_([4]).play;
)
Pbindef(\arpeggio).stop;

// then start with the bassline
(
Pbindef(\bass,
	\instrument,\ring1,
	\scale,Scale.minor,
	\root, 0,
	\degree, 0,
	\octave, 3,
	\dur, Pbjorklund2(1, 8,inf)/4,
	\atk, 0.01, \rel,0.6,\dist,15,
	\pan,0,
	\amp, 0.6,
	\addAction,1
).quant_([4]).play;
)
Pbindef(\bass).stop;
Pbindef(\bass).clear;

Pbindef.gui

// change the bass pattern
Pbindef(\bass,\dur,Pbjorklund2(5, 8,inf)/4, \rel, 0.3);


(
Pbindef(\arpeggio,
	\instrument,\sinfb,
	\scale,Scale.minor,
	\root,0,
	\octave,[4,5],
	\degree,Place([0,0,2,[4,5,6],[7,1,2],[6,7,8,9],[10,12,14,15],7,6,5],inf),
	\dur,Pbjorklund2(Pwhite(6,8),8)/4,
	\amp,0.2,
	\fb,0.9,
	\rel,0.125,
	\pan, Pwhite(-0.8, 0.8),
	\addAction, 1
);
Pbindef(\k, \instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1,\rel,0.125,\addAction,1).quant_([4]).play;
)

(
Pbindef(\s, \instrument,\bplay,\buf,d["s"][0],\dur,Pseq([2, Pbjorklund2(1, 8, inf)/4], inf),\amp,0.3, \rate, 0.25, \rel, 0.12,\addAction,1).quant_([4,1]).stop.play;
Pbindef(\k, \instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1,\rel,0.125).quant_([4]).play;
)

(
Pbindef(\stabs,
	\instrument,\sinfb,
	\scale,Scale.minor,
	\root, 0,
	\octave, 6,
	\degree, 0,
	\dur,Pseq([Pseq([0.25],3),Pseq([2], 2)],inf),
	\amp, 0.4,
	\fb, 2,
	\rel,0.03,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4]).play;
)


(
Pbindef(\s, \instrument,\bplay,\buf,d["s"][0],\dur,Pseq([2, Pbjorklund2(1, 8, inf)/4], inf),\amp,0.5, \rate, 0.25, \rel, 0.12);
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1,\rel,0.125);
Pbindef(\arpeggio,\instrument,\sinfb,\scale,d[\scale],\root,0,\octave,6,\degree,0,\dur,Pseq([Pseq([0.25],3),Pseq([2], 2)],inf),\amp,0.2,\fb,2,\rel,0.03);
)
