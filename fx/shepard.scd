// Comb used as a resonator. The resonant fundamental is equal to reciprocal of the delay time.
(
SynthDef(\combi1, {
	|
	amp=0.5,pan=0.0,
	f1=440, f2=6000,lenght=20,out=0
	|
	var sig, env;
	env = EnvGen.ar(Env.triangle(lenght),1, doneAction:2);
	sig = PinkNoise.ar();
	sig = CombC.ar(sig, 0.01, XLine.kr(f1.reciprocal, f2.reciprocal, lenght), 0.2);
	sig = HPF.ar(sig, 500);
	sig = sig * env;

	sig = sig * amp;

	Out.ar(out, Pan2.ar(sig, pan));

}).add;
);


s.plotTree;
(
~amp_shepards = 0.1;
)

(
Pbindef(\noise_falling,
	\instrument, \combi1,
	\f1, Pwhite(2000, 3000, inf),
	\f2, Pwhite(500, 1000, inf),
	\lenght, Pwhite(10, 20, inf),
	\dur,0.25,
	\amp, 0.05 * Pfunc({~amp_shepards}),
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\group, ~grp_shepards,
	//\addAction, Prand([0],inf)
);
)
Pbindef(\noise_falling).play;
Pbindef(\noise_falling).stop;


// create a grp where to place the shepard synths
// play the pattern
(
Tdef(\activate_shepard, {
	"activate shepards".postln;
	~grp_shepards = Group.new(s);
	Pbindef(\noise_raising,
		\instrument, \combi1,
		\f1, Pwhite(500, 1000, inf),
		\f2, Pwhite(2000, 3000, inf),
		\lenght, Pwhite(3, 5, inf),
		\dur, 0.25,
		\amp, 0.1 * Pfunc({~amp_shepards}),
		\out, 0,
		\pan, Pwhite(-1.0, 1.0, inf),
		\group, ~grp_shepards,
		\addAction, Prand([1],inf)
	).quant_(0).play;
}).quant_(0);
)
// evaluate the code below to instantly kill all the shepards and the container grp
(
Tdef(\deactivate_shepard, {
	"deactivate shepards".postln;
Pbindef(\noise_raising).stop;
~grp_shepards.free;
}).quant_([0]);
)


// temp
Pbindef(\noise_raising).play;
