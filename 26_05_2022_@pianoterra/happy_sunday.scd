
// USED SAMPLES
// d["c"][0]
// ~dirt["808oh"][1]
// ~vincent = Buffer.read(s, "/home/nicola/Scaricati/Telegram Desktop/vincent_price_MLgenerated_test1.wav");




//TempoClock.default.tempo_(90/60);
(
TempoClock.default.tempo_(136/60);
Tdef(\chordChanger).stop;
~scale = Scale.diminished;
~root = 2;
)

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
Pbindef(\A).clear;
Pbindef(\A,
	\instrument, \test,
	\octave, Pseq([4,6],inf).clump(2),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, Pseq([Pseq([2,3],8) ,Pseq([0,1],8)], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\fb, Pwhite(0.1, 1, inf).clump(2),
	\atk, 0.01,
	\rel, 0.1,
	\dur, 0.5,
	\amp, 1.6 * Pgauss(0.2, 0.01, inf).clump(2),
	\strum, 0,
	\addAction, 0
).quant_([4]).play;
)

// fire clackle!! (to be used later)
(
Pbindef(\A,
	\instrument, \test,
	\octave, Pseq([6,7,8],inf).clump(4),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\mtranspose, Pwhite(-1, 1, inf).clump(2) * Pseg([0.0, 0.04],[4],\lin, inf),
	\fb, Pwhite(0.1, 1, inf).clump(4),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 2 * Pgauss(0.1, 0.01, inf).clump(2),
	\strum, 0.1,
	\addAction, 1
).quant_([4]).play;
)
Pbindef(\A).play;
Pbindef(\A).stop;


(
SynthDef(\saw, {
	|
	freq=440, amp=1.0, atk=0.01, rel=0.1, gate=1, pan=0.0,
	fb=0.1, dist=1.0, rq=0.01
	|
	var env = EnvGen.ar(Env.adsr(atk, 0.0, 0.7, rel),gate, doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env;
	sig = RLPF.ar(sig, freq*8, rq);
	// added a HPF in order not to create disorder in low frequencies
	sig = HPF.ar(sig, 120);
	sig = (sig *dist).tanh;

	Out.ar(0, Pan2.ar(sig*amp, pan));
}).add;
);

// dark and gloomy vibrations
(
Pbindef(\B,
	\instrument, \saw,
	\octave, Pseq([2,3,4],inf).clump(4),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	//\degree, Pseq((0..7), inf),
	\degree, Pseq([Pseq([[2,2]],4), Pseq([[0,0]],4)], inf),
	\mtranspose, Pwhite(-0.001, 0.001, inf).clump(4),
	\fb, 0.6,
	\rq, 0.1,
	\dist, 2,
	\atk, 0.1,
	\rel, 1,
	\dur, 2,
	\amp, 0.3,
	\pan, Pwhite(-1.0, 1.0, inf).clump(4),
	\addAction,0
).quant_([4]).stop.play;
)
Pbindef(\B).stop;

// which now became frenetic and terrible
(
Pbindef(\B,
	\fb, Pseg([0.1, 1, 0.1],[4,4],\exp,inf),
	\rq, Pseg([0.1, 0.001, 0.1],[8,8],\lin,inf),
	\dist, Pseg([1, 200, 1],[16,16],\exp,inf),
	\amp, 0.2
);
Pbindef(\B, \degree, Pseq([Pseq([[2,2]],8), Pseq([[0,0]],8)], inf));
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
	\atk, 0.0, \rel, 0.1,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 100, \matk, 0.01, \mrel, 0.01,
	\dist, 1.0,
	\amp, 16,
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
	\amp, 0.7,
	\dur, Pseq([2], inf),
	\addAction,1
).quant_([4,1]).stop.play;
)
Pbindef(\s).stop;


Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,Prand([4,16],inf),\amp,0.5,\rate, 0.7,\rel, 0.1,\addAction, 0).quant_([4,1]).stop.play

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
// super groovy hi-hat!!!
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.25,\amp,2,\rel,Pseq([Pn(0.02,16+15), 2],inf),\rate,1,\addAction,1).quant_([4]).play;
Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,Prand([4,16],inf),\amp,0.5,\rate, 0.7,\rel, 0.1,\addAction, 0).quant_([4,1]).stop.play;
)

