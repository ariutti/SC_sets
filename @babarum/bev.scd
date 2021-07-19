// BEV
// This is also the home of the acid Bass patch :)

t = TempoClock.default;
t.tempo_(120/60);
s.meter
Tdef(\chordChanger).stop;

// MIDI IN ///////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;


// bev samples is @ 120 BPM
// is made of 8 bars
// with the following chords
// Cm  | Bb    | Gm   | Abmaj || Cm  | Bb   | Gm    | Abmaj ||
// in terms of normalized position, each chord lives @
// 0.0 | 0.125 | 0.25 | 0.375 || 0.5 | 0.625 | 0.75 | 0.875 ||


// EVALUATE THIS FIRST !!!!!!
(
~tonica = 0;
~root = 0;
~bass_freq = 130;
~bass_rq   = 1;
)

//~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
//~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);


// BEV VOICE //////////////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\bplay_filt,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, cf=500, rq=0.1;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(0.001,rel,0.001),doneAction:2);
		sig = BPF.ar(sig, cf, rq);
		sig = HPF.ar(sig, 500);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

Pbindef(\bev).stop;


// complete phrase
(
Tdef(\chordChanger).stop;
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 1.5,
	\cf, 1000,
	\rq, 4,
	\rel, t.beatDur * 16 * 2,
	\dur, 16 * 2,
	\pos, 0.0,
	\rate, 1,
	\pan, 0.0,
	\addAction, 1
).quant_([4,0]).stop.play;
)

// first sliced
(
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\degree, Pseq([0],inf),
	\cf, 1000,
	\rq, 4,
	\rel, 0.25,
	\dur, 0.5,
	\pos, Pseq([  0,  1,  2,  3,  4,  5,  6,  7]/8,inf),
	\amp, Pseq([1.5,1.5,1.5,1.5,1.5,1.5,1.2,1.5],inf),
	\rate, Prand([1], inf),
	\pan, 0.0,
	\addAction, 1
).quant_([4,0]).play;
)

// second sliced
(
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\degree, Pseq([0],inf),
	\cf, 5000,
	\rq, 4,
	\rel, 0.25,
	\dur, 0.5,
	\pos, Pseq([  0,  3,  2,  0,  4,  7,  6,  7]/8,inf),
	\amp, Pseq([1.5,1.5,1.5,1.5,1.5,1.5,0.9,1.5],inf),
	\rate, Prand([[1,1],[2,1]], inf),
	\pan, 0.0,
	\addAction, 1
).quant_([4,0]).play;
)

// texture A
(
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\degree, Pseq([0],inf),
	\amp, 1,
	\cf, Pseg([100, 5000, 100],[8,8],\exp, inf),
	\rq, 2,
	\rel, t.beatDur * 0.125, //Prand([0.25, 0.125], inf),
	\dur, 0.25,
	//\pos, Pseq((0..6).pyramid(2), inf)/8,
	//\pos, Prand(((0..100)/100).round(0.125),inf),
	//\pos, 0.0,
	\pos, 0.125, //Pstutter(8, Pseq([0.0, 0.15, 0.5, 0.125],inf)), //0.15, //Prand([0.125, 0.0, 0.25], inf),
	\rate, [0,12].midiratio, //Prand([1,2,[1,2]], inf),
	\pan, Pseq([-1, 1],inf),
	\addAction,0
).quant_([4,0]).play;
)


// texture Abis (alternate)
(
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\degree, Pseq([0],inf),
	\amp, 1,
	\cf, Pseg([100, 5000, 100],[8,8],\exp, inf),
	\rq, 2,
	\rel, 0.125, //Prand([0.25, 0.125], inf),
	\dur, 0.25,
	//\pos, Pseq((0..6).pyramid(2), inf)/8,
	//\pos, Prand(((0..100)/100).round(0.125),inf),
	//\pos, 0.0,
	\pos, 0.125, //Pstutter(8, Pseq([0.0, 0.15, 0.5, 0.125],inf)), //0.15, //Prand([0.125, 0.0, 0.25], inf),
	\rate, [0,12].midiratio, //Prand([1,2,[1,2]], inf),
	\pan, Pseq([-1, 1],inf),
	\addAction,0
).quant_(1).play;
)


