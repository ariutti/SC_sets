
(
~intro = {"'Se telefonando' by Ennio Morricone".postln;
	"inspired by DeltaV and Subsonica";
	"performed by Nicola Ariutti";
};
)
~intro.value;

({
	// startup
	MIDIClient.init;
	s.sync;
	MIDIIn.connectAll;
	s.sync;

	TempoClock.default.tempo_(135/60);
	t = TempoClock.default;

	~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
	~verb.set(\dec,0.6, \lpf,1500, \wet,1.0);


	~root = -1;  // 2

	Tdef(\rootChanger, {
		loop{
			~root = -1;
			~root.postln;
			wait(16*2*2);
			~root = 2;
			~root.postln;
			wait(16*2*2);
		};
	}).quant_(4);



	// Synth defs /////////////////////////////////////////////

	SynthDef(\distdoublebass, {
		|freq=440, pan=0.0, amp=1.0, out=0
		atk=0.05, rel=0.2, fc=67, dist=1.0,
		width=0.5
		|
		var sig, env;
		env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
		sig = Pulse.ar(freq, width) ;
		sig = LPF.ar(sig, fc);
		sig = LeakDC.ar(sig);
		sig = (sig * dist).tanh;
		sig = sig * env * amp;
		Out.ar(out, Pan2.ar(sig, pan));
	}).add;

	~bass_degs = [-1, 0,0,-1,0,-4,-3,-1];
	~bass_durs = [0.5];
	~amp_bass = 0.4;


	SynthDef(\varsaw, {
		|
		freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0,
		width=0.1
		|
		var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
		var sig = VarSaw.ar(
			(freq * [0.999, 1.001]) +
			(Line.kr(0.0, 1.0, 0.5)*LFNoise2.kr(6).range(5)),
			width:width) * env * amp;
		Out.ar(0, sig);
	}).add;

	SynthDef(\sinfb_tremolo, {
		arg freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0, dur=1;
		var sig, env;
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
		sig = SinOscFB.ar(freq + (Line.ar(0.0, 1.0, dur*0.125)*SinOsc.kr(6, mul:10)),fb,1);
		sig = sig*env;
		Out.ar(out,Pan2.ar(sig,pan,amp));
	}).add;


	~mel_ptA1  = [2, 1,-1,  2, 1,-1, 2, 1,  2,-1, 2, 1,  -1, 2, 1,-1, 2, -1, 2, 3];
	~mel_ptA2  = [3, 2,-1,  3, 2,-1, 3, 2,  3,-1, 3, 2,  -1, 3, 2,-1, 3, 2, 3, 4];
	~mel_ptB1  = ~mel_ptA1;
	~mel_ptB2  = [3, 2,-1,  3, 2,-1, 3, 2,  3,-1, 3, 2,  -1, 3, 2,-1, 3, 2, 0, -1];
	~mel_degs = ~mel_ptA1; // ++ ~mel_ptA2 ++ ~mel_ptB1 ++ ~mel_ptB2;
	~mel_durs = [1, 1, 1,0.5, 1, 1, 1, 1,0.5, 1, 1, 1, 0.5, 1, 1, 1, 1,0.5, 8, 8];
	~amp_mel = 0.0;


	a = Buffer.read(s, "/home/nicola/Musica/sfx/dialup_by_oona.wav");
	~amp_dial = 0.0;

	~amp_shepards = 0.1;

	"\nWARNING: remember evaluate MIDI functions".postln;



}.fork;
)



s.meter;
s.scope;
s.plotTree;
StageLimiter.activate;
Pbindef.gui;
Pbindef.gui;


Tdef(\rootChanger).play;
Tdef(\rootChanger).stop;


(
Pbindef(\bass,
	\instrument, \distdoublebass,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, [3,4],
	\degree, Pseq([0],inf),
	\amp, Pseq([1.2,Pn(0.7,3)], inf) * Pfunc({~amp_bass}),
	\fc, Pseg([240, 120, 240],[4,4], \exp, inf),
	\width, 0.01,
	\dist, 30,
	\atk, 0.0,
	\rel, 0.2,
	\dur, 0.5,
	\pan, 0.0,
	\addAction,1
).quant_([4,0]).stop;
)

