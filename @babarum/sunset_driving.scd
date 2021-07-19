t.tempo_(136/60);

// do you remember when we stayided together
// I'm happy to feel you by my side
// I'm happy to know that you are fine
// I'm happy to hear you voice again
// after a long long time
// we used to talk


s.meter
s.scope
s.plotTree

//~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
//~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);
~verb.free;

~delay = Synth(\delay1, [\lpf, 5000, \delaytime, t.beatDur*0.26, \decaytime,2.0, \wet,1.0]);
~delay.set(\wet,0.0);
~delay.set(\wet,0.6);
~delay.free;

(
~filter_freq = 100;
~filter_rq = 0.1;
)




// TDEF TONE CHANGER //////////////////////////////////////////////////////////////////////////////////
(
~root = 8;
~tonica = 0;
~scale = Scale.major;
)
(
Tdef(\chordChanger, {
	var tonica = Pseq([-2, -3, 0, -4], inf).asStream;
	var time   = Pseq([4,4,4,4], inf).asStream;
	loop{
		~tonica = tonica.next;
		switch( ~tonica,
			(-2), {"Fm --> inizio giro".postln;},
			(-3), {"Eb".postln;},
			0,    {"Ab".postln;},
			(-4), {"Db".postln;},
		);
		//("tonica = " ++ ~tonica).postln;
		wait( time.next );
	};
}).quant_([4,0,0.1]);
)
Tdef(\chordChanger).reset.play;
Tdef(\chordChanger).stop;




// DRUMS ///////////////////////////////////////////////////////////////////////////////////

(
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 0.7,\rel,0.125,\rate,1.1 * Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\strum, Pwhite(0.0, 0.1, inf), \pan, [-1, 1]).quant_([4,1]).stop.play;
)

(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,1]).stop.play;
)

Pbindef(\clap).play;
Pbindef(\snap).play;

(
Pbindef(\clap).stop;
Pbindef(\snap).stop;
)

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1.25, 0.5,0.75,1.5],inf),\amp,2,\rel,0.125,\rate,0.6,\addAction,1, \lag,Pwhite(0.0, 0.02, inf)).quant_(4).play;

Pbindef(\s,
	\instrument,\bplaym,
	\buf,d["sstick"][0],
	\dur,Pseq([0.5, 1.5,2],inf),
	\amp, Pseq([0.5,1, 0.7], inf) *1,
	\rel,0.6,
	\rate,0.7,
	\addAction, 1,
	\lag, Pwhite(0.0, 0.02, inf)
).quant_([4,1]).play;

Pbindef(\hh,
	\instrument,\bplay,
	\buf,d["ch"][0],
	\dur,  Pseq([0.5,0.5,0.25,0.5,0.25,0.25,0.75,   1], inf),
	\rate, Pseq([  1,  1,   1,0.5, 0.5,   1, 0.5,0.45],inf) * 1,
	\amp, 1,
	\rel, 0.02,
	\lag, Pwhite(0.0, 0.02, inf),
	\addAction, 1
).quant_([4,0.5]).play;
)





// more rythm please ( FoF )
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,2,\rel,0.25,\rate,0.6,\addAction,1,\lag, 0.0).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,0.7,\rel,0.1,\rate,0.7,\addAction,1,\lag, 0.0).quant_([4,1]).play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)*1.5,\rate,2,\addAction,1, \lag, 0.0).quant_(4).play;
)


// alternate kick for a break
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1.25, 0.5,0.75,1.5],inf),\amp,1.2,\rel,0.25,\rate,0.6,\addAction,1, \lag,Pwhite(0.0, 0.02, inf)).quant_(4).play;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)



(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)

s.plotTree;
StageLimiter.activate;

// PADS ////////////////////////////////////////////////////////////////////////////////////

