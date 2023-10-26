	#ifndef __KITCHENLEDS_RGBLEDS_INC
	#define __KITCHENLEDS_RGBLEDS_INC

	radix decimal

	extern rgbLedsInitialise
	extern rgbLedsPoll
	extern rgbLedsForceNextBlitBeforeFrameSync
	extern rgbLedsEnableBlitting
	extern rgbLedsDisableBlitting

	extern rgbLedsFrameCounter

	extern rgbLedsTryPutNextPixel
	extern rgbLedsTryGetNextPixel
	extern rgbLedsResetNextPixelPointer
	extern rgbLedsPixelRed
	extern rgbLedsPixelGreen
	extern rgbLedsPixelBlue

	#endif
