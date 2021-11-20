(
// 136 BPM
t = TempoClock.default;
t.tempo_(136/60);
~scale = Scale.minor;
~root = 0;
)

~verb.set(\dec,5, \lpf,7000, \wet,1);

// start with a dark and gloomy pad
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
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, Prand([3,4], inf).clump(6),
	\degree, Pseq([3.1,4],inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.3, 0.01, inf).clump(6) * 0.125,
	\dur, Pseq([4,8],inf),
	\addAction,0
).quant_(4).play;
)

Pbindef(\pads).stop;





(
Pbindef(\caossine,
	\instrument, \caossine,
	\scale, Pfunc({~scale}),
	\degree, 0,
	\detune, 0,
	\octave, Prand((3..12), inf),
	\dur, Prand([5,3,7], inf),
	\im, Pwhite(16, 35, inf),
	\fb, Pwhite(0.1, 16, inf),
	\a, Pexprand(0.1,1.2, inf),
	\c, Pexprand(1,6, inf),
	\atk, 2,
	\sus, 0,
	\rel, 5, //Pexprand(0.1,0.3, inf),
	\amp, 0.025,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4]).play;
)
Pbindef(\caossine).stop;






//Pbindef(\r1,\instrument,\bplaym,\buf,~dirt["jazz"][0],\dur,2,\amp,Pseg([0.0, 2, 0.0],[4,4],\lin,inf),\rel,0.1,\rate,1,\addAction,1).quant_([4,0]).stop.play;
//Pbindef(\r1).stop;
~dirt["jazz"].size
Pbindef.gui



// original LEAD
(
Pbindef(\lead,
	\instrument, \brinkmann1,
	\octave, Pseq([[4,5]], inf).clump(3),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree,  Pseq([Pn(14,6), 14+7], inf), //3.1 +4 //Pseq([3.1, 4], inf),
	\mtranspose, 0, //Pseg([0, 0.3, 0],[4,4],\lin, inf),
	\fb, 1.5, //Pseg([0.9, 1.1, 0.9],[4,4], \lin, inf), //Pwhite(0.1, 0.9,inf).clump(3),
	\dur, Pseq([Pn(0.25,4), Pn(0.5,7), 1], inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.0,
	\rel, 0.1, //Pseg([0.5, 0.1, 0.5],[4,4], \lin, inf),
	\type, 2,
	\noise, 0.1,
	\amp, 0.1, //Pseg([0.0, 0.4, 0.0], [4, 4], \lin, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pseq([Pn(1,7), 0], inf),
	\stretch,1,
).quant_([4,0]).stop.play;
)
Pbindef(\lead).stop;
Pbindef(\lead, \amp, 0.2)

// four on the floor with some variation
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,Pseq([Pn(2,7),0.5, 1.5],inf),\amp,8,\atk, 0.0, \rel,0.1,\rate,1,\addAction,1, \stretch, 0.5).quant_(4).play;
Pbindef(\k).stop;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,Pbjorklund2(5,8,inf,0)/4,\amp,0.5,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,1).quant_(4).play;
Pbindef(\hh).stop;

//Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,2,\amp,2,\rel,0.4,\rate,0.5,\addAction,1).quant_([4,1]).play;
//Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][9],\dur,2,\amp,2,\rel,0.4,\rate,1,\addAction,1).quant_([4,1]).play;
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["jazz"][7],\dur,2,\amp,6,\rel,0.5,\rate,0.9,\addAction,1).quant_([4,1]).play;
Pbindef(\s).stop;


// facoltativo
Pbindef(\agogo,\instrument,\bplaym,\buf,~dirt["drumtraks"][2],\dur,Pbjorklund2(5,8,inf,0)/4,\amp,0.7,\rel,1,\rate,Pseq([1,1,2,2],inf),\addAction,Pwrand([1,0],[10,1].normalizeSum, inf)).quant_(4).play;
Pbindef(\agogo).stop;

Pbindef(\clap,\instrument,\bplaym,\buf,~dirt["jazz"][4],\dur,2,\amp,2,\rel,0.1,\rate,1,\addAction,1).quant_([4,1]).stop.play;
Pbindef(\clap).stop;




