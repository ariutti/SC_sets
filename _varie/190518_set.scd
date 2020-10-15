// set 2019-05-18
// angry drum + subkick
// acid bass
// hey
// orchstral hit


//start proxyspace
p=ProxySpace.push(s);
p.makeTempoClock;
p.clock = TempoClock.default;
p.clear


"./mySetup/mySetup.scd".loadRelative;

p.clock.tempo_(120/60)
p.quant_(4)

d.keys

(
~k = Pbind(\instrument, \bplay, \buf, d["k"][0], \dur, Pbjorklund2(Pwhite(2,4).asStream.round(1),8,inf, Pwhite(0.5, 4).asStream.round(0.5))/4, \amp, 0.5);
~sn = Pbind(\instrument, \bplay, \buf, d["s"][3], \dur, Prand([Pseq([0.125], 8), Pbjorklund2(Pwhite(2,4).asStream.round(1),8,12, Pwhite(0.5, 4).asStream.round(1))/4], inf), \amp,0.5, \rate, Pwhite(0.8, 1.2, inf));
~k.play;
~sn.play;
)

~hh = Pbind(\instrument, \bplay, \buf, d["ch"][0], \dur, Pseq([0.5, Pseq([1],inf)],inf), \amp,0.4);
~hh.play;


~clap = Pbind(\instrument, \bplay, \buf, d["c"][0], \dur, 2, \amp,0.7);
~clap.play;

~sk[0] = Pbind(\instrument, \bplay, \buf, d["sk"][0], \dur, 1, \amp, 0.8);
~sk.play;
~sk[1] = \filter -> {|in| FreeVerb.ar(in, 0.8, 0.7, 0.2)}
~sk.set(\wet1, 0.1);
~sk.clear(4)


out=0,
amp=1, freq=440, pos=0.0,
gate=1,
atk=0.01, dcy=0.05, sus=0.7, rel=0.5,
rf=440, rq=0.1,
fatk=0.01, fdcy=0.05, fsus=0.7, frel=0.5

(
~acid.quant_(4);
~acid = Pbind(
	\instrument, \acid,
	\scale, Scale.minor,
	\octave, 4,
	\degree, Prand([0], inf),
	\atk, 0.0,
	\rel, 0.01,
	\fatk, 0.25,
	\fdcy, 0.1,
	\fsus, 0.01,
	\frel, 0.001,
	\rf, 2000,
	\dur, 0.5 + Pbjorklund2(3, 8, inf)/4,
	\amp, 0.5
);
~acid.play;
)

~k.stop; ~sn.stop; ~hh.stop; ~clap.stop; ~sk.stop; ~acid.stop;
~k.play; ~sn.play; ~hh.play; ~clap.play; ~sk.play; ~acid.play;



a = Buffer.readChannel(s, "/home/nicola/Musica/SC_set/mySamples/shout/4.wav", channels:0);

~hey.set(\amp, 0.5);
~hey[0] = Pbind(\instrument, \glinem, \buf, a, \dur, 7, \amp, 1, \rate, Pwhite(0.8, 1.2, inf), \density, 1);
~hey.play;
~hey[1] = \filter -> {|in| FreeVerb.ar(in, 1, 0.6, 0.5)}
~hey.set(\wet1, 0)
~hey.clear(4)

d.keys
~orch = Pbind(\instrument, \bplay, \buf, d["orchestrahit"][0], \dur, Prand([0.5, 0.25, 0.25]*4, inf), \rate, Pseq([1, 2, 2], inf), \amp, 3, \pan, 0.6)
~orch.play;

~numbers.set(\amp, 0.4)
~numbers.fadeTime_(0.01)
~numbers[0] = Pbind(\instrument, \bplaym, \buf, Pindex(d["numbers"], Prand((0..5),inf), inf), \amp, 0.5, \rate, 1.3, \dur, 4,\pan, 0)
~numbers.play;
~numbers.clear;
~numbers[1] = \filter -> {|in| in * Pulse.ar(2)}
~numbers.set(\wet1, 1)


~numbers.stop; ~numbers.stop(4); ~hey.stop(4);
~k.stop; ~sn.stop; ~hh.stop; ~clap.stop; ~sk.stop; ~acid.stop;
~orch.stop;


