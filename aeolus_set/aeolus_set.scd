// use it with aeolus
MIDIClient.init;

~myScale = Scale.new(#[0,2,3,5,7,9,10], 12);

(
Pbindef(
	\organ,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 0, // MIDI channel 4
	\scale, ~myScale,
	\root, 0,
	\octave, Pstutter(2, Pseq([4,5],inf)),
	\degree, Pseq([
		0,Prand([1,2,3,4], 1),6,
		0,Prand([1,2,3], 1),4
	],inf),
	\amp, Pgauss(0.5, 0.1,inf),
	\dur, Pseq([0.5,0.5,0.5], inf)*0.33,
	\lag, Pwhite(0.0, 0.01,inf)
	\sustain, 0.1
).quant_(4);
)
Pbindef(\organ).reset.play;
Pbindef(\organ).stop;

(
Pbindef(
	\chords,
	\type, \midi,
    \midicmd, \noteOn,
	\midiout, MIDIOut(0),
    \chan, 3, // MIDI channel 4
	\scale, ~myScale,
	\root, 0,
	\octave, [4],
	\degree, Pstutter(2, Pseq([[0,4], [2,6], [-1,3]],inf)),
	\amp, Pgauss(0.5, 0.1,inf),
	\dur, 8,
	\lag, 0.0, //Pwhite(0.0, 0.01,inf),
	\stretch,1
).quant_(4);
)

Pbindef(\chords).clear;
Pbindef(\chords).stop;
Pbindef(\chords).reset.play;


{Out.ar(0, In.ar(2, 2))}.play;
s.scope
s.volume_(1.0);
s.unmute