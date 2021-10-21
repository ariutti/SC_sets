//Boilerplate code for basic live coding functionality

	// 1. uninstall ddwSnippet quark --> re-compile class library
	// 2. instal ddwSnippets quark --> re-compile class library
	// 3. evaluate the code

(
//increase number of buffers the server has access to for loading samples
s.options.numBuffers = 1024 * 32;
//increase the memory available to the server
s.options.memSize = 8192 * 128;

//display the tree
//s.plotTree;
s.waitForBoot({
	Task({
		var initTime = 0;
		var currentTime = 0;
		// load "my samples"
		"WARNING: loading \"mySamples\" samples (it will take some time ~ 10secs approx)".postln;
		initTime = Date.localtime.rawSeconds;
		d = nil;
		d = Dictionary.new;
		d.add(\foldernames -> PathName(thisProcess.nowExecutingPath.dirname +/+ "../mySamples").entries);
		for (0, d[\foldernames].size-1,
			{arg i; d.add(d[\foldernames][i].folderName -> d[\foldernames][i].entries.collect({
				arg sf;
				//Buffer.read(s,sf.fullPath);
				if( sf.isFile && sf.extension.toLower == "wav", {
					("loading buffer: (folder "++d[\foldernames][i].folderName++"): " ++ sf.fileName).postln;
					//s.sync;
					Buffer.read(s, sf.fullPath);
				});
			});
		)});
		currentTime = Date.localtime.rawSeconds;
		("elapsed: " ++ (currentTime-initTime)).postln;


		// load "dirt" samples
		"WARNING: loading \"dirt\" samples  (it will take a looong time ~ 90secs approx)".postln;
		initTime = Date.localtime.rawSeconds;
		~dirt = nil;
		~dirt = Dictionary.new;
		~dirt.add(\foldernames -> PathName("/home/nicola/Musica/samples/Dirt-Samples").entries);
		for (0, ~dirt[\foldernames].size-1,
			{
			|i|
			~dirt.add(~dirt[\foldernames][i].folderName -> ~dirt[\foldernames][i].entries.collect({
				arg sf;
				//postln( sf.extension );

				if( sf.isFile && sf.extension.toLower == "wav", {
					("loading buffer (folder "++~dirt[\foldernames][i].folderName++"): " ++ sf.fileName).postln;
					//s.sync;
					Buffer.read(s,sf.fullPath);
				});
			});
		)});
		currentTime = Date.localtime.rawSeconds;
		("elapsed: " ++ (currentTime-initTime)).postln;


		"WARNING: loading \"sonatina\" samples".postln;
		// load samples from sonatina
		// for ~rootpah, see "MasterOfMasters.scd"
		~path = PathName(thisProcess.nowExecutingPath.dirname +/+ "../mySamples2");

		//~loadfunc;
		if (~samples.notNil) {
			~samples.do({
				|key|
				if (~samples[key].notNil) {
					~samples[key][\buffers].do({
						| buffer |
						if (buffer.notNil) {
							buffer.free;
						};
					});
				};
			});
		};
		~samples = ();

		// add function to load samples
		~loadfunc = {
			// loaded samples will be stored under samples[key]
			|
			key, relpath, namefilter, destination,
			basepath="/home/nicola/Musica/SC_set/mySamples2"
			|
			var path = PathName(basepath +/+ relpath);
			var tmp_buffers = path.entries.removeAllSuchThat({|item| item.fileName.contains(namefilter); });
			var tmp_array = tmp_buffers.collect({
				| item, index |
				var d = ();
				var string = item.fileNameWithoutExtension;
				var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
				var noteNameAll = output[0][1];
				var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
				var noteName = noteNameAll[0].asString;
				var isSharp = noteNameAll.contains("#"); // boolean
				var midiNumber = (octNumber +1) * 12;
				switch( noteName.toLower,
					"c", { midiNumber = midiNumber+0; },
					"d", { midiNumber = midiNumber+2; },
					"e", { midiNumber = midiNumber+4; },
					"f", { midiNumber = midiNumber+5; },
					"g", { midiNumber = midiNumber+7; },
					"a", { midiNumber = midiNumber+9; },
					"b", { midiNumber = midiNumber+11; },
				);
				if (isSharp) {midiNumber = midiNumber + 1;};
				//[noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;//.debug("[fullname, note, sharp, octave, midinum]");
				d[\midi] = midiNumber.asInteger;
				d[\note] = noteNameAll;
				// uncomment the line below if you want to see a more verbose debug
				//d[\buffer] = Buffer.readChannel(s, item.fullPath.debug("reading file"), channels:0);

				d[\buffer] = Buffer.readChannel(s, item.fullPath, channels:0);
				//d;
			});
			key.debug("loading");
			tmp_array.sortBy(\midi);
			destination[key] = ();
			destination[key][\buffers] = tmp_array.collect({|item| item[\buffer]; });
			destination[key][\midinotes] = tmp_array.collect({|item| item[\midi]; });
			destination;
			// TODO: add here a check evaluation function in order to check if the samples array
			// has been succesfully filled or not
			//if( destination[key][\buffers].isEmpty,
			//{"ERROR".postln;}, {}
			//);
		};
		// load all the need secondary samples
		//~samples = ~loadfunc.(\piano,  "pianoteq", "pianoteq-p-", ~samples);
		s.sync; // pianoteq samples
	}).start;
	//~samples = ~loadfunc.(\violins_1st_sus, "1st Violins", "1st-violins-sus-", ~samples); s.sync;

	//100.wait;
	4.wait;


	"loading synthdefs".postln;
	("mySynthDefs.scd").loadRelative;

	1.wait;

	// load snippets
	//"loading snippets".postln;
	//("mySnippets.scd").loadRelative;
	// shortcut CTRL + ALT + ?


	//wait, because otherwise it won't work for some reason
	3.wait;
	//activate StageLimiter - Part of the BatLib quark
	StageLimiter.activate;

	3.wait;

	//display the oscilloscope
	s.scope;
	//display the meter
	s.meter;
	// display the freqscope
	//s.freqscope;
	//display tree
	//s.plotTree;

	// MIDI IN ///////////////////////////////////////////////
	MIDIClient.init;
	s.sync;
	5.wait;
	MIDIIn.connectAll;
	s.sync;
	5.wait;

	s.volume_(0);


	"\nWARNING: Setup done!".postln;
	"\nWARNING: remember to connect SC to OBS".postln;
});
)


