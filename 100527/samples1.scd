//100527

//https://www.findsound.com
//download some aiff or wav files in format: 16bit, mono, 44100
//search for snares, kick drums, hihats, cats, cymbals etc
//make a folder and put the files in /Applications/SuperCollider/sounds/



/*
http://fastlanestudio.com/students/sfsu/su07/flash/Flash1CD/Sound%20Effects/Dog%20Bark.aif
http://chronos.ece.miami.edu/~dasp/samples/openhihat.wav
http://homepage.mac.com/kaseo/download/tom/tom-closedhihat-24.aiff
http://www.drumaddikt.com/breaks/addictspsalm1.wav
http://bigsamples.free.fr/d_kit/snare/909_snr3.wav
http://www.robbasile.com/Samples/Making%20Waves%20Samples/Other%20Samples/Drumstyles/techno/Dis_kick.wav
http://soundcavern.free.fr/snare/sn909v2.wav
http://bigsamples.free.fr/d_kit/snare/snare02.wav
*/


s.boot

//
(
SynthDef(\oneshot, {|buf, off= 0, rate= 1, pan= 0, amp= 0.1|
	var snd;
	snd= PlayBuf.ar(1, buf, rate, 1, off*BufFrames.ir(buf), 0, 2);
	Out.ar(0, Pan2.ar(snd*amp, pan));
}).add;
)

b= Buffer.read(s, "sounds/udksoundfiles/Dog Bark.aif");
//check post window to see if buffer loaded soundfile correctly

b.plot		//save first!  might crash on some machines


a= Buffer.read(s, "sounds/udksoundfiles/909_snr3.wav");
b= Buffer.read(s, "sounds/udksoundfiles/Dog Bark.aif");
c= Buffer.read(s, "sounds/udksoundfiles/Dis_kick.wav");
d= Buffer.read(s, "sounds/udksoundfiles/openhihat.wav");
e= Buffer.read(s, "sounds/udksoundfiles/snare02.wav");
f= Buffer.read(s, "sounds/udksoundfiles/sn909v2.wav");
g= Buffer.read(s, "sounds/udksoundfiles/tom-closedhihat-24.aiff");
l= Buffer.read(s, "sounds/udksoundfiles/addictspsalm1.wav");//drumloop

j= Buffer.readChannel(s, "sounds/SinedPink.aiff", channels:[0]);//this will read a stereo soundfile and create a mono buffer from left channel


//test some sounds
Synth(\oneshot, [\buf, a]);
Synth(\oneshot, [\buf, b]);
Synth(\oneshot, [\buf, c]);

//give arguments to the synth
Synth(\oneshot, [\buf, b, \rate, 0.7]);
Synth(\oneshot, [\buf, b, \rate, 2, \off, 0.5]);
Synth(\oneshot, [\buf, b, \rate, 2, \off, 0.6, \amp, 0.4, \pan, 1]);
Synth(\oneshot, [\buf, c, \rate, 2, \off, 0.65, \amp, 0.4, \pan, -1]);


//sequencer code
Pdef(\snare).play(quant:2);

(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, a,
	\dur, 0.5,
	\rate, 1
));
)

(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, a,
	\dur, 0.75,
	\rate, 2
));
)

(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, a,
	\dur, 0.25,
	\rate, 0.5,
	\off, 0.1
));
)

Pdef(\snare).stop;




Pdef(\snare).play(quant:2);

//sequencing 2 buffers
(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, Pseq([a, c], inf),
	\dur, 0.5,
	\rate, 1
));
)

//sequencing 2 buffers with 3 rates
(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, Pseq([a, c], inf),
	\dur, 0.5,
	\rate, Pseq([1, 1.2, 0.5], inf)
));
)

//sequencing 2 buffers with 3 rates with 4 durations
(
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, Pseq([a, c], inf),
	\dur, Pseq([0.125, 0.25, 0.5, 1], inf),
	\rate, Pseq([1, 1.2, 0.5], inf)
));
)

Pdef(\snare).stop;



//make a complete 4 tracks music section.  section 1:
(
Pdef(\snare).play(quant:1);
Pdef(\bass).play(quant:1);
Pdef(\dog).play(quant:1);
Pdef(\hat).play(quant:1);

//snare......
Pdef(\snare, Pbind(
	\instrument, \oneshot,
	\buf, Pseq([a, c], inf),
	\dur, 0.5,
	\rate, Pseq([1, 1.2, 0.5], inf)
));
//bassdrum....
Pdef(\bass, Pbind(
	\instrument, \oneshot,
	\buf, c,
	\dur, 0.5,
	\rate, 1,
	\amp, 0.3
));
//dog barks....
Pdef(\dog, Pbind(
	\instrument, \oneshot,
	\buf, b,
	\dur, 4,
	\rate, 1.2,
	\amp, 0.5,
	\pan, Pseq([-1, 1], inf)
));
//hihat....
Pdef(\hat, Pbind(
	\instrument, \oneshot,
	\buf, Prand([g, d, f], inf),
	\dur, 0.125,
	\rate, Prand([1, 1.1, 0.9], inf),
	\amp, 0.6
));
)


//section:2
(
//snare......
Pdef(\snare, Pbind(\amp, 0));//mute snare track
//bassdrum....
Pdef(\bass, Pbind(
	\instrument, \oneshot,
	\buf, c,
	\dur, 0.5,
	\rate, 1,
	\amp, 0.3
));
//dog barks....
Pdef(\dog, Pbind(\amp, 0));
//hihat....
Pdef(\hat, Pbind(
	\instrument, \oneshot,
	\buf, g,
	\dur, 0.125,
	\rate, Prand([2, 2, 2, 2, 1.7], inf),
	\amp, 0.6
));
)



//stop playing all tracks
Pdef(\dog).stop;
Pdef(\bass).stop;
Pdef(\snare).stop;
Pdef(\hat).stop;



Buffer.freeAll;		//deallocate memory / remove buffers



//additional notes:

//get path from this document. useful for loading buffer from the same directory as the code
Document.current.path.dirname;
a= Buffer.read(s, Document.current.path.dirname++"/myfile.aiff");

//change global tempo for Pdefs above
TempoClock.default.tempo= 1.5	//global tempo control






