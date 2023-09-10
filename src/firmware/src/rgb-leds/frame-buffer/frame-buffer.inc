	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#include "../../mcu.inc"
	#include "../../config.inc"

	radix decimal

_NUMBER_OF_BYTES_IN_FRAMEBUFFER equ CONFIG_NUMBER_OF_PIXELS * 2

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
	extern frameBufferSyncAndTryBlit
	extern frameBufferTryBlit
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	extern _frameBufferStart
	extern _frameBufferEnd
	extern _frameBufferPastEnd

	extern frameBufferLinearStart
	extern frameBufferLinearEnd
	extern frameBufferLinearPastEnd

	extern _frameBufferRedPalette
	extern _frameBufferGreenPalette
	extern _frameBufferBluePalette
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATASTATE_ASM
	extern _frameBufferFlags
	extern _frameBufferDisplayPtrLow
	extern _frameBufferDisplayPtrHigh
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_GAMMACORRECTIONPALETTENVRAM_ASM
	extern _frameBufferGammaCorrectionPaletteNvram
	#endif

constrainedToFrameBufferOf256BytesOrLess macro
	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER < 2)
		error "The frame-buffer must be at least 2 bytes (1 pixel of 2 bytes each; 5-bit RGB components)."
	#endif

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER % 2 != 0)
		error "The frame-buffer must be a multiple of 2 bytes (1 pixel is 2 bytes consisting of 5-bit RGB components)."
	#endif

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER > 256)
		error "The frame-buffer must not be more than 256 bytes (128 pixels of 2 bytes each; 5-bit RGB components)."
	#endif
	endm

	#endif
