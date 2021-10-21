t.tempo_(120/60);


(
Pbindef(\A,
	\instrument, \bplaym,
	\buf, ~dirt["metal"][0],
	\amp, 1,
	\dur, 7,
	\atk, 0.01,
	\rel, 0.1,
	\pan, Pwhite(-1.0, 1.0, inf)
).quant_([4,1]).play;
)


(
Pbindef(\B,
	\instrument, \bplaym,
	\buf, ~dirt["metal"][1],
	\amp, 1,
	\dur, 5,
	\atk, 0.01,
	\rel, 0.1,
	\pan, Pwhite(-1.0, 1.0, inf)
).quant_([4]).play;
)



(
Pbindef(\C,
	\instrument, \bplaym,
	\buf, ~dirt["blip"][0],
	\amp, 1,
	\dur, 3,
	\atk, 0.01,
	\rel, 0.1,
	\pan, Pwhite(-1.0, 1.0, inf)
).quant_([4, 0.5]).play;
)



(
Pbindef(\bass,
	\instrument, \bplaym,
	\buf, ~dirt["gabbalouder"][0],
	\amp, 0.3,
	\rate, Prand([0.2, 0.6], inf),
	\dur, Pbjorklund2(3,8, inf, 0)/4,
	\atk, 0.01,
	\rel, 0.1,
	\addAction, 1
).quant_([4, 1]).stop.play;
)
Pbindef(\bass).stop;


(
Pbindef(\k,
	\instrument, \bplaym,
	\buf, d["k"][1],
	\amp, 2,
	\rate, 1,
	\dur, 2,
	\atk, 0.01,
	\rel, 0.1
).quant_([4]).play;
)
Pbindef(\k).stop;

StageLimiter.activate;

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\rel, 0.01, \rate, 2,\amp, Pgauss(0.4,0.01, inf) * 2).quant_([4, 0.5]).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,0.6,\rel,0.2,\rate,0.8,\addAction,Pwrand([0, 1], [1, 7].normalizeSum, inf) ).quant_([4,1]).stop.play;

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


~dirt.keys