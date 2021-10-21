t = TempoClock.default;
t = TempoClock.default.tempo_(136/60);

// DRUMS ///////////////////////////////////////////////////////////////////////////////////

(
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
Pbindef(\clap,\instrument,\bplay,\buf,~clap,\dur,2,\amp,[1,1] * 0.7,\rel,0.125,\rate,1.1 * Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\strum, Pwhite(0.0, 0.1, inf), \pan, [-1, 1]).quant_([4,1]).stop.play;
)

(
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
Pbindef(\snap,\instrument,\bplay,\buf,~snap,\dur,2,\amp,4,\rel,0.125,\rate, Pgauss(1, 0.07, inf).clump(2),\addAction,1, \lag,Pwhite(0.0, 0.02, inf),\pan, [-1, 1], \strum,Pwhite(0.0, 0.02, inf)).quant_([4,1]).stop.play;
)

Pbindef(\clap).play;
Pbindef(\snap).play;

(
Pbindef(\clap).stop;
Pbindef(\snap).stop;
)