# Simple In -> Out Example

## Purpose
Demonstrates the use of iCE40UL IO primitives. Simply routes one input to another output pin, no logic involved. The whole point is that in order to use the LED driver pins as user I/O, instances of SB\_IO\_OD must be used.

## Sketch
The arduino sketch configures the  dipsy and then outputs a square wave on pin 14.

## Circuit
Arduino pin 14 -> Dipsy B4 (RGB0)
Dipsy A4 (RGB1) -> LED cathode -> 330 Ohm -> 3.3V

The LED should blink.