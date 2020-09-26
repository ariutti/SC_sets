// 2020 07 28
// https://youtu.be/z3MihcqWeo0

t = TempoClock.default
t.tempo_(135/60)

(
SynthDef(\sinfbvib, {
	|freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0, dur=1, dist=1, duty=0.5|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk,rel,curve:[4,-4]), doneAction:2);
	// some vibrato
	sig = SinOscFB.ar(freq * (1.0!2 + ([-0.01, 0.01] * Line.kr(0.0, 1.0, dur*0.25))),fb,1);
	//sig = Pulse.ar(freq * (1.0!2 + ([-0.01, 0.01] * Line.kr(0.0, 1.0, dur*0.25))),duty,1);
	// some tramolo
	sig = sig * Line.kr(1.0,0.5, dur*0.5) * SinOsc.kr(6, mul:0.5, add:0.5);
	sig = (sig*dist).tanh * env * amp;
	//sig = RLPF.ar(sig, freq*2, 0.5);
	sig = LeakDC.ar(sig);
	Out.ar(out,sig);
}).add;
);

s.scope;
s.meter;
s.freqscope

(
Pbindef(\chords,
	\instrument, \sinfbvib,
	\octave, Pseq([[3,4,5]],inf),
	\degree, Pseq([
		[5,7,9],
		[4,6,8],
		Pwrand([
			Pseq([ [2,4,6], [3,5,7] ], 1),
			Pseq([ [0,2,4], [0,2,4] ], 1)+7
		], [5,1].normalizeSum, 1),
		[3,5,7],
		[4,6,8]
	],inf),
	\dur,Pseq([
		1.5,1.5,0.5,
		0.5+2,1,1
	],inf),
	\fb, (Pseg([0.0, 2, 0], [16,16], \lin,inf)).clump(3),
	\dist, 2,
	\amp, 0.1,
	\atk, 0.01,
	\rel, Pkey(\dur) * 2,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction,1,
	\stretch,1
).quant_([4,2]).stop.play;
)
Pbindef(\chords).stop;

Pbindef(\chords,\instrument, \sinfb, \amp, 0.07, \rel,2,\fb,0.5);
Pbindef(\chords,\instrument, \sinfb, \amp, 0.07, \rel,2,\fb,0.5,\stretch,2);


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);


(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["808bd"][2],\dur,1,\amp,2,\rel,0.05,\rate,1,\addAction,1).quant_(4).stop.play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pwrand([2, Pseq([0.25,1.75], 1), Pseq([1.75,0.25],1)],[5,1,1].normalizeSum,inf),\amp,0.6,\rel,0.05,\rate,0.7,\addAction,1).quant_([4,1]).stop.play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][2],\dur,0.25,\amp,Pexprand(0.05,1)*0.75, \rel,0.01,\rate,Prand((1,0.9..0.7)*0.5,inf)).quant_(4).stop.play;
Pbindef(\tom,\instrument,\bplaym,\buf,~dirt["808ht"][0],\dur,2,\amp,1.5,\rel,4,\rate,1,\addAction,1).quant_([4,3.5]).stop.play;
)


(
Pbindef(\k,\dur,Pseq([Pn(0.25, 3), 0.75, Prand([1,2,3], 1)],inf));
//Pbindef(\k,\stretch,2);
Pbindef(\s,\stretch,2);
Pbindef(\hh).stop;
Pbindef(\tom).stop;
)

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\clap).stop;
Pbindef(\whitejump).stop;
)

(
Pbindef(\k,\stretch,1,\dur,1).stop.play;
Pbindef(\s,\stretch,1).stop.play;
Pbindef(\hh,\stretch,1).stop.play;
Pbindef(\tom,\stretch,1).stop.play;
)
(
Pbindef(\mel,
	\instrument, \fm4_perc,
	\octave, Prand([[6,7]],inf),
	\scale, Scale.major,
	\root, 0,
	\degree, Pseq([0,  2,   4,  0,  2,    3,   4, \],inf),
	\dur,    Pseq([1,0.5,0.25,1.25, 0.25, 0.25,0.25,0.25],inf),
	\n1, Pseq([1],inf), \n2, Prand([4,5,6,7,8], inf), \mi, 1000,
	\iAtk, 0.0, \iRel, 0.1,
	\amp, 0.25,
	\atk, 0.0,
	\rel, 0.125,
	\pan, Pseq([1.0, -1.0], inf),
	\addAction, 0
).quant_([4,2]).play;
)
Pbindef(\mel).stop;


(
Pbindef(\mel).play;
Pbindef(\echo).play;
)

Pbindef(\whitejump).play;
Pbindef(\blip).play;
Pbindef(\clap).play;

(
Pbindef(\invaders).stop;
Pbindef(\birds).stop;
)

(
Pbindef(\invaders).play;
Pbindef(\birds).play;
)



Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,2,\amp,0.1,\rel,0.05,\rate,[0.9,1.1]*0.9,\addAction,0).quant_([4,3]).stop.play;

Pbindef(\clap).stop;

