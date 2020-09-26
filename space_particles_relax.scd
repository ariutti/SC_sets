(
SynthDef(\blip, {
	|
	out, freq=440, amp=1.0,atk=0.01, rel=0.1, gate=1, pan=0.0, nh=3
	|
	var env = EnvGen.ar(Env.adsr(atk, 0.0, 1.0, rel),gate, doneAction:2);
	var detune = LFNoise2.kr(6, mul:2);
	var sig1 = LPF.ar(Blip.ar(freq + detune, nh), freq*LFNoise1.kr(1).range(2,4));
	var sig2 = sig1 * SinOsc.ar(6, mul:0.125, add: 1-0.25);
	var sig = SelectX.ar( LFNoise1.kr(1), [sig1, sig2]);

	sig = sig * amp* env;

	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\subsaw, {
	|
	out, freq=440, amp=1.0,
	atk=0.01, rel=0.1, gate=1, pan=0.0,
	osc1amt=0.33, osc2amt=0.33, subamt=0.33,
	rf=880, rq=1.0
	|
	var env = EnvGen.ar(Env.adsr(atk, 0.0, 1.0, rel),gate, doneAction:2);
	var osc1 = LFSaw.ar(freq+0.25, mul:osc1amt).bipolar;
	var osc2 = LFSaw.ar(freq-0.25, mul:osc2amt).bipolar;
	var sub  = LFPulse.ar(freq*0.5, mul:subamt).bipolar;

	var sig = RLPF.ar( (osc1 + osc2 + sub), rf, rq);
	sig = LPF.ar(sig ,110);
	sig = sig * amp * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,3, \lpf,1500, \wet,1.0);

~myScale = Scale.new(#[0,2,3,5,7,9,10], 12); // Cminor scale

(
Pbindef(\spaceparticles_arpeggio,
	\instrument, \blip,
	\scale, ~myScale,
	\root, 0,
	\octave, Pstutter(2, Pseq([4,5],inf)),
	\degree, Pseq([
		0,Prand([1,2,3,4], 1),6,
		0,Prand([1,2,3], 1),4
	],inf),

	\amp, Pgauss(0.05, 0.01,inf),
	\dur, Pseq([0.5,0.5,0.5], inf)*(1.0/3),
	\lag, Pwhite(0.0, 0.01,inf),
	\sustain, 0.1,
	\nh, Prand([2,3,4,5,6],inf),
	\atk, 0.01,
	\rel, 1,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction,0
).quant_(4).play;
)
Pbindef(\spaceparticles_arpeggio).stop;


(
Pbindef(\spaceparticles_chords,
	\instrument, \blip,
	\scale, ~myScale,
	\root, 0,
	\octave, [4],
	\degree, Pstutter(2, Pseq([[0,4], [2,6], [-1,3]],inf)), // Cm, Gm, Bb
	\amp, Pgauss(0.1, 0.01,inf).clump(2),
	\dur, 8,
	\lag, 0.0, //Pwhite(0.0, 0.01,inf),
	\stretch,1,
	\atk, 0.1,
	\rel, 1,
	\pan, Pwhite(-1.0, 1.0, inf).clump(2),
	\addAction,0
).quant_(4).play;
)
Pbindef(\spaceparticles_chords).stop;

(
Pbindef(\spaceparticles_sub,
	\instrument, \subsaw,
	\scale, ~myScale,
	\root, 0,
	\octave, [3],
	\degree, Pwrand([0,4,2],[7,4,4].normalizeSum, inf), // C, G, Eb
	\amp, 0.25,
	\osc1amt, 0.33, \osc2amt, 0.33, \subamt, 0.7,
	\rf, Pwhite(80, 1000, inf), \rq, 0.1,
	\dur, 8,
	\atk, 0.5,
	\rel, 3,
	\pan, 0.0,
	\width, 3,
).quant_(4).play;
)
Pbindef(\spaceparticles_sub).stop;
