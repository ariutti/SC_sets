// triphop
// Dm


TempoClock.default.tempo_(120/60);


(
~filter_lofreq = 300;
~filter_hifreq = 500;
)

// Dm


// time to add some rythm
(
Pbindef(\loop,
	\instrument, \sliceplayer,
	\loopbuf, d["loops"][0],
	\loopbars, 1,
	\loopbpm, 136,
	\currentBpm, Pfunc({TempoClock.default.tempo}),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 1,
	\start, 0.0,
	\dur, 4,
	\addAction, 1
).quant_([4,0]).stop.play;
)

Pbindef(\loop,\amp, 0.4)
Pbindef(\loop).play;
Pbindef(\loop).stop;
Pbindef(\lool).clear;

//Pbindef(\loop, \loopbuf, d["loops"][2], \loopbars, 4,\loopbpm, 175 * 0.5); //dnb
Pbindef(\loop, \loopbuf, d["loops"][0], \loopbars, 1, \loopbpm, 136);


Pbindef(\loop, \sr, 4000, \bits, 5, \amp, 1); // decimator on
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 1); // decimator off

Pbindef(\loop, \hf, Pfunc({~filter_hifreq}), \lf, Pfunc({~filter_lofreq}), \amp, 1.2); // filter on
Pbindef(\loop, \hf,20000,\lf,0, \amp, 1);  // filter off

// !!!!!
Pbindef(\loop, \sr, 44100, \bits, 16, \hf,20000,\lf,300, \amp, 1,\start, 0.0, \dur, 4).reset.play; // normal, decimator & filter off

(
Pbindef(\loop, \pan, 0.0); // reset pan
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 1); // decimator setup
Pbindef(\loop, \start,0.0, \dur, 4, \amp, 1);
Pbindef(\loop, \hf,20000, \lf,0);  // remove filter
)



Pbindef(\loop, \start,0.0, \dur, 0.5, \amp, 1); // kick
Pbindef(\loop, \start,0.0, \dur, 1, \amp, 1); // kick & snare - grezzo
Pbindef(\loop, \start,0.25, \dur, 1, \amp, Pseq([1,0],inf));

Pbindef(\loop, \start,0.25 * 0.125, \dur, 0.25, \amp, 1); // snare
Pbindef(\loop, \start,Pseq([0.0, 0.0, 0.25*0.125],inf), \dur, 0.25); // k + sn
Pbindef(\loop, \start, 0.75, \dur, 0.125*0.25, \amp, 0.25); // errrrrr
Pbindef(\loop, \start, Pwhite(0.0, 0.75).round(0.25), \dur, 0.25*0.5); //pure random
Pbindef(\loop, \start, Prand([0, 0.125, 0.25, 0.5, 0.625, 0.75] * 0.25, inf), \dur, Prand([0.25, 0.5], inf), \amp, 1) // break core
Pbindef(\loop).reset.play; //\start, Prand([0, 0.125, 0.25, 0.5, 0.625, 0.75] * 0.25, inf), \dur, Prand([0.25, 0.5], inf), \amp, 1) // break core




Pbindef(\speakSpell,\instrument,\bplaym,\buf,Pindex(d["speakspell_letters"], Prand((0..d["speakspell_letters"].size),inf), inf),\dur,4,\amp,1,\addAction,0,\pan, Pwhite(-1.0, 1.0, inf)).quant_(4);
Pbindef(\speakSpell).stop;
Pbindef(\speakSpell).play;





//////////////////////////////////////////////////////////////////////////////////////////

Pbindef.gui;

(
Pbindef(\A).stop;
Pbindef(\B).stop;
Pbindef(\chirp).stop;
Pbindef(\hi).stop;
Pbindef(\hh).stop;
Pbindef(\lo).stop;
)


[Pbindef(\A), Pbindef(\B), Pbindef(\chirp), Pbindef(\hi),Pbindef(\lo),Pbindef(\hh)].do({|item| item.play;});


Pbindef(\loop).play;
Pbindef(\loop).stop;
Pbindef(\lool).clear;


// STOP
(
Pbindef(\bells).stop;
Pbindef(\loop , \start,Prand([0, 0.125, 0.25, 0.5, 0.625, 0.75] * 0.25,inf), \dur, Prand([0.25, 0.5], inf));
//Pbindef(\loop, \start, Pwhite(0.0, 0.75).round(0.25), \dur, 0.25*0.5);
Pbindef(\bass).stop;
)


