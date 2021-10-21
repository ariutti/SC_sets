t = TempoClock.default

// CHORDS
// 1  2  3  4 | 1 2 3 4 | 1 2 3 4 ||
// Bm7 - F#m7 | G       | -       ||
// D   - A    | G       | -       ||
// D   - A    | Em      | -       ||

(
t.tempo_(60/60);
Tdef(\chordChanger).stop;
~tonica = 0;
~root = 2; // D
)

Pbindef.gui

// MIDI IN ///////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;

s.plotTree;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,2.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,2);
s.meter;


// it seems to me that major sitar arpeggio are those with indexes:
// 1, 2, 4, 6
(
Pbindef(\sitar,
	\instrument,\bplaym,
	\buf, Pseq([~dirt["sitar"][6]],1) ++ Pindex( ~dirt["sitar"], Prand([1,2,4,6],inf), inf),
	\dur, Prand([7,11,13],inf),
	\amp, 1,
	\rel, 15,
	\rate, 1,
	\addAction,0
).quant_(4).play;
)
Pbindef(\sitar).stop;


(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Prand([4,5,6], inf),
	\degree, Pfunc({~tonica}) + Pseq([0,4],inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf),
	\fb, 0.5,
	\amp, 0.05,
	\atk, 2,
	\rel, 2,
	\dur, 0.125,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).play;
)

Pbindef(\pads).stop
Pbindef(\pads, \fb, 1.3);


(
Pbindef(\bass,
	\instrument, \ring1,
	\root, Pfunc({~root}),
	\octave, 1 + [3,4], // 1+ [3,4,7]
	\degree, Pfunc({~tonica}) + Pseq([
		Pseq([-2,-5,-4], 1), // Bm7 | F#m7 | G
		Pseq([0,-3,-4], 1),  // D   | A    | G
		Pseq([0,-3,-6], 1),  // D   | A    | Em
	],inf),
	\mtranspose, Pwhite(0.0, 0.02, inf) * [0, 0, 1],
	\dist, 4,
	\amp, 0.3 * [1,1,0.125],
	\atk, 0.01,
	\dur, Pseq([2,2,8], inf),
	\rel, Pkey(\dur) * t.beatDur * 2,
	\pan, [0, 0, Pseq([-1, 1], inf).asStream],
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\bass).clear;
Pbindef(\bass).stop


(
Pbindef(\tabla,
	\instrument,\bplay,
	\buf, Pindex(~dirt["tabla"], Prand((0..~dirt["tabla"].size-1),inf), inf),
	\dur, Prand([1,2,4], inf),
	\amp, Pgauss(0.5, 0.1, inf) * 2,
	\rel,15,
	\rate,1,
	\addAction,1
).quant_([4, 0.5] ).stop.play;
)
Pbindef(\tabla).stop;


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,1,\rel,0.4,\rate,0.7,\addAction,0).quant_(4).play;


Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,2,\rel, 0.05, \rate, 2,\amp, Pgauss(0.9,0.1, inf)).quant_([4, 0.5]).play;


Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,2,\amp,0.8,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;


//some sort of glithes
(
Pbindef(\yeah,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["yeah"], Prand((0..~dirt["yeah"].size-1),inf), inf),
	\dur, 0.25,
	\amp, Pgauss(0.5, 0.1, inf),
	\rel,1,
	\rate,1,
	\addAction,1
).quant_(4).play;
)
Pbindef(\yeah).stop;



// MELODY FIRST TIME ///////////////////////////////////////////////////////////////////////////
(
Pbindef(\melody,
	\instrument, \fm4_perc,
	\root, Pfunc({~root}),
	\octave, Prand([5,6], inf),
	\degree, Pfunc({~tonica}) + Pseq([0,1],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, Pseg([0.1, 0.3], [4],\lin, inf),
	\atk, 0.2,
	\rel, 0.01,
	\dur, 0.25,
	\n1, Prand([1,2], inf), //Pseg([1,4], [8], \lin, inf).round(0.125),
	\n2, Prand([2,3,4,5,6,7,8], inf),
	\mi, Pseg([10, 5000], [2], \exp, inf),
	\iatk, 0.0,
	\irel, 0.05,
	\iAdd, 0,
	\pan, Pseq([-1.0, 1.0], inf),
	\lag, Pwhite(0.0, 0.025, inf),
	\addAction, 0
).quant_([4,0.5]).stop.play;
)
Pbindef(\melody).stop;
Pbindef.gui;

/// double (maybe later)
(
Pbindef(\bass,
	\instrument, \ring1,
	\root, Pfunc({~root}),
	\octave, 1 + [3,4,5], // 1+ [3,4,7]
	\degree, Pfunc({~tonica}) + Pseq([
		Pseq([Pn(-2,8),Pn(-5,8),Pn(-4,16)], 1), // Bm7 | F#m7 | G
		Pseq([Pn(0,8),Pn(-3,8),Pn(-4,16)], 1),  // D   | A    | G
		Pseq([Pn(0,8),Pn(-3,8),Pn(-6,16)], 1),  // D   | A    | Em
	],inf),
	\mtranspose, Pwhite(0.0, 0.02, inf) * [0, 0, 1],
	\dist, 10,
	\amp, 0.3 * [1,1,0.125],
	\atk, 0.01,
	\dur, 0.25, //Pseq([Pn(4, 0.5), Pn(4,0.5),Pn(16,0.5)], inf),
	\rel, 0.2, //Pkey(\dur) * t.beatDur * 2,
	\pan, [0, 0, Pseq([-1, 1], inf).asStream],
	\addAction,1
).quant_([4,0]).play;
)



(
Pbindef(\speak,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["speech"], Prand((0..~dirt["speech"].size-1),inf), inf),
	\dur, Prand([0.25, 0.5], inf),
	\amp,0.25,
	\rel,10,
	\rate,1.3,
	\addAction, 0 //Prand([0,1], inf)
).quant_(4).play;
)
Pbindef(\speak).stop;


