	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	#include "frame-buffer.inc"

	radix decimal

.framebuffer code
	global frameBufferInitialise

frameBufferInitialise:
	banksel _frameBufferFlags
	clrf _frameBufferFlags

_initialiseFrameBufferPointers:
	movlw low(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh

_referenceUnusedBankVariablesToPreventLinkerStrippingSymbolAndCorruptingTheMemoryMap:
	movlw low(_frameBufferPastEnd)

_clearFrameBuffer:
	pagesel frameBufferClear
	call frameBufferClear
	return

	end
