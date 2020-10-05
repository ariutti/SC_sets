// increase the server memory ///////////////////////////////////////////////////////////
s.options.memSize = 8192 * 64;//s.options.memSize*64;
// NOTE: don't make the buffer too large because granulars and GUI will suffer
s.options.blockSize = 128; // increase block size (default is 64)

// load stone samples ///////////////////////////////////////////////////////////////////

~samples = nil;
~samples = [];
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/sfx/CC0/stone_on_stone_dragging/_exports/dragged_stone_01.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/sfx/CC0/stone_on_stone_dragging/_exports/dragged_stone_02.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/sfx/CC0/stone_on_stone_dragging/_exports/dragged_stone_03.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/sfx/CC0/stone_on_stone_dragging/_exports/dragged_stone_04.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/produzioni/_audiofiles/21-cracling-audio-181228_1343.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/produzioni/_audiofiles/398271__inspectorj__pencil-writing-close-a.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/produzioni/_audiofiles/bocca-aperta-01.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/produzioni/_audiofiles/forbici_su_nastri_lunghi.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/produzioni/_audiofiles/respiro_01.wav"));
~samples = ~samples.add( Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/audio4video/Lacoonte/mediafiles/respiro_01-glued render 001_mono.wav"));
~samples.size;
//~samples[3] = Buffer.read(s, "/home/nicola/Musica/_dotdotdot/RAFFAELLO/audio4video/Lacoonte/mediafiles/respiro_01-glued render 001_mono.wav")
~samples = ~samples.add( Buffer.readChannel(s, "/home/nicola/Musica/sfx/CC0/male_screams/257691__vmgraw__scream.wav", channels:0));
// test
{PlayBuf.ar(1, ~samples[3], doneAction:2)}.play;
(
// GRAIN PLAYER
// a synth to play buffers in a granular fashion
SynthDef(\texture_generator, {
	|
	out=0, amp=0.7,
	bus=0, winenv,
	buf,
	gDensity = 6,
	gLength  = 1,
	gRate    = 0.0,
	gPan     = 0.0,
	master_rate = 1.0,
	atk=5, dcy=1,rel=5,gate=1,
	fx_pre_bus=0, fxpresend=0.0,
	fx_post_bus=0, fxpostsend=0.0
	//gAmp     = 0.7
	|
	var sig, env;

	var density = gDensity; // number of simultaneous grain
	var trigger = Impulse.kr( density, phase:Rand(0.0, 2pi));
	var pos = TRand.kr(0.1, 0.9, trigger); // norm. pos of the grain indie the audio file
	var length = gLength; // size of the grain in seconds
	var pan  = 0.0 + Latch.ar( LFNoise0.kr(25, mul:gPan  ), trigger ); // position of the grain
	var rate = (1.0 + Latch.ar( LFNoise0.kr(25, mul:gRate ), trigger ) ) * master_rate;
	//var amp  = 0.0 + Latch.ar( LFNoise0.kr(25, mul:gAmp  ), trigger );

	// gloabal envelope
	env = EnvGen.kr(Env.adsr(atk, dcy, 1, rel), gate, doneAction:0);

	// unfortunately GrainBuf doesn't have a per-grain volume control
	// and it is not possible to use mul to obtain the desired effect
	// because mul affect the global GrainBuf output so you will experience
	// glithces when many grains overlaps
	sig = GrainBuf.ar(
		2, //num channels
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: pan,
		envbufnum: winenv,
		//mul: amp
	);

	sig = LeakDC.ar(sig);
	sig = sig * env;

	// NOTE: signal is already panned inside the granular UGen
	// fx send (prefade)
	//Out.ar(fx_pre_bus, sig*fxpresend);

	sig = sig * amp;
	Out.ar(out, sig);

	// fx send (postfade)
	//Out.ar(fx_post_bus, sig*fxpostsend);
}).add;
)

// (optionally) CREATE A CUSTOM ENVELOPE ////////////////////////////////////////////////
// for this particular application is better to use a custom envelope instead of the hann one!
// I'm creatin a sort-of-rectangular envelope here
(
~winenv = Env([0,1,1,0], [0.01,1, 0.01], [0,0,0]);
~winenv = Buffer.sendCollection(s, ~winenv.discretize, 1);
)
~winenv.plot;

// INSTANTIATE THE SYNTH ////////////////////////////////////////////////////////////////

// check point A
(
~gDensity = 3.83;
~gLength  = 0.48;
~gRate    = 0.15;
~gPan     = 1.0;
~amp      = 1.0;
~masterRate = 1.0;
~preAmt  = 0.0;
~postAmt = 0.0
)

// check point B
(
~gDensity = 3.83;
~gLength  = 0.48;
~gRate    = 0.15;
~gPan     = 1.0;
~amp      = 0.0;
~masterRate = 0.13;
~preAmt  = 0.44;
~postAmt = 0.0
)
s.meter
(
~synth_grain = Synth(\texture_generator, [
	\out, ~room1_bus,
	\buf, ~samples[0],
	\gDensity, ~gDensity,
	\gLength, ~gLength,
	\gRate, ~gRate,
	\gPan, ~gPan,
	\amp, 1.0,
	\master_rate, 1.0,
	\winenv, -1, //~winenv
],
target: ~room1_grp,
addAction: 0
);
)
~synth_grain.free;
~synth_grain.set(\gate, 0);
~synth_grain.set(\gate, 1);

(
~routine_morphing = Routine{
	var bufnum;
	inf.do{
		bufnum = ~samples.choose();
		//bufnum.postln;
		~synth_grain.set(\buf, bufnum);
		1.wait;
	};
};
);

~routine_morphing.reset.play;
~routine_morphing.stop;



// CONTROL IT VIA MIDI //////////////////////////////////////////////////////////////////
// and eventually print some value if we want to save it for future uses

MIDIIn.connectAll;
// My midi controller has 9 faders with this CC numbers: 74, 71, 91, 93, 73, 72, 5, 84, 7
(
~print_func={
	postf("[gDen: %,  gLen: %, gRate: %, gPan: %, amp: % mRate: % pre: % post: %]\n",
		~gDensity.round(1e-2),
		~gLength.round(1e-2),
		~gRate.round(1e-2),
		~gPan.round(1e-2),
		~amp.round(1e-2),
		~masterRate.round(1e-2),
		~preAmt.round(1e-2),
		~postAmt.round(1e-2),
	);
};

~ctrl_gDensity = MIDIFunc.cc({
	arg ...args;
	~gDensity = args[0].linexp(0, 127, 1.0, 100);
	//("gDensity = "++ ~gDensity).postln;
	~print_func.value();
	~synth_grain.set(\gDensity, ~gDensity);
}, 0);

~ctrl_gLength = MIDIFunc.cc({
	arg ...args;
	~gLength = args[0].linlin(0, 127, 0.01, 2.0);
	//("gLength = "++ ~gLength).postln;
	~print_func.value();
	~synth_grain.set(\gLength, ~gLength);
}, 1);

~ctrl_gRate = MIDIFunc.cc({
	arg ...args;
	~gRate = args[0].linlin(0, 127, 0.00, 0.99);
	//("gRate = "++ ~gRate).postln;
	~print_func.value();
	~synth_grain.set(\gRate, ~gRate);
}, 2);

~ctrl_gPan = MIDIFunc.cc({
	arg ...args;
	~gPan = args[0].linlin(0, 127, 0.00, 1.0);
	//("gPan = "++ ~gPan).postln;
	~print_func.value();
	~synth_grain.set(\gPan, ~gPan );
}, 3);

~ctrl_amp = MIDIFunc.cc({
	arg ...args;
	~amp = args[0].linlin(0, 127, 0.0, 1.0);
	~print_func.value();
	~synth_grain.set(\amp, ~amp);
}, 4);


~ctrl_masterRate = MIDIFunc.cc({
	arg ...args;
	~masterRate = args[0].linlin(0, 127, 0.0001, 2.0);
	~print_func.value();
	~synth_grain.set(\master_rate, ~masterRate);
}, 5);

~ctrl_preAmt = MIDIFunc.cc({
	arg ...args;
	~preAmt = args[0].linlin(0, 127, 0.0, 2.0);
	~print_func.value();
	~synth_grain.set(\fxpresend, ~preAmt);
}, 16);

~ctrl_postAmt = MIDIFunc.cc({
	arg ...args;
	~postAmt = args[0].linlin(0, 127, 0.0, 2.0);
	~print_func.value();
	~synth_grain.set(\fxpostsend, ~postAmt);
}, 17);

// I'm also using some pads to change the buffer
~ctrl_buffer = MIDIFunc.cc({
	arg ...args;
	//args.postln;
	switch( args[1],
		43, {
			"sample 0 selected".postln;
			~synth_grain.set(\buf, ~samples[0]);
		},
		44, {
			"sample 1 selected".postln;
			~synth_grain.set(\buf, ~samples[3]);
		},
		42, {
			"sample 2 selected".postln;
			~synth_grain.set(\buf, ~samples[2]);
		},
		41, {
			"sample 3 selected".postln;
			~synth_grain.set(\buf, ~samples[3]);
		},
		45, {
			"sample 4 selected".postln;
			~synth_grain.set(\buf, ~samples[5]);
		}
	);
});
//~ctrl_buffer.free;

/*
~ctrl_gAmp = MIDIFunc.cc({
	arg ...args;
	var gAmp = args[0].linexp(0, 127, 0.0001, 1.0);
	("gAmp = "++ gAmp).postln;
	~synth_grain_whisperings.do({
		|item|
		item.set(\gAmp, gAmp);
	});
}, 73);
*/
)

s.meter;

(
~ctrl_gDensity.free;
~ctrl_gLength.free;
~ctrl_gRate.free;
~ctrl_gPan.free;
~ctrl_amp.free;
~ctrl_masterRate.free;
~ctrl_preAmt.free;
~ctrl_postAmt.free;
~ctrl_buffer.free;
)


a = MIDIFunc.cc({arg ...args; args.postln}); // match any cc
a.free; // cleanup