(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Pfunc({~scale}),
	\octave, [4,5,6],
	\root, Pfunc({~root}),
	\degree, Pfunc({~tonica}) + Prand([[0,2,4]], inf),
	//\degree, Pseq([
	//	[0,2,4],
	//	Prand([[-1,1,3],[-1,2,6]],1),
	//	Pseq([[-3,-1,2]],1),
	//	Pn([-2,0,2], 1)
	//], inf),
	\fb, Pseq([0,0.25, 0.5, 1], inf), //Pwhite(0.1, 1.1, inf).clump(3),
	\dur, 4, //Pseq([4,4,4,8], inf),
	\atk, t.beatDur*1,  //Pkey(\dur)*0.5,
	\rel, Pkey(\dur) * t.beatDur, //Pkey(\dur)*1.5,
	\amp, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 1
).quant_([4,0]).stop.play;
)
Pbindef(\pads).stop;



(
Pbindef(\pads,
	\instrument, \fm4,
	\scale, Pfunc({~scale}),
	\octave, Prand([[3,4,5], [3,5,6]], inf),
	\root, Pfunc({~root}),
	\degree, Pfunc({~tonica}) + Pseq([[0,2,4]], inf),
	//\degree, Pseq([
	//	[0,2,4], // Fm
	//	Prand([[-1,1,3],[-1,2,6]],1), //Eb o Ab
	//	Pseq([[-3,-1,2]],1), // Ab
	//	Prand([[-2,0,2]], 1) // Db
	//], inf),
	\n1,1,
	\n2, Prand((1..10),inf).clump(3),
	\mi, Pexprand(500, 5000, inf).clump(3),
	\iatk,0.01,\irel,2,
	\iAdd, Pwhite(1,3,inf).clump(3),
	\dur, 4,
	\atk, Pkey(\dur)*0.5,
	\rel, Pkey(\dur)*1.5,
	\amp, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 1
).quant_([4,0]).play;
)
Pbindef(\pads).clear;

(
Pbindef(\pads, 	\n2, 2, //Prand((1..10),inf).clump(3),
	\mi, 100, //Pexprand(500, 5000, inf).clump(3),
	\iatk,0.01,\irel,2,
	\iAdd, 0, //Pwhite(1,3,inf).clump(3),)
	\amp, 0.2,
	\octave, [4,5,6]
);
)






// BASS ////////////////////////////////////////////////////////////////////////////////////

// wooble bass
(
Pbindef(\bass,
	\instrument, \distSin,
	\scale, Pfunc({~scale}),
	\octave, 3,
	\root, Pfunc({~root}),
	\degree, Pfunc({~tonica}) + Pseq([0],inf),
	//\degree, Pseq([0,-1,-3, Pn(-2,2)],inf),
	\atk, 1 * t.beatDur,
	\rel, 0.001 * t.beatDur,
	\dist, 20,
	\amp, 0.5,
	\dur, Pseq([4], inf),
	\addAction, 1
).quant_([4,3]).stop.play;
);
Pbindef(\bass).play;
Pbindef(\bass).stop;

// walkin bass in off beat
(
Pbindef(\bass,
	\instrument, \ring1,
	\scale, Pfunc({~scale}),
	\octave, 3,
	\root, Pfunc({~root}),
	\degree, Pfunc({~tonica}) + Pseq([0],inf),
	//\degree, Pseq([Pn(0,4), Pn(-1,4), Pn(-3,4), Pn(-2,8)],inf),
	\atk, 0.01,
	\rel, 0.2,
	\dist, 30,
	\amp, 2,
	\dur, Pseq([1], inf),
	\addAction, 1
).quant_([4,0.5]).stop.play;
);
Pbindef(\bass).play
Pbindef(\bass).stop;


// LEAD ////////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\lead,
	\instrument, \squarebass,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Prand([3,4,5,6,7], inf),
	\degree, Prand([-3,-2,2], inf), //Prand([-1,0,4], inf),
	\detune, 0,
	\width, 0.5,
	\dur, 0.25,
	\rel, 0.125,
	\amp, 0.5,
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction, 1,
).quant_([4,0]).play;
)
Pbindef(\lead).stop;

