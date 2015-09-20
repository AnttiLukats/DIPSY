# Blinky with constant current driver IP driving an LED

## Purpose
Demonstrates the use of
- constant current driver IP (SB_RGBA_DRV)
- internal low frequency oscillator (SB_LFOSC)

Note that dividing down the low frequency oscillator needs a smaller counter and is consequently a bit more efficient in terms of flip flop usage.

## Sketch
The arduino sketch configures the dipsy one second after reset.

## Circuit
RGB0 -> LED Cathode
LED Anode -> Vcc (no current limiting resistor required!)