(
SynthDef(\blip, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,dur=1|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = LFPulse.ar( Line.kr(0.5,2,dur*0.25) *freq).bipolar * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\blip,
	\instrument, \blip,
	\octave, Prand([8,7],inf),
	\degree, Prand([0,-1,4],inf),
	\amp, 0.3,
	\atk, 0.0,
	\rel, 0.1,
	\dur,Pseq([0.25, 7.75], inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).play;
)
Pbindef(\blip).stop;


(
Pbindef(\echo,
	\instrument, \fm4_perc,
	\octave, Prand([6],inf),
	\degree, Pseq([0,  2,   4,   0,    2,    3,   4,   \],inf),
	\dur,    Pseq([1,0.5,0.25,1.25, 0.25, 0.25,0.25,0.25],inf),
	\n1, Pseq([1],inf), \n2, Prand([8], inf), \mi, 500,
	\iAtk, 0.0, \iRel, 0.1,
	\amp, 0.125,
	\atk, 0.01,
	\rel, 0.2,
	\pan, Pseq([-1.0, 1.0], inf),
	\addAction, 0
).quant_([4,1]).stop.play;
)
Pbindef(\echo).stop;


(
SynthDef(\filterdnoise, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,rq=0.1|
	var env = EnvGen.ar(Env.perc(atk,rel, curve:[4,-4]),doneAction:2);
	var sig = Decay2.ar(Impulse.ar(10), 0.0, 0.5) * WhiteNoise.ar();
	sig = BPF.ar(sig, freq, rq) * env * amp * 10;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\rev,
	\instrument, \filterdnoise,
	\octave, Prand([[6,7]],inf),
	\degree, Prand([Pn(4,4),Pn(0,4)],inf),
	\dur,    Pseq([2],inf),
	\rq, 0.01,
	\amp, 1,
	\atk, Pkey(\dur) * t.beatDur,
	\rel, 0.001,
	\pan, Pseq([[-1, 1],[1, -1]],inf), //Pseg([1.0, -1.0, 1.0],[8,8],\exp,inf),
	\addAction, 0
).quant_([4,1]).play;
)
Pbindef(\rev).stop;


(
SynthDef(\noise, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel, curve:[8,-4]),doneAction:2);
	var sig = LFNoise0.ar(10000) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)



(
Pbindef(\whitejump,
	\instrument, \noise,
	\dur, Pseq([2],inf),
	\amp, 0.05,
	\atk, Pkey(\dur) * t.beatDur,
	\rel, Pkey(\dur) * t.beatDur,
	\pan, 0.0,
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\whitejump).stop;


(
Pbindef(\invaders,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["invaders"], Prand((0..~dirt["invaders"].size-1), inf),inf),
	\dur, 8,
	\amp, 0.5,
	\rel, 0.1,
	\rate, 1,
	\addAction,1
).quant_([4,1]).stop.play;
)

(
Pbindef(\birds,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["birds3"], Prand((0..~dirt["birds3"].size-1), inf),inf),
	\dur, 0.25,
	\amp, 0.5,
	\rel, 0.25,
	\rate, 1,
	\addAction,1
).quant_([4,1]).stop.play;
)




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


// PADS ////////////////////////////////////////
(
~pad1.free;
~pad1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad 1 pressed".postln;
		Pbindef(\k).play;
		Pbindef(\s).play;
		Pbindef(\hh).play;
		Pbindef(\tom).play;
		Pbindef(\clap).play;
		Pbindef(\blip).play;
	}, {
		"pad 1 pressed".postln;
		Pbindef(\k).stop;
		Pbindef(\s).stop;
		Pbindef(\hh).stop;
		Pbindef(\tom).stop;
		Pbindef(\clap).stop;
		Pbindef(\blip).stop;
	});
},20);

~pad2.free;
~pad2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad 2 pressed".postln;
		Pbindef(\invaders).play;
		Pbindef(\birds).play;
	}, {
		"pad 2 released".postln;
		Pbindef(\invaders).stop;
		Pbindef(\birds).stop;
	});

},21);


~pad3.free;
~pad3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad 3 pressed".postln;
		Pbindef(\whitejump).play;
		Pbindef(\rev).play;
	}, {
		"pad 3 released".postln;
		Pbindef(\whitejump).stop;
		Pbindef(\rev).stop;
	});
},22);

~pad4.free;
~pad4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad 4 pressed".postln;
	}, {
		"pad 4 released".postln;

	});
},23);

~pad5.free;
~pad5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad 5 pressed".postln;
		Pbindef(\chords).play;
	}, {
		"pad 5 released".postln;
		Pbindef(\chords).stop;
	});
},24);


~pad6.free;
~pad6 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad 6 pressed".postln;
		Pbindef(\mel).play;
		Pbindef(\echo).play;

	}, {
		"pad 6 released".postln;
		Pbindef(\mel).stop;
		Pbindef(\echo).stop;
	});
},25);


~pad7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad 7 pressed".postln;

	}, {
		"pad 7 released".postln;

	});
},26);


~pad8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad 8 pressed".postln;

	}, {
		"pad 8 released".postln;

	});
},27);
)




// KONTROLS ////////////////////////////
(
~k1.free;
~k1 = MIDIFunc.cc({
	arg ...args;


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
	var rq;
	args.postln;
	rq = args[0].linexp(0, 127, 1, 0.1);
	~filt.set(\rq, rq);

},8);
)

// BEND ////////////////////////
(
~bend.free;
~bend = MIDIFunc.bend({
	arg ...args;
	var freq;
	args.postln;
	freq = args[0].linexp(0,16383, 100, 6000);
	~filt.set(\freq, freq);
});
)
~filt.free;




(
~filt = Synth(\masterFilter,
	target: RootNode(Server.default),
	addAction: \addToTail
);
)

~filt.free

(
SynthDef(\masterFilter, {
	|freq=1000, rq=2|
	var input = In.ar(0, 2);
	input = BPF.ar(input, freq, rq);
	ReplaceOut.ar(0, input) ;
}).add;
)