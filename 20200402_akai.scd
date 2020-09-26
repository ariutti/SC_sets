~z = -1;

// now tru to change the custom envelope
(
// a custom envelope
var winenv = Env([0, 1, 0], [0.0, 0.5], [8, -8]);
~z = Buffer.sendCollection(s, winenv.discretize, 1);
)
~z.plot;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,2, \lpf,5000, \wet,1.0);
~verb.free;

(
Pbindef(\test_gfm,
	\instrument, \gfm,
	\scale, Scale.minor,
	\gdur, Pexprand(0.1, 1, inf),
	\gdensity, Pexprand(1, 100, inf), //Prand([1,2,4], inf), //Pfunc({TempoClock.default.beatDur}) * 4,
	\octave, Prand([4,5,6,7],inf),
	\degree, Prand([0,2,4,6], inf),
	\mf, Pn(Pgeom(0.125,2,8),inf),
	\mi, Pexprand(0.01, 8, inf),
	\dur, 0.25,
	\atk, 0.01,
	\rel, 3,
	\amp, Pgauss(0.1, 0.01, inf),
	\envbuf, Pfunc({~z}),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, 0, //Prand([0,1], inf)
).quant_(1).play;
)

(
Pbindef(\test_gfm).stop;

Pbindef(\pads).stop;
)


(
Pbindef(\test_gfm).play;
Pbindef(\pads).play;
)

// BASS ///////////////////////////////////////////////////


