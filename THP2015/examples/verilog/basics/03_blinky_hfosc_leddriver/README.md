# Blinky with constant current driver IP driving an LED

## Purpose
Demonstrates the use of
- constant current driver IP (SB_RGBA_DRV)
- internal high frequency oscillator (SB_HFOSC)

## Sketch
The arduino sketch configures the dipsy one second after reset.

## Circuit
RGB0 -> LED Cathode
LED Anode -> Vcc (no current limiting resistor required!)