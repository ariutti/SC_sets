// initialize MIDI devices
MIDIClient.init

//up-down riff
//harmonic series version
//re-evaluate individual directions to create a different riff

p.clock.tempo = 2;
~r = {67};

// piano bass line
~sinfb3 = Pbind(\type,\midi,\midicmd,\noteOn,\midiout,MIDIOut(0),\chan,0, \octave,3,\degree, 0,\dur,0.5,\amp,Pwhite(0.2, 0.3),\legato, 0.2);
~sinfb3.clear(0.1)

// play some chords
// using Ptuple to get different octaves for differnet notes
(
~sinfb = Pbind(\type,\midi,
	\midicmd,\noteOn,
	\midiout,MIDIOut(0),
	\chan,0,
	\scale, Scale.chromatic,
	\octave, Ptuple([Prand([4,5],inf), Prand([5],inf), Prand([5,6],inf)], inf),
	\degree, Pseq([\C,\Am,\Em,\F].chordProg,inf),
	\dur,Pbjorklund2(3, 8,inf)/2,
	\amp,Ptuple([Pwhite(0.2,0.3),Pwhite(0.2,0.3),Pwhite(0.2,0.3)],inf),
	\stretch, Pwhite(0.95,1.05, inf),
	\legato, 0.9
);
~sinfb.play
)

// don't know why we have to use input 2 and 3 instead of 0 and 1
// maybe because 0 and 1 are reserver for monitoring the hardware output?
~in = {In.ar(2, 2)}
~in.play;
~in.stop;


~pitch = {PitchShift.ar(~in, 0.4, 1.0, SinOsc.kr(0.1).range(0.01, 0.05), SinOsc.kr(0.75).range(0.01, 0.09))}
~pitch.play;
~pitch.stop(4);


// use this methods to kill the MIDI NodeProxy
~sinfb3.clear(1);
~sinfb.clear(4)

