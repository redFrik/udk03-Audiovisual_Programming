1.0.rand			//0 to 1
1.0.rand2			//-1 to 1
1.0.rrand(2.0)	//1 and 2
1.0.linlin(0, 10, 400, 500)
0.25.coin			//25% chance of true


//--
s.boot

(
SynthDef(\noise, {|amp= 0.1, pan= 0, sustain= 0.2, release= 0.1|
	var env= EnvGen.ar(Env.linen(0, sustain, release), doneAction:2);
	var snd= ClipNoise.ar(amp)+Impulse.ar(0)+BrownNoise.ar(0.3);
	Out.ar(0, Pan2.ar(snd*env, pan));
}).add;
)
Synth(\noise, [\release, 0])

(
SynthDef(\buzz, {|amp= 0.1, pan= 0, sustain= 0.2, release= 0.1, freq= 100|
	var env= EnvGen.ar(Env.linen(0, sustain, release), doneAction:2);
	var snd= BPF.ar(LFSaw.ar(freq+ClipNoise.ar(40), 0, amp), 500, 1);
	Out.ar(0, Pan2.ar(snd*env, pan));
}).add;
)
Synth(\buzz, [\release, 0])


//--sequencing
p= Pbind(\instrument, \noise, \sustain, 0.02, \dur, 0.08, \release, 0).play
p.stop
p= Pbind(\instrument, \buzz, \sustain, 0.1, \dur, 0.25, \freq, 300).play
p.stop

p= Pbind(\instrument, Pfunc({[\buzz, \noise].choose}), \dur, 0.5.rrand(1.5)).play
p.stop

p= Pbind(\instrument, Pfunc({[\buzz, \noise].choose}), \dur, Pfunc({0.5.rrand(1.5)})).play
p.stop

//--ikeda sound-a-like
p= Pbind(\dur, 0.08, \instrument, \noise, \sustain, 0.03, \release, 0, \pan, Pfunc({1.0.rand2}).trace).play
p.stop

p= Pbind(\dur, 0.08, \instrument, \noise, \sustain, Pfunc({0.03+0.01.rand2}), \release, 0, \pan, Pfunc({1.0.rand2}).trace).play
p.stop

q= Pbind(\dur, 0.08, \instrument, \buzz, \sustain, 0.07, \release, 0, \pan, 0, \freq, 120, \amp, Pfunc({[0.7, 0, 0, 0].choose})).play
q.stop

//--wait 15 times until set amp 0.7
i= 0;
q= Pbind(\dur, 0.08, \instrument, \buzz, \sustain, 0.07, \release, 0, \pan, 0, \freq, 120, \amp, Pfunc({i= i+1; if(i>15, {0.7}, {0})})).play
q.stop

//--play now and then, wait at least 15 times inbetween, play for at least 5 times
(
i= 0;		//counter
a= 0;		//current amp (state)
q= Pbind(\dur, 0.08, \instrument, \buzz, \sustain, 0.07, \release, 0, \pan, 0, \freq, 120, \amp, Pfunc({
	i= i+1;
	if(a==0, {			//if not playing currently
		"silence".postln;
		if(i>15, {		//if waited for 15 times
			if(0.2.coin, {a= 0.7; i= 0});//here small chance of start playing
		});
	}, {					//if we are playing
		"playing".postln;
		if(i>5, {
			if(0.4.coin, {a= 0; i= 0});
		});
	});
	a;
})).play;
)
q.stop;



//--all together
(
i= 0;
a= 0;
p= Pbind(\dur, 0.08, \instrument, \noise, \sustain, Pfunc({0.03+0.01.rand2}), \release, 0, \pan, Pfunc({1.0.rand2})).play;
q= Pbind(\dur, 0.08, \instrument, \buzz, \sustain, 0.07, \release, 0, \pan, 0, \freq, Pfunc({120+5.rand2}), \amp, Pfunc({
	i= i+1;
	if(a==0, {			//if not playing currently
		if(i>15, {		//if waited for 15 times
			if(0.2.coin, {a= 0.7; i= 0});//here small chance of start playing
		});
	}, {					//if we are playing
		if(i>5, {
			if(0.4.coin, {a= 0; i= 0});
		});
	});
	a;
})).play;
)
