// most interesting thing here is the plin synth and the minor chord progression
// with gated pads and bass melody line!

"./mySetup/mySetup.scd".loadRelative;

//start proxyspace
p=ProxySpace.push(s);
//start tempo clock
p.makeTempoClock;
p.clock = TempoClock.default;
//give proxyspace a tempo
p.clock.tempo = 120/60;
p.clear;



(
SynthDef(\plin, {
	|freq=440, pan=0.0, out=0, amp=1.0, atk=0.01, rel=0.3|
	var env, sig;
	env = EnvGen.ar(Env.perc(atk, rel),doneAction:2);
	sig = LFPar.ar(freq) * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


(
~r = Pbind(\instrument, \plin,\octave,Pwhite(4,5,inf).round(1),\scale, Scale.minor, \degree,Pseq([0,7].pyramid(5),inf),\amp,0.5,\dur,Pbjorklund2(Pwhite(1,3).round(1),8,inf)/4,\atk, 0.0, \rls,0.3, \gtranspose, Pwhite(-1, 1, inf));
~bass = Pbind(\instrument, \plin,\octave,3,\scale, Scale.minor, \degree,0,\amp,0.5,\dur,Pbjorklund2(3,8,inf)/4,\rel, 0.3);
)

~r.play; ~dly.play;
~r.stop; ~dly.stop;

(
~r.play;
~bass.play;
)

~k.play; ~sn.play; ~hh.play;
~k.stop; ~sn.stop; ~hh.stop;
~clap.stop; ~bass.stop;

~verb.stop; ~dly.stop;
~h.stop
~pads.stop(6)
~r.stop(1)



~pads = Pbind(\instrument, \plin,\octave,5,\scale, Scale.minor, \degree,Pseq([Pn([0,2,4,7], 16),Pn([0,3,5,7], 16)],inf),\amp,0.1,\dur,0.25, \atk, 0.01, \rel,0.2);

~pads = Pbind(\instrument, \plin,\octave,5,\scale, Scale.minor, \degree,Pseq([[0,2,4,7],[0,3,5,7]],inf),\amp,0.07,\dur,8, \atk, 4, \rel,4);

~pads.play;

~dly.ar;
~dly = {CombN.ar(~r!2, 2, 0.25, 1)}
~in.ar; ~verb.ar;
~in = ~r + ~clap + ~dly;
~verb = {FreeVerb.ar(~in, 0.8, 0.7, 0.6)}
~verb.play;

(
~k = Pbind(\instrument, \bplaym, \buf, d["k"][0], \amp, 0.4, \dur, 1);
~sn = Pbind(\instrument, \bplaym, \buf, d["s"][0], \amp, 0.25, \dur, Pseq([1, Pseq([2],inf)], inf));
~k.play; ~sn.play;
)

~h = Pbind(\instrument, \bplay, \buf, d["ch"][0], \amp, 0.25, \dur, Pseq([0.5, Pseq([1],inf)], inf));
~h.play;

~clap = Pbind(\instrument, \bplaym, \buf, d["c"][0], \amp, 0.125, \dur, Pseq([1, Pseq([2],inf)], inf));
~clap.play;