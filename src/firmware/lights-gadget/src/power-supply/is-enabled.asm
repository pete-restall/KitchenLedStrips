	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

.powermonitor code
	global powerSupplyIsEnabled

powerSupplyIsEnabled:
_returnFalseIfNotEnablingPowerSwitch:
	banksel PORTB
	btfss PORTB, RB5
	retlw 0

_returnFalseIfPowerGoodFlagIsLow:
	btfss PORTB, RB4
	retlw 0

_returnFalseIfVoltageRailMonitoringHasNotYetStarted:
	banksel ADCON0
	btfss ADCON0, ADON
	retlw 0

_powerSupplyIsEnabled:
	retlw 1

	end
