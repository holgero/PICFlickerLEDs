# PIC Flicker LEDs
# Flickering LEDs that simulate the light of a fire or candles
# Top level Makefile, creates device firmware.
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

all: device

device:
	$(MAKE) -C device clean all

clean:
	$(MAKE) -C device clean

.PHONY: all device clean
