p = ProxySpace.push(s.boot);
p.makeTempoClock;
p.clock.tempo_(110/60);
StageLimiter.activate;

MIDIClient.init;
MIDIIn.connectAll;

~midiPattern.clear; ~a.clear; ~b.clear; ~c.clear; ~d.clear;

// Note On
(
~midiPattern = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
	\scale, Scale.major,
	\root, 0,
    \degree, Pseq([0],inf),
	\amp, Pseq([0.5, 0.2, 0.2, 0.1], inf),
    \octave, 3,
    \dur, 0.5,
    \legato, 0.4
);
)

(
~a = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
    \scale, Scale.major,
    \degree, Pseq([0, 4, 5],inf),
	\amp, Pseq([0.25, 0.1, 0.1], inf),
    \octave, 7,
	\dur, Pbjorklund2(3, 8, inf)/4,
    \legato, 0.4
);
)

(
~b = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
    \scale,Scale.major,
    \degree, Pseq([0,8],inf),
	\amp, Pwhite(0.1, 0.5, inf),
    \octave, 8,
	\dur, Pbjorklund2(Pwhite(3, 5).round(1), 8, inf)/4,
    \legato, 0.4
);
)

(
~c = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
    \scale,Scale.major,
	\degree, Pseq([0,1,2,3,4,5,6,7,8].pyramid(1),inf),
	\amp, Pwhite(0.2, 0.5, inf),
	\octave, Pwhite(4,5,inf).round(1),
	\dur, Pbjorklund2(Pwhite(3, 5).round(1), Prand([4, 8],inf), inf)/4,
	\legato, Pwhite(0.1, 0.8, inf)
);
)


(
~d = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
    \scale,Scale.major,
	\degree, Pseq([[0, 2],[0,4], [0,5], [0,2]], inf),
	\amp, 0.6,
    \octave, 6,
	\dur, 3,
	\legato, 3
);
~sustain = Pbind(
	\type,\midi,
	\midiout,MIDIOut(0),
	\chan, 3,
	\midicmd, \control,
	\ctlNum, 64, // sustain pedal
	\control, Pseq([127, 0], inf),
	\dur, Pseq([2.89, 0.11],inf)
)
)
~sustain.clear