/*
(
Pbindef(\lead,
	\instrument, \fm4_perc,
	\scale, Pfunc({~scale}),
	\octave, Prand([4,5,6], inf),
	\root, Pfunc({~root}),
	\n1,1,\n2,Prand([2,5,6,7,8,9],inf),
	\degree, Pseq([2], inf), //Pseq([4], inf),
	\mi, 5000,\iatk,0.01,\irel,0.01,\iAdd,0,
	\detune, 0,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.3,
	\dur, Pwrand([1, Pn(0.25,4)],[5,1].normalizeSum,inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction, 1, //Pwrand([1,0],[10,1].normalizeSum,inf)
).quant_([4,0]).play;
)
Pbindef(\lead).stop;


// noisy lead (detuned)
(
Pbindef(\lead,
	\instrument, \squarebass,
	\scale, Pfunc({~scale}),
	\octave, Prand([3,4,5,6,7], inf),
	\degree, Prand([-3,-2,2], inf), //Prand([-1,0,4], inf),
	\root, Pfunc({~root}),
	\width, Pseg([0.5,0.1], [4], \lin, inf), //Pwhite(1, 5, inf),
	\detune, Pseg([1,200], [1], \lin, inf), //Pwhite(1, 5, inf),
	\atk, 0.0,
	\rel, 0.25,
	\amp, 0.5,
	\dur, Pwrand([1, Pn(0.25,4)],[1,10].normalizeSum,inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	\addAction, 1, //Pwrand([1,0],[1,10].normalizeSum,inf),
).quant_([4,0]).play;
)
*/

Pbindef.gui

// guitar like lead
(
Pbindef(\lead,
	\instrument, \pluck,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Prand([4], inf),
	\degree, Prand([Pn(-2,8),Pn(0,8),Pn(-4,8)],inf) + Pseq([7,7,6,4], inf),
	\mtranspose, Pwhite(0.0, 0.01,inf),
	\coef, Pseg([0.3, 0.9],[8],\lin,inf),
	\dcy, Pseg([0.5, 0.05],[8],\lin,inf),
	\dist, 10, //Pwhite(1.0, 100, inf),
	\dur, 0.25,
	\atk, 0.0,
	\rel, 1,
	\amp, Pseq([1,0.5, 0.7, 0.7],inf) * 0.25,
	\addAction, Prand([0,1],inf),
	\pan, Pseg([-1.0, 1.0, -1.0],[4,4],\lin,inf)
).quant_([4]).stop.play;
)

Pbindef.gui;
// OFFBEATS ////////////////////////////////////////////////////////////////////////////////

// jumping now
(
Pbindef(\offbeats,
	//\instrument, \dfm1, // \sinfb
	\instrument, Prand([\sinfb,\dfm1], inf),
	\scale, Pfunc({~scale}),
	\octave, Prand([4,5,6],inf).clump(3),
	\root, Pfunc({~root}),
	\mtranspose, Pwhite(-0.02, 0.02,inf).clump(3),
	\degree,  Pseq([[0,2,4]],inf), //Pseq([[2,4,6]],inf),
	\fb, 1.7, //Pseg([0.9, 1.7], [8],\exp, inf),
	\dur, Pwrand([1, Pn(0.5, 2)],[1,0.25].normalizeSum, inf),
	\atk, 0.0,  //Pkey(\dur)*0.5,
	\rel, Pseg([0.05, 0.4], [8],\exp, inf), //Pwhite(0.1,0.7,inf), //Pkey(\dur) * t.beatDur, //Pkey(\dur)*1.5,
    \amp, Pgauss(0.4, 0.05,inf) * 0.7,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 0
).quant_([4,0.5]).play;
)
Pbindef(\offbeats).stop;


