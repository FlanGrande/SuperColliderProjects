s.quit; // Does this actually help?
s.boot;

s.waitForBoot({
	var bass_dur,

		blues_bass_dur, 
		blues_bass_notes, blues_bass_notesEnd, 
		blues_bass_scale, blues_bass_scaleEnd, 
		blues_bass_octave, 
		blues_bass_masterTranspose, 
		blues_bass_seq,
		
		jazz_bass_dur,
		jazz_bass_amp,
		jazz_bass_notes2, 
		jazz_bass_notes5, 
		jazz_bass_notes1_1, 
		jazz_bass_notes1_2, 
		jazz_bass_chords, 
		jazz_bass_scale, 
		jazz_bass_octave, 
		jazz_bass_masterTranspose, 
		jazz_bass_seq,

		jazz_chords_dur,
		jazz_chords_amp,
		jazz_chords_chord2,
		jazz_chords_chord5,
		jazz_chords_chord1_1,
		jazz_chords_chord1_2,
		jazz_chords_scale,
		jazz_chords_octave,
		jazz_chords_masterTranspose,
		jazz_chords_seq,

		jazz_melody_dur,
		jazz_melody_chord2,
		jazz_melody_chord5,
		jazz_melody_chord1,
		jazz_melody_scale,
		jazz_melody_octave,
		jazz_melody_masterTranspose,
		jazz_melody_seq;

	/* General vars */
	bass_dur = 0.5;

	/* Blues vars */
	blues_bass_dur = 0.5;
	blues_bass_notes = Pseq([0, 2, 4, 5, 6, 5, 4, 2]);
	blues_bass_notesEnd = Pseq([0, 4, 5, 6, 7, 5, 4, 2]);
	blues_bass_scale = Scale.mixolydian;
	blues_bass_scaleEnd = Scale.chromatic;
	blues_bass_octave = 3;
	blues_bass_masterTranspose = -3;

	/* Jazz vars */
	jazz_bass_dur = Pseq([0.5], 4);
	jazz_bass_amp = Pseq([1.5, 1.3, 1.4, 1.2], 1);
	jazz_bass_notes2 = Pseq([1, 2, 3, 4]);
	jazz_bass_notes5 = Pseq([5, 3, 2, 1]);
	jazz_bass_notes1_1 = Pseq([0, 5, 6, 5]);
	jazz_bass_notes1_2 = Pseq([8, 7, 6, 5]);
	jazz_bass_scale = Scale.new(#[0, 2, 4, 5, 6, 7, 9, 11], name: "My Jazz");
	jazz_bass_octave = 2;
	jazz_bass_masterTranspose = 0;

	jazz_chords_dur = Pseq([2.0], 1);
	jazz_chords_amp = Pseq([0.5], 1);
	jazz_chords_chord2 = [1, 7, 10, 12];
	jazz_chords_chord5 = [4, 8, 10, 13];
	jazz_chords_chord1_1 = [0, 4, 6, 9];
	jazz_chords_chord1_2 = [-2, 2, 4, 7];
	jazz_chords_scale = Scale.major;
	jazz_chords_octave = 4;
	jazz_chords_masterTranspose = 0;

	jazz_melody_dur = Pseq([0.5], 4);
	jazz_melody_chord2 = Pseq([1, 2, 3, 4]);
	jazz_melody_chord5 = Pseq([5, 3, 2, 1]);
	jazz_melody_chord1 = Pseq([0, 5, 6, 5]);
	jazz_melody_scale = Scale.major;
	jazz_melody_octave = 6;
	jazz_melody_masterTranspose = 0;
	
	/* Synths definitions */
	SynthDef('\snakebass', {
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

	SynthDef(\snakepad, { |freq|
		var env = EnvGen.kr(Env.perc(2, 1, 0.5, -1), doneAction: Done.freeSelf);
		var temp, sum;
		sum = 0;
		10.do{
			temp = LFTri.ar(
				freq * {Rand(0.99, 1.02)}!2,
				{Rand(0.0, 1.0)}!2,
				{ExpRand(0.005, 0.05)}!2,
				0.02!2
			);
			sum = sum + temp;
		};

		sum = sum * env;
		Out.ar(0, sum);
	}).send(s);


	SynthDef(\snakeharp, { |freq, amp|
		var osc, env, output;

		osc = {LFTri.ar(freq)};

		env = EnvGen.kr(Env.perc(attackTime: 0.001, releaseTime: 2.0, level: amp, curve: SinOsc.kr(440.0, 0.0, 1.0)), doneAction: Done.freeSelf);
		//env = Env.perc(level: 0.6, releaseTime: 0.4).kr(doneAction: Done.freeSelf);
		//env = Env.sine(0.6, 2.0).kr(doneAction: Done.freeSelf);
		output = LPF.ar(osc * env, freq, LinExp.ar(osc * env, 1.0, 0.0, 1.0, 1.0));
		output = Vibrato.ar(output, 4, Line.kr(0.0, 0.2, 1.5, 1.0));
		//output = LPF.ar(osc * env, freq, Line.ar(4.0, 0.2, 0.5));

		//env = {Line.ar(900, 600, 0.5, 0.1, doneAction: Done.freeSelf)};
		//output = BPF.ar(osc * env, 440.0, 0.8 ,0.08);

		Out.ar(0,
			Pan2.ar(output, 0)
		)
	}).send(s);

	SynthDef(\snakeblip, { |freq|
		var env = Env.perc(level: 0.1, releaseTime: 0.2).kr(doneAction: Done.freeSelf);
		var sig = Pulse.ar(freq: freq, width: 0.5) * env;
		Out.ar(0, [sig, sig]);
	}).send(s);

	SynthDef('\snakeeat', {
		|freq|
		var osc, env, output;

	    //osc = {SinOsc.ar(40)};
	    osc = {LFTri.ar(freq)};
	    env = {Line.ar(1.0, 0, 0.02, doneAction: 2)};

	    output = osc * env;

	    Out.ar(0,
	        Pan2.ar(output, 0)
	    )

	}).send(s);

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

	/* Sequences */
	blues_bass_seq = Pseq([
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, blues_bass_notes,
			\ctranspose, 0 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, blues_bass_notes,
			\ctranspose, 0 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, blues_bass_notes,
			\ctranspose, 5 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, blues_bass_notes,
			\ctranspose, 0 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, Pseq(blues_bass_notes.list.copyRange(0, 3)),
			\ctranspose, 7 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, Pseq(blues_bass_notes.list.copyRange(0, 3)),
			\ctranspose, 5 + blues_bass_masterTranspose,
			\scale, blues_bass_scale,
			\octave, blues_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, blues_bass_dur,
			\degree, blues_bass_notesEnd,
			\ctranspose, 0 + blues_bass_masterTranspose,
			\scale, blues_bass_scaleEnd,
			\octave, blues_bass_octave
		)
	], inf).asStream;

	jazz_bass_seq = Pseq([
		Pbind(
			\instrument, \snakebass,
			\dur, bass_dur,
			\amp, jazz_bass_amp,
			\degree, jazz_bass_notes2,
			\ctranspose, 0 + jazz_bass_masterTranspose,
			\scale, jazz_bass_scale,
			\octave, jazz_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, bass_dur,
			\amp, jazz_bass_amp,
			\degree, jazz_bass_notes5,
			\ctranspose, 0 + jazz_bass_masterTranspose,
			\scale, jazz_bass_scale,
			\octave, jazz_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, bass_dur,
			\amp, jazz_bass_amp,
			\degree, jazz_bass_notes1_1,
			\ctranspose, 0 + jazz_bass_masterTranspose,
			\scale, jazz_bass_scale,
			\octave, jazz_bass_octave
		),
		Pbind(
			\instrument, \snakebass,
			\dur, bass_dur,
			\amp, jazz_bass_amp,
			\degree, jazz_bass_notes1_2,
			\ctranspose, 0 + jazz_bass_masterTranspose,
			\scale, jazz_bass_scale,
			\octave, jazz_bass_octave
		)
	], inf).asStream;

	jazz_chords_seq = Pseq([
		Pbind(
			\instrument, \snakeharp,
			\dur, jazz_chords_dur,
			\amp, jazz_chords_amp,
			\degree, jazz_chords_chord2,
			\ctranspose, 0 + jazz_chords_masterTranspose,
			\scale, jazz_chords_scale,
			\octave, jazz_chords_octave,
			\strum, 0.4 / jazz_chords_chord2.size
		),
		Pbind(
			\instrument, \snakeharp,
			\dur, jazz_chords_dur,
			\amp, jazz_chords_amp,
			\degree, jazz_chords_chord5,
			\ctranspose, 0 + jazz_chords_masterTranspose,
			\scale, jazz_chords_scale,
			\octave, jazz_chords_octave,
			\strum, 0.4 / jazz_chords_chord5.size
		),
		Pbind(
			\instrument, \snakeharp,
			\dur, jazz_chords_dur,
			\amp, jazz_chords_amp,
			\degree, jazz_chords_chord1_1,
			\ctranspose, 0 + jazz_chords_masterTranspose,
			\scale, jazz_chords_scale,
			\octave, jazz_chords_octave,
			\strum, 0.4 / jazz_chords_chord1_1.size
		),
		Pbind(
			\instrument, \snakeharp,
			\dur, jazz_chords_dur,
			\amp, jazz_chords_amp,
			\degree, jazz_chords_chord1_2,
			\ctranspose, 0 + jazz_chords_masterTranspose,
			\scale, jazz_chords_scale,
			\octave, jazz_chords_octave,
			\strum, 0.4 / jazz_chords_chord1_2.size
		)
	], inf).asStream;

	jazz_melody_seq = Pseq([
		Pbind(
			\instrument, \snakeblip,
			\dur, jazz_melody_dur,
			\degree, jazz_melody_chord2,
			\ctranspose, 0 + jazz_melody_masterTranspose,
			\scale, jazz_melody_scale,
			\octave, jazz_melody_octave
		),
		Pbind(
			\instrument, \snakeblip,
			\dur, jazz_melody_dur,
			\degree, jazz_melody_chord5,
			\ctranspose, 0 + jazz_melody_masterTranspose,
			\scale, jazz_melody_scale,
			\octave, jazz_melody_octave
		),
		Pbind(
			\instrument, \snakeblip,
			\dur, jazz_melody_dur,
			\degree, jazz_melody_chord1,
			\ctranspose, 0 + jazz_melody_masterTranspose,
			\scale, jazz_melody_scale,
			\octave, jazz_melody_octave
		),
		Pbind(
			\instrument, \snakeblip,
			\dur, jazz_melody_dur,
			\degree, jazz_melody_chord1,
			\ctranspose, 0 + jazz_melody_masterTranspose,
			\scale, jazz_melody_scale,
			\octave, jazz_melody_octave
		)
	], inf).asStream;

	/* OSC message definitions */
	OSCdef(\snakeeat,
	{
        |msg|
		Post << msg;
		Synth('snakeeat', [freq: msg[1]])
	}, '/eat');

	OSCdef(\snakebluesbass,
	{
        |msg|
		Post << msg;
		/*Synth('snakebass', [freq: msg[1]]);*/
		blues_bass_seq.next(Event.new).play;
	}, '/walking_blues_bass');

	OSCdef(\snakejazzbass,
	{
        |msg|
		Post << msg;
		bass_dur = msg[2];
		/*Synth('snakebass', [freq: msg[1]]);*/
		jazz_bass_seq.next(Event.new).play;
	}, '/walking_jazz_bass');

	OSCdef(\snakejazzchords,
	{
        |msg|
		Post << msg;
		jazz_chords_dur = msg[2];
		/*Synth('snakebass', [freq: msg[1]]);*/
		jazz_chords_seq.next(Event.new).play;
	}, '/walking_jazz_chords');

	OSCdef(\snakejazzmelody,
	{
        |msg|
		Post << msg;
		/*Synth('snakebass', [freq: msg[1]]);*/
		jazz_melody_seq.next(Event.new).play;
	}, '/walking_jazz_melody');

	OSCdef(\snaketss,
	{
        |msg|
		Post << msg;
		Synth('tss', [freq: msg[1]]);
	}, '/tss');

	OSCdef(\snaketssT,
	{
        |msg|
		Post << msg;
		Synth('tssT', [freq: msg[1]]);
	}, '/tssT');

	OSCdef(\snakeexit,
	{
		0.exit;
	}, '/exit');

	/* We use this message to update the duration or level of synths, so that they don't saturate the speaker */
	OSCdef(\update_synthdefs,
	{
		SynthDef('snakebass', {	|freq, amp|
			var osc, env, output;

			osc = {LFTri.ar(freq)};

			env = EnvGen.kr(Env.perc(attackTime: 0.001, releaseTime: bass_dur, level: amp, curve: -2.0), doneAction: Done.freeSelf);
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

		SynthDef(\snakepad, { |freq, amp|
			var env = EnvGen.kr(Env.perc(jazz_chords_dur/2.0, jazz_chords_dur/2.0, amp, -1), doneAction: Done.freeSelf);
			var temp, sum;
			sum = 0;
			10.do{
				temp = LFTri.ar(
					freq * {Rand(0.99, 1.02)}!2,
					{Rand(0.0, 1.0)}!2,
					{ExpRand(0.005, 0.05)}!2,
					0.02!2
				);
				sum = sum + temp;
			};

			sum = sum * env;
			Out.ar(0, sum);
		}).send(s);
	}, '/update_synthdefs');
});