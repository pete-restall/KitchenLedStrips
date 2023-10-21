	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	#include "frame-buffer.inc"

	radix decimal

	constrainedToFrameBufferOf256BytesOrLess

.frameBufferLinear udata
	global frameBufferLinearStart ; Up to 256-byte linear-access buffer
	global frameBufferLinearPartition0Start
	global frameBufferLinearPartition0End
	global frameBufferLinearPartition0PastEnd
	global frameBufferLinearPartition1Start
	global frameBufferLinearPartition1End
	global frameBufferLinearEnd
	global frameBufferLinearPartition1PastEnd
	global frameBufferLinearPastEnd

frameBufferLinearStart:
frameBufferLinearPartition0Start:
	res _NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION0 - 1
frameBufferLinearPartition0End res 1

frameBufferLinearPartition0PastEnd:
frameBufferLinearPartition1Start:
	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 > 1)
		res _NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 - 1
	#endif
frameBufferLinearPartition1End:
frameBufferLinearEnd:
	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 > 0)
		res 1
	#endif
frameBufferLinearPartition1PastEnd:
frameBufferLinearPastEnd:


.redPaletteUdata udata
	global _frameBufferRedPalette
_frameBufferRedPalette res 32

.greenPaletteUdata udata
	global _frameBufferGreenPalette
_frameBufferGreenPalette res 32

.bluePaletteUdata udata
	global _frameBufferBluePalette
_frameBufferBluePalette res 32

	end