// and now a super saw bass
(
Pbindef(\bass,
	\instrument, \ring1,
	\octave, Prand([[3,4,5]], inf),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree, 0, //Prand([4, 3.1], inf),

	\dur, Pseq([Pn(0.5,7), 0.25, 0.75],inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 0.5,
	\addAction, 1,
	\dist, 5,

	\pan, 0.0, //Pwhite(-1.0, 1.0, inf).clump(1)
).quant_([4,0]).play;
)
Pbindef(\bass).stop;
Pbindef(\bass).clear;







(
SynthDef(\saw, {
	|out=0, amp=1.0, freq=440, pan=0.0, atk=0.01, rel=0.1|
	var env, sig;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = LFSaw.ar(freq).bipolar * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)




// bass with sawtooth
(
Pbindef(\bass,
	//\instrument, \ring1,
	\instrument, \saw,

	\octave, Prand([[3,4]], inf),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\mtranspose, Pseq([[-0.01, 0.01]], inf),
	\degree, 0, //Prand([4, 3.1], inf),

	\dur, Pseq([Pn(0.5,7), 0.25, 0.75],inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.0,
	\rel, 0.2,
	\amp, 0.5,

	\amp, 0.5,
	\pan, Pseq([[-1.0 ,1.0]], inf), //Pwhite(-1.0, 1.0, inf).clump(1)
	\addAction, 1,
).quant_([4,0]).play;
)




// LEAD experiments

// transposing lead
Pbindef(\lead, \degree, 14, \mtranspose, Pseg([0, 0.3, 0],[4,4],\lin, inf), \dur, 0.5, \addAction, 0, \amp, 0.3);
Pbindef(\lead, \amp, 0.3)

(
Pbindef(\lead,
	\instrument, \brinkmann1,
	\octave, Pseq([[5,6]], inf).clump(3),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree,  Pseq([
		Pn(0,6),
		7,
		Pn(0, 5),
		-1
	], inf), //3.1 +4 //Pseq([3.1, 4], inf),-
	\mtranspose, 0, //Pseg([0, 0.3, 0],[4,4],\lin, inf),

	\dur, Pseq([
		Pn(0.5,6),
		1,
		Pn(0.5,5),
		1.5
	], inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\atk, 0.0,
	\rel, 0.1, //Pseq([Pn(0.3,6), 0.5], inf), //Pseg([0.5, 0.1, 0.5],[4,4], \lin, inf),

	\fb, 0.5, //Pseg([0.9, 1.1, 0.9],[4,4], \lin, inf).clump(3), //Pwhite(0.1, 0.9,inf).clump(3),
	\offset, 0.2,
	\dist, 1,

	\amp, 0.7,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pseq([
		Pn(1,6),
		0,
		Pn(1,5),
		1
	], inf),
	\stretch,1,
).quant_([4,0.5]).play;
)


(
Pbindef(\lead,
	\instrument, \saw,
	\octave, Pseq([[5,6]], inf).clump(3),
	\degree,  Pseq([
		Pn(0,6),
		7,
		0, 7, 7, 0
	], inf), //3.1 +4 //Pseq([3.1, 4], inf),-

	\dur, Pseq([
		Pn(0.5,6),
		2,
		Pn(0.5,3),
		1.5
	], inf), //Pseq([Pn(0.5,2), 1,2,7], inf),
	\addAction, Pseq([
		Pn(1,6),
		0,
		1, 1,1, 0
	], inf),
	\dist, 1,//P1seg([10,1],[1],\lin,inf),
	\rel, Pseq([Pn(0.1, 10), 0.15], inf)
).stop.play;
)


// this is an alternative BASS made only of reverb
(
Pbindef(\bass,
	\instrument, \saw,
	\octave, Pseq([[3]], inf).clump(3),
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\degree,  Pseq([0], inf),
	\atk, 0.0,
	\amp, 1,
	\dur, 8,
	\rel, 1,
	\addAction, 0
).quant_([4, 1]).stop.play;
)
Pbindef(\bass).stop;



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
		"pad A4 pressed - agogo-clap ON".postln;
		Pbindef(\agogo).play;
		Pbindef(\clap).play;
	}, {
		"pad A4 released - agogo-clap OFF".postln;
		Pbindef(\agogo).stop;
		Pbindef(\clap).stop;
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
		"pad A7 pressed".postln;
		Pbindef(\caossine).play;
	}, {
		"pad A7 released".postln;
		Pbindef(\caossine).stop;
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



// LATER EXPERIMENTS /////////////////////////////////////////////////////////////////////
(
SynthDef(\saw_adsr, {
	|out=0, amp=1.0, freq=440, pan=0.0, atk=0.01, rel=0.1, dcy=1, gate=1|
	var env, sig;
	env = EnvGen.ar(Env.adsr(atk, dcy, 0.7, rel), gate, doneAction:2);
	sig = LFSaw.ar(freq).bipolar * env * amp;
	//sig = MoogFF.ar(sig, MouseX.kr(200, 5000), MouseY.kr(1, 50));
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)



(
Pbindef(\pads,
	\instrument, \saw_adsr,
	\scale, Pfunc({~scale}),
	\root, Pfunc({~root}),
	\octave, Pseq([[3]],inf),
	\mtranspose, 0.0, //Pwhite(-0.02, 0.02, inf).clump(4),
	\degree, Pseq([[3.1,1],[4,0]],inf),
	\pan, 0.0, //Pwhite(-1.0, 1.0 ,inf),
	\amp, Pgauss(0.3, 0.01, inf) * 0.5,
	\atk, 0.0,
	\rel, 0.1,
	\dur, 8,
	\legato, 0.99,
	\addAction,1
).quant_(4).stop.play;
)
Pbindef(\pads).clear;