(
Pbindef(\bass,
	\instrument, \distdoublebass,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, [3,4],
	\degree, Pseq(~bass_degs,inf),
	\amp, Pseq([1.2,Pn(0.7,3)], inf) * Pfunc({~amp_bass}),
	\fc, Pseg([240, 120, 240],[4,4], \exp, inf),
	\width, 0.01,
	\dist, 30,
	\atk, 0.0,
	\rel, 0.2,
	\dur, Pseq(~bass_durs, inf),
	\pan, 0.0,
	\addAction,1
).quant_([4,0]).stop;
)
Pbindef(\bass).stop;


(
Pbindef(\dial,
	\instrument,\bplaym,
	\buf, a,
	\pos, 0.55, //Pwhite(0.1, 0.25, inf),
	\dur, Pseq([2], inf),
	\rel, Pkey(\dur),
	\rate, Pfunc({~root}).midiratio,
	\addAction, 1, //Prand([0,1],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, Pfunc({~amp_dial})
).quant_(1).play;
)
Pbindef(\dial).stop;

(
Pbindef(\dial).stop;
~dial = Synth(\bplaym, [
	\buf, a,
	\pos, 0.55, //Pwhite(0.1, 0.25, inf),
	\rel, 8,
	\dur, 32,
	\rate, ~root.midiratio,
	\pan, 0.0,
	\amp, ~amp_dial
], addAction:1)
)


// INTRo FORK
(
{
	"intro".postln;
	(4+4+4+2).wait;

	Pbindef(\dial).stop;
	~dial = Synth(\bplaym, [
		\buf, a,
		\pos, 0.55, //Pwhite(0.1, 0.25, inf),
		\rel, 8,
		\dur, 32,
		\rate, ~root.midiratio,
		\pan, 0.0,
		\amp, ~amp_dial
	], addAction:1);

	(2+8+8-1).wait;

	Pbindef(\bass,
		\instrument, \distdoublebass,
		\scale, Scale.minor,
		\root, Pfunc({~root}),
		\octave, [3,4],
		\degree, Pseq(~bass_degs,inf),
		\amp, Pseq([1.2,Pn(0.7,3)], inf) * Pfunc({~amp_bass}),
		\fc, Pseg([240, 120, 240],[4,4], \exp, inf),
		\width, 0.01,
		\dist, 30,
		\atk, 0.0,
		\rel, 0.2,
		\dur, Pseq(~bass_durs, inf),
		\pan, 0.0,
		\addAction,1
	).quant_([4,0]).stop.play;

}.fork;
)


Tdef(\intro_2).clear;


(
Pbindef(\stabs,
	\instrument, Prand([\squarebass,\fm4,\syncsaw],inf),
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([6,7],inf).clump(3),
	\degree, Pseq([
		 Pseq([[0,2,4]], 16), // Bm
		 Pseq([[-1,1,3,4]], 16), // F#m
		 Prand([[-1,0,2,4],[-2,0,2,4]], 16), // Em
		 Pseq([[-1,1,3,4]], 16), // F#m
		 //-1 + Pseq([[-1,1,3,4]], 1), // A7
	], inf),
	\n1, 1, \n2, Prand([2,4,6,8], inf), \mi, Pwhite(100, 1000, inf).clump(3),
	\iatk, 0.01, \irel, 0.01,
	\iAdd, Pwhite(0.0, 5,inf).clump(3), //Pseg([0.0, 10], [8], \lin, inf),
	\dur, Pseq([Pn(0.5, 16)],inf),
	\atk, 0.05, //Pkey(\dur)*0.1,
	\rel, 0.01, //Pkey(\dur)*0.9,
	\amp, 0.1 * Pseg([0.2, 1.0],[4],\exp, inf),
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pwrand([1,0],[100,1].normalizeSum, inf).clump(3),
	\strum, Pwhite(0.0, 0.01, inf)
).quant_([4,0]).stop;
)
Pbindef(\stabs).stop;


