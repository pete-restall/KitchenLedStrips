	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	#include "frame-buffer.inc"

	radix decimal

_FSR_LINEAR_ACCESS_HIGH equ 0x20

.framebuffer code
	global frameBufferInitialise

frameBufferInitialise:
	banksel _frameBufferFlags
	clrf _frameBufferFlags

	movlw low(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh
	movlw low(_frameBufferLinearStart) + 6 ; low(_frameBufferPastEnd) ; TODO: requires adjustment depending on the number of LEDs in the strip
	movwf _frameBufferDisplayPtrLowPastEnd

; TODO: ******** START OF TEMPORARY DEBUGGING - SET UP A SIMPLE DISPLAY FRAME ********
	banksel _frameBufferStart ; RRRR GGGG  BBBB rgb_
	movlw 0xf0
	movwf _frameBufferStart + 0
	movlw 0x08
	movwf _frameBufferStart + 1

	movlw 0x70
	movwf _frameBufferStart + 2
	movlw 0x08
	movwf _frameBufferStart + 3

	movlw 0x30
	movwf _frameBufferStart + 4
	movlw 0x08
	movwf _frameBufferStart + 5

; TODO: ******** END OF TEMPORARY DEBUGGING ********

	return

	end
