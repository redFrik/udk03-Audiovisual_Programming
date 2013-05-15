//100603 udk

s.boot


//how to use conditions inside synthdefs?
(
SynthDef(\condition, {
	var src= Select.ar(MouseX.kr(0, 2).round(1), [SinOsc.ar(400), Saw.ar(300), WhiteNoise.ar(0.5)]);
	Out.ar(MouseY.kr(0, 1).round(1), src*0.2);
}).add;
)

a= Synth(\condition)
a.free



//--

(
SynthDef(\grain, {|off= 0, amp= 0.1, rate= 1, pan= 0, atk= 0.01, rel= 0.1, gate= 1, bufnum|
	var env= EnvGen.ar(Env.asr(atk, amp, rel), gate, doneAction:2);
	var src= PlayBuf.ar(1, bufnum, rate, 1, off*BufFrames.ir(bufnum));
	Out.ar(0, Pan2.ar(src*env, pan));
}).add;
)

//load a mono soundfile
b= Buffer.read(s, "sounds/udksoundfiles/Dog Bark.aif");
b.plot

a= Synth(\grain, [\bufnum, b, \amp, 0.7, \off, 0.3])
a.free

a= Synth(\grain, [\bufnum, b, \amp, 0.7, \off, 0.5])
a.free



(		//frogs
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, 0.125,
	\bufnum, b,
	\amp, 0.7,
	\off, 0.2,
	\rate, 0.75
))
)
(		//my nice texture
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, 0.08,
	\bufnum, b,
	\amp, 0.5,
	\off, 0.1,
	\rate, -0.5
))
)




(		//my nice texture - variation using Prand patterns
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, Prand([0.08, 0.07, 0.09, 0.2], inf),
	\bufnum, b,
	\amp, Prand([0.3, 0.5, 0.6, 0.6, 0.5, 0.5], inf),
	\off, Prand([0.1, 0.11, 0.12, 0.13, 0.14], inf),
	\rate, Prand([-0.5, -0.5, -0.5, -0.5, -0.4, -0.3], inf),
	\pan, Prand([-0.4, -0.3, -0.2, 0.2, 0.3, 0.4], inf)
))
)


(		//my nice texture - variation using Pseq patterns
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, Pseq([Pseq([1, 0.4], 1), Pseq([0.08, 0.07, 0.2], 3),], inf),
	\bufnum, b,
	\amp, Pseq([0.3, 0.5, 0.6, 0.6, 0.5, 0.5], inf),
	\off, Pseq([0.1, 0.11, 0.12, 0.13, 0.14], inf),
	\rate, Pseq([-0.5, -0.5, -0.5, -0.5, -0.4, -0.3], inf),
	\pan, Pseq([-0.4, -0.3, -0.2, 0.2, 0.3, 0.4], inf)
))
)



//more granular synthesis like.  faster, shorter
(
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, 0.01,
	\atk, 0.001,
	\rel, 0.05,
	\legato, 2,
	\bufnum, b,
	\amp, 0.4,
	\off, Pwhite(0.3, 0.4, inf),//random values between 0.3 and 0.4
	\rate, Pwhite(0.9, 1.1, inf),
	\pan, 0
))
)


//more granular synthesis like
(
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, Pwhite(0.005, 0.01, inf),
	\legato, 25,	//number of overlaps
	\atk, 0.001,
	\rel, 0.05,
	\bufnum, b,
	\amp, Pwhite(0.3, 0.5, inf),
	\off, Pwhite(0.3, 0.4, inf),//random values between 0.3 and 0.4
	\rate, Pwhite(0.9, 1.1, inf),
	\pan, Pwhite(-1.0, 1.0, inf)
))
)



(
var win= Window("small gui", Rect(100, 100, 500, 300));
~offMin= 0;
~offMax= 0;
RangeSlider(win, Rect(10, 10, 300, 30)).action= {|view| ~offMin= view.lo; ~offMax= view.hi};
win.front;
)

(
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, Pwhite(0.005, 0.01, inf),
	\legato, 10,
	\atk, 0.001,
	\rel, 0.05,
	\bufnum, b,
	\amp, Pwhite(0.3, 0.5, inf),
	\off, Pfunc({~offMin.rrand(~offMax)}),
	\rate, Pwhite(0.9, 1.1, inf),
	\pan, Pwhite(-1.0, 1.0, inf)
))
)



//--
(
var win= Window("bigger gui", Rect(100, 100, 500, 300));
~offMin= 0;
~offMax= 1;
~legatoMin= 0.1;
~legatoMax= 5;
~durMin= 0.005;
~durMax= 0.2;
~rateMin= -2.0;
~rateMax= 2.0;
~panMin= -1.0;
~panMax= 1.0;
RangeSlider(win, Rect(10, 10, 300, 30)).action= {|view| ~offMin= view.lo; ~offMax= view.hi};
RangeSlider(win, Rect(10, 50, 300, 30)).action= {|view| ~legatoMin= view.lo.linlin(0, 1, 0.1, 5); ~legatoMax= view.hi.linlin(0, 1, 0.1, 5)};
RangeSlider(win, Rect(10, 90, 300, 30)).action= {|view| ~durMin= view.lo.linlin(0, 1, 0.005, 0.2); ~durMax= view.hi.linlin(0, 1, 0.005, 0.2)};
RangeSlider(win, Rect(10, 130, 300, 30)).action= {|view| ~rateMin= view.lo.linlin(0, 1, -2.0, 2.0); ~rateMax= view.hi.linlin(0, 1, -2.0, 2.0)};
RangeSlider(win, Rect(10, 170, 300, 30)).action= {|view| ~panMin= view.lo.linlin(0, 1, -1.0, 1.0); ~panMax= view.hi.linlin(0, 1, -1.0, 1.0)};

win.front;
)

(
Pdef(\buzzer).play;
Pdef(\buzzer, Pbind(
	\instrument, \grain,
	\dur, Pfunc({~durMin.rrand(~durMax)}),
	\legato, Pfunc({~legatoMin.rrand(~legatoMax)}),
	\atk, 0.01,
	\rel, 0.05,
	\bufnum, b,
	\amp, Pwhite(0.3, 0.5, inf),
	\off, Pfunc({~offMin.rrand(~offMax)}),
	\rate, Pfunc({~rateMin.rrand(~rateMax)}),
	\pan, Pfunc({~panMin.rrand(~panMax)})
))
)


Pdef(\buzzer).stop;
