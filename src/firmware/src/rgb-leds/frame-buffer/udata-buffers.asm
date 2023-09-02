	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	#include "frame-buffer.inc"

	radix decimal

	constrainedToFrameBufferOf256BytesOrLess

reserveFrameBufferBank macro bankNumber, numberOfBytes
.frameBuffer#v(bankNumber) udata
	if (bankNumber == 0)
		global _frameBufferStart
		if (numberOfBytes > 80)
_frameBufferStart res 80
			reserveFrameBufferBank bankNumber + 1, numberOfBytes - 80
		else
			global _frameBufferStart
			global _frameBufferEnd
			global _frameBufferPastEnd
_frameBufferStart res numberOfBytes - 1
_frameBufferEnd res 1
_frameBufferPastEnd:
		endif
	else
		if (numberOfBytes > 80)
			res 80
			reserveFrameBufferBank bankNumber + 1, numberOfBytes - 80
		else
			global _frameBufferEnd
			global _frameBufferPastEnd
			res numberOfBytes - 1
_frameBufferEnd res 1
_frameBufferPastEnd:
		endif
	endif

	endm

	reserveFrameBufferBank 0, _NUMBER_OF_BYTES_IN_FRAMEBUFFER

.frameBufferLinear udata
	global frameBufferLinearStart ; Up to 256-byte linear-access buffer
	global frameBufferLinearEnd
	global frameBufferLinearPastEnd
frameBufferLinearStart res 1
	res _NUMBER_OF_BYTES_IN_FRAMEBUFFER - 2
frameBufferLinearEnd res 1
frameBufferLinearPastEnd:

	end
