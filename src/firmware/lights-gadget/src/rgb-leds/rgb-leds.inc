	#ifndef __KITCHENLEDS_RGBLEDS_RGBLEDS_INC
	#define __KITCHENLEDS_RGBLEDS_RGBLEDS_INC

	radix decimal

_POLL_FLAG_DISABLE_BLITTING equ 0
_POLL_FLAG_FORCE_BLIT equ 1
_POLL_FLAG_SKIP_NEXT_BLIT_TO_RESYNC equ 2

	extern rgbLedsModulatorInitialise
	extern rgbLedsModulatorIsBusy
	extern rgbLedsModulatorTryStartFrame

	#ifndef __KITCHENLEDS_RGBLEDS_POLL_ASM
	extern _rgbLedsPollState
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_TRYPUTNEXTPIXELINTOTX_ASM
	extern rgbLedsTryPutNextPixelIntoTransmissionBuffer
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_NEXTPIXEL_ASM
	extern _rgbLedsNextPixelInitialise
	extern rgbLedsTryPutNextPixel
	extern rgbLedsTryGetNextPixel
	extern rgbLedsResetNextPixelPointer
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_TMR0FRAMESYNC_ASM
	extern frameSyncTimerInitialise
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_PUBLICUDATA_ASM
	extern rgbLedsFrameCounter
	extern rgbLedsPixelRed
	extern rgbLedsPixelGreen
	extern rgbLedsPixelBlue
	#endif

	#endif
