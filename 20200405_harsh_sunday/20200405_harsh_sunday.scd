//TempoClock.default.tempo_(90/60);
TempoClock.default.tempo_(136/60);


// chord progression: Fm | Dm

(
SynthDef(\test, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env * amp;

	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\A,
	\instrument, \test,
	\octave, Pseq([4,6],inf).clump(2),
	\scale, Scale.minor,
	\degree, Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\fb, Pwhite(0.1, 1, inf).clump(2),
	\atk, 0.01,
	\rel, 0.3,
	\dur, 0.5,
	\amp, Pgauss(0.2, 0.01, inf).clump(2),
	\strum, 0,
	\addAction, 0
).quant_([4]).play;
)


// fire clackle!!
(
Pbindef(\A,
	\instrument, \test,
	\octave, Pseq([6,7,8],inf).clump(4),
	\mtranspose, Pwhite(-1, 1, inf).clump(2) * Pseg([0.0, 0.04],[4],\lin, inf),
	\fb, Pwhite(0.1, 1, inf).clump(4),
	\atk, 0.0,
	\rel, 0.1,
	\amp, Pgauss(0.1, 0.01, inf).clump(2),
	\strum, 0.1,
).quant_([4]).play;
)

Pbindef(\A).play;
Pbindef(\A).stop;


~verb = Synth(\Gverb);
~verb.set(\revtime,2, \damping, 0.9);
~verb.free;


s.plotTree

(
SynthDef(\saw, {
	|
	freq=440, amp=1.0, atk=0.01, rel=0.1, gate=1, pan=0.0,
	fb=0.1, dist=1.0, rq=0.01
	|
	var env = EnvGen.ar(Env.adsr(atk, 0.0, 0.7, rel),gate, doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env;
	sig = RLPF.ar(sig, freq*8, rq);
	sig = (sig *dist).tanh;

	Out.ar(0, Pan2.ar(sig*amp, pan));
}).add;
);
(
Pbindef(\B,
	\instrument, \saw,
	\octave, Pseq([2,3,4],inf).clump(4),
	\scale, Scale.minor,
	\degree, Pseq([Pseq([[3,3]],4), Pseq([[1,1]],4)], inf),
	\mtranspose, Pwhite(-0.001, 0.001, inf).clump(4),
	\fb, 0.6,
	\rq, 0.1,
	\dist, 2,
	\atk, 0.1,
	\rel, 1,
	\dur, 2,
	\amp, 0.1,
	\pan, Pwhite(-1.0, 1.0, inf).clump(4),
	\addAction,0
).quant_([4]).stop.play;
)
Pbindef(\B).stop;

(
Pbindef(\B,
	\fb, Pseg([0.1, 1, 0.1],[4,4],\exp,inf),
	\rq, Pseg([0.1, 0.001, 0.1],[8,8],\lin,inf),
	\dist, Pseg([1, 200, 1],[16,16],\exp,inf),
	\amp, 0.1
);
Pbindef(\B, \degree, Pseq([Pseq([[3,3]],8), Pseq([[1,1]],8)], inf));
Pbindef(\B, \amp, 0.1);
Pbindef(\B, \dur,0.5, \atk, 0.01, \rel, 0.1);
)





// PERCUSSIONS ///////////////////////////////////////////////////////////////

(
SynthDef(\kickFm, {
	|
	out=0, pan=0.0, amp=1.0, freq=60,
	//amplitude envelope
	atk=0.001, rel=1,
	// pitch modulation
	fenvamt=2.0, fatk=0.2, frel=0.1,
	// frequency modulation
	mf=100, mi=10, matk=0.001, mrel=0.01,
	dist=1.0
	|
	// amplitude modulation
	var env = EnvGen.ar(Env.perc(atk, rel),doneAction:2);
	// pitch modulation
	var fenv= EnvGen.ar(Env.perc(fatk, frel), levelScale: fenvamt, doneAction:0);
	// fm modulation
	var mod = SinOsc.ar(mf, mul:mi) * EnvGen.ar(Env.perc(matk, mrel));
	var sig = SinOsc.ar(freq + mod + fenv, 0.5pi);
	sig = (sig * env) * dist;
	sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig * amp, pan));
}).add;
);

