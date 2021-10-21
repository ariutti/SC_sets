// use the electri counterpoint
~scale = Scale.major;
t = TempoClock.default;
t.tempo_(96/60);
~root = 0;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,0.0);
~verb.free;

Pbindef.gui
s.meter


// first of all start with finding a repating melody
// a la steve reich
(
SynthDef(\mySin, {
	|out=0, pan=0, amp=1.0, freq=440, atk=0.01, rel=1.0|
	var sig, env;
	//sig = LFPulse.ar(freq + SinOsc.ar(6, mul:10)).bipolar * 0.3;
	//sig = LFTri.ar(freq + SinOsc.ar(30, mul:10)).bipolar * 2; // change vibrato to fb
	sig = SinOsc.ar(freq);
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	//sig = RLPF.ar(sig, freq*5, 1);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


(
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

)



(
Pbindef(\mySin1,
	\instrument, \mySin,
	\root, Pfunc({ ~root }),
	\scale, Pfunc({ ~scale }),
	\octave, 6,
	\degree, Pseq( Pfunc({~lickA}).asArray.flatten , inf),
	\dur, Pseq( Pfunc({~dursA}).asArray.flatten , inf),
	\atk, 0.01,
	\rel, 0.4,
	\amp, Pseq( Pfunc({~accentsA}).asArray.flatten , inf) * 0.25,
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
	\atk, 0.01,
	\rel, 0.4,
	\amp, Pseq( Pfunc({~accentsA.rotate(-1)}).asArray.flatten, inf) * 0.25,
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
	\atk, 0.01,
	\rel, 0.4,
	\amp, Pseq( Pfunc({~accentsA.rotate(-2)}).asArray.flatten, inf) * 0.25,
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
	\atk, 0.01,
	\rel, 0.4,
	\amp, Pseq( Pfunc({~accentsA.rotate(-3)}).asArray.flatten, inf) * 0.25,
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
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,1,\amp,8,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;


// hh in levare
// snare con rimshot
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["drumtraks"][6],\dur,1,\amp,8,\rel,8,\rate,1,\addAction,1, \lag,Pwhite(0.0, 0.02, inf), \stretch, 1).quant_(4).play;

Pbindef(\s,\instrument,\bplaym,\buf,~dirt["drumtraks"][8],\dur,Pwrand([2, Pseq([0.25,1.75],1)],[4,1].normalizeSum,inf),\amp,2,\atk,0.0,\rel,5,\rate,1,\addAction,1,\lag,0.0, \stretch, 1).quant_([4,1]).stop.play;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["drumtraks"][4],\dur,1,\amp,1,\atk,0.0,\rel,0.1,\rate,1,\addAction,1,\lag,0.0, \stretch, 1).quant_([4,0.5]).stop.play;
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
	\amp, 1,

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
	\amp, 1,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\degree, Pseq([Pn(0, 4*4*2), Pn(3,8), Pn(4,8)],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),
	\octave, Prand([[3,4]], inf),

	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.1,
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
	\amp, 1,

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
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\fb, 0.9, //Pseg([0.5, 2.5, 0.5], [8,8], \lin, inf),
	\root, 0,
	\amp, 1,

	//\octave, Prand([3,4,5], inf),
	//\degree, Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\degree, Pseq([
		Pn(0, 8), Pn(3,4), Pn(4,4), // C | C | F | G
		Pn(0, 14), 0, -1,  Pn(-2,4), Pn(-3,4), // C | C | Am | G
		Pn(0, 8), Pn(3,4), Pn(4,4), // C | C | F | G
		Pn(5, 8), Pn(3,4), Pn(4,4)  //
	],inf), //Prand([0,0,-1,0,4, 0,0,-7,0], inf),

	\octave, Prand([[3,4]], inf),

	\rate, 1, //Prand([0.2, 0.6], inf),
	\dur, 0.5, //Pseq([Pn(0.25, 2), 0.5], inf), //Pseq([0.25, 0.25, 0.25, 3.75, 0.25, 0.25, 0.25, 2.75], inf), //Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.1,
	\addAction, 1,
	\stretch, 1
).quant_([4, 0]).play;
)