s.boot;

s.waitForBoot({
	(
	OSCdef(\snakemove,
		{
			|msg|
			Post << msg;
			Synth('snakemove', [freq: msg[1]])
	}, '/move');

	OSCdef(\snakeeat,
		{
	        |msg|
			Post << msg;
			Synth('snakeeat', [freq: msg[1]])
	}, '/eat');

	OSCdef(\snaketest,
		{
	        |msg|
			Post << msg;
			Synth('snaketest', [freq: msg[1]]);
			if([false, true].choose, {Synth('\drums', [\freq: ~bass]);}, {Synth('\drums', [\freq: ~snare]);});
	}, '/test');
	);

	(
	SynthDef('snakemove', {
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

	SynthDef('snakeeat', {
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

	SynthDef('openhat', {

	    var hatosc, hatenv, hatnoise, hatoutput;

	    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

	    hatosc = {HPF.ar(hatnoise,2000)};
	    hatenv = {Line.ar(1, 0, 0.3)};

	    hatoutput = (hatosc * hatenv);

	    Out.ar(0,
	    Pan2.ar(hatoutput, 0)
	    )

	}).send(s);

	SynthDef('closedhat', {

	    var hatosc, hatenv, hatnoise, hatoutput;

	    hatnoise = {LPF.ar(WhiteNoise.ar(1.0),1600, 1.0)};

	    hatosc = {HPF.ar(hatnoise,4000)};
	    hatenv = {Line.ar(1.0, 0, 0.02)};

	    hatoutput = (hatosc * hatenv);

	    Out.ar(0,
	    Pan2.ar(hatoutput, 0)
	    )

	}).send(s);
	);

	(
	SynthDef('snaketest', {
		var osc, env, output;
		var randomnumber = {Rand.new(lo: 1.0, hi: 6.0)};

		t = Tuning.et12;
		osc = SinOsc.ar({Select.kr(randomnumber, Scale.chromatic(t).cents)}, 1.0);
		env = {Line.ar(1.0, 0, 0.1, doneAction: 2)};

		output = (osc * env);

	    Out.ar(0,
	    Pan2.ar(output, 0)
	    )

	}).send(s);
	);

	(
	SynthDef(\drums, { |freq|
		var env = Env.perc(level: 0.1, releaseTime: 0.2).kr(doneAction: Done.freeSelf);
		var sig = WhiteNoise.ar * env;
		var trigger = Impulse.ar(freq);
		sig = Latch.ar(sig, trigger);
		Out.ar(0, [sig, sig]);
	}).send(s);

	~bass = 500; ~snare = 10000;
	);

});