// playing with lissajeout figures

(
SynthDef(\test, {
	|freq=440, amp=1.0, atk=0.01, rel=1, phase=0.0|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	//var sig = SinOsc.ar(freq, phase:[0.0, phase], mul:MouseY.kr(1.0, 10)).clip(-0.5, 0.5) * env * amp;
	//var sig = SinOsc.ar(freq, phase:[0.0, phase], mul:MouseY.kr(1.0, 10)).wrap(-0.5, 0.5) * env * amp;
	//var sig = SinOsc.ar(freq, phase:[0.0, phase], mul:MouseY.kr(1.0, 10)).fold(-0.5, 0.5) * env * amp;
	//var sig = SinOsc.ar(freq, phase:[0.0, phase], mul:MouseY.kr(1.0, 10)).fold(MouseX.kr().range(0.001, 1.0) * -1, MouseX.kr().range(0.001, 1.0) * 1) * env * amp;
	var sig = SinOsc.ar(freq, phase:[0.0, phase], mul:MouseY.kr(1.0, 10)).clip(MouseX.kr().range(0.001, 1.0) * -1, MouseX.kr().range(0.001, 1.0) * 1) * env * amp;
	Out.ar(0, Pan2.ar(sig, 0.0));
}).add;
)
s.scope;
(
Pbindef(\test,
	\instrument, \test,
	\octave, Prand([3,4], inf),
	\degree, Prand([0,-7], inf),
	\dur, 0.25,
	\amp, 1.0,
	\phase, Pwhite(0.0, 0.25pi, inf),
	\rel, 1
).quant_(1);
)
Pbindef(\test).reset.play;
Pbindef(\test).stop;