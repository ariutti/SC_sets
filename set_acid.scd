"mySetup/mySetup.scd".loadRelative;
p.pop

// notes and duration lick
a = [[0, 0, 0, 0, 2],[1, 1, 1, 0.25, 0.75]]
p.clock.tempo = 60/60;

(
~acidLine = Pbind(
	\instrument, \acid,
	\octave, 3, //Prand([1, 2, 3], inf),
	\scale, Scale.major,
	\degree, 0, //Pseq((0..7), inf),
	//\degree, Pseq( a[0], inf),
	\amp, 1, //Pwhite(0.65, 0.7, inf),
	\dur, Pbjorklund2(4,8,inf)/4,
	//\dur, Pseq( a[1], inf),
	\atk, 0.01, \dcy, 0.1, \sus, 0.3, \rel, 0.3,
	\rq, 0.1, \rf, 16000,
	\fatk, 0.01, \fdcy, 0.2, \fsus, 0.1, \frel, 0.2,
	\legato, 0.6,
);
)

~acidLine.play(fadeTime:3)

~acidline.clear
~acidLine.set(\rf, 0.01)
~acidLine.set(\rq, 10000)
~acidLine.stop(4)
~acidLine.play



~filtmod = {LFTri.kr(1).range(5000, 15000)}
~rfmod   = {Saw.kr(1).exprange(0.1, 0.5)}
~rfmod.stop(4);
~filtmod.stop(4);
~rfmod.clear;
~filtmod.clear;

p.clock.tempo = 60/60;

(
~strings = Pbind(
	\instrument, \test,
	\octave, Pfunc({[8, 9, 7].scramble}),
	\scale, Scale.chromatic,
	\degree, [\C].chordProg.flat,
	\gtranspose, Ptuple([Pwhite(-0.125,0.125),Pwhite(-0.125,0.125),Pwhite(-0.125,0.125)]*1.1,inf),
	\amp, 0.33,
	\dur,Pseq([0.25], inf),
	\legato, 0.9,
	\atk, Pkey(\sustain)*0.125,
	\dcy, Pkey(\sustain)*0.125,
	\sus, 0.1,
	\rel, Pkey(\sustain)*0.05,
	\pos, Ptuple([Pwhite(-0.8,0.8),Pwhite(-0.8,0.8),Pwhite(-0.8,0.8)],inf)
);
)
~strings.play
~strings.stop

(
~verbSend = ~acidLine*0.1+ ~strings*0.0; // + ~sin;
~room = {100};
~time = {2};
~verb = {GVerb.ar(~verbSend, ~room, ~time, mul:0.25)};
~verb.play(fadeTime:0.1);
)
~verb.stop(3);
~acidLine.stop()


(
~strings.stop(4);
~combSend = ~strings;
~comb = {CombC.ar( {~combSend}, 4, p.clock.tempo*0.256, 2.5 )};
~comb.play;
)
~comb.clear;
~combSend.clear;


~acidLine.fadeTime_(0.01);
~acidLine.play(fadeTime:3);
~acidLine.stop(3)
~acidLine.clear


// with drums


d.keys

~k = Pbind(\instrument,\bplaym,\buf,d["k"][7],\dur,1,\amp,2);
~k.play

~sn = Pbind(\instrument,\bplaym,\buf,d["sn"][0],\dur,Pseq([0, Pseq([2],inf)],inf),\amp,1.1);
~sn.play

(
~k = Pbind(\instrument,\bplaym,\buf,d["k"][7],\dur,Pbjorklund2(5,8,inf, Pwhite(1,10).asStream)/4,\amp,2, \rate, Pwhite(0.6, 1.2, inf));
~sn = Pbind(\instrument,\bplaym,\buf,d["sn"][0],\dur,Pseq([1, Pbjorklund2(3,8,inf,Pwhite(1,10).asStream)/4],inf),\amp,1.1, \rate, Pwhite(0.5, 1.2, inf));
~clap = Pbind(\instrument,\bplaym,\buf,d["clap"][0],\dur,Pseq([0.5, Pbjorklund2(3, 8, inf,Pwhite(1,10).asStream)],inf),\amp,0.9);
~ohit = Pbind(\instrument,\bplay,\buf,d["orchestrahit"][0], \dur,Pseq([0.5, Pbjorklund2(3,8,inf,Pwhite(1,10).asStream)/4],inf), \amp,1.5,\rate,Pwrand([0.7, 0.9, 1.5], [1, 2, 5].normalizeSum, inf));
~sn.play;
~k.play;
~clap.play;
~ohit.play;
)

~verbSend = ~clap * 1.1 + ~ohit;
~verb.play;
~strings.play;
~strings.stop;


(
~comb.stop;
~clap.stop;
~acidLine.stop;
~verb.stop;
)


~clap = Pbind(\instrument,\bplaym,\buf,d["clap"][0],\dur,Pseq([0.5, Pseq([4],inf)],inf),\amp,0.9);
~clap.play;


~ohit = Pbind(\instrument,\bplay,\buf,d["orchestrahit"][0], \dur,Pseq([0.5, Pbjorklund2(3,8,inf)/4],inf), \amp,1.5,\rate,Pwrand([0.7, 0.9, 1.5], [1, 2, 5].normalizeSum, inf));
~ohit.play;




~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)*3, \rate, 1);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,0.75,\amp,1);


(
~verbSend = ~clap; //acidLine*0.1+ ~strings*0.0; // + ~sin;
~room = {200};
~time = {6};
~verb = {GVerb.ar( {~verbSend}, ~room, ~time, mul:0.25)};
~verb.play(fadeTime:0.1);
)
~verb.stop
~verb.clear
~verbSend.clear

