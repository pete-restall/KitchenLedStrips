	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_CLEAR_ASM
	#include "../../mcu.inc"
	#include "frame-buffer.inc"

	radix decimal

	constrainedToFrameBufferOf256BytesOrLess

.framebuffer code
	global frameBufferClear

;
; Clear the frame-buffer (all LEDs will be off).
;
frameBufferClear:
_pointToFirstByteInBuffer:
	movlw low(frameBufferLinearStart)
	movwf FSR0L
	movlw high(frameBufferLinearStart)
	movwf FSR0H

_clearFromStartUntilEndOfBuffer:
	clrw
	movwi FSR0++
	movf FSR0L, W
	xorlw low(frameBufferLinearPastEnd)
	btfss STATUS, Z
	bra _clearFromStartUntilEndOfBuffer

	return

	end
