s.meter
s.plotTree
s.scope

t = TempoClock.default;
t.tempo = 123/60

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,4, \lpf,1500, \wet,0.1);


(
SynthDef(\fnoise, {
	|out=0, freq=440, rq=0.1, amp=1.0, pan=0.0, l=1,
	atk=1.0, rel=1
	|
	var sig, env;
	//env = EnvGen.ar(Env.triangle(l), doneAction:2);
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Decay2.ar(Dust.ar(1), 0.01, 0.1);
	//sig = sig * BPF.ar(PinkNoise.ar(), freq, rq);
	sig = BPF.ar(PinkNoise.ar(), freq, rq);

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\pads,
	\instrument, \fnoise,
	\scale, Scale.major,
	\root, 0,
	\octave, [3,4,5,6],
	\degree, Pseq([
		Pn([4,4,-1,1], 8), // G
		Pn([5,2,0,2], 8),  // Am
		Pn([3,3,0,-2], 8), // F
		Pn([0,2,0,-3], 8)  // C
	], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\l, 4,
	\atk, 0.01,
	\rel, 4,
	\dur, 0.5,
	\pan, Pwhite(-0.8, 0.8, inf),
	\amp, 10,
	\rq, Pexprand(0.0005, 0.01, inf),
	\addAction,0
).quant_([4,0]).play;
)

(
Pbindef(\pads,
	\instrument, \sinfb_adsr,
	\scale, Scale.major,
	\root, 0,
	\octave, Pseq([4,5,6,7], inf).clump(4),
	\degree, Pseq([
		Pn([4,4,-1,1], 1), // G
		Pn([5,2,0, 2], 1), // Am
		Pn([3,3,0,-2], 1), // F
		Pn([0,2,0,-3], 1)  // C
	], inf),
	\mtranspose, Pwhite( 0.0, 0.02, inf).clump(4),
	\fb, Pwhite(0.2, 0.7, inf).clump(4),
	\atk, 0.0 * t.beatDur,
	\rel, 2 * t.beatDur,
	\dur, 4,
	\pan, Pwhite(-0.8, 0.8, inf).clump(4),
	\amp, Pgauss(0.1, 0.01, inf).clump(4),
	\rq, Pexprand(0.0005, 0.01, inf),
	\addAction,0
).quant_([4,0]).play;
)

Pbindef(\pads).stop;
Pbindef(\pads).clear;


(
~path = PathName(thisProcess.nowExecutingPath.dirname +/+ "mySamples2");
//~loadfunc;
if (~samples.notNil) {
	~samples.do({
		|key|
		if (~samples[key].notNil) {
			~samples[key][\buffers].do({
				| buffer |
				if (buffer.notNil) {
					buffer.free;
				};
			});
		};
	});
};
~samples = ();

// add function to load samples
~loadfunc = {
	// loaded samples will be stored under samples[key]
	|
	key, relpath, namefilter, destination,
	basepath="/home/nicola/Musica/SC_set/mySamples2"
	|
	var path = PathName(basepath +/+ relpath);
	var tmp_buffers = path.entries.removeAllSuchThat({|item| item.fileName.contains(namefilter); });
	var tmp_array = tmp_buffers.collect({
		| item, index |
		var d = ();
		var string = item.fileNameWithoutExtension;
		var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
		var noteNameAll = output[0][1];
		var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
		var noteName = noteNameAll[0].asString;
		var isSharp = noteNameAll.contains("#"); // boolean
		var midiNumber = (octNumber +1) * 12;
		switch( noteName.toLower,
			"c", { midiNumber = midiNumber+0; },
			"d", { midiNumber = midiNumber+2; },
			"e", { midiNumber = midiNumber+4; },
			"f", { midiNumber = midiNumber+5; },
			"g", { midiNumber = midiNumber+7; },
			"a", { midiNumber = midiNumber+9; },
			"b", { midiNumber = midiNumber+11; },
		);
		if (isSharp) {midiNumber = midiNumber + 1;};
		//[noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;//.debug("[fullname, note, sharp, octave, midinum]");
		d[\midi] = midiNumber.asInteger;
		d[\note] = noteNameAll;
		// uncomment the line below if you want to see a more verbose debug
		//d[\buffer] = Buffer.readChannel(s, item.fullPath.debug("reading file"), channels:0);

		d[\buffer] = Buffer.readChannel(s, item.fullPath, channels:0);
		//d;
	});
	key.debug("loading");
	tmp_array.sortBy(\midi);
	destination[key] = ();
	destination[key][\buffers] = tmp_array.collect({|item| item[\buffer]; });
	destination[key][\midinotes] = tmp_array.collect({|item| item[\midi]; });
	destination;
	// TODO: add here a check evaluation function in order to check if the samples array
	// has been succesfully filled or not
	//if( destination[key][\buffers].isEmpty,
	//{"ERROR".postln;}, {}
	//);
};
)


// load all the need secondary samples
//~samples = ~loadfunc.(\violins_1st_sus, "1st Violins", "1st-violins-sus-", ~samples); s.sync;
~samples = ~loadfunc.(\piano,  "pianoteq", "pianoteq-p-", ~samples);
~samples = ~loadfunc.(\carillon,  "carillon", "carillon-", ~samples);

(
Pbindef(\carillon,
	\instrument, \oneshot_player,
	\scale, Scale.major,
	\root, 0,
	\octave, [4,5,6],
	\degree, Pseq([0,2, Pseq([4],1)], inf),

	\index,  Pfunc({ |e| e.use { ~midinote.() }.asArray.collect { |note| ~samples[\carillon][\midinotes].indexIn(note) } }),
	\buf, Pindex(~samples[\carillon][\buffers], Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~samples[\carillon][\midinotes], Pkey(\index))).midiratio,

	\amp, Pgauss(0.15, 0.05, inf),
	\dur, 0.25,
	\atk, 0.01,
	\dcy, 0.1,
	\sus, 1,
	\rel, 0.4,
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\lag, Pwhite(0.0, 0.02, inf),
	\strum, Pwhite(-0.005, 0.005, inf),
	\addAction, 0
).quant_(1).play;
)
Pbindef(\carillon).stop;

s.meter;




/*************************************************/
(
Tdef(\serverVolume, {
	var time = 0.25;
	//var time = 0.875;
	{
		s.volume_(0.0.ampdb);
		time.wait;
		s.volume_(1.5.ampdb);
		time.wait;
	}.loop;
}).quant_(4);
)


Tdef(\serverVolume).play;
Tdef(\serverVolume, {nil});


(
Tdef(\serverVolume).stop;
s.volume_(1.0.ampdb);
)

/*************************************************/

(
Pbindef(\varsaws,
	\instrument, \syncsaw,
	\scale, Scale.major,
	\root, 0,
	\octave, [3,4,5,6],
	\degree, Pseq([
		Pn([4,4,-1,1], 8), // G
		Pn([5,2,0,2],  8), // Am
		Pn([3,3,0,-2], 8), // F
		Pn([0,2,0,-3], 8)  // C
	], inf),
	\mtranspose, Pseg([0,0.07],[2], \lin, inf),
	\atk, 0.01,
	\rel, 0.5,
	\dur, 0.5,
	\sf, 5,
	\pan, Pwhite(-0.8, 0.8, inf).clump(4),
	\amp, 0.07,
	\addAction,0
).quant_([4,0.5]).stop.play;
)

Pbindef(\varsaws).stop;


(
Pbindef(\varsaws,
	\instrument, \syncsaw,
	\scale, Scale.major,
	\root, 0,
	\octave, [4,5,6,7],
	\degree, Pseq([
		Pn([4,4,-1,1], 7), // G
		Pn([5,2,0,2],  7), // Am
		Pn([3,3,0,-2], 7), // F
		Pn([0,2,0,-3], 7)  // C
	], inf),
	\mtranspose, Pseq([
		Pseg([0,0.07],[4], \lin, 1),
		Pn( Pseg([0,0],[4], \lin, 1), 3)
	],inf) * Pwhite(0.0, 1.0, inf),
	\atk, Pseq([ Pn(0.01, 6), 0.05], inf) * t.beatDur,
	\rel, Pseq([ Pn(0.25, 6), 0.75], inf) * t.beatDur,
	\dur, Pseq([ Pn(0.5, 6), 1], inf),
	\sf,  Pseg([10, 30],[4],\lin,inf),
	\pan, Pwhite(-0.8, 0.8, inf).clump(4),
	\amp, 0.4 * Pseg([0.5, 1.0],[4],\exp,inf) ,
	\addAction, Pseq([Pn(1, 6), 0],inf)
).quant_([4,0.5]).stop.play;
)
Pbindef(\varsaws).stop;

(
Pbindef(\varsaws,
	\instrument, \syncsaw,
	\scale, Scale.major,
	\root, 0,
	\octave, [4,5,6,7],
	\degree, Pseq([
		Pn([4,4,-1,1], 8), // G
		Pn([5,2,0,2],  8), // Am
		Pn([3,3,0,-2], 8), // F
		Pn([0,2,0,-3], 8)  // C
	], inf),
	\mtranspose, 0.0,
	\atk, 0.01, //Pseq([ Pn(0.01, 6), 0.05], inf) * t.beatDur,
	\rel, 0.25 * t.beatDur, //Pseq([ Pn(0.25, 6), 0.75], inf) * t.beatDur,
	\dur, 0.5, //Pseq([ Pn(0.5, 6), 1], inf),
	\sf,  30, //Pseg([10, 30],[4],\lin,inf),
	\pan, Pwhite(-0.8, 0.8, inf).clump(4),
	\amp, 0.3, //Pseg([0.5, 1.0],[4],\exp,inf) ,
	\addAction, 1, //Pseq([Pn(1, 6), 0],inf)
).quant_([4,0.5]).stop.play;
Pbindef(\varsaws).play;
)


// DRUMS *******************************************/
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pwrand([1,Pseq([0.5, 0.5], 1)],[10,1].normalizeSum, inf),\amp,1,\rel,0.2,\rate,1,\addAction,1).quant_(4).stop.play;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][2],\dur,0.5,\amp,0.6,\rel,0.2,\rate,1,\addAction,1).quant_([4,1]).stop.play;