(
SynthDef(\fm4bass, {
	|
	amp=1.0, freq=440, pan=0.0, out=0,
	atk=0.0, rel=0.1,
	mi=0, n1=1, n2=1, iatk=0.01, irel=0.1, iAdd=0.0
	|
	var env = EnvGen.ar(Env.perc(atk,rel,curve:[4,-4]), 1, doneAction:2);
	var iEnv= EnvGen.ar(Env.perc(iatk, irel),1);
	var fmod = freq*n2;
	var mod = SinOsc.ar(fmod, mul:(mi*iEnv), add:iAdd );
	var sig = SinOsc.ar(freq*n1 + mod);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

s.scope

(
~bass_lickA = [0,0,4,7];
~bass_dursA = [0.25, 0.25, 0.25, 1.25];

~bass_lickB = [0,0,4,7,4,7];
~bass_dursB = [0.25,0.25,0.25,0.75,0.25,0.25];
)

(
Pbindef(\bass,
	\instrument, \ring1,
	\octave, 3,
	\degree, Pseq(~bass_lickB,inf),
	\dur, Pseq(~bass_dursB, inf),
	\dist, 5,
	\atk, 0.001,
	\rel, 0.5,
	\amp, 0.5,
	\pan, 0.0,
	\addAction,1
).quant_([4]).play;
)

Pbindef(\bass).stop;

// PADS /////////////////////////////////////////////////////////


(
SynthDef(\sinfbMod, {
	|
	freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0,
	detfreq=6, detamt=6
	|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
	sig = SinOscFB.ar(freq + (SinOsc.ar(detfreq, mul:detamt*freq)*Line.kr(0.0, 1.0)),fb,1);
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);


(
~pads_notes = [
	[0,2,4,4],
	[-1,1,3,4],
	[-2.1,0,2,4],
	[-2,0,2,4],
	[-1.1,0,3,4]
];
)

(
Pbindef(\pads,
	\instrument, \sinfbMod,
	\octave, [4,5,6,6],
	\scale, Scale.minor,
	\degree, Pseq(~pads_notes,inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(4),
	\fb, Pexprand(0.2, 0.6,inf).clump(4),
	\amp, 0.065,
	\atk, 0.2,
	\dur, Pseq([4,4,4,2,2],inf),
	\rel, Pkey(\dur),
	\pan, Pxrand([-1, 1], inf).clump(4),
	\detfreq, Pwhite(4,7, inf).clump(4),
	\detamt,  Pwhite(0.001,0.025, inf).clump(4),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\pads).stop;



(
Pbindef(\amen,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["amencutup"],Pseq((0..~dirt["amencutup"].size),inf),inf), //Pindex(~dirt["amencutup"], Pn(Prand((0..~dirt["amencutup"].size),inf),Prand([1,4],inf)),	inf),
	\dur, Pwrand([0.25, Pn(0.125,2),Pn(0.065,4)], [6,3,0.1].normalizeSum, inf),
	\atk, 0.0,
	\amp,2,
	\rel, 2,
	\rate, 1.2,
	\addAction,1
).quant_(4).play;
)


Pbindef(\amen, \rate, 0.9);
(
Pbindef(\amen,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["amencutup"],Pseq([7,2],inf),inf),
	\atk, 0.0, \rel, 2,
	\amp, 1 * Pseq([1, 1.4],inf),
	\dur, 1,
	\rate, Pseq([0.9, 0.5], inf),
	\addAction, Pseq([1,1], inf)
).quant_(4).stop.play;
)

(
Pbindef(\amen,
	\buf, Pindex(~dirt["amencutup"],Pseq([7,2],inf),inf),
	\rel, 2,
	\amp, 1 * Pseq([1.4, 1],inf),
	\dur, 1,
	\rate, 0.9, //Pseq([0.9, 0.5], inf),
	\addAction, Pseq([1, Prand([0,1], 1)], inf)
).quant_(4).stop.play;
)

(
Pbindef(\amen,
	\buf, Pindex(~dirt["amencutup"],Pseq((0..~dirt["amencutup"].size),inf),inf),
	\dur, 0.25,
).play;
)


(
Pbindef(\amen,
	\buf, Pindex(~dirt["amencutup"],Pseq((0..~dirt["amencutup"].size),inf),inf),
	\dur, Pwrand([0.25, Pn(0.125,2)], [10,5].normalizeSum, inf),
).play;
)



(
Pbindef(\hh,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["amencutup"],Pseq([3],inf),inf),
	\dur,0.25,
	\atk, 0.0,
	\amp,0.5 * Pseg([0.5,1],[1],\lin, inf),
	\rel, 0.1,
	\rate, 1.5, //Pseg([0.5,1],[4],\lin, inf),
	\pan, 0.5,
	\addAction,1
).quant_(4).play;
)
Pbindef(\hh).stop;

Pbindef(\k,\instrument,\bplaym,\buf,~dirt["808bd"][6],\dur,2,\amp,1.5,\atk,0.0,\rel,0.125,\rate,1,\addAction,1).quant_(4).play;




(
Pbindef(\bass).play;
Pbindef(\amen).play;
Pbindef(\k).play;
Pbindef(\hh).play;
)

(
Pbindef(\amen).stop;
Pbindef(\k).stop;
Pbindef(\hh).stop;
)

Pbindef(\bass).stop;

(
Pbindef(\bass).play;
Pbindef(\pads).play;
)

Pbindef(\pads).stop;

(
Pbindef(\ghost1,
	\instrument, \fm4_perc,
	\octave, 5,
	\degree, Pseq([4,3,0],inf),
	\amp, 0.3,
	\n1, 3, \n2, 2, \mi, 1000,
	\atk, 0.0,
	\rel, 0.4,
	\dur, Pseq([0.5,0.25, 3.25+4],inf),
	\pan, 0.8,
	\addAction,0
).quant_([4,0]).play;
)

(
Pbindef(\ghost2,
	\instrument, \fm4_perc,
	\scale, Scale.minor,
	\octave, 5,
	\degree, Pseq([-1,-1,-1,-1,-1,0],inf),
	\amp, 0.3,
	\n1, 1, \n2, 0.25, \mi, 100,
	\atk, 0.0,
	\rel, 0.4,
	\dur, Pseq([0.25,0.25,0.25,0.25,0.25,2.75+4],inf),
	\pan, -0.8,
	\addAction,1
).quant_([1,0]).play;
)


(
Pbindef(\ghost2).stop;
Pbindef(\ghost1).stop;
)


(
~solo_lickA = [0, -1, 2,0, -1,-3];
~solo_dursA = [0.25,0.25, 0.5, 0.5,0.25,0.25];

~solo_lickB = [0,1,0,-1, 2,0, -1,-3];
~solo_dursB = [0.125,0.125,0.125,0.125, 0.5, 0.5,0.25,0.25];
)

(
Pbindef(\solo,
	\instrument, \fm4_perc,
	\scale, Scale.minor,
	\octave, 6,
	\degree, Pseq(~solo_lickB,inf),
	\amp, Pgauss(0.4, 0.1, inf),
	\n1, 1, \n2, 0.25, \mi, 100,
	\atk, 0.01,
	\rel, 0.12,
	\dur, Pseq(~solo_dursB,inf),
	\pan, Pseg([-0.5, 0.5, 0.5], [4,4],\exp,inf),
	\addAction,0
).quant_([4,0]).play;
)


(
Pbindef(\soloB,
	\instrument, \fm4_perc,
	\scale, Scale.minor,
	\octave, 7,
	\degree, Pseq([0,2,6],inf),
	\mtranspose, Pseg([0.0, 0.02, 0.1], [4,4],\lin,inf),
	\amp, Pgauss(0.2, 0.01, inf) * Pseg([0.01, 1.0, 0.01], [4,4],\exp,inf),
	\n1, 1, \n2, 0.25, \mi, 1000,
	\atk, 0.01,
	\rel, 0.1,
	\dur, Pseq([0.125],inf),
	\pan, Pwhite(-1.0 ,1.0 ,inf),
	\addAction,0
).quant_([4,0]).play;
)

// AUDIO IN //////////////////////////////////////////////


~inout = Synth(\inout, [\in,2,\ont,0],addAction:1);
~inout.set(\amp, 0.8);
~inout.free;

s.meter;
s.plotTree
StageLimiter.activate


Pbindef.gui




// MIDI IN ///////////////////////////////////////////////


MIDIClient.init;
MIDIIn.connectAll;

/*
(
~midioteOn.free;
~midioteOn = MIDIFunc.noteOn({
	arg ...args;
	//args.postln;
	Synth(\sinfb, [
		\freq, args[1].midicps,
		//\mtranspose, rrand(-0.02, 0.02),
		\fb, rrand(0.2, 1.5),
		\amp, 0.1,
		\atk, 0.1,
		\rel, 6,
		\pan, rrand(-1.0, 1.0),
	], addAction:1
	);
});
)
*/

(
~ctrl_verbSend.free;
~ctrl_verbSend = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~verb.set(\dec,2, \lpf,5000, \wet,args[0].linlin(0, 127, 0.0, 1.0) );
},1);

~ctrl_pad1.free;
~ctrl_pad1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		Pbindef(\amen).play;
	}, {
		Pbindef(\amen).stop;
	});

},20);

