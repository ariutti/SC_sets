// A live code set which is using modartt Pianoteq as a MIDI instrument
// Everything here is greatly inspired by the beautiful Live code
// tutorials by co34pt (tutorial link: https://theseanco.github.io/howto_co34pt_liveCode/)

"Setup/Setup.scd".loadRelative;

MIDIClient.init;

p.clear;

(
~piano = Pbind(
    //specifies type of message sent
    \type, \midi,
    //specifies type of midi message
    \midicmd, \noteOn,
    //the MIDI Out used
	\midiout, MIDIOut(0),
    //the MIDI channel
    \chan, 0,
    //The rest of the pattern
    \scale, Scale.minor,
	\amp, Pwhite(0.25, 0.7)*0.2,
	\degree, Pseq([1,[3,7],2,3,4,5,[1,2,4],6,7,8,[1,5,7]].pyramid(0)-1,inf),
    \octave, 4,
	\dur, 0.5,// + Pwhite(-0.01, 0.01, inf),
    \legato, 0.2
);
)

(
~sinfb = Pbind(\instrument,\sinfb,\freq,36.midicps,\dur,Pseq([0.25, Pseq([4],inf)],inf),\amp,0.1,\fb,0.9,\rel,4);
~sinfb.play;
~modulator = {SinOsc.ar(0.25).range(0.01, 0.9)};
~sinfb.set(\fb, ~modulator);
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,0.2,\rate,1);
~k.play;
)

~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1, 0.25].stutter(4), inf),\amp,0.2,\rate,Pseq([1,1.2], inf));


(
~sinfb.play;
~k.play;
)

(
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,0.15);
~oh.play;
)

~k.stop;
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1, 0.25].stutter(4), inf),\amp,0.2,\rate,Pseq([1,1.5], inf));
~sinfb.stop;
~oh.stop;
)