	#ifndef __KITCHENLEDS_MCU_INC
	#define __KITCHENLEDS_MCU_INC
	#include "p16f15356.inc"

	radix decimal

	#define MCU_FOSC_HZ 32000000

	errorlevel -305

constrainedToMcuClockFrequencyHz macro hz
	#if MCU_FOSC_HZ != hz
		error "Unexpected MCU Fosc frequency - review this code !"
	#endif
	endm

constrainedToMcuInstructionFrequencyHz macro hz
	#if (hz * 4) != MCU_FOSC_HZ
		error "Unexpected MCU Fosc/4 frequency - review this code !"
	#endif
	endm

	#endif
