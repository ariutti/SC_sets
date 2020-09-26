// very interesting Bell pattern
"mySetup/mySetup.scd".loadRelative;

Scale.directory

~bell = Pbind(\instrument, \bell1, \degree, Pxrand(Scale.minorPentatonic, inf), \octave, Pwhite(-2, 0, inf).round(1), \root, 60, \pitchy,Pwhite(0.99, 1.01, inf),\t60, Pwrand([0.1, 0.4, 3],[1,4,2].normalizeSum, inf), \atk, 0.0001, \rls, 0.0125,\dur,Pbjorklund2(Prand([3, 7, 9, 5], inf),8, inf)/4, \amp, Pexprand(0.3, 0.5, inf), \pan, Pwhite(-0.8, 0.8));
~bell.play;
~bell.stop;

p.pop;

(instrument:\bell1, dur:10, freq:800,t60:1,atk:0.001,rls:0.125).play;
x=Synth(\bell1, [\dur,10, \freq,440,\pitchy,0.25,\t60,1,\atk,0.001,\rls,0.125])


(
~bell.stop;
~in = ~bell;
~verb = {FreeVerb.ar(~in, 0.3, 0.99, 0.6)};
~verb.play;
)

~k = Pbind(\instrument, \bplaym, \buf, d["k"][0], \amp, 0.8, \dur, Pbjorklund2(1, 8, inf)/8)
~k.play;

~sn = Pbind(\instrument, \bplaym, \buf, d["sn"][0], \amp, 0.7, \rate, 0.5, \dur, Pseq([1, Pseq([2], inf)], inf))
~sn.play;

(
~bass = Pbind(\instrument, \acid,
	\scale, Scale.minorPentatonic,
	\degree, Pseq([Pser([0], 4), Pser([0], 3), 5, 7],inf), \octave, -3, \root, 60,
	\dur, Pseq([1,1,1,1,1,1,1,0.5, 0.5],inf),
	\amp, 0.8,
	\atk,0.01, \dcy, 0.1, \sus,0.3,\rel, 0.25,
	\rf, 5000, \rq, 0.1,
	\fatk,0.01,\fdcy,0.2,\fsus,0.1,\frel,0.2,
	\legato, 0.6,
)
)
~bass.play;

p.stop(10);