(
Pbindef(\padA,
	\instrument, \varsaw,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([5,6],inf).clump(3),
	//\degree, (Pseq([0,2,4],inf).collect({|n| n+[0,7].choose}).clump(3) + Pseq([0,-2,-3,0,-2,-1],inf)).trace,
	\degree, ((Pseq([0,2,4],inf) + Pwrand([0,7],[1,0.1].normalizeSum, inf)).clump(3) + Pseq([0,-2,-3,0,-2,-1],inf)),

	\width, Pwhite(0.3, 0.5, inf).clump(3),
	\dur, Pseq([Pn(4,4), Pn(8,2)], inf),
	\atk, Pkey(\dur)*0.5*t.beatDur,
	\rel, Pkey(\dur)*2*t.beatDur,
	\amp, 0.1 * Pseg([0.1, 1.0,1.0],[16,16],\exp,inf),
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, 0, //Prand([0,1], inf).clump(3)
).quant_([4,0]).stop;
)
Pbindef(\padA).play;
Pbindef(\padA).stop;


(
Pbindef(\padB,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([6,5],inf).clump(3),
	\degree, Pseq([
		 Pseq([[0,2,4]], 1), // Bm
		 Pseq([[-1,1,3,4]], 1), // F#m
		 Prand([[-1,0,2,4],[-2,0,2,4]], 1), // Em
		 Pseq([[-1,1,3,4]], 1), // F#m
		 //-1 + Pseq([[-1,1,3,4]], 1), // A7
	], inf),
	\fb, Pwhite(0.4,0.8, inf).clump(4),
	\dur, Pseq([Pn(8,4)], inf),
	//\dur, Pseq([Pn(4,4), Pn(8,2)], inf),
	\atk, Pkey(\dur)*0.25*TempoClock.default.beatDur,
	\rel, Pkey(\dur)*0.75*TempoClock.default.beatDur,
	\amp, 0.06,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pwrand([1,0],[100,1].normalizeSum, inf).clump(3),
	\strum, Pwhite(0.0, 0.01, inf)
).quant_([4,2]).stop;
)
Pbindef(\padB).stop;
Pbindef(\padB).play;

(
Pbindef(\stabs).stop;
Pbindef(\padA).stop;
Pbindef(\padB).stop;
)


d.keys
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["808bd"][0],\dur,Pseq([4,1,3],inf),\amp,4,\rel,0.2,\rate,1,\addAction,1).quant_([4,0]);
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["808sd"][1],\dur,Pseq([4],inf),\amp,0.4,\rel,0.3,\rate,1.1,\addAction,1).quant_([4,2]);
Pbindef(\c,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,Pseq([1.5,2.5],inf),\amp,0.1,\rel,0.2,\rate,0.7,\addAction,1).quant_([4,2]);
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808"][1],\dur,0.5,\amp,Pseg([1,0.2], [2], \lin,inf) * 0.5,\addAction,1).quant_([1]);
)

(
Pbindef(\k).stop;
Pbindef(\c).stop;
Pbindef(\hh).stop;
Pbindef(\s).stop;
)


Pbindef(\lt,\instrument,\bplaym,\buf,~dirt["808mt"][1],\dur,Pseq([0.5],3),\rel,2,\rate,Pseq([3,1,-2],inf).midiratio,\amp,1,\addAction,Pseq([1,1,0],inf), \pan, Pseq([1,0,-1],inf)).quant_([1]).play;



(
Pbindef(\mel,
	\instrument, \sinfb_tremolo,
	\octave, [5,6],
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}),
	\detune, Pwhite(3, 5, inf).clump(2),
	\dist, Pwhite(5, 10,inf).clump(2),
	\fb, 0.5,
	\amp, Pseq([Pn(0.1,18), Pn(0.1,2)],inf)* Pfunc({~amp_mel}),
	\atk, Pseq([Pn(0.0,18), Pn(0.02,2)],inf),
	\dur,Pseq(~mel_durs,inf),
	\rel, Pseq([Pn(0.2,18), Pkey(\dur) * TempoClock.default.beatDur],inf),
	\pan, Pwhite(-1.0 ,1.0,inf).clump(2),
	\lag, Pwhite(0.0, 0.05, inf).clump(2),
	\strum, 0.0, //Pwhite(-0.01, 0.01, inf),
	\addAction,0
).quant_([4,0]);

