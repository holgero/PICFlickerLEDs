; PIC Flicker LEDs
; Flickering LEDs that simulate the light of a fire or candles
; main routine
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
	__CONFIG _WDT_OFF & _IntRC_OSC
; macros
checkPwm	macro	idx
		movf	brightness+idx,W
		subwf	pwmCounter,W ; sets Carry if positive
		btfsc	STATUS,C
		bsf	latchPortB,idx
		endm

changeBright	macro	idx,minusL,doneL
		movlw	brightness+idx
		movwf	FSR
		call	setBright
		; now change direction if random is 1
		call	next_bit
		xorwf	direction+idx,F
		endm

; imported subroutines
		EXTERN	init_random	; random.asm
		EXTERN	next_bit	; random.asm
; imported variables
;		EXTERN
; exported subroutines
;		GLOBAL
; exported variables
;		GLOBAL
; local definitions
DELAY_H		EQU	1
DELAY_L		EQU	128
PWMC		EQU	8

;**************************************************************
; data section
flacker_udata	UDATA
delayCountL	RES	1
delayCountH	RES	1
pwmCounter	RES	1
latchPortB	RES	1
brightness	RES	6
direction	RES	6

;**************************************************************
; Program
resetvector	ORG 0x00
	movwf	OSCCAL
	goto	Init		; jump to main routine
; code section
flacker_code	CODE
Init
	call	init_random
	movlw	~( 1 << T0CS )	; clear T0CS bit
	option			; in option register

	movlw	( 1 << 3 )	; all output, but GP3
	tris	GPIO
	clrf	GPIO

	movlw	PWMC/2
	movwf	brightness
	movwf	brightness+1
	movwf	brightness+2
	movwf	brightness+3
	movwf	brightness+4
	movwf	brightness+5
	movlw	1
	movwf	direction
	movwf	direction+1
	movwf	direction+2
	movwf	direction+3
	movwf	direction+4
	movwf	direction+5

mainloop
	movlw	DELAY_H+1
	movwf	delayCountH
	movlw	DELAY_L
	movwf	delayCountL
delayLoop
	movlw	PWMC
	movwf	pwmCounter
pwmloop
	clrf	latchPortB
	checkPwm	0
	checkPwm	1
	checkPwm	2
	checkPwm	3
	checkPwm	4
	checkPwm	5
	bsf	latchPortB,3	; keep bit 3 set (gpsim bug???)
	movf	latchPortB,W
	movwf	GPIO

	decfsz	pwmCounter,F
	goto	pwmloop

	decfsz	delayCountL,F
	goto	delayLoop
	decfsz	delayCountH,F
	goto	delayLoop

	; pwm stuff has been handled, now change
	; brightness according to current direction
	changeBright 0,minus0,done0
	changeBright 1,minus1,done1
	changeBright 2,minus2,done2
	changeBright 3,minus3,done3
	changeBright 4,minus4,done4
	changeBright 5,minus5,done5

	goto	mainloop

; brightness register in FSR
setBright
		movlw	direction-brightness
		addwf	FSR,F
		btfss	INDF,0
		goto	lowerBright
; increase brightness
		subwf	FSR,F	; fix FSR first
		incf	INDF,F
; check overflow
		movlw	PWMC
		subwf	INDF,W
		btfss	STATUS,Z
		goto	doneBright	; no overflow
resetBright
; reset to 1/2 brightness
		movlw	PWMC/2
		movwf	INDF
		goto	doneBright

lowerBright
		subwf	FSR,F	; fix FSR first
		decf	INDF,F
		btfsc	STATUS,Z
		goto	resetBright	; overflow

doneBright
		retlw	0x00
	END