(
// alternate HH and clap (use to make some transition)
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,Pseq([1.5,2.5],inf),\amp,3,\rel,0.7,\rate,0.7,\addAction,1).quant_([4,2]).stop.play;
Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,Prand([4],inf),\amp,0.5,\rate, 0.7,\rel, 0.1,\addAction, 0).quant_([4,1]).stop.play;
)



// VOICE of VINCENT PRICE ////////////////////////////////////////////////////
~vincent = Buffer.read(s, "/home/nicola/Scaricati/Telegram Desktop/vincent_price_MLgenerated_test1.wav");

Pbindef(\vincent,\instrument,\bplaym,\buf,~vincent,\dur,Pseq([1],1),\amp,5,\rel,15,\rate,1,\addAction,1).quant_(1).play;



// SOUND FX //////////////////////////////////////////////////////////////////
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
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, 5,
	\degree, 6,
	\dur, Pseq([8],1),
	\l, 2,
	\amp, 0.3,
	\addAction, 0,
	\pan, 0.0
).quant_([4,1]).stop.play;
)
Synth(\osc, [\freq, 400,\amp,0.05]);
Pbindef(\oua).stop;


(
Pbindef(\oua,
	\instrument, \osc,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, 6, // also try with 3
	\degree, Pseq( (0..7), inf),
	\dur, 0.5,
	\l, t.beatDur * 0.25,
	\amp, Pseg([0.5, 1.0], 4, \exp, inf) * 0.4,
	\addAction, 1,
	\pan, Pseq([1, -1],inf)
).quant_([4,1]).stop.play;
)
Pbindef(\oua).clear;
Pbindef(\oua).stop;

// STABS /////////////////////////////////////////////////////////////////////
(
Pbindef(\stabs,
	\instrument, \test,
	\scale, Pfunc({~scale}),
	\octave, Pseq([4,5],inf).clump(2),
	\root, Pfunc({~root}),
	\degree, [2, 0], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.2,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 3,
	\strum, 0,
	\addAction, 0
).quant_([4, 1.5]).stop.play;
)
Pbindef(\stabs).stop;
Pbindef(\stabs).play;
Pbindef(\stabs).clear;


// MIDI IN ////////////////////////////////////////////////////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;


// PADS ////////////////////////////////////////
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
		"pad A3 released - hihat ON".postln;
		Pbindef(\hh).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed - clap ON".postln;
		Pbindef(\clap).play;

	}, {
		"pad A4 released - clap OFF".postln;
		Pbindef(\clap).stop;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed - oua ON".postln;
		Pbindef(\oua).play;

	}, {
		"pad A5 released - oua OFF".postln;
		Pbindef(\oua).stop;

	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed - B ON".postln;
		Pbindef(\B).play;
	}, {
		"pad A6 released - B OFF".postln;
		Pbindef(\B).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed - A ON".postln;
		Pbindef(\A).play;
	}, {
		"pad A7 released - A OFF".postln;
		Pbindef(\A).stop;
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

/*********************************************************/

~padB1.free;
~padB1 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B1 pressed".postln;

	}, {
		"pad B1 released".postln;

	});
},28);

~padB2.free;
~padB2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B2 pressed".postln;

	}, {
		"pad B2 released".postln;

	});
},29);


~padB3.free;
~padB3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B3 pressed".postln;

	}, {
		"pad B3 released".postln;

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
	//args.postln;
},1);

~k2.free;
~k2 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	var verb = args[0].linlin(0, 127, 0.0, 1.0);
	("verb " + verb.round(0.001)).postln;
	~verb.set(\dec,2, \lpf,5000, \wet, );

},2);

~k3.free;
~k3 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	//~bass_freq = args[0].linexp(0,127,200, 7000.0);
},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	//~bass_rq = args[0].linexp(0,127,1, 0.01);

},4);

~k5.free;
~k5 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	//~vocoder_amp = args[0].linlin(0,127,0.0, 1);
	//("~vocoder_amp = " ++ ~vocoder_amp.round(0.001)).postln;
},5);

~k6.free;
~k6 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
},6);

~k7.free;
~k7 = MIDIFunc.cc({
	arg ...args;
	//args.postln;

},7);

~k8.free;
~k8 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
},8);
)
