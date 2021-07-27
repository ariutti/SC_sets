// SAKANOTO (a.k.a. Cromosomi)

// @ 80 BPM loop chords will be
// Db | Eb | Fm | Eb ||
//piano_pt1_8bars_80bpm_stereo.wav

// 0.0       0.125     0.25
//| Db  Eb | Fm  Eb || Db  Eb | Fm  Eb |
// 0.5
//| Db  Eb | Fm  Eb || Db  Eb | Fm  Eb |


t = TempoClock.default;
t.tempo_(80/60)
~delay.free;
~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,1.0);
~verb.free;

(
Tdef(\changeTempoGradually, {
	var timeInterval = 0.5;
	t.tempo = (136/60);
	(136-80-1).do {
		t.tempo = (t.tempo*60-1)/60;
		timeInterval.wait;
	};
	t.tempo = (80/60);
})
)
Tdef(\changeTempoGradually).play;
Tdef(\changeTempoGradually).stop;


// finale !!!!
// REMEMBER: first make the pads fade away
(
~static_noise_1.free;
Pbindef(\pads).stop;
Pbindef(\loop,	\start, 0.0,\dur, Pseq([0.5], 1), \addAction, 0); // Db
//Pbindef(\loop,	\start, 0.125,\dur, Pseq([0.5], 1), \addAction, 0); // Fm
)


// MIDI IN ///////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;

Pbindef.gui;



// VERB ////////////////////////////////////////////////////////////
//~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
//~verb.set(\dec,0.6, \lpf,1500, \wet,1.0);


// NOISE FX ////////////////////////////////////////////////////////
(
SynthDef(\staticNoise, {
	|amp=1.0, out=0|
	var a = SinOsc.ar(15600, mul:0.00125);
	var b = SinOsc.ar(2484, mul:0.00125);
	var c = LPF.ar(HPF.ar(PinkNoise.ar().cos(), 700), 900);
	var sig = (a + b + c) * amp;
	Out.ar(out, Pan2.ar(sig, 0.0));
}).add;
)


~static_noise_1 = Synth(\staticNoise, [\amp, 2.0, \out, 0], addAction:1);
~static_noise_1.set(\amp, 4);
~static_noise_1.free;

// PIANO LOOP //////////////////////////////////////////////////////
(
SynthDef(\sliceplayer, {
	|
	out=0, amp=1.0,
	atk = 0.0, rel= 1.0,
	dur=1.0,
	loopbuf,
	loopbpm=136,loopbars=4,
	currentBpm=120,
	start=0.0
	// filters
	hf=16000,
	lf=60,
	// pan
	pan=0.0
	// decimator parameters
	bits = 16,
	sr = 44100
	|
	var bpmrate, env, ph,sig,nquarter,end;
	nquarter = loopbars * 4;
	bpmrate = currentBpm / (loopbpm/60.0);
	env = EnvGen.ar( Env(
		[0,1,1,0],
		[
			0.01,
			(BufDur.ir(loopbuf) * (bpmrate.reciprocal) * (dur/nquarter)) -0.01,
			0.01
		]
	),1, doneAction:2);
	dur = dur.clip(0.0, nquarter);
	start = start.clip(0.0, 1.0);
	end = (start + dur).clip(0.0, 1.0);

	ph = Phasor.ar(1, BufRateScale.ir(loopbuf) * bpmrate,
		BufFrames.kr(loopbuf) * start,
		BufFrames.kr(loopbuf) * end,
	0);

	sig = BufRd.ar(2, loopbuf, ph, 0.0,2) * amp * env;
	//sig = BufRd.ar(1, loopbuf, ph, 0.0,2) * amp * env;

	//sig = Decimator.ar(sig, sr, bits);
	//sig = LPF.ar(sig, hf);
	//sig = HPF.ar(sig, lf);
	Out.ar(out, Pan2.ar(sig, 0.0));
}).add;
);


Pbindef.gui;
Pbindef(\pads).stop;

// complete loop
(
Pbindef(\pads,
	\degree, Pseq([
		[-3,-1, 0,2,4], // Fm
		[ -1,1,3 ], // Eb maj
		//[ -2,0,2, 3, 4 ] // Db
	], inf),
);


// full piano loop | Db  Eb | Fm  Eb |
Pbindef(\loop,
	\instrument, \sliceplayer,
	\loopbuf, d["loops"][6],
	\loopbars, 8,
	\loopbpm, 80,
	\currentBpm, Pfunc({t.tempo}),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 0.7,
	\start, 0.0,
	\dur, 8,
	\addAction, 1
).quant_(4);
)
Pbindef(\loop).play;
Pbindef(\loop).stop;

