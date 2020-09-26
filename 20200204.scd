(
Pbindef(\fm,
	\instrument, \fm1,
	\scale, Scale.minor,
	\octave, Prand([6],inf),
	\degree, Pstutter(16, Pseq([0,-1,-2,-1],inf),inf) + Pseq([[0,2,4]],inf),
	\mf, 1000, //Pwhite(1, 2000,inf), //Pseries(100, 100, inf).wrap(100,1600),
	\mi, 100, //Pwhite(10,1000, inf), //Pseries(1, 10, inf).wrap(10,320),
	\atk, 0.01,
	\rel,0.1,
	\dur,0.125,
	\amp,0.3
).quant_(1).play;
)

(
Pbindef(\fm_chirp,
	\instrument, \fm1,
	\degree, Prand([0,2,3,4,6],inf),
	\octave, Pwhite(0, 8, inf).round(1),
	\atk, 0.01, \rls, 1/(Pkey(\dur)*4),
	\dur, Pbjorklund2(Prand((1..3),inf), 8, inf)/8,
	\mi,  Pwhite(0.0, 1000, inf),
	\mf,  Pwhite(1, 1000, inf),
	\pan, Pwhite(-0.8, 0.8),
	\amp, Pwhite(0.1, 0.9)
).quant_(4).play;
);

Pbindef(\fm_chirp).play;
Pbindef(\fm_chirp).stop;

(
Pbindef(
	\sinfb,
	\instrument, \sinfb,
	\octave, Prand([4,5],inf),
	\scale, Scale.minor,
	\degree, Pstutter(16, Pseq([0,3,-2,-1],inf),inf) + Pseq([[0,2,4]], inf),
	\detune, Pwhite(0.0, 4, inf).clump(4),
	\fb, Pseries(0.0, 0.1, inf).wrap(0.0, 0.8), //Pwhite(0.1, 1, inf),
	\atk, 0.01,
	\rel, 1,
	\dur, 0.25,
	\amp, 0.2,
	\pan, Pwhite(-0.8, 0.8, inf).clump(3)
).quant_(4).play;
)

Pbindef(\sinfb).stop;

(
Pbindef(\bass_lick,
	\instrument, \doublebass,
	\octave, [3,4],
	\degree, Prand([0,-1,4,7],inf),
	\atk, 0.0,
	\fc, 1000, //Pwhite(10, 60, inf),
	\rel, 0.5,
	\detune, Pwhite(0.0,2,inf).clump(2),
	\dur, Pwrand([0.75,0.25,0.5, Pn(0.125,2)],[0.1, 1, 0.5,0.1].normalizeSum,inf),
	\amp, 0.7, //Pseg(Pseq([0.0, 1.0],inf), Pn(8,inf), inf),
	//\bus, ~fxsend,
	//\send, Pseries(0.0, 0.01, inf).wrap(0.0, 1.0)
).quant_(1).play;
)



Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1).quant_(4).play;
(
Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],
	\dur,Pseq([0.5, Pseq([1],inf)],inf),
	\amp,Pseq([\rest, Pseq([1],inf)],inf),
	\rate, 0.5,
	\rel, 0.1).quant_(4).play;
)
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,0.7)).quant_(4).play;


(
MIDIdef.noteOn(\stacco1, {
	arg ...args; args.postln;
	Pbindef(\k).stop;
	Pbindef(\sn).stop;
	Pbindef(\hh).stop;
},36);
)

(
MIDIdef.noteOn(\stacco2, {
	arg ...args; args.postln;

	Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1).quant_(1).play;
	(
		Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],
			\dur,Pseq([0.5, Pseq([1],inf)],inf),
			\amp,Pseq([\rest, Pseq([1],inf)],inf),
			\rate, 0.5,
			\rel, 0.1).quant_(1).play;
	);
	Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,0.7)).quant_(1).play;


	//Pbindef(\k).quant_(1).play;
	//Pbindef(\sn).quant_(1).play;
	//Pbindef(\hh).quant_(1).play;
},38);
)
MIDIdef.all;


MIDIdef.noteOn(\matchAllMIDInoteOn, {arg ...args; args.postln;});



(
MIDIdef.noteOn(\kick, {
	arg ...args; args.postln;
	Synth(\bplay,[\buf,d["k"][0],\dur,1,\amp,1]);
},45);
)

(
MIDIdef.noteOn(\snare, {
	arg ...args; args.postln;
	Synth(\bplay,[\buf,d["s"][0],\dur,1,\amp,0.7,\rel,0.1,\rate, 0.5]);
},51);
)

(
MIDIdef.noteOn(\stacco1, {
	arg ...args; args.postln;

	Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,2,\amp,1).quant_(1).play;
	(
		Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],
			\dur,Pseq([0.5, Pseq([0.5],2)],inf),
			\amp,Pseq([\rest, Pseq([1],inf)],inf),
			\rate, 0.5,
			\rel, 0.1).quant_(1).play;
	);
	Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.125,\amp,Pexprand(0.05,0.7)).quant_(1).play;

},49);
)


