s.plotTree;
s.meter;

(
SynthDef(\blip, { |freq|
	var env = Env.perc(level: 0.1, releaseTime: 0.2).kr(doneAction: Done.freeSelf);
	var sig = Pulse.ar(freq: freq, width: 0.5) * env;
	Out.ar(0, [sig, sig]);
}).add;

SynthDef(\bass, { |freq|
	var env = Env.perc(level: 0.1, releaseTime: 1.0, curve: -2.0).kr(doneAction: Done.freeSelf);
	var sig = Pulse.ar(freq: freq/4, width: 0.9) * env;
	Out.ar(0, [sig, sig]);
}).add;

SynthDef(\strings, { |freq|
	var env = EnvGen.kr(Env.perc(0.01, 5, 1, -2), doneAction: Done.freeSelf);
	var temp, sum;
	sum = 0;
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99, 1.02)}!2,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2,
			0.02!2
		);
		sum = sum + temp;
	};

	sum = sum * env;
	Out.ar(0, sum);
}).add;
);

Synth(\strings, [\freq: 60.midicps]);

(
SynthDef(\drums, { |freq|
	var env = Env.perc(level: 0.1, releaseTime: 0.2).kr(doneAction: Done.freeSelf);
	var sig = WhiteNoise.ar * env;
	var trigger = Impulse.ar(freq);
	sig = Latch.ar(sig, trigger);
	Out.ar(0, [sig, sig]);
}).send(s);

~bass = 500; ~snare = 10000;

SynthDef(\tss, { |freq|
	//var env = Env.perc(level: 0.1, releaseTime: 0.6).kr(doneAction: Done.freeSelf);
	var env = Env.new(levels: [0.00, 0.01, 0.01, 0], times: [0.04, 0.04, 1], curve: [3,-3, -3]).kr(doneAction: Done.freeSelf);
	//var sig = WhiteNoise.ar * env;
    var sig = {LPF.ar(WhiteNoise.ar(1.0),16000, 1.0)} * env;
	//sig = sig * freq;

	Out.ar(0, [sig, sig]);
}).send(s);

SynthDef(\tssT, { |freq|
	//var env = Env.perc(level: 0.1, releaseTime: 0.6).kr(doneAction: Done.freeSelf);
	var env = Env.new(levels: [0.00, 0.02, 0.01, 0, 0.01, 0], times: [0.04, 0.01, 0.3, 0.2, 0.2], curve: [3,-3, -3, 7, 0]).kr(doneAction: Done.freeSelf);
	//var sig = WhiteNoise.ar * env;
    var sig = {LPF.ar(WhiteNoise.ar(1.0),16000, 1.0)} * env;
	//sig = sig * freq;

	Out.ar(0, [sig, sig]);
}).send(s);
);


Synth(\drums, [\freq: 60]);
~bass = 500; ~snare = 10000;

Env.new(levels: [0.00, 0.04, 0.02, 0, 0.02, 0], times: [0.04, 0.01, 0.35, 0.2], curve: [3,-3, -3, 7, -3]).plot;
Synth(\tss, [\freq: 100]);
Synth(\tssT, [\freq: 100]);


(
x = Pdef(\melody,
	Pbind(
		\type, \note,
		\instrument, \blip,
		\dur, Pseq([0.5, 0.75, 0.25, 0.25, 0.5, 0.25, 1.5], inf),
		\degree, Pseq([2, 0, -2, 0, 1, 0, 1], inf),
		\scale, Scale.major
	)
).play(quant: 4);
);
Tuning.directory;
(
y = Pdef(\bass,
	Pbind(
		\instrument, \bass,
		\dur, Pseq([1, 1, 1, 1], inf),
		\degree, Pseq([-2, 1, 2, 0], inf),
		\scale, Scale.major
	)
).play(quant: 4);
);

