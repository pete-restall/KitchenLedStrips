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
	#error "A unit ID must be provided to allow location- and device-specific configuration settings to be hard-coded into the firmware."
	#endif

	radix decimal

CONFIG_NUMBER_OF_PIXELS equ CONFIG_NUMBER_OF_PIXELS_PARTITION0 + CONFIG_NUMBER_OF_PIXELS_PARTITION1

CONFIG_NUMBER_OF_LEDS equ CONFIG_NUMBER_OF_PIXELS * 3
CONFIG_NUMBER_OF_LEDS_PARTITION0 equ CONFIG_NUMBER_OF_PIXELS_PARTITION0 * 3
CONFIG_NUMBER_OF_LEDS_PARTITION1 equ CONFIG_NUMBER_OF_PIXELS_PARTITION1 * 3

	#if (CONFIG_NUMBER_OF_PIXELS_PARTITION0 <= 0)
	#error "There must always be at least one pixel in partition 0."
	#endif

	#if (CONFIG_NUMBER_OF_PIXELS_PARTITION1 < 0)
	#error "The number of pixels in partition 1 must be zero or more."
	#endif

	#ifndef __KITCHENLEDS_CONFIG_ASM
	extern FIRMWARE_VERSION
	#endif

	#endif
