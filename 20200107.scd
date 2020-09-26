m = MIDIOut(0);
m.control(3, 64, 0);
m.control(3, 64, 127);

(
Pbindef(
	\piano_test,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3,
	\scale, Scale.major,
	\root, 0,
	\octave, Pwrand([4,5,6],[0.1,0.9,0.1].normalizeSum, inf),
	\degree, Pseq([0,2,4], inf).collect({|deg| [deg, deg+4, deg+7]}),
	\amp, 0.3
	\dur, 1
);
)