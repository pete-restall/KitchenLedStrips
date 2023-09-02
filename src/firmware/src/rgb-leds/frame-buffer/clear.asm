	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_CLEAR_ASM
	#include "../../mcu.inc"
	#include "../../working-registers.inc"
	#include "frame-buffer.inc"

	radix decimal

.framebuffer code
	global frameBufferClear

;
; Clear the frame-buffer (all LEDs will be off).
;
; If W=0 then the entire frame-buffer will be zeroed (128 pixels), otherwise just the number of configured pixels.
;
frameBufferClear:
_zeroInWClearsEntireBufferOf256BytesOtherwiseJustUntilTheFrameBufferEnd:
	banksel _frameBufferDisplayPtrLowPastEnd
	movf WREG, W
	movlw low(_frameBufferLinearPastEnd)
	btfss STATUS, Z
	movf _frameBufferDisplayPtrLowPastEnd, W

	movwf workingA

_pointToFirstByteInBuffer:
	movlw low(_frameBufferLinearStart)
	movwf FSR0L
	movlw high(_frameBufferLinearStart)
	movwf FSR0H

_clearFromStartUntilEndOfBuffer:
	clrw
	movwi FSR0++
	movf FSR0L, W
	xorwf workingA, W
	btfss STATUS, Z
	bra _clearFromStartUntilEndOfBuffer

	return

	end