// sidestick
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pwrand([2,Pseq([0.5, 1.5], 1), Pseq([0.25, 1.75],1)],[10,3,2].normalizeSum,inf),\amp,Pgauss(1.2, 0.1, inf),\rel,0.2,\rate,0.8,\addAction,1).quant_([4,1]).stop.play;
)


Pbindef(\k,\dur,Pwrand([Pn(1,3), Pseq([0.5, 0.25, 0.25],1)],[4,1].normalizeSum,inf));
Pbindef(\k,\dur,2);
Pbindef(\k,\dur,1); // four on the floor


Pbindef(\s,\dur,Pseq([2],inf)).play;
Pbindef(\s,\dur,Pseq([Pn(2,2), 0.25, 1.75],inf)).play;


Pbindef(\hh,\dur,Pseq([0.5,1.5], inf));



(
Pbindef(\k).stop.play;
Pbindef(\s).stop.play;
Pbindef(\hh).stop.play;
Pbindef(\clap).stop.play;
Pbindef(\tom).stop.play;
)

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][2],\dur,Pseq([Pn(0.5, 15), Pn(0.25,2)],inf),\amp,0.6,\rel,0.2,\rate,1,\addAction,1).quant_([4,1]).stop.play;


Pbindef(\k,\dur,1).play;



