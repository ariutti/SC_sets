~myScale = Scale.major;


(
Pbindef(\lick_lead,
	\instrument, \sin,
	\root,
	\scale, Pfunc({~myScale}),
	\octave, Prand([5],inf),
	\amp, 2,
	\atk, 0.01,
	\rel, 0.2,
	\degree, Pseq([0,2,0,2,0],inf),
	\dur, Pseq([Pn(0.5,4), 6],inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\fb, Pgauss(0.9, 0.1, inf),
	\addAction,0
).quant_([4,1.5]).stop.play;
)



// Ascolta: max cooper (discorso dei bassi pesanti)

// Voce:
// mirko + shoegaze
// ascolta "my bloody valantine" "sometimes" sono indietro (anche smashing pumpkins)
// crosses (initiation) ***
// DIIV -
