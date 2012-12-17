Flickering LEDs driven by PIC12F580 microcontroller

To build: run make in the top level directory like this:
$ make

It needs gputils to compile. After a successfull build you
will find it in the device directory under the name
PICFlickerLEDs.hex.

After flashing your PIC12F508 with the firmware, hook up to
five LEDs (with appropriate current limiting resistors in
series) to the pins (2,3,5,6,7). Connect the PIC and the
LEDs with VDD, connect GND to the PIC.

	VDD  1 -  - 8   GND
	LED  2 -  - 7   LED
	LED  3 -  - 6   LED
	NC   4 -  - 5   LED

Enjoy the flicker light!
