

// vocals

~idro = Buffer.readChannel(s, "/home/nicola/Bitwig Studio/Projects/idro_modified/bounce/hello-bounce-1.wav", channels:0);
Pbindef(\idro,\instrument,\bplaym,\buf,~idro,\dur,13*4,\amp,1.25,\rel,13*4*t.beatDur,\rate,1.005,\addAction,Pseq([1]P,1)).quant_([4,0]).stop.play;

d["idro"][1]

// random
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pindex(d["idro"], Pxrand((0..(d["idro"].size-1)),inf),inf),
	\dur,4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,0]).stop.play;
)


// molte cose
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][2]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,0.75]).stop.play;
)


// dicon che seguo la corrente, ma non è proprio così
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][1]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,10*t.beatDur,
	\rate,1.0,
	\addAction,1
).quant_([4,-0.15]).stop.play;
)


// ciao sono idro
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][0]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,0]).stop.play;
)

// non ci penso mai
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][3]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,0]).stop.play;
)

// per me non è facile
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][4]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,-0.125]).stop.play;
)


// ho sempre una fomra diversa
(
Pbindef(\idro,
	\instrument,\bplay,
	\buf, Pseq([d["idro"][7]],1),
	\dur, 4 * 2,
	\amp,1,
	\rel,4*2*t.beatDur,
	\rate,1.005,
	\addAction,1
).quant_([4,0.37]).stop.play;
)