// 808 version ************************************************/
~dirt.keys

(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["808bd"][0],\dur,1,\amp,8,\rel,0.1,\rate,1,\addAction,1).quant_(4).stop.play;

Pbindef(\clap, \instrument,\bplaym,\buf,~dirt["bend"][1],\dur,2,\amp,6,\rel,0.1,\rate,3,\addAction,0).quant_([4,1]).stop.play;

Pbindef(\s,
	\instrument,\bplaym,
	\buf, ~dirt["808sd"][3],
	\dur, Pwrand([2, Pseq([1.25, 0.75], 1)],[10,1].normalizeSum,inf),
	\amp,Pgauss(3, 0.1, inf),
	\rel, 0.1, //Prand([0.1, 0.2] ,inf),
	\rate, 1,
	\addAction,1
).quant_([4,1]).stop.play;

Pbindef(\tom,
	\instrument,\bplaym,
	\buf, Pseq([~dirt["808hc"][1], ~dirt["808hc"][0]],inf),
	\dur, Pseq([8],inf),
	\amp,Pgauss(2, 0.1, inf),
	\rel, 1, //Prand([0.1, 0.2] ,inf),
	\rate, 0.7,
	\addAction,0
).quant_([4,0.25]).stop.play;

Pbindef(\hh,\instrument,\bplaym,\buf,Pseq([Pn(~dirt["808oh"][1],1), Pn(~dirt["808oh"][0],3)],inf),\dur,0.5,\amp,0.6,\rel,0.1,\rate,1,\addAction,1).quant_([4,0.5]).stop.play;
)

