# PIC Flicker LEDs
# Flickering LEDs that simulate the light of a fire or candles
# Makefile, creates PICFlickerLEDs.hex file from sources
#
# Copyright (C) 2012 Holger Oehm
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

OBJECTS=flacker.o random.o

%.o : %.asm
	gpasm -c -p p12f508 -r dec -w 2 $<

all: PICFlickerLEDs.hex

PICFlickerLEDs.hex: $(OBJECTS)
	gplink -o PICFlickerLEDs.hex -a inhx32 -m $(OBJECTS)
	@test -f PICFlickerLEDs.hex || ( echo gplink failed; exit 1 )

clean:
	rm -f *.o *.map *.lst *.cod *.hex

.PHONY: all clean
