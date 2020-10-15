(
SynthDef(\sine, {
	|freq=440, amp=1.0, pan=0.0, atk=0.01, rel=1|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = Impulse.ar(freq*0.5, mul:2) + SinOsc.ar(freq) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbindef(\sine,
	\instrument, \sine,
	\scale, Scale.minor,
	\octave, Prand([5,6,7],inf),
	\degree, Prand([[0,7,13],[0,1],[2,6], 7], inf), //Pseq([Pn(0, 5), Pn(7,1)], inf),
	\atk, 0.0,
	\rel, Pgauss(0.125, 0.05, inf),
	\dur, Prand([Pn(0.25,8)], inf),
	\amp, Pgauss(0.1, 0.01, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\strum, Pwhite(-0.02, 0.02, inf)
).play;
)

Pbindef(\sine).stop;

~t = TempoClock.default;
~t.tempo_(120/60);

(
SynthDef(\pad, {
	|freq=440, pan=0.0, atk=0.01, rel=1, amp=1.0|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = [];
	10.do{
		|i|
		sig.add(LPF.ar(Pulse.ar((freq*(i+1)) + 0.1.rrand(2), LFNoise1.kr(20).range(0.1, 0.5)), freq*8, mul: 1/10)
		);
	};
	sig = Splay.ar(sig) * amp * env;
	Out.ar(0, sig);
}).add;

Pbindef(\pads,
	\instrument, \pad,
	\scale, Scale.minor,
	\octave, 4,
	\degree, Pseq([
		Pn([0, 2, 6],2),
		Pn([0, 2, 4],2),
	], inf),
	\dur, 8,
	\atk, Pkey(\dur) * 0.5,
	\rel, Pkey(\dur) * 0.5,
	\pan, 0.0,
	\amp, 0.9,
	\legato, 1.01
).quant_(4);
Pbindef(\pads).play;
)

Pbindef(\pads).stop;

(
SynthDef(\saw, {
	|freq=440, amp=1.0, atk=0.01, rel=1, pan=0.0, width=0.5|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = VarSaw.ar(freq, width:width);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
Pbindef(\bass,
	\instrument, \saw,
	\scale, Scale.minor,
	\octave, [2, 3, 4],
	\degree, Pseq([ Pn(0,7), Pn(7,1)], inf),
	\amp, Pgauss(0.3, 0.01, inf),
	\atk, 0.01,
	\rel, 0.5,
	\width, 0.1,
	\dur, Pseq([1,0.25,0.75], inf)
).quant_(4).play;
)

Pbindef(\bass).stop;

p.pop
~k = Buffer.read(s, "/home/nicola/Documenti/repos/SC_workshop/sounds/Linn Kick 1.wav");
~sn = Buffer.read(s, "/home/nicola/Documenti/repos/SC_workshop/sounds/Crsnred_scr_snr_6.wav");
~hh = Buffer.read(s,"/home/nicola/Documenti/repos/SC_workshop/sounds/Crsnred_scr_ht_3.wav");

(
SynthDef(\player, {
	|buf, rate=1, amp=1.0, atk=0.01, rel=1|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0) * amp * env;
	Out.ar(0, Pan2.ar(sig, 0.0));
}).add;
)
(
Pbindef(\kick,
	\instrument, \player,
	\buf, ~k,
	\dur, 2, //Prand([2, Pn(0.5,2)], inf),
	\atk, 0.0,
	\rel, 4,
	\amp,0.5
).quant_(4);

Pbindef(\snare,
	\instrument, \player,
	\buf, ~sn,
	\atk, 0.0,
	\rel, 1,
	\dur, Pseq([1,Pseq([2],inf)], inf),
	\amp,0.5
).quant_(4);
)
(
Pbindef(\hh,
	\instrument, \player,
	\buf, ~hh,
	\atk, 0.0,
	\rel, 1,
	\dur, Pseq([0.5, Prand([
		Pseq([1],5),
		Pseq([0.25],3)
	],inf),
	], inf),
	\amp,0.5
).quant_(4);
)

Pbindef(\kick).stop;Pbindef(\snare).stop;Pbindef(\hh).stop;
(
Pbindef(\kick).play;
Pbindef(\snare).play;
Pbindef(\hh).play;
)


// thanks, bye!!!

