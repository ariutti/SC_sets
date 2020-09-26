// MY SNIPPETS

// press ctrl-` (backtick)

//generic drum patterns
/*
DDWSnippets.put("kick", "~k = Pbind(\\instrument,\\bplay,\\buf,d[\"k\"][0],\\dur,##1##,\\amp,1);");
DDWSnippets.put("hat","~h = Pbind(\\instrument,\\bplay,\\buf,d[\"ch\"][0],\\dur,##0.25##,\\amp,Pexprand(0.05,1));");
DDWSnippets.put("snare","~sn = Pbind(\\instrument,\\bplay,\\buf,d[\"s\"][0],\\dur,##2##,\\amp,1);");
DDWSnippets.put("clap","~c = Pbind(\\instrument,\\bplay,\\buf,d[\"c\"][0],\\dur,##0.75##,\\amp,1);");
DDWSnippets.put("oh","~oh = Pbind(\\instrument,\\bplay,\\buf,d[\"oh\"][1],\\dur,##Pseq([0.5,Pseq([1],inf)],inf)##,\\amp,1);");
*/

DDWSnippets.put("kick", "Pbindef(\\k,\\instrument,\\bplay,\\buf,d[\"k\"][0],\\dur,##1##,\\amp,0.5,\\rel,0.1,\\rate,0.7,\\addAction,1).quant_(4).play;");

DDWSnippets.put("snare","Pbindef(\\s,\\instrument,\\bplay,\\buf,d[\"s\"][0],\\dur,##2##,\\amp,0.5,\\rel,0.2,\\rate,0.8,\\addAction,1).quant_([4,1]).play;");

DDWSnippets.put("hat","Pbindef(\\hh,\\instrument,\\bplay,\\buf,d[\"ch\"][0],\\dur,##0.25##,\\amp,Pexprand(0.05,1)*0.7).quant_(4).play;");
DDWSnippets.put("clap","Pbindef(\\clap, \\instrument,\\bplay,\\buf,d[\"c\"][0],\\dur,##5##,\\amp,0.5).quant_(4).play;");
DDWSnippets.put("ohh","Pbindef(\\oh, \\instrument,\\bplay,\\buf,d[\"oh\"][1],\\dur,##Pseq([0.5,Pseq([1],inf)],inf)##,\\amp,0.5).quant_(4).play;");
DDWSnippets.put("shout","Pbindef(\\shout, \\instrument,\\bplay,\\buf,d[\"shout\"][1],\\dur,8,\\amp,0.5).quant_(4).play;");

DDWSnippets.put("verb", "~verb = Synth(\\verb, [\\dec,1, \\lpf,1500, \\wet,1.0]);
~verb.set(\\dec,##0.1##, \\lpf,1500, \\wet,1.0);");


DDWSnippets.put("tape_dly", "~dly = Synth(\\tapedly, [\\in, 0, \\dlytime, 0.333, \\fb, 0.5, \\wet, 1.0]);
~dly.set(\\dlytime, 0.25, \\fb, 0.8,\\wet, 1.0,\\fc, 5000);");


// a trick to be used to modulate cutoff frequency for synth which let you do this
// it takes advantage of the Pseg pattern. Please keep in mind to use it in Pbind(ef) where duration is less than the curve duration
DDWSnippets.put("_cutoff_lfo", "\\cutfreq, Pseg([200, 6000, 200], ##8##, \\linear, inf),");

// A template synth for generic use
DDWSnippets.put("_synthTemp", "(
SynthDef(##\\temp##, {
	|freq=400,atk=0.1,rel=0.1,amp=1.0,pan=0.0,fb=0.0|
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2);
	var sig = SinOscFB.ar(freq, fb) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)");

// a template for a generic Pbindef
DDWSnippets.put("_PbindefTemp", "(
Pbindef(\\namemeplease,
	\\instrument, \\myinstrument,
	\\octave, 5,
	\\degree, Pseq([0],inf),
	\\amp, 0.1,
	\\atk, 0.0,
	\\rel, 0.4,
	\\dur,8,
	\\pan, 0.0,
	\\addAction,0
).quant_([4,0]).play;
)
");


DDWSnippets.put("_OrchestraPbindefTemp", "(
Pbindef(\\mysamplerlick,
	\\instrument, \\oneshot_player, //\\hybrid_player
	\\scale, Scale.minor,
	\\root, 0,
	\\octave, 5,
	\\degree, 0,

	\\index,  Pfunc({ |e| e.use { ~midinote.() }.asArray.collect { |note| ~samples[\\##mysamples##][\\midinotes].indexIn(note) } }),
	\\buf, Pindex(~samples[\\mysamples][\\buffers], Pkey(\\index)),
	\\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~samples[\\mysamples][\\midinotes], Pkey(\\index))).midiratio,

	\\amp, 0.1,
	\\dur, 4,
	\\atk, 0.01,
	\\dcy, 0.1,
	\\sus, 1,
	\\rel, 8,
	\\out, 0,
	\\pan, 0.0,
	\\addAction, 1
);)");

DDWSnippets.put("killTheZombie", "(
a = Synth.basicNew(\synthDefName, nodeID:##nodeID##);
a.free;
)"
);


DDWSnippets.put("inout", "~inout = Synth(\\inout, [\\in,2,\\out,0,\\amp,0.5],addAction:0);
~inout.set(\\amp, 0.4);");