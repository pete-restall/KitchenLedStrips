	#ifndef __KITCHENLEDS_RGBLEDS_RGBLEDS_INC
	#define __KITCHENLEDS_RGBLEDS_RGBLEDS_INC

	#define __NEED_ISR_INTERNALS
	#include "../isr.inc"
	#undefine __NEED_ISR_INTERNALS

	#include "../mcu.inc"

	radix decimal

	#ifndef __KITCHENLEDS_RGBLEDS_UDATABUFFERS_ASM
	extern animationBufferStart
	extern animationBufferEnd
	extern animationBufferPastEnd

	extern frameBuffer0Start
	extern frameBuffer0End
	extern frameBuffer0PastEnd

	extern frameBuffer1Start
	extern frameBuffer1End
	extern frameBuffer1PastEnd

	extern palette0Start
	extern palette0End
	extern palette0PastEnd

	extern palette1Start
	extern palette1End
	extern palette1PastEnd

	extern palette2Start
	extern palette2End
	extern palette2PastEnd

	extern palette3Start
	extern palette3End
	extern palette3PastEnd
	#endif

	#endif
