	#define __KITCHENLEDS_CONFIG_ASM
	#include "config.inc"

	radix decimal

.config code
	global FIRMWARE_VERSION
FIRMWARE_VERSION da "{{FIRMWARE_VERSION}}"

	end