// MIDI IN ////////////////////////////////////////////////////////////////////////////////////////////
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
		"pad A4 pressed - clap/snap play".postln;
		Pbindef(\clap).play;
		Pbindef(\snap).play;
	}, {
		"pad A4 released - clap/snap stop".postln;
		Pbindef(\clap).stop;
		Pbindef(\snap).stop;
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
		"pad A7 pressed - offbeat ON".postln;
		Pbindef(\offbeats).play;
	}, {
		"pad A7 released - offbeat OFF".postln;
		Pbindef(\offbeats).stop;
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
	//args.postln;
	if( args[0] > 0, {
		"WARNING: pad B4 pressed - adding DJ filter".postln;
		~filter = Synth(\dejay_filter, [\freq, ~filter_freq, \rq, ~filter_rq], target: RootNode(Server.default), addAction: \addToTail);
	}, {
		"WARNING: pad B4 released - releasing DJ filter".postln;
		~filter.free;
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
)





// KONTROLS ////////////////////////////
(
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
	var delaywet = args[0].linlin(0, 127, 0.0, 2.0);
	("delay wet " ++ delaywet.round(0.001)).postln;
	~delay.set(\wet, delaywet);
},2);

~k3.free;
~k3 = MIDIFunc.cc({
	arg ...args;
	var delaylpf = args[0].linexp(0, 127, 120, 10000);
	("delay lpf " ++ delaylpf.round(0.001)).postln;
	~delay.set(\lpf, delaylpf);
/*	var delaytime = args[0].linlin(0, 127, 1/16, 2.0);
	("delay time " ++ delaytime.round(0.001) ).postln;
	delaytime = delaytime * t.beatDur;
	~delay.set(\delaytime, delaytime);*/

},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	/*var delayfb = args[0].linlin(0, 127, 0.0, 0.999);
	("delay fb " ++ delayfb.round(0.001)).postln;
	~delay.set(\fb, delayfb);*/

},4);

~k5.free;
~k5 = MIDIFunc.cc({
	arg ...args;
},5);

~k6.free;
~k6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

},6);

~k7.free;
~k7 = MIDIFunc.cc({
	arg ...args;
	~filter_freq = args[0].linexp(0, 127, 100, 10000);
	("filter freq " ++ ~filter_freq.round(0.001)).postln;
	~filter.set(\freq, ~filter_freq);

},7);

~k8.free;
~k8 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	~filter_rq = args[0].linexp(0, 127, 1, 100).reciprocal;
	("filter rq " ++ ~filter_rq.round(0.001)).postln;
	~filter.set(\rq, ~filter_rq);
},8);
)


// experimental pads //////////////////////////////////////////////////////////////////////////
(
SynthDef(\varsaw_tremolo, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,width=0.5, tremoloFreq=6, tremoloAmt=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = VarSaw.ar(freq, width:width, mul:SinOsc.kr(tremoloFreq).range(1.0-tremoloAmt,1)) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\pads,
	\instrument, \varsaw_tremolo,
	\scale, Pfunc({~scale}),
	\octave, Pxrand([4,5,6], inf).clump(4),
	\root, Pfunc({~root}),
	\degree, Pfunc({~tonica}) + Prand([[0,2,4,7]], inf),
	//\degree, Pseq([
	//	[0,2,4],
	//	Prand([[-1,1,3],[-1,2,6]],1),
	//	Pseq([[-3,-1,2]],1),
	//	Pn([-2,0,2], 1)
	//], inf),
	\width, Pwhite(0.1, 0.3, inf).clump(4), //Pseq([0,0.25, 0.5, 1], inf), //Pwhite(0.1, 1.1, inf).clump(3),
	\tremoloFreq, Pwhite(5.0, 7.0, inf).clump(4),
	\tremoloAmt, Pwhite(0.5, 1.0, inf).clump(4),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(4),
	\dur, 4, //Pseq([4,4,4,8], inf),
	\atk, t.beatDur*1,  //Pkey(\dur)*0.5,
	\rel, 1.5 * Pkey(\dur) * t.beatDur, //Pkey(\dur)*1.5,
	\amp, Pgauss(0.5, 0.1, inf).clump(4),
	\pan, Pgauss(0.0, 0.5, inf).clump(4).clip(-1, 1),
	\addAction, 1
).quant_([4,0]).play;
)