// GO!!!!
(
Pbindef(\loop).play;
Pbindef(\loop, \hf,20000,\lf,0);  // remove filter
Pbindef(\loop, \pan, 0.0); // reset pan
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 0.3); // decimator setup
Pbindef(\loop, \start,0.0, \dur, 4, \amp, 0.3);Pbindef(\amen, \hf,20000, \lf,0);  // remove
Pbindef(\bass).quant_(4).stop.play;
Pbindef(\bells).quant_(4).stop.play;
Pbindef(\sn).play;
)

s.plotTree


// bells with ringsaw
(
Pbindef(\loop).stop;
Pbindef(\bells,
	\instrument, \fm2,
	\amp, Pseries(1, 1, inf).fold(1,9) / 30 * 1.0,
	\atk, 0.01,
	\rel, 0.25, //Pwhite(1, 8, inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\scale, Scale.minor,
	\octave, Pwrand([5,6], [5,0.2].normalizeSum, inf),
	\root, 2,
	\degree, 0 + [0,2,4], //Pseq([0,Prand([2,4,7],3)],inf).collect({|note| [note, note+[3,4].choose() ]}),
	\dur, Pwrand([0.25], [10].normalizeSum,inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\mr, 10, //Pseries(1, 1, inf).wrap(1, 8), //Prand([0.5, 1,2],inf),
	\mi, 100,
	\width, 0.01, //Pwhite(0.1, 0.5, inf),
	\addAction, 0
).quant_(1).play;
)
(
Pbindef(\speakSpell, \addAction, 1).stop
)

(
Pbindef(\k,\dur, Pbjorklund2(3,4,inf)/4).stop;
Pbindef(\s).stop;
)
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,8,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,Pseq([1, Pseq([2], inf)], inf),\amp,0.7,\addAction,1,\rate,0.8,\rel,0.1).quant_(4).play;
)
Pbindef(\bells).play;
Pbindef(\bells).stop;


~verb.set(\dec,0.6, \lpf,1500, \wet,1.0);



Pbindef.gui;

// try with fm2
(
Pbindef(\bells,
	\instrument, \fm2,
	\amp, Pseries(1, 1, inf).fold(1,9) / 30 * 0.5,
	\atk, 0.0,
	\rel, Pwhite(0.01, 0.5, inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\scale, Scale.minor,
	\octave, Prand([5,6], inf),
	\degree, 0, //Pseq([0,Prand([2,4,7],3)],inf).collect({|note| [note, note+[3,4].choose() ]}),
	\dur, Pwrand([0.25, Pn(0.125, 2)],[10,1].normalizeSum, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\mr, Pseries(1, 1, inf).wrap(1, 8), //Prand([0.5, 1,2],inf),
	\mi, 1000,
	\addAction, 1
).quant_(4)
)

(
SynthDef(\ringsaw1,{
	|
	freq=45, pan=0, amp=1, out=0,
	atk=0.001, rel=0.1, dist=1.0, width=0.5
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	//env = Line.kr(0,1,rel);
	//env = FreeSelfWhenDone.kr(env);
	sig = VarSaw.ar(freq, width:width, mul:dist).tanh;
	sig = sig * amp * env;
	Out.ar(out,Pan2.ar(sig.tanh,pan));
	};
).add;
);


(
Pbindef(\bells).stop;
Pbindef(\loop).stop;
Pbindef(\k).stop;
Pbindef(\sn).stop;
)

(
Pbindef(\bells).play;
Pbindef(\loop).play;
)

s.plotTree



// bass:
(
//TempoClock.default.tempo_(120/60);
Pbindef(\bass,
	\instrument, \ringsaw1,
	\scale, Scale.minor,
	\root, 2,
	\dist, 10, //Pseg([10,60], [4], inf), //Pseries(1, 1).fold(1, 5),
	\amp, [0.7, 0.5, 0.2] * 1,
	\mtranspose, Pwhite(0.01, -0.01, inf).clump(3),
	\atk, 0.01,
	\rel, 0.3,
	\octave, [3,4,5],
	\degree, 0 + Pwrand([0, Pn(7,2)], [15,1].normalizeSum,inf),
    \dur, 0.5,
	\pan, 0, //Pwhite(-1.0, 1.0, inf).clump(3),
	\width, 0.02,
	\addAction, 0
).quant_(4).play;
)
Pbindef(\bass).play;
Pbindef(\bass).stop;
Pbindef(\bass, \degree, -0+Pwrand([0, Pn(7,2)], [15,1].normalizeSum,inf)); //-4 , -3
Pbindef(\bass,\addAction, Pwrand([1,0],[10,1].normalizeSum, inf)).play;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);
~verb.set(\wet, 1.0);




Pbindef(\speakSpell,\instrument,\bplaym,\buf,Pindex(d["speakspell_letters"], Prand((0..d["speakspell_letters"].size),inf), inf),\dur,4,\amp,1,\addAction,0,\pan, Pwhite(-1.0, 1.0, inf)).quant_([4,1]).stop.play;
Pbindef(\speakSpell).stop;
Pbindef(\speakSpell).play;

// time for a sigarette ahahaha


Pbindef(\loop).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,4,\amp,1,\rel,0.25,\rate,0.8,\addAction,1).quant_(4).play;
Pbindef(\k).stop;

Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],\dur,(Pn(0.5,1) ++ Pseq([1],inf))*0.7,\amp,Pn(\rest,1)++Pseq([0.4 * 1],inf),\addAction,1,\rel,0.1,\rate, 0.6).quant_(4).stop.play;

