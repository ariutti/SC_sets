t = TempoClock.default;
t.tempo_(120/60)

(
SynthDef(\syncsaw, {
	|freq=440, sf=10, amp=1.0, atk=0.01, rel=0.1, bus=0, send=0.0|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = Decay.ar(Impulse.ar(0))*SinOsc.ar(freq) + SyncSaw.ar(sf, freq*[0.99, 1.01]) * env * amp;
	Out.ar(0, Pan2.ar(sig, 0.0));
	Out.ar(bus, sig*send); // fx send
}).add;
);

Pbindef(\lick1).stop;

(
Pbindef(\lick1,
	\instrument, \syncsaw,
	\scale, Scale.minor,
	\octave, [3,4],
	\detune, Pseries(0.0, 0.1, inf).wrap(0.0, 0.8), //Pwhite(0.0, 0.5, inf).clump(4),

	\degree, Prand([
		Pseq([\rest, Pn(0, 6),-7], 3),
		Pseq([\rest, Pn(0, 3), -7], 1),
		Pseq([\rest, Pn(0, 5), -7], 1),
		//Pseq([\rest,2,3,4,5,6,7,8],1)-8
	],inf),
	\dur, 0.5,
	\atk, 0.0,
	\rel, 0.3,
	\sf, ((60+Pkey(\degree))-48).midicps,
	\amp, Pn(Pseries(0.2, 0.05, 8).clip(0.0, 1.0), inf)*0.9,
	\lag, Pwhite(0.0, 0.01, inf)
).quant_(4).play;
Pbindef(\k).play;
Pbindef(\sn).play;
Pbindef(\hh).play;
)



Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Prand([0.5, 1, Pn(0.25, 2)], inf),\amp,0.6).quant_(4).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Prand([1], inf),\amp,1).quant_(4).play;
Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],\dur,Pn(0,1)++Pseq([2],inf),\amp,Pn(\rest,1)++Pseq([0.5],inf)).quant_(4).play;

Pbindef(\clap, \instrument,\bplay,\buf,d["c"][0],\dur,5,\amp,0.5).quant_(4).play;
Pbindef(\clap).stop;

Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],\dur,Pn(1,1)++Pseq([2],inf),\amp,Pn(\rest,1)++Pseq([0.5],inf)).quant_(4).play;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)).quant_(4).play;
Pbindef(\shout, \instrument,\bplay,\buf,d["shout"][1],\dur,8,\amp,0.8,\rate,0.8).quant_(4).stop;

s.meter;
s.plotTree;

(
Pbindef(\sn,
	\instrument,\bplay,
	\buf,d["s"][0],
	\dur,Pseq([1,Pseq([2],inf)],inf),
	\amp,Pseq([\rest, Pseq([1],inf)],inf),
	\rate, 0.6,
	\rel, 0.1
).quant_(4).play;
)

// stacco
(
Pbindef(\lick1,\degree, 0, \dur,1);
Pbindef(\k).stop;
Pbindef(\sn).stop;
Pbindef(\hh).stop;
Pbindef(\clap).stop;
Pbindef(\shout).stop;
)

Pbindef(\lick1).stop;


(
SynthDef(\syncsaw, {
	|freq=440, sf=10, amp=1.0, atk=0.01, rel=0.1, bus=0, send=0.0|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = Decay.ar(Impulse.ar(0))*SinOsc.ar(freq) + SyncSaw.ar(sf, freq*[1.01, 0.99]) * env * amp;
	Out.ar(0, Pan2.ar(sig, 0.0));
	Out.ar(bus, sig*send); // fx send
}).add;
);