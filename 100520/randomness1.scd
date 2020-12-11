//randomness  audiovisual programming 20100520


//--pick one out of many
[4, 1, 10, 100].choose
[100, 300].choose
[0.5, 0.3, -3.3].choose

//--pick one but some more often than others
[10, 20, 30, 40, 50].wchoose([0.5, 0.5, 0, 0, 0])		//weights should add up to 1.0.  here 10 or 20 with equal chance, never 30, 40, 50

[10, 20, 30, 40, 50].wchoose([0.5, 0.4, 0.05, 0.04, 0.01])	//50%, 40%, 5%, 4%, 1%

[10, 20, 30].wchoose([4, 3, 10].normalizeSum)	//.normalizeSum on your array of weights helps to calculate


//--rand

10.rand	//0 - 9 integer
10.0.rand	//0.0 - 9.999999999 float

10.xrand(5)		//random interger between 0-9 but exclude 5

10.rand2			//between -10 and 10 integer (note it includes -10 and 10 here)
100.0.rand2		//between -99.999 and 99.999 float

50.rrand(60)	//between 50-60 (including 50 and 60)

10.linrand		//pick more low values
10.exprand(100)	//exponential random distribution (never start from 0)
//0 will give you a division with 0 and that is not allowed
10.exprand(110)-10;	//this way you can get 0-100
0.0001.exprand(100);	//or this way very close to 0


//--arrays of random values and plotting
a= {1.0.rand}.dup(100)		//dup will evaluate and duplicate
a.plot
a= {1.0.linrand}.dup(100)	//more low values
a.plot


//--never repeat the same value
b= 0;	//will hold previous value
a= {b= 5.xrand(b)}.dup(100);
a.plot


//--if previous was low, randomize a high and if previous was high, randomize a low
b= 0;
a= {if(b>5, {b= 5.rand}, {b= 5.rrand(10)})}.dup(100);
a.plot

//--gaussian distribution (around 0 with a 'bell' curve)
{0.gauss(1)}.dup(100).plot(minval: -1, maxval: 1)
{0.gauss(0.1)}.dup(100).plot(minval: -1, maxval: 1)
{0.gauss(0.01)}.dup(100).plot(minval: -1, maxval: 1)


//--our own simplified gaussian distribution
[100.rand, 100.rand, 100.rand].sum/3
[100.rand, 100.rand, 100.rand, 100.rand, 100.rand].sum/5
//technique is to pick a few random values and then take the average of them.  will center around middle almost like a gauss distribution

a= {(100.rand+100.rand+100.rand)/3}.dup(100)
a.plot


//--random walk aka drunk walk with floats
b= 0;
a= {b= b+1.0.rand2}.dup(100)//-1 and 1
a.plot


//--random walk with integers
b= 0;
a= {b= b+1.rand2}.dup(100)//-1 and 1
a.plot
//can walk out of range - usually need some kind of limiter or clip

//--more random walk
b= 0;
a= {b= b+[0, -1, 1, -2, 2].wchoose([0, 0.4, 0.4, 0.1, 0.1])}.dup(100)
a.plot
//mostly go -1 and 1, sometimes jump -2 or 2, never still 0


//--falling random walk
b= 0;
a= {b= b+[0, -1, 1, -2, 2].wchoose([0.8, 0.06, 0.04, 0.06, 0.04])}.dup(100)
a.plot

//--rising random walk (just changed weights to give more of 1 and 2 and less of -1 and -2)
b= 0;
a= {b= b+[0, -1, 1, -2, 2].wchoose([0.8, 0.04, 0.06, 0.04, 0.06])}.dup(100)
a.plot


//--sound examples
s.boot;

a= {1.0.rand2}.dup(44100*2)//44100 samples / second.  here 2sec of white noise (loud!)
b= Buffer.loadCollection(s, a)
b.play

a= {1.0.linrand*[-1, 1].choose}.dup(44100)
b= Buffer.loadCollection(s, a)
b.play

a= {0.0.gauss(0.2)}.dup(44100)
b= Buffer.loadCollection(s, a)
b.play

b= 0;
a= {b= b+[0.1, -0.1].choose}.dup(44100)
b= Buffer.loadCollection(s, a)
b.play

//built in ugens
WhiteNoise
PinkNoise
BrownNoise
GreyNoise
ClipNoise
LFNoise0
LFNoise1
LFNoise2
etc.


b= 0;
a= {if(b<0.1, {b= 0.2.rand}, {if(b<0.5, {b= 0.6.rand}, {if(b<0.8, {b= 0.9}, {b= 1.0.rand})})})}.dup(100)
a.plot
a= {if(b<0.1, {b= 0.2.rand}, {if(b<0.5, {b= 0.6.rand}, {if(b<0.8, {b= 0.9}, {b= 1.0.rand})})})}.dup(44100)
b= Buffer.loadCollection(s, a)
b.play


//--our own crappy random generator function
b= 10;	//seed
a= {b= b+30/3*6-100%11}
a.value

(
thisThread.randSeed= 61;
10.rand;
)

//--normally you seed your random generator functions with the date or time
(
thisThread.randSeed= SystemClock.seconds;
10.rand;
)


//--random melodies
Pbind(\dur, 0.25, \degree, Pfunc({10.rand})).play	//white noise

b= 0;
Pbind(\dur, 0.25, \degree, Pfunc({b= b+1.rand2})).play	//drunk walk

b= 30;
Pbind(\dur, 0.25, \degree, Pfunc({b= b+[1, -1, 2, -2].wchoose([0.1, 0.4, 0.05, 0.3].normalizeSum)})).play	//slowly going downwards

b= 0;
(
Pbind(\dur, 0.25, \degree, Pfunc({
	if(b==0, {b= [0, 1].choose}, {
		if(b==1, {b= 2}, {
			if(b==2, {b= [2, 0].wchoose([0.9, 0.1]);
			});
		});
	});
})).play
)	//markov chain

//--compare how white noise melodies sounds again
(
Pbind(\dur, 0.25, \degree, Pfunc({
	0.rrand(2)
})).play
)


//--using a counter to add some other random distribution at certain times
b= 0;
i= 0;
(
Pbind(\dur, 0.25, \degree, Pfunc({
	i= i+1;	//counter will weights or type of randomness
	if(i==5, {i= 0; b= 8.rrand(10)}, {b= 5.rand});
});
).play
)

//--another example with a counter. every 3rd tone, reset counter and play tone 8, else random selection of tones 0, 1, 2
b= 0;
i= 0;
(
Pbind(\dur, 0.25, \degree, Pfunc({
	i= i+1;
	if(i==3, {i= 0; b= 8}, {b= 3.rand});
});
).play
)


//--change random distribution over time
//degrees start out between -20- 20
//then after 60 beats range between 0-5
(
i= 0;
Pbind(\dur, 0.25, \degree, Pfunc({
	i= i+1;
	i.postln;
	i.linlin(0, 60, -20, 0).rrand(i.linlin(0, 60, 20, 5));
})
).play
)

//--more
Randomness		//recommended helpfile
