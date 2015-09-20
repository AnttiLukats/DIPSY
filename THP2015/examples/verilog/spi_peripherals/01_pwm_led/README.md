# SPI slave with PWM output on the LED driver

## Purpose
Demonstrates the implementation of an SPI slave
- an SPI slave in mode 3 is insstantiated
- receives PWM values
- a timer generates PWM for the internal LED driver IP (SB_RGBA_DRV)

## Sketch
The arduino sketch configures the dipsy one second after reset. It then sends PWM values over SPI.

## Circuit
RGB0 -> LED Cathode
LED Anode -> Vcc (no current limiting resistor required!)