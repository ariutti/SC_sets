// echoplex - nine inch nail (Ghost VI)n
// forse Dixie Dregs: Free Falls


// BPM : 115
t.tempo_(115/60)

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,500, \wet,1.0);
~verb.free;

(
~root = 9; // A minor
~scale = Scale.minor;
~bass_freq = 5000;
~bass_rq   = 0.1;
)


(
Pbindef(\lead,
	\instrument, \acid,//\syncsaw, // \fm4_perc
	\root, Pfunc({~root}), // D
	\octave, [2,3,4],
	\scale, Pfunc({~scale}),
	\atk, 0.01,
	\rel, 1, //[0.5,0.3,0.1],
	\amp, 0.3,
	\degree, Pseq([0,0,0,-1,0],inf).collect({|n| n}),
	\dur, Pseq([1,1,0.25,0.75,1],inf),
	\addAction, 1,
	\sustain, 0.125,
	\rf, Pfunc({~bass_freq}), \rq, Pfunc({~bass_rq}),
	\fatk, 0.01, \fdcy, 0.05, \fsus,0.7, \frel,Pkey(\rel)*0.5,\famp,1,
	\addAction,1
).quant_([4]).play;
)
Pbindef(\lead, \addAction, 1)


// cassa storta ( non usare il rullante in questo caso)
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([1],inf),\rel,0.2,\rate,1,\amp,4,\addAction,1).quant_([4,0.5]).stop.play;
)


(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([1],inf),\rel,0.2,\rate,1,\amp,4,\addAction,1).quant_([4,0]).stop.play;
)


// PADS ///////////////////////////////////////////////////////////////////////////////////////
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
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\octave, Prand([3,4,5],inf).clump(3),
	\degree, Pseq([
		[0,2,4]
	], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(3),
	\amp, Pgauss(0.1, 0.01, inf).clump(3) * 0.6,
	\rq, Pwhite(2, 0.5, inf),
	\dur, Prand([4], inf),
	\addAction,0
).quant_(4).stop.play;
)
Pbindef(\pads).stop;


//////////////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([1],inf),\rel,0.2,\rate,1,\amp,8,\addAction,1).quant_([4,0]).stop.play;
)

(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([Pn(2,2), Pn(1,2), 0.5],inf),\rel,0.2,\rate,1,\amp,4,\addAction,1).quant_([4,0]).stop.play;
)

(
// dry kick
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,8,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;
)

(
// more deep kick
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,1,\amp,1,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;


// hh in levare
// snare con rimshot

//Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,1,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;


Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,2,\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,1,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).play;




// add more elements
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][0],\dur,2,\amp,4,\atk,0.0,\rel,5,\rate,1,\addAction,1).quant_([4,1]).stop.play;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,1,\amp,0.8,\atk,0.0,\rel,0.1,\rate,1,\addAction,1,\lag,0.0, \stretch, 1).quant_([4,0.5]).stop.play;

Pbindef(\hh2,\instrument,\bplaym,\buf,~dirt["drumtraks"][7],\dur,0.25,\amp,0.5,\atk,0.0,\rel,Prand([0.05,0.1],inf),\rate,Pwhite(0.99,1.01,inf),\addAction,1).quant_([4,0]).play;
)




/////////////////////////////////////////////////////////////////////////////////////////


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
	\octave, Pseq([3],inf).clump(2),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, 0, //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\fb, Pwhite(0.9, 1.1, inf),
	\atk, 0.0,
	\rel, 4,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 0.6,
	\strum, 0,
	\addAction, 0
).quant_([4, 1]).stop.play;
)
Pbindef(\stabs).stop


(
Pbindef(\pads).stop;
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,2,\amp,1,\atk,0.0,\rel,0.1,\rate,1.5,\addAction,1, \stretch, 0.5).quant_(4).play;
)

Pbindef(\k).play;

Pbindef(\s,\instrument,\bplay,\buf,~dirt["tech"][11],\dur,2,\rel,0.3,\rate,1,\dist,Prand([6,100],inf),\amp,1,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).play;



Pbindef(\s,\instrument,\bplay,\buf,~dirt["tech"][11],\dur,2,\atk, 0.0,\rel,0.15,\rate,0.8,\amp,5,\addAction,1).quant_([4,1]).play;

