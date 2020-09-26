t = TempoClock.default;
t.tempo_(128/60)
s.plotTree;

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

(
SynthDef(\k, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0, dc=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = DC.ar( dc.clip(0.0, 0.5) ) +  SinOsc.ar(freq, 0.5pi);
	sig = sig.fold(-1.0, 1.0);
	sig = LPF.ar(sig, XLine.kr(3000, 1000, rel));
	sig = sig + (SinOsc.ar(freq * 2,  mul:Line.kr(0.0, 1,rel*1)));
	sig = sig * amp * env;
	sig = LeakDC.ar(sig);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

s.scope
Pbindef(\k).clear;

(
Pbindef(\k,
	\instrument, \k,
	\octave, 3,
	\degree, Pseq([-3],inf),
	\dur, 4, //Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, 2 ,//Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, 0.15, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
)


(
Pbindef(\k,
	\instrument, \k,
	\octave, 3,
	\degree, Pseq([-3],inf),
	\dur, Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 2,
	\rel, 0.1, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\dc, Pseq([0.1,0.25], inf), //Pseg([0.0, 0.25], [4],\lin, inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1
).quant_(4).play;
)
Pbindef(\k).stop;


(
SynthDef(\hh, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,rq=0.1|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = BPF.ar(WhiteNoise.ar(), freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)
(
Pbindef(\hh,
	\instrument,\hh,
	//\buf, Pseq([~dirt["tech"][0], ~dirt["tech"][7], Pn(~dirt["tech"][0],3)], inf),
	\freq, [7000, 9000],
	\rq, 0.05,
	\dur, Pseq([
		0.5,0.5,0.25,0.25,0.5
		//0.5,Prand([0.5, Pn(0.25,2)],1),0.25,0.25,0.5
	], inf),
	\amp, Pgauss(1, 0.2, inf) * 5,
	\atk, 0.0,
	\rel, Pseq([
		0.01,
		0.1,
		Pn(0.01,3)
	],inf),
	\rate, 1, // Pseq([1, 2, Pn(1,3)], inf),
	\addAction,1
).quant_(4).play;
)
Pbindef(\hh).stop;



(
SynthDef(\bplay_dist,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15, dist=1.0;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = (sig*dist).tanh;
		sig = sig * env * amp;
		sig = LeakDC.ar(sig);
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

(
SynthDef(\bplay_distm,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15, dist=1.0;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = (sig*dist).tanh;
		sig = sig * env * amp;
		sig = LeakDC.ar(sig);
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

Pbindef(\s,\instrument,\bplay_dist,\buf,~dirt["tech"][12],\dur,Pseq([2.25, 1.75], inf),\rel,0.3,\rate,1.1,\dist,Prand([6,100],inf),\amp,0.3,\addAction,Pwrand([0,1],[1,7].normalizeSum,inf)).quant_([4,1]).play;
Pbindef(\s).stop;


(
Pbindef(\cymbal,
	\instrument, \glinem_rev,
	\buf, d["oh_mono"][1],
	\dur, 4,
	\atk, Pkey(\dur)*t.beatDur,
	\rel, 0.0,
    \density, 10, \caos, 5.0,
	\rate, 0.9,
	\amp, Pseq([Pn(\,3), 30],inf) * 5,
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).stop.play;
)
Pbindef(\cymbal).stop;

(
Pbindef(\k).stop;
Pbindef(\s).stop;
Pbindef(\hh).stop;
Pbindef(\cymbal).stop;
)


(
Pbindef(\k).play;
Pbindef(\s).play;
Pbindef(\hh).play;
Pbindef(\cymbal).play;
)


(
SynthDef(\sinfb, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\stabs,
	\instrument, \sinfb,
	\octave, Pseq([4,5],inf).clump(2),
	\scale, Scale.minor,
	\degree, [3, 0], //Pseq([Pseq([3,3.1],8) ,Pseq([1,2],8)], inf),
	\mtranspose, Pwhite(-0.02, 0.02, inf).clump(2),
	\fb, 0.9,
	\atk, 0.0,
	\rel, 0.07,
	\dur, 8,
	\amp, Pgauss(1, 0.01, inf).clump(2) * 1,
	\strum, 0,
	\addAction, 0
).quant_([4, 1]).stop.play;
)
Pbindef(\stabs).play;
Pbindef(\stabs).stop;



(
SynthDef(\wt_simple, {
	|amp=0, out=0, bufnum, freq=440, atk=0.01, dcy=0.1, sus=0.7, rel=1, pan=0.0, gate=1, beats=0.1|
	var env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);
	var sig = COsc.ar(bufnum, freq, beats);
	sig = sig * env * amp;
	sig = LPF.ar(sig, freq * 8);
	sig = LeakDC.ar(sig);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


(
Pbindef(\pads,
	\instrument, \wt_simple,
	\octave, Prand([[3,4,5]], inf),
	\scale, Scale.major,
	\bufnum, b,
	\root, -4,
	\beats, 0.25,
	\degree, Pseq([3, 4, 5], inf) + Pseq([[0,2,4]], inf),
	\amp, 0.02,
	\atk, 1,
	\rel, 1,
	\dur, Pseq([4,4, 8], inf),
	\pan, Pwhite(-1.0 , 1.0, inf).clump(3),
	\addAction,0,
	\legato, 1.125
).quant_([4,1]).stop.play;
)

Pbindef(\pads).stop


(
Pbindef(\lead,
	\instrument, \sinfb,
	\octave, Prand([4,5,6], inf),
	\scale, Scale.major,
	\root, -4,
	\degree, Pseq([-2],inf),
	\fb, 1.1,
	\amp, Pseq([1, 0.5], inf) * 0.3,
	\atk, 0.0,
	\rel, 0.1,
	\dur, Pseq([0.75, Pn(0.25, 2)],inf),
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).play;
)


(
Pbindef(\lead,
	\instrument, \dfm1,
	\octave, Prand([5,6], inf),
	\scale, Scale.major,
	\root, -4,
	\degree, Pseq([-2],inf),
	\res, 3,
	\amp, Pseq([1, 0.5], inf) * 0.3,
	\atk, 0.0,
	\rel, 0.1,
	\dur, Pseq([0.75, Pn(0.25, 2)],inf),
	\pan, 0.0,
	\addAction,0
).quant_([4,0]).play;
)


Pbindef(\lead).stop;



