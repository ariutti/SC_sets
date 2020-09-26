MIDIClient.init;
m = MIDIOut(0);
m.control(3, 64, 127);
m.control(3, 64, 0);



(
Tdef(\ct, {
	var prog = Pseq([0,3,-2], inf).asStream;
	loop{
		~tonica = prog.next;
		~tonica.postln;
		Pbindef(\phraseA).stop;
		m.control(3, 64, 0);
		0.125.wait;
		m.control(3, 64, 127);
		(4-0.125).wait;
	};
}).quant_(4).play;
)
Tdef(\ct).stop;
(
Pbindef(
	\piano_test,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
	\scale, Scale.major,
	\root, 0,
	\octave, Pwrand([4,5,6],[0.1,0.9,0.1].normalizeSum, inf),
	\degree, Pfunc({~tonica}) + Pseq([0,2,4], inf).collect({|deg| [deg, deg+4, deg+7]}),
	\amp, Pgauss(0.02, 0.003, inf),
	\dur, Pseq([0.125], inf),
	\atk, 0.01,
	\dcy, 0.1,
	\rel, 8,
	\strum, 0.1,
	\lag, Pwhite(0.0, 0.03, inf),
	\legato, 1.5
);
)

Pbindef(\piano_test).stop;

(
Pbindef(
	\phraseA,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
	\scale, Scale.major,
	\root, 0,
	\octave, Pseq([3,4], inf),
	\degree, Pseq([0], 4),
	\amp, Pgauss(0.6, 0.03, inf),
	\dur, Pseq([0.5], inf),
	\atk, 0.01,
	\dcy, 0.1,
	\rel, 8,
	\strum, Pwhite(-0.01, 0.01, inf),
	\lag, Pwhite(0.0, 0.03, inf),
	\out, ~octagon_bus,
	\pan, Pwhite(-1.0, 1.0, inf),
	\legato, 1.2
).quant_(4);
)
Pbindef(\phraseA).play;



(
Pbindef(
	\piano_test,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
	\scale, Scale.major,
	\root, 0,
	\octave, Pseq([6,5],inf), //Pwrand([4,5,6],[0.1,0.9,0.1].normalizeSum, inf),
	\degree, 0 + Prand([[0,4],2,4,7], inf),
	\amp, Pgauss(0.5, 0.03, inf),
	\dur, Pseq([0.125], inf),
	\atk, 0.01,
	\dcy, 0.1,
	\rel, 8,
	\legato, 0.8,
	\lag, 0.0,
	\strum, 0
);
)