Pbindef(\mel_fm,
	\instrument, \fm4_perc,
	\octave, 5,
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq(~mel_degs,inf),
	\detune, 0, //Pwhite(3, 5, inf),
	//\n1, Pseq([1,2,3], inf),\n2, 8, \mi, 5000,
	\n1, 1,\n2, 8, \mi, 1000,
	\iatk, 0.5,\irel, 5, \iAdd, 3,

	\amp, Pseq([Pn(0.1,18), Pn(0.1,2)],inf)* Pfunc({~amp_mel}),
	\atk, Pseq([Pn(0.0,18), Pn(0.02,2)],inf),
	\dur, Pseq(~mel_durs,inf),
	\rel, Pseq([Pn(0.2,18), Pkey(\dur) * t.beatDur],inf),
	\pan, Pwhite(-1.0 ,1.0,inf).clump(2),
	\lag, Pwhite(0.0, 0.05, inf).clump(2),
	\strum, 0,
	\addAction,0
).quant_([4,0]);
)
Pbindef(\mel).stop;
Pbindef(\mel,\fb, 0.5, \amp, 0.06)
Pbindef(\mel).play;
Pbindef(\mel_fm).play;
Pbindef(\mel_fm).stop;

s.meter

(
Pbindef(\fmfx,
	\instrument, \fm4_perc,
	\octave, Prand([6,7,8],inf),
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Prand([0,4],inf),
	\detune, 0, //Pwhite(3, 5, inf),
	//\n1, Pseq([1,2,3], inf),\n2, 8, \mi, 5000,
	\n1, Prand([1,2],inf),\n2, 8, \mi, 6000,
	\iatk, 0.1,\irel, 0.1, \iAdd, 5,

	\amp, Pgauss(0.1, 0.05,inf) * Pseg([1.0, 0.5],[2], \lin, inf),
	\atk, 0.0,
	\dur, Pgeom(1.0/3, 0.95, 16),
	\rel, 0.1,
	\pan, Prand([
		Pseg([-1.0,  1.0], [2],\lin, 1),
		Pseg([ 1.0, -1.0], [2],\lin, 1),
	],inf),
	\lag, 0,
	\strum, 0,
	\addAction, Prand([0,1],inf)
).quant_([1,0.5]).stop.play;
)





// MIDI IN ///////////////////////////////////////////////


MIDIClient.init;
MIDIIn.connectAll;


// PADS ////////////////////////////////////////
(
~padA1.free;
~padA1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A1 pressed".postln;
		Pbindef(\k).play;
	}, {
		"pad A1 released".postln;
		Pbindef(\k).stop;

	});
},20);

~padA2.free;
~padA2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A2 pressed".postln;
		Pbindef(\s).play;
	}, {
		"pad A2 released".postln;
		Pbindef(\s).stop;
	});
},21);


~padA3.free;
~padA3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A3 pressed".postln;
		Pbindef(\hh).play;
		Pbindef(\c).play;
	}, {
		"pad A3 released".postln;
		Pbindef(\hh).stop;
		Pbindef(\c).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed".postln;
		Tdef(\activate_shepard).play;

	}, {
		"pad A4 released".postln;
		Tdef(\deactivate_shepard).play;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed".postln;
		Pbindef(\bass).play;

	}, {
		"pad A5 released".postln;
		Pbindef(\bass).stop;

	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed".postln;
		Pbindef(\stabs).play;

	}, {
		"pad A6 released".postln;
		Pbindef(\stabs).stop;

	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed".postln;
		Pbindef(\padA).play;
		Pbindef(\padB).play;

	}, {
		"pad A7 released".postln;
		Pbindef(\padA).stop;
		Pbindef(\padB).stop;

	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed".postln;
		Pbindef(\mel).play;
		//Pbindef(\mel_fm).play;

	}, {
		"pad A8 released".postln;
		Pbindef(\mel).stop;
		//Pbindef(\mel_fm).stop;
	});
},27);

~padB1.free;
~padB1 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B1 pressed".postln;
		//Tdef(\section_D).play;
		Tdef(\rootChanger_once).play;

	}, {
		"pad B1 released".postln;
		//Tdef(\section_E).play;
		Tdef(\rootChanger_once).stop;
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
			Tdef(\section_B).play;

	}, {
		"pad B4 released".postln;
			Tdef(\section_B).stop;
			Tdef(\section_C).play;

	});
},31);

~padB5.free;
~padB5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B5 pressed".postln;
		Pbindef(\fx1).play;

	}, {
		"pad B5 released".postln;
		Pbindef(\fx1).stop;

	});
},32);


