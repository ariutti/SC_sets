t = TempoClock.default;
t.tempo_(136/60);

// CHORDS
//| F | Bb |
// other possible chords are

Pbindef.gui

s.plotTree

// MIDI IN ///////////////////////////////////////////////
MIDIClient.init;
MIDIIn.connectAll;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

// PADS ///////////////////////////////////////////////////////////////////////
(
Pbindef(\pads).stop;
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, Pseq([[4,5,6]], inf).clump(3),
	\root, 5,
	\mtranspose, Pwhite(0.0, 0.02, inf).clump(3),
	\degree, Pseq(
		[
			Pseq([[0,4,7]],4), // F
			Pseq([[3,5,7]],2), // Bb
			//Pseq([[2,5,7]],1), // Dm II rivolto
			//Pseq([[1,4,6]],2), // C
		]
	,inf),
	\fb, Pwhite(0.2, 0.6, inf).clump(3),
	\amp, 0.07,
	\atk, 4,
	\rel, 4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\dur, 8,
).quant_([4]).play;
)
Pbindef(\pads,\degree, Pseq([[0,4,7]],inf)).play; // F
Pbindef(\pads,\degree, Pseq([[3,5,7]],inf)).play; // Bb
Pbindef(\pads,\degree, Pseq([[1,4,6]],inf)).play; // C


