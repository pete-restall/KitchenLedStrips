	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

.powersupply code
	global powerSupplyDisable

powerSupplyDisable:
	banksel PIE1
	bcf PIE1, ADIE

	banksel LATB
	bcf LATB, RB5

	banksel ADCON0
	bcf ADCON0, ADON

	banksel PIR1
	bcf PIR1, ADIF

	banksel IOCBF
	bcf IOCBF, RB4

_disableLedBitstreamTransmissionToPreventDrivingUnpoweredLedStrip:
	banksel CLC4POL
	bcf CLC4POL, LC4G2POL ; data
	bsf CLC4POL, LC4G3POL ; reset

_disableAdcConversionTrigger:
	banksel NCO1CON
	bsf NCO1CON, N1EN

	return

	end