(
Pbindef(\bass,
	\instrument, \brinkmann1,
	\octave, [3,4],
	\degree, Pseq([Pn(0,7),7,0],inf),
	\offset, 0.0,
	\dist, 10,
	\fb, 0.0,
	\amp, 0.15,
	\dur, Pseq([2,2,2,2,2,3,0.5,0.5,2], inf),
	\atk, 0.0,
	\rel, 0.3,
	\pan, 0.0,
	\addAction, 1
).quant_([4,0.5]).stop.play;
)
Pbindef(\bass).stop;


(
Pbindef(\stab,
	\instrument, \fm4_perc,
	\octave, [5,6],
	\degree, Pseq([0],inf),
	\amp, [1, 0.3]*0.3,
	\dur, 16,
	\n1, 2, \n2, 16, \mi, 1000,
	\iatk, 0.2, \irel, 0.3, \iAdd, 5,
	\atk, 0.1,
	\rel, 2,
	\pan, 0.0, //Pseq([1.0, -1.0, 1.0],inf).clump(2),
	\addAction,0
).quant_([4,3]).play;
)

(
Pbindef(\stab,
	\instrument, \sinfb,
	\octave, [5,6],
	\degree, Pseq([0],inf),
	\fb, 0.7,
	\amp, [1, 0.3]*0.4,
	\dur, 16,
	\atk, 0.0,
	\rel, 0.4,
	\pan, 0.0, //Pseq([1.0, -1.0, 1.0],inf).clump(2),
	\addAction,0
).quant_([4,3]).play;
)
Pbindef(\stab).stop;


Pbindef.gui


// midi controller

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
	}, {
		"pad A3 released".postln;
		Pbindef(\hh).stop;
	});
},22);

~padA4.free;
~padA4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
	if( args[0] > 0, {
		"pad A4 pressed".postln;
		Pbindef(\clap).play;
		Pbindef(\tom).play;
	}, {
		"pad A4 released".postln;
		Pbindef(\clap).stop;
		Pbindef(\tom).stop;
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
		Pbindef(\pads).play;

	}, {
		"pad A6 released".postln;
		Pbindef(\pads).stop;

	});
},25);

~padA7.free;
~padA7 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A7 pressed".postln;
		Pbindef(\stab).play;
		Pbindef(\carillon).play;

	}, {
		"pad A7 released".postln;
		Pbindef(\stab).stop;
		Pbindef(\carillon).stop;

	});
},26);

~padA8.free;
~padA8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad A8 pressed".postln;
		Pbindef(\varsaws).play;

	}, {
		"pad A8 released".postln;
		Pbindef(\varsaws).stop;
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
		Pbindef(\noises).play;
	}, {
		"pad B7 released".postln;
		Pbindef(\noises).stop;
	});
},34);

~padB8.free;
~padB8 = MIDIFunc.cc({
	arg ...args;
	args.postln;

	if( args[0] > 0, {
		"pad B8 pressed".postln;
		Pbindef(\alert).play;
		Pbindef(\invaders).play;

	}, {
		"pad B8 released".postln;
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

