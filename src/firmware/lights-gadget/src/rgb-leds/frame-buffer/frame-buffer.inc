	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_FRAMEBUFFER_INC
	#include "../../mcu.inc"
	#include "../../config.inc"

	radix decimal

_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION0 equ CONFIG_NUMBER_OF_PIXELS_PARTITION0 * 2
_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 equ CONFIG_NUMBER_OF_PIXELS_PARTITION1 * 2

_FRAME_BUFFER_FLAG_FRAMESYNC equ 0
_FRAME_BUFFER_FLAG_FRAMESYNC_BLIT equ 1
_FRAME_BUFFER_FLAG_PARTITIONSYNC equ 2
_FRAME_BUFFER_FLAG_RGB_UNPACKED equ 3

_FRAME_BUFFER_TRYBLIT_WAITING_TXBUFFER equ 0
_FRAME_BUFFER_TRYBLIT_WAITING_FRAMESYNC equ 1
_FRAME_BUFFER_TRYBLIT_WAITING_PARTITIONSYNC equ 2

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	extern frameBufferInitialise
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_CLEAR_ASM
	extern frameBufferClear
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_TRYBLIT_ASM
	extern frameBufferSyncFrameAndTryBlit
	extern frameBufferSyncPartitionAndTryBlit
	extern frameBufferTryBlit
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATABUFFERS_ASM
	extern frameBufferLinearStart
	extern frameBufferLinearEnd
	extern frameBufferLinearPastEnd

	extern frameBufferLinearPartition0Start
	extern frameBufferLinearPartition0End
	extern frameBufferLinearPartition0PastEnd

	extern frameBufferLinearPartition1Start
	extern frameBufferLinearPartition1End
	extern frameBufferLinearPartition1PastEnd

	extern _frameBufferRedPalette
	extern _frameBufferGreenPalette
	extern _frameBufferBluePalette
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_UDATASTATE_ASM
	extern _frameBufferFlags
	extern _frameBufferDisplayPtrLow
	extern _frameBufferDisplayPtrHigh
	extern _frameBufferDisplayPtrPastEnd
	#endif

	extern _frameBufferGammaCorrectionPaletteNvram

	extern _frameBufferDefaultRedPalette
	extern _frameBufferDefaultGreenPalette
	extern _frameBufferDefaultBluePalette


constrainedToFrameBufferOf256BytesOrLess macro
	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION0 < 2)
		error "Partition 0 of the frame-buffer must be at least 2 bytes (1 pixel of 2 bytes each; 5-bit RGB components)."
	#endif

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION0 % 2 != 0)
		error "Partition 0 of the frame-buffer must be a multiple of 2 bytes (1 pixel is 2 bytes consisting of 5-bit RGB components)."
	#endif

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 < 0)
		error "Partition 1 of the frame-buffer must be 0 or more bytes."
	#endif

	#if (_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1 % 2 != 0)
		error "Partition 1 of the frame-buffer must be a multiple of 2 bytes (1 pixel is 2 bytes consisting of 5-bit RGB components)."
	#endif

	#if ((_NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION0 + _NUMBER_OF_BYTES_IN_FRAMEBUFFER_PARTITION1) > 256)
		error "The frame-buffer must not be more than 256 bytes (128 pixels of 2 bytes each; 5-bit RGB components)."
	#endif
	endm

	#endif