~ctrl_pad2.free;
~ctrl_pad2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		Pbindef(\k).play;
	}, {
		Pbindef(\k).stop;
	});

},21);

~ctrl_pad3.free;
~ctrl_pad3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		Pbindef(\hh).play;
	}, {
		Pbindef(\hh).stop;
	});
},22);

~ctrl_pad4.free;
~ctrl_pad4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		Pbindef(\bass).play;
	}, {
		Pbindef(\bass).stop;
	});

},23);

~ctrl_pad5.free;
~ctrl_pad5 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		Pbindef(\solo).play;
		Pbindef(\soloB).play;
	}, {
		Pbindef(\solo).stop;
		Pbindef(\soloB).stop;
	});

},24);

~ctrl_pads_volume.free;
~ctrl_pads_volume = MIDIFunc.cc({
	arg ...args;
	args.postln;
	Pbindef(\pads, \amp, args[0].linlin(0, 127, 0.0, 0.1));

},2);

~ctrl_pad8.free;
~ctrl_pad8 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	Task({
		Synth(\bplaym, [
			\buf,~dirt["808bd"][1],
			\amp,1,
			\atk,0.0,
			\rel,0.125,
			\rate,rrand(1.0,1.2),
		],
		addAction:0);
	}).play(quant:0);
},27);

~ctrl_pad7.free;
~ctrl_pad7 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	Task({
		Synth(\bplaym, [
			\buf,~dirt["amencutup"][2],
			\amp,0.5,
			\atk,0.0,
			\rel,0.125,
			\rate,rrand(1.0,1.9)
		],
		addAction:0);
	}).play(quant:1/8);

},26);
)
