(
~scale = Scale.major;
t = TempoClock.default;
t.tempo_(96/60);
~root = 0;
)

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,0.0);
~verb.free;

~delay = Synth(\delay_w_bpf, [\cf, 5000, \rq, 0.1, \delaytime, t.beatDur*0.26, \decaytime,2.0, \wet,1.0]);
~delay.free;

(
~filter_cf = 100;
~filter_rq = 0.1;
~melodyAmp = 1;
~melodyAtk = 0.01;
~melodyRel = 0.4;
)

Pbindef.gui
s.meter


// first of all start with finding a repating melody
// a la steve reich
(
SynthDef(\mySin, {
	|out=0, pan=0, amp=1.0, freq=440, atk=0.01, rel=1.0|
	var sig, env;
	//sig = LFPulse.ar(freq + SinOsc.ar(6, mul:10)).bipolar * 0.3;
	sig = LFTri.ar(freq + SinOsc.ar(30, mul:10)).bipolar * 2; // change vibrato to fb
	//sig = SinOsc.ar(freq);
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	//sig = RLPF.ar(sig, freq*5, 1);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
~func_changeMelody = {
	~lickA = Array.new(12);
	~dursA = Array.fill(12, {0.5});
	// add a pause some where
	~lickA = Array.fill(12, { if( 0.2.coin, {"rest".asSymbol}, {~scale.degrees.choose})}).postln;
	~accentsA = ([1,0.125, 0.75, 0.125]!3).flat;
	("\nlick:\t" + ~lickA).postln;
	("durs:\t" + ~dursA).postln;
	("accents:" + ~accentsA).postln;

	// try 5 times to reduce the notes on the lick
	// and to double the duration of the remaining neighbor note
	3.do({
		var randomIndex = 1.rrand( ~lickA.size-1);
		if( (~dursA.at( randomIndex ) != 1).and(~dursA.at( randomIndex-1 ) != 1), {
			~lickA.removeAt( randomIndex );
			~accentsA.removeAt( randomIndex );
			~dursA.removeAt( randomIndex );

			~dursA.put( randomIndex-1, 1 );

			("\nlick:\t" + ~lickA).postln;
			("durs:\t" + ~dursA).postln;
			("accents:" + ~accentsA).postln;
			//[~lickA.size, ~dursA.size, ~accentsA.size].postln;
			//~dursA.sum.postln;
		},{"nothing to do".postln;});
	})
};
~func_changeMelody.value();
)



(
Pbindef(\mySin1,
	\instrument, \mySin,
	\root, Pfunc({ ~root }),
	\scale, Pfunc({ ~scale }),
	\octave, 6,
	\degree, Pseq( Pfunc({~lickA}).asArray.flatten , inf),
	\dur, Pseq( Pfunc({~dursA}).asArray.flatten , inf),
	\atk, Pfunc({~melodyAtk}),
	\rel, Pfunc({~melodyRel}),
	\amp, Pseq( Pfunc({~accentsA}).asArray.flatten , inf) * Pfunc({~melodyAmp}),
	\pan, Pwhite(-0.9, 0.9, inf),
	\out, 0,
	\stretch, 0.5
).quant_([4,0]).reset.play;

Pbindef(\mySin2,
	\instrument, \mySin,
	\root, Pfunc({ ~root }),
	\scale, Pfunc({ ~scale }),
	\octave, 5,
	\degree, Pseq( Pfunc({~lickA}).asArray.flatten , inf),
	\dur, Pseq( Pfunc({~dursA}).asArray.flatten , inf),
	\atk, Pfunc({~melodyAtk}),
	\rel, Pfunc({~melodyRel}),
	\amp, Pseq( Pfunc({~accentsA.rotate(-1)}).asArray.flatten, inf) * Pfunc({~melodyAmp}),
	\pan, Pwhite(-0.9, 0.9, inf),
	\out, 0,
	\stretch, 0.5
).quant_([4,1]).reset.play;

Pbindef(\mySin3,
	\instrument, \mySin,
	\root, Pfunc({ ~root }),
	\scale, Pfunc({ ~scale }),
	\octave, 5,
	\degree, Pseq( Pfunc({~lickA}).asArray.flatten , inf),
	\dur, Pseq( Pfunc({~dursA}).asArray.flatten , inf),
	\atk, Pfunc({~melodyAtk}),
	\rel, Pfunc({~melodyRel}),
	\amp, Pseq( Pfunc({~accentsA.rotate(-2)}).asArray.flatten, inf) * Pfunc({~melodyAmp}),
	\pan, Pwhite(-0.9, 0.9, inf),
	\out, 0,
	\stretch, 0.5
).quant_([4,2]).reset.play;

Pbindef(\mySin4,
	\instrument, \mySin,
	\root, Pfunc({ ~root }),
	\scale, Pfunc({ ~scale }),
	\octave, 4,
	\degree, Pseq( Pfunc({~lickA}).asArray.flatten , inf),
	\atk, Pfunc({~melodyAtk}),
	\rel, Pfunc({~melodyRel}),
	\amp, Pseq( Pfunc({~accentsA.rotate(-3)}).asArray.flatten, inf) * Pfunc({~melodyAmp}),
	\pan, Pwhite(-0.9, 0.9, inf),
	\out, 0,
	\stretch, 0.5
).quant_([4,3]).reset.play;
)

(
Pbindef(\mySin1).stop;
Pbindef(\mySin2).stop;
Pbindef(\mySin3).stop;
Pbindef(\mySin4).stop;
)

Pbindef(\mySin1).clear;
Pbindef(\mySin2).clear;
Pbindef(\mySin3).clear;
Pbindef(\mySin4).clear;


// then add some pads
(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0
	|
	var env = EnvGen.ar(Env.triangle(dur*1.2), doneAction:2);
	var mamp = LFTri.kr(freq*0.0125*LFNoise0.kr(5).range(0.8,1.2)).range(0.5,5); //modulated amp
	var mwidth   = LFTri.kr(
		LFNoise1.kr(2).exprange(0.1, 2)
	).range(0.4, 0.6);
	var sig = VarSaw.ar(freq, width:mwidth, mul:mamp).squared.softclip;
	sig = LPF.ar( sig+WhiteNoise.ar(0.2), freq*4);
	//sig = HPF.ar(sig, freq * 0.25);
	//sig = CombN.ar(sig, 0.8, 0.2, 0.5);
	sig = LeakDC.ar(sig) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\pads,
	\instrument, \dist,
	\scale, Pfunc({ ~scale }),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, Prand([3,4,5], inf).clump(6),
	\degree, Pseq([0,4,7,2], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.3, 0.01, inf).clump(6) * 0.7,
	\dur, 10,
	\addAction,0
).quant_(4).play;
)
Pbindef(\pads).stop;

// dry kick
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,2,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;


// more deep kick
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,1,\amp,4,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;


// hh in levare
// snare con rimshot
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,4,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;

Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][8],\dur,Pwrand([2, Pseq([0.25,1.75],1)],[4,1].normalizeSum,inf),\amp,1,\atk,0.0,\rel,5,\rate,1,\addAction,1,\lag,0.0, \stretch, 1).quant_([4,1]).stop.play;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,1,\amp,0.8,\atk,0.0,\rel,0.1,\rate,1,\addAction,1,\lag,0.0, \stretch, 1).quant_([4,0.5]).stop.play;
)

