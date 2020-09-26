// inspired by rusty nails - shackleton remix
//https://open.spotify.com/track/2xK6remdEjB0ipy6CFXUqi?si=CklIHR-jTD2roszR_P3l3Q

t = TempoClock.default;
t.tempo_(128/60)

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.5,\amp,0.6).quant_(4).play;
Pbindef(\hh).stop;


(
Pbindef(\k,
	\instrument,\bplay,
	\buf,~dirt["tech"][5],
	\dur, Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\atk, 0.0,
	\rate, 1,
	\addAction,1).quant_(4).play;
)

(
Pbindef(\k,
	\instrument,\kickFm,
	\octave, 2,
	\dist, 1,
	\degree, 0,
	\dur, Pseq([0.75, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5], inf),
	\amp, Pseq([   1, 0.5,  0.7, 0.7,    1, 0.5, 0.7,  0.5, 0.6], inf) * 1,
	\rel, 0.1, //Pseq([ 0.1,   1,    1,   1,    1,   1,   1,    1,   1], inf),
	\atk, 0.0,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 100, \matk, 0.01, \mrel, 0.01,
	\rate, 0.8,
	\addAction,1).quant_(4).play;
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





