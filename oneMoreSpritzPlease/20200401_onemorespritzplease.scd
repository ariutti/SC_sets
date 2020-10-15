t = TempoClock.default;
t.tempo_(60/60);
Pbindef.gui;

~tonica = 0;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);



// CHORD CHANGER //////////////////////////////////////////////////////////////////////////
(
Tdef(\tonicachange, {
	var seq  = Pseq([0, -2, 3, 4], inf).asStream;
	var time = Pseq([8, 8, 4, 4], inf).asStream;
	{
		~tonica = seq.next;
		~tonica.postln;
		time.next.wait;
	}.loop;
}).quant_([4,0]).stop.play;
)

(
Tdef(\tonicachange).stop;
~tonica = 0;
)

// BASS ///////////////////////////////////////////////////////////////////////////////////
(
Pbindef(\bass,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [3,4], //Prand([4,5,6],inf),
	\degree, Pfunc({~tonica}),
	\fb, Pgauss(0.9, 0.1, inf),

	\amp, 1,
	\atk, 0.0,
	\rel, 0.2,
	\dur, 0.25,
	\pan, Pwhite(-0.2 ,0.2, inf),
	\addAction,1
).quant_([4,0]).play;
)
Pbindef(\bass).stop;


// PADS ///////////////////////////////////////////////////////////////////////////////////
(
SynthDef(\varsaw, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,width=0.01|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = VarSaw.ar(freq, width:width) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\sin, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\square, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0, fc=1000|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = Pulse.ar(freq, mul:SinOsc.kr(LFNoise2.kr(1).range(4,6)).range(0.3, 1.0)) * env * amp;
	sig = LPF.ar(sig, fc);
	sig = (sig * 2).tanh * 0.5 ;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\pads,
	\instrument, \square,
	\scale, Scale.major,
	\octave, Prand([4,6],inf).clump(2),
	\degree, Pfunc({~tonica}) + Pseq([[2,4]],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\width, Pseg([0.5, 0.01, 0.5], [4], \exp, inf),
	\fc, Pseg([1000, 6000, 1000], [4], \exp, inf),
	\amp, Pgauss(0.1, 0.01, inf).clump(4),
	\atk, 1,
	\rel, 4,
	\dur, 0.5,
	\pan, Pwhite(-1.0 ,1.0, inf).clump(2),
	\addAction,0
).quant_([4,0,0.1]).play;
)
Pbindef(\pads).stop;

// DRUMS //////////////////////////////////////////////////////////////////////////////////


(
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,4,\amp,3,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pwrand([2,Pseq([0.125,0.125+0.25+0.5+1],1)],[10,1].normalizeSum, inf) ,\amp,1,\rel,0.1,\rate,0.4,\addAction,0).quant_([4,1]).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["808sd"][9],\dur,1 /*Pwrand([2,Pseq([0.125,0.125+0.25+0.5+1],1)],[10,1].normalizeSum, inf)*/,\amp,2,\rel,1,\rate,1,\addAction,1).quant_([1,1]).stop;
)


/* ALTERNATE DRUMS */

(
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,0.5,\amp,3,\rel,0.1,\rate,0.7,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pwrand([2,Pseq([0.125,0.125+0.25+0.5+1],1)],[10,1].normalizeSum, inf) ,\amp,1,\rel,0.1,\rate,0.4,\addAction,0).quant_([4,1]).play;
Pbindef(\s808,\instrument,\bplaym,\buf,d["808sd"][9],\dur,1 /*Pwrand([2,Pseq([0.125,0.125+0.25+0.5+1],1)],[10,1].normalizeSum, inf)*/,\amp,2,\rel,1,\rate,1,\addAction,0).quant_([1,0.25]).stop;
)

(
//aggressive
Pbindef(\k,
	\instrument, \kickFm,
	\freq, (48-12).midicps,
	\dur, 0.5,
	\atk, 0.003, \rel, 0.25,
	\fatk, 0.001,\frel, 0.05, \fenvamt, 100,
	\fm, 1000,
	\mi, 500,
	\matk, 0.001, \mrel, 0.01,
	\dist, 4,
	\amp, 3,
    \addAction, 1
).quant_([4]).stop.play;
)
Pbindef(\k).stop;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][0],\dur,1,\amp,2,\rel,0.1,\rate,0.4,\addAction,1).quant_([4,0.5]).stop.play;
);


