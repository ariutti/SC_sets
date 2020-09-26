"mySetup/mySetup.scd".loadRelative;


p.clock.tempo = 70/60;


~msg0 = Pbind(\instrument,\bplaym,\buf,d["glitch"][0],\dur,Pbjorklund2(3,8,inf)/4, \amp,4, \rate, 2, \pan, Pwhite(-0.8, 0.8, inf));
~msg0.play;
~msg0.stop;

~tik1 = Pbind(\instrument,\bplaym,\buf,d["glitch"][1],\dur,Pbjorklund2(Pwhite(3,8,inf).round(1),8,inf)/Prand([4, 8], inf),\amp,1, \rate, Pwhite(0.5, 2,inf), \pan, Pwhite(-0.8, 0.8, inf));
~tik1.play;
~tik1.stop;

~msg2 = Pbind(\instrument,\bplaym,\buf,d["glitch"][2],\dur,Pbjorklund2(Pwhite(3,8,inf, Pwhite(1, 10, inf).asStream).round(1),8,inf)/4,\amp,0.6, \rate, Pwhite(0.4, 0.8,inf), \pan, Pwhite(-0.2, 0.2, inf));
~msg2.play;
~msg2.stop;

~high = Pbind(\instrument,\bplaym,\buf,d["glitch"][3],\dur,Pbjorklund2(Pwhite(3,8,inf).round(1),8,inf)/Prand([4],inf),\amp,1, \rate, Prand([0.75, 1,75, 3], inf), \pan, 1);
~high.play;
~high.stop;

(
~p1 = Pbind(\instrument,\bplaym,\buf,d["glitch"][4],\dur,Pbjorklund2(3,8,inf)/4,\amp,1, \rate, Pseq([1.1,2.25, 2.25], inf), \pan, 0);
~p1.play;
)
(
~p1 = Pbind(\instrument,\bplaym,\buf,d["glitch"][4],\dur,Pbjorklund2(Prand([3,5], inf) ,8,inf)/4,\amp,1, \rate, Pseq([1.1,2.25, 2.25], inf), \pan, 0);
~p1.play;
)

~p1.play;
~p1.stop;

~high2 = Pbind(\instrument,\bplaym,\buf,d["glitch"][5],\dur,Pbjorklund2(3,8,inf)/Prand([4,8],inf),\amp, 1, \rate, Pwrand([1.13, 2.26], [9,1].normalizeSum,inf), \pan, 0);
~high2.play;
~high2.stop;

p.clear(2);


1.1
1.34
2.25



Buffer(12, 713, 1, 44000.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/000_msg0.wav)
Buffer(13, 159, 1, 44100.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/000_tik1.wav)
Buffer(14, 131, 1, 44000.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/002_msg2.wav)
Buffer(15, 4832, 1, 44100.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/005_high.wav)

Buffer(16, 12928, 1, 44100.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/005_P1.wav)
Buffer(17, 4768, 1, 44100.0, /home/nicola/Musica/SC_set/mySetup/../mySamples/glitch/006_high2.wav)