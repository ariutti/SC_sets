s.boot;


(
SynthDef(\sinfb, {
	|amp=1.0, freq=440, atk=0.01, rel=1.0, pan=0.0, fb=0.0, out=0|
	var env = EnvGen.ar(Env.perc(atk,rel), doneAction:2);
	var sig = SinOscFB.ar(freq, fb);
	sig = sig * amp * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
~scale = Scale.minor;
~root = 1;
)

s.scope;

(
Pbindef(\melody,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\root, Pfunc({ ~root }),
	\octave, Pseq([6]).clump(3),
	\detune, 0,
	\amp, 0.8,
	\atk, 1,
	\mtranspose, 0.0, //Pwhite(0.0, 0.02, inf).clump(3),
	\rel, 8,//Pseg([0.1, 1, 0.1], [4,4],\lin, inf),
	\fb, Pwhite(0.1, 0.6, inf).clump(3), //Pseg([0.1, 0.9],[4,4], \lin, inf),
	\degree, 0 + Pseq([[0,2,4]], inf) , //Pseq([0,[4,-2],[7,14]], inf), //Pseq([0,1,2,3,4,5,6,7], inf),
	\dur, 8,
	\pan, Pwhite(-1.0, 1.0, 1).clump(3),
	\addAction, Pwrand([0,1],[1, 10].normalizeSum, inf)
).quant_([1,0]).stop.play;
)
Pbindef(\melody).clear.stop;
Pbindef(\melody, \mtranspose, 0.0);


s.scope
s.meter;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,1, \lpf,5000, \wet,4.0);
~verb.free;
StageLimiter.activate



(
SynthDef(\varsaw, {
	|amp=1.0, freq=440, atk=0.01, width=0.5, rel=1.0, pan=0.0, fb=0.0, out=0|
	var env = EnvGen.ar(Env.perc(atk,rel), doneAction:2);
	var sig = VarSaw.ar(freq, width:width);
	sig = sig * amp * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)



(
Pbindef(\melody).stop;
Pbindef(\bass,
	\instrument, \varsaw,
	\scale, Pfunc({ ~scale }),
	\root, Pfunc({ ~root }),
	\octave, [5,6,7], //Prand([6,4,7],inf).clump(3),
	\detune, 0,
	\amp, 2,
	\atk, 0.01,
	\mtranspose, 0.0, //Pwhite(0.0, 0.02, inf).clump(3),
	\rel, 0.1,//Pseg([0.1, 1, 0.1], [4,4],\lin, inf),
	\width, 0.4, //Pseg([0.1, 0.9],[4,4], \lin, inf),
	\degree, 0 ,//Pwrand([0,-1],[7,2].normalizeSum, inf),
	\dur, Pwrand([1, Pn(0.5,2)],[10,2].normalizeSum,inf),
	\pan,  0.0,
	\addAction,
).quant_([4,0.5]).stop.play;
)
Pbindef(\bass).stop;

Pbindef(\bass, \degree, 0);


(
Pbindef(\melody,
	\instrument, \sinfb,
	\scale, Pfunc({ ~scale }),
	\root, Pfunc({ ~root }),
	\octave, [4,5], //Prand([6,4,7],inf).clump(3),
	\detune, 0,
	\amp, 0.5,
	\atk, 0.0,
	\mtranspose, 0.0, //Pwhite(0.0, 0.02, inf).clump(3),
	\rel, 0.2,//Pseg([0.1, 1, 0.1], [4,4],\lin, inf),
	\fb, 1.1, //Pwhite(0.1, 1.1, inf).clump(3), //Pseg([0.1, 0.9],[4,4], \lin, inf),
	\degree, 0 + Pseq([
		Pseq([0], 7).collect({|n|  [n, n+5]}),
		Prand([7,-1], 1),
	], inf).collect({|n| [n,n+12]}),
	\dur, Pwrand([0.5, Pn(0.25, 2), Pn(1/3, 3)],[7,2,1].normalizeSum, inf),
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pwrand([0,1],[1, 10].normalizeSum, inf)
).quant_([4,0]).stop.play;
)
Pbindef(\melody).stop.clear;




(
SynthDef(\fm4_perc, {
	|
	amp=1.0, freq=440, pan=0.0, out=0,
	atk=0.0, rel=0.1,
	mi=0, n1=1, n2=1, iatk=0.01, irel=0.1, iAdd=0.0
	|
	var env = EnvGen.ar(Env.perc(atk,rel), 1, doneAction:2);
	var iEnv= EnvGen.ar(Env.perc(iatk, irel),1);
	var fmod = freq*n2;
	var mod = SinOsc.ar(fmod, mul:(mi*iEnv), add:iAdd );
	var sig = SinOsc.ar(freq*n1 + mod);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

(
Pbindef(\bass,
	\instrument, \fm4_perc,
	\scale, Pfunc({ ~scale }),
	\root, Pfunc({ ~root }),
	\octave, 4, //Prand([6,4,7],inf).clump(3),
	\detune, 0,
	\amp, 0.25,
	\mi, 1000,
	\n1, 3,
	\n2, 4,
	\iatk, 0.5,\irel, 2, \iAdd, 1,
	\atk, 1,
	\rel, 4,
	\degree, 0 + Pseq([0,4, -1, 3],inf),
	\dur, 4,
	\pan, 0.0,
	\addAction, 0
).quant_([4,0]).stop.play;
)
Pbindef(\bass).stop.clear
s.freqscope
Pbindef(\bass).stop;

(
Pbindef(\melody,
	\instrument, \fm4_perc,
	\scale, Pfunc({ ~scale }),
	\root, Pfunc({ ~root }),
	\octave, 5, //Prand([6,4,7],inf).clump(3),
	\detune, 0,
	\amp, 0.7,
	\mi, 10000,
	\n1, 2,
	\n2, 5,
	\iatk, 0.01,\irel, 0.1, \iAdd, 1,
	\atk, 0.0,
	\rel, 0.02,
	\degree, 0,
	\dur, Pwrand([1, Pseq([0.25,0.75],1)],[7,3].normalizeSum, inf),
	\pan, 0.0,
	\addAction, 1
).quant_([4,0.5]).play;
)
Pbindef(\melody).stop.clear;
Pbindef(\melody).stop

Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([1.25, 0.5,0.75,1.5],inf) ,\amp,2,\rel,0.125,\rate,0.6,\addAction,1, \lag,Pwhite(0.0, 0.02, inf)).quant_(4).play;

(
Pbindef(\k,
	\instrument, \kickFm,
	\freq, 50,
	//amplitude envelope
	\atk, 0.0, \rel, 0.1,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 100, \matk, 0.01, \mrel, 0.01,
	\dist, 200.0,
	\amp, 16,
	\dur, 1,
	\addAction,1
).quant_([4,0]).play;
)
Pbindef(\k).stop;

(
Pbindef(\s,
	\instrument, \snareFm,
	\freq, 90,
	//amplitude envelope
	\atk, 0.0, \rel, 0.01,
	// pitch modulation
	\pamp, 100, \patk, 0.0, \prel, 0.2,
	// frequency modulation
	\nf, 3500,\rq, 0.3,\namp, 2,\natk, 0.0, \nrel, 0.2,
	\dist, 3,
	\amp, 0.7,
	\dur, Pseq([2], inf),
	\addAction,1
).quant_([4,1]).stop.play;
)
Pbindef(\s).stop;
"/home/nicola/Musica/SC_set/mySamples/s/Crsnred_scr_snr_1.wav"

~snare = Buffer.read(s, "/home/nicola/Musica/SC_set/mySamples/s/Crsnred_scr_snr_1.wav");

Pbindef(\s,\instrument,\bplaym,\buf,~snare,\dur,1,\rate,1.0,\amp,0.5,\atk,0.0,\rel,0.1,\addAction,1).quant_([4,1.1]).stop.play;

Pbindef(\s).stop


~verb.set(\dec,1, \lpf,5000, \wet,2.0);
(
Pbindef(\caossine,
	\instrument,\caossine,
	\scale, Scale.minor,
	\degree, Pseq([0,2,4], inf),
	\detune, 0,
	\octave, Prand((3..12), inf),
	\dur, 0.25,
	\im, Pwhite(16, 35, inf),
	\fb, Pwhite(0.1, 16, inf),
	\a, Pexprand(0.1,1.2, inf),
	\c, Pexprand(1,6, inf),
	\atk, 0.0,
	\sus, 0,
	\rel, Pexprand(0.1,0.3, inf),
	\amp, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_([4,0]).stop.play;
)

(
Pbindef(\k,
	\instrument, \k,
	\octave, [3],
	\degree, Pseq([7],inf),
	\dur, 1, //Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, 16,//Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, 0.05, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
)



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
	\scale, Scale.minor,
	\octave, Prand([4,5,6,7], inf).clump(3),
	\degree, 3 + Pseq(~pads_degs[7], inf),
	\root, 1,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\n1, 1, \n2, Prand((1..8),inf),
	\iAdd, Pwhite(0.0, 1.9, inf).clump(3),
	\mi, 400,
	\atk, 4, \rel,4,
	\iatk, 3, \irel, Pkey(\rel),
	\amp, 0.8,
	\pan, Pwhite(-1.0,1.0,inf).clump(3),
	\legato, 0.9,
	\addAction, 0
).quant_([4,0]).play;
)

(
Pbindef(\pads, \degree, 0 + Pseq(~pads_degs[7], inf));
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\hh).play;
Pbindef(\hh1).play;
//Pbindef(\caossine, \dur, 0.125, \rel, 0.1).stop;
)

(
Pbindef(\pads, \degree, 3 + Pseq(~pads_degs[0], inf));
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\hh1).stop;
Pbindef(\caossine, \dur, 1, \rel, 1).stop;
)

Pbindef(\pads).stop;



(
Pbindef(\hh1,
	\instrument,\hh,
	//\buf, Pseq([~dirt["tech"][0], ~dirt["tech"][7], Pn(~dirt["tech"][0],3)], inf),
	\freq, [7000, 9000],
	\rq, 0.05,
	\dur, 1, //Pwrand([1, Pseq([0.25, 0.75], 1)], [7,2].normalizeSum,\lin, inf),
	\amp, Pgauss(1, 0.2, inf) * 3,
	\atk, 0.0,
	\rel, 0.2,
	\rate, 1, // Pseq([1, 2, Pn(1,3)], inf),
	\addAction,1
).quant_([4,0.5]).play;
)
Pbindef(\hh1).stop.clear;

Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,Pwrand([2, Pseq([0.25, 1.75],1)],[7,2].normalizeSum, inf),\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,1,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).stop.play;

Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][5], \dur, 2, \amp, 0.7,\dist, 50, \rate, 0.7, \rel, 0.15)
~dirt["tech"][11]

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
)


