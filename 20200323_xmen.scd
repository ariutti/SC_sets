t = TempoClock.default;
t.tempo_(120/60);

~fundamental = nil;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,8, \lpf,1500, \wet,1.0);

Pbindef.gui;


// PADS & BASS //////////////////////////////////////////////////////////////
// Pads depend on bass to choose what shord to play
// becasue the bass is also updateing the ~fundamental
// with the help of the quant TimingOffset



(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0, atk=1, rel=1, cutfreq=1000
	|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
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

Pbindef(\pads,\cutfreq, 2000);
(
Pbindef(\pads,
	\instrument, \dist,
	\scale, Scale.minor,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, 4,
	\degree, Pfunc({~fundamental}) + [0,1,4,9],
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.7, 0.01, inf).clump(6),
	\atk, 0.05,
	\rel, 0.01,
	\dur, 0.5,
	\cutfreq, Pseries(200, 50, inf).fold(200, 6000),
	\addAction,0
).quant_(4).play;
)
Pbindef(\pads).stop;

(
Pbindef(\bass,
	\instrument, \fm_bass1,
	\octave, 4,
	\scale, Scale.minor,
	\degree, Pstutter(Pseq([4,2,2,4,2,2,4,2,2],inf).asStream,Pseq([0,-2,-1,0,2,-1,-2,-2,-1], inf)).collect({|item| ~fundamental = item}),
	//\detune, Pwhite(0, 1),
	\mIdx, 400, //Pseries(0, 100, inf).trace, //Pwhite(0, 400, inf),
	\mRatio, 4, //Prand([0.125, 0.25, 0.5, 2, 4, 8], inf),
	\dur, Pseq([1], inf),
	\atk, Pkey(\dur)*0.01,
	\rel, Pkey(\dur)*1,
    \iatk, Pkey(\atk)*0.01,
	\irel, Pkey(\rel)*0.5,
	\amp, Pwhite(1, 0.8, inf),
	\addAction, 1
).quant_([4,0,0.01]).stop.play;
)

// ALTERNATE BASS /////////////////////////////////////////////////////////////////////
(
Pbindef(\blink).stop;
Pbindef(\scale).stop;
Pbindef(\scale1).stop;
Pbindef(\bass,
	\instrument, \dfm1,
	\scale, Scale.minor,
	\octave, 3,
	\amp, 2,
	\atk, 0.01,
	\rel, 2,
	\degree, Pseq([0,-1,Pn(-2,2)], inf).collect({|item| ~fundamental = item}),
	\dur, 4
).quant_([4,0,0.01]).play;
)
Pbindef(\bass).stop;


// DRUMS ////////////////////////////////////////////////////////////////////

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,4,\rel,0.2,\rate,0.6,\addAction,1).quant_(4).stop.play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][0],\dur,Pbjorklund2(3,8,inf,Prand([2,3],inf).asStream)/4,\amp,0.5,\rel,0.2,\rate,0.8,\addAction,1).quant_([4,1]).play;
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)*0.7).quant_(4).play;

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)

// MELODIES /////////////////////////////////////////////////////////////////

(
SynthDef(\sin, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\blink,
	\instrument, \sin,
	\scale, Scale.minor,
	\octave, Prand([5,6,8],inf),
	\amp, 0.5,
	\atk, 0.01,
	\rel, 0.3,
	\degree, Pseq([0,7,0],inf),
	\dur, Pseq([0.5, 0.5, 1],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\fb, Pgauss(0.1, 0.001, inf)
).quant_(4).play;

Pbindef(\scale,
	\instrument, \sin,
	\scale, Scale.minor,
	\octave, Prand([7,6],inf),
	\amp, 0.4,
	\atk, 0.1,
	\rel, 0.2,
	\degree, Pseq([6,6,5,4,2],inf),
	\dur, Pseq([Pn(0.5,4), 6],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\fb, Pgauss(0.6, 0.01, inf)
).quant_([4,2]).stop.play;

Pbindef(\scale1,
	\instrument, \sin,
	\scale, Scale.minor,
	\octave, Prand([5],inf),
	\amp, 0.7,
	\atk, 0.01,
	\rel, 0.2,
	\degree, Pseq([0,2,0,2,0],inf),
	\dur, Pseq([Pn(0.5,4), 6],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\fb, Pgauss(0.9, 0.1, inf)
).quant_([4,1.5]).stop.play;
)



// GESTURES //////////////////////////////////////////////////////////////////////////

(
Pbindef(\bass).stop;
Pbindef(\k).stop;Pbindef(\s).stop;Pbindef(\hh).stop;
Pbindef(\blink).stop;
Pbindef(\scale).stop;
Pbindef(\scale1).stop;
Pbindef(\pads,
	\instrument, \dist,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, 3,
	\degree, Pseq([
		[ 0,4,8, 9,13,18 ],
		[ 0,3,7,12,14,18 ],
		[-2,2,6, 7,11,15 ]
	], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.3, 0.01, inf).clump(6),
	\atk, 5,
	\rel, 5,
	\dur, 10,
	\addAction,0
).quant_(4).play;
)
Pbindef(\pads).stop;