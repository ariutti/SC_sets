// guitar

t = TempoClock.default
t.tempo_(135/60)
s.meter;

~root = -1;


(
SynthDef(\pluck, {
	|out=0, freq=440, pan=0.0, amp=1.0, coef, dcy=1, dist=1, atk=0.1, rel=0.5|
	var exc, sig, env;
	exc = WhiteNoise.ar() * EnvGen.ar(Env.perc(atk, rel));
	//exc = BrownNoise.ar() * Decay2.ar(Dust.ar(10)); //EnvGen.ar(Env.perc(atk, rel));
	sig = Pluck.ar(exc, 1, 0.2,freq.reciprocal,dcy,coef:coef.clip(-1.0, 1.0));
	sig = (sig * dist).tanh * amp;
	sig = LeakDC.ar(sig);
	DetectSilence.ar(sig, 0.0001, 0.01, doneAction:2);
	Out.ar(out, Pan2.ar(sig,pan));
}).add
);


// questo arpeggio potrebbe tranquilamente essere lo stesso che viene usato per
// fare la progressione "shepard" in itnerstellar

~arp_1 = [\,2,0,-3,2,0,-3,2,\,2,0,-3,2,0,-3]
~durs  = [Pn(0.5,8+6),1]
~arp_2 = [\,1,-1,-3,1,-1,-3,1,\,1,-1,-3,1,-1,-3]
~arp_3 = [\,2,0,-2,2,0,-2,2,\,2,0,-2,2,0,-2]
~arp_4 = [\,3,1,-1,3,1,-1,3,\,3,1,-1,3,1,-1]

(
Pbindef(\arpeggio,
	\instrument, \pluck,
	\octave, [3,4,6],
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\degree, Pseq([[0,2,4]],inf), //Pseq(~arp_1++~arp_2++~arp_3++~arp_4, inf),
	\dur, 0.5, //Pseq(~durs,inf),
	\coef, Pseg([0.1, 0.9, 0.1],[8,8],\lin, inf),
	\dcy, 0.3,
	\atk, 0.0,
	\amp, 0.7,
	\dist, Pseg([1, 100, 1],[16,16],\exp, inf),
	\rel, t.beatDur * Pkey(\dur),
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\lag, Pwhite(0.0, 0.001, inf)
).quant_([4])
)
Pbindef(\arpeggio).play;
Pbindef(\arpeggio).stop;







// guitar test ///////////////////////////////////////////////////


(
SynthDef(\pluck, {
	|out=0, freq=440, pan=0.0, amp=1.0, coef, dcy=1, dist=1, atk=0.1, rel=0.5|
	var exc, sig, env;
	exc = WhiteNoise.ar() * EnvGen.ar(Env.perc(atk, rel));
	exc = BrownNoise.ar() * EnvGen.ar(Env.perc(atk, rel));
	sig = Pluck.ar(exc, 1, 0.2,freq.reciprocal,dcy,coef:coef.clip(-1.0, 1.0));
	sig = (sig * dist).tanh * amp;
	sig = LeakDC.ar(sig);
	DetectSilence.ar(sig, 0.0001, 0.01, doneAction:2);
	Out.ar(out, Pan2.ar(sig,pan));
}).add
);

(
Pbindef(\arpeggio,
	\instrument, \pluck,
	\octave, 6,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\degree, Pseq(~arp_1++~arp_2++~arp_3++~arp_4, inf),
	\dur, Pseq(~durs,inf),
	\coef, 0.1,
	\dcy, 5,
	\atk, 0.0,
	\amp, 0.7,
	\dist, 1,
	\rel, t.beatDur * Pkey(\dur),
	\pan, Pwhite(-1.0, 1.0, inf),
	\lag, Pwhite(0.0, 0.001, inf)
).quant_([4])
)