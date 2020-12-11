IP numbers.  each computer/device gets one from the router.  usually something like 192.168.0.x.
port 0-65535 (recommended to use port numbers >1000, some of the lower ones are reserverd for things like mail, http, ftp etc)

fredrik= 192.168.0.135		600
rita= 192.168.0.192			700
chrisi= 192.168.0.102		800
karin= 192.168.0.133		900
florian= 192.168.0.136		1000
marek= 192.168.0.137		1100
tiago= 192.168.0.193		1200
joon= 192.168.0.134			1300
andre= 192.168.0.184		1400
timur= 192.168.0.197		1500
alexa= 192.168.0.130 		1600

//--set up a sending osc object
n= NetAddr("192.168.0.136", 6789);
n.sendMsg("freq", 1111);
n.sendMsg("amp", 0.2);


UDP= fast but not safe (especially over wlan).  no check if package received or not.  good for streaming data like sound
TCP/IP= safe but can hog the network.  it will keep sending packages until it receives an 'ok, i got it' from the destination.  recommended only for important control data that must not get lost.
OSC= OpenSound Control (protocol) - normally uses UDP


//storing a few destinations in ~ variables
~fredrik= NetAddr("192.168.0.135", 6789);
~joon= NetAddr("192.168.0.134", 6789);
~tiago= NetAddr("192.168.0.193", 6789);

~fredrik.sendMsg("freq", 1000);
~tiago.sendMsg("freq", 666);
~joon.sendMsg("freq", 666);



//--receiving osc in supercollider...
s.boot;
(
SynthDef(\ping, {|freq= 800| Out.ar(0, Line.kr(0.5, 0, 0.2, doneAction:2)*SinOsc.ar(freq))}).send(s);
)

(
OSCresponder(nil, "freq", {|time, respo, msg|
	msg.postln;
	Synth(\ping, [\freq, msg[1]]);
}).add;
)
~chrisi= NetAddr("192.168.0.102", 57120);
~chrisi.sendMsg("freq", 10101)
~localhost= NetAddr("127.0.0.1", 57120);
~localhost.sendMsg("freq", 9000)
