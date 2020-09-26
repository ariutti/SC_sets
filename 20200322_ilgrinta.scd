// distorted pad
(
SynthDef(\dist, {
	|
	freq=440, pan=0.0, dur=10, amp=1.0
	|
	var env = EnvGen.ar(Env.triangle(dur*1.2), doneAction:2);
	var mamp = LFTri.kr(freq*0.0125*LFNoise0.kr(5).range(0.8,1.2)).range(0.5,5); //modulated amp
	var mwidth   = LFTri.kr(
		LFNoise1.kr(2).exprange(0.1, 2)
	).range(0.4, 0.6);
	var sig = VarSaw.ar(freq, width:mwidth, mul:mamp).squared.softclip;
	sig = LPF.ar( sig+WhiteNoise.ar(0.2), freq*4);
	//sig = HPF.ar(sig, freq * 0.25);
	//sig = CombN.ar(sig, 0.8, 0.2, 0.5);
	sig = LeakDC.ar(sig) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

s.freqscope;
s.meter;


(
Pbindef(\pads,
	\instrument, \dist,
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(6),
	\octave, 3,
	\degree, Pseq([
		[ 0,4,8, 9,13,18 ],
		[ 0,3,7,12,14,18 ],
		[-2,2,6, 7,11,15 ]
	], inf),
	\pan, Pwhite(-1.0, 1.0 ,inf).clump(6),
	\amp, Pgauss(0.3, 0.01, inf).clump(6),
	\dur, 10,
	\addAction,0
).quant_(4).play;
)

Pbindef(\pads).stop

s.scope
s.meter
s.plotTree

\degree, Pseq([
	[ 0,4, 8, 9,13,18 ],
	[ 3,7,12,14,18 ],
	[-2,2, 6, 7,11,15 ]
], inf),

[48, 55, 62, 64, 71, 79] - 48 //[ 0, 7, 14, 16, 23, 31 ]
[53, 60, 69, 72, 79] - 48 //[ 5, 12, 21, 24, 31 ]
[45, 52, 59, 60, 67, 74] - 48 // [ -3, 4, 11, 12, 19, 26 ]

3,7,12,14,18

MIDIIn.connect;
n.free;n = MIDIFunc.noteOn({arg ...args; args[1].postln}); // match any noteOn






(
~chords = [
	[48, 55, 62, 64, 71, 79],
	[53, 60, 69, 72, 79],
	[45, 52, 59, 60, 67, 74],

];
)


(
t = Task({
	{
	~chords.choose.do
		({
			|note|
			Synth(\dist, [\freq, (note-12).midicps]);
		});
		8.wait;
	}.loop;
}).start
);
t.stop


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);
~verb.set(\dec,4, \lpf,1500, \wet,1.0);