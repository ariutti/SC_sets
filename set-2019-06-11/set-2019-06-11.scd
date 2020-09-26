// SET 11/06/2019

m = MandelHub.start("leader");

"mySetup/mySetup.scd".loadRelative;

// 2. execute the following line on all other laptops
MandelHub.join("nicola", action: {m = MandelHub.instance});

// 3. if you want you can evaluate some of the following lines of code
m.gui // to make a GUI
m.changeTempo(90/60) // to change the Mandelhub BPM (and all of the clients BPMs)
m.chat("Hi, I'm chatting!"); // chat with other peers


~root = {0};

(
~bass = Pbind(
	\instrument, \wtplay,
	\root, Pkr(~root),
	\octave, 4, //Pseq([3,5,4,6], inf),
	\degree, Pseq([0, 4, 8].pyramid(2), inf), //Pseq([1,2,3,5,6,8], inf)-1,
	\atk, 0.01,
	\rls, 0.3, //Pexprand(0.1, 3, inf),
	\wt, b,
	\out, 0,
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, 0.25,
	\dur, 0.25 //Pbjorklund2(Pwhite(3,9).asStream.round(1),16,inf, Pwhite(0,15).asStream.round(1))/16
);
)

~bass.quant_(1);
~bass.play

(
~pads[0] = Pbind(
	\instrument, \wtplay,
	\root, Pkr(~root),
	\octave, 4, //Pseq([3,5,4,6], inf),
	\degree, Pseq([[1,3,5,8], [1,4,6,8]], inf)-1, //Pseq([[1,3,5,8], [1,4,6,8], [-1, 2,5,7]], inf)-1
	\atk, 1,
	\rls, 16, //Pexprand(0.1, 3, inf),
	\wt, b,
	\pan, 0.0,
	\amp, 0.07,
	\dur, Pseq([16], inf)
);
~pads[1] = \filter -> {|in| GVerb.ar(in, 100, 3, 0.5)};
~pads.quant_(16);
~pads.play;
)
~pads.set(\atk, 1)
~pads.map(\det, 0.015);


~bass.quant_(1);
~bass.play


//freq=440, mRatio=1, mIdx=400, atk=0.01, rel=0.1
(
~fmbass = Pbind(
	\instrument, \fm_bass1,
	\root, Pkr(~root),
	\octave, Pseq([3,5,4,6], inf),
	\degree, Pseq([0, 0], inf), //Pseq([1,2,3,5,6,8], inf)-1,
	\mRatio, 0.125,
	\mIdx, 200,
	\atk, 0.01,
	\rel, 2,
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, 0.25,
	\dur, Pseq([2,1], inf)//Pbjorklund2(Pwhite(3,9).asStream.round(1),16,inf, Pwhite(0,15).asStream.round(1))/16
);
)

~fmbass.quant_(1);
~fmbass.play;

(
~k = Pbind(\instrument, \bplay, \buf, d["k"][0], \amp, 0.3, \dur, 8, \rate, 0.6);
~k.quant_(4);
~k.play;
)
~k.stop;

(
~sn[0] = Pbind(\instrument, \bplay, \buf, d["s"][0], \amp, 0.125, \dur, 13, \rate, 0.2);
~sn[1] = \filter -> {|in| GVerb.ar(in, 100, 3, 0.6)};
~sn.quant_(2);
~sn.play;
)


//freq=440, mRatio=1, mIdx=400, atk=0.01, rel=0.1
(
~chip[0] = Pbind(
	\instrument, \fm_bass1,
	\root, Pkr(~root),
	\octave, 7,
	\degree, Pseq([1,2,3,5,6,8], inf)-1,
	\mRatio, 0.125,
	\mIdx, 1000,
	\atk, 0.01,
	\rel, 0.1,
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, Pseries(0.125, -0.01, inf),
	\dur, Pseq([0.125], 12)//Pbjorklund2(Pwhite(3,9).asStream.round(1),16,inf, Pwhite(0,15).asStream.round(1))/16
);
~chip[1] = \filter -> {|in| CombL.ar(in, 0.4, 0.125, 4)};
)

~chip.quant_(1)
~chip.play;


~k.stop(12)
~sn.stop(12);
~fmbass.stop(12);
(
~pads.stop(8);
~bass.stop;
)


 