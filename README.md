# Heapsort in AVR Assembly
This is an implementation of the heapsort algorithm in AVR assembly.  This algorithm lends itself to a relatively simple assembly implementation because it is both iterative and in place, requiring no recursive calls or extra space to complete.

## Requirements
You will need some sort of AVR simulator and assembler.  Microchip, a manufacturer of AVR instruction set microprocessors, has released the Atmel Studio simulator for free on their website.

[Download Atmel Studio 7](https://www.microchip.com/mplab/avr-support/atmel-studio-7)

This program is Windows only, and is quite large.  You easily can find other AVR simulators and assemblers that are smaller or will work on other platforms on the internet through a quick Google search.

## Limitations
Since the registers on the Atmega328P are 8 bit, you can only work with numbers between -127 and 127, accounting for the 8th sign bit.  This also means you can sort at most 127 numbers at a time.