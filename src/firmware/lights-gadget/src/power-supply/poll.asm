	#include "../main.inc"
	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

.powermonitor code
	global powerSupplyPoll

powerSupplyPoll:
	banksel ADCON0
	btfsc ADCON0, ADON
	retlw 0

_nothingToDoIfPowerSupplyNotEnabled:
	banksel PORTB
	btfss PORTB, RB5
	retlw 0

_waitUntilBlankingTimeHasElapsed:
	banksel mainTimebaseLow
	movf mainTimebaseLow, W

	banksel _powerSupplyBlankingTimer
	xorwf _powerSupplyBlankingTimer, W
	btfss STATUS, Z
	retlw 1

_clearInterruptFlags:
	banksel PIR1
	bcf PIR1, ADIF

	banksel IOCBF
	bcf IOCBF, RB4

_unmuteLedBitstreamTransmissionNowThatPowerIsPresent:
	banksel CLC4POL
	bcf CLC4POL, LC4G2POL ; data
	bcf CLC4POL, LC4G3POL ; reset

_enableAdcInterruptOnlyIfHigherFrequencyTransmissionInterruptIsDisabled:
	banksel PIE3
	btfss PIE3, TX1IE
	bsf PIE1, ADIE

_enableAdcAndNcoToMonitorPowerSupply:
	banksel ADCON0
	bcf ADCON0, GO
	bsf ADCON0, ADON

	banksel NCO1CON
	bsf NCO1CON, N1EN

	retlw 0

	end
