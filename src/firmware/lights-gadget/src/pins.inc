	#ifndef __KITCHENLEDS_PINS_INC
	#define __KITCHENLEDS_PINS_INC

	radix decimal

	#ifndef __KITCHENLEDS_PINS_ASM
	extern pinsInitialise
	extern pinsSetPeripherals
	extern pinsDirectClc1outToLedD0
	extern pinsDirectClc1outToLedD1
	#endif

pinsDirectClc1outToLedsForPartition0 macro
	if (CONFIG_PARTITION0_IS_LED_D0 != 0)
		pagesel pinsDirectClc1outToLedD0
		call pinsDirectClc1outToLedD0
	else
		pagesel pinsDirectClc1outToLedD1
		call pinsDirectClc1outToLedD1
	endif

	endm

pinsDirectClc1outToLedsForPartition1 macro
	if (CONFIG_PARTITION0_IS_LED_D0 == 0)
		pagesel pinsDirectClc1outToLedD0
		call pinsDirectClc1outToLedD0
	else
		pagesel pinsDirectClc1outToLedD1
		call pinsDirectClc1outToLedD1
	endif

	endm

	#endif
