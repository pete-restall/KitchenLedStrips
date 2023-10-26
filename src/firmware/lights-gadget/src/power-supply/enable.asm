	#include "../main.inc"
	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

_BLANKING_TIME_ABOUT_3MS equ 24 ; Timebase is NCO1 at roughly 8kHz

.powersupply code
	global powerSupplyEnable

powerSupplyEnable:
_doNotEnableIfAlreadyEnabled:
	banksel PORTB
	btfsc PORTB, RB5
	return

_enablePowerSupply:
	banksel LATB
	bsf LATB, RB5

_storeBlankingTimeDelayToDisableMonitoringDuringPowerSupplyRampUp:
	banksel _powerSupplyBlankingTimer
	movlw _BLANKING_TIME_ABOUT_3MS
	movwf _powerSupplyBlankingTimer

_clearAdcInterruptFlag:
	banksel PIR1
	bcf PIR1, ADIF

_enableAdcInterruptOnlyIfHigherFrequencyTransmissionInterruptIsDisabled:
	banksel PIE3
	btfss PIE3, TX1IE
	bsf PIE1, ADIE

_enableAdcAndNcoToStartMonitoringThePowerSupply:
	banksel ADCON0
	bcf ADCON0, GO
	bsf ADCON0, ADON

	banksel NCO1CON
	bsf NCO1CON, N1EN

	return

	end
