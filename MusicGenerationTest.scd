(
SynthDef(\blip, { |freq|
	var env = Env.perc(level: 0.1, releaseTime: 0.2).kr(doneAction: Done.freeSelf);
	var sig = Pulse.ar(freq: freq, width: 0.5) * env;
	Out.ar(0, [sig, sig]);
}).add;
)

(
Pdef(\melody,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5], inf),
		\degree, Pseq([0, 4, 6, 8, 4, 6, 7], inf),
		\scale, Scale.minor
	)
).play(TempoClock.default, quant: 4);
)