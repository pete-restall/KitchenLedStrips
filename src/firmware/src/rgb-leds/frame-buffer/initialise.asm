	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	#include "frame-buffer.inc"

	radix decimal

.framebuffer code
	global frameBufferInitialise

frameBufferInitialise:
	banksel _frameBufferFlags
	clrf _frameBufferFlags

_initialiseFrameBufferPointers:
	movlw low(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh
	movlw low(_frameBufferLinearStart) + 6 ; low(_frameBufferPastEnd) ; TODO: requires adjustment depending on the number of LEDs in the strip
	movwf _frameBufferDisplayPtrLowPastEnd

_referenceUnusedBankVariablesToPreventLinkerStrippingSymbolAndCorruptingTheMemoryMap:
	movlw low(_frameBufferPastEnd)

_clearFrameBuffer:
	clrw
	pagesel frameBufferClear
	call frameBufferClear
	return

	end
