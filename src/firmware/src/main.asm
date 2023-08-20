	#include "mcu.inc"

	radix decimal

.udata udata
_counter res 3

.main code
	global main

main:
	banksel LATC
	bcf LATC, 6

	banksel ANSELC
	bcf ANSELC, 6

	banksel TRISC
	bcf TRISC, 6

	banksel _counter
	clrf (_counter + 0)
	clrf (_counter + 1)
	clrf (_counter + 2)

_loop:
	clrwdt

	banksel _counter
	movf (_counter + 0), W
	xorlw 0x40
	btfss STATUS, Z
	bra _incrementAndLoop

	movf (_counter + 1), W
	xorlw 0x42
	btfss STATUS, Z
	bra _incrementAndLoop

	movf (_counter + 2), W
	xorlw 0x0f
	btfss STATUS, Z
	bra _incrementAndLoop

	clrf (_counter + 0)
	clrf (_counter + 1)
	clrf (_counter + 2)

	banksel LATC
	movlw 1 << 6
	xorwf LATC, F

	bra _loop

_incrementAndLoop:
	incfsz (_counter + 0), F
	bra _loop

	incfsz (_counter + 1), F
	bra _loop

	incf (_counter + 2), F
	bra _loop

	end
