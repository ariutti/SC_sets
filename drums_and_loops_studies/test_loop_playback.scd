"mySetup/mySetup.scd".loadRelative;

~loop = Pbind(\instrument, \lplay, \buf, d["loops"][0], \amp,1, \bed,16, \dur,4, \start, 0);
~loop.play;
~loop.stop;
~loop.clear;


~in = ~loop
~freq = {LFSaw.kr(1/p.clock.tempo, 0.0).cubed.exprange(50, 15000)}
~lpf = {LPF.ar(~in, ~freq)}
(
//~loop.play;
~loop.stop;
~freq = {LFSaw.kr(1/p.clock.tempo, 0.0).cubed.exprange(50, 15000)};
~lpf.play;
//~lpf.stop;
)

// TODO: creare un synthDef che funga da LFO che abbia un senso musicalmente parlando