Pbindef(\hh,\instrument,\bplay,\buf,~dirt["tech"][8],\dur,1,\rel,1,\rate,1,\dist,Prand([6,100],inf),\amp,6,\addAction,1).quant_([4,0.5]).stop.play;



// 6 bella kick
// 8 - tamburello




(
Pbindef(\s).play;
Pbindef(\k, \dur, 2, \).play;
Pbindef(\hh).play;
Pbindef(\clap).play;
)

Pbindef(\test).stop;
Pbindef(\k).stop;

Pbindef(\stabs).play;



// INTERROMPI TUTTO ////////////////////////////////
(
Pbindef(\k).stop; //, \buf, ~dirt["drumtraks"][6],\dur, 2,\amp, 16, \rel, 0.1).play;
Pbindef(\lead).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\hh2).stop;
Pbindef(\clap).stop;
Pbindef(\stabs).stop;
Pbindef(\snap).stop;
Pbindef(\cymbal).stop;
)



// riparti con la cassa dritta ////////////////////
(
Pbindef(\lead).play;
Pbindef(\k, \buf, ~dirt["drumtraks"][6],\dur, 1,\amp, 8, \rel, 0.1).quant_([4,0]).stop.play;
//Pbindef(\s, \instrument, \bplay, \buf, d["s"][3], \amp, 1).play;
Pbindef(\k).play;
Pbindef(\hh).play;
Pbindef(\hh2).play;
Pbindef(\clap, \addAction, 1).play;
Pbindef(\stabs, \addAction, 1).play;

//Pbindef(\hh,\instrument,\bplay,\buf,~dirt["tech"][8],\dur,0.25,\rel,0.05,\rate,1,\dist,Prand([6,100],inf),\amp,6,\addAction,1).quant_([4]).play;

Pbindef(\stabs,
	\instrument, \sinfb,
	\octave, Pseq([3,4],inf).clump(2),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, 0, //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 1.2,
	\atk, 0.0,
	\rel, 0.6,
	\dur, 4,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 0.5,
	\strum, 0,
	\addAction, 0
).quant_([4, 1]).stop.play;

)



(
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 0.3,\rel,0.125,\rate,1.1 * Pgauss(1, 0.07, inf).clump(2),\addAction,0, \lag,0,\strum, 0, \pan, [-1, 1]).quant_([4,1]).stop.play;
)



(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,0, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,1]).stop.play;
)

// nella ///////////////////////////////////////////////////////////////////////////////////////////////////////


(
Pbindef(\cymbal,\instrument,\bplaym,\buf,d["oh_mono"][1],\dur,8,\amp,0.2,\atk, 0.0, \rel,5,\rate, 0.35,\addAction,0, \pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,0]).stop.play;
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
	\amp, Pseq([Pn(\,3), 30],inf) * 0.1,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\cymbal).stop;



// nella ///////////////////////////////////////////////////////////////////////////////////////////////////////
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
		Pbindef(\clap).play;
	}, {
		"pad A2 released - snare OFF".postln;
		Pbindef(\s).stop;
		Pbindef(\clap).stop;

	});
},21);


~padA3.free;
~padA3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A3 pressed - hihat ON".postln;
		Pbindef(\hh).play;
		Pbindef(\hh2).play;
	}, {
		"pad A3 released - hihat OFF".postln;
		Pbindef(\hh).stop;
		Pbindef(\hh2).stop;
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
		"pad A6 pressed - claps ON".postln;
		Pbindef(\pads).play;
	}, {
		"pad A6 released - claps OFF".postln;
		Pbindef(\pads).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed - lead ON".postln;
		Pbindef(\lead).play;
	}, {
		"pad A7 released - lead OFF".postln;
		Pbindef(\lead).stop;
	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed - stabs ON".postln;
		Pbindef(\pads).play;
		Pbindef(\stabs).play;

	}, {
		"pad A8 released - stabs OFF".postln;
		Pbindef(\pads).stop;
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
	var bass_cf = args[0].linexp(0, 127, 200.0, 7000.0);
	("bass cf " ++ bass_cf.round(0.001)).postln;
	~bass_freq = bass_cf; //args[0].linexp(0,127,200, 7000.0);
},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	var bass_rq = args[0].linexp(0, 127, 1.0, 0.01);
	("bass rq " ++ bass_rq.round(0.001)).postln;
	~bass_rq = bass_rq; //args[0].linexp(0,127,1, 0.01);

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