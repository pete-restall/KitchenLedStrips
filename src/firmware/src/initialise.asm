	#include "led-patterns.inc"
	#include "pins.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"

	radix decimal

.initialise code
	global initialise

initialise:
	; TODO: Different reset behaviours are required.
	;   If POR then turn on full (with default settings).
	;   If BOR then turn on full (perhaps with previous settings, if not wiped from RAM ?)
	;   If WDT then same as BOR or perhaps just turn off all LEDs ?

	; TODO: Various settings not yet considered, such as PCON for enabling stack over/underflow resets

	pagesel powerManagementInitialise
	call powerManagementInitialise

	pagesel pinsInitialise
	call pinsInitialise

	pagesel rgbLedsInitialise
	call rgbLedsInitialise

	pagesel ledPatternsInitialise
	call ledPatternsInitialise

	pagesel pinsSetPeripherals
	call pinsSetPeripherals

	return

	end
