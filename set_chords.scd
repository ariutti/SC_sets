// rythm calm
// intersting pads
// and chords progression

"mySetup/mySetup.scd".loadRelative;

p.clock.tempo = 90/60;

(
SynthDef(\whistle, {
	|out=0, freq=440, amp=1.0, pan=0.0
	atk=0.001, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


// experimental pad
(
SynthDef(\saw, {
	|
	out=0, freq=440, amp=1,
	rythm=1
	atk=0.001, rel=1
	|
	var sig, env, det, dynAmp, dynPan;
	det = freq.cpsmidi * 0.01;
	dynAmp = freq.explin(48.midicps, 84.midicps, 1.0, 0.25);
	dynPan = freq.explin(48.midicps, 84.midicps, 0, 1.0);
	env = EnvGen.ar(Env.perc(atk,rel), 1, doneAction:2);
	sig = LFSaw.ar(freq + SinOsc.ar(LFNoise1.kr(1).range(0.25, 0.8)).range(-1 * det, det), Rand(0.0, 2.0));
	sig = RLPF.ar(sig, LFSaw.kr(p.clock.tempo * rythm, 1).range(freq*1, freq*4), 0.07);
	sig = (sig * env * amp * dynAmp);
	Out.ar(out, Pan2.ar(sig, dynPan * LFNoise1.kr(0.1)));
}).add;
)

// PADS with changing chord progression
(
~a = Pbind(
	\instrument, \saw,
	\scale, Scale.chromatic,
	// give a different octave trasposition for each one of the three notes
	\octave, Pseq([[3, 4, 5]], inf),
	// put a wrap to contains notes inside a chromatic octave
	\degree, Pseq([\E, \A, \B, \Csminor].chordProg.wrap(0, 11), inf),
	\rythm, 0.666,
	\dur, Pseq([6, 2, 6, 2], inf),
	\amp, 0.25,
	\atk, 0.01 * Pkey(\dur),
	\rel, 0.99 * Pkey(\dur),
	\pan, Pwhite(-1.0, 1.0, inf)
);
)
~a.set(\rythm, 0.66)
~a.play;

// plin, plin, plin
(
~b = Pbind(
	\instrument, \whistle,
	//\midinote, 60+24,
	\octave, Pwhite(6, 8,inf),
	\scale, Scale.chromatic,
	\degree, 4,
	\dur, 0.25,
	\atk, 0.01,
	\rel, 0.01,
	\amp, 0.25,
	\pan, Pwhite(-1.0, 1.0 ,inf),
	\type, Pseq([Pser([\note], Pwhite(2, 5,inf)), \rest], inf)
	//\dur, 1
);
)
~b.play;

(
~a.stop;
~b.stop;
~verb.stop;
)

// add some magic verb
~verb = {GVerb.ar( ~a*0.3 + ~b*0.5, 100, 3)}


~a.clear;
~b.clear;
~verb.clear;


(
~a.stop(1);
~verb.stop(2);
)

~verb = {GVerb.ar(~sn*0.125 + ~a*0.25 + ~b*0.125, 100, 3)}
~verb.play;
~verb.stop;

s.scope
p.clear(4)


~k.quant_(4);
~k = Pbind(\instrument, \bplay, \buf, d["k"][0], \dur, 1, \amp, 4);
~k.play;
~k.stop


~sn = Pbind(\instrument, \bplay, \buf, d["s"][0], \dur, Pseq([1, Pbjorklund2(3, 8, inf)/4], inf), \amp, 0.5, \rel, 0.05, \rate, 0.8);
~sn.play;
(
~k.stop;
~sn.stop;
~a.stop;
)


(
x = ChordSymbol(\E).wrapExtend( 3.rrand(6) ).collect({
	|item, idx|
	//item.postln;
	item+(0.5.coin.asInteger*12);
})
)