// LEADS //////////////////////////////////////////////////////////////////////////////////

(
Pbindef(\lead,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [5,7],
	\degree, Pseq([0,1,2,0,1,2,4],inf),
	\width, Pwhite(0.01, 0.5, inf),
	\fb, [0.6,0.9] * Pseg([0.6,1.0,0.6], [2,2], \lin, inf),
	\amp, 0.5,
	\atk, 0.01,
	\rel, [1,2],
	\dur, Pseq([1,1,2,1,1,1,1],inf),
	\pan, Pseries(0.0, 0.2, inf).fold(-1.0, 1.0),
	\addAction,0
).quant_([4,0]).play;
)

(
// lead offtempo
Pbindef(\lead2,
	\instrument, \fm2,
	\scale, Scale.major,
	\octave, 5,
	\degree, Pseq([0],inf),
	\width, Pwhite(0.01, 0.5, inf),
	\mr, 16,
	\mi, 400,
	\amp, 4,
	\atk, 0.01,
	\rel, 0.5,
	\dur, Pseq([1,1,1,1,1,1,1],inf),
	\pan, Pseries(0.0, -0.2, inf).fold(-1.0, 1.0),
	\addAction,1
).quant_([4,0.5]).play;
)
Pbindef(\lead).stop;
Pbindef(\lead2).stop;

// CHOIR //////////////////////////////////////////////////////////////////////////////////

(
Pbindef(\choir,
	\instrument, \speak,
	\scale, Scale.major,
	\octave, [3,4,5],
	\degree, Pfunc({~tonica}) + [0,2,4], //Pstutter(4, Pseq([[0,2,4], [-1,1,4], [-1,1,3], [0,3,5], [0,2,4]], inf)), //Pwrand([0,-1],[10,2].normalizeSum, inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\atk, 2,
	\rel, 6,
	\va, Pwrand([\a,\e],[10,10].normalizeSum, inf),
	//\vb, Pseq([\bass, \soprano, \counterTenor, \alto], inf),
	//\vb, Prand([\bass, \tenor, \alto], inf),
	\vb, \bass,

	\freqs,  Pfunc({|env| `[ Vowel(  env.use({~va}), env.use({~vb})).asKeyValuePairs.at(1) ] }),
	\widths, Pfunc({|env| `[ Vowel(  env.use({~va}), env.use({~vb})).asKeyValuePairs.at(3) ] }),
	\dBs,    Pfunc({|env| `[ Vowel(  env.use({~va}), env.use({~vb})).asKeyValuePairs.at(5) ] }),

	\amp, Pgauss(0.1, 0.01, inf).clump(3),
	\dur, 4,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Prand([0,1], inf).clump(3)
).quant_(4).play;
)
Pbindef(\choir).play;
Pbindef(\choir).stop;




// prosegui da qui
(
Pbindef(\lead,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [4,5,7],
	\degree, Pseq([7,6,2,5,4,1,2],inf),//Pseq([0,1,2,0,1,2,4],inf),
	\width, Pwhite(0.01, 0.5, inf),
	\fb, [0.6,0.9],
	\amp, 0.3,
	\atk, 0.01,
	\rel, [1,2],
	\dur, Pseq([2,1,1,2], inf),//Pseq([1,1,2,1,1,1,1],inf),
	\pan, Pseries(0.0, 0.2, inf).fold(-1.0, 1.0),
	\addAction,0
).quant_([4,0]).play;


Tdef(\tonicachange, {
	var seq  = Pseq([-2, 3, 4], inf).asStream;
	var time = Pseq([4, 4, 4], inf).asStream;
	{
		~tonica = seq.next;
		~tonica.postln;
		time.next.wait;
	}.loop;
}).quant_([4,0]).stop.play;
)


Pbindef(\lead,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [5,7],
	\degree, Pseq([7,6,2,5],inf),//Pseq([0,1,2,0,1,2,4],inf),
	\width, Pwhite(0.01, 0.5, inf),
	\fb, [0.6,0.9],
	\amp, 0.5,
	\atk, 0.01,
	\rel, [1,2],
	\dur, Pseq([2,1,1,2], inf),//Pseq([1,1,2,1,1,1,1],inf),
	\pan, Pseries(0.0, 0.2, inf).fold(-1.0, 1.0),
	\addAction,0
).quant_([4,0]).play;
Pbindef(\lead).stop;
