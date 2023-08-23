	#include "mcu.inc"                            ;;;;;;; TODO: TEMPORARY DEBUGGING !
	#include "initialise.inc"

	radix decimal

.TODO_TEMPORARY udata
_temp1 res 1
_temp2 res 1

.main code
	global main

main:
	pagesel initialise
	call initialise

	banksel INTCON
	bsf INTCON, PEIE
	bsf INTCON, GIE

	banksel LATC ; TODO: MORE TEMPORARY DEBUGGING
	bsf LATC, 4 ;;;;;;;; TODO: GREEN - TEMPORARY DEBUGGING
	banksel LATC
	bsf LATC, 5 ;;;;;;;; TODO: RED - TEMPORARY DEBUGGING

	pagesel _temporaryDebugging
	call _temporaryDebugging

	banksel T2CON
	movf T2CON, W
	banksel LATC
	btfsc WREG, EN
	bcf LATC, 4 ;;;;;;;; TODO: GREEN - TEMPORARY DEBUGGING

_pollingLoop:
	clrwdt
	banksel CLCDATA
	movf CLCDATA, W

	banksel LATC
	movf _txUnreadCount, W
	btfsc STATUS, Z
	bcf LATC, 5 ;;;;;;;; TODO: RED - TEMPORARY DEBUGGING
	bra _pollingLoop


_temporaryDebugging:
	; TODO: FIGURE OUT A WAY TO WAIT FOR THE 80us AFTER INITIALISATION (AND AFTER EACH FRAME) TO KEEP THE CLC1OUT LOW TO RESET THE LEDS
	banksel _temp1
	clrf _temp1
	movlw 0xfc
	movwf _temp2
_xxx:
	incfsz _temp1, F
	bra _xxx
	incfsz _temp2, F
	bra _xxx

	movlw 2
	movwf _temp1

_shiftThreeLeds:
	movlw 0xff
	movwi FSR1++
	movlw 0
	movwi FSR1++
	movwi FSR1++

	movlw 0
	movwi FSR1++
	movlw 0xff
	movwi FSR1++
	movlw 0
	movwi FSR1++

	movlw 0
	movwi FSR1++
	movwi FSR1++
	movlw 0xff
	movwi FSR1++

	decfsz _temp1, F
	bra _shiftThreeLeds

	extern _txUnreadCount
	movlw 1
	movwf _txUnreadCount

	banksel TX1REG
	clrf TX1REG

	banksel T2CON
	clrf TMR2
	bsf T2CON, EN

	banksel CLC2POL
	bsf CLC2POL, LC2G2POL ; data

	banksel PIE3
	bsf PIE3, TX1IE

	return

	end
