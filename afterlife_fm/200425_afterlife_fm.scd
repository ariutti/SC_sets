// welcome here!
// ralaxing with fm synthesis

TempoClock.default.tempo_(60/60);
Pbindef.gui


(
~pads_degs = [
	[1,1,1],
	[0,2,2],
	[-5,0,1],
	[-4,0,0],
	[-3,0,1],
	[-2,0,2],
	[-3,0,1],
	[-7,0,4]
];
~pads_durs = [3,5,3,5,3,5,3,1+4*4]*0.5;
)

Pbindef(\pads).stop;
Pbindef(\pads,\amp, 0.1, \degree, ~pads_degs[7], \mi, 1500, \octave, Prand([3,4], inf))
(
Pbindef(\pads,
	\instrument, \fm4,
	\dur, 0.125,
	\scale, Scale.major,
	\octave, Prand([4,5,6], inf),
	\degree, Pseq(~pads_degs[0], inf),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\n1, 1, \n2, Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 1.9, inf).clump(3),
	\mi, 400,
	\atk, 4, \rel,4,
	\iatk, 3, \irel, Pkey(\rel),
	\amp, 0.05,
	\pan, Pwhite(-1.0,1.0,inf).clump(3),
	\legato, 0.9,
	\addAction, 0
).quant_([4,0]).play;
)

Pbindef(\leadA).play;
Pbindef(\leadB).play;
Pbindef(\leadC).play;
Pbindef(\s).play;
Pbindef(\k).play;


// thank you!
// see you next time
// goodnight!



(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\padsB).stop;
Pbindef(\padsB,
	\instrument, \fm4,
	\dur, Pseq(~pads_durs,inf),
	\scale, Scale.major,
	\octave, 4,
	\degree, Pseq(~pads_degs, inf),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\n1, 1, \n2, 4,//Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 1.9, inf).clump(3),
	\mi, 100,
	\atk, 1, \rel,2,
	\iatk, 3, \irel, Pkey(\rel),
	\amp, 0.15,
	\pan, Pwhite(-1.0,1.0,inf).clump(3),
	\legato, 0.9,
	\addAction, 0
).quant_([4,0]).stop.play;
)

s.meter

Pbindef(\padsB, \amp, 0.1);
Pbindef(\padsB, \n1,1,\n2,2,\mi,400);
Pbindef(\padsB, \n1,1,\n2,2,\mi,400);
Pbindef(\padsB, \atk,3,\rel,2,\legato,1.5);
Pbindef(\padsB).stop;Pbindef(\s).stop;Pbindef(\k).stop;
s.plotTree

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,1.0);
~verb.free;

~delay = Synth(\delay1, [\dlytime,0.125, \wet,0.0]);
~delay.set(\dlytime,0.1, \decaytime,1, \wet,0.5);
~delay.free;


(
Pbindef(\test,
	\instrument, \fm4_perc,
	\dur, Pbjorklund2(Prand([3,4,5], inf).asStream,8, inf)/8,
	\scale, Scale.major,
	\octave, Prand([5,6], inf),
	\degree, Prand([Prand([-1,0], inf).asStream,2, Prand([4,5],inf).asStream], inf),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\n1, 1, \n2, Pseq([1,2,4,8].pyramid(2), inf),
	\iAdd, 0.0,
	\mi, Pseg([400, 2000, 400], [32,32], \lin, inf),
	\atk, 0.0, \rel,2,
	\iatk, 0.1, \irel, 0.01,
	\amp, Pseq([Pgeom(0.1, -3.dbamp, 4)], inf),
	\pan, Pwhite(-1.0,1.0,inf),
	\addAction, Prand([0,1], inf)
).quant_([4,0]).play;
)
Pbindef(\test).stop;




