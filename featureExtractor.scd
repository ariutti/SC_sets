// FEATURE + ONSETs

s.plotTree;
s.meter;

(
s.waitForBoot({
	/*
	var path, audiofile,
	filename_1, csv_feat,
	filename_2, csv_onset,
	filename_3, csv_pitch;

	s.meter;
	*/

	// this is the address of the OSC application
	//~data_analyzer = NetAddr("192.168.1.68", 15100);
	~data_analyzer = NetAddr("127.0.0.1", 15100);

	~bool_recordCSV = False;
	~bool_sendOSC   = True;

	~fftWidth = 2048;

	s.sync;


	// Synth Definitions ///////////////////////////////////////////////////////////////////////

	SynthDef(\features_onset, {
		| in=0, rate=10, onsetTh=0.2, pitchExecfreq=10 |
		var sig, fft, amplitude;
		var loud, flat, centroid;
		var freq, hasFreq, chroma;
		var ph, onset;

		// comment out the following line if you want to use an audiofile
		// instead of the live input.
		sig = Mix.ar(SoundIn.ar(in));
		//sig = Mix.ar(In.ar(in, 2));

		amplitude = Amplitude.kr(sig);
		fft = FFT(LocalBuf(~fftWidth), sig);
		loud = Loudness.kr(fft);
		# freq, hasFreq = Pitch.kr(sig, execFreq:pitchExecfreq);
		flat = SpecFlatness.kr(fft);
		chroma = Chromagram.kr(fft, ~fftWidth, /*tuningbase:55.0,*/ integrationflag:0, perframenormalize:1);
		centroid = SpecCentroid.kr(fft);


		onset = Onsets.kr(fft, threshold:onsetTh, odftype:'magsum');
		//SendTrig.kr(onset, id:1, value:ph);
		SendTrig.kr(onset, id:0);


		SendReply.kr(Impulse.kr(rate),'/tr',
			[
				loud, flat, centroid
			],
		replyID:1);


		// TODO: find a better way to refer to chroma elements below.
		// TODO: Impulse freq is the same as 'execFreq' in Pitch.
		SendReply.kr(Impulse.kr(pitchExecfreq),'/tr',
			[
				hasFreq, freq,
				chroma[0], chroma[1], chroma[2],  chroma[3],
				chroma[4], chroma[5], chroma[6],  chroma[7],
				chroma[8], chroma[9], chroma[10], chroma[11],
			],
		replyID:2);

		Out.ar(0, sig!2);
	}).add;


	s.sync;


	// OSC functions ///////////////////////////////////////////////////////////////////////////


	o = OSCFunc({
		|msg, time, addr, recvPort|
		var data, elapsed;

		switch( msg[2],
			0, {
				// ONSET ID
				//"onset detected".postln;
				// send messages via OSC to Processing
				if( ~bool_sendOSC == True , {
					~data_analyzer.sendMsg("/debug/onset", 1);
					~data_analyzer.sendMsg("/debug/onset", 0);
				});
			},
			1, {
				// LOUDNESS, FLATNESS, CENTROID
				data = msg[3..];
				//data.round(0.01).postln;

				// send data via OSC to Processing
				if( ~bool_sendOSC == True , {
					~data_analyzer.sendMsg("/debug/loud", data[0]);
					~data_analyzer.sendMsg("/debug/flat", data[1]);
					~data_analyzer.sendMsg("/debug/centroid", data[2]);
				});
			},
			2, {
				// PITCH FEATURES ID
				data = msg[3..];

				// send data via OSC to Processing
				if( ~bool_sendOSC == True , {
					~sendDataViaOsc.value(data);
				});
			},
			{
				"default".postln;
			}
		);

	},'/tr', s.addr);


	s.sync;


	// some Utility functions //////////////////////////////////////////////////////////////////
	// function (ugly) to send data to Processing
	// TODO: make this function looks better
	~sendDataViaOsc = {
		|data|

		//data[0].postln;
		~data_analyzer.sendMsg("/debug/hasFreq", data[0]);
		~data_analyzer.sendMsg("/debug/freq", data[1]);

		// chroma data
		~data_analyzer.sendMsg("/debug/C",  data[2] );
		~data_analyzer.sendMsg("/debug/C#", data[3] );
		~data_analyzer.sendMsg("/debug/D",  data[4] );
		~data_analyzer.sendMsg("/debug/D#", data[5] );
		~data_analyzer.sendMsg("/debug/E",  data[6] );
		~data_analyzer.sendMsg("/debug/F",  data[7] );
		~data_analyzer.sendMsg("/debug/F#", data[8] );
		~data_analyzer.sendMsg("/debug/G",  data[9] );
		~data_analyzer.sendMsg("/debug/G#", data[10]);
		~data_analyzer.sendMsg("/debug/A",  data[11]);
		~data_analyzer.sendMsg("/debug/A#", data[12]);
		~data_analyzer.sendMsg("/debug/B",  data[13]);

		//if(data[0]==1){data[2..].round(0.01).postln};
	};

	s.sync;

	// Instantiate Synths //////////////////////////////////////////////////////////////////////

	// begin the process!
	~feature_onset = Synth(\features_onset, [\in, 0, \rate, ~rate]);
});
)

~feature_onset.set(\onsetTh, 0.1);
~feature_onset.set(\pitchExecfreq, 10);
~feature_onset.set(\rate, 10);


(
s.freeAll;
o.free;
if( ~bool_recordCSV == True, {
	~csv_feat.close();
	~csv_onset.close();
	~csv_pitch.close();
});
s.quit;
)

// TEST STUFF /////////////////////////////////////////////////////
/*
{PlayBuf.ar(1,c, BufRateScale.ir(c),doneAction:2)}.play;
OSCdef(\listener).free;
*/
