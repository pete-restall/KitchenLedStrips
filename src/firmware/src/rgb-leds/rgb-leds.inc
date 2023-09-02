	#ifndef __KITCHENLEDS_RGBLEDS_RGBLEDS_INC
	#define __KITCHENLEDS_RGBLEDS_RGBLEDS_INC

	radix decimal

	extern rgbLedsModulatorInitialise
	extern rgbLedsModulatorIsBusy
	extern rgbLedsModulatorTryStartFrame

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
	extern rgbLedsPixelRed
	extern rgbLedsPixelGreen
	extern rgbLedsPixelBlue
	#endif

	#endif