// loop version 2
(
Pbindef(\loop,
	\instrument, \sliceplayer,
	\loopbuf, d["loops"][6],
	\loopbars, 8,
	\loopbpm, 80,
	\currentBpm, Pfunc({t.tempo}),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 1,
	\start, 0.0,
	\dur, 32,
	\addAction, 1
).quant_(4);
)

(
Pbindef(\pads,
	\degree, Pseq([
		[-3,-1, 0,2,4], // Fm
		//[ -1,1,3 ], // Eb maj
		//[ -2,0,2, 3, 4 ] // Db
	], inf),
).quant_(4);

Pbindef(\loop,\start, 0.0,\dur, 0.5, \amp, 1); // Db
)

(
Pbindef(\pads,
	\degree, Pseq([
		[-3,-1, 0,2,4], // Fm
		//[ -1,1,3 ], // Eb maj
		//[ -2,0,2, 3, 4 ] // Db
	], inf),
).quant_(4);

Pbindef(\loop,	\start, 0.125,\dur, 0.5, \amp, 0.6); // Fm
)

(
Pbindef(\pads,
	\degree, Pseq([
		//[-3,-1, 0,2,4], // Fm
		[ -1,1,3 ], // Eb maj
		//[ -2,0,2, 3, 4 ] // Db
	], inf),
).quant_(4);

Pbindef(\loop,	\start, 0.0625,\dur, 0.5, \amp, 0.5); // Eb
)
Pbindef(\loop,	\start, 0.1875,\dur, 0.5); // Eb




// Here's my boy: Db | Fm | Eb
(
Pbindef(\loop,
	\start, Pseq([Pn(0.0, 16), Pn(0.125,8), Pn(0.0625,8)], inf) ,//([8,1],inf), Pseq([0.0, 0.125], inf)), //Pseq((0..7)/16,inf),
	\amp, Pseq([Pn(0.9,16), Pn(0.6,8), Pn(0.8,8)], inf),
	\dur, Pseq([0.5], inf)
);
)


// pads ////////////////////////////////////////////////////////////

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

s.freqscope;
s.meter;


(
Pbindef(\pads,
	\instrument, \dist,
	\scale, Scale.minor,
	\root,5,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(5),
	\octave, Prand([3,4,5],inf).clump(5),
	\degree, Pseq([
		[ -2,0,2, 3, 4 ], // Db
		[-3,-1, 0,2,4], // Fm
		[ -1,1,3 ], // Eb maj
		//[-2,2,6, 7,11,15 ]
	], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(5),
	\amp, Pgauss(0.1, 0.01, inf).clump(5) * 1,
	\rq, Pwhite(2, 0.5, inf),
	\dur, Pseq([8, 4,4], inf),
	\addAction,0
).quant_(4).stop.play;
)

Pbindef(\pads).stop;
Pbindef(\pads).clear;



// STABS ///////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\sputnik, {
	|freq = 880, amp = 1.0, pan=0.0, dist=1.0|
	var trig = Impulse.kr(0);
	var env = EnvGen.ar(Env.perc(0.0, 6, curve:[4,-8]), trig);
	var sig = RLPF.ar(PinkNoise.ar(), freq, 0.005) * env * 0.15 * amp;
	sig = (sig * dist).tanh * amp;
	//sig = HPF.ar(sig, 600);
	//sig = FreeVerb2.ar(sig, sig, mix:0.4, room:0.85, damp:0.95);
	DetectSilence.ar(sig, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pan))
}).add;
);

(
Pbindef(\sputnik,
	\instrument, \sputnik,
	\scale, Scale.minor,
	\root, 5,
	\octave, Prand([5], inf),
	\degree, Prand([0], inf),
	\dist, 40,
	\amp, 0.3,
	\dur, 16,
	\atk, 0.0,
	\rel, 0.025,
	\pan, Pseq([-1, 1] ,inf),
	\addAction, 0
).quant_([4,1]).stop.play;
)
Pbindef(\sputnik).stop;


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
	\octave, Pseq([4,5],inf).clump(2),
	\scale, Scale.minor,
	\root, 1,
	\degree, [0, 4], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.07,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 0.3,
	\strum, 0,
	\addAction, 0
).quant_([4, 1]).stop.play;
)
Pbindef(\stabs).stop


// DRUMS ///////////////////////////////////////////////////////////////////////


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

s.scope
Pbindef(\k).clear;

// 1 on 4
(
Pbindef(\k,
	\instrument, \k,
	\octave, 3,
	\degree, Pseq([-3],inf),
	\dur, 4, //Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, 4 ,//Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, 0.15, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
)


(
Pbindef(\k,
	\instrument, \k,
	\octave, 3,
	\degree, Pseq([-3],inf),
	\dur, Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 2,
	\rel, 0.1, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
)
Pbindef(\k).stop;


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
).quant_(4).play;
)
Pbindef(\hh).stop;


