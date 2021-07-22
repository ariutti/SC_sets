// cirene

// Em | Bm
// Em | Bm | C | Bm o D
// Em | Bm |

(
t.tempo_(136/60);
Tdef(\chordChanger).stop;
)
Pbindef.gui


// MIDI IN ///////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;


(
~scale = Scale.minor;
~root = 4;
~tonica = -0;
);

Pbindef.gui;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,1.0);
~verb.free;

~freezer = Synth(\freezer,target: RootNode(Server.default), addAction: \addToTail);
~freezer.free;

(
Pbindef(\stabs,
	\instrument, \sinfb,
	\octave, Pseq([4,5],inf).clump(2),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, [0, 4], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.07,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 0.5,
	\strum, 0,
	\addAction, 0
).quant_([4, 1.5]).stop.play;
)
Pbindef(\stabs).play;
Pbindef(\stabs).stop;


// walkin bass in off beat
(
Pbindef(\bass,
	\instrument, \ring1,
	\scale, Pfunc({~scale}),
	\octave, 3,
	\root, Pfunc({~root}),
	\degree, Pseq([0],inf),
	\mtranspose, Pfunc({~tonica}),
	//\degree, Pseq([Pn(0,4), Pn(-1,4), Pn(-3,4), Pn(-2,8)],inf),
	\atk, 0.01,
	\rel, 0.2,
	\dist, 60,
	\amp, 1,
	\dur, Pseq([2], inf),
	\addAction, 1
).quant_([4,0.5]).stop.play;
);
Pbindef(\bass).play;
Pbindef(\bass).stop;

//

(
Pbindef(\second_voice,
	\instrument, \dfm1,
	\scale, Pfunc({~scale}),
	\octave, [4,7],
	\root, Pfunc({~root}),
	\degree, Pseq([\, 0, 2, 0],inf),
	\mtranspose, Pfunc({~tonica}),
	//\degree, Pseq([Pn(0,4), Pn(-1,4), Pn(-3,4), Pn(-2,8)],inf),
	\atk, 0.01,
	\rel, 0.1,
	\dist, 60,
	\amp, 0.4,
	\dur, Pseq([1.5, 0.5, 0.5, 4+1.5], inf),
	\addAction, 1
).quant_([4]).stop.play;
);
Pbindef(\second_voice).play;
Pbindef(\second_voice).stop;



Pbindef.all.do({ |item| item.play; });
s.unmute
// DRUMS ///////////////////////////////////////////////////////////
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,2,\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(4).stop.play;

Pbindef(\s,
	\instrument,\bplaym,
	\buf, ~dirt["808sd"][3],
	\dur, Pwrand([2, Pseq([1.25, 0.75], 1)],[10,1].normalizeSum,inf),
	\amp,Pgauss(3, 0.1, inf),
	\rel, 0.1, //Prand([0.1, 0.2] ,inf),
	\rate, 1,
	\addAction,1
).quant_([4,1]).stop.play;


Pbindef(\hh,\instrument,\bplaym,\buf,Pseq([~dirt["808oh"][1]],inf),\dur,1,\amp,0.7,\rel,0.1,\rate,1,\addAction,1).quant_([4,0.5]).stop.play;
)

Pbindef(\k,\dur, 1, \amp, 4);
Pbindef(\k,\dur, 4, \amp, 4);


(
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 0.7,\rel,0.125,\rate,1.3 * Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\strum, Pwhite(0.0, 0.05, inf), \pan, [-1, 1]).quant_([4,3]);
)

Pbindef(\clap, \rate, 0.7, \rel, 0.1);

(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,1,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.01, inf),\pan, [-1, 1], \strum, Pwhite(0.0, 0.02, inf)).quant_([4,1]);
)
Pbindef(\snap,\dur, 1);
Pbindef(\clap).play;
Pbindef(\snap).play;

(
Pbindef(\clap).stop;
Pbindef(\snap).stop;
)


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(4).stop.play;



(
Pbindef(\g1,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([3],1),inf),
	\dur,32,
	\amp,0.5,
	\rate,1,
	\addAction,0
).quant_(4).stop.play;
)


(
Pbindef(\g2,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([4],1),inf),
	\dur,16,
	\amp,0.5,
	\rate,0.5,
	\addAction,0,
	\pan, Pwhite(0.0, 1.0, inf)
).quant_(4).stop.play;
)


(
Pbindef(\g3,
	\instrument,\bplay,
	\buf,Pindex(d["guitars"], Pseq([1],1),inf),
	\dur,12,
	\amp,0.5,
	\rate,1,
	\addAction,0,
	\pan, Pwhite(-1.0, 0.0, inf)
).quant_(4).stop.play;
)


(
Pbindef(\g1).stop;
Pbindef(\g2).stop;
Pbindef(\g3).stop;
)


/*
(
Pbindef(\aggressive_pads,
	\instrument, \brinkmann1,
	\scale, Pfunc({~scale}),
	\octave, [4,7],
	\root, Pfunc({~root}),
	\degree, Pseq([\, 0, 2, 0],inf),
	\mtranspose, Pfunc({~tonica}),
	//\degree, Pseq([Pn(0,4), Pn(-1,4), Pn(-3,4), Pn(-2,8)],inf),
	\atk, 0.01,
	\rel, 0.1,
	\dist, 60,
	\amp, 0.4,
	\dur, Pseq([1.5, 0.5, 0.5, 4+1.5], inf),
	\addAction, 1
).quant_([4]).stop.play;
);
*/






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
		"WARNING: pad A4 pressed - FREEZE".postln;
		{~freezer.set(\freeze, 1);}.fork(t, Quant(0));

	}, {
		"WARNING: pad A4 released - FREEZE".postln;
		~freezer.set(\freeze, 0);

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
	//args.postln;
	if( args[0] > 0, {
		"pad A6 pressed - clap ON".postln;
		Pbindef(\clap).play;
		Pbindef(\snap).play;
	}, {
		"pad A6 released - clap OFF".postln;
		Pbindef(\clap).stop;
		Pbindef(\snap).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed - shepard ON".postln;
		Tdef(\activate_shepard).play;


	}, {
		"pad A7 released - shepard OFF".postln;
		Tdef(\deactivate_shepard).play;

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

},28);

~padB2.free;
~padB2 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},29);


~padB3.free;
~padB3 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},30);

~padB4.free;
~padB4 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},31);

~padB5.free;
~padB5 = MIDIFunc.cc({
	arg ...args;
	args.postln;


},32);


~padB6.free;
~padB6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},33);

~padB7.free;
~padB7 = MIDIFunc.cc({
	arg ...args;
	args.postln;
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