// NOISES /////////////////////////////////////////////////////////////////////
(
SynthDef(\filterdnoise, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,rq=0.1|
	var env = EnvGen.ar(Env.perc(atk,rel, curve:[4,-4]),doneAction:2);
	var sig = Decay2.ar(Impulse.ar(t.tempo*4), 0.0, 0.1) * WhiteNoise.ar();
	sig = BPF.ar(sig, freq, rq) * env * amp * 10;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\noises,
	\instrument, \filterdnoise,
	\octave, Prand([7],inf),
	//\degree, Prand([Pn(0,4),Pn(-2,4),Pn(-4,4)],inf),
	\degree, Prand([Pn(0,4),Pn(-2,4),Pn(-4,4)],inf),
	\dur,    Pseq([2],inf),
	\rq, 0.01,
	\amp, 1.6,
	\atk, Pkey(\dur) * t.beatDur,
	\rel, 0.001,
	\pan, Pseq([[-1, 1],[1, -1]],inf), //Pseg([1.0, -1.0, 1.0],[8,8],\exp,inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\noises).stop;
Pbindef(\noises,\degree, Pseq([0], inf));


// CHIMES /////////////////////////////////////////////////////////////////////
(
//Pbindef(\chimes).stop;
Pbindef(\chimes,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, Prand([4,5], inf),
	\root, 5,
	\mtranspose, Pwhite(0.0, 0.025, inf),
	\degree, Prand(
		[
		//Pn(Prand([0,4,7],16), 1), // F
		//Pn(Prand([3,5,7],16), 1), // Bb
		//Pn(Prand([2,5,7],16), 1), // Dm II rivolto
		Pseq([
				Pn(Prand([3,5,7],8), 1), // Bb
				Pn(Prand([0,4,7],8), 1), // F
				//Pn(Prand([-1,2,4],8), 1), // Am
				Pn(Prand([1,3,5],8), 1), // Gm
				Pn(Prand([0,4,7],8), 1), // F
			], 1),
		//Pn(Prand([1,3,6],16), 1), // C
	]
	,inf),
	\fb, Pwhite(0.7, 1.1, inf) * Pseg([0.2, 1.1],[8, 8], \lin, inf),
	\amp, Pgauss(0.07, 0.001, inf),
	\atk, 0.0,
	\rel, Pgauss(1, 0.1, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\dur, 0.5,
	\addAction,0
).quant_([4]);
)
Pbindef(\chimes).play;
Pbindef(\chimes).stop;


// BASSES /////////////////////////////////////////////////////////////////////
(
Pbindef(\bass).stop;
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [3,4],
	\root, 5,
	\degree, Pseq([0],inf),
	\fb, 0.8,
	\amp, 0.4,
	\atk, 0.01,
	\rel, 1,
	\dur, 8, //Pbjorklund2(3,8,inf,0)/2,
	\addAction, 0
).quant_([4]).play;
)

// space invader basses: 15 14 13 12 bass
(
Pbindef(\bass,
	\instrument,\bplaym,
	//\buf, Pindex(~dirt["invaders"], Prand((0..~dirt["invaders"].size-1), inf),inf),
	\buf, Pindex(~dirt["invaders"], Pseq([13],inf),inf), //0,9,11,16
	\dur, Prand([0.5,1,2],inf),
	\atk, 0.01,
	\amp, 0.8,
	\rel, 1,
	\rate, (-3 + Pseq([Pseq([-1,0],1),0,4,7],inf)).midiratio,
	\addAction,1
).quant_([4,1]).stop.play;
)


(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5, dist=1.0,
	cf=1000, rq=0.1,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = LFPulse.ar(freq, width:width);

	sig = RLPF.ar(sig, freq*cf, rq);
	//sig = LPF.ar(sig, freq*cf);
	sig = (sig * dist).tanh;

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


(
Pbindef(\bass,
	\instrument, \squarebass,
	\scale, Scale.major,
	\octave, [3],
	\root, 5,
	\degree, Pwrand([Pseq([-1,0],1),-4,0,4], [5,2,7,2].normalizeSum,inf),
	\cf, 2, \rq, 1.5,
	\width, 0.5,
	\dist, 20,
	\amp, 0.8,
	\atk, 0.01,
	\rel, 0.2,
	\dur, Prand([0.5,1,2],inf),
	\addAction, 1
).quant_([4]);
)

Pbindef(\bass).play;
Pbindef(\bass).stop;



// DRUMS ////////////////////////////////////////////////////////////////////////
(

// 1 on 4
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,1,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;

// ° , , °° |
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([3.5,0.5],inf),\amp,1,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([3.5,0.25,0.25],inf),\amp,1,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;

// fof
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(4).play;

Pbindef(\k, \amp, 1);

Pbindef(\s1,
	\instrument,\bplaym,
	\buf,Pindex(~dirt["invaders"],[10],inf),
	\dur,2,
	\amp, 0.7,
	\atk, 0.0,
	\rel, 0.07,
	\rate, 2.5,
	\addAction,Prand([0,1], inf)
).quant_([4,1]).play;

Pbindef(\s2,
	\instrument,\bplaym,
	//\buf, Pindex(~dirt["invaders"], Prand((0..~dirt["invaders"].size-1), inf),inf),
	\buf, Pindex(~dirt["invaders"], Pseq([10],inf),inf), //0,9
	\dur, Prand([0.5, 1,2],inf),
	\amp, 0.2,
	\atk, 0.0,
	\rel, 0.3,
	\rate, (-2 + Prand([0,2,4], inf)).midiratio,
	\addAction, 1
).quant_([4,1]).stop.play;
)

// fof, some slight variation
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pwrand([1, Pn(0.5,2)],[6,1].normalizeSum,inf),\amp,0.2,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;


(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([3.5,0.25,0.25],inf),\amp,0.2,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s1).stop;
Pbindef(\s2).stop;
)


(
//Pbindef(\chimes).stop;
Pbindef(\k).stop;
Pbindef(\s1).stop;
Pbindef(\s2).stop;
Pbindef(\invaders).stop;
Pbindef(\alert).stop;
)

(
Pbindef(\chimes).play;
Pbindef(\k).play;
Pbindef(\s1).play;
Pbindef(\s2).play;
Pbindef(\invaders).play;
Pbindef(\alert).play;
)


{PlayBuf.ar(1,d["k"][0], doneAction:2)*4}.play;


// ALTERNATE DRUMS
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,0.4,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([3.5,0.5],inf),\amp,0.4,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.4,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],
	\dur,Pwrand([1, Pn(0.5,2)],[6,1].normalizeSum,inf),
	\amp,0.4,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;

Pbindef(\s1,\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,0.5,\rel,0.1,\rate,0.6,\addAction,1).quant_([4,1]).play;

Pbindef(\s2,
	\instrument,\bplaym,
	//\buf, Pindex(~dirt["invaders"], Prand((0..~dirt["invaders"].size-1), inf),inf),
	\buf, d["sstick"][0], //0,9
	\dur, Prand([0.5, 1,2],inf),
	\amp, Pgauss(0.5, 0.1, inf) * 1.0,
	\atk, 0.0,
	\rel, 0.5,
	\rate, 0.3 * (Prand([0,2,4], inf)).midiratio,
	\addAction, Pwrand([1,0], [10,1].normalizeSum, inf)
).quant_([4,1]).stop.play;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\rel,0.07,\amp,Pexprand(0.05,1)*0.5,\rate,1.7,\addAction,1).quant_(1).play;
)


// FXS ////////////////////////////////////////////////////////////////////////
(
Pbindef(\invaders).stop;
Pbindef(\invaders,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["invaders"], Pseq([0,9,11,16],inf),inf), //0,9,11,16
	\dur, Prand([5,7,13],inf),
	\amp, Pgauss(0.125, 0.05, inf),
	\rel, 0.1,
	\rate, (-2).midiratio,
	\pan, Pseq([-1.0, 1.0], inf),
	\addAction,0
).quant_([4,1]).stop.play;
)

