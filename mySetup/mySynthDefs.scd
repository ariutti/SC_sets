/*
Nicola Ariutti SynthDef library
many synths taken from coï¿¥ï¾¡pt SynthDef library
*/

// synths by Nicola Ariutti /////////////////////////////////////////////////////////////////////////////////


// WIP
/*
(
SynthDef(\bassline4, {
	|
	out=0, freq=440, pan=0.0, amp=1.0,
	atk=0.05, rls=0.2,
	sub=0.0, subwidth=0.5,
	sync=0.0, // this is a sync ratio going from 0.0 (no effect) to 60 semitones (5 octave above)
	voices = 1,
	det=0.0,
	cf = 1000,
	rq = 0.1
	|
	var env, sig, spread;
	env = EnvGen.ar(Env.perc(atk, rls), 1, doneAction:2);
	voices = voices.clip(1, 16);

	sig = Array.fill(16, {
		|index|
		var onoff = (voices.round(1) > index);  // the ">" here will return 1 or 0 depending on voices
		onoff * SyncSaw.ar(freq *Rand(1.0, det.midiratio), freq*(sync.midiratio));
	});
	sig = sig + Pulse.ar(freq*0.5, subwidth, mul:sub);
	spread = (voices-1)/15;

	sig = sig * env * voices.linexp(1, 16, 1.0, 0.3) * amp;

	sig = RLPF.ar(sig, cf, rq);

	sig = LeakDC.ar( sig.clip() );
	Out.ar(out, Splay.ar(sig, spread));
}).add;
)
*/


// utility
(
SynthDef(\inout, {
	|in=2, out=0, amp=1.0|
	var sig = In.ar(in, 2);
	Out.ar(out, sig*amp);
}).add;
);




// metronome utility
// to be used with something like this
// ~metronome = Pbind(\instrument, \metronome,\freq, Pseq([1500, 1000.dup(3)].flat, inf),\dur, 1, \rel, 0.01);
// ~metrnome.play;
(
SynthDef(\metronome, {
	|
	out=0,
	amp=1, freq=1000, pos=0.0,
	rel=0.1
	|
	var sig, env, fenv;

	// amplitude envelope
	env   = EnvGen.ar(Env.perc( 0.001, rel), doneAction:2);
	// cut frequency envelope
	sig = SinOsc.ar(freq);
	//sig = RLPF.ar(sig, rf*fenv, rq);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pos));
}).add;
);



(
SynthDef(\test, {
	|
	out=0,
	amp=1, freq=440, pos=0.0,
	gate=1,
	atk=0.01, dcy=0.05, sus=0.7, rel=0.5
	|
	var sig, env, fenv;

	// amplitude envelope
	env   = EnvGen.ar(Env.adsr( atk,  dcy,  sus,  rel, curve:[4, -4, -4]), gate:gate, doneAction:2);
	// cut frequency envelope
	sig = SinOsc.ar(freq);
	//sig = RLPF.ar(sig, rf*fenv, rq);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pos));
}).add;
);

/*************************************************
*    SAMPLERS                                    *
*************************************************/

/*
// ONE SHOT PLAYER (stereo)

(
Pbindef(\piano,
	\instrument, \oneshot_player,
	\scale, Scale.major,
	\root, 0,
	\octave, Prand([3,4,5], inf),

	\degree, Prand([
		[0,7],
		Ptuple([Prand((0..3),1), Prand((4..7),1)],1),
		4,
		7,
		-1
	],inf),

	\index,  Pfunc({ |e| e.use { ~midinote.() }.asArray.collect { |note| ~samples[\piano][\midinotes].indexIn(note) } }),
	\buf, Pindex(~samples[\piano][\buffers], Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~samples[\piano][\midinotes], Pkey(\index))).midiratio,

	\atk, 0.01, \rel, Pwhite(1, 4, inf),
	\amp, Pgauss(4, 0.2, inf),
	\dur, Pwrand([0.25, Pn(0.125, 2)],[1, 0.25].normalizeSum, inf), //Prand([0.25, 0.5, 1], inf),
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\lag, Pwhite(0.0, 0.002, inf),
	\addAction, Prand([1,0], inf)
).quant_(1);
);
*/
(
SynthDef(\oneshot_player, {
	|
	out=0, amp=0.5, buf, rate=1.0, pan=0.0,
	atk=0.01, rel=0.1
	|
	var env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0);

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan) );
}).add;
);

(
SynthDef(\hybrid_player, {
	|
	out=0, gate=1, amp=0.9, buf, rate=1, pan=0.0,
	atk=5, dcy=0.1, sus=0.7, rel=5,
	width=2,
	fx_pre_bus=0, fxpresend=0.0,
	fx_post_bus=0, fxpostsend=0.0
	|
	var sig, sig1, sig2, env;

	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.35, 0.35);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);

	sig1 = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0);

	sig2 = Mix.ar(GrainBuf.ar(
		1,
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: 0)
	);

	// TODO: sometimes the Line time create some glitch: why?
	sig = SelectX.ar(Line.kr(0, 1.0, 0.3), [sig1, sig2]);
	sig = LeakDC.ar(sig);
	sig = sig * env;

	sig = sig * amp;
	//Out.ar(out, Pan2.ar(sig, pan));
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


/*************************************************
*    EXPERIMENTAL                                *
*************************************************/

(
SynthDef(\sliceplayer, {
	|
	out=0, amp=1.0,
	atk = 0.0, rel= 1.0,
	dur=1.0,
	loopbuf,
	loopbpm=136,loopbars=4,
	currentBpm=120,
	start=0.0
	// filters
	hf=16000,
	lf=60,
	// pan
	pan=0.0
	// decimator parameters
	bits = 16,
	sr = 44100
	|
	var bpmrate, env, ph,sig,nquarter,end;
	nquarter = loopbars * 4;
	bpmrate = currentBpm / (loopbpm/60.0);
	env = EnvGen.ar( Env(
		[0,1,1,0],
		[
			0.01,
			(BufDur.ir(loopbuf) * (bpmrate.reciprocal) * (dur/nquarter)) -0.01,
			0.01
		]
	),1, doneAction:2);
	dur = dur.clip(0.0, nquarter);
	start = start.clip(0.0, 1.0);
	end = (start + dur).clip(0.0, 1.0);

	ph = Phasor.ar(1, BufRateScale.ir(loopbuf) * bpmrate,
		BufFrames.kr(loopbuf) * start,
		BufFrames.kr(loopbuf) * end,
	0);

	sig = BufRd.ar(2, loopbuf, ph, 0.0,2) * amp * env;
	//sig = BufRd.ar(1, loopbuf, ph, 0.0,2) * amp * env;

	sig = Decimator.ar(sig, sr, bits);
	sig = LPF.ar(sig, hf);
	sig = HPF.ar(sig, lf);
	Out.ar(out, Pan2.ar(sig, 0.0));
}).add;
);


(
SynthDef(\speak, {
	|
	out=0, amp=1.0, pan=0.0, atk=0.01, rel=0.5,
	freq=440
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Formants.ar( freq, Vowel(\a,\bass).addControls(lag:1) );
	sig = sig * amp * env;
	Out.ar(out, Pan2.ar(sig,pan));
}).add;
);


/*************************************************
*    REVERB                                      *
*************************************************/


