d = Dictionary.new();
d[\k] = [];
d[\k].add(Buffer.read(s,"/home/nicola/Musica/SC_set/mySamples/k/1-by-asparagus.wav"));
d[\k][0];

d[\sn] = [];
d[\sn].add(Buffer.read(s,"/home/nicola/Musica/SC_set/mySamples/s/Crsnred_scr_snr_6.wav"));
d[\sn][0];

p = ProxySpace.push(s)
p.makeTempoClock;
p.clock = m.clock;

~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pwrand([Pn(1/3,3), Pn(1/6,6), 0.5], [2, 1, 20].normalizeSum, inf),\amp,1,\rate,0.5);
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pseq([Pn(1/3,3), Pn(0.5,inf)], inf),\amp,1,\rate,0.5);
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pseq([Pn(1/6,6), Pn(0.5,inf)], inf),\amp,1,\rate,0.5);
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pseq([Pn(1/4,3), Pn(0.5,8)], inf),\amp,1,\rate,0.5);
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,0.5,\amp,1,\rate,0.5);
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,1,\amp,1,\rate,0.5);
~k.quant_(1);
~k.fadeTime_(0.0);
(
~k = Pbind(\instrument,\bplay,\buf,d[\k][0],\dur,Pseq([Pn(1/4,2), Pn(0.5,7)], inf),\amp,1,\rate,0.5);
~k.reset;
~k.play;
~sn.play;
)
(
~k.stop;
~sn.stop;
)
(
~sn = Pbind(\instrument,\bplay,\buf,d[\sn][0],\dur,2,\amp,0.5, \rate, 0.6, \rel,Pseq([0.1, 0.2], inf));
~sn[1] = \filter -> {|in| Decimator.ar(in, 11025, 4)}; //XFade2.ar(in,GVerb.ar(in*0.5), Pulse.kr(0.5).range(-1, 1)),44100, 3)}
)
~sn.quant_(2);
~sn.play;
~sn.stop(fadeTime:4);