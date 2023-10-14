	#ifndef __KITCHENLEDS_CONFIG_INC
	#define __KITCHENLEDS_CONFIG_INC

	radix decimal

CONFIG_UNIT_ID equ {{CONFIG_UNIT_ID}}

	#if (CONFIG_UNIT_ID == 1)
	#include "config.fridge.inc"
	#elif (CONFIG_UNIT_ID == 2)
	#include "config.cooker.inc"
	#elif (CONFIG_UNIT_ID == 3)
	#include "config.sink-left.inc"
	#elif (CONFIG_UNIT_ID == 4)
	#include "config.sink-right.inc"
	#elif (CONFIG_UNIT_ID == 7)
	#include "config.debug.inc"
	#else
	#error "A unit ID must be provided to allow location- and device-specific configuration settings to be hard-coded into the firmware"
	#endif

	radix decimal

CONFIG_NUMBER_OF_LEDS equ CONFIG_NUMBER_OF_PIXELS * 3

	#ifndef __KITCHENLEDS_CONFIG_ASM
	extern FIRMWARE_VERSION
	#endif

	#endif
