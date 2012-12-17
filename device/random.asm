; PIC Flicker LEDs
; Flickering LEDs that simulate the light of a fire or candles
; pseodo random generator as linear feedback shift register
;
; Copyright (C) 2012 Holger Oehm
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
        #include <p12f508.inc>
;**************************************************************
; imported subroutines
;		EXTERN
; imported variables
;		EXTERN
; exported subroutines
		GLOBAL init_random
		GLOBAL next_bit
; exported variables
;		GLOBAL
; local definitions
SEED	EQU	0xA5

;**************************************************************
; data section
random_udata	UDATA
registerL	RES	1
registerH	RES	1

; local data
			UDATA_OVR
bit		RES	1

;**************************************************************
; code section
random_code	CODE
init_random
	movlw	SEED
	movwf	registerL
	movwf	registerH
	retlw	0x00

; linear feedback shift register
; layout: registerL registerH
;         01234567 01234567
;                   1
;         01234567 90123456
; calculate next bit
; get bit 16
; xor with bit 14
; xor with bit 13
; xor with bit 11
; -> is the result
; calculate next value in register
; put result into carry
; shift register with carry left (C->0->1->...->7->C)
next_bit
	clrw
	btfsc	registerH,7
	movlw	1
	btfsc	registerH,5
	xorlw	1
	btfsc	registerH,4
	xorlw	1
	btfsc	registerH,2
	xorlw	1
; result is now in W (and inverted in Z)
	bcf	STATUS,C
	btfss	STATUS,Z
	bsf	STATUS,C
	rlf	registerL,1
	rlf	registerH,1
	btfss	STATUS,Z
	retlw	0x00
	retlw	0x01
	END
