// a simple set which uses noise and sines and square waves to play a little happy song!

"./mySetup/mySetup.scd".loadRelative;

//start proxyspace
p=ProxySpace.push(s);
p.makeTempoClock;
p.clock = TempoClock.default;
//give proxyspace a tempo
p.clock.tempo = 120/60;

(
SynthDef(\noise, {
	|out=0, amp=1.0, pan=0.0, atk=0.01, rel=0.4|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = LFNoise0.ar() * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\kick, {
	|out=0, freq=60, amp=1.0, pan=0.0, atk=0.01, rel=0.4|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


(
SynthDef(\white, {
	|out=0, amp=1.0, pan=0.0, atk=0.01, rel=0.4|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = WhiteNoise.ar() * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\square, {
	|out=0, freq=440, amp=1.0, pan=0.0, atk=0.01, rel=0.4, width=0.3|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = LFPulse.ar(freq, width:width) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

Synth(\noise, [\amp, 0.5]);
Synth(\square, [\amp, 0.2, \width, 0.2]);

~bass = Pbind(\instrument, \square, \octave, 4, \degree, 0, \dur, Pbjorklund2(3,8,inf)/4);
~bass.play;

~melody = Pbind(\instrument, \square, \octave, 5, \degree, Pseq([0,2,4,7].pyramid(2), inf), \dur, Pbjorklund2(3,8,inf)/8, \pan, Pwhite(-0.8, 0.8, inf));
~melody.play;

~melody1 = Pbind(\instrument, \square, \octave, 6, \degree, Pseq([0,2,4,7].pyramid(5), inf), \dur, Pbjorklund2(Pwhite(1,5).round(1),8,inf)/8, \pan, Pwhite(0.0, 0.8, inf));
~melody1.play;

~melody2 = Pbind(\instrument, \square, \octave, 6, \degree, Pseq([0,2,4,7].pyramid(5), inf), \dur, Pbjorklund2(Pwhite(1,3).round(1),8,inf)/8, \pan, Pwhite(-0.8, 0.0, inf));
~melody2.play;

~sn = Pbind(\instrument, \noise, \dur, Pseq([1, Pseq([2],inf)], inf), \rel, 0.2, \amp, 0.6);
~sn.play;

~hh = Pbind(\instrument, \white, \dur, Pseq([0.5, Pseq([1],inf)], inf), \rel, 0.1, \amp, 0.3);
~hh.play;

~k = Pbind(\instrument, \kick, \dur, 1,\freq, 65, \rel, 0.3, \amp, 3);
~k.play;



