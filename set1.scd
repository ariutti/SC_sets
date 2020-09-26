"Setup/Setup.scd".loadRelative;

~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,0.75,\amp,0.125,\out, ~b);
~c.play;
~c.stop;

s.scope(~bus);

~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,4,\amp,1,\type,[\Rest, \note], \out, ~b);
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pexprand(0.05,1)*3, \rate, 1);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,0.75,\amp,1);

~k.stop
~sn.stop
~h.play
~c.stop


//same example but with all rhythms constrained
(
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(1,5.0).round(1),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][2],\dur,Pwhite(0.25,0.75).round(0.25),\amp,0.2);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,Pwhite(0.75,2).round(0.75),\amp,0.5,\rate,Pwhite(0.5, 3));
~t = Pbind(\instrument,\bplay,\buf,d["t"][2],\dur,Pwhite(1,5.0).round(0.5),\amp,1);
~sn.play;~h.play;~c.play;~t.play;
)
//sounds more palatable with everything arranged properly
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~k.play;
)

~k.stop;~sn.stop;~h.stop;~c.stop;~t.stop;

s.scope;
s.meter;

//same example again
(
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(1,5.0).round(1),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwhite(0.25,0.75).round(0.25),\amp,Pwhite(0.2,1), \pan, Pwhite(-0.8, 0.8));
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,Pwhite(0.75,2).round(0.75),\amp,0.5);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pwhite(1,5.0).round(0.5),\amp,1);
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~sn.play;~h.play;~c.play;~t.play;~k.play;
)
//added whole note fx, short, medium and long.
(
~fx1 = Pbind(\instrument,\bplay,\buf,d["sfx"][0],\dur,Pwhite(1,5),\amp,1);
~fx2 = Pbind(\instrument,\bplay,\buf,d["fx"][0],\dur,Pwhite(1,10),\amp,1);
~fx3 = Pbind(\instrument,\bplay,\buf,d["lfx"][0],\dur,Pwhite(10,40),\amp,1);
~fx1.play;~fx2.play;~fx3.play;
)

~fx1.stop;~fx2.stop;~fx3.stop;

~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(0.25, 2).round(0.25),\amp,1,\rate,Pwhite(0.1,3));
~sn.play;
~sn.stop;
~h.stop;
~c.stop;
~t.stop;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pseq([Pseq([0.5], 4), Pseq([1], 3)], inf),\amp,Pwhite(0.3, 1.5));

(
p.clock.tempo = 2.3;
~sn.stop;~h.stop;~c.stop;~t.stop;~k.stop;
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(0.25, 1).round(0.25),\amp,Pgauss(1.0, 0.125, inf),\rate, Pwhite(0.1,4));
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~sn.play;
~k.play;
)


~k2.stop; ~k.stop; ~sn.stop; ~h.stop;
~k2.play; ~k.play; ~sn.play; ~h.play;



//layering at different pitches - kicks
(
p.clock.tempo = 2.3;
p.fadeTime = 5;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(3,8)/4,\amp,2,\rate,Pseq([1,1.2],inf));
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,2,\rate,1);
~k.play;
)
~k.stop;
~k2.stop;
//kicks at a different pitch. Evaluate this a few times to get different permutations
(
~k2 = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.8],inf)*4);
~k2.play;
)
~k2.stop