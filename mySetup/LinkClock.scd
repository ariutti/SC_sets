TempoClock.default = LinkClock(120/60).latency_(Server.default.latency);
t = TempoClock.default;
t.free
t.latency_(0.21)

// test the LinkClock
t.tempo_(136/60)
t.tempo_(120/60)
t.tempo_(60/60)


(
var win = Window("LinkClock", Rect(200, 200, 500, 100)).front,
peersBox, tempoBox, barsBox, beatsBox,
font = Font.default.copy.size_(32),
boldFont = font.boldVariant,
controller, task;

win.layout = HLayout(
    StaticText().font_(font).string_("Peers:"),
    peersBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
    StaticText().font_(font).string_("Tempo:"),
    tempoBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(120),
    StaticText().font_(font).string_("Now:"),
    barsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
    beatsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80)
);

[peersBox, barsBox, beatsBox].do { |view| view.enabled_(false) };

tempoBox.action = { |view| t.tempo = view.value / 60 };
tempoBox.value = t.tempo * 60;
peersBox.value = t.numPeers;

task = Routine {
    var bars, beats;
    loop {
        bars = t.bar;
        beats = t.beatInBar;
        {
            barsBox.value = bars;
            beatsBox.value = beats+1;
			switch( beatsBox.value.asInteger,
				1, { beatsBox.background_(Color.red()) },
				{ beatsBox.background_(Color.green()) },
			);
        }.defer(t.latency);
        1.0.wait;
    }
}.play(t, quant: 1);

controller = SimpleController(t)
.put(\tempo, {
    defer { tempoBox.value = t.tempo * 60 }
})
.put(\numPeers, {
    defer { peersBox.value = t.numPeers }
})
.put(\stop, { defer { win.close } });

win.onClose = { task.stop; controller.remove };
)
