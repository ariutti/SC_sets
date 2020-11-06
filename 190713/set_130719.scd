p = ProxySpace.push();
p.makeTempoClock
p.clock.tempo_(2)
s.plotTree
s.meter;
s.scope
s.freqscope

~fond = {0};
p.clear(4)
p.stop


(
~fond = {0};
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\rel, 0.05,\amp,0.6);
~k.quant_(2);
~k.play(fadeTime:0.0);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,2,\rel, 0.1,\amp,0.5);
~sn.quant_(4);
~sn.play(fadeTime:0.0);
~caossine.play(fadeTime:3);
)

~caossine.play(fadeTime:3);

(
~fond = {0};
~k.stop;
~sn.stop;
~caossine.stop(fadeTime:10);
)

~bass.stop(5);
~test.stop(1);

~bass.play;
~stabs.stop(0.1);
~stabs.play;

(
~stabs = Pbind(
	\instrument, \ring1,
	\dist, 9, //Pseries(1, 1, inf).fold(1, 9),
	\rel, 0.3,
	\amp, 0.3,
	\degree, Pkr(~fond)
	       + Pwrand(#[[0, -3, -5], [0, -2, -4], [0, -2, -5], [0, -1, -4]], [1, 0.5, 0.4, 0.3].normalizeSum, inf),
    \dur, 0.25 + Pwrand(#[1, 0.5], #[0.6, 0.4], inf)
);
~stabs[1] = \filter -> {|in| in + GVerb.ar(in, 30, 3, 0.5, mul:0.1)};
)


(
~bass = Pbind(
	\instrument, \squarebass,
	\octave, Pwhite(3,4,inf),
	\degree, Pkr(~fond) + Prand([0, 4], inf),
	\amp, 1,
	\detune, 0.1,
	\width, Pwhite(0.1, 0.5, inf),
	\dur, 0.5 + Prand([1, 0.5, Pn(0.25, 4)], inf)
)
)
~bass.quant_(4);
~bass.play;


(
~caossine = Pbind(
	\instrument,\caossine,
	\scale, Scale.minor,
	\degree, 0,
	\detune, 0,
	\octave, Prand((3..12), inf),
	\dur, 0.25,
	\im, Pwhite(16, 35, inf),
	\fb, Pwhite(0.1, 16, inf),
	\a, Pexprand(0.1,1.2, inf),
	\c, Pexprand(1,6, inf),
	\atk, 0.01,
	\sus, 0,
	\rel, 0.005, //Pexprand(0.1,0.3, inf),
	\amp, 0.4,
	\pan, Pwhite(-1.0, 1.0, inf)
);
)
~caossine.play;