~padB6.free;
~padB6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B6 pressed".postln;
		Pbindef(\seagulls).play;

	}, {
		"pad B6 released".postln;
		Pbindef(\seagulls).stop;

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
)






// KONTROLS ////////////////////////////
(
~k1.free;
~k1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~amp_bass = args[0].linlin(0,127,0.0, 1.0);

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
	~amp_dial = args[0].linlin(0,127,0.0, 1.0);
	/*
	if( ~dial != nil, {
		~dial.set(\amp, ~amp_dial*2);
	});
	*/
},3);

~k4.free;
~k4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	~amp_mel = args[0].linlin(0,127,0.0, 1.8);

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
	~amp_shepards = args[0].linlin(0,127,0.0, 1.5);

},8);
)


~init_pads.value;
~init_kontrols.value;


(
Tdef(\section_B, {
	Pbindef(\dial).play;
	Tdef(\deactivate_shepard).play;
	Pbindef(\seagulls).stop;
    Pbindef(\fx1).stop;
	Pbindef(\bass).stop;
	Pbindef(\mel).stop;
	Pbindef(\stabs).stop;
	Pbindef(\padA).stop;
	Pbindef(\padB).stop;
	Pbindef(\k).stop;
	Pbindef(\s).stop;
	Pbindef(\hh).stop;
	Pbindef(\c).stop;
	~amp_dial = 0.6;
	~amp_bass = 0.0;
	loop{
		Pbindef(\mel).play;
		(4+4+4).wait;
		Pbindef(\mel).stop;
		4.wait
	}
}).quant_([4]);
)

Tdef(\section_B).play;
Tdef(\section_B).stop;

(
Tdef(\section_C, {
	Pbindef(\bass).play;
	Tdef(\section_B).stop;
	Tdef(\deactivate_shepard).play;
	Pbindef(\mel).stop;
	Pbindef(\mel).play;
	Pbindef(\stabs).play;
	Pbindef(\padA).play;
	Pbindef(\padB).play;
	Pbindef(\k).play;
	Pbindef(\s).play;
	Pbindef(\hh).play;
	Pbindef(\c).play;
	~amp_dial = 0.0;
	~amp_bass = 1.0;
}).quant_([4])
)

Tdef(\section_C).play;
Tdef(\section_C).stop;