~sn = Pbind(\instrument, \bplay, \buf, d["s"][3], \dur, 0.5 + 1, \amp,0.5, \rate, Pwhite(0.8, 1.2, inf));
~k = Pbind(\instrument, \bplay, \buf, d["s"][3], \dur, 0.25 + 1, \amp,0.5, \rate, Pwhite(0.8, 1.2, inf));
~clap.stop;
(
~sk.stop; ~orch.stop; ~sn.stop; ~hh.stop;
~fm.quant_(1);
~fm = Pbind(\instrument, \fm1, \degree, Prand([0, 1,2,3,4,5],inf), \octave, Pwhite(0, 8, inf).round(1), \atk, 0.01, \rls, 1/(Pkey(\dur)*4), \dur,Pbjorklund2(Prand((1..3),inf), 8, inf)/8, \mi, Pwhite(0.0, 1000, inf), \mf, Pwhite(1, 1000, inf), \pan, Pwhite(-0.8, 0.8), \amp, Pwhite(0.1, 0.9));
~fm.play;
)

(

~clap.stop;
~acid.stop;
~fm.stop(6);
~k.set(\dur, 1);

~sqBass = Pbind(\instrument, \squarebass,
	\scale, Scale.minor,
	\octave, 3,
	\degree, 0,
	\dur, 2,
	\amp, 2
);
~sqBass.quant_(1);
~sqBass.play;
)

(
~k.stop(5);
~sqBass.stop;
~hey.stop(5);
~sinfb.quant_(1);


~sinfb = Pbind(\instrument, \sinfb,
	\scale, Scale.minor,
	\degree, Prand([[0,2,4],[0,3,5] ], inf),
	\fb, Pwhite(0.1, 1, inf),
	\atk, 2,
	\rel, 10,
	\dur, 8,
	\amp, 0.5,
	\pan, Pwhite(-0.8, 0.8, inf)
);
~sinfb.play;
)

~sinfb[1] = \filter -> {|in| FreeVerb.ar(in, 1, 0.6, 0.3)}
~sinfb.set(\wet1, 0.9);


a = Buffer.readChannel(s, "/home/nicola/Musica/SC_set/mySamples/gab/Crsnred_scr_fx_52.wav", channels:0);

~hey.set(\amp, 0.5);

(
~t = Task({
	loop({
		Synth(\glinem, [\buf, a, \dur, 22, \amp, 0.3, \rate, 0.9, \caos, 1, \density, 50]);
		wait(60);
	});
});
)


~pluck[0] = Pbind(\instrument, \pluck, \dur, Pbjorklund2(3,8,inf, Pwhite(1,5,inf).asStream.round(1))/4, \scale, Scale.minor, \degree, Prand([0,2,5,7], inf), \octave, Prand([4,5], inf), \coeff, Pwhite(0.01, 0.6, inf), \type, Pwrand([\note, \rest], [1, 0.2].normalizeSum, inf));
~pluck.play;
~pluck[1] = \filter -> {|in| CombC.ar(in, 0.5, 0.125, 1)}
~pluck.set(\wet1, 0.5)


p.quant_(4)
~pluck.stop; ~k.stop; ~sn.stop; ~bass.stop; ~sk.stop;
~pluck.play; ~k.play; ~sn.play; ~bass.play; ~sk.play;


~k.fadeTime_(4);
~k = Pbind(\instrument, \bplay, \buf, d["k"][0], \dur, 4, \amp, 0.7);
~k.play;
~k.clear;
~sk.play;
~sn = Pbind(\instrument, \bplay, \buf, d["s"][0], \dur, 2, \amp, 0.7);


(
~bass = Pbind(\instrument, \ring1,
	\a, 10,
	\d, 0.1,
	\dur, Prand([0.25, 0.5], inf), //Pseq([0.25, 0.25, 0.25, 0.25, 4], inf),
	\scale, Scale.minor,
	\degree, Pseq([0, 7], inf),
	\octave, Pseq([3,4], inf),
	\amp,0.4,
);
~bass.play;
)
~mod = {SinOsc.kr(0.25).exprange(10, 100)}
~bass.set(\a, ~mod);


~fm = Pbind(\instrument, \fm1, \scale, Scale.minor, \degree, Pseq([0, 4, 2], inf), \octave, Pwhite(6, 8).round(1), \atk, 0.01, \rls, 0.02, \dur, Pseq([0.25, 1.75, 0.5, 0.5].pyramid(1), inf), \mi, Pwhite(1, 1000, inf), \mf, Pwhite(1, 1000, inf), \pan, 0.0, \amp, 0.5);
~fm.play;

~p = Pbind(\dur, 4)
~p.play;
p.stop(10)


(
SynthDef(\pad, {
	|out=0, freq=440, amp=1.0, pan=0.0, dur=1|
	var sig, env;
	env = EnvGen.ar(Env.triangle(dur), doneAction:2);
	sig = LFPar.ar(freq);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

s.scope;
s.meter;

(
~pad = Pbind(
	\instrument, \pad,
	\scale, Scale.minor,
	\degree, Pseq(#[[0, 0]], inf),
	\pan, Prand([-1, 1], inf),
	\gtranspose, Pwhite(-1, 1, inf),
	\dur, 3
)
)
~pad.play;



