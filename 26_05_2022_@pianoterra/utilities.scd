Pbindef.gui;
//stop all
Pbindef.all.do({ |item| item.stop; });
Tdef.all.do({ |item| item.stop; });


// kill the zombies
(
a = Synth.basicNew(\synthDefName, nodeID:);
a.free;
)




// metronome
(
Pbindef(\metronome,
	\instrument, \metronome,
	\freq, Pseq([1500, 1000.dup(3)].flat, inf),
	\dur, 1,
	\amp, 1,
	\rel, 0.01,
	\addAction,1
).quant_([4,0]).stop.play;
)
Pbindef(\metronome).stop;
Pbindef(\metronome).clear;


s.scope
s.meter