//100528

//for these examples to work download this file and put in /Applications/SuperCollider/sounds/udksoundfiles/
//or use your own/any mono drumloop soundfile

//http://www.drumaddikt.com/breaks/addictspsalm1.wav


//sort of break beat cutting up/sliceing soundfile thing

s.boot

(
SynthDef(\segment, {|buf, off= 0, amp= 0.1, pan= 0, gate= 1|
	var env= EnvGen.ar(Env.asr(0.005, amp, 0.05), gate, doneAction:2);
	var snd= PlayBuf.ar(1, buf, 1, 1, off*BufFrames.ir(buf), 1, 0);
	Out.ar(0, Pan2.ar(snd*env, pan));
}).add;
)

//this synthdef lets us play a soundfile, loop and determine when to stop by setting gate to 0.  we can also control amplitude and panning position, and which buffer to play with the buf argument

b= Buffer.read(s, "sounds/udksoundfiles/addictspsalm1.wav");

//create a synth and play the buffer from position 87%
a= Synth(\segment, [\buf, b, \off, 0.87])
a.set(\gate, 0)





Pdef(\myseq).play(quant:1);
(
Pdef(\myseq, Pbind(
	\instrument, \segment,	//which instrument/synth to use
	\buf, b,	//which buffer to use
	\off, 0,//offset positions in a sequence
	\dur, 0.5,	//pdef duration
	\amp, 0.4	//amplitude
))
)

(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0.2, 0.4, 0.7], inf),//offset positions in a sequence
	\dur, 0.5,
	\amp, 0.4
))
)


//first figure out the bpm (tempo) of the drumloop
//count beats over 1 minute (hard way)
//use kind of tap tempo utility


//set supercollider tempo to the same as the drumloop
TempoClock.default.tempo= 106/60;

Pdef(\myseq).play(quant:1)
(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0, 2/8, 4/8, 6/8], inf),//will play beats 0, 2, 4, 6
	\dur, 1,
	\legato, 1,
	\amp, 0.4
))
)


(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0, 1/8, 2/8, 3/8, 4/8, 5/8, 6/8, 7/8], inf),//this will play the original drumloop in correct order
	\dur, 1,
	\legato, 1,
	\amp, 0.4
))
)


//reshuffeling the beats
(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0, 1/8, 5/8, 3/8, 4/8, 2/8, 6/8, 1/8], inf),
	\dur, 1,
	\legato, 1,
	\amp, 0.4
))
)


(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq({8.rand/8}.dup(8), inf),//randomize order every time this code is evaluated
	\dur, 1,
	\legato, 1,
	\amp, 0.4
))
)


(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0, 0, 0, 3]/8, inf),//experiment with segments number 0-8
	\dur, 1,
	\legato, 0.4,	//shorter
	\amp, 0.4
))
)


(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0,   2,   4,   3,    0,   2,   4,   5,     5,     5]/8, inf),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5,  0.5, 0.5, 0.5, 0.5/3, 0.5/3, 0.5/3], inf),	//with fill
	\legato, 0.5,
	\amp, 0.4
))
)



Pdef(\myseq).play
(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([0,   2,   4,   3,    0,   2,   4,   5,     5,     5,     5]/8, inf),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5,  0.5, 0.5, 0.5, 0.5/4, 0.5/4, 0.5/4, 0.5/4], inf),
	\legato, 0.75,
	\amp, 0.4
))
)


Pdef(\myseq).play
(
Pdef(\myseq, Pbind(
	\instrument, \segment,
	\buf, b,
	\off, Pseq([Pseq([0, 2, 4, 3], 3), Pseq([5], 8)], inf)/8,
	\dur, Pseq([Pseq([0.5], 12), Pseq([0.5/16], 16)], inf),
	\legato, 0.75,
	\pan, Pseq([Pseq([0], 12), Pseq([-1, 1], 8)], inf),
	\amp, 0.4
))
)


//try loading another buffer - non drumloop
b= Buffer.read(s, "sounds/a11wlk01-44_1.aiff");
b= Buffer.read(s, "sounds/baba.aiff");	//something just recorder in audacity
b= Buffer.read(s, "sounds/udksoundfiles/addictspsalm1.wav");


Pdef(\myseq).stop


//advanced:
//it is also possible to cut up spoken word and shuffle words and phrases around.  then you can not segment the soundfile mathematically, but use an array to store the positions of each phrase and then index into that from the pbind