// add more elements
Pbindef(\striscio,\instrument,\bplaym,\buf,~dirt["drumtraks"][0],\dur,2,\amp,4,\atk,0.0,\rel,5,\rate,1,\addAction,1).quant_([4,1]).stop.play;

Pbindef(\hh2,\instrument,\bplaym,\buf,~dirt["drumtraks"][7],\dur,0.25,\amp,0.5,\atk,0.0,\rel,Prand([0.05,0.1],inf),\rate,Pwhite(0.99,1.01,inf),\addAction,1).quant_([4,0]).play;

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\striscio).stop;
Pbindef(\hh2).stop;
)


(
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\hh).play;
Pbindef(\striscio).play;
Pbindef(\hh2).play;
)

StageLimiter.activate;


// other phrase (in minor modulation)
// C | C | F | G
(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 0.6,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\degree, Pseq([Pn(0, 4*4), Pn(3,4), Pn(4,4)],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),
	\octave, Prand([[3,4]], inf),

	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.1,
	\addAction, 1,
	\stretch, 1
).quant_([4, 0]).play;
)
Pbindef(\bass).stop;

// double the bass
(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 0.6,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\degree, Pseq([Pn(0, 4*4*2), Pn(3,8), Pn(4,8)],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),
	\octave, Prand([[3,4]], inf),

	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.07,
	\addAction, 1,
	\stretch, 0.5
).quant_([4, 0]).play;
)


// other phrase (in minor modulation)
// C | C | Am | G
(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 0.7,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\degree, Pseq([Pn(0, 14), 0, -1, Pn(-2,4), Pn(-3,4)],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),
	\octave, Prand([[3,4]], inf),

	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.1,
	\addAction, 1,
	\stretch, 1
).quant_([4, 0]).play;
)



