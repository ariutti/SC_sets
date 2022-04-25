
d["loops"][1]

(
Pbindef(\loop,
	\instrument, \sliceplayer,
	\loopbuf, d["loops"][1],
	\loopbars, 4,
	\loopbpm, 168,
	\currentBpm, Pfunc({TempoClock.default.tempo}),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 0.2,
	\start, 0.0,
	\dur, 4*4,
	\addAction, 1
).quant_(4).stop.play;
)

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.6).quant_(4).play;
Pbindef(\loop).stop;
)
s.plotTree



~scale =  Scale.minor;

(
Pbindef(\bass_lick,
	\instrument, \doublebass,
	\scale, Scale.minor,
	\root, 4,
	\octave, [3,4,5],
	\degree, Pfunc({~tonica}) + Prand([0,-1],inf),
	\atk, 0.0,
	\fc, 4000, //Pwhite(10, 60, inf),
	\rel, 0.25,
	\detune, Pwhite(0.0,2,inf).clump(2),
	\dur, Pwrand([0.75,0.25,0.5, Pn(0.125,2)],[0.1, 1, 0.5,0.1].normalizeSum,inf) * 2,
	\amp, 0.1, //Pseg(Pseq([0.0, 1.0],inf), Pn(8,inf), inf),
	//\bus, ~fxsend,
	//\send, Pseries(0.0, 0.01, inf).wrap(0.0, 1.0)
	\addAction, 0
).quant_(1).play;
)
Pbindef(\bass_lick).stop;

(
~tonica = 0;
//Pbindef(\k).stop;
Pbindef(\ping).stop;

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([0.25,1.75],inf),\amp,0.6).quant_(4).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.6).quant_(4).play;
)

(
Pbindef(\hh).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
)

(
Pbindef(\hh).play;
Pbindef(\k).play;
Pbindef(\s).play;
)


Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.6).quant_(4).play;

(
~tonica = 0;
Pbindef(\ping).play;
//Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Prand([1, Pseq([0.25,1.75],1)],inf),\amp,0.6).quant_(4).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.6).quant_(4).play;

Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,0.5,\amp,0.6,\rel,0.05,\rate,2,\addAction,1).quant_([4,0.5]).play;

Pbindef(\s,\instrument,\bplaym,\buf,d["sstick"][0],\dur,Pbjorklund2(3,4,inf,1)/2,\amp,0.5,\rel,0.2,\rate,1,\addAction,1 ).quant_([4,1]).play;
)


(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.6).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][1],\dur,2,\amp,0.4,\rel,0.5,\rate,0.6,\addAction,1 ).quant_([4,1]).play;
)
Pbindef(\k).stop;

~tonica = 0;

s.plotTree


