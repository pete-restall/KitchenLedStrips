	#include "rgb-leds.inc"

	radix decimal

_TX_BUFFER_MINIMUM_CAPACITY equ RGBLEDS_NUMBER_OF_BYTES_IN_TX_BUFFER - 3

.rgbleds code
	global rgbLedsTryPutNextPixel

;
; Append one pixel (three colour components / three bytes) pointed to by FSR0 to the LED's circular buffer.
;
; Returns W=0 if there was insufficient space, W=1 if the pixel was successfully appended.
;
rgbLedsTryPutNextPixel:
_ensureSufficientBufferSpaceForThreeColourComponents:
	banksel _txUnreadCount
	movf _txUnreadCount, W
	sublw _TX_BUFFER_MINIMUM_CAPACITY
	btfss STATUS, C
	retlw 0

_writeFirstComponentToCircularBuffer:
	moviw FSR0++
	movwi FSR1++

	movlw low(_txBufferEnd) + 1
	xorwf FSR1L, W
	movlw low(_txBufferStart)
	btfsc STATUS, Z
	movwf FSR1L ; _txReadPtrLow == _txBufferEnd, so reset the pointer to _txBufferStart

_writeSecondComponentToCircularBuffer:
	moviw FSR0++
	movwi FSR1++

	movlw low(_txBufferEnd) + 1
	xorwf FSR1L, W
	movlw low(_txBufferStart)
	btfsc STATUS, Z
	movwf FSR1L ; _txReadPtrLow == _txBufferEnd, so reset the pointer to _txBufferStart

_writeThirdComponentToCircularBuffer:
	moviw FSR0++
	movwi FSR1++

	movlw low(_txBufferEnd) + 1
	xorwf FSR1L, W
	movlw low(_txBufferStart)
	btfsc STATUS, Z
	movwf FSR1L ; _txReadPtrLow == _txBufferEnd, so reset the pointer to _txBufferStart

_atomicallyAddThreeBytesToUnreadCountAndReturnSuccessfully:
	movlw 3
	addwf _txUnreadCount, F
	retlw 1

	end