//
(
Pbindef(\bass,
	\instrument, \doublebass,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 2,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\octave, Prand([[3,4]], inf),
	\degree, Pseq([
		Pn(0, 16), Pn(3,4), Pn(4,4), // C | C | F  - G
		//Pn(0, 14), 0, -1,  Pn(-2,4), Pn(-3,4), // C | C | Am | G
		Pn(0, 16), Pn(3,4), Pn(4,4), // C | C | F - G
		Pn(5, 16), Pn(3,8), Pn(4,8)  // Am | Am | F | G ||
	],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),



	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.4,
	\addAction, 1,
	\stretch, 1
).quant_([4, 0]).play;
)
Pbindef(\bass).stop;



// duble bass with all the chord
(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 0.7,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\octave, Prand([[3,4]], inf),
	\degree, Pseq([
		Pn(0, 32), Pn(3,8), Pn(4,8), // C | C | F  - G
		//Pn(0, 14), 0, -1,  Pn(-2,4), Pn(-3,4), // C | C | Am | G
		Pn(0, 32), Pn(3,8), Pn(4,8), // C | C | F - G
		Pn(5, 32), Pn(3,16), Pn(4,16)  // Am | Am | F | G ||
	],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),



	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.07,
	\addAction, 1,
	\stretch, 0.5
).quant_([4, 0]).play;
)


// MIDI /////////////////////////////////////////////////////////////////////////////////////
(
~padA1.free;
~padA1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A1 pressed - K on".postln;
		Pbindef(\k).play;
	}, {
		"pad A1 released - K off".postln;
		Pbindef(\k).stop;
	});
},20);

~padA2.free;
~padA2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A2 pressed - S on".postln;
		Pbindef(\s).play;
		Pbindef(\striscio).play;
	}, {
		"pad A2 released - S off".postln;
		Pbindef(\s).stop;
		Pbindef(\striscio).stop;
	});
},21);


~padA3.free;
~padA3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A3 pressed - HH on".postln;
		Pbindef(\hh).play;
		Pbindef(\hh2).play;
	}, {
		"pad A3 released - HH off".postln;
		Pbindef(\hh).stop;
		Pbindef(\hh2).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed - CHANGE MELODY".postln;
		~func_changeMelody.value();
	}, {
		"pad A4 released".postln;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed - BASS on".postln;
		Pbindef(\bass).play;
	}, {
		"pad A5 released - BASS off".postln;
		Pbindef(\bass).stop;
	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed - PADS on".postln;
		Pbindef(\pads).play;
	}, {
		"pad A6 released - PADS off".postln;
		Pbindef(\pads).stop;
	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed".postln;
	}, {
		"pad A7 released".postln;
	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed - MELODY on".postln;
		Pbindef(\mySin1).play;
		Pbindef(\mySin2).play;
		Pbindef(\mySin3).play;
		Pbindef(\mySin4).play;

	}, {
		"pad A8 released - MELODY off".postln;
		Pbindef(\mySin1).stop;
		Pbindef(\mySin2).stop;
		Pbindef(\mySin3).stop;
		Pbindef(\mySin4).stop;
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
		~filter = Synth(\dejay_filter, [\cf, ~filter_cf, \rq, ~filter_rq], target: RootNode(Server.default), addAction: \addToTail);
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
	/*
	if( args[0] > 10, {
		//s.mute;
	}, {
		//s.unmute;
	});
	*/
	~melodyAmp = args[0].linlin(0, 127, 0.0, 2.0);
	("melody amp " ++ ~melodyAmp.round(0.001)).postln;

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
	//args.postln;
	~melodyAtk = args[0].linexp(0, 127, 0.01, 1.0);
	("melody atk " ++ ~melodyAtk.round(0.001)).postln;

},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	~melodyRel = args[0].linexp(0, 127, 0.01, 1.0);
	("melody rel " ++ ~melodyRel.round(0.001)).postln;
},4);

~k5.free;
~k5 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
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
	~filter_cf = args[0].linexp(0, 127, 120, 10000);
	("filter cf " ++ ~filter_cf.round(0.001)).postln;
	~filter.set(\cf, ~filter_cf);

},7);

~k8.free;
~k8 = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	~filter_rq  = args[0].linexp(0, 127, 0.5, 100).reciprocal;
	("filter rq " ++ ~filter_rq.round(0.001)).postln;
	~filter.set(\rq, ~filter_rq);
},8);
)