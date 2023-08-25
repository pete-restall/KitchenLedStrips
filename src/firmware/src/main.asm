	#include "initialise.inc"

	#include "mcu.inc"                            ;;;;;;; TODO: TEMPORARY DEBUGGING !
	#include "rgb-leds.inc"                       ;;;;;;; TODO: TEMPORARY DEBUGGING !

	radix decimal

.TODO_TEMPORARY udata
_temp1 res 1
_temp2 res 1
_ledBuf res 9

.main code
	global main

main:
	pagesel initialise
	call initialise
	clrwdt

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
	extern _txUnreadCount
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

_populateFrameBufferWithSomePixels:
	movlw low(_ledBuf)
	movwf FSR0L
	movlw high(_ledBuf)
	movwf FSR0H

	banksel _ledBuf
	movlw 0xaa ; needs reversing - remember UART is LSb first !
	movwf (_ledBuf + 0)
	movwf (_ledBuf + 1)
	movwf (_ledBuf + 2)

	movlw 0x55 ; needs reversing - remember UART is LSb first !
	movwf (_ledBuf + 3)
	movwf (_ledBuf + 4)
	movwf (_ledBuf + 5)

	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel

	pagesel rgbLedsStartFrame
	call rgbLedsStartFrame

	return

	end