// texture Atris (more space between slices)
(
Pbindef(\bev,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 1,
	\atk, 0.0,
	\cf, Pseg([100, 5000, 100],[4,4],\exp, inf),
	\rq, 2,
	\dur, 0.5,
	\rel, 0.5,
	\rel, t.beatDur * 0.25, //Prand([0.25, 0.125], inf),
	//\pos, Pseq((0..6).pyramid(2), inf)/8,
	//\pos, Prand(((0..100)/100).round(0.125),inf),
	\pos, Pseq([Pn(0.0, 16), Pn(0.5, 16)],inf),
	//\pos, Pseq((0..3),inf)/8,
	\rate, 1, //Prand([1,2,[1,2]], inf),
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).play;
)


Pbindef(\bev).stop;
Pbindef(\bev,\amp, 0.0);


Tdef(\chordChanger).stop;
(
Pbindef(\bev, \pos, Prand([0.0, 0.5], inf)); // Cm
~tonica = 0;
)
(
Pbindef(\bev, \pos, Prand([0.125, 0.625], inf)); // Bb
~tonica = -1;
)
(
Pbindef(\bev, \pos, 0.25); // Gm
~tonica = -3;
)
(
Pbindef(\bev, \pos, Prand([0.325, 0.875],inf)); // Abmaj
~tonica = -2;
)


Pbindef(\bev, \pos, 0.5); // Cm
Pbindef(\bev, \pos, 0.625); // Bb
Pbindef(\bev, \pos, 0.75); // Gm (don't use it)
Pbindef(\bev, \pos, 0.875); // Abmaj


// TDEF TONE CHANGER //////////////////////////////////////////////////////////////////////////////////
(
Tdef(\chordChanger, {

	// chord progression Cm | Ab | Bb | Cm ||
	//var pos    = Pseq([ Prand([0.0, 0.5], 1), Prand([0.325, 0.875],1), Prand([0.125, 0.625], 1), Prand([0.0, 0.5], 1)], inf).asStream;
	//var tonica = Pseq([0,      -2,    -1,   0], inf).asStream;
	// chord progression Cm | Ab | Bb | Cm ||
	var pos    = Pseq([ Prand([0.0, 0.5], 1), Prand([0.325, 0.875],1), Prand([0.125, 0.625], 1), Prand([0.125, 0.625], 1)], inf).asStream;
	var tonica = Pseq([0,      -2,    -1, -1], inf).asStream;
	loop{
		Pbindef(\bev, \pos, pos.next);
		~tonica = tonica.next;
		switch( ~tonica,
			( 0), {"Cm".postln;},
			(-2), {"Ab".postln;},
			(-1), {"Bb".postln;},
		);
		wait(4);
	};
}).quant_([4,0,0.1]);
)


(
SynthDef(\varsaw, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,width=0.5, dist=1.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = VarSaw.ar(freq, width:width, mul:dist).tanh;
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Tdef(\chordChanger).play;

// plain chords
Pbindef(\chords,
	\instrument, \varsaw,
	\scale, Scale.minor,
	\octave, Prand([5,6], inf).clump(3),
	\root, 0,
	\degree, Pfunc({~tonica}) + Pseq([[0,2,4]], inf), //Pseq([[0,2,4], [-2,0,2], [-1,1,2],[0,2,4]],inf), // Cm, Abmaj, Bb, Cm
	\mtranspose, Pwhite(0.0, 0.001, inf).clump(3),
	\width, 0.3,
	\dist, 1,
	\amp, 0.1,
	\atk, 1,
	\rel, 7,
	\dur, 4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 0,
	\strum, 0.001
).quant_([4,0]).play;

Pbindef(\k,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,4,\amp,2,\rel,0.5,\rate,0.9,\addAction,1).quant_([4,0]).stop.play;
)

Tdef(\chordChanger).stop;
Tdef(\chordChanger).clear;


// PADS //////////////////////////////////////////////////////////////////////////////////

/*
(
SynthDef(\organ, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,n=8, dist=1.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = Blip.ar(freq, n, dist).tanh;
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)*/


Pbindef(\chords).play;
Pbindef(\chords).stop;

(
Tdef(\chordChanger).play;
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,4,\amp,2,\rel,0.5,\rate,0.9,\addAction,1).quant_([4,0]).stop.play;
Pbindef(\chords).play;
)


// a bit more aggressive (dirty) chords
(
Pbindef(\chords,
	\instrument, \varsaw,
	\width, 0.3,
	\dist, 1,
	\amp, 0.2,
	\atk, 1,
	\rel, 7,
	\dur, 4,
).quant_([4,0]).stop.play;
)