(
SynthDef(\bplay_dist,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15, dist=1.0;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = (sig*dist).tanh;
		sig = sig * env * amp;
		sig = LeakDC.ar(sig);
		Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef(\bplay_distm,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15, dist=1.0;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = (sig*dist).tanh;
		sig = sig * env * amp;
		sig = LeakDC.ar(sig);
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,Pseq([2.25, 1.75], inf),\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,0.5,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).play;
Pbindef(\s).stop;


(
Pbindef(\cymbal,
	\instrument, \glinem_rev,
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


(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\clap).stop;
Pbindef(\hh).stop;
)

// BASS ///////////////////////////////////////////////////////////////////
(
SynthDef(\loSin, {
	|freq=16000, atk=1,rel=0, out=0, amp=1.0,dist=1.0, pan=0.0|
	var env =EnvGen.ar(Env.perc(atk, rel, curve:[10,-4]), doneAction:2);
	//var sig = SinOsc.ar(freq, [0.0, 0.5pi]);
	var sig = VarSaw.ar(freq, width:0.1);
	sig = (sig*dist).tanh * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\bass,
	\instrument, \loSin,
	\freq, (65-24).midicps,
	\dist, 100,
	\amp, 0.2,
	\atk, 8 * t.beatDur,
	\rel, 0.0,
	\dur, 8,
	\addAction,0
).quant_([4]).stop.play;
)
Pbindef(\bass).play;
Pbindef(\bass).stop;


// GLITCH /////////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\glicth1, {
	|freq=440,amp=1.0
	rf=1000, q=1,
	decay=1,
	out=0, pan=0.0
	|
	var sig = Impulse.ar(0);
	sig = Ringz.ar(sig, freq, decay) * amp;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);



(
SynthDef(\glitch2, {
	|amp=1.0,out=0, pan=0.0|
	var sig = Resonz.ar(Impulse.ar(0), freq:77, bwr:300) * amp;
	sig = sig.softclip;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

/*
(
Pbindef(\glitchA,
	\instrument, \glicth1,
	\scale, Scale.minor,
	\octave, 3,
	\degree, 0, //Pxrand([0,2,4],inf),
	\dur, Prand([0.25, 0.125],inf), //Prand([Pn(0.25,2),Pn(0.125,2)],inf),
	\decay, Pexprand(0.1, 0.001, inf),
	\amp, 1, //Pwhite(0.3, 0.9, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf)
).quant_(1);
);

Pbindef(\glitchA).clear;
Pbindef(\glitchA).play;
Pbindef(\glitchA).stop;*/

(
Pbindef(\glitchB,
	\instrument, \glitch2,
	\dur, Pbjorklund2(3,4,inf,Prand([2,4],inf).asStream)/4,
	\amp, 5,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf),
	\lag, 0.0 //0.112
).quant_(1);
);

Pbindef.gui;
Pbindef(\glitchB).stop;
Pbindef(\glitchB).play;


(
SynthDef(\hiSin, {
	|freq=16000, atk=1,rel=0, out=0, amp=1.0|
	var env =EnvGen.ar(Env.perc(atk, rel, curve:[4,-4]), doneAction:2);
	var sig = SinOsc.ar(freq, [0.0, 0.5pi], mul:env) * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\hiSin);

(
Pbindef(\hi,
	\instrument, \hiSin,
	\freq, 16000,
	\amp, 0.4,
	\dur, 2,
	\atk, Pkey(\dur),
	\rel, 0.0,
	\pan, Pseq([-1.0, 1.0], 1)
)
)
Pbindef(\hi).play;
Pbindef(\hi).stop;

(
Pbindef(\hi2,
	\instrument, \hiSin,
	\octave, Prand([9, 10], inf),
	\root, 5,
	\scale, Scale.minor,
	\degree, Prand([0], inf),
	\amp, 0.2,
	\dur, Prand([0.25, Pn(0.125,2)], inf),
	\atk, 0.0,
	\rel, 0.025,
	\pan, Pseq([-1.0, 1.0], inf),
	\addAction, 1
).quant_([4,0]);
)
Pbindef(\hi2).play;
Pbindef(\hi2).stop;
(
Pbindef(\chirp,
	\instrument, \hiSin,
	\freq, 14000, //Pexprand(14000, 17000, inf),
	\amp, 0.8,
	\atk,0.0,
	\rel, 0.001,
	\dur, Pseq([Pn(0.125,Prand((3..5),inf).asStream), 4], inf)
)
)
Pbindef(\chirp).play;
Pbindef(\chirp).stop;


// MIDI STUFF ////////////////////////////////////////////////////
(
~padA1.free;
~padA1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A1 pressed - kick ON".postln;
		Pbindef(\k).play;
	}, {
		"pad A1 released - kick OFF".postln;
		Pbindef(\k).stop;

	});
},20);

~padA2.free;
~padA2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A2 pressed - snare ON".postln;
		Pbindef(\s).play;
	}, {
		"pad A2 released - snare OFF".postln;
		Pbindef(\s).stop;

	});
},21);