(
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\hh).play;
)

Pbindef(\k,\instrument,\bplay_dist,\buf,~dirt["tech"][6],\dur,1,\rel,1,\rate,1,\amp,4,\addAction,1).quant_([4,0]).stop.play;

~dirt["tech"][6]

(
Pbindef(\hh,\instrument,\bplay_dist,\buf,~dirt["tech"][9],\dur,1,\rel,0.5,\rate,1,\amp,5,\addAction,0).quant_([4,0]).stop.play;
Pbindef(\hi1).stop;
)
(
Pbindef(\hh,\instrument,\bplay_dist,\buf,~dirt["tech"][9],\dur,1,\rel,0.5,\rate,1,\amp,5,\addAction,0).quant_([4,0]).stop.play;
Pbindef(\hi1).stop;
)
~dirt["tech"][8]

(
SynthDef(\dfm1, {
	|
	out=0, freq = 440,
	res = 1,type = 0, noise = 0.0003,
	atk = 0.01, rel = 1,
	amp=1.0, pan=0.0
	|

	var sig, env;
	env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	sig = DFM1.ar(SinOsc.ar(freq),freq,res,1,type,noise);
	sig = sig*env*amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;
);


Pbindef(\dfm).stop;
(
Pbindef(\k).play;
Pbindef(\s, \amp, 0.6).play;
Pbindef(\hh,\dur,1).play;
Pbindef(\hh1).play;

Pbindef(\dfm,
	\instrument, \dfm1,
	\scale, Scale.minor,
	\root, 1,
	\octave, [6,7],
	\degree, 0 + Prand([-1,0,7],inf), //[0, 3,6], //Pseq([0,7],inf),
	\amp, 0.9,
	\atk, 0.0, \rel, 0.2, //0.125,
	\type, 0,
	\noise, 0.03,
	\dur, 2, //Pseq([1, Pn(0.25,4), Pn(0.5,2)], inf),
	\addAction, 1,
	\pan, Pwhite(-1.0, 1.0, inf)
).quant_(4).play;
Pbindef(\caossine).play;
)

Pbindef(\dfm, \dur, 2, \atk, 1).stop
t.tempo_(106/60)

(
Pbindef(\dfm).stop;
Pbindef(\caossine).stop;
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\hh1).stop;
)


