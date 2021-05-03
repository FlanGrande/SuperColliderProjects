//monitor all incoming OSC Messages
OSCFunc.trace(true, true);
//set the relevant IP and port - both arbitrary, but these will be sent to SuperCollider internally (assuming that NetAddr.langPort == 57120)
b = NetAddr.new("127.0.0.1", 57120);

/*o = OSCdef(\test, {|msg, time, addr, recvPort| \hola.postln}, '/hello', b);

//send the above message, and it should be shown in the post window
b.sendMsg("/hello", 1, 32.32, 'message')
// If this doesn't work, evaluate:
NetAddr.langPort
// Then change the port of NetAddr.new accordingly



{ SinOsc.ar(440, 0, 0.2) }.play;

o.free
b.disconnect

s.boot


AbstractResponderFunc.allEnabled
OSCdef(\snakemove).clear; // remove all functions
OSCdef(\snakeeat).clear; // remove all functions
OSCdef(\test).disable;*/


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
)

Synth('snakemove', [freq: 440]);