(
Pbindef(\alert).stop;
Pbindef(\alert,
	\instrument,\bplaym,
	//\buf, Pindex(~dirt["invaders"], Prand((0..~dirt["invaders"].size-1), inf),inf),
	\buf, Pindex(~dirt["invaders"], Pseq([17],inf),inf), //0,9,11,16
	\dur, 3 * Prand([0.5, 1,2],inf),
	\amp, Pgauss(0.125, 0.05, inf),
	\atk, 0.0,
	\rel, 0.5,
	\rate, -0.11 + (-3 + Prand([0,11],inf)).midiratio,
	\addAction,0
).quant_([4,1]).stop.play;
)


// LEADS //////////////////////////////////////////////////////////////////////
(
Pbindef(\melody,
	\instrument, \sinfb,
	\root, 5,
	\octave, 6,
	\degree, Pseq([0,1,2,4,-3, 0,1,2,-3,-3],inf),
	\amp, 0.3,
	\atk, 0.0,
	\rel, 0.4,
	\dur, Pseq([1,1,1.5,4, 0.5],inf),
	\pan, 0.0,
	\addAction,0
).quant_([4,2]).stop.play;
)


(
Pbindef(\melody).stop;
Pbindef(\noises).stop;
Pbindef(\pads).stop;
)


(
Pbindef(\melodyC,
	\instrument, \fm4_perc,
	\root, 5,
	\octave, 6,
	\degree, Pseq([\,0,0,0,0,0, -2, -3, -2,0, 0,0,0,0,0, -3,  -2,   2], inf),
	\dur,    Pseq([1,1,1,1,1,1,0.5,0.5,0.5,1.5,1,1,1,1,1,0.5, 0.5, 1], inf),

	\amp,Pseq([Pseq([0.5,1],3), Pseq([0.5,0.5,1],1), Pseq([1,0.5],3), Pseq([0.5,1],1)],inf) * 0.3,
	\n1, 1, \n2, 4,\mi, 1000,
	\iatk, 0.0, \irel, 0.2, \iAdd, 5,

	\atk, 0.0,
	\rel, 0.5,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\melodyC).stop;



// MIDI CONTROLS /////////////////////////////////////////////////////





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
		Pbindef(\s1).play;
		Pbindef(\s2).play;
	}, {
		"pad A2 released - snare OFF".postln;
		Pbindef(\s1).stop;
		Pbindef(\s2).stop;
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
		"pad A4 pressed - shepard ON".postln;
		Tdef(\activate_shepard).play;

	}, {
		"pad A4 released - shepard OFF".postln;
		Tdef(\deactivate_shepard).play;
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
		"pad A7 pressed - chimes ON".postln;
		Pbindef(\chimes).play;

	}, {
		"pad A7 released - chimes OFF".postln;
		Pbindef(\chimes).stop;

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
		"pad B6 pressed - melodyC ON".postln;
		Pbindef(\melodyC).play;
	}, {
		"pad B6 released - melodyC OFF".postln;
		Pbindef(\melodyC).stop;

	});
},33);

~padB7.free;
~padB7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B7 pressed - noises ON".postln;
		Pbindef(\noises).play;
	}, {
		"pad B7 released - noises OFF".postln;
		Pbindef(\noises).stop;
	});
},34);

~padB8.free;
~padB8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B8 pressed - alert/invaders ON".postln;
		Pbindef(\alert).play;
		Pbindef(\invaders).play;

	}, {
		"pad B8 released - alert/invaders OFF".postln;
		Pbindef(\alert).stop;
		Pbindef(\invaders).stop;

	});
},35);
)






// KONTROLS ////////////////////////////
(
~k1.free;
~k1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	//~amp_bass = args[0].linlin(0,127,0.0, 1.0);
	//("~amp_bass = " ++ ~amp_bass.round(0.001)).postln;

},1);

~k2.free;
~k2 = MIDIFunc.cc({
	arg ...args;
	var wet = args[0].linlin(0, 127, 0.0, 1.0);
	//args.postln;
	~verb.set(\dec,2, \lpf,5000, \wet, wet);
	("verb wet = " ++ wet.round(0.001)).postln;
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
	//~amp_mel = args[0].linlin(0,127,0.0, 1.8);
	//("~amp_mel = " ++ ~amp_mel.round(0.001)).postln;
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
	//args.postln;
	~amp_shepards = args[0].linlin(0,127,0.0, 1.5);
	("~amp_shepard = " ++ ~amp_shepards.round(0.001)).postln;
},8);
)

