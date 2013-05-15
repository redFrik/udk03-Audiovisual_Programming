//100604

0:00			1.0.rrand(1.0)

0:30			-1.0.rrand(1.0)

0:60			-1.0.rrand(-1.0)


//--
s.boot

(
SynthDef(\grain2, {|pan= 0, amp= 0.1, rate= 1, atk= 0.01, rel= 0.1, gate= 1, curve= -4, bufnum, off= 0|
	var env= EnvGen.ar(Env.asr(atk, amp, rel, curve), gate, doneAction:2);
	var src= PlayBuf.ar(1, bufnum, rate, 1, off*BufFrames.ir(bufnum));
	Out.ar(0, Pan2.ar(src*env, pan));
}).add;
)

b= Buffer.read(s, "sounds/udksoundfiles/Dog Bark.aif");
c= Buffer.read(s, "sounds/a11wlk01-44_1.aiff");

(
Pdef(\seq1).play;
Pdef(\seq1, Pbind(
	\instrument, \grain2,
	\dur, 0.1,
	\legato, 2.5,
	\bufnum, b,
	\pan, Pfunc({1.0.rrand(-1.0)})
))
)


//--1st method/technique - building ramps / lfo with patterns
(
Pdef(\seq1).play;
Pdef(\seq1, Pbind(
	\instrument, \grain2,
	\dur, 0.1,
	\legato, 2.5,
	\bufnum, b,
	\pan, Pseries(1.0, -2/300, 30/0.1).trace
))
)

//pan over 60sec.
(
Pdef(\seq1).play;
Pdef(\seq1, Pbind(
	\instrument, \grain2,
	\dur, 0.1,
	\legato, 0.9,
	\bufnum, b,
	\pan, Pwhite(
				Pseq([Pseries(1.0, -2/300, 30/0.1), Pn(-1.0, 300)], inf),
				Pseq([Pn(1.0, 300), Pseries(1.0, -2/300, 30/0.1)], inf),
		inf).trace
))
)


//--2nd method - use external control / variables
(
~pan= 0;		//variable that we can access below
Pdef(\seq1).play;
Pdef(\seq1, Pbind(
	\instrument, \grain2,
	\dur, 0.1,
	\legato, 0.75,
	\bufnum, b,
	\pan, Pfunc({~pan})
))
)

(		//does random panning over 10 seconds, once per second
Routine({
	10.do{
		~pan= -1.0.rrand(1.0).postln;
		1.wait;		//wait for 1sec
	};
}).play;
)

(
Routine({
	300.do{|i|
		//~pan= i/300*2-1;
		~pan= i.linlin(0, 299, 1.0, -1.0).rrand(1.0);
		~pan.postln;
		0.1.wait;		//wait for 0.1sec
	};
	"halfway".postln;
	300.do{|i|
		~pan= -1.0.rrand(i.linlin(0, 299, 1.0, -1.0));
		~pan.postln;
		0.1.wait;		//wait for 0.1sec
	};
}).play;
)



//--self promotion: UGenPatterns quark - need to install separately
(
Pdef(\seq1).play;
Pdef(\seq1, Pbind(
	\instrument, \grain2,
	\dur, 0.1,
	\legato, 0.75,
	\bufnum, b,
	\pan, PSinOsc(300, 0, 1).trace
))
)

PLine
PSinOsc

Quarks.checkoutAll
Quarks.gui



//--more fun examples
(
Pdef(\seq2).play;
Pdef(\seq2, Pbind(
	\instrument, \grain2,
	\dur, Pwhite(0.05, 0.08, inf),
	\legato, Pwhite(2.0, 3.0, inf),
	\bufnum, Pseq([b, b, b, b, c, c], inf),
	\off, Pwhite(0.0, 0.4, inf),
	\pan, Pn(Pseries(-1.0, 0.01, 200), inf).trace,
	\rate, Pseq([Pseries(0.5, 0.01, 100), Pseries(1.5, -0.01, 50)], inf),
	\amp, Pwhite(0.4, 0.6, inf)
))
)


(
Pdef(\seq2).play;
Pdef(\seq2, Pbind(
	\instrument, \grain2,
	\dur, 0.08,
	\legato, 0.5,
	\bufnum, b,
	\amp, 0.5,
	\off, 0.2,
	\atk, Pseq([Pn(0, 100), Pn(0.01, 100), Pn(0.05, 100)], inf),
	\rel, Pseq([Pn(0, 100), Pn(0.01, 100), Pn(0.05, 100)], inf),
	\curve, 4
))
)


//--time streching
(
Pdef(\seq2).play;
Pdef(\seq2, Pbind(
	\instrument, \grain2,
	\dur, 0.08,
	\legato, 3,
	\bufnum, b,
	\amp, 0.5,
	\off, Pn(Pseries(0, 0.03, 1/0.03), inf).trace
))
)


//--time compression
(
Pdef(\seq2).play;
Pdef(\seq2, Pbind(
	\instrument, \grain2,
	\dur, 0.08,
	\legato, 3,
	\bufnum, b,
	\amp, 0.5,
	\off, Pn(Pseries(0, 0.1, 1/0.1), inf).trace
))
)

//--time strech with every 2nd grain backwards
(
Pdef(\seq2).play;
Pdef(\seq2, Pbind(
	\instrument, \grain2,
	\dur, 0.08,
	\legato, 3,
	\bufnum, b,
	\amp, 0.5,
	\rate, Pseq([1, -1], inf),
	\off, Pn(Pseries(0, 0.02, 1/0.02), inf).trace
))
)


Pdef(\seq2).stop
b.free
c.free
