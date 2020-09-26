a = Buffer.read(s, "/home/nicola/Musica/_dotdotdot/ENEL/centrali_interattive/Audio moduli/Modulo_1/hello.wav");


Pbindef(\idro,\instrument,\posbplaym,\buf,a,\dur,8,\pos,0.004,\amp,2,\rel,0.0,\rate,1,\addAction,1).quant_([4,0]).stop.play; // ciao, benvenuti,

Pbindef(\idro,\instrument,\posbplaym,\buf,a,\dur,4,\pos,0.1,\amp,2,\rel,0.0,\rate,1,\addAction,1).quant_([4,0]).stop.play; // mi presento sono idro

Pbindef(\idro,\instrument,\posbplaym,\buf,a,\dur,1,\pos,Prand((0..99)/100,inf),\amp,3,\atk, 0.1,\rel,0.1,\rate,1,\addAction,1).quant_([4,0]).stop.play;




Pbindef(\idro).stop;
{PlayBuf.ar(1, a, doneAction:2)}.play;


Vocoder