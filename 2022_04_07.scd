// echoplex - nine inch nail (Ghost VI)n
// forse Dixie Dregs: Free Falls


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,1.0);
~verb.free;


(
Pbindef(\test,
	\instrument, \syncsaw, // \fm4_perc
	\root, 9, // D
	\octave, [2,3,4],
	\scale, Scale.minor,
	\atk, 0.01,
	\fb, 0.8,
	\amp, 0.1,
	\rel, [0.5,0.3,0.1],
	\degree, Pseq([0,0,0,-1,0],inf).collect({|n| n}),
	\dur, Pseq([1,1,0.25,0.75,1],inf),
	\addAction, 0
).quant_([4]).play;
)

Pbindef(\tes_saw).stop;
Pbindef.gui


(
Pbindef(\tes_saw,
	\instrument, \saw,
	\root, 9, // D
	\octave, 6,
	\scale, Scale.minor,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.1,
	\degree, Pseq([0,0,0,-1,0],inf).collect({|n| n}),
	\dur, Pseq([1,1,0.25,0.7,1],inf),
	\addAction, 1
).quant_([4]).stop;
)

(
Pbindef(\test2,
	\instrument, \fm4_perc,
	\root, 2, // D
	\octave, [5,6,7],
	\scale, Scale.major,
	\atk, 0.01,
	\rel, 4,
	\degree, Pseq([0],inf),
	\dur, 4,
	\addAction, 0
).quant_([4]).stop;
)

~scale = Scale.minor;
~root = 9;

(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0,rq=0.1
	|
	var env = EnvGen.ar(Env.triangle(dur*1.2), doneAction:2);
	var mamp = LFTri.kr(freq*0.0125*LFNoise0.kr(5).range(0.8,1.2)).range(0.5,5); //modulated amp
	var mwidth   = LFTri.kr(
		LFNoise1.kr(2).exprange(0.1, 2)
	).range(0.4, 0.6);
	var sig = VarSaw.ar(freq, width:mwidth, mul:mamp).squared.softclip;
	sig = RLPF.ar( sig+WhiteNoise.ar(0.2), freq*4,rq);
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
	\root, Pfunc({~root}),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(5),
	\octave, Prand([3,4,5],inf).clump(5),
	\degree, Pseq([
		[ -2,0,2, 3, 4 ], // Db
		//[-3,-1, 0,2,4], // Fm
		//[ -1,1,3 ], // Eb maj
		//[-2,2,6, 7,11,15 ]
	], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(5),
	\amp, Pgauss(0.1, 0.01, inf).clump(5) * 0.4,
	\rq, Pwhite(2, 0.5, inf),
	\dur, Pseq([8, 4,4], inf),
	\addAction,0
).quant_(4).stop.play;
)
Pbindef(\pads).stop;


(
SynthDef(\k, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0, dc=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = DC.ar( dc.clip(0.0, 0.5) ) +  SinOsc.ar(freq, 0.5pi);
	sig = sig.fold(-1.0, 1.0);
	sig = LPF.ar(sig, XLine.kr(3000, 1000, rel));
	sig = sig + (SinOsc.ar(freq * 2,  mul:Line.kr(0.0, 1,rel*1)));
	sig = sig * amp * env;
	sig = LeakDC.ar(sig);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\k,
	\instrument, \k,
	\octave, 3,
	\degree, Pseq([-3],inf),
	\dur, 1, //Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, 8,//Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, 0.15, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
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
		//0.5,0.5,0.25,0.25,0.5
		0.5
		//0.5,Prand([0.5, Pn(0.25,2)],1),0.25,0.25,0.5
	], inf),
	\amp, Pseq([1,3], inf) * 3, //Pgauss(1, 0.2, inf) * 3,
	\atk, 0.0,
	\rel, Pseq([0.3, 0.1], inf),
	/*
	Pseq([
		0.01,
		0.1,
		Pn(0.01,3)
	],inf),
	*/
	\addAction,1
).quant_([4,0.5]).play;
)

Pbindef(\hh).stop;




(
SynthDef(\sinfb, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\stabs,
	\instrument, \sinfb,
	\octave, Pseq([4,5,6],inf).clump(2),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, [-2, 2], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.07,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 2,
	\strum, 0,
	\addAction, 0
).quant_([4, 1]).stop.play;
)
Pbindef(\stabs).stop


Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,2,\amp,16,\atk, 0.0, \rel,0.5,\rate,1,\addAction,1, \stretch, 0.5).quant_(4).play;

Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,Pseq([2.25, 1.75], inf),\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,0.5,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).play;

(
Pbindef(\s).play;
Pbindef(\k, \dur, 2, \).play;
Pbindef(\hh).play;
Pbindef(\clap).play;
)

Pbindef(\test).stop;
Pbindef(\k).stop;

(
Pbindef(\k, \buf, ~dirt["drumtraks"][5],\dur, 2,\amp, 16, \rel, 0.1).play;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\clap).stop;
Pbindef(\stabs).stop;
Pbindef(\snap).stop;
Pbindef(\cymbal).stop;
)



(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,0, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,1]).stop.play;
)

(
Pbindef(\cymbal,\instrument,\bplaym,\buf,d["oh_mono"][1],\dur,8,\amp,3,\atk, 0.0, \rel,5,\rate, 0.35,\addAction,0, \pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,0]).stop.play;
)

(
Pbindef(\cymbal,
	\instrument, \glinem,
	\buf, d["oh_mono"][1],
	\dur, 4,
	\atk, Pkey(\dur)*t.beatDur,
	\rel, 0.0,
    \density, 10, \caos, 5.0,
	\rate, 0.9,
	\amp, Pseq([Pn(\,3), 30],inf) * 5,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\cymbal).stop;