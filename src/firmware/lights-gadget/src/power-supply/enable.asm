	#include "../main.inc"
	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

.powermonitor code
	global powerSupplyEnable

powerSupplyEnable:
_doNotEnableIfAlreadyEnabled:
	banksel PORTB
	btfsc PORTB, RB5
	return

_enablePowerSupply:
	banksel LATB
	bsf LATB, RB5

_storeBlankingTimeDelayForMonitoring:
	banksel mainTimebaseLow
	movf mainTimebaseLow, W
	addlw 2

	banksel _powerSupplyBlankingTimer
	movwf _powerSupplyBlankingTimer

	return

	end
