(
SynthDef(\organ, {
	|amp=1.0, freq=440,atk=0.1, rel=1,pan=0.0,nh=2,dist=1|
	var env = EnvGen.ar(Env.perc(atk,rel), doneAction:2);
	var sig = Blip.ar(freq*[0.998, 0.999, 1.001, 1.002], nh) * env;
	sig = (sig * dist).tanh * amp;
	sig = Splay.ar(sig);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\verb, {
	|in=0, out=0,amp=1.0, room=0.7, damp=0.5|
	var sig = In.ar(in,1);
	sig = FreeVerb.ar(sig, 1.0, room, damp) * amp;
	Out.ar(out, sig!2);
}).add;
)

~verb = Synth(\verb);
~verb.set(\room,0.9, \damp, 0.01)
~verb.free;

(
Pbindef(\test,
	\instrument, \organ,
	\octave, Prand([2,3,4],inf),
	\scale, Scale.minor,
	\detune, 0,
	\degree, Pstutter(Prand([1,2,4],inf).asStream, Pwrand([0,-1,7],[1,0.25,0.5].normalizeSum,inf),inf),
	\nh, Pwhite(1,20,inf),
	\atk, 0.01,
	\rel, 0.3,
	\dur, 0.125,
	\amp, 0.1,
	\dist, Pwhite(1,90, inf),
	\strum, Pwhite(0.01, -0.01, inf),
	\addAction, Pwrand([0,1],[2,1].normalizeSum,inf)
).stop.quant_(4).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,0.5,\amp,0.7,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,1,\amp,0.5,\addAction,1,\rate,0.8,\rel,0.15).quant_(4).play;
)

Pbindef(\test,\amp,0.0);

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,0.5,\amp,0.7,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,1,\amp,0.5,\addAction,1,\rate,0.8,\rel,0.15).quant_(4).play;
)

Pbindef(\test, \detune, Pseries(0.0, 1.0,inf), \nh, Pseries(0.0, 0.25,inf), \octave, 4, \dist, 10,\rel, 0.1)

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Prand([0.5,0.25,Pn(0.125,4)],inf),\amp,0.7,\addAction,1,\rel, 0.1).quant_(4).play;

Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,1,\amp,0.5,\rate,0.8,\rel,0.15,\addAction,1).quant_(4).play;

(
Pbindef(\test, \detune, Pseries(0.0, 1.0,inf), \nh, Pseries(0.0, 0.25,inf), \octave, 4, \dist, 10,\rel, 0.1);
Pbindef(\k).stop;
Pbindef(\s).stop;
)


s.meter
s.plotTree;

Pbindef(\test).play;