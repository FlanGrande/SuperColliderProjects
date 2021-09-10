/* Jazz */
(
SynthDef('snakebass', {
	|freq, amp|
	var osc, env, output;

	osc = {LFTri.ar(freq)};

	env = EnvGen.kr(Env.perc(attackTime: 0.001, releaseTime: 1, level: amp, curve: -2.0), doneAction: Done.freeSelf);
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
var dur, amp, notes2, notes5, notes1_1, notes1_2, notesEnd, scale, scaleEnd, octave, masterTranspose;
dur = Pseq([0.5], 4);
amp = Pseq([1.5, 1.0, 1.5, 1.0], 1);
notes2 = Pseq([1, 2, 3, 4]);
notes5 = Pseq([5, 3, 2, 1]);
notes1_1 = Pseq([0, 5, 6, 5]);
notes1_2 = Pseq([8, 7, 6, 5]);
notesEnd = Pseq([0, 4, 5, 6, 7, 5, 4, 2]);
scale = Scale.new(#[0, 2, 4, 5, 6, 7, 9, 11], name: "My Jazz");
scaleEnd = Scale.chromatic;
octave = 2;
masterTranspose = 0;

Pdef(\walking_jazz_bass,
	Pseq([
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\amp, amp,
			\degree, notes2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\amp, amp,
			\degree, notes5,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\amp, amp,
			\degree, notes1_1,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, dur,
			\amp, amp,
			\degree, notes1_2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		)
	], inf)
).play(quant: Quant(4, 0))
);

(
SynthDef(\pad, { |freq|
	var env = EnvGen.kr(Env.perc(0.3, 4.0, 0.5, 0.5), doneAction: Done.freeSelf);
	var temp, sum;
	sum = 0;
	10.do{
		temp = LFTri.ar(
			freq * {Rand(0.99, 1.02)}!2,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2,
			0.02!2
		);
		sum = Vibrato.ar(sum + temp, 4, Line.kr(0.0, 0.06, 4.0, 1.0));
	};

	sum = sum * env;
	Out.ar(0, sum);
}).add;
);

Synth(\pad, [\freq: 60.midicps]);
Synth(\pad, [\freq: 67.midicps]);
Synth(\pad, [\freq: 72.midicps]);

(
SynthDef('harp', {
	|freq, amp|
	var osc, env, output;

	osc = {LFTri.ar(freq)};

	env = EnvGen.kr(Env.perc(attackTime: 0.001, releaseTime: 2.0, level: amp, curve: SinOsc.kr(440.0, 0.0, 1.0)), doneAction: Done.freeSelf);
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
var dur, chord2, chord5, chord1_1, chord1_2, scale, octave, masterTranspose;
dur = Pseq([2.0], 1);
chord2 = [3, 5, 7, 9, 11, 13];
chord5 = [3, 5, 6, 9, 11, 12];
chord1_1 = [2, 4, 6, 8, 11];
chord1_2 = [2, 4, 6, 8];
scale = Scale.major;
octave = 5;
masterTranspose = 0;

Pdef(\walking_jazz_chords,
	Pseq([
		Pbind(
			\instrument, \harp,
			\dur, dur,
			\degree, chord2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave,
			\strum, 0.4 / chord2.size
		),
		Pbind(
			\instrument, \harp,
			\dur, dur,
			\degree, chord5,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave,
			\strum, 0.4 / chord5.size
		),
		Pbind(
			\instrument, \harp,
			\dur, dur,
			\degree, chord1_1,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave,
			\strum, 0.4 / chord1_1.size
		),
		Pbind(
			\instrument, \harp,
			\dur, dur,
			\degree, chord1_2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave,
			\strum, 0.4 / chord1_2.size
		)
	], inf)
).play(quant: Quant(4, 0));
);

(
var dur, chord2, chord5, chord1_1, chord1_2, scale, octave, masterTranspose;
dur = Pseq([2.0], 1);
chord2 = [3, 5, 7];
chord5 = [3, 5, 6];
chord1_1 = [2, 4, 6];
chord1_2 = [2, 4, 6];
scale = Scale.major;
octave = 5;
masterTranspose = 0;

Pdef(\walking_jazz_chords2,
	Pseq([
		Pbind(
			\instrument, \pad,
			\dur, dur,
			\degree, chord2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \pad,
			\dur, dur,
			\degree, chord5,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \pad,
			\dur, dur,
			\degree, chord1_1,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		),
		Pbind(
			\instrument, \pad,
			\dur, dur,
			\degree, chord1_2,
			\ctranspose, 0 + masterTranspose,
			\scale, scale,
			\octave, octave
		)
	], inf)
).play(quant: Quant(4, 0));
);

/* It seems silly but maybe I can use code similar to this to make a NOM sound? */
{ VarSaw.ar(VarSaw.kr(0.2, 0, 0.2, 400,800),0,0.2,0.1) }.scope(1, zoom: 4);
{ VarSaw.ar(XLine.kr(100,15000,6),0,0.2,0.1) }.scope(1, zoom: 4);

/* Sound of rain or an old vynil playing */
{ Dust.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);
{ Dust2.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);

/* For whatever reason this default synth sounds a bit like a guitar */
(
p = Pbind(
    // array is "multichannel expanded" into one Synth each
	\instrument, \snakebass,
    \degree, #[0, 2, 5, 8, 11, 13, 16],
    \octave, 5,
    \dur, 1.6,
    \sustain, 1.0,
    // non-zero strum staggers the entrances
	\strum, 0.06
).play(quant: 2);
)