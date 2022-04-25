Pbindef.gui;
//stop all
Pbindef.all.do({ |item| item.stop; });
Tdef.all.do({ |item| item.stop; });


// kill the zombies
(
a = Synth.basicNew(\synthDefName, nodeID:);
a.free;
)




(
SynthDef(\metronome, {
	|
	out=0,
	amp=1, freq=1000, pos=0.0,
	rel=0.1
	|
	var sig, env, fenv;

	// amplitude envelope
	env   = EnvGen.ar(Env.perc( 0.001, rel), doneAction:2);
	// cut frequency envelope
	sig = SinOsc.ar(freq);
	//sig = RLPF.ar(sig, rf*fenv, rq);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pos));
}).add;
);

// metronome
(
Pbindef(\metronome,
	\instrument, \metronome,
	\freq, Pseq([1500, 1000.dup(3)].flat, inf),
	\dur, 1,
	\amp, 1,
	\rel, 0.01,
	\addAction,1
).quant_([4,0]).stop.play;
)
Pbindef(\metronome).stop;
Pbindef(\metronome).clear;


s.scope
s.meter