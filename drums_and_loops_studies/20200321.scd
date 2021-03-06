TempoClock.default.tempo_(90/60);


// time to add some rythm

(
Pbindef(\loop,
	\instrument, \sliceplayer,
	\loopbuf, d["loops"][2],
	\loopbars, 4,
	\loopbpm, 175 * 0.5,
	\currentBpm, Pfunc({TempoClock.default.tempo}),
	\atk, 0.0,
	\rel, 0.1,
	\amp, 0.4,
	\start, 0.0,
	\dur, 4,
	\addAction, 1
).quant_(4);
)

Pbindef(\loop,\amp, 0.4)
Pbindef(\loop).play;
Pbindef(\loop).stop;
Pbindef(\lool).clear;

Pbindef(\loop, \loopbuf, d["loops"][2], \loopbars, 4,\loopbpm, 175 * 0.5); //dnb
Pbindef(\loop, \loopbuf, d["loops"][0], \loopbars, 1, \loopbpm, 136);


Pbindef(\loop, \sr, 4000, \bits, 5, \amp, 0.5); // decimator setup
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 0.3); // decimator setup

Pbindef(\loop, \hf,3000, \lf,300); // add filter
(
Pbindef(\loop, \hf,20000,\lf,0);  // remove filter
Pbindef(\loop, \pan, 0.0); // reset pan
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 0.3); // decimator setup
Pbindef(\loop, \start,0.0, \dur, 4, \amp, 0.3);Pbindef(\amen, \hf,20000, \lf,0);  // remove filter
)
Pbindef(\loop, \start,0.0, \dur, 0.25, \amp, 0.3); // kick
Pbindef(\loop, \start,0.25 * 0.125, \dur, 0.25, \amp, 0.3); // snare
Pbindef(\loop, \start,Pseq([0.0, 0.0, 0.25*0.125],inf), \dur, 0.25); // k + sn
Pbindef(\loop, \start, 0.75, \dur, 0.125*0.25, \amp, 0.25); // errrrrr
Pbindef(\loop, \start, Pwhite(0.0, 0.75).round(0.25), \dur, 0.25*0.5);
Pbindef(\loop, \start, Prand([0, 0.125, 0.25, 0.5, 0.625, 0.75] * 0.25,inf), \dur, Prand([0.25, 0.5], inf))




Pbindef.gui;

(
Pbindef(\A).stop;
Pbindef(\B).stop;
Pbindef(\chirp).stop;
Pbindef(\hi).stop;
Pbindef(\hh).stop;
Pbindef(\lo).stop;
)


[Pbindef(\A), Pbindef(\B), Pbindef(\chirp), Pbindef(\hi),Pbindef(\lo),Pbindef(\hh)].do({|item| item.play;});


Pbindef(\loop).play;
Pbindef(\loop).stop;
Pbindef(\lool).clear;


// STOP
(
Pbindef(\bells).stop;
Pbindef(\loop , \start,Prand([0, 0.125, 0.25, 0.5, 0.625, 0.75] * 0.25,inf), \dur, Prand([0.25, 0.5], inf));
//Pbindef(\loop, \start, Pwhite(0.0, 0.75).round(0.25), \dur, 0.25*0.5);
Pbindef(\bass).stop;
)


// GO!!!!
(
Pbindef(\loop).play;
Pbindef(\loop, \hf,20000,\lf,0);  // remove filter
Pbindef(\loop, \pan, 0.0); // reset pan
Pbindef(\loop, \sr, 44100, \bits, 16, \amp, 0.3); // decimator setup
Pbindef(\loop, \start,0.0, \dur, 4, \amp, 0.3);Pbindef(\amen, \hf,20000, \lf,0);  // remove
Pbindef(\bass).quant_(4).stop.play;
Pbindef(\bells).quant_(4).stop.play;
Pbindef(\sn).play;
)

s.plotTree


// bells with ringsaw
(
Pbindef(\loop).stop;
Pbindef(\bells,
	\instrument, \fm2,
	\amp, Pseries(1, 1, inf).fold(1,9) / 30 * 0.0,
	\atk, 0.01,
	\rel, 0.25, //Pwhite(1, 8, inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf).clump(3),
	\scale, Scale.minor,
	\octave, Pwrand([5,6], [5,0.2].normalizeSum, inf),
	\degree, 0 + [0,2,4], //Pseq([0,Prand([2,4,7],3)],inf).collect({|note| [note, note+[3,4].choose() ]}),
	\dur, Pwrand([0.25], [10].normalizeSum,inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\mr, 10, //Pseries(1, 1, inf).wrap(1, 8), //Prand([0.5, 1,2],inf),
	\mi, 100,
	\width, 0.01, //Pwhite(0.1, 0.5, inf),
	\addAction, 0
).quant_(1);
)
(
Pbindef(\speakSpell, \addAction, 1).stop
)

(
Pbindef(\k,\dur, Pbjorklund2(3,4,inf)/4).stop;
Pbindef(\s).stop;
)
(
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,2,\addAction,1,\rel, 0.1).quant_(4).play;
Pbindef(\s,\instrument,\bplay,\buf,d["s"][3],\dur,Pseq([1, Pseq([2], inf)], inf),\amp,0.4,\addAction,1,\rate,0.8,\rel,0.15).quant_(4).play;
)
Pbindef(\bells).play;
Pbindef(\bells).stop;


~verb.set(\dec,0.6, \lpf,1500, \wet,1.0);





