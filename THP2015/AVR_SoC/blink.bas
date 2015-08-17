// DIPSY test program, Basic is compile to AVR object and executed on
// Lattice  ICEUltra UL1K FPGA
// ICE Arduino board is used as "DIPSY Programmer..."
// AVR Basic compiler sources are open source also

#device 60

#include pindef.inc

var T1: byte @R20;
var T2: byte @R21;

	goto Main

delay:
	T1 = 10			
	repeat
		repeat
			until not --T2
		until not --T1
	return


Main:
	repeat
		RLED = 1; gosub delay; RLED = 0; gosub delay
		GLED = 1; gosub delay; GLED = 0; gosub delay
		BLED = 1; gosub delay; BLED = 0; gosub delay

	until false;
		
