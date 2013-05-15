//-100625

//install SCPyduino quark
//install FTDIdrivers if needed http://www.ftdichip.com/Drivers/VCP.htm
//upload standard firmata from Arduino.app from examples menu

SerialPort.listDevices
f= SCPyduino("/dev/tty.usbserial-A1001NeZ", 57600);
//wait 3 seconds
f.firmataVersion	//should return 2.1 or something like that


//--test flash led
(
f.digital[13].mode= 1;		//set pin13 as digital output
Routine({
	10.do{
		0.1.wait;
		f.digital[13].write(1);		//pin high
		0.1.wait;
		f.digital[13].write(0);		//pin low
	};
}).play;
)


//--knob0 to control frequency
(
SynthDef(\bitbang2, {|freq= 400|
	var snd= LFPulse.ar(freq);
	Out.ar(0, snd*0.5);
}).add;
)

(
Routine({
	var syn= Synth(\bitbang2);
	inf.do{
		f.iterate;
		syn.set(\freq, f.analog[0].value.linexp(0, 1, 200, 2000));
	};
}).play;
)
//stop with cmd+.


f.close;
