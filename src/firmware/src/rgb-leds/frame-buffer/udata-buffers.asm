	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	#include "frame-buffer.inc"

	radix decimal

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER != 256)
		error "The frame-buffer must be 256 bytes (128 pixels of 2 bytes each; 5-bit RGB components)."
	#endif

.frameBuffer0 udata
	global _frameBufferStart ; 256-byte linear-access buffer
_frameBufferStart res 80

.frameBuffer1 udata
	res 80

.frameBuffer2 udata
	res 80

.frameBuffer3 udata
	global _frameBufferEnd
	global _frameBufferPastEnd
	res 15
_frameBufferEnd res 1
_frameBufferPastEnd:


.frameBufferLinear udata
	global _frameBufferLinearStart
	global _frameBufferLinearEnd
	global _frameBufferLinearPastEnd
_frameBufferLinearStart res 1
	res _NUMBER_OF_BYTES_IN_FRAMEBUFFER - 2
_frameBufferLinearEnd res 1
_frameBufferLinearPastEnd:

	end
