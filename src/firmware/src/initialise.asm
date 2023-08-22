	#include "pins.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"

	radix decimal

.initialise code
	global initialise

initialise:
	pagesel powerManagementInitialise
	call powerManagementInitialise

	pagesel pinsInitialise
	call pinsInitialise

	pagesel rgbLedsInitialise
	call rgbLedsInitialise

	pagesel pinsSetPeripherals
	call pinsSetPeripherals

	return

	end
