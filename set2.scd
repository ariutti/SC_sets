//layering of slightly different rhythms
//rhythm 1
(
p.clock.tempo = 1.7;
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t.play;
)
//rhythm 2, using a different tom for contrast
//also re-evaluating rhythm 1 to get them playing together
(
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d["t"][1],\dur,Pseq([1,1,1,0.25],inf),\amp,1);
~t2.play;
)
//rhythm 3 for more
(
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,0.5);
~t2 = Pbind(\instrument,\bplay,\buf,d["t"][1],\dur,Pseq([1,1,1,0.25],inf),\amp,0.5);
~t3 = Pbind(\instrument,\bplay,\buf,d["t"][2],\dur,Pseq([1,1,1,0.75],inf),\amp,0.5);
~t3.play;
)
//kick underneath to illustrate
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1,\rate,1);
~oh.play;
~k.play;
)

~t.stop; ~t1.stop; ~t2.stop; ~t3.stop;
~t.play; ~t1.play; ~t2.play; ~t3.play;
~sn.stop; ~k.stop; ~oh.stop;
~sn.play; ~k.play; ~oh.play; ~t.stop; ~t1.stop; ~t2.stop; ~t3.stop;
~sin.stop;

~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,2,\amp,0.7,\rate, 1);
~sn.play;

p.fadeTime = 0.25;
~sin = Pbind(\instrument,\sinfb,\freq,60.midicps,\dur,0.25,\amp,0.3,\fb,0.1,\rel,0.7);
(
var root = 34;
~sin = Pbind(\instrument,\sinfb,\freq,Pseq([1,2,3,4,5].pyramid,inf)*(root+24).midicps,\dur,0.25,\amp,0.2,\fb,Pwhite(0.1, 0.9),\rel,0.15);

~bass = Pbind(\instrument,\sinfb,\freq,root.midicps,\dur,Pseq([0.25, 0.25, 0.5, 0.25],inf),\amp,0.8,\fb,0.9,\rel,0.1);

~sin.play;
~bass.play;
)
(
~sin.stop;
~bass.stop;
)

p.gui