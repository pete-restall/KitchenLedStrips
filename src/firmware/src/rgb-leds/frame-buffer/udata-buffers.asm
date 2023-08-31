	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	#include "frame-buffer.inc"

	radix decimal

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

	end
