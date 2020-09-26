"mySetup/mySetup.scd".loadRelative;

(
Tdef(\arp, {
	~arpeggio.ar(2);
	~arpeggio.play;
	loop{
		"arpeggio".postln;
		~arpeggio = Pbind(\instrument, \fm1, \scale, Scale.minor, \degree, Pseq([0, 1, 4], 3), \octave, 6, \atk, 0.001, \rls, 1/(Pkey(\dur)*4), \dur,Pseq([0.5, Pbjorklund2(2, 8, inf)/16],inf), \mi, Pexprand(100, 1000, inf), \mf, Pexprand(1000, 10000, inf), \pan, Pwhite(-0.8, 0.8), \amp, Pseries(0.9, -0.125, inf));
		8.wait;
	};
}).play;
)

~verb.ar(2);
~verb.play;
~in = ~arpeggio;
~verb = {FreeVerb.ar(PitchShift.ar(CombN.ar(~in, 4, 0.257, 1.0)!2, 0.1, 2.0, 0.1, 0.1), 0.9, 0.6, 0.2)}
~in.clear
~verb.clear

~bass = Pbind(\instrument, \squarebass,\degree, Pseq([0, 4, 5, 7], inf), \octave, 2, \scale, Scale.minor, \dur, Pseq([Pser([1], 2),2], inf)/Prand([2,4],inf), \width, 0.3, \amp, 1, \detune, 0.1 );
~bass.play;

~k = Pbind(\instrument, \bplay, \buf, d["k"][0], \amp, 0.8, \dur, Pbjorklund2(1, 8, inf)/8)

~sn = Pbind(\instrument, \bplay, \buf, d["sn"][0], \amp, 0.7, \rate, 0.5, \dur, Pseq([1, Pseq([2], inf)], inf))

(
~k.play;
~sn.play;
)

p.stop(3)
p.clear