(
Pbindef(\loop).stop;
Pbindef(\bass,\rel, 1);
Pbindef(\k).quant_(4).stop;
Pbindef(\sn).quant_(4).stop;
)


(
Pbindef(\k,\amp,1);
Pbindef(\sn,\amp,1);
)

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,Pseq([Pn(0.125, 4),3],inf),\amp,Pexprand(0.05,1)*2,\rel,0.1,\rate, 3,\addAction,Prand([0,1],inf)).quant_(4).play;

Pbindef(\hh).stop;
(
Pbindef(\loop).play;
Pbindef(\bass,\rel, 0.25,\amp,[0.7, 0.5, 0.2] * 0.5);
Pbindef(\k,\dur, 0.5).quant_(4).play;
Pbindef(\sn).quant_(4).play;
)


(
SynthDef(\ring1,{
	|
	freq=45, pan=0, amp=1, out=0,
	atk=0.001, rel=0.1, dist=1.0
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Ringz.ar( Impulse.ar(0) ,freq,rel, dist).tanh;
	sig = sig * amp * env;
	Out.ar(out,Pan2.ar(sig,pan));
	}, metadata: (
	credit: "by Nicola Ariutti 2020-03-21",
	tags: [\bass, \pads, \lead]
	)
).add;
);


// speak and spell
(
~word = "iloveyou";
~alphabet = "abcdefghijklmnopqrstuvwxyz".asList;
~word = ~word.toLower.asList.collect({|letter| ~alphabet.indexOf( letter )});

Pbindef(\speakSpell,\instrument,\bplaym,\buf,Pindex(d["speakspell_letters"], Pseq(~word, inf), inf),\dur,4,\amp,0.3,\addAction,0,\pan, Pwhite(-1.0, 1.0, inf),\rate,1).quant_(4);
)

"espeak -v it \"benvenuti in questa bella serata\"".unixCmd;




(
~padA1.free;
~padA1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A1 pressed - loop ON".postln;
		Pbindef(\loop).play;
	}, {
		"pad A1 released - loop OFF".postln;
		Pbindef(\loop).stop;

	});
},20);

~padA2.free;
~padA2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A2 pressed - decimator ON".postln;
		Pbindef(\loop, \sr, 4000, \bits, 5, \amp, 1); // decimator on

	}, {
		"pad A2 released - decimator OFF".postln;
		Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 1); // decimator off

	});
},21);


~padA3.free;
~padA3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A3 pressed - filter ON".postln;
		Pbindef(\loop, \hf,3000, \lf,300, \amp, 1.2); // filter on

	}, {
		"pad A3 released - filter OFF".postln;
		Pbindef(\loop, \hf,20000,\lf,0, \amp, 1);  // filter off
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed".postln;
	}, {
		"pad A4 released".postln;
	});
},23);

~padA5.free;
~padA5 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A5 pressed".postln;
	}, {
		"pad A5 released".postln;
	});
},24);


~padA6.free;
~padA6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A6 pressed".postln;
	}, {
		"pad A6 released".postln;
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
		"pad A8 pressed".postln;
	}, {
		"pad A8 released".postln;
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
	~filter_hifreq = args[0].linlin(0, 127, 5000, 20000);
	("hifreq " ++ ~filter_hifreq.round(0.001)).postln;
	Pbindef(\loop, \hf, ~filter_hifreq, \lf,~filter_lofreq, \amp, 1.2); // filter on
},5);

~k6.free;
~k6 = MIDIFunc.cc({
	arg ...args;
	~filter_lofreq = args[0].linlin(0, 127, 300, 4500);
	("lofreq " ++ ~filter_lofreq.round(0.001)).postln;
	Pbindef(\loop, \hf,~filter_hifreq, \lf,~filter_lofreq, \amp, 1.2); // filter on

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