Synth(\blip, [\freq: Scale.major.degreeToFreq(2, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(0, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(-2, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(0, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(1, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(0, 60.midicps, 1)]);
Synth(\blip, [\freq: Scale.major.degreeToFreq(1, 60.midicps, 1)]);

(
x = Pdef(\melody2,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([0.5, 1, 0.25, 0.5, 0.5, 0.5, 0.5], inf),
		\degree, Pseq([0, 4, 6, 8, 4, 6, 7], inf),
		\scale, Scale.minor
	)
).play(TempoClock.default, quant: 4);
);

(
Pdef(\harmony,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([Prand([0.25, 0.5, 0.125, 0.125, 0.125, 0.125])], inf),
		\degree, Pseq([4, Prand([3, 2, 1]), 0, 2], inf),
		\scale, Scale.mixolydian,
		\octave, 6
	)
).play(TempoClock.default, quant: 4);
);

(
Pdef(\harmonyrand,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([Prand([0.25, 0.5])], inf),
		\degree, Pseq([3, Prand([4, 7, 2]), Prand([1, 2]), Prand([0, 3, 5])], inf),
		\scale, Scale.major,
		\octave, 6
	)
).play(TempoClock.default, quant: 4);
);

(
Pdef(\drumBeat,
	Pbind(
		\instrument, \drums,
		\dur, Pseq([1, 1.5, 0.5, 0.5, 0.5], inf),
		\freq, Pseq([~bass, ~snare, ~bass, ~snare, ~bass], inf)
	)
).play(quant: 4);
);

(
Pdef(\snakeTss,
	Pbind(
		\type, \note,
		\instrument, Pseq([\tssT, \tss], inf),
		\dur, Pseq([0.85, 0.15], inf)
	)
).play(quant: 4);
);

(
SynthDef('snakebass', {
	|freq|
	var osc, env, output;

	osc = {SinOsc.ar(freq)};

	env = Env.perc(level: 1.5, releaseTime: 1, curve: -4.0).kr(doneAction: Done.freeSelf);
	//env = Env.perc(level: 0.6, releaseTime: 0.4).kr(doneAction: Done.freeSelf);
	//env = Env.sine(0.6, 2.0).kr(doneAction: Done.freeSelf);
	output = LPF.ar(osc * env, freq, LinExp.ar(osc * env, 1.0, 0.0, 2.0, 1.0));
	//output = LPF.ar(osc * env, freq, Line.ar(4.0, 0.2, 0.5));

	//env = {Line.ar(900, 600, 0.5, 0.1, doneAction: Done.freeSelf)};
	//output = BPF.ar(osc * env, 440.0, 0.8 ,0.08);

	Out.ar(0,
		Pan2.ar(output, 0)
	)
}).send(s);
)

(
Pdef(\walking_bass,
	Pbind(
		\instrument, \snakebass,
		\dur, Pseq([Prand([0.5])], inf),
		\degree, Pseq([Prand([-2, -1, 0, 1, 4, 5, 7, 8, 11, 12, 14])], inf),
		\scale, Scale.harmonicMinor,
		\octave, 2
	)
).play(quant: 4);
);

(
Pdef(\walking_bass,
	Pbind(
		\instrument, \snakebass,
		\dur, Pseq([Prand([0.5])], inf),
		\degree, Pseq([1, 2, 4, 7, 5, 4, 3, 6, Prand([4,7])], inf),
		\scale, Scale.harmonicMinor,
		\octave, 2
	)
).play(quant: 4);
);

(
var dur, notes, notesEnd, scale, scaleEnd, octave, masterTranspose;
dur = 0.35;
notes = Pseq([0, 2, 4, 5, 6, 5, 4, 2]);
notesEnd = Pseq([0, 4, 5, 6, 7, 5, 4, 2]);
scale = Scale.mixolydian;
scaleEnd = Scale.chromatic;
octave = 3;
masterTranspose = -3;

Pdef(\walking_blues_bass,
	Pseq([
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 5 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, Pseq(notes.list.copyRange(0, 3)),
			\ctranspose, 7 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, Pseq(notes.list.copyRange(0, 3)),
			\ctranspose, 5 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notesEnd,
			\ctranspose, 0 + masterTranspose,
			\scale, scaleEnd,
			\octave, octave
		)
	], inf)
).play(quant: 4);
);

Scale.directory;

{XLine.ar(900, 300, 0.5, 0.01, doneAction: Done.freeSelf)}.plot

{SinOsc.ar(110, 0.2)}.plot

/*(
t = Pbind(
		\type, \note,
		\instrument, Pseq([\tssT, \tss, \tss, \tss], inf),
		\dur, Pseq([0.85, 0.15, 0.85, 0.15], inf)
	).asStream;
)

t.next(Event.new).play*/

(
SynthDef('basic-FM',{

arg freq1 = 440, amp1 = 30,
freq2 = 150, amp2 = 0.5;

var osc1, osc2;

osc1 = {SinOsc.ar(freq1) * amp1};
osc2 = {SinOsc.ar(freq2 + osc1)};

Out.ar(0,
Pan2.ar(osc2, 0)
)

}).send(s)
)

t = Synth('basic-FM',['freq1', 40, 'freq2', 120, 'amp1', 100]);

t.free;

(
	var dur, notes, notesEnd, scale, scaleEnd, octave, masterTranspose;
	dur = 0.35;
	notes = Pseq([0, 2, 4, 5, 6, 5, 4, 2]);
	notesEnd = Pseq([0, 4, 5, 6, 7, 5, 4, 2]);
	scale = Scale.mixolydian;
	scaleEnd = Scale.chromatic;
	octave = 3;
	masterTranspose = -3;

	t = Pseq([
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 5 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notes,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, Pseq(notes.list.copyRange(0, 3)),
			\ctranspose, 7 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, Pseq(notes.list.copyRange(0, 3)),
			\ctranspose, 5 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\degree, notesEnd,
			\ctranspose, 0 + masterTranspose,
			\scale, scaleEnd,
			\octave, octave
		)
	], inf).asStream
);

