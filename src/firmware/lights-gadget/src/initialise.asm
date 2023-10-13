	#define __KITCHENLEDS_INITIALISE_ASM
	#include "commands.inc"
	#include "led-patterns.inc"
	#include "main.inc"
	#include "mcu.inc"
	#include "pins.inc"
	#include "power-management.inc"
	#include "power-supply.inc"
	#include "reset.inc"
	#include "rgb-leds.inc"

	radix decimal

.initialise code
	global initialise

initialise:
	pagesel resetInitialise
	call resetInitialise

_initialiseModules:
	pagesel powerManagementInitialise
	call powerManagementInitialise

	pagesel pinsInitialise
	call pinsInitialise

	pagesel powerSupplyInitialise
	call powerSupplyInitialise

	pagesel rgbLedsInitialise
	call rgbLedsInitialise

	pagesel ledPatternsInitialise
	call ledPatternsInitialise

	pagesel commandsInitialise
	call commandsInitialise

	pagesel pinsSetPeripherals
	call pinsSetPeripherals

	return

	end
