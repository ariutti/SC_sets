~root = -1 // 2
~bass_degs = [-1, 0,0,-1,0,-4,-3,-1]
~bass_durs = [0.5]

(
Tdef(\rootChanger, {
	loop{
		~root = -1;
		~root.postln;
		wait(16*2*2);
		~root = 2;
		~root.postln;
		wait(16*2*2);
	};
}).quant_(4);
)
Tdef(\rootChanger).play;

TempoClock.default.tempo_(135/60);

(
SynthDef(\distdoublebass, {
	|freq=440, pan=0.0, amp=1.0, out=0
	atk=0.05, rel=0.2, fc=67, dist=1.0|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = Pulse.ar(freq, 0.3);
	sig = LPF.ar(sig, fc);
	sig = LeakDC.ar(sig);
	sig = (sig * dist).tanh;
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

(
Pbindef(\db,
	\instrument, \distdoublebass,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, [3,4],
	\degree, Pseq(~bass_degs,inf),
	\amp, Pseq([1,Pn(0.7,3)], inf) * 0.3,
	\fc, Pseg([240, 120, 240],[4,4], \exp, inf),
	\dist, 30,
	\atk, 0.0,
	\rel, 0.2,
	\dur, Pseq(~bass_durs, inf),
	\pan, 0.0,
	\addAction,1
).quant_([4,0]).play;
)

(
Pbindef(\pads,
	\instrument, Prand([\squarebass,\fm4,\syncsaw],inf),
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([6,7],inf).clump(3),
	\degree, Pseq([
		 Pseq([[0,2,4]], 16), // Bm
		 Pseq([[-1,1,3,4]], 16), // F#m
		 Prand([[-1,0,2,4],[-2,0,2,4]], 16), // Em
		 Pseq([[-1,1,3,4]], 16), // F#m
		 //-1 + Pseq([[-1,1,3,4]], 1), // A7
	], inf),
	\n1, 1, \n2, Prand([2,4,6,8], inf), \mi, Pwhite(100, 1000, inf).clump(3),
	\iatk, 0.01, \irel, 0.01,
	\iAdd, Pwhite(0.0, 5,inf).clump(3), //Pseg([0.0, 10], [8], \lin, inf),
	\dur, Pseq([Pn(0.5, 16)],inf),
	\atk, 0.05, //Pkey(\dur)*0.1,
	\rel, 0.01, //Pkey(\dur)*0.9,
	\amp, 0.1 * Pseg([0.2, 1.0],[4],\exp, inf),
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pwrand([1,0],[100,1].normalizeSum, inf).clump(3),
	\strum, Pwhite(0.0, 0.01, inf)
).quant_([4,0]).stop.play;
)

(
Pbindef(\pads,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([5,6],inf).clump(3),
	\degree, Pseq([
		 0 + Pseq([[2,4,6]], 1), // D
		-2 + Pseq([[0,2,4]], 1), // G
		-3 + Pseq([[0,2,4]], 1), // F#m
		 0 + Pseq([[0,2,4]], 1), // Bm
		-2 + Pseq([[0,2,4]], 1), // G
		-1 + Pseq([[0,2,4,6]], 1) // A7
	], inf),
	\fb, 0.4, //Pwhite(0.5, 1.1,inf).clump(3),
	\dur, Pseq([Pn(4,4), Pn(8,2)], inf),
	\atk, Pkey(\dur)*0.01,
	\rel, Pkey(\dur)*0.9,
	\amp, 0.07,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Prand([0,1], inf).clump(3)
).quant_([4,0]).stop.play;
)

Pbindef(\pads).stop;



(
Pbindef(\pads2,
	\instrument, \sinfb,
	\scale, Scale.minor,
	\root, Pfunc({~root}),
	\octave, Prand([6,5],inf).clump(3),
	\degree, Pseq([
		 Pseq([[0,2,4]], 1), // Bm
		 Pseq([[-1,1,3,4]], 1), // F#m
		 Prand([[-1,0,2,4],[-2,0,2,4]], 1), // Em
		 Pseq([[-1,1,3,4]], 1), // F#m
		 //-1 + Pseq([[-1,1,3,4]], 1), // A7
	], inf),
	\fb, Pwhite(0.4,0.8, inf).clump(4),
	\dur, Pseq([Pn(8,4)], inf),
	//\dur, Pseq([Pn(4,4), Pn(8,2)], inf),
	\atk, Pkey(\dur)*0.25*TempoClock.default.beatDur,
	\rel, Pkey(\dur)*0.75*TempoClock.default.beatDur,
	\amp, 0.06,
	\pan, Pwhite(-1.0, 1.0, inf).clump(3),
	\addAction, Pwrand([1,0],[100,1].normalizeSum, inf).clump(3),
	\strum, Pwhite(0.0, 0.01, inf)
).quant_([4,2]).stop.play;
)
Pbindef(\pads2).stop;




~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);

d.keys
(
Pbindef(\k,\instrument,\bplaym,\buf,~dirt["808bd"][0],\dur,Pseq([4,1,3],inf),\amp,2,\rel,0.1,\rate,1,\addAction,1).quant_(4).play;
Pbindef(\s,\instrument,\bplaym,\buf,~dirt["808sd"][1],\dur,Pseq([4],inf),\amp,0.3,\rel,0.3,\rate,1.1,\addAction,1).quant_([4,2]).play;
Pbindef(\c,\instrument,\bplaym,\buf,~dirt["808oh"][1],\dur,Pseq([1.5,2.5],inf),\amp,0.1,\rel,0.2,\rate,0.7,\addAction,1).quant_([4,2]).play;
Pbindef(\hh,\instrument,\bplaym,\buf,~dirt["808"][1],\dur,0.5,\amp,Pseg([1,0.2], [2], \lin,inf) * 0.5).quant_(4).play;
)

(
Pbindef(\k).stop;
Pbindef(\c).stop;
Pbindef(\hh).stop;
Pbindef(\s).stop;
)

s.meter

(
~mel_degs = [2, 1,-1,  2, 1,-1, 2, 1,  2,-1, 2, 1,  -1, 2, 1,-1, 2, -1, 2, 3];
~mel_durs = [1, 1, 1,0.5, 1, 1, 1, 1,0.5, 1, 1, 1, 0.5, 1, 1, 1, 1,0.5, 8, 8];
)


(
SynthDef(\sinfb_tremolo, {
	arg freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0, dur=1;
	var sig, env;
	env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
	sig = SinOscFB.ar(freq + (Line.ar(0.0, 1.0, dur*0.125)*SinOsc.kr(6, mul:5)),fb,1);
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);


(
Pbindef(\mel,
	\instrument, \sinfb_tremolo,
	\octave, [5,6],
	\root, Pfunc({~root}),
	\scale, Scale.minor,
	\degree, Pseq(~mel_degs,inf).collect({|note| [note, note]}),
	\detune, Pwhite(3, 5, inf).clump(2),
	\dist, Pwhite(5, 10,inf).clump(2),
	\fb, 0.5,
	\amp, Pseq([Pn(0.1,18), Pn(0.07,2)],inf)*1.1,
	\atk, Pseq([Pn(0.0,18), Pn(0.1,2)],inf),
	\dur,Pseq(~mel_durs,inf),
	\rel, Pseq([Pn(0.2,18), Pkey(\dur) * TempoClock.default.beatDur],inf),
	\pan, Pwhite(-1.0 ,1.0,inf).clump(2),
	\lag, Pwhite(0.0, 0.05, inf).clump(2),
	\strum, 0.0, //Pwhite(-0.01, 0.01, inf),
	\addAction,0
).quant_([4,0]).play;
)
Pbindef(\mel).stop;
Pbindef(\mel,\fb, 0.5, \amp, 0.06)
Pbindef(\mel).play;


