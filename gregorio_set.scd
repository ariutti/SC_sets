// interesting morbid pads (violins)
// and strong BASS made with ring1 synth

"mySetup/mySetup.scd".loadRelative;
p.clock.tempo_(61/60)

~root = {5};

~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,16,\rate,0.7);
~k.quant(1);
~k.play;
~k.stop;

~sn = Pbind(\instrument,\bplay,\buf,d["s"][3],\dur,Pbjorklund2(Pwhite(1,5).asStream.round(1),8, inf,Pwhite(1,5).asStream.round(1))/4,\amp,0.4,\rate, 0.5);
~sn.quant(2);
~sn.play;
~sn.stop;

~hh = Pbind(\instrument,\bplay,\buf,d["oh"][0],\dur,0.25,\amp,3, \rate, 2);
~hh.play;
~hh.stop;
~hh.clear;

(
~clap[0] = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,4,\amp,0.2, \rate, 0.7);
~clap[1] = \filter -> {|in| GVerb.ar(in, 100, 3, 0.6)};
~clap.play;
)
~clap.stop
~clap.quant(3);

(
~k.stop;
~sn.stop;
~hh.stop;
~clap.stop;
)

(
~k.quant(1);
~k.play;
~sn.play;
~hh.play;
~clap.play;
)

~fx = Pbind(\instrument,\bplaym,\buf,Pfunc({d["numbers"].choose();}, inf),\dur,4,\amp,1,\rate, 1.3);
~fx.play;
~fx.stop






~fx.quant(2);

d.keys

~bass.stop; ~k.stop; ~sn.stop; ~hh.stop; ~fx.stop; ~clap.stop; ~rings.stop; ~verb.stop;
~bass.play; ~k.play; ~sn.play; ~hh.play; ~fx.play; ~clap.play; ~rings.play; ~verb.play;
~





~bass = Pbind(\instrument,\squarebass,\root,0,\scale, Scale.major, \degree, Pkr(~root), \octave, 4, \dur,Pbjorklund2(5, 8, inf)/4,\amp,2,\rel, 0.125, \width, Pwhite(0.3, 0.5, inf), \detune, 0.8);
~bass.play;

~violins = Pbind(\instrument,\sinfb,\root,0,\scale, Scale.major, \degree, Prand([0, 2, 4], inf)+0, \octave, 5, \dur,Pbjorklund2(4, 4, inf)/4,\amp, Pwhite(0.1, 0.2,inf), \fb, Pwhite(0.5, 0.8, inf), \atk, 0.1, \rel, 0.7, \pan, Pwhite(-0.8, 0.8, inf));

~violins.play(fadeTime: 10);
~violins.stop(10);

~in = ~rings * 1;
~room = 100;
~time = 3;
~verb = {CombN.ar(~in, 4, 0.5, 0.5)}
~verb.stop;
~verb.play;

// POWER BASS!!!
(
~rings = Pbind(
	\instrument,\ring1,
	\root, 0,
	\scale, Scale.major,
	\degree, [0, 7], //Pseq([0, 7], inf), // Pkr(~root),
	\octave, 3, //Prand([2, 3,4], inf),
	\dur, 1, //Pseq([0.5, Pn(0.25, 2)], inf),
	\amp, 0.3, //Pseq([0.6, 0.1], inf),
	\a, 150, //Pseq([10, 150], inf),
	\d, 0.7 ,//Pwhite(0.01, 0.2,inf),
	\pan, 0.0);
)
~rings.play(fadeTime:12);
~rings.stop(10);


p
~clap.stop
~sn.stop
~hh.clear
s.meter;
~fmbass.stop(12)
