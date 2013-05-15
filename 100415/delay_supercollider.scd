//first click 'boot' in localhost server window
//then select everything between () and press enter (or fn+return)
(
SynthDef(\delay, {
	var input= SoundIn.ar(0);
	var one= LPF.ar(DelayN.ar(input, 0.1, 0.1, 0.9), 9000);
	var two= LPF.ar(DelayN.ar(input, 0.22, 0.22, 0.6), 7000);
	var three= LPF.ar(DelayN.ar(input, 0.36, 0.36, 0.5), 4000);
	var four= LPF.ar(DelayN.ar(input, 0.7, 0.7, 0.4), 2000);
	var five= LPF.ar(DelayN.ar(input, 1.0, 1.0, 0.2), 1000);
	Out.ar(0, one+three+five);
	Out.ar(1, two+four);
}).send(s);
)

a= Synth(\delay)
a.free

