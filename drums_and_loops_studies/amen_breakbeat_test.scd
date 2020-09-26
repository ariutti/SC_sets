
// amen
(
Pbindef(\k,
	\instrument,\bplaym,
	\buf, Pindex(~dirt["amencutup"], Pn(Prand(
		(0..~dirt["amencutup"].size),inf), Prand([1,4],inf)),
	inf),
	\dur, Pwrand([0.125, Pn(0.065,2)], [5,1].normalizeSum, inf),
	\atk, 0.0,
	\amp,0.5,
	\rel, 1,
	\rate, Pwrand([
		1,
		Pseg([1,2], [0.5], \lin, 1),
	],[5,1].normalizeSum, inf),
	\addAction,1
).quant_(4).play;
)


Pbindef.gui;
Pbindef(\k).stop
