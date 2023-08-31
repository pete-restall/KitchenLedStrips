	#include "initialise.inc"
	#include "mcu.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"

	radix decimal

.mainUdata udata
_isMorePollingRequired res 1

.main code
	global main

main:
	pagesel initialise
	call initialise

	banksel INTCON
	bsf INTCON, PEIE
	bsf INTCON, GIE

_pollingLoop:
	clrwdt
	banksel _isMorePollingRequired
	clrf _isMorePollingRequired

_pollRgbLedsModule:
	pagesel rgbLedsPoll
	call rgbLedsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_sleepIfNoMorePollingIsRequired:
	banksel _isMorePollingRequired
	movf _isMorePollingRequired, F
	btfss STATUS, Z
	bra _pollingLoop

	pagesel powerManagementSleep
	call powerManagementSleep
	bra _pollingLoop

	end
