(
SynthDef(\fm, {
	|freq=440, amp=1.0,atk=0.01, rel=0.25,
	mr=0, mi=100, pan=0.0, out=2|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = SinOsc.ar(freq + SinOsc.ar(freq*mr, mul:mi)) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
	Out.ar(out, sig);
}).add;
)

~fx = Bus.audio(s,1);
~verb = Synth(\verb, [\in, ~fx]);
~verb.set(\amp, 1.0, \room,0.8, \damp, 0.7);
~verb.free

~fx.scope

(
SynthDef(\verb, {
	|in, amp=0.0, room=0.7, mix=1.0, damp=0.5|
	var sig = In.ar(in,1);
	sig = FreeVerb.ar(sig, mix, room, damp) * amp;
	Out.ar(0, sig!2);
}).add;
)
(
Pbindef(\fms,
	\instrument, \fm,
	\scale, Scale.major,
	\octave, Prand([
		2,3,4,
		[4, 3],
		Pxrand([5,6], 8),
		7 //,Pxrand([7,8], 2),
	],inf),
	\degree, 0 + Prand([
		Pseq([[0,1],4,7],7),
		-1,
		13,
		Pn(4,8),
		Pn(1,3),
		Pn(0, 4),
		[0,4,7]
	], inf),
	\mr, Prand((1,2..16),inf).clump(4),
	\mi, Pexprand(10, 1000, inf).clump(4),
	\atk, Pexprand(0.01, 0.5,inf).clump(4),
	\rel, Pexprand(0.1, 1,inf).clump(4),
	\amp, Pgauss(0.2, 0.1, inf).clump(4),
	\dur, Pswitch([
		Prand([0.125,0.25,1, Pn(0.25,4),Pn(0.125,4)], 1),
		Prand([0.125],1),
		Prand([0.25],1)
	], Pfunc({~select})),
	\out, ~fx,
	\pan, Pwhite(-1.0, 1.0, inf).clump(4),
	\strum, Pwhite(-0.02, 0.02, inf),
	\lag, Pwhite(0.0, 0.02, inf)
))

~select = 0;

Pswitch

s.scope

s.freqscope

Pbindef(\fms).play;
Pbindef(\fms, \mf,nil)