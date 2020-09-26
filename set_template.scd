s.boot;
m = MandelHub.start("leader");
MandelHub.join("nicola", action: {m = MandelHub.instance});

// 3. if you want you can evaluate some of the following lines of code
m.gui // to make a GUI
m.changeTempo(90/60) // to change the Mandelhub BPM (and all of the clients BPMs)
m.chat("Hi, I'm chatting!"); // chat with other peers

p = ProxySpace.push(s)


"mySetup/mySetup.scd".loadRelative;

s.latency_(0.1);