(
Tdef(\rootChanger_once, {

	Pbindef(\mel).stop;

	~mel_degs = ~mel_ptA1 ++ ~mel_ptA2 ++ ~mel_ptB1 ++ ~mel_ptB2;
	Pbindef(\mel,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
	Pbindef(\mel_fm,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));

	~root = -1;
	~root.postln;

	Pbindef(\mel).play;

	wait(16*2*2);

	~root = 2;
	~root.postln;
	wait(16*2*2);

	~root = -1;
	~root.postln;

	~mel_degs = ~mel_ptA1;
	Pbindef(\mel,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
	Pbindef(\mel_fm,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
}).quant_(4);
)


(
Tdef(\section_D, {
	"section D".postln;
	~mel_degs = ~mel_ptA1 ++ ~mel_ptA2 ++ ~mel_ptB1 ++ ~mel_ptB2;
	Pbindef(\mel).stop.play;
	Pbindef(\mel,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
	Pbindef(\mel_fm,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
	Tdef(\rootChanger).play;
}).quant_([4,0]);
)

(
Tdef(\section_E, {
	"section E".postln;
	Tdef(\rootChanger).stop;
	~root = -1;
	~mel_degs = ~mel_ptA1;
	Pbindef(\mel,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));
	Pbindef(\mel_fm,\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}));

}).quant_([4,0]);
)

Tdef(\section_E).clear


~mel_degs = ~mel_ptA1 ++ ~mel_ptA2 ++ ~mel_ptB1 ++ ~mel_ptB2;


// SHEPARD EFFECT

(
SynthDef(\combi1, {
	|
	amp=0.5,pan=0.0,
	f1=440, f2=6000,lenght=20,out=0
	|
	var sig, env;
	env = EnvGen.ar(Env.triangle(lenght),1, doneAction:2);
	sig = PinkNoise.ar();
	sig = CombC.ar(sig, 0.01, XLine.kr(f1.reciprocal, f2.reciprocal, lenght), 0.2);
	sig = HPF.ar(sig, 500);
	sig = sig * env;

	sig = sig * amp;

	Out.ar(out, Pan2.ar(sig, pan));

}).add;
);


(
~amp_shepards = 0.1;
)

(
Pbindef(\noise_falling,
	\instrument, \combi1,
	\f1, Pwhite(2000, 3000, inf),
	\f2, Pwhite(500, 1000, inf),
	\lenght, Pwhite(10, 20, inf),
	\dur,0.25,
	\amp, 0.05 * Pfunc({~amp_shepards}),
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\group, ~grp_shepards,
	//\addAction, Prand([0],inf)
);
)
Pbindef(\noise_falling).play;
Pbindef(\noise_falling).stop;


// create a grp where to place the shepard synths
// play the pattern
(
Tdef(\activate_shepard, {
	"activate shepards".postln;
	~grp_shepards = Group.new(s);
	Pbindef(\noise_raising,
		\instrument, \combi1,
		\f1, Pwhite(500, 1000, inf),
		\f2, Pwhite(2000, 3000, inf),
		\lenght, Pwhite(3, 5, inf),
		\dur, 0.25,
		\amp, 0.1 * Pfunc({~amp_shepards}),
		\out, 0,
		\pan, Pwhite(-1.0, 1.0, inf),
		\group, ~grp_shepards,
		\addAction, Prand([1],inf)
	).quant_(0).play;
}).quant_(0);
)
// evaluate the code below to instantly kill all the shepards and the container grp
(
Tdef(\deactivate_shepard, {
	"deactivate shepards".postln;
Pbindef(\noise_raising).stop;
~grp_shepards.free;
}).quant_([0]);
)


// temp
Pbindef(\noise_raising).play;



// addendum

(
Pbindef(\fx1,
	\instrument, \fm4_perc,
	\octave, [6,7],
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq([0,-1,-3,-4,-5],inf),
	\detune, 0, //Pwhite(3, 5, inf),

	\n1,2,\n2, 8, \mi, 1000,

	//\n1, Pseq([1,2,4], inf), \n2, Prand([16,8,4,2],inf), \mi, 1000,

	\iatk, 0.5,\irel, 0.1, \iAdd, 10,

	\amp, Pgauss(0.05,0.01,inf),
	\atk, 0.01,
	\dur, Pseq([Pn(0.5,4),2],inf),
	\rel, 1,
	\pan, Pwhite(-1.0, 1.0, inf),
	\lag, 0,
	\strum, 0.0,
	\addAction, 0
).quant_([4,2]).stop;
)

(
Pbindef(\fx1).clear;
Pbindef(\fx1,
	\instrument, \fm4_perc,
	\octave, [7,8],
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq([0,-1,-3,-4,-5].pyramid(2),inf),
	\detune, 0, //Pwhite(3, 5, inf),

	\n1,2,\n2, 8, \mi, 1000,

	//\n1, Pseq([1,2,4], inf), \n2, Prand([16,8,4,2],inf), \mi, 1000,

	\iatk, 0.01,\irel, 0.1, \iAdd, 10,

	\amp, Pgauss(0.03,0.01,inf),
	\atk, 0.01,
	\dur, Pseq([Pn(0.5,4),2],inf),
	\rel, 1,
	\pan, Pwhite(-1.0, 1.0, inf),
	\lag, 0,
	\strum, 0.0,
	\addAction, 0
).quant_([4,2]).stop;
)

Pbindef(\fx1).stop;



(
SynthDef(\seagull, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,dist=0.0|
	var env, sig;
	env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	freq = Line.kr(freq, freq * (-2).midiratio, rel*0.5, doneAction:0);
	//sig = SinOscFB.ar(freq, fb);
	//sig = VarSaw.ar(freq, width:fb);
	sig = Ringz.ar( Impulse.ar(0) ,freq,rel, dist).tanh;
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\seagulls,
	\instrument, \seagull,
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\octave, Prand([6,7],inf),
	\degree, Prand([0,2,4],inf),
	\dist, Pwhite(0.0, 80, inf),
	\amp, Pgauss(0.015, 0.005, inf),
	\atk, 0.1,
	\rel, 2,
	\dur, Prand([0.5,1,7], inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]);
)

(
Pbindef(\seagulls).stop;
Pbindef(\fx1).stop;
)