~leadA_degs = [  0, -1,-3, -3, -1,  0,  0];
~leadA_durs = [0.5,0.5, 1,0.5,0.5,1.5,3.5];
(
Pbindef(\bass).stop;
Pbindef(\padsB).play;
Pbindef(\test).stop;
Pbindef(\leadA,
	\instrument, \fm4_perc,
	\dur, Pstutter(1, Pseq(~leadA_durs,inf)*0.5),
	\scale, Scale.major,
	\octave, 5,
	\degree, Pstutter(1, Pseq(~leadA_degs, inf)),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\n1, 1, \n2, Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 1.9, inf).clump(3), //Pseg([0, 50, 0], [8,8],\lin, inf),
	\mi, Pwhite(100, 1000, inf).clump(3),
	\atk, 0.0, \rel,0.5,
	\iatk, 0.0, \irel, 0.1,
	\amp, 0.1,//Pseq([Pgeom(0.3,-3.dbamp,4)],inf),
	\pan, Pwhite(-1.0,1.0,inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\leadA).stop;
Pbindef(\leadB).stop;


~leadB_degs = [\,2,3,4];
~leadB_durs = [1,1,2,4*5];
(
Pbindef(\leadB,
	\instrument, \fm4_perc,
	\dur, Pstutter(1, Pseq(~leadB_durs,inf)*0.5),
	\scale, Scale.major,
	\octave, Pstutter( ~leadB_degs.size, Prand([5,6],inf)),
	\degree, Pstutter(1, Pseq(~leadB_degs, inf)),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\n1, 1, \n2, Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 1.9, inf).clump(3), //Pseg([0, 50, 0], [8,8],\lin, inf),
	\mi, Pwhite(100, 1000, inf).clump(3),
	\atk, 0.0, \rel,4,
	\iatk, 0.0, \irel, 0.5,
	\amp, 0.1,//Pseq([Pgeom(0.3,-3.dbamp,4)],inf),
	\pan, Pwhite(-1.0,1.0,inf),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\leadB).stop;


~leadC_degs = [\,  0, -1,-3, -3, -1,-4];
~leadC_durs = [1,0.5,0.5, 1,0.5,0.5, 4];
(
Pbindef(\leadC,
	\instrument, \fm4_perc,
	\dur, Pstutter(1, Pseq(~leadC_durs,inf)*0.5),
	\scale, Scale.major,
	\octave, 5,
	\degree, Pstutter(1, Pseq(~leadC_degs, inf)),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\n1, 1, \n2,3,
	\iAdd, 0, //Pseg([0, 50, 0], [8,8],\lin, inf),
	\mi, 4000,
	\atk, 0.1, \rel,6,
	\iatk, 0.0, \irel, 0.5,
	\amp, 0.05,//Pseq([Pgeom(0.3,-3.dbamp,4)],inf),
	\pan, Pwhite(-1.0,1.0, inf),
	\lag, Pwhite(0.0, 0.01, 8),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\leadC).stop;


~leadD_degs = [  1,  2,    2,  2,  2,  1,  2];
~leadD_durs = [1.5,1.5,1+0.5,1.5,0.5,0.5,1+4];
(
Pbindef(\leadD,
	\instrument, \fm4_perc,
	\dur, Pstutter(1, Pseq(~leadD_durs,inf)*0.5),
	\scale, Scale.major,
	\octave, 5,
	\degree, Pstutter(1, Pseq(~leadD_degs, inf)),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\n1, 3, \n2,2,//1
	\iAdd, 0,
	\mi, 4000,
	\atk, 0.0, \rel,2,
	\iatk, 0.1, \irel, 0.5,
	\amp, 0.025,
	\pan, 0.0,
	\lag, Pwhite(0.0, 0.01, 7),
	\addAction, 0
).quant_([4,0]).play;
)
Pbindef(\leadD).stop;

s.scope;


(
~bass_degs = [1,0,-5,-4,-3,-2,-3,-7];
)
(
Pbindef(\bass,
	\instrument, \fm4_perc,
	\dur, 0.25, //Pstutter(4, Pseq(~pads_durs, inf)*0.25),
	\scale, Scale.major,
	\octave, Pseq([[2,3]],inf),
	\degree, [0,0], //Pstutter(4, Pseq(~bass_degs, inf)),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\n1, 1, \n2, 8,//Pseq((1..8),inf),
	\mi, Pseg([400, 1000, 400], [8,8],\lin, inf),
	\iAdd, Pwhite(0.0, 1.0, inf).clump(2),
	\atk, 0.0, \rel,0.5,
	\iatk, 0.01, \irel,0.1,
	\amp, Pseq([Pgeom(0.2,-3.dbamp,4)],inf),
	\pan, 0.0, //Pseq([-1.0,1.0],inf).clump(2),
	\addAction, 1
).quant_(4).play;
)
Pbindef(\bass).stop;
Pbindef(\bass, \iAdd, Pwhite(0.0, 1.0, inf).clump(2));
Pbindef(\bass, \dur, 1, \rel, Pkey(\dur),\amp, 0.3 );

s.meter;

(
//Pbindef(\bass).play;
Pbindef(\k,
	\instrument, \kickFm,
	\freq, 50,
	//amplitude envelope
	\atk, 0.0, \rel, 0.1,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 200, \matk, 0.01, \mrel, 0.01,
	\dist, 10.0,
	\amp, 0.6,
	\dur, 0.5,
	\addAction,1
).quant_([4,0]).play;
)

(
Pbindef(\s,
	\instrument, \snareFm,
	\freq, 90,
	//amplitude envelope
	\atk, 0.0, \rel, 0.1,
	// pitch modulation
	\pamp, 100, \patk, 0.0, \prel, 0.1,
	// frequency modulation
	\nf, 3500,\rq, 0.3,\namp, 3,\natk, 0.01, \nrel, 0.1,
	\dist, 10,
	\amp, 0.03,
	\dur, 1,
	\addAction,1
).quant_([1,1]).play;
)

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\bass).stop;
)


(
Pbindef(\magic,
	\instrument, \fm4,
	\dur, 0.125, //Pseq(~pads_durs,inf),
	\scale, Scale.major,
	\octave, 6,
	\degree, Pseq(~pads_degs[4], inf),
	\root, 9,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\n1, 1, \n2, Pseries(1,1, 8), //seg([1, 8,1],[4,4],\lin,inf).trace, //Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 10, inf).clump(3),
	\mi, 4000,
	\atk, 1, \rel,6,
	\iatk, 3, \irel, Pkey(\rel),
	\amp, 0.125,
	\pan, Pwhite(-1.0,1.0,inf).clump(3),
	\legato, 0.9,
	\addAction, 0
).quant_([1,0]).play;
)




Pbindef(\leadA).stop;
Pbindef(\leadB).stop;
Pbindef(\leadC).stop;
Pbindef(\pads).stop;
