// NOISE FX ////////////////////////////////////////////////////////
(
SynthDef(\staticNoise, {
	|amp=1.0, out=0|
	var a = SinOsc.ar(15600, mul:0.00125);
	var b = SinOsc.ar(2484, mul:0.00125);
	var c = LPF.ar(HPF.ar(PinkNoise.ar().cos(), 700), 900);
	var sig = (a + b + c) * amp;
	Out.ar(out, Pan2.ar(sig, 0.0));
}).add;
)


~static_noise_1 = Synth(\staticNoise, [\amp, 2.0, \out, 0], addAction:1);
~static_noise_1.set(\amp, 4);
~static_noise_1.free;