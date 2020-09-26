s.freqscope

~verb = Synth(\verb);
~verb.set(\wet,0.2);
~verb.free;

Pbindef(\k,\instrument,\bplaym,\buf,d["k"][3],\dur,Pseq([0.5],inf),\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(1).play;
(
Pbindef(\ss,
	\instrument,\bplaym,
	\buf,d["sstick"][2],
	\dur,Pwrand([
		Pseq([0.25,0.75],1),
		Pn(1,3)
	],[1,6].normalizeSum, inf),
	\amp,0.3,
	\rel,0.05,
	\rate,1.2,
	\lag, Pwhite(0.0, 0.01, inf),
	\addAction,1
).quant_([1,0.5]).play;
)
Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,Pwrand([Pn(0.125,4), 0.5], [1,10].normalizeSum, inf),\amp,0.125).quant_([4,0.25]).play;


(
Pbindef(\fmbassLick1,
	\instrument, \sinfb,
	\octave, [3,4,5],
	\scale, Scale.minor,
	\degree, Pseq([0,0,   0, Pn(  -1,3),-1], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\dur,    Pseq([1,1,0.75, Pn(0.25,3), 0.5], inf),//Pwrand([1,Pn(0.25, 4)],[1,0.25].normalizeSum, inf),
	\fb, Pseg([0.6,1,0.6], [4,4], \exp, inf),
	\atk, 0.0,
	\rel, 0.2,
	\amp, Pgauss(0.3, 0.01, inf),
	\addAction,0
).quant_([4,0.25]);
Pbindef(\fmbassLick1).play;
//Pbindef(\fmbassLick1).clear;
)



a = Buffer.read(s, "/home/nicola/Musica/sfx/dialup_by_oona.wav");
(
Pbindef(\dial,
	\instrument,\bplaym,
	\buf, a,
	\pos, 0.55, //Pwhite(0.1, 0.25, inf),
	\dur, Pseq([2], inf),
	\rel, Pkey(\dur),
	\rate, 1,
	\addAction,Prand([0,1],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, 2
).quant_(1).play;
)
Pbindef(\dial).stop;




(
SynthDef(\fnoise, {
	|out=0, freq=440, rq=0.1, amp=1.0, pan=0.0, l=1|
	var sig, env;
	env = EnvGen.ar(Env.triangle(l), doneAction:2);
	//env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Decay2.ar(Dust.ar(1), 0.01, 0.1);
	//sig = sig * BPF.ar(PinkNoise.ar(), freq, rq);
	sig = BPF.ar(PinkNoise.ar(), freq, rq);

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

StageLimiter.deactivate


(
Pbindef(\filteredNoiseLick,
	\instrument, \fnoise,
	\octave, Prand((3..6),inf),
	\scale, Scale.minor,
	\degree, 0 + Prand([0,2,4],inf), //Pwrand([0,3,5],[2,1,0.5].normalizeSum, inf), //Prand([1,5],inf)-1,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\l, 4,
	\dur, 0.25,
	\pan, Pwhite(-0.8, 0.8, inf),
	\amp, 20,
	\rq, Pexprand(0.0005, 0.002, inf),
	\addAction,0
).quant_(4);
Pbindef(\filteredNoiseLick).play;
)

s.meter
s.plotTree
s.scope

Pbindef(\filteredNoiseLick).stop;
Pbindef(\filteredNoiseLick).clear;



Pbindef(\oh, \instrument,\glinem,\buf,d["speakspell_letters"][0],\dur,2,\amp,2,\density,10,\caos,0,\rate,2,\addAction,1).quant_(4).play;
Pbindef(\oh).stop
{PlayBuf.ar(2, d["oh"][1], doneAction:2)}.play



(
Pbindef(\fmbassLick1,
	\instrument, \sinfb,
	\octave, [3,4,5],
	\scale, Scale.minor,
	\degree, Pseq([0,0,   0, Pn(  -1,3),-1], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\dur,    Pseq([1,1,0.75, Pn(0.25,3), 0.5], inf),//Pwrand([1,Pn(0.25, 4)],[1,0.25].normalizeSum, inf),
	\fb, Pseg([0.6,1,0.6], [4,4], \exp, inf),
	\atk, 0.0,
	\rel, 0.2,
	\amp, Pgauss(0.3, 0.01, inf),
	\addAction,0
).quant_([4,0.25]);
Pbindef(\fmbassLick1).play;
//Pbindef(\fmbassLick1).clear;
)
Pbindef(\fmbassLick1).stop;


(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5,
	//detune=0.1,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	//sig = LFPulse.ar(freq + LFNoise1.ar(10, detune), width:width);
	sig = LFPulse.ar(freq, width:width).bipolar;

	sig = sig * env * amp;
	sig = Decimator.ar(sig, 22050, 16);
	//sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

s.scope


(
Pbindef(\fmbassLick1,
	\instrument, \squarebass,
	\octave, [3,4],
	\scale, Scale.minor,
	\degree, Pseq([0,0,   0, Pn(  -1,3),-1], inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(2),
	\dur,    Pseq([1,1,0.75, Pn(0.25,3), 0.5], inf),//Pwrand([1,Pn(0.25, 4)],[1,0.25].normalizeSum, inf),
	//\fb, Pseg([0.6,1,0.6], [4,4], \exp, inf),
	\width, Pwhite(0.1, 0.5,inf).clump(2),
	\atk, 0.01,
	\rel, 0.2,
	\amp, Pgauss(0.3, 0.01, inf),
	\addAction,1
).quant_([4,0.25]);
Pbindef(\fmbassLick1).play;
//Pbindef(\fmbassLick1).clear;
)



// from Andrea Valle Super Collider book

// Segnale telefonico (italiano)

(
// occupato: pulsazioni a intervalli di 200 msec
{
var freq = 422, dur = 0.2;
LFPulse.kr(1/( dur*2))*SinOsc.ar(freq)
}.play ;
)
(
// libero
{
var freq = 422, cycleDur = 2 ;
var env = Env([0,1,1,0,0,1,1,0, 0], [0,1,0, 1, 0, 2.5, 0, 1.5]);
EnvGen.kr(env, 1,
gate: Impulse.kr(1/cycleDur),
timeScale:1/5, doneAction:0)
* SinOsc.ar(freq)
}.play
)
s.plotTree



(
// Segnale orario SRC
{
var amp = 0.125 ;
var firstBit = Array.fill(32, {[0,1].choose}) ;
var secondBit = Array.fill(16, {[0,1].choose}) ;
var freq ;
// primi 32 bit
firstBit.do{|i|
freq = [2000, 2500][i] ;
{SinOsc.ar(freq, mul:amp)*Line.kr(1,1,0.30, doneAction:2)}.play ;
0.03.wait
} ;
0.04.wait ;
// secondi 16 bit
secondBit.do{|i|
freq = [2000, 2500][i] ;
{SinOsc.ar(freq, mul:amp)*Line.kr(1,1,0.30, doneAction:2)}.play ;
0.03.wait
} ;
0.52.wait;
// 5 impulsi a 1000 Hz
{
SinOsc.ar(1000, mul:amp)
*
LFPulse.ar(1, width:0.1)*Line.kr(1,1,5, doneAction:2)
}.play ;
6.wait;
// ultimo
{SinOsc.ar(1000, mul:amp)*Line.ar(1, 1, 0.1, doneAction:2)}.play ;
}.fork


Synth.basicNew('',s,91636).free