(
SynthDef(\verb, {
	arg in, out=0, dec=4, lpf=1500, wet=1.0;
	var sig;
	sig = In.ar(in, 1);
	//sig = In.ar(in, 2).sum;
	sig = DelayN.ar(sig, 0.03, 0.03);
	sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
	sig = SplayAz.ar(2, sig);
	sig = LPF.ar(sig, lpf);
	5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
	sig = LPF.ar(sig, lpf);
	sig = LeakDC.ar(sig);
	//Out.ar(out, (sig*wet) + (in*(1.0-wet)));
	Out.ar(out, (sig*wet));
}).add;
);


(
SynthDef(\Gverb, {
	arg in, out=0, wet=1.0, roomsize=100, revtime=3, damping=0.5;
	var sig;
	sig = In.ar(in, 1);
	sig = GVerb.ar(sig, roomsize, revtime, damping);
	sig = LeakDC.ar(sig);
	Out.ar(out, (sig*wet));
}).add;
);



// Use with something like this:
// t = TempoClock.default;
//~delay = Synth(\delay1, [\lpf, 500, \delaytime, t.beatDur*0.25, \decaytime,1.0, \wet,1.0]);
(
SynthDef(\delay1, {
	arg in, out=0, delaytime=0.1, decaytime=1.0, wet=1.0, lpf=1500;
	var sig;
	sig = In.ar(in, 2);
	//sig = In.ar(in, 2).sum;
	sig = LPF.ar(sig, lpf);
	sig = CombL.ar(sig, 0.5, delaytime, decaytime);
	sig = LeakDC.ar(sig);
	//Out.ar(out, (sig*wet) + (in*(1.0-wet)));
	Out.ar(out, (sig*wet));
}).add;
);


// TAPE DELAY (still a WIP)
// use it like this:
// d = Synth(\tapedly, [\in, 0, \dlytime, 0.333, \fb, 0.5, \wet, 1.0]);
// d.set(\dlytime, 0.25, \fb, 0.8,\wet, 1.0,\fc, 5000);

(
SynthDef(\tapedly, {
	|in=0, out=0, fb=0.6, lpf=5000, delaytime=0.125, wet=0.5, pan=0.0|
	var local, sig, delayed, phi, phR, phP, freq;
	var tdbh; // time delay between heads (seconds)
	local = LocalBuf(SampleRate.ir * 3, 1);
	local.clear; // clear the buffer

	tdbh = 0.0125;
	//tdbh = 0.125;
	phi = (2 * tdbh) / BufDur.ir(local);
	freq = 1.0 / BufDur.ir(local); // frequency to playback the buffer at rate 1
	freq = (freq * tdbh) / VarLag.kr(delaytime, 2, warp:\linear);
	phR = LFSaw.ar( freq, phi, 0.5, 0.5)*BufFrames.kr( local );
	phP = LFSaw.ar( freq, 0.0, 0.5, 0.5)*BufFrames.kr( local );

	sig = Mix.ar(In.ar(in,2));
	delayed = BufRd.ar(1, local, phP, loop:1);
	delayed = delayed.tanh;
	BufWr.ar( LPF.ar( (sig + delayed), lpf, mul:fb), local, phR, loop:1);
	pan = LFNoise1.ar(5);
	Out.ar(out, Pan2.ar(delayed*wet, pan));
}).add;
);



/*************************************************
*    GLITCH and NOISE                            *
*************************************************/
/*
// try to use it like this
Pbindef(\A,
	\instrument, \glicth1,
	\scale, Scale.minor,
	\octave, 3,
	\degree, 0, //Pxrand([0,2,4],inf),
	\dur, 0.125, //Prand([Pn(0.25,2),Pn(0.125,2)],inf),
	\decay, Pexprand(0.1, 0.001, inf),
	\amp, 1, //Pwhite(0.3, 0.9, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf)
).quant_(1);
*/