t.next(Event.new).play;

// Examples of Env

*linen(attackTime, sustainTime, releaseTime, level, curve)

Env.linen(1, 2, 3, 0.6).test.plot;
Env.linen(0.1, 0.2, 0.1, 0.6).test.plot;
Env.linen(1, 2, 3, 0.6, 'sine').test.plot;
Env.linen(1, 2, 3, 0.6, 'welch').test.plot;

*triangle(duration, level)

Env.triangle(1, 1).test.plot;

*sine(duration, level) // hanning

Env.sine(1,1).test.plot;

*perc(attackTime, releaseTime, peakLevel, curve)

Env.perc(0.05, 1, 1, 0).test.plot;   // linear
Env.perc(0.05, 1, 1, -4).test.plot;  // exponential
Env.perc(0.001, 1, 1, -4).test.plot; // sharper attack
Env.perc(0.001, 1, 1, -8).test.plot; // change curvature
Env.perc(1, 0.01, 1, -4).test.plot;  // reverse envelope

// In order to use these in real life you need EnvGen

{SinOsc.ar(800, 0, 0.5) * EnvGen.kr(Env.perc (0.001, 1), 1.0)}.play;

// Another way of writing the same thing:
(
 {
  var freq, env;
  freq = 800;
  env = EnvGen.kr(Env.perc(0.001, 1), 1.0);
  SinOsc.ar(freq, mul: env);
 }.play
)



Env.perc(0.001, 1).test.plot; // this is sharp and nice attack

{SinOsc.ar(800, 0, 0.5) * EnvGen.kr(Env.perc (0.001, 1), 1.0)}.play; // this should be the same, but it isn't...

// And if I use an envelope trigger, the following notes sound correct, but the first is still wrong:
(
 {
  var freq, trigger, env;
  freq = 800;
  trigger = Impulse.kr(1/2); // trigger a note every 2 seconds
  env = EnvGen.kr(Env.perc(0.001, 1), trigger);
  SinOsc.ar(freq, mul: env);
 }.play
)


// Additive Synthesis (I believe this is useful if I want to emulate the timbre of an instrument)
/* TRUMPET */
(
var freq = 440;
{SinOsc.ar(freq,0,0.1)
	+ SinOsc.ar(freq*2,0,0.01)
	+ SinOsc.ar(freq*3,0,0.2)
	+ SinOsc.ar(freq*4,0,0.4)
	+ SinOsc.ar(freq*5,0,0.3)}.play
)

/* SAX */
(
var freq = 440;
{SinOsc.ar(freq,0,0.5)
	+ SinOsc.ar(freq*2,0,0.4)
	+ SinOsc.ar(freq*3,0,0.1)
	+ SinOsc.ar(freq*4,0,0.01)
	+ SinOsc.ar(freq*5,0,0.01)}.play
)

{SinOsc.ar(440,0,0.5) + SinOsc.ar(870,0,0.3) + SinOsc.ar(1330,0,0.1)}.play // A4 + 2 slightly detuned harmonics

(
{
 var fund = 220;
 Mix.ar(
		[
		SinOsc.ar(fund*1),
		SinOsc.ar(fund*2),
		SinOsc.ar(fund*3),
		SinOsc.ar(fund*4),
		SinOsc.ar(fund*5),
		SinOsc.ar(fund*6)
		]
        ) * 0.1  // scale amplitude down to avoid clipping
}.play
)

(
{Mix.ar(
	Array.fill(20,
		{arg count;
		 var harm;
		 harm = (count + 1) * 110;
			SinOsc.ar(harm)*1/(count+1) // higher harmonics will be softer
		}))*0.5 // global amplitude scaling
}.play
)