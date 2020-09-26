p.fadeTime = 0.25;



d[\scale] = Scale.minor;
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,d[\scale],\root,60,\degree, Prand([7], inf),\octave,-2,\dur,Pbjorklund2(7,16,inf)/4,\d,0.1,\a,900,\pan,0,\amp,0.9);

~ring1.play(fadeTime:0.1);
~ring1.fadeTime_(0.125)
~ring1.stop(5);



~dly = {CombC.ar(~ring1, 4, 0.25, 1.0, 0.7)}
~pitch = {PitchShift.ar(~dly, 2, TRand.kr(0.5, 8, Dust.kr(10)))}
~pitch.play;
~dly = ~root.midicps
~dly.play(fadeTime:0.125);
~verb.stop(0.125);
~pitch.stop


~time = {6.1}
~room = {90}
~verb = {GVerb.ar(~ring1,~room,~time, 0.3, 0.9, drylevel:0.01)}
~verb.play(fadeTime:0.125);
~verb.stop(0.125);
~henon.stop


~dfm = {DFM1.ar(SinOsc.ar([100,103],0,0.1),200,SinOsc.kr(0.1).range(0.9,5),1,0,0.0003,0.9)};
~dfm = {DFM1.ar(SinOsc.ar((60-12).midicps,0,0.1),(60-12).midicps*2,SinOsc.kr(0.1).range(0.9,1.1),1,0,0.0003,0.9)};
~dfm.play;
~dfm.stop(6);
~dfm.stop;

(
~verbSend = {
	var array = [~none.ar];
	FreeVerb.ar(Mix.ar(array),0.33,0.5,0.5,1.5)
}
)



~loop = Pbind(\instrument,\lplay,\buf,d["breaks"][0],\dur,8,\amp,0.5);
~loop.play;
s.meter;
