	#ifndef __KITCHENLEDS_MAIN_INC
	#define __KITCHENLEDS_MAIN_INC

	radix decimal

	#ifndef __KITCHENLEDS_MAIN_ASM
	extern mainTimebaseLow
	extern mainTimebaseHigh
	#endif

	#ifndef __KITCHENLEDS_INITIALISE_ASM
	extern resetStatus
	extern resetPcon0
	extern resetPcon1
	#endif

	#endif
