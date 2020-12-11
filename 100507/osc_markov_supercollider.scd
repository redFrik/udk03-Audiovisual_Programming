//ip

~fredrik= NetAddr("192.168.0.135", 57120);
~joon= NetAddr("192.168.0.134", 57120);
~olga= NetAddr("192.168.0.132", 57120);
~naomi= NetAddr("192.168.0.119", 57120);
~tiago= NetAddr("192.168.0.193", 57120);
~chrisi= NetAddr("192.168.0.102", 57120);
~bernhard= NetAddr("192.168.0.118", 57120);
~alexa= NetAddr("192.168.0.186", 57120);
~florian= NetAddr("192.168.0.136", 57120);
~karin= NetAddr("192.168.0.133", 57120);
~andre= NetAddr("192.168.0.184", 57120);

//test sending - will not work yet because no one has code to receive the message
~olga.sendMsg("hello", 1, 2, 3);
~tiago.sendMsg("hello", 1, 2, 3);
~alexa.sendMsg("hello", 400)


//receiving osc data...
(
OSCresponder(nil, "hello", {|time, resp, msg|
	[time, resp, msg].postln;//just post the arguments
}).add;
)
~fredrik.sendMsg("hello", 1, 2, 3, "myname");
~naomi.sendMsg("hello", 10)


//--a little synth
s.boot;
(
SynthDef(\ping, {|freq= 600, dur= 0.2|
	var env= EnvGen.kr(Env.perc(0.01, dur), doneAction:2);
	var src= SinOsc.ar(freq, 0, env);
	Out.ar(0, src);
}).send(s);
)

Synth(\ping, [\freq, 800, \dur, 0.5])//test the sound


//osc responder with sound...
(
OSCresponder(nil, "play", {|time, resp, msg|
	Synth(\ping, [\freq, 1000]);
	msg.postln;
}).add;
)
~fredrik.sendMsg("play")
~joon.sendMsg("play");
~florian.sendMsg("play");
~tiago.sendMsg("play", "from fredrik");
~chrisi.sendMsg("play");
~bernhard.sendMsg("play");
~olga.sendMsg("play");
~naomi.sendMsg("play");
~karin.sendMsg("play");
~alexa.sendMsg("play");


//markov chains...

//example to create a table of rules:
joon:  80% sending back to himself, 15% sending to fredrik, 5% sending to olga
olga: 50% sending back to herself, 25% fredrik, 25%joon
fredrik: 90% sending back to himself, 7.5% olga, 2.5% joon

      joon  fred  olga

joon  0.80  0.15  0.05

olga  0.25  0.25  0.50

fred  0.025 0.90 0.075

//weighted probability table


//a simple 1st order markov chain...
(
OSCresponder(nil, "markov", {|time, resp, msg|
	var rand= 1.0.rand;
	msg.postln;
	if(rand<0.6, {	//send 60% to myself
		{~fredrik.sendMsg("markov", "from fred")}.defer(0.125);
	}, {
		if(rand<0.8, {	//send 20% to andre
			{~andre.postln.sendMsg("markov", "from fred")}.defer(0.75);
		}, {							//send 20% to olga
			{~olga.postln.sendMsg("markov", "from fred")}.defer(0.5);
		});
	});
	Synth(\ping, [\freq, 1000, \dur, 0.2]);
}).add;
)
~fredrik.sendMsg("markov");

/*
read about markov chains and hidden markov models on wikipedia or
Algorithmic composition - Gerhard Nierhaus, pages: 68-69
book is in room111
*/

https://en.wikipedia.org/wiki/File:MarkovChain1.png
https://en.wikipedia.org/wiki/Markov_chain

//a 2nd order markov chain have a memory of the 2 last states
//higher order markov chains are also possible but complexity grows fast - hard to know how/if the system is working.

Pfsm - built into supercollider
https://en.wikipedia.org/wiki/Finite-state_machine

//in maxmsp and puredata see the [prob] object helpfile

//Hidden Markov Models (HMM) can be used for analysing systems
https://en.wikipedia.org/wiki/Hidden_Markov_model


