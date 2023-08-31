	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	#include "frame-buffer.inc"

	radix decimal

_FSR_LINEAR_ACCESS_HIGH equ 0x20

.framebuffer code
	global frameBufferInitialise

frameBufferInitialise:
	banksel _frameBufferFlags
	clrf _frameBufferFlags
	bsf _frameBufferFlags, _FRAME_BUFFER_FLAG_FRAMESYNC_BLIT

	movlw 0x30 ;low(_frameBufferStart)
	movwf _frameBufferDisplayPtrLow
	movlw 0x22 ;high(_frameBufferStart) ; TODO: LINEAR ADDRESSING FORMULA NEEDS TO BE WORKED OUT, UNLESS WE DEFINE SOME OVERLAPPING LABELS IN A LINEAR SECTION AS WELL
	iorlw _FSR_LINEAR_ACCESS_HIGH
	movwf _frameBufferDisplayPtrHigh
	movlw 0x36 ; low(_frameBufferPastEnd) ; TODO: requires adjustment depending on the number of LEDs in the strip
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

	movlw 0x00
	movwf _frameBufferStart + 4
	movlw 0xf2
	movwf _frameBufferStart + 5

; TODO: ******** END OF TEMPORARY DEBUGGING ********

	return

	end