Pbindef(\k,\dur, 1)
(
Pbindef(\k,
	\instrument, \kickFm,
	\freq, 50,
	//amplitude envelope
	\atk, 0.0, \rel, 0.5,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 100, \matk, 0.01, \mrel, 0.01,
	\dist, 1.0,
	\amp, 5,
	\dur, 1,
	\addAction,1
).quant_([4,0]).stop.play;
)

(
SynthDef(\snareFm, {
	|
	out=0, pan=0.0, amp=1.0, freq=60,
	//amplitude envelope
	atk=0.0, rel=0.1,
	// pitch modulation
	pamp=100, patk=0.0, prel=0.2,
	// frequency modulation
	nf=3500, rq=0.3, natk=0.01, nrel=0.3,namp=3
	dist=1.0
	|
	// amplitude modulation
	var env = EnvGen.ar(Env.perc(atk, rel),doneAction:0);
	// pitch modulation
	var fenv= EnvGen.ar(Env.perc(patk, prel), levelScale: pamp, doneAction:0);
	// filtered noise
	var mod = BPF.ar(WhiteNoise.ar(), nf, rq, mul:EnvGen.ar(Env.perc(natk, nrel,curve:[4,-2]), levelScale: namp));

	var sig = SinOsc.ar(freq + fenv, 0.5pi, mul:env) + mod;

	sig = (sig * dist).tanh * amp;
	DetectSilence.ar(sig, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

(
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\clap).play;
)

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\clap).stop;
)


(
Pbindef(\s,
	\instrument, \snareFm,
	\freq, 90,
	//amplitude envelope
	\atk, 0.0, \rel, 0.15,
	// pitch modulation
	\pamp, 100, \patk, 0.0, \prel, 0.2,
	// frequency modulation
	\nf, 3500,\rq, 0.3,\namp, 2,\natk, 0.0, \nrel, 0.2,
	\dist, 3,
	\amp, 0.5,
	\dur, Pseq([2], inf),
	\addAction,1
).quant_([4,1]).stop.play;
)
Pbindef(\s).stop;


Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,Pseq([1.5,2.5],inf),\amp,0.1,\rel,0.2,\rate,0.7,\addAction,1).quant_([4,2]);
Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,4,\amp,0.5,\rate, 0.7,\rel, 0.1,\addAction, 0).quant_([4,1]).stop.play;

Pbindef(\clap).stop;

~vincent = Buffer.read(s, "/home/nicola/Scaricati/Telegram Desktop/vincent_price_MLgenerated_test1.wav");

Pbindef(\vincent,\instrument,\bplaym,\buf,~vincent,\dur,Pseq([1],1),\amp,3,\rel,15,\rate,1,\addAction,0).quant_(1).play;


(
SynthDef(\osc, {
	|freq=400,amp=1.0,pan=0.0,l=1|
	//var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOsc.ar( Line.kr(freq, freq*4, l, doneAction:2)) * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\oua,
	\instrument, \osc,
	\freq, [400, 402]*2,
	\dur, 8,
	\l, 2,
	\amp, 0.05,
	\addAction, 0
).quant_([4,1]).stop.play;
)
Synth(\osc, [\freq, 400,\amp,0.05]);
Pbindef(\oua).stop;



(
Pbindef(\D,
	\instrument, \test,
	\octave, Pseq([4,5],inf).clump(2),
	\scale, Scale.minor,
	\degree, [3, 0], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.2,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2),
	\strum, 0,
	\addAction, 0
).quant_([4, 1.5]).stop.play;
)
Pbindef(\D).play;
Pbindef(\D).stop;