(
SynthDef(\glicth1, {
	|freq=440,amp=1.0
	rf=1000, q=1,
	decay=1,
	out=0, pan=0.0
	|
	var sig = Impulse.ar(0);
	sig = Ringz.ar(sig, freq, decay) * amp;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

/*
(
Pbindef(\B,
	\instrument, \glitch2,
	\dur, 0.125,
	\amp, 1,
	\pan, Pwhite(-1.0, 1.0, inf),
	\addAction, Pwrand([0,1],[0.1,1].normalizeSum,inf)
).quant_(1);
);
*/
(
SynthDef(\glitch2, {
	|amp=1.0,out=0, pan=0.0|
	var sig = Resonz.ar(Impulse.ar(0), freq:77, bwr:300) * amp;
	sig = sig.softclip;
	DetectSilence.ar(sig, 0.0001, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

/*
// try use it this way
(
Pbindef(\hi,
	\instrument, \hiSin,
	\freq, 16000,
	\amp, 0.6,
	\dur, 3
);
);
Pbindef(\hi).play;

(
Pbindef(\lo,
	\instrument, \hiSin,
	\freq, 60,
	\amp, 0.6,
	\dur, 4
);
);
Pbindef(\lo).play;


(
Pbindef(\chirp,
	\instrument, \hiSin,
	\freq, 14000, //Pexprand(14000, 17000, inf),
	\amp, 0.8,
	\atk,0.0,
	\rel, 0.001,
	\dur, Pseq([Pn(0.125,Prand((3..5),inf).asStream), 4], inf)
);
);
Pbindef(\chirp).play;
*/
(
SynthDef(\hiSin, {
	|freq=16000, atk=1,rel=0, out=0, amp=1.0|
	var env =EnvGen.ar(Env.perc(atk, rel, curve:[4,-4]), doneAction:2);
	var sig = SinOsc.ar(freq, [0.0, 0.5pi], mul:env) * amp;
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\distSin, {
	|freq=16000, atk=1,rel=0, out=0, amp=1.0,dist=1.0|
	var env =EnvGen.ar(Env.perc(atk, rel, curve:[4,-4]), doneAction:2);
	var sig = SinOsc.ar(freq, 0.5pi, mul:env);
	sig = (sig*dist).tanh * amp;
	Out.ar(out, sig!2);
}).add;
);

// SPUTNIK

(
SynthDef(\sputnik, {
	var trig = Impulse.kr(0);
	var env = EnvGen.ar(Env.perc(0.0, 6, curve:[4,-8]), trig);
	var sig = RLPF.ar(PinkNoise.ar(), 880, 0.005) * env * 0.15;
	//sig = HPF.ar(sig, 600);
	sig = FreeVerb2.ar(sig, sig, mix:0.4, room:0.85, damp:0.95);
	DetectSilence.ar(sig, doneAction:2);
	Out.ar(0, sig)
}).add;
);


/*************************************************
*    DRUMS                                       *
*************************************************/


/*
// KICK1
// A simple kick with frequency envelope and distorsion.

ARGS:

out  = channel out
amp  = volume
freq = note frequency (default 60Hz)
dist = a value between 1.0 and +inf to increase the distorsion
atk  = attack time of amplitude envelope
rel  = release time of amplitude envelope
fatk  = attack time of frequency envelope
frel  = release time of frequency envelope
frange = a multiplyer for the frequency envleope range

USE EXAMPLE:

(
//dark
Pbindef(\kick,
	\instrument, \kick,
	\freq, 60,
	\dur,Pseq([Pn(1,7), Pn(0.5,2)], inf),
	\atk, 0.005, \rel, 0.2,
	\fatk, 0.01,\frel, 0.1, \frange, 0.2,
	\dist,1,
	\amp, 0.6
).quant_(1);
);

(
//aggressive
Pbindef(\kick,
	\instrument, \kick,
	\freq, 60,
	\dur,Pseq([Pn(1,7), Pn(0.5,2)], inf),
	\atk, 0.003, \rel, 0.2,
	\fatk, 0.001,\frel, 0.001, \frange, 0.1,
	\dist, 2,
	\amp, 0.3,
    \addAction, 1
).quant_(1);
);

(
// gabba
Pbindef(\kick,
	\instrument, \kick,
	\freq, 60,
	\dur,Pseq([Pn(1,7), Pn(0.5,2)], inf),
	\atk, 0.002, \rel, 0.4,
	\fatk, 0.001,\frel, 0.001, \frange, 0.2,
	\dist, 10,
	\amp, 0.1
).quant_(1);
)
*/

(
SynthDef(\kick, {
	|amp=1.0, dist=1.0, out=0, pan=0.0,
	atk=0.001, rel=1,
	fatk=0.2, frel=0.1,fenvamt=2.0,
	freq=60
	|
	var env = EnvGen.ar(Env.perc(atk, rel),doneAction:2);
	var fenv= EnvGen.ar(Env.perc(fatk, frel), levelScale: fenvamt, doneAction:0);
	var sig = SinOsc.ar(freq + fenv, 0.5pi);
	sig = sig * env * dist;
	sig = sig.tanh * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);



/*
(
Pbindef(\k,
	\instrument, \kickFm,
	\freq, 50,
	//amplitude envelope
	\atk, 0.0, \rel, 0.5,
	// pitch modulation
	\fenvamt, 10.0, \fatk, 0.1, \frel, 0.2,
	// frequency modulation
	\mf, 100, \mi, 100, \matk, 0.01, \mrel, 0.01,
	\dist, 2.0,
	\amp, 1,
	\dur, 1,
	\addAction,1
).quant_([1,0]).play;
)
*/

//fm_kick
// fm kick
(
SynthDef(\kickFm, {
	|
	out=0, pan=0.0, amp=1.0, freq=60,
	//amplitude envelope
	atk=0.001, rel=1,
	// pitch modulation
	fenvamt=2.0, fatk=0.2, frel=0.1,
	// frequency modulation
	mf=100, mi=10, matk=0.001, mrel=0.01,
	dist=1.0
	|
	var env = EnvGen.ar(Env.perc(atk, rel),doneAction:2);
	var fenv= EnvGen.ar(Env.perc(fatk, frel), levelScale: fenvamt, doneAction:0);
	var mod = SinOsc.ar(mf, mul:mi) * EnvGen.ar(Env.perc(matk, mrel));
	var sig = SinOsc.ar(freq + mod + fenv, 0.5pi);
	sig = (sig * env) * dist;
	sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig * amp, pan));
}).add;
);


/*
(
Pbindef(\s,
	\instrument, \snareFm,
	\freq, 90,
	//amplitude envelope
	\atk, 0.0, \rel, 0.1,
	// pitch modulation
	\pamp, 100, \patk, 0.0, \prel, 0.2,
	// frequency modulation
	\nf, 3500,\rq, 0.3,\namp, 3,\natk, 0.01, \nrel, 0.3,
	\dist, 1,
	\amp, 1,
	\dur, 2,
	\addAction,1
).quant_([1,1]).play;
)
Pbindef(\s).stop;
*/


(
SynthDef(\snareFm, {
	|
	out=0, pan=0.0, amp=1.0, freq=60,
	//amplitude envelope
	atk=0.0, rel=0.1,
	// pitch modulation
	pamp=100, patk=0.0, prel=0.2,
	// frequency modulation
	nf=3500, rq=0.3, natk=0.01, nrel=0.3,namp=3
	dist=1.0
	|
	// amplitude modulation
	var env = EnvGen.ar(Env.perc(atk, rel),doneAction:0);
	// pitch modulation
	var fenv= EnvGen.ar(Env.perc(patk, prel), levelScale: pamp, doneAction:0);
	// filtered noise
	var mod = BPF.ar(WhiteNoise.ar(), nf, rq, mul:EnvGen.ar(Env.perc(natk, nrel, curve:[4,-2]), levelScale: namp));

	var sig = SinOsc.ar(freq + fenv, 0.5pi, mul:env) + mod;

	sig = (sig * dist).tanh * amp;
	DetectSilence.ar(sig, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);



/*
PLUCK
Inpired by a "Benoit and the Mandelbrot" set
*/
(
SynthDef(\pluck, {
	|out=0, freq=440, pan=0.0, amp=1.0, coef, dcy=1, dist=1, atk=0.1, rel=0.5|
	var exc, sig, env;
	exc = WhiteNoise.ar() * EnvGen.ar(Env.perc(atk, rel));
	sig = Pluck.ar(exc, 1, 0.2,freq.reciprocal,dcy,coef:coef.clip(-1.0, 1.0));
	sig = (sig * dist).clip(-1.0, 1.0) * amp;
	sig = LeakDC.ar(sig);
	DetectSilence.ar(sig, 0.0001, 0.01, doneAction:2);
	Out.ar(out, Pan2.ar(sig,pan));
}).add
);


/*
BELL1
exciter resonator sound to model instruments like bells, tubulars bells, xilophone, marimba, glokenspiel
*/

(
SynthDef(\bell1, {
	|out=0, freq=440, pitchy=1, t60=1, exc_amp=0.25, amp=0.25, pan=0.0, atk=0.001, rel=0.05|
	var sig, exciter;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(atk, rel), gate:1) * exc_amp;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60 // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	sig = sig * amp;
	//sig = sig + CombN.ar(sig, 1, 0.1, 0.7);
	//sig = FreeVerb.ar(sig, 0.7,0.7,0.6) * amp;
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


/*
FM1
A basic frequency modulation synthetizer

ARGS:

out  = channel out
amp  = volume
freq = note frequency
fMod = modulator frequency
mIdx = the index modulation
atk  = attack time of amplitude envelope
rel  = release time of amplitude envelope

USE EXAMPLE:

Pbind(\instrument, \fm1, \degree, Prand([0, 1,2,3,4,5],inf), \octave, Pwhite(0, 8, inf).round(1), \atk, 0.01, \rls, 1/(Pkey(\dur)*4), \dur,Pbjorklund2(Prand((1..3),inf), 8, inf)/8, \mi, Pwhite(0.0, 1000, inf), \mf, Pwhite(1, 1000, inf), \pan, Pwhite(-0.8, 0.8), \amp, Pwhite(0.1, 0.9));

*/

(
SynthDef(\fm1, {
	|
	out=0, amp=1.0, freq=440, pan=0.0,
	atk=0.01, rel=0.25,
	mi=0, mf=1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = SinOsc.ar(freq + SinOsc.ar(mf, mul:mi));
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

(
SynthDef(\fm2, {
	|
	out=0, amp=1.0, freq=440, pan=0.0,
	atk=0.01, rel=0.25,
	mr = 1.0, mi=0
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = SinOsc.ar(freq + SinOsc.ar(freq * mr, mul:mi));
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

// still a wip (thanks to Eli Fieldsteel FM tutorial 22)
(
SynthDef(\fm3, {
	|
	out=0, amp=1.0, freq=440, pan=0.0,
	atk=0.01, rel=0.25,
	mr = 1.0, mi=0,
	iAtk=0.01, iRel=0.25, icAtk=4, icRel=(-4),iScale=2
	|
	var env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	//index of modulation
	var iEnv = EnvGen.kr(
		Env(
			[1, iScale, 1],
			[iAtk, iRel],
			[icAtk, icRel]
		), levelScale:mi*freq;
	);
	var mod = SinOsc.ar(freq * mr, mul:iEnv);
	var sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

// my wip (based on chowning 1973 paper)
(
SynthDef(\fm4, {
	|
	amp=1.0, freq=440, pan=0.0, out=0, gate=1,
	atk=0.0, dcy=0.1, sus=0.7, rel=0.1,
	mi=0, n1=1, n2=1, iatk=0.01, irel=0.1, iAdd=0.0
	|
	var env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);
	var iEnv= EnvGen.ar(Env.perc(iatk, irel),1);
	var fmod = freq*n2;
	var mod = SinOsc.ar(fmod, mul:(mi*iEnv), add:iAdd );
	var sig = SinOsc.ar(freq*n1 + mod);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

(
SynthDef(\fm4_perc, {
	|
	amp=1.0, freq=440, pan=0.0, out=0,
	atk=0.0, rel=0.1,
	mi=0, n1=1, n2=1, iatk=0.01, irel=0.1, iAdd=0.0
	|
	var env = EnvGen.ar(Env.perc(atk,rel), 1, doneAction:2);
	var iEnv= EnvGen.ar(Env.perc(iatk, irel),1);
	var fmod = freq*n2;
	var mod = SinOsc.ar(fmod, mul:(mi*iEnv), add:iAdd );
	var sig = SinOsc.ar(freq*n1 + mod);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);




/*
FM PADS 1
A basic fm pad.

ARGS:
out    = channel out
amp    = volume
freq   = note frequency
mRatio = a value representing the ratio fCarrier / fModulator
mIdx   = the amount of index modulation (index modulation will follow the same evelope as amplitude)
atk    = attack time of amplitude and modulation index envelope
rel    = release time of amplitude and modulation index envelope

USE EXAMPLE:

(
~fmpads = Pbind(
	\instrument, \fm_pads1,
	\octave, Pwrand([5,6,7],[3,2,1].normalizeSum, inf),
	\scale, Scale.minor,
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\root, 0,
	\degree, Pwrand([0,4,7],[3,1.5, 2].normalizeSum, inf),
	\mIdx, Pexprand(100, 1000, inf),
	\mRatio, Prand([0.125, 0.25, 0.5, 2, 4, 8], inf),
	\dur, Pwhite(1, 5, inf),
	\atk, Pkey(\dur)*2,
	\rel, Pkey(\dur)*3,
	\amp, Pwhite(0.05, 0.1, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
)
)
*/


(
SynthDef(\fm_pads1, {
	|out=0, amp=1.0, pan=0.0,
	freq=440, mRatio=1, mIdx=400
	atk=0.01, rel=0.1
	|
	var sig, env, iEnv, tremolo;
	env  = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.ar(Env.perc(atk, rel, curve:[4,1])) * mIdx;
	//iEnv = EnvGen.ar(Env.new([0,1], [atk+rel]));
	sig = SinOsc.ar( freq + SinOsc.ar(freq/mRatio, mul:iEnv));
	sig = sig * amp * env; // * SinOsc.kr(6,mul:Line.kr(0,
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

/*
FM BASS 1
An fm bass synth. Inpired by Eli Fieldsteel SC tutorial 22 (https://www.youtube.com/watch?v=dLMSR2Kjq6Y)

ARGS:

out    = channel out
amp    = volume
freq   = note frequency
mRatio = a value representing the ratio fCarrier / fModulator
mIdx   = the amount of index modulation (index modulation will follow the same evelope as amplitude)
atk    = attack time of amplitude and modulation index envelope
rel    = release time of amplitude and modulation index envelope

USE EXAMPLE:

(
~fmbass1 = Pbind(
	\instrument, \fm_bass1,
	\octave, 4,
	\scale, Scale.minor,
	\degree, Pseq([0,7], inf),
	//\detune, Pwhite(0, 1),
	\mIdx, 400, //Pseries(0, 100, inf).trace, //Pwhite(0, 400, inf),
	\mRatio, 4, //Prand([0.125, 0.25, 0.5, 2, 4, 8], inf),
	\dur, Pseq([Pbjorklund2(3,8,3)/4, Pseq(0.25.dup(8), 1)], inf),
	\atk, Pkey(\dur)*0.01,
	\rel, Pkey(\dur)*0.5,
    \iatk, Pkey(\atk)*0.01,
	\irel, Pkey(\rel)*0.5,
	\amp, Pwhite(0.4, 0.8, inf)
)
)

~fmbass1.quant_(4)
~fmbass1.fadeTime_(0.01)
~fmbass1.play;
~fmbass1.stop(10);

// You can also use it as a kick making some variation
// in modulation index envelope and freq ratio

(
~kick = Pbind(
	\instrument, \fm_bass1,
	\octave, 3,
	\scale, Scale.minor,
	\degree, 0,
	\mIdx, 200,
	\mRatio, 3,
	\dur, 0.5,
	\atk, 0.01,
	\rel, 1,
	\iatk, 0.01,
	\irel, 0.2, //Pkey(\rel),
	\amp, 0.3, //Pwhite(0.4, 0.8, inf)
	\out, 0
);
)
a = ~kick.asEventStreamPlayer;
a.play;
a.stop;
*/

(
SynthDef(\fm_bass1, {
	|
	out=0, amp=1.0, pan=0.0,
	freq=440, mRatio=1, mIdx=400
	atk=0.01, rel=0.1,
	iatk=0.01, irel=0.1
	|
	var sig, env, iEnv;
	env  = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.ar(Env.perc(iatk, irel, curve:[4,-4])) * mIdx;
	sig = SinOsc.ar( freq + SinOsc.ar(freq/mRatio, mul:iEnv) + [-1, 1]);
	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;
);

// SYNC SAW

/*
#EXAMPLE 1
(
Pbindef(\bass_lick,
	\instrument, \syncsaw,
	\octave, [2,3],
	\degree, Pseq([0,0,0,-1],inf),
	\atk, 0.01,
	\sf, 10,
	\rel, 0.4,
	\dur, Pseq([1, 1, 1, 0.5],inf),
	\amp, 0.4,
	\bus, ~fxsend,
	\send, Pseries(0.0, 0.01, inf).wrap(0.0, 1.0)
).quant_(1).play;
)

#EXAMPLE (BPM 120)
(
Pbindef(\lick1,
	\instrument, \syncsaw,
	\scale, Scale.minor,
	\octave, [2,3,4],
	\detune, Pseries(0.0, 0.1, inf).wrap(0.0, 0.8), //Pwhite(0.0, 0.5, inf).clump(4),

	\degree, Pseq([
		Pseq([\rest, 0,0,0,0,0,0,-7], 3),
		Pseq([\rest,2,3,4,5,6,7,8],1)-8
	],inf),
	\dur, 0.5,
	\atk, 0.0,
	\rel, 0.5,
	\sf, ((60+Pkey(\degree))-48).midicps,
	\amp, Pn(Pseries(0.2, 0.05, 8).clip(0.0, 1.0), inf),
	\lag, Pwhite(0.0, 0.01, inf)
).quant_(4).play;
)
*/

(
SynthDef(\syncsaw, {
	|freq=440, sf=10, amp=1.0, atk=0.01, rel=0.1, pan=0.0|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = SyncSaw.ar(sf, freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
);

/* variant 1
(
SynthDef(\syncsaw, {
	|freq=440, sf=10, amp=1.0, atk=0.01, rel=0.1, bus=0, send=0.0|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = Decay.ar(Impulse.ar(0))*SinOsc.ar(freq) + SyncSaw.ar(sf, freq*[1.001, 0.999]) * env * amp;
	Out.ar(0, Pan2.ar(sig, 0.0));
	Out.ar(bus, sig*send); // fx send
}).add;
);
*/




// ACOUSTIC SIMS

/* DOUBLE BASS

# EXAMPLE

## vince guaraldi

(
~bass = Pbind(
	\instrument, \doublebass,
	\octave, 3,
	\degree, Pseq([0,4,7,0,4,7]++[0,4,5,0,4,5],inf),
	\atk, 0.01,
	\rls, 0.6,
	\amp, Pseq([1,0.6,0.6],inf),
	\dur, Pseq([Pn(0.5, 5), 1.5], inf),
	\lag, Pseq([Pwhite(-0.01, 0.01,inf), -0.025], inf)
);
~bass.quant_(1);
~bass.play;
~bass.stop;
)

*/
(
SynthDef(\doublebass, {
	|freq=440, pan=0.0, amp=1.0, out=0
	atk=0.05, rel=0.2, fc=67|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), 1, doneAction:2);
	sig = Pulse.ar(freq, 0.3);
	sig = LPF.ar(sig, fc);
	sig = sig * env * amp * 2;
	sig = LeakDC.ar(sig);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


// WAVETABLE SYNTHESIS
(
SynthDef(\wtplay,{
	|wt, amp=0.5, pan=0.0, freq=400, out=0, atk=3, rls=3|
	var env, sig;
	env = EnvGen.ar(Env.perc(atk, rls), doneAction:2);
	sig = Osc.ar(wt, freq*[1, LFNoise1.kr(0.1).range(1.99, 2.01)]) * amp * env;
	sig = LeakDC.ar(Mix.ar(sig));
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);

/*
SQUARE BASS

use it with somethig like that:

Pbind(\instrument, \squarebass,\degree, Pseq([0,  2, 5, 7], inf), \octave, 3, \scale, Scale.major, \dur, Pseq([Pser([1], 2),2], inf)/Prand([2,4],inf), \width, 0.3, \amp, 1.1, \detune, 0.1 );

*/

(
SynthDef(\squarebass, {
	|
	out=0, freq=440,
	amp=1.0, pan=0.0,
	width=0.5, detune=0.1,
	atk=0.01, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);

	sig = LFPulse.ar(freq + LFNoise1.ar(10, detune), width:width);
	sig = sig * env * amp;
	sig = Decimator.ar(sig, 11025, 8);
	sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
);


/*
ACID: a synth made of a sawtooth wave filtered with a resonant low pass filter
The synth has 2 separated envelopes, one for the amplitude and the other
controlling the cut frequency of the filter.

Use it with Pbind and legato values < 1!

(
Pbindef(\acid,
	\instrument, \acid,
	\scale, Scale.minor,
	\octave, [2,3],
	\degree, 0, //, //[0,2,4], //[0, 3,6], //Pseq([0,7],inf),
	\amp, 0.25,
	\atk, 0.0, \rel, 0.1,
	\fatk, 0.0,  \frel, 0.05,
	\dur, 0.5,
	\famp, Pseries(1,0.25, inf).fold(1,8),
	\legato, 0.5,
	\addAction,1
).quant_(1).play;
)
*/
(
SynthDef(\acid, {
	|
	out=0,
	amp=1, freq=440, pos=0.0,
	gate=1,
	atk=0.01, dcy=0.05, sus=0.7, rel=0.5,
	rf=440, rq=0.1,
	fatk=0.01, fdcy=0.05, fsus=0.7, frel=0.5,famp=1
	|
	var sig, env, fenv;

	// amplitude envelope
	env   = EnvGen.ar(Env.adsr( atk,  dcy,  sus,  rel, curve:[4, -4, -4]), gate:gate, doneAction:2);
	// cut frequency envelope
	fenv  = EnvGen.ar(Env.adsr(fatk, fdcy, fsus, frel, curve:[4, -4, -4]), gate:gate, levelScale:famp);
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig, rf*fenv, rq);
	sig = sig * env * amp;
	// a little bit of distorsion
	//sig = sig.tanh;
	Out.ar(out, Pan2.ar(sig, pos))
}).add;
);



// CAOS //////////////////////////////////////////////////////////////////////////////////////////////

/*
CAOS SINE
to be used with somwthing like this:

(
~caossine = Pbind(
	\instrument,\caossine,
	\scale, Scale.minorPentatonic,
	\degree, 0,
	\detune, 0,
	\octave, Prand((3..12), inf),
	\dur, 0.5,
	\im, Pwhite(16, 35, inf),
	\fb, Pwhite(0.1, 16, inf),
	\a, Pexprand(0.1,1.2, inf),
	\c, Pexprand(1,6, inf),
	\atk, 0.1,
	\sus, 0,
	\rel, Pexprand(0.1,0.3, inf),
	\amp, 0.3,
	\pan, Pwhite(-1.0, 1.0, inf)
);
)
~caossine.play;
~caossine.stop;
*/
(
SynthDef(\caossine,
	{arg freq=440, im=1, fb=0.1, a=1.1, c=0.5, xi=0.30501993062401,yi=0.20938865431933,atk=0.01,sus=1,rel=1,ts=1,out=0,pan=0,amp=0.3;
		var sig,env;
		sig = FBSineN.ar(freq,im,fb,a,c,xi,xi);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,ts,doneAction:2);
		sig = LeakDC.ar(sig);
		sig = sig*env*amp;
		sig = sig.tanh();
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);


/*
CAOS SINE MOVE

use with something like this:

(
~fbsin = Pbind(
	\instrument,\caossinemove,
	\scale, Scale.minorPentatonic,
	\degree, 0,
	\octave, Prand([8,9,12], inf), //rand((3..12), inf),
	\dur, 1, //Pwhite(0.25, 0.25, inf),
	\im, Pwhite(16, 35, inf),
	\fb, 0.1, //Pwhite(0.1, 16, inf),
	\a, 1.005, //Pexprand(0.1,1.2, inf),
	\c, 0.1, //Pexprand(1,6, inf),
	\atk, 0.1,
	\sus, 0.7,
	\rel, 0.1, //Pexprand(0.1,0.3, inf),
	\amp, 0.3,
	\pan, 0.0 //Pwhite(-1.0, 1.0, inf)
);)

or this for the "matrix scream effect" (to be triggered only from time to time)
try also with other value for parameter c (0.4, 0.7) to obtain other interesting
talking effects|
(
~fbsin = Pbind(
	\instrument,\caossinemove,
	\scale, Scale.minorPentatonic,
	\degree, 0,
	\octave, 8,
	\dur, 1,
	\im, Pwhite(16, 35, 1),
	\fb, 0.1,
	\a, 1.005,
	\c, 0.1,
	\atk, 0.1,
	\sus, 0.7,
	\rel, 0.1, //Pexprand(0.1,0.3, inf),
	\amp, 0.3,
	\pan, 0.0 //Pwhite(-1.0, 1.0, inf)
);)


// or like this for some hifreq "cutting blades"
(
~fbsin = Pbind(
	\instrument,\caossinemove,
	\scale, Scale.minorPentatonic,
	\degree, Pseq([0,1,2,3], inf),
	\octave, 12, //rand((3..12), inf),
	\dur, 0.25, //Pwhite(0.25, 0.25, inf),
	\im, Pwhite(16, 35),
	\fb, 0.1, //Pwhite(0.1, 16, inf),
	\a, 1.005, //Pexprand(0.1,1.2, inf),
	\c, 0.7, //0.7, //Pexprand(1,6, inf),
	\atk, Pkey(\dur)  * 0.1,
	\sus, Pkey(\dur)  * 0.5,
	\rel, Pkey(\dur)  * 0.1, //Pexprand(0.1,0.3, inf),
	\amp, 0.3,
	\pan, 0.0 //Pwhite(-1.0, 1.0, inf)
);)
*/

(
SynthDef(\caossinemove,
	{arg freq=440, fb=0.1, a=1.005, c=0.7, xi=0.30501993062401,yi=0.20938865431933,atk=0.01,sus=1,rel=1,ts=1,out=0,pan=0,amp=0.3;
		var sig,env;
		sig = FBSineN.ar(freq, XLine.kr(16,35, atk+sus), fb, a, c);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,ts,doneAction:2);
		sig = LeakDC.ar(sig);
		sig = sig*env*amp;
		sig = sig.tanh();
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);





/*
HENON 2D

to be used with something like this:

(
~henon = Pbind(
	\instrument,\henon2D,
	\scale, Scale.minorPentatonic,
	\degree, 0,
	\detune, 0, //Pwhite(-1, 1, inf),
	\octave, Prand((3..6), inf),
	\mfreq, Pexprand(100, 10000, inf),
	\dur, 0.25, //Pwhite(0.25, 0.5, inf),
	\a, Pexprand(0.1,1.2, inf),
	\b, Pexprand(1,6, inf),
	\atk, 0,
	\sus, 0,
	\rel, Pexprand(0.1,0.2, inf),
	\amp, 0.3,
	\pan, Pwhite(-1.0, 1.0, inf)
);)
~henon.play;

*/
(
SynthDef(\henon2D,
	{arg freq=440, mfreq=440, a=1.3,b=0.3,x0=0.30501993062401,x1=0.20938865431933,atk=0.01,sus=1,rel=1,ts=1,out=0,pan=0,amp=0.3;
		var sig,env;
		sig = Henon2DN.ar(freq, freq+mfreq,a,b,x0,x1,amp);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,ts,doneAction:2);
		sig = LeakDC.ar(sig);
		sig = sig.tanh();
		sig = sig*env;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

// GRANULAR //////////////////////////////////////////////////////////////////////////////////////////


/*
GLINEM (GRANULAR MONO PLAYER)
It uses a line to play back the sample from stat to end.
density:
caos:

ARGS:

out
amp
dur
buf     = MUST be a mono buffer!
rate    = the rate at witch each grain is played back
density = change the number of overlapping grains (keep it high)
caos    = (0-1) use this parameter to offset each grain rate, pos and pan.
*/

(
SynthDef(\glinem, {
	|
	out=0, amp=1, dur=1
	buf, density=50, caos=0.0,
	rate=1
	|
    var sig, env;

	//var density = 50;
	var trigger = Impulse.kr( density );
	var pos = Line.kr(0.0, 0.6, dur, doneAction:0) + (TRand.kr(-0.01, 0.01, trigger) * caos);
	var length = 2.0/density;
	var pan = 0.0 + (TRand.kr(-0.8, 0.8, trigger) * caos);
	rate = rate + (TRand.kr(-0.01, 0.01,trigger) * caos);

	env = EnvGen.kr(Env.perc(0.0,dur), doneAction:2);

    sig = GrainBuf.ar(2,
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: pan);

	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\glinem_rev, {
	|
	out=0, amp=1,
	buf, density=50, caos=0.0,
	rate=1,
	atk=0.0, rel=1.0
	|
    var sig, env;

	//var density = 50;
	var trigger = Impulse.kr( density );
	var pos = Line.kr(0.0, 0.6, rel, doneAction:0) + (TRand.kr(-0.01, 0.01, trigger) * caos);
	var length = 2.0/density;
	var pan = 0.0 + (TRand.kr(-0.8, 0.8, trigger) * caos);
	rate = rate + (TRand.kr(-0.01, 0.01,trigger) * caos);

	env = EnvGen.kr(Env.perc(atk, rel, curve:4), doneAction:2);

    sig = GrainBuf.ar(2,
		trigger,
		length,
		buf,
		rate.clip(0.1, 3),
		pos,
		2,
		pan: pan.clip(-1.0, 1.0)
	);

	sig = sig.tanh * amp * env;
	Out.ar(out, sig);
}).add;
);




(
SynthDef(\gfm, {
	|
	freq=440, mf=0.0, mi=0.0, envbuf=(-1),
	pan=0.0, amp=1.0, out=0,atk=1.0,rel=1.0, gdensity=100, gdur=0.01
	|
	var env = EnvGen.ar(Env.perc(atk, rel),1, doneAction:2);
	var sig = GrainFM.ar(
		2,
		Impulse.kr( gdensity ),
		gdur,
		freq, // carrier freq
		mf * freq,   // mod freq
 		mi,   // mod index
		pan,
		envbufnum:envbuf
	) * env * amp;
	Out.ar(out, sig);
}).add;
);




/*
A modified version of the wtabl synth by Cotterill to be used with soundfiles from
AKWF (https://www.adventurekid.se).
Beacuse all wavetable files from AKWF are sampled at D1+2, we take it into account in
calculatin the playback rate.
*/

(
SynthDef(\AKWF_wtabl,{
	|out=0, buf=0, freq=300, amp=0.5, pan=0, atk=0.01, rel=1|
	var sig, env;
	sig = PlayBuf.ar(1,buf,BufRateScale.ir(buf) * (freq / (38.02.midicps)),1,0,1);
	env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out,Pan2.ar(sig, pan));
}).add;
);


/*
A modified version of Cotterill lplay synth
out = channel out
buf = buffer index
amp = volume
pan = stereo panning

start = a normalized value to define the start position inside the buffer
bed = represents the number of SC song quarter notes for the loop to be played inside
dur = represents the number of quarter notes of the loop to be played back

*/
/*
// temporary comment
(
SynthDef(\lplay, {
	|out=0, buf, amp=1.0, pan=0.0, dur=4, bed=8, start=0|
	var sig, env, rate;
	var duration = dur / p.clock.tempo;
	// keep 10ms for fade in/out
	var fadeTime = 0.01;
	// the remaining time from duration is the envelope sustain
	var susTime  = (1-fadeTime) * duration;
	env = EnvGen.ar(Env([0, 1, 1, 0],[fadeTime, susTime, fadeTime],[-4, 0, 4]),doneAction:2);
	rate = (BufFrames.kr(buf) * p.clock.tempo) / (s.sampleRate * bed);
	start = start.clip(0,1) * BufFrames.kr(buf);
	sig = PlayBuf.ar(2, buf, rate,1, start, 0.0, doneAction:2);
	Out.ar(out, sig);
	//sig = Mix.ar(sig * env * amp);
	//Out.ar(out, Pan2.ar(sig, pan));
}).add;
);
*/

// synths by Sean Cotterill /////////////////////////////////////////////////////////////////////////////////

/*

vplaym: enveloped mono buffer player
For mono buffers only

Arguments:

out = Channel out
buf = Buffer index
rate = Speed of playback
amp = volume
pan = pan (stereo)
atk = attack
rel = release
pos = position to start playback from 0 to 1

*/
(
SynthDef(\vplaym,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, atk=0.01, rel=1, pos=0;
		var sig, env;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0.0,1));
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);
/*

vplay: enveloped stereo buffer player
For stereo buffers only
The default is to have no attack, as I use this to create a 'chopped-up' effect

Arguments:

out = Channel out
buf = Buffer index
rate = Speed of playback
amp = volume
pan = pan (stereo)
atk = attack
sus = sustain
rel = release
pos = position to start playback from 0 to 1

*/
(
SynthDef(\vplay,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, atk=0.0, sus=1, rel= 0, pos=0;
		var sig, env;
		sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(atk,sus,rel,1),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);




/*

bplay: basic stereo buffer player
This is the bread and butter of my SynthDef library
Designed for simple repeated playback of stereo buffers inside of a pattern
TODO: This - Stereo samples are currently mixed down to mono and positioned in a stereo field by using the Pan2 Ugen. I'm going to correct this soon

out = channel out
buf = buffer index
rate = rate of playback (or pitch)
amp = volume
pan = stereo panning of sample
pos = position of playback (usually not used)
rel = release (usually not used, this is only really in case I accidentally play a sample backwards, and need the synth to free at some point in the future, or schedule very long samples to be played. This is a security measure in case I box my processor.)

*/
(
SynthDef(\bplay,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);


(
SynthDef(\susbplay,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, gate=1, atk=0.0, rel=15;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf)*rate,1,BufFrames.kr(buf)*pos,doneAction:2),pan);
		env = EnvGen.ar(Env.asr(atk,1.0,rel),gate,doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);

(
SynthDef(\posbplay,
	{arg out = 0, buf = 0, rate = 1, gate=1, amp = 0.5, pan = 0, pos = 0, atk=0.001, rel=0.001,cf=500, rq=0.1;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.asr(atk,1.0,rel),gate,doneAction:2);
		//sig = BPF.ar(sig, cf, rq);
		//sig = HPF.ar(sig, 500);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

/*

bplaym: basic mono buffer player
Designed for simple repeated playback of mono buffers inside of a pattern

out = channel out
buf = buffer index
rate = rate of playback (or pitch)
amp = volume
pan = stereo panning of sample
pos = position of playback (usually not used)
rel = release (usually not used, this is only really in case I accidentally play a sample backwards, and need the synth to free at some point in the future, or schedule very long samples to be played. This is a security measure in case I box my processor.)

*/
(
SynthDef(\bplaym,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, atk=0.0, rel=15;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf)*rate,1,BufFrames.kr(buf)*pos,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(atk,rel,0.01),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);

(
SynthDef(\susbplaym,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, gate=1, atk=0.0, rel=15;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf)*rate,1,BufFrames.kr(buf)*pos,doneAction:2),pan);
		env = EnvGen.ar(Env.asr(atk,1.0,rel),gate,doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);

(
SynthDef(\posbplaym,
	{arg out = 0, buf = 0, rate = 1, gate=1, amp = 0.5, pan = 0, pos = 0, atk=0.001, rel=0.001, cf=500, rq=0.1;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufFrames.kr(buf)*pos,doneAction:2));
		env = EnvGen.ar(Env.asr(atk,1.0,rel),gate,doneAction:2);
		//sig = BPF.ar(sig, cf, rq);
		//sig = HPF.ar(sig, 500);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);



/*

bplaymr: basic reversed mono buffer player
plays back a mono sample in reverse. I designed this for a specific instance but kept it in the setupfile because why not. It takes away some of the extra work needed to schedule the playing of backward sample within my other SynthDefs

out = channel out
buf = buffer index
rate = rate of playback (or pitch)
amp = volume
pan = stereo panning of sample
pos = position of playback (usually not used)
rel = release (usually not used, this is only really in case I accidentally play a sample backwards, and need the synth to free at some point in the future, or schedule very long samples to be played. This is a security measure in case I box my processor.)

*/

(
SynthDef(\bplaymr,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=3;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,rate.neg,1,BufFrames.kr(buf)*44100-2,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
);


(
//SynthDef based on an overdriven DFM1 - this is very CPU intensive
//Using resonance values of >1 only will sound the freq value and detune it.
//good for stabs, but is buggy

/*
(
Pbindef(\dfm,
	\instrument, \dfm1,
	\scale, Scale.minor,
	\octave, 3,
	\degree, Prand([-1,0,7],inf), //[0, 3,6], //Pseq([0,7],inf),
	\amp, 0.125,
	\atk, 0.01, \rel, 0.5,
	\res, Pwhite(2.0, 5.0, inf),
	\type, 0,
	\noise, 0.03,
	\dur, 0.25,
	\addAction,1
).quant_(4);
)
*/

SynthDef(\dfm1, {
	|
	out=0, freq = 440,
	res = 1,type = 0, noise = 0.0003,
	atk = 0.01, rel = 1,
	amp=1.0, pan=0.0
	|

	var sig, env;
	env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	sig = DFM1.ar(SinOsc.ar(freq),freq,res,1,type,noise);
	sig = sig*env*amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;
);


/*

lplay - a looping player for stereo samples that uses the dur value to automatically pitch samples for looping over a given number of beats. I built this to grab a bunch of drum loops and percussion loops at roughly the correct tempo and use them at the clock rate of my set.

out = channel out
buf = buffer index
amp = volume
pan = stereo panning
rel = release (mostly here to prevent runaway PlayBufs)
dur = duration, in beats, that you would like your sample scaled to. For example a sample played over 8 beats would have a dur of 8 specified. Note that this repitches the sample in order to scale it to the correct beat, so it could end up at a _very_ different pitch

(
SynthDef(\lplay,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, rel=15, dur = 8;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * ((BufFrames.ir(buf)/s.sampleRate)*p.clock.tempo/dur),1,0,loop:0,doneAction:2));
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		//sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);
*/

/*
SINFB

ARGS:

freq =
atk  = attack time
sus  = sustain time
rel  = release time
fb   =
amp  =
out  =
pan  =

USE EXAMPLE:

pad example:
~sinfb = Pbind(\instrument, \sinfb,
	\scale, Scale.minor,
	\degree, Prand([[0,2,4],[0,3,5] ], inf),
	\fb, Pwhite(0.1, 1, inf),
	\atk, 2,
	\rel, 10,
	\dur, 8,
	\amp, 0.5,
	\pan, Pwhite(-0.8, 0.8, inf)
);

USE EXAMPLE 2 (use it with some verb):
(
Pbindef(\lick_lead,
	\instrument, \sin,
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

*/

(
SynthDef(\sinfb, {
	arg freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0;
	var sig, env;
	env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
	sig = SinOscFB.ar(freq,fb,1);
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);

(
SynthDef(\sinfb_adsr, {
	arg freq = 440, atk = 0.01, sus = 0.7, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0, gate=1;
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk,0.1,sus,rel),gate,1,0,1,2);
	sig = SinOscFB.ar(freq,fb,1);
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);

/*
RING1

ARGS:

freq =
d (rel)  = Ringz decay time
a (dist) = Ringz amplitude
pan  =
amp  =
out  =

USE EXAMPLE

## great for basses

try to use it with long decay and a "sidechain" kick

~root = {0}
~bass = Pbind(\instrument, \ring1, \a, 7, \d, 1, \dur, 0.25, \octave, Prand([3],inf), \root, Pkr(~root), \degree, 0, \amp, 0.25);

## also great for stabs
// see pattern guid cookboock 01

Pbind(
	\instrument, \ring1,
	\a, Pseries(1, 1, inf).fold(1, 9), // an incremental change of timbre
	\d, 0.4,
	\amp, 0.4,
	\degree, 0 // change this if you want to move the melody note
        + Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
    \dur, 0.25 + Pwrand(#[1, 0.5], #[0.6, 0.4], inf)
)

(
SynthDef(\ring1, {
		arg freq = 45, a = 9, d = 0.6, pan = 0, amp = 1, out = 0;
		var sig, env;
		env = Line.kr(0,1,d);
		env = FreeSelfWhenDone.kr(env);
		sig = Impulse.ar(0);
		sig = Ringz.ar(sig,freq,d,a);
		Out.ar(out,Pan2.ar(sig.tanh,pan) * amp)
	}, metadata: (
	credit: "by Sean Cotterill, original implementation",
	tags: [\bass, \pads, \lead]
	)
).add;
);
*/



/*

// bass:
(
Pbindef(\bass,
	\instrument, \ring1,
	\dist, Pwhite(2,5,inf),
	\amp, 0.8,
	\atk, 0.001,
	\rel, 1,
	\scale, Scale.minor,
	\octave, 4,
	\degree, 0,
    \dur, 0.25,
	\pan, 0
).quant_(4).play;
)

//80s style
(
Pbindef(\bass,
	\instrument, \ring1,
	\octave, [3,4], //Pseq([3,4,5,6], inf),
	\scale, Scale.minor,
	\dist, 50, //Pwhite(2,5,inf),
	\degree, Pseq([-1, 0, 0, -1, 0], inf),
	\amp, 0.5,
	\atk, 0.001,
	\rel, 0.25,
	\root, 2,
	\dur, Pseq([Pseq([0.125, 0.375], 1), 0.25], inf),
	\pan, 0
).quant_([4,0]).play;
)

*/

(
SynthDef(\ring1,{
	|
	freq=45, pan=0, amp=1, out=0,
	atk=0.001, rel=0.1, dist=1.0
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Ringz.ar( Impulse.ar(0) ,freq, rel, dist).tanh;
	sig = sig * amp * env;
	Out.ar(out,Pan2.ar(sig,pan));
	}, metadata: (
	credit: "by Nicola Ariutti 2020-03-21",
	tags: [\bass, \pads, \lead]
	)
).add;
);


// an instrument which has a distortion inside it which is inspired
// by the work of Martin Brinkmann on one if his PureData pathces.
// Great for basses!!
/*
example

(
Pbindef(\bass,
	\instrument, \brinkmann1,
	\scale, Scale.major,
	\octave, Prand([2,3], inf),
	\root, 5,
	\mtranspose, Pwhite(0.0, 0.03, inf),
	\degree, Prand([
		Prand([-3,0,2,4],32), // F
		Prand([3,5,7,-2],32), // Bb
		Prand([1,4,-1,6],32), // C
		Prand([-1.1, 1, 3, 5.9],32), // Eb
		Prand([-1.1, 1.9, 4,5.9],32), // Ab
		//Prand([-2, 0, 2,5],32), // Dm
	],inf),
	\fb, Pwhite(0.0, 0.9, inf),
	\offset, Pwhite(0.0, 1.1, inf),
	\dist, Pwhite(1.0, 100.0, inf),
	\amp, 0.25,
	\atk, 0.0,
	\rel, 0.2,
	\pan, Pwhite(-1.0, 1.0, inf),
	\dur, 0.5,
	\addAction, 1
).quant_([4]).play;
)
*/

(
SynthDef(\brinkmann1, {
	|
	freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,
	fb=0.0, offset=0.0, dist=1.0
	|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env; // you can change the audio source

	// here the distortion which do its job
	sig = sig * dist.clip(1.0, 100);
	sig = sig / (sig.abs + offset.clip(0.01, 0.9));

	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
);

/*

bpfsaw: an instrument by Eli Fieldsteel as part of his SuperCollider tutorial series
A detuned slow-enveloped saw wave which sounds lush and beautiful, especially with some extended chords
Has a lot of arguments,

atk = attack
sus = sustain
rel = release
ts = timescale of the envelope
c1 = start of envelope curve
c2 = end of envelope curve
freq = frequency
detune = detuning (multiple of frequency), works well with low values, higher ones get quite silly
pan = panning in stereo
cfhzmin = minimum modulation of filter frequency
cfhzmax = maximum modulation of filter frequency
cfmin = minimum filter frequency
cfmax = maximum filter frequency
rqmin = controls filter sweeping. Lower values = greater effects of filtering
rqmax = controls filter sweeping. Lower values = greater effects of filtering
lsf = frequency at which low shelf is activated
ldb = low shelf boost (in dB) - gets really glitchy over around 16 dB, but sounds great so I keep it high
amp = volume
out = channels out

*/

(
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, ts=1, c1=1, c2=(-1), freq=500, detune=0.02, pan=0, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),timeScale:ts,doneAction:2);
	sig = Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env*amp;
	Out.ar(out,sig);
}).add;
);



// shepardTomes

// SHEPARD EFFECT

(
SynthDef(\combi1, {
	|
	amp=0.5,pan=0.0,
	f1=440, f2=6000,lenght=20,out=0
	|
	var sig, env;
	env = EnvGen.ar(Env.triangle(lenght),1, doneAction:2);
	sig = PinkNoise.ar();
	sig = CombC.ar(sig, 0.01, XLine.kr(f1.reciprocal, f2.reciprocal, lenght), 0.2);
	sig = HPF.ar(sig, 500);
	sig = sig * env;

	sig = sig * amp;

	Out.ar(out, Pan2.ar(sig, pan));

}).add;
);


(
~amp_shepards = 0.1;
);

(
Pbindef(\noise_falling,
	\instrument, \combi1,
	\f1, Pwhite(2000, 3000, inf),
	\f2, Pwhite(500, 1000, inf),
	\lenght, Pwhite(10, 20, inf),
	\dur,0.25,
	\amp, 0.05 * Pfunc({~amp_shepards}),
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\group, ~grp_shepards,
	//\addAction, Prand([0],inf)
).quant(0);

Pbindef(\noise_raising,
	\instrument, \combi1,
	\f1, Pwhite(500, 1000, inf),
	\f2, Pwhite(2000, 3000, inf),
	\lenght, Pwhite(3, 5, inf),
	\dur, 0.25,
	\amp, 0.1 * Pfunc({~amp_shepards}),
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\group, ~grp_shepards,
	\addAction, Prand([1],inf)
).quant_(0);
);



// create a grp where to place the shepard synths
// play the pattern
(
Tdef(\activate_shepard, {
	"activate shepards".postln;
	~grp_shepards = Group.new(s);
	Pbindef(\noise_raising,
		\instrument, \combi1,
		\f1, Pwhite(500, 1000, inf),
		\f2, Pwhite(2000, 3000, inf),
		\lenght, Pwhite(3, 5, inf),
		\dur, 0.25,
		\amp, 0.1 * Pfunc({~amp_shepards}),
		\out, 0,
		\pan, Pwhite(-1.0, 1.0, inf),
		\group, ~grp_shepards,
		\addAction, Prand([1],inf)
	).quant_(0).play;
}).quant_(0);
);
// evaluate the code below to instantly kill all the shepards and the container grp
(
Tdef(\deactivate_shepard, {
	"deactivate shepards".postln;
Pbindef(\noise_raising).stop;
~grp_shepards.free;
}).quant_([0]);
);


// temp
//Pbindef(\noise_raising).play;


// use the FREEZER like this
// ~freezer = Synth(\freezer,target: RootNode(Server.default), addAction: \addToTail);
// ~freezer.free;
(
SynthDef(\freezer, {
	|in=0, out=0, freeze=0, bufSize=2048|

	var sig = In.ar( in, 2 );
	var chain;
	chain = FFT( LocalBuf((bufSize).dup(2), 1), sig);
    chain = PV_Freeze(chain, freeze );
	sig = IFFT(chain);
	ReplaceOut.ar(out, sig) ;
}).add;
)


