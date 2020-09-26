TempoClock.default.tempo
s.meter

// happy listening!!
// thank you s-ol
// it should keep going foerever


(
Tdef(\repetition, {
	var t = Pseq([4,3,2], inf).asStream;
	{
		//~tonica = t.next;
		postln("we love repetition!");
		1.wait;
	}.loop;
}).quant_(4);
)
Tdef(\repetition).play;
Tdef(\repetition).stop;


~tonica = 3;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,4, \lpf,1500, \wet,1.0);

(
Pbindef(\A,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, [5,6], //Prand([5,6],inf),
	\degree, Pfunc({~tonica}) + Prand([
		Pseq([0,2,9], 1),
		Pseq([0,4,7], 1),
		Pseq([0,5,6], 1),
	], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\fb, Pseg([0.0, 0.9,0.0], [8,8], \lin, inf),
	\atk, 0.0,
	\rel, 1,
	\amp, 0.0125,
	\dur, 0.25,
	\pan, Pwhite(-1.0, 1.0, inf).clump(2),
	\addAction, 0
).quant_(0).play;
)
Pbindef(\A).stop;


(
Pbindef(\test,
	\instrument, \sinfb,
	\scale, Scale.major,
	\octave, Prand([4,5,6], inf),
	\degree, Pfunc({~tonica}) + Pseq([0,1,7], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf),
	\fb, Pseg([0.0, 0.9,0.0], [8,8], \lin, inf),
	\atk, 0.5,
	\rel, 1,
	\amp, Pseg([0.02, 0.05,0.02], [4,3], \lin, inf),
	\dur, 0.125,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_(0).play;
)
Pbindef(\test).stop;

(
Pbindef(\B,
	\instrument, \sinfb,
	\octave, Pseq([5,6,7], inf),
	\degree, Pseq([0,-1,-2],inf),
	\mtranspose, Pwhite(-1.0, 1.0, inf) * Pseg([0.0, 0.2], [4], \lin, inf),
	\amp, Pseg([0.3, 0.0], [4], \lin, inf),
	\fb, Pseg([0.7, 0.9], [4], \lin, inf),
	\atk, 0.0,
	\rel, 0.05,
	\dur, 0.125,
	\pan, Pseq([-1, 1], inf),
	\addAction, Prand([0,1], inf),
	\strum, 0.05
).quant_(0).play;
)
Pbindef(\B).stop;

Pbindef(\k).stop;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,0.5,\amp,0.4,\rel,0.1,\rate,0.7,\addAction,1).quant_([4]).play;

s.meter;
(
Pbindef(\D,
	\instrument, \ring1,
	\octave, [4,5],
	\degree, Pseq([-2],inf),
	\amp, 0.4,
	\dist, 5,
	\atk, 0.0,
	\rel, 2,
	\dur, 4,
	\pan, Pseq([-1.0, 1,0], inf).clump(2),
	\addAction,0
).quant_(0).stop.play;
)
Pbindef(\D).stop;


// gently fade out
// thank you for beeing here with us