Pbindef(\chords).stop;


// more rythm!
(
Pbindef(\chords,
	\instrument, \varsaw,
	\scale, Scale.minor,
	\octave, Prand([5,6], inf).clump(3),
	\root, 0,
	//\degree, 0 + Pseq([],inf),
	\degree, Pfunc({~tonica}) + Pseq([ [0,2,4] ], inf),
	//\degree, Pseq([	Pn([0,2,4],16), Pn([-2,0,2],16), Pn([-1,1,2],16), Pn([0,2,4],16)],inf),
	\detune, Pwhite(0.0, 5, inf).clump(3),
	\width, Pwhite(0.1, 0.2,inf).clump(3),
	\dist, 5,
	\amp, 0.1,
	\atk, t.beatDur * 0.05,
	\rel, t.beatDur * 0.1,
	\dur,0.25,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 1,
	\strum, 0.001
).quant_([4,0.0]).play;
)


// BASS ///////////////////////////////////////////////////////////////////////////////////////////////
(
~bass_freq = 120;
~bass_rq   = 0.7;
)

(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	sig = Pulse.ar(freq, width:width).bipolar;
	sig = sig * env * amp;
	sig = RLPF.ar(sig, freq*8, 0.1);

	//sig = Decimator.ar(sig, 11025, 8);
	//sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


// this is my boy!!!
// WARNING: evaluate it on time
(
Pbindef(\bass,
	\instrument, \acid,
	//\dist, 20, //Pwhite(2,5,inf),
	\amp, 0.3,
	\atk, 0.0,
	\rel, 0.1,
	\width, 0.4,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([3,4], inf),
	\degree, Pfunc({~tonica}) + Pwrand([\,-1, 0,7],[2,2,4,0.5].normalizeSum, inf), //Pn(Pstutter(2, Pseq([0,2,4], 1))++Pseq([0,4], 1),inf),
	\dur, Pwrand([0.25, 0.5],[4,1].normalizeSum, inf),
	\rf, Pfunc({~bass_freq}), //3000,
	\rq, Pfunc({~bass_rq}), //0.1,
	\fatk, 0.01, \fdcy, 0.05, \fsus, 0.7, \frel, 0.5,\famp, 1,
	\pan, 0,
	\addAction, 1
).quant_([4,0]).stop.play;
)
Pbindef(\bass).clear


// DRUMS //////////////////////////////////////////////////////////////////////////////////////////////
// warm up
(
Pbindef(\sk,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,8,\amp,4,\rel,8,\rate,1,\addAction,1).quant_([4,0]).stop.play;
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,4,\amp,2,\rel,0.5,\rate,0.9,\addAction,1).quant_([4,0]).stop.play;
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["808sd"][1],\dur,Pseq([Pn(1,6), 0.25, 0.75],inf),\amp,1,\rel,0.02,\rate,0.5,\addAction,1).quant_([2, 0.5]).stop.play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.25,\amp,0.2,\rel,0.05,\rate,1,\addAction,1).quant_([2]).stop.play;
)

Pbindef(\k).stop;

(
Pbindef(\k,\dur,2);
Pbindef(\s,\dur,2);
Pbindef(\hh,\dur,0.25);
)

(
Pbindef(\k,\dur,1).play;
Pbindef(\s,\dur,1).play;
Pbindef(\hh,\dur,0.25).play;
)
Pbindef(\bass).stop;

(
Pbindef(\sk).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)

// alternate drums - four on the floor (w/ strong snare)
(
Pbindef(\sk,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,8,\amp,3,\rel,8,\rate,1,\addAction,Pseq([0,Pn(1,3)],inf)).quant_([8]).stop.play;
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,1,\amp,2,\rel,0.5,\rate,0.9,\addAction,1).quant_([4]).stop.play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][1],\dur,2,\amp,1,\rel,1,\rate,0.6,\addAction,1).quant_([4, 1]).stop.play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.25,\amp,0.2,\rel,Pseq([Pn(0.02,16+15), 2],inf),\rate,1,\addAction,1).quant_([4]).stop.play;
)

// crescendo dai dai dai (solo per poco)
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["909"][0],\dur,Pseq([0.5], inf),\amp,Pseq([1, 0.5],inf) * 2,\rel,0.25,\rate,Pseq([0.9, 0.7],inf),\addAction,1).quant_([4]).stop.play;


(
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\hh).play;
)


Pbindef.gui

