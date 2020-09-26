// 808 version ************************************************/
~dirt.keys;

(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,2,\amp,1,\rel,0.1,\rate,1,\addAction,1).quant_(4).stop.play;

Pbindef(\clap, \instrument,\bplaym,\buf,~dirt["bend"][1],\dur,4,\amp,10,\rel,0.1,\rate,3,\addAction,0).quant_([4,3.5]).stop.play;

Pbindef(\s,
	\instrument,\bplaym,
	\buf, ~dirt["808sd"][3],
	\dur, Pwrand([2, Pseq([1.25, 0.75], 1)],[10,1].normalizeSum,inf),
	\amp,Pgauss(3, 0.1, inf),
	\rel, 0.1, //Prand([0.1, 0.2] ,inf),
	\rate, 1,
	\addAction,1
).quant_([4,1]).stop.play;



Pbindef(\hh,\instrument,\bplaym,\buf,Pseq([~dirt["808oh"][1]],inf),\dur,1,\amp,0.7,\rel,0.1,\rate,1,\addAction,1).quant_([4,0.5]).stop.play;
)

(
Pbindef(\k, \stretch, 0.5);
Pbindef(\s, \stretch, 0.5);
Pbindef(\clap, \stretch, 0.5);
Pbindef(\hh, \stretch, 0.5);
)



(
Pbindef(\k, \stretch, 1);
Pbindef(\s, \stretch, 1);
Pbindef(\clap, \stretch, 1);
Pbindef(\hh, \stretch, 1);
)