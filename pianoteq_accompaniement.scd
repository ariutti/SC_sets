(
Pbindef(\miditest,
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
	\root, 4,
    \chan, 3, // MIDI channel 4
    \scale, Scale.minor,
	\octave, Prand([4],inf),
	\degree, Pstutter(8, Pseq([0,5,4,-1,3,0], inf),inf) + Pseq([[-5, 0], [-1,4], [9-5,9], [14-5,14]], inf),
    \dur, 0.125,
	\amp, Pgauss(0.3, 0.1, inf),
	\strum, Pwhite(-0.03, 0.03, inf),
	\lag, Pwhite(0.0, 0.03, inf),
	\legato, 0.4
);
Pbindef(\melody).stop;
)

Pbindef(\miditest).play;
Pbindef(\miditest).set(\amp, 0.7);

Pbindef(\miditest).stop;

(
Pbindef(\melody,
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
	\root, 4,
    \chan, 3, // MIDI channel 4
    \scale, Scale.minor,
	\octave, Pseq([6],inf),
	\degree, 0 + Pstutter(Prand((1..1),inf), Pseq([0,4,7, 11], inf)),
    \dur, 0.125,
	\amp, Pgauss(0.2, 0.1, inf),
	\strum, Pwhite(-0.01, 0.01, inf),
	\lag, Pwhite(0.0, 0.02, inf),
	\legato, 0.2
);
)

Pbindef(\melody).play;
Pbindef(\melody).stop;