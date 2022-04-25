d.keys.do({|k| k.postln;})
/*
lfx
misc
k
speakspell_letters
breaks175
numbers
ding
808sd
strings
s
ch
oh
q
loops
sstick
shout
foldernames
idro
mySamples
sfx
c
oh_mono
t
tlapan
vinyl
stab
ht
mt
fx
guitars
sk
gab
pk
prince
orchestrahit
*/
d["ch"][0].play

~dirt.keys.do({|k| k.postln;})

// KICKs ///////////////////////////////////////////////////////////////////////////////////////
d["k"][0].play // blahh
d["k"][1].play
~dirt["world"][0].play
~dirt["drumtraks"][6].play // !!! low, profonda

~dirt["909"][0].play // blah


// SNARE //////////////////////////////////////////////////////////////////////////////////////
~dirt["drumtraks"][9].play // - snare
~dirt["jazz"][7].play // - snare
d["s"][0].play
d["s"][1].play // volgarissimo
d["s"][3].play
~dirt["808sd"][3].play // 808
~dirt["808sd"][1].play // 808

// SIDE STICK /////////////////////////////////////////////////////////////////////////////////
d["sstick"][0].play
d["sstick"][2].play
~dirt["tech"][12].play // sidestick
~dirt["drumtraks"][8].play // !!



// HI HAT CLOSED ///////////////////////////////////////////////////////////////////////////////
d["ch"][0].play
~dirt["tech"][0].play // closed hat
~dirt["drumtraks"][4].play


// HI HAT CLOSED ///////////////////////////////////////////////////////////////////////////////
~dirt["tech"][7].play // open hat
~dirt["drumtraks"][4].play; // open hat
~dirt["808oh"][1].play // 808



// CLAP ///////////////////////////////////////////////////////////////////////////////////////
d["c"][0].play
~dirt["jazz"][4].play // - clap
~clap = Buffer.read(s, "/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Claps/clap-toilet-07.wav");
~clap.play;

// SNAP ///////////////////////////////////////////////////////////////////////////////////////
~snap = Buffer.read(s,"/home/nicola/Musica/samples/CC0/#99S002 Hands Make Sounds/Snaps/snap-close-13.wav");
~snap.play

// OTHERS /////////////////////////////////////////////////////////////////////////////////////
~dirt["drumtraks"][2].play // - agogo
~vincent = Buffer.read(s, "/home/nicola/Scaricati/Telegram Desktop/vincent_price_MLgenerated_test1.wav");
~vincent.play

~dirt["yeah"]  // slitchy sort of things
~dirt["tabla"] // - all
~dirt["sitar"]
~dirt["invaders"]
~dirt["bev"]
d["speakspell_letters"][0].play
d["loops"]



// SHAKER ///////////////////////////////////////////////////////////////////////////////////////
~dirt["drumtraks"][0].play
~dirt["tech"][8] // tambourine

