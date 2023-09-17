	#ifndef __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INC
	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INC

	radix decimal

	extern frameBufferInitialise
	extern frameBufferClear
	extern frameBufferSyncAndTryBlit
	extern frameBufferTryBlit

	extern frameBufferLinearStart
	extern frameBufferLinearEnd
	extern frameBufferLinearPastEnd

	#endif