// DRUM VARIATIONS ///////////////////////////////////////////////////////////////////////////////
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,1,\rel,0.4,\rate,0.7,\addAction,0).quant_(4).play;


// soft drums (already playing)
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,1,\rel,0.4,\rate,0.7,\addAction,0).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,2,\amp,0.6,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,2,\rel, 0.05, \rate, 2,\amp, Pgauss(0.4,0.01, inf)).quant_([4, 0.5]).play;
)

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)

(
Pbindef(\yeah).stop;
Pbindef(\speak).stop;
)

Pbindef.gui;

// kick: four on the floor @ 60 is too sloe
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,3,\rel,0.4,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,2,\amp,0.6,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,2,\rel, 0.05, \rate, 2,\amp, Pgauss(0.4,0.01, inf)).quant_([4, 0.5]).play;
)


// kick variation
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pwrand([1, Pn(0.5, 2), Pseq([0.25, 0.75],1)],[10,1,3].normalizeSum, inf),\amp,1,\rel,0.4,\rate,0.7,\addAction,1).quant_(4).play;


// violent kick (in otto)
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,0.25,\amp,2,\rel,0.4,\rate,0.7,\addAction,1).quant_(4).play;

(
// super kick
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Prand([0.5, Pn(2,0.25)],inf),\amp,8,\rel,0.03,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][2],\dur,1,\amp,4,\rel,0.05,\rate,0.7,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,0.5]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\rel, 0.05, \rate, 2,\amp, Pgauss(0.4,0.01, inf) * 1).quant_([4, 0.5]).play;
)


Pbindef.gui;

// MELODY ///////////////////////////////////////////////////////////////////////////////////


(
Pbindef(\melody,
	\instrument, \fm4_perc,
	\root, Pfunc({~root}),
	\octave, 7, //Prand([5,6,7], inf),
	\degree, Pfunc({~tonica}) + Pseq([2,0,-3],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, Pseg([0.1, 0.3], [4],\lin, inf) * 3,
	\atk, 0.0,
	\rel, 0.2,
	\dur, Pseq([0.25, 0.25, 0.5], inf),
	\n1, 1, //Prand([1,2], inf), //Pseg([1,4], [8], \lin, inf).round(0.125),
	\n2, 2, //Prand([2,3,4,5,6,7,8], inf),
	\mi, 5000, //Pseg([10, 5000], [2], \exp, inf),
	\iatk, 0.0,
	\irel, 0.05,
	\iAdd, 0,
	\pan, Pseq([-0.8, 0.8], inf),
	\lag, 0.0, //Pwhite(0.0, 0.025, inf),
	\addAction, 0
	).quant_([4,0.5]).play;
)


(
Pbindef(\melody,
	\instrument, \fm4_perc,
	\root, Pfunc({~root}),
	\octave, Prand([5,6,7], inf),
	\degree, Pfunc({~tonica}) + Pseq([2,0,-3],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\amp, Pseg([0.1, 0.3], [4],\lin, inf) * 3,
	\atk, 0.0,
	\rel, 0.1,
	\dur, Pseq([0.25, 0.25, Prand([0.5, Pn(0.25, 2)], 1)], inf),
	\n1, 1, //Prand([1,2], inf), //Pseg([1,4], [8], \lin, inf).round(0.125),
	\n2, 2, //Prand([2,3,4,5,6,7,8], inf),
	\mi, 5000, //Pseg([10, 5000], [2], \exp, inf),
	\iatk, 0.0,
	\irel, 0.05,
	\iAdd, 0,
	\pan, Pseq([-0.8, 0.8], inf),
	\lag, 0.0, //Pwhite(0.0, 0.025, inf),
	\addAction, 0
	).quant_([4,0.5]).play;
)


// finale?!?
(
Pbindef(\melody).stop;
Pbindef(\k).stop; Pbindef(\s).stop;Pbindef(\hh).stop;
Pbindef(\speak).stop;
Pbindef(\bass).stop;
)

Pbindef.gui



// MIDI STUFF ////////////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;

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
		"pad A4 pressed - tabla ON".postln;
		Pbindef(\tabla).play;
	}, {
		"pad A4 released - tabla OFF".postln;
		Pbindef(\tabla).stop;
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
		"pad A7 pressed - sitar ON".postln;
		Pbindef(\sitar).play;
	}, {
		"pad A7 released - sitar OFF".postln;

		Pbindef(\sitar).stop;
	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed - melody ON".postln;
		Pbindef(\melody).play;

	}, {
		"pad A8 released - melody OFF".postln;
		Pbindef(\melody).stop;
	});
},27);

~padB1.free;
~padB1 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B1 pressed - yeah ON".postln;
		Pbindef(\yeah).play;
	}, {
		"pad B1 released - yeah OFF".postln;
		Pbindef(\yeah).stop;
	});
},28);

~padB2.free;
~padB2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad B2 pressed - speak ON".postln;
		Pbindef(\speak).play;

	}, {
		"pad B2 released - speak OFF".postln;
		Pbindef(\speak).stop;
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
},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
},4);

~k5.free;
~k5 = MIDIFunc.cc({
	arg ...args;
	args.postln;
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