// try with fm2
(
Pbindef(\bells,
	\instrument, \fm2,
	\amp, Pseries(1, 1, inf).fold(1,9) / 30 * 0.5,
	\atk, 0.0,
	\rel, Pwhite(0.01, 0.5, inf),
	\mtranspose, Pwhite(-0.01, 0.01, inf),
	\scale, Scale.minor,
	\octave, Prand([5,6], inf),
	\degree, 0, //Pseq([0,Prand([2,4,7],3)],inf).collect({|note| [note, note+[3,4].choose() ]}),
	\dur, Pwrand([0.25, Pn(0.125, 2)],[10,1].normalizeSum, inf),
	\pan, Pwhite(-1.0, 1.0, inf),
	\mr, Pseries(1, 1, inf).wrap(1, 8), //Prand([0.5, 1,2],inf),
	\mi, 1000,
	\addAction, 0
).quant_(4)
)

(
SynthDef(\ringsaw1,{
	|
	freq=45, pan=0, amp=1, out=0,
	atk=0.001, rel=0.1, dist=1.0, width=0.5
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	//env = Line.kr(0,1,rel);
	//env = FreeSelfWhenDone.kr(env);
	sig = VarSaw.ar(freq, width:width, mul:dist).tanh;
	sig = sig * amp * env;
	Out.ar(out,Pan2.ar(sig.tanh,pan));
	};
).add;
);


(
Pbindef(\bells).stop;
Pbindef(\loop).stop;
Pbindef(\k).stop;
Pbindef(\sn).stop;
)

(
Pbindef(\bells).play;
Pbindef(\loop).play;
)

s.meter



// bass:
(
TempoClock.default.tempo_(120/60);
Pbindef(\bass,
	\instrument, \ringsaw1,
	\dist, Pseries(1, 1).fold(1, 5),
	\amp, [0.7, 0.5, 0.2] * 0.3,
	\mtranspose, Pwhite(0.02, -0.02, inf).clump(3),
	\atk, 0.01,
	\rel, 0.3,
	\scale, Scale.minor,
	\octave, [3,4,5],
	\degree, 0 + Pwrand([0, Pn(7,2)], [15,1].normalizeSum,inf),
    \dur, 1,
	\pan, 0, //Pwhite(-1.0, 1.0, inf).clump(3),
	\width, 0.02,
	\addAction, 0
).quant_(4);
)
Pbindef(\bass).play;
Pbindef(\bass).stop;
Pbindef(\bass, \degree, -0+Pwrand([0, Pn(7,2)], [15,1].normalizeSum,inf)); //-4 , -3
Pbindef(\bass,\addAction, Pwrand([1,0],[10,1].normalizeSum, inf)).play;


~verb = Synth(\verb, [\dec,1, \lpf,1500, \wet,1.0]);~verb.set(\dec,0.1, \lpf,1500, \wet,1.0);
~verb.set(\wet, 1.0);




Pbindef(\speakSpell,\instrument,\bplaym,\buf,Pindex(d["speakspell_letters"], Prand((0..d["speakspell_letters"].size),inf), inf),\dur,4,\amp,0.5,\addAction,0,\pan, Pwhite(-1.0, 1.0, inf)).quant_(4);
Pbindef(\speakSpell).stop;
Pbindef(\speakSpell).play;

// time for a sigarette ahahaha


Pbindef(\loop).play;
Pbindef(\k,\instrument,\bplay,\buf,d["k"][0],\dur,0.5,\amp,0.7,\rel,0.5,\rate,0.8,\addAction,1).quant_(4).play;
Pbindef(\k).stop;

Pbindef(\sn,\instrument,\bplay,\buf,d["s"][0],\dur,(Pn(0.5,1) ++ Pseq([1],inf))*0.7,\amp,Pn(\rest,1)++Pseq([0.4 * 1],inf),\addAction,1,\rel,0.1,\rate, 0.6).quant_(4).stop.play;

(
Pbindef(\loop).stop;
Pbindef(\bass,\rel, 1);
Pbindef(\k).quant_(4).stop;
Pbindef(\sn).quant_(4).stop;
)

(
Pbindef(\k,\amp,1);
Pbindef(\sn,\amp,1);
)

Pbindef(\hh,\instrument,\bplay,\buf,d["ch"][0],\dur,Pseq([Pn(0.125, 4),3],inf),\amp,Pexprand(0.05,1)*2,\rel,0.1,\rate, 3,\addAction,Prand([0,1],inf)).quant_(4).play;

(
Pbindef(\loop).play;
Pbindef(\bass,\rel, 0.25,\amp,[0.7, 0.5, 0.2] * 0.5);
Pbindef(\k,\dur, 0.5).quant_(4).play;
Pbindef(\sn).quant_(4).play;
)


(
SynthDef(\ring1,{
	|
	freq=45, pan=0, amp=1, out=0,
	atk=0.001, rel=0.1, dist=1.0
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	sig = Ringz.ar( Impulse.ar(0) ,freq,rel, dist).tanh;
	sig = sig * amp * env;
	Out.ar(out,Pan2.ar(sig,pan));
	}, metadata: (
	credit: "by Nicola Ariutti 2020-03-21",
	tags: [\bass, \pads, \lead]
	)
).add;
);


// speak and spell
(
~word = "iloveyou";
~alphabet = "abcdefghijklmnopqrstuvwxyz".asList;
~word = ~word.toLower.asList.collect({|letter| ~alphabet.indexOf( letter )});

Pbindef(\speakSpell,\instrument,\bplaym,\buf,Pindex(d["speakspell_letters"], Pseq(~word, inf), inf),\dur,4,\amp,0.3,\addAction,0,\pan, Pwhite(-1.0, 1.0, inf),\rate,1).quant_(4);
)

"espeak -v en \"I love you\"".unixCmd;