~padA3.free;
~padA3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A3 pressed - hihat ON".postln;
		Pbindef(\hh).play;
	}, {
		"pad A3 released - hihat OFF".postln;
		Pbindef(\hh).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed - cymbal ON".postln;
		Pbindef(\cymbal).play;
	}, {
		"pad A4 released - cymbal OFF".postln;
		Pbindef(\cymbal).stop;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed - bass (a.k.a. lo) ON".postln;
		Pbindef(\bass).play;

	}, {
		"pad A5 released - bass (a.k.a. lo) OFF".postln;
		Pbindef(\bass).stop;

	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed - pads ON".postln;
		Pbindef(\pads).play;
	}, {
		"pad A6 released - pads OFF".postln;
		Pbindef(\pads).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed - sputnik ON".postln;
		Pbindef(\sputnik).play;
	}, {
		"pad A7 released - sputnik OFF".postln;
		Pbindef(\sputnik).stop;
	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed - stabs ON".postln;
		Pbindef(\stabs).play;

	}, {
		"pad A8 released - stabs OFF".postln;
		Pbindef(\stabs).stop;
	});
},27);

~padB1.free;
~padB1 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B1 pressed - chirp ON".postln;
		Pbindef(\chirp).play;

	}, {
		"pad B1 released - chirp OFF".postln;
		Pbindef(\chirp).stop;
	});
},28);

~padB2.free;
~padB2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B2 pressed - glitchB ON".postln;
		Pbindef(\glitchB).play;
	}, {
		"pad B2 released - glitchB OFF".postln;
		Pbindef(\glitchB).stop;
	});
},29);


~padB3.free;
~padB3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B3 pressed - hi2 ON".postln;
		Pbindef(\hi2).play;
	}, {
		"pad B3 released - hi2 OFF".postln;
		Pbindef(\hi2).stop;
	});
},30);

~padB4.free;
~padB4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B4 pressed".postln;


	}, {
		"pad B4 released".postln;

	});
},31);

~padB5.free;
~padB5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B5 pressed".postln;

	}, {
		"pad B5 released".postln;

	});
},32);


~padB6.free;
~padB6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B6 pressed".postln;

	}, {
		"pad B6 released".postln;

	});
},33);

~padB7.free;
~padB7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B7 pressed".postln;
	}, {
		"pad B7 released".postln;
	});
},34);

~padB8.free;
~padB8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B8 pressed".postln;

	}, {
		"pad B8 released".postln;

	});
},35);

// KONTROLS ////////////////////////////
~k1.free;
~k1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 10, {
		//s.mute;
	}, {
		//s.unmute;
	});

},1);

~k2.free;
~k2 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	var verbwet = args[0].linlin(0, 127, 0.0, 1.0);
	("verb wet " ++ verbwet.round(0.001)).postln;
	~verb.set(\dec,2, \lpf,5000, \wet, verbwet);

},2);

~k3.free;
~k3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~bass_freq = args[0].linexp(0,127,200, 7000.0);
},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~bass_rq = args[0].linexp(0,127,1, 0.01);

},4);

~k5.free;
~k5 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	~vocoder_amp = args[0].linlin(0,127,0.0, 1);
	("~vocoder_amp = " ++ ~vocoder_amp.round(0.001)).postln;
},5);

~k6.free;
~k6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},6);

~k7.free;
~k7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},7);

~k8.free;
~k8 = MIDIFunc.cc({
	arg ...args;
	args.postln;
},8);
)


// vocoder experimental

// Db Fm Eb
(
Pbindef(\chords,
	\instrument, \vocoder_synth,
	\scale, Scale.minor,
	\root, 5,
	\octave, Prand([3,4,5,6], inf).clump(4),
	\degree, Pseq([
		Pn([0,2,3,4],16 * 2), // Db
		Pn([0,2,4,7],8 * 2), // Fm
		Pn([-1,1,3,4],8 * 2) // Eb maj
	], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(4),
	\width, 0.01, //Pwhite(0.01, 0.5, inf).clump(4),
	\in, ~bus_modulator,
	\atk, 0.5,
	\rel, 1,
	\amp, Pgauss(0.125, 0.1, inf).clump(4) * 0.5,
	\dur, 0.25,
	\group, ~grp_vocoders,
	\pan, Pwhite(-1.0, 1.0, inf).clump(4),
	\addAction, 0
).quant_([4]).stop.play;
)
Pbindef(\chords).stop;