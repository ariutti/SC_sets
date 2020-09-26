(
SynthDef(\saw, {
	|amp=1.0, atk=0.1, rel=1, freq=440, det=0.01, width=0.5|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = VarSaw.ar(freq * [[1.0, 1.0-det],[1.0, 1.0+det]], width:width) * env * amp;
	Out.ar(0, sig);
}).add;
)


x = Synth(\saw)

t = TempoClock.default;
t.tempo_(120/60)

~tonica = 0;
s.meter
s.scope
(
Pbindef(
	\pads,
	\instrument, \saw,
	\scale, Scale.minor,
	\octave, 3,
	\degree, Pfunc({~tonica}) + Pseq([-1, Pn(0,7)],inf) + [0,4,7].collect({|item| [item, item+0.01,item+11]}).flat,
	\atk, Pkey(\dur)*0.01,
	\rel, Pkey(\dur)*0.99,
	\amp, 0.0125,
	\det, Pn(Pseries(0.0, 0.0025,8),inf),
	\dur, 0.5,
	\width, Pn(Pseries(0.1, 0.005,8),inf),
).quant_(8).play
)

b = Buffer.read(s, "/home/nicola/Musica/SC_set/samples/superdirt/808bd/BD7525.WAV");
r = Buffer.read(s, "/home/nicola/Musica/SC_set/samples/superdirt/808sd/SD2550.WAV");

(
SynthDef(\buf, {
	|buf,amp=1.0, atk=0.01, rel=1.0, rate=1.0|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:0);
	var sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, doneAction:2) * amp * env;
	Out.ar(0, sig!2);
}).add;
)
Pbindef(\pads).play;
Pbindef(\pads).stop;
StageLimiter.activate;

(
Pbindef(\k,
	\instrument, \buf,
	\buf, b,
	\atk, 0.01,
	\rel, 0.25,
	\amp, 1,
	\dur, Pwrand([1, Pn(0.5,2)],[1,0.25].normalizeSum, inf),
	\rate, 0.9
).quant_(4).reset.play;
)

(
Pbindef(\sn,
	\instrument, \buf,
	\buf, r,
	\atk, 0.01,
	\rel, 0.2,
	\amp, 0.5,
	\dur, Pseq([1, Pseq([Pn(2,7), Pn(1,1)], inf)], inf),
	\rate, 1.1
).quant_(4).reset.play;
)

(
Pbindef(\hh,
	\instrument, \buf,
	\buf, r,
	\atk, 0.01,
	\rel, 0.1,
	\amp, 0.4,
	\dur, Pseq([0.5, Pseq([Pn(1,7), 0.5, Pn(0.25,2)],inf)], inf),
	\rate, 7
).quant_(4).reset.play;
)


