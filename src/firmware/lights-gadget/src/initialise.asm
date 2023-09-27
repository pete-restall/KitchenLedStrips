	#define __KITCHENLEDS_INITIALISE_ASM
	#include "commands.inc"
	#include "led-patterns.inc"
	#include "main.inc"
	#include "mcu.inc"
	#include "pins.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"

	radix decimal

.initialiseUdata udata
	global resetStatus
	global resetPcon0
	global resetPcon1
resetStatus res 1
resetPcon0 res 1
resetPcon1 res 1

.initialise code
	global initialise

initialise:
_saveResetRegistersForDebugging:
	movf STATUS, W
	banksel resetStatus
	movwf resetStatus

	banksel PCON0
	movf PCON0, W
	movwf resetPcon0
	movf PCON1, W
	movwf resetPcon1

_clearResetRegisters:
	movlw b'00111111'
	movwf PCON0
	movlw b'00000010'
	movwf PCON1

	; TODO: Different reset behaviours are required.
	;   If POR then turn on full (with default settings).
	;   If BOR then turn on full (perhaps with previous settings, if not wiped from RAM ?)
	;   If WDT then same as BOR or perhaps just turn off all LEDs ?

_initialiseModules:
	pagesel powerManagementInitialise
	call powerManagementInitialise

	pagesel pinsInitialise
	call pinsInitialise

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