(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5, detune=0.1,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	sig = LFPulse.ar(freq + LFNoise1.ar(10, detune), width:width);
	sig = sig * env * amp;
	sig = Decimator.ar(sig, 11025, 8);
	sig = LeakDC.ar(sig);
	sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


(
SynthDef(\square, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5, detune=0.1,
	dist=1.0
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	sig = LFPulse.ar(freq, width:width).bipolar;
	sig = sig * env * dist;
	sig = sig.tanh * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);




~tonica = 0;
Pbindef(\pads, \amp, 0.0)
(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, 4,
	\octave, Prand([6,5],inf).clump(2),
	\degree, Pfunc({~tonica}) + Prand([0,4,7],inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	//\width, Pseg([0.5, 0.01, 0.5], [4], \exp, inf),
	//\fc, Pseg([1000, 6000, 1000], [4], \exp, inf),
	\amp, 0.04,
	\atk, 4,
	\rel, 4,
	\dur, 0.25,
	\pan, Pwhite(-1.0 ,1.0, inf).clump(2),
	\addAction, 1, //Prand([0,1],inf)
).quant_([4,1]).stop.play;
)
Pbindef(\pads).stop;

~tonica = 0;
Pbindef(\test, \amp, 0.1);
(
Pbindef(\test,
	\instrument, \square,
	\octave, Prand([4],inf),
	\scale, Scale.minor,
	\root, 4,
	\detune, Pwhite(0.1, -0.1, inf),
	\degree, Pfunc({~tonica}) + Pseq([0,2,[4,7]].rotate,inf), // Pstutter(Prand([1,2,4],inf).asStream, Pwrand([0,-1,7],[1,0.25,0.5].normalizeSum,inf),inf),
	\amp, 0.3,
	\atk, 0.0,
	\rel, Pseq([0.4,0.4,1.5], inf),
	\dist, 6,
	\dur, Pseq([1,1,2+4], inf), //0.125,
	\addAction, 1,
).quant_([4,0]).stop.play;
)
Pbindef(\test).stop;


~tonica = 0

(
Pbindef(\ping,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, 4,
	\detune, Pwhite(-0.05, 0.05, inf).clump(3),
	\octave, Prand([7],inf), // Prand([4,5,6], inf), //]Pseq([[3,4],5],inf), //Prand([3,4,5], inf).clump(3),
	\degree, Pfunc({~tonica}) + Pseq([0],inf),
	\fb, Pseg([0.1, 2.1], [4], \lin, inf),
	\amp, Pseg([0.0, 0.5], [4],\lin, inf) * 0.3,
	\atk, 0.0,
	\rel, 0.1, Pseq([4, Pn(0.5, 4)], inf),
	\dur, 0.25, //Pseq([6, Pn(0.5,4)],inf),
	\pan, Prand([-1.0, 1.0], inf),
	\addAction, 1
).quant_([4,0]).play;
)

Pbindef(\ping).stop;

Pbindef(\k, \dur, 0.75)
Pbindef(\k, \dur, 1)
Pbindef(\k,\instrument,\bplaym,\buf,d["k"][1],\dur,1,\amp,18,\rel,5,\rate,1,\addAction,1).quant_([2]).stop.play;
Pbindef(\k).stop;
Pbindef.gui

~tonica = 0;

(
Pbindef(\test,
	\instrument, \square,
	\octave, [6], //Prand([2,3,4],inf),
	\scale, Scale.minor,
	\root, 4,
	\detune, Pwhite(0.1, -0.1, inf),
	\degree, Pfunc({~tonica}) + [0,7], //Pseq([0,2,4],inf),//Prand((0..7),inf), //Pfunc({~tonica}) + Pseq([4,2,-1],inf), // Pstutter(Prand([1,2,4],inf).asStream, Pwrand([0,-1,7],[1,0.25,0.5].normalizeSum,inf),inf),
	\nh, Pwhite(1,20,inf),
	\atk, 0.0,
	\rel, 1,
	\dur, 4, //Pseq([0.5,0.5,3], inf) * 1,
	\amp, 0.1,
	\dist, Pwhite(1,90, inf),
	\strum, 0.0, //Pwhite(0.01, -0.01, inf),
	\addAction, 0, //Pwrand([0,1],[1,2].normalizeSum,inf)
	\lag, 0.0//, Pwhite(0.0, 0.05, inf)
).quant_([4,1]).play;
)


(
Pbindef(\speakSpell,\instrument,\bplaym,\buf,d["speakspell_letters"][0],\dur,Pseq([4],1),\amp,3,\addAction,0,\rate,0.5,\pan, 0.0).quant_(4);
)
Pbindef(\speakSpell).stop;

(
Pbindef(\test).stop;
~tonica = 4;
//Pbindef(\test, \dur, 2);
Pbindef(\hh).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
)

(
Pbindef(\test).play;
~tonica = 0;
Pbindef(\test, \dur, 1, \lag, 0.0);
Pbindef(\hh).play;
Pbindef(\k).play;
Pbindef(\s).play;
)