// Calm and Relaxing Theme
p = ProxySpace.push(s.boot);
"./mySetup/mySetup.scd".loadRelative;

p.quant_(4)
p.clock.tempo = 2

~tlapan = Pbind(\instrument, \bplaym, \buf, Pindex(d["tlapan"],Pseq([0,1,1],inf),inf), \dur, Pseq([2, 1, 1], inf), \amp, Pseq([0.6, 0.4, 0.3]*2, inf));
~tlapan.quant_(2)
~tlapan.play;
~tlapan.stop(10);

~misc = Pbind(\instrument, \bplaym, \buf, Pindex(d["misc"],Prand((0..d["misc"].size-1),inf)), \dur, 0.5, \amp, 0.25, \rate, Pwhite(0.2, 5, inf), \pan, Pwhite(-0.8, 0.8,inf));
~misc.quant_(1)
~misc.play;
~misc.clear;
~misc.stop;


~shout = Pbind(\instrument, \bplay, \buf, d["shout"][1], \dur, 16, \amp, 0.5, \rate, Pwhite(0.9, 1.2, inf) );
~shout[1] = \filter -> {|in| GVerb.ar(in, 100, 3, 0.5)}
~shout.quant_(4);
~shout.play;
~shout.stop(10);

~numbers = Pbind(\instrument, \bplaym, \buf, Pindex(d["numbers"],Pseq((0..d["numbers"].size-1),inf)), \dur, 8, \amp, 0.25, \rate,1);
~numbers.quant_(4);
~numbers.play;
~numbers.stop(10);

~root = {3}; //0, 5, 7

(
~fmpads[0] = Pbind(
	\instrument, \fm_pads1,
	\octave, Pwrand([5,6,7],[3,2,1].normalizeSum, inf),
	\scale, Scale.major,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\root, Pkr(~root),
	\degree, Pwrand([0,4,7],[3,1.5, 2].normalizeSum, inf),
	\mIdx, Pexprand(100, 1000, inf),
	\mRatio, Prand([0.125, 0.25, 0.5, 2, 4, 8], inf),
	\dur, Pwhite(1, 5, inf),
	\atk, Pkey(\dur)*2,
	\rel, Pkey(\dur)*3,
	\amp, Pwhite(0.05, 0.1, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
)
)
~fmpads[1] = \filter -> {|in| GVerb.ar(in, 100, 3, 0.5)}
~fmpads.play(fadeTime:10);
~fmpads.clear;
~fmpads.stop(10);


~goh = Pbind(\instrument, \glinem, \buf, Pindex(d["oh_mono"],Prand((0..d["oh_mono"].size-1),inf)), \dur, 16, \rate, 0.25, \density, 300, \caos, 0.9, \amp, 0.7);
~goh[1] = \filter -> {|in| GVerb.ar(in*0.25, 100, 3, 0.5)}
~goh.play;
~goh.stop(10);


~bass = Pbind(\instrument, \ring1, \a, 7, \d, 1, \dur, 0.5, \octave, Prand([3],inf), \degree, 0, \root, Pkr(~root), \amp, 0.25);
~bass.quant_(4)
~bass.play();
~bass.stop(4);
~bass.clear;

p.gui

