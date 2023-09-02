	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATASTATE_ASM
	#include "frame-buffer.inc"

	radix decimal

.frameBufferState udata
	global _frameBufferFlags
	global _frameBufferDisplayPtrLow
	global _frameBufferDisplayPtrHigh

_frameBufferFlags res 1
_frameBufferDisplayPtrLow res 1
_frameBufferDisplayPtrHigh res 1

	end
