MIDIClient.init;
MIDIIn.connectAll;

(
~nk2_fader1.free;
~nk2_fader1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 0);

~nk2_fader2.free;
~nk2_fader2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 1);

~nk2_fader3.free;
~nk2_fader3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 2);

~nk2_fader4.free;
~nk2_fader4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 3);


~nk2_fader5.free;
~nk2_fader5 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 4);

~nk2_fader6.free;
~nk2_fader6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 5);

~nk2_fader7.free;
~nk2_fader7 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 6);

~nk2_fader8.free;
~nk2_fader8 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 7);

// KNOBS (PANS)

~nk2_pan1.free;
~nk2_pan1 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 16);

~nk2_pan2.free;
~nk2_pan2 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 17);

~nk2_pan3.free;
~nk2_pan3 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 18);

~nk2_pan4.free;
~nk2_pan4 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 19);

~nk2_pan5.free;
~nk2_pan5 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 20);

~nk2_pan6.free;
~nk2_pan6 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 21);

~nk2_pan7.free;
~nk2_pan7 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 22);

~nk2_pan8.free;
~nk2_pan8 = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 23);


// SOLO BUTTONS
~nk2_track1_solo_button.free;
~nk2_track1_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 32);

~nk2_track2_solo_button.free;
~nk2_track2_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 33);

~nk2_track3_solo_button.free;
~nk2_track3_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 34);


~nk2_track4_solo_button.free;
~nk2_track4_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 35);

~nk2_track5_solo_button.free;
~nk2_track5_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 36);

~nk2_track6_solo_button.free;
~nk2_track6_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 37);

~nk2_track7_solo_button.free;
~nk2_track7_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 38);

~nk2_track8_solo_button.free;
~nk2_track8_solo_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 39);


// MUTE BUTTONS
~nk2_track1_mute_button.free;
~nk2_track1_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 48);

~nk2_track2_mute_button.free;
~nk2_track2_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 49);

~nk2_track3_mute_button.free;
~nk2_track3_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 50);


~nk2_track4_mute_button.free;
~nk2_track4_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 51);

~nk2_track5_mute_button.free;
~nk2_track5_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 52);

~nk2_track6_mute_button.free;
~nk2_track6_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 53);

~nk2_track7_mute_button.free;
~nk2_track7_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 54);

~nk2_track8_mute_button.free;
~nk2_track8_mute_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 55);


// ARM REC BUTTONS
~nk2_track1_armrec_button.free;
~nk2_track1_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 64);

~nk2_track2_armrec_button.free;
~nk2_track2_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 65);

~nk2_track3_armrec_button.free;
~nk2_track3_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 66);


~nk2_track4_armrec_button.free;
~nk2_track4_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 67);

~nk2_track5_armrec_button.free;
~nk2_track5_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 68);

~nk2_track6_armrec_button.free;
~nk2_track6_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 69);

~nk2_track7_armrec_button.free;
~nk2_track7_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 70);

~nk2_track8_armrec_button.free;
~nk2_track8_armrec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 71);



// MASTER BUTTONS
~nk2_track_left_button.free;
~nk2_track_left_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 58);

~nk2_track_right_button.free;
~nk2_track_right_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 59);

~nk2_cycle_button.free;
~nk2_cycle_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 46);


~nk2_rewind_button.free;
~nk2_rewind_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 43);

~nk2_marker_set_button.free;
~nk2_marker_set_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 60);

~nk2_marker_left_button.free;
~nk2_marker_left_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 61);

~nk2_marker_right_button.free;
~nk2_marker_right_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 62);

~nk2_fforward_button.free;
~nk2_fforward_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 44);


~nk2_stop_button.free;
~nk2_stop_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 42);


~nk2_play_button.free;
~nk2_play_button = MIDIFunc.cc({
	arg ...args;
	args.postln;
}, 41);


~nk2_rec_button.free;
~nk2_rec_button = MIDIFunc.cc({
	arg ...args;
	args.postln;

}, 45);
)