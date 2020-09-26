// 2019-05-05
// A little experiment that's reminds me of pushover soundtrack

p = ProxySpace.push(s.boot);

(
SynthDef(\pluck, {
	|out=0, freq=440, pan=0.0, amp=1.0, coef, dcy=1|
	var exc, sig, env;
	exc = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.5));
	sig = Pluck.ar(exc, 1, 0.2,freq.reciprocal,dcy,coef:coef) * amp;
	DetectSilence.ar(sig, 0.0001, 0.01, doneAction:2);
	Out.ar(out, Pan2.ar(sig,pan));
}).add
);

~root = {0};//{Pseq([0,2,7,0], 1)}

(
t = Task({
	var stream = Pseq([0, 3, 1], inf).asStream;
	loop({
		var note = stream.next;
		//note.postln;
		~root = { note; };
		wait(4);
	});
})
)
t.play;

p.stop(4);

(
// see "Undestranding Stream, Patterns, Events - pt.5"
~phrase = Pbind(
	\instrument, \pluck,
	\detune, Pwhite(-1, 1, inf),
	\octave, 4,
	\root, Pkr(~root),
	\coef, 0.01,
	\dur, 0.15,
	\dcy, 0.1,
	\gtranspose, Pwhite(-0.1, 0.1, inf),
    \degree, Pseq([
        Pshuf(#[-7,-3,0,2,4,7], 4)+[0,4],
		Pseq( [0,1,2,3,4,5,6,7].scramble )+[0,2]
    ], inf),
	\pan, Pwhite(-0.7, 0.7, inf),
	\amp, 1.0
);
)

~phrase.play;
~phrase.quant_(4);
~phrase.set(\octave, 4).quant_(8);
~phrase.set(\coef, 0.8);
~phrase.set(\dcy,1).quant_(4);
~phrase.set(\mtranspose, 0).quant_(8);
~phrase.stop; ~in=nil;

~mod = {LFPar.kr(1).range(0.01, 0.3)}
~mod = {0.001}
~vol = {SinOsc.kr(1).range(0.6, 1.0)}
~vol = {0.0};
~phrase.set(\coef, ~mod);
~phrase.set(\amp, ~vol);
~phrase.set(\gtranspose, 1);
~phrase.set(\dcy, 0.3);

~phrase.clear;
s.plotTree;

p.makeTempoClock
p.clock.tempo_(60/60);

~in.ar;
~room = {100};
~time = {3};
~damp = {0.6};
~verb = {GVerb.ar(~in, ~room, ~time, ~damp)};
~in = ~phrase*0.1;
~verb.play;
~verb.stop(4);
~verb.clear;

s.scope
s.meter