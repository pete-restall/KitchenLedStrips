	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#include "../../mcu.inc"

	radix decimal

_NUMBER_OF_BYTES_IN_FRAMEBUFFER equ 128 * 2

_FRAME_BUFFER_FLAG_FRAMESYNC equ 0
_FRAME_BUFFER_FLAG_FRAMESYNC_BLIT equ 1
_FRAME_BUFFER_FLAG_RGB_UNPACKED equ 2

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	extern frameBufferInitialise
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_CLEAR_ASM
	extern frameBufferClear
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_TRYBLIT_ASM
	extern frameBufferTryBlit
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	extern _frameBufferStart
	extern _frameBufferEnd
	extern _frameBufferPastEnd

	extern _frameBufferLinearStart
	extern _frameBufferLinearEnd
	extern _frameBufferLinearPastEnd
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATASTATE_ASM
	extern _frameBufferFlags
	extern _frameBufferDisplayPtrLow
	extern _frameBufferDisplayPtrHigh
	extern _frameBufferDisplayPtrLowPastEnd
	#endif

	#endif
