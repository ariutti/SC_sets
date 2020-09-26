//Boilerplate code for basic live coding functionality
(
//increase number of buffers the server has access to for loading samples
s.options.numBuffers = 1024 * 16;
//increase the memory available to the server
s.options.memSize = 8192 * 64;

s.waitForBoot({

//boot the server
//s.boot;
//start proxyspace
//p=ProxySpace.push(s);
//p.makeTempoClock;
//p.clock = TempoClock.default;


// if you want to use some MIDI functionality
//MIDIClient.init;
//MIDIIn.connectAll;

/*
//start tempo clock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 120/60;
*/

Task({
	d = Dictionary.new;
	d.add(\foldernames -> PathName(thisProcess.nowExecutingPath.dirname +/+ "../mySamples").entries);
	for (0, d[\foldernames].size-1,
		{arg i; d.add(d[\foldernames][i].folderName -> d[\foldernames][i].entries.collect({
			arg sf;
			sf.postln;
			Buffer.read(s,sf.fullPath);
		});
	)});

	"loading synthdefs".postln;
	("mySynthDefs.scd").loadRelative;
	// load snippets
	"loading snippets".postln;
	("mySnippets.scd").loadRelative;

	//wait, because otherwise it won't work for some reason
	3.wait;
	//activate StageLimiter - Part of the BatLib quark
	StageLimiter.activate;

	"Setup done!".postln;
}).start;
});
);

//display the oscilloscope
s.scope;
//display the meter
s.meter;
// display the freqscope
s.freqscope;
s.plotTree;

m = nil
// 1. evaluate this
m = MandelHub.start("MasterCommander");
// or thie
MandelHub.join("nicola", action: {m = MandelHub.instance});

m.takeLead;
m.clear;
// 2. if you want you can evaluate some of the following lines of code
m.gui; // to make a GUI
// eventually this to change tempo
m.changeTempo(120/60) // to change the Mandelhub BPM (and all of the clients BPMs)
m.chat("Hi, I'm chatting!"); // chat with other peers
m.shout("hi")

p = ProxySpace.push(s);
//p.makeTempoClock;
//p.clock = TempoClock.default;

s.latency_(0.150);
