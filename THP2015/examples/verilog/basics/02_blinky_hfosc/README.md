# Blinky with open drain output driving an LED

## Purpose
Demonstrates the use of
- open drain IP (SB_IO_OD)
- internal high frequency oscillator (SB_HFOSC)

## Sketch
The arduino sketch configures the dipsy one second after reset.

## Circuit
RGB0 -> LED Cathode
LED Anode -> 330 Ohm resistor -> Vcc