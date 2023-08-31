	#ifndef __KITCHENLEDS_RGBLEDS_RGBLEDS_INC
	#define __KITCHENLEDS_RGBLEDS_RGBLEDS_INC

	radix decimal

	extern rgbLedsModulatorInitialise
	extern rgbLedsModulatorTryStartFrame

	#ifndef __KITCHENLEDS_RGBLEDS_TRYPUTNEXTPIXELINTOTX_ASM
	extern rgbLedsTryPutNextPixelIntoTransmissionBuffer
	#endif

	#ifndef __KITCHENLEDS_RGBLEDS_UDATABUFFERS_ASM
	extern animationBufferStart
	extern animationBufferEnd
	extern animationBufferPastEnd
	#endif

	#endif