// LEAD /////////////////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\lead,
	\instrument, \varsaw,
	\octave, 6,
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq([4,2,0,4,3,4,6,4,4,3], inf),
	\dur, Pseq([3,0.75,3.75, 0.25, 0.25], inf),
	\dist, 4,
	\width, 0.01,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.9,
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\lead, \dist, 4, \rel, 0.25, \width, 0.01);
Pbindef(\lead).stop;
(
Pbindef(\lead,
	\instrument, \varsaw,
	\octave, 6,
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq([0,2,4].pyramid(3), inf),
	\dur, Pseq([0.25], inf),
	\dist, 5,
	\width, 0.3,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.6,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).stop.play;
)


s.meter



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
		"pad A3 released - hihat OFF".postln;
		Pbindef(\hh).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed - subkick ON".postln;
		Pbindef(\sk).reset;
		Pbindef(\sk).play;

	}, {
		"pad A4 released - subkick OFF".postln;
		Pbindef(\sk).stop;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed - bass ON".postln;
		Pbindef(\bass).play;

	}, {
		"pad A5 released - bass OFF".postln;
		Pbindef(\bass).stop;

	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed - bev voice ON".postln;
		Pbindef(\bev).play;
	}, {
		"pad A6 released - bev voice OFF".postln;
		Pbindef(\bev).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed - chords ON".postln;
		Pbindef(\chords).play;
	}, {
		"pad A7 released - chords OFF".postln;
		Pbindef(\chords).stop;
	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed - lead ON".postln;
		Pbindef(\lead).play;

	}, {
		"pad A8 released - lead OFF".postln;
		Pbindef(\lead).stop;
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
	"WARNING: stop all".postln;
	Pbindef.all.do({ |item| item.stop; });
},35);



// KONTROLS ////////////////////////////
~k1.free;
~k1 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},1);

~k2.free;
~k2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~verb.set(\dec,2, \lpf,5000, \wet,args[0].linlin(0, 127, 0.0, 1.0) );

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


(
~drums_1.free;
~drums_1 = MIDIFunc.noteOn({
	arg ...args;
	args.postln;
	Synth(\bplaym,[\buf,~dirt["909"][0],\amp,2,\rel,0.5,\rate,0.9],addAction:1);
},44,0); // match any noteOn


~drums_2.free;
~drums_2 = MIDIFunc.noteOn({
	arg ...args;
	args.postln;
	Synth(\bplay,[\buf,d["s"][1],\amp,1,\rel,1,\rate,0.6],addAction:1);
},45,0); // match any noteOn

~drums_3.free;
~drums_3 = MIDIFunc.noteOn({
	arg ...args;
	args.postln;
	Synth(\bplaym,[\buf,~dirt["808oh"][0],\amp,0.2,\rel,1,\rate,1],addAction:1);
},46,0); // match any noteOn

)


// BEV STABS //////////////////////////////////////////////////////////////////////////////////////////
// single voice fragments

// you light up (don't use if Tdef is working)
(
Pbindef(\bev_spot,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 2,
	\rel, t.beatDur * 3,
	\cf, 1000,
	\rq, 4,
	\dur, Pseq([4],1),
	\pos, 0.0,
	\rate, 1,
	\addAction, 0
).quant_([4,0]).stop.play;
)


// bottle of wine (don't use if Tdef is working)
(
Pbindef(\bev_spot,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 3,
	\rel, t.beatDur * 4,
	\cf, 1000,
	\rq, 4,
	\dur, Pseq([4],1),
	\pos, 0.25,
	\rate, 1,
	\addAction, 0
).quant_([4,0]).stop.play;
)

// story (don't use if Tdef is working)
(
Pbindef(\bev_spot,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 0.7,
	\rel, t.beatDur * 2,
	\cf, 1000,
	\rq, 4,
	\dur, Pseq([4],1),
	\pos, 0.75,
	\rate, 1,
	\addAction, 0
).quant_([4,0]).stop.play;
)

// you get alive (don't use if Tdef is working)
(
Pbindef(\bev_spot,
	\instrument, \bplay_filt,
	\buf, ~dirt["bev"][1],
	\amp, 3,
	\rel, t.beatDur * 4,
	\cf, 1000,
	\rq, 4,
	\dur, Pseq([4],1),
	\pos, 0.806,
	\rate, 1,
	\addAction,1
).quant_([4,0]).stop.play;
)
Pbindef(\bev_spot).stop