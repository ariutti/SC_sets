// hypnotic piano
// an experiment in playing a piano loop
s.meter;
(
~pianoLoop = Pbind(
	\instrument, \lplay,
	\buf, d["loops"][0],
	\amp, 4,
	\dur, 2,
	\bed, 48,
	//\start, 0.125*0.5,
	\start, Pseq([Pn(0,Pwhite(0,8).asStream.round(2)), Pn(0.125*0.5, Pwhite(0,8).asStream.round(2)), Pn(0.125, Pwhite(0,8).asStream.round(2))],inf),
	//\start, Pseq((0..7)/8, inf), //Pwrand([0,4]/8, [3,1].normalizeSum, inf)
);
~pianoLoop[1] = \filter -> {|in| GVerb.ar(
	BPF.ar(in,
		SinOsc.ar(p.clock.tempo/8).exprange(200, 1000), 0.5
), 100, 3, 0.7)
};

~pianoLoop.quant_(4);
)
~pianoLoop.stop;
~pianoLoop.play;
~pianoLopp.clear;

// eventually pay a rythm
(
~tlapan = Pbind(\instrument, \bplaym, \buf, Pindex(d["tlapan"],Pseq([0,1,1],inf),inf), \dur, Pseq([2, 1, 1], inf), \amp, Pseq([0.6, 0.4, 0.3]*2, inf));
~tlapan.quant_(2);
)
~tlapan.play;
~tlapan.stop;
~tlapan.clear;

p.stop(10)