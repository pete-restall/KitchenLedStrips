	#define __KITCHENLEDS_POWERSUPPLY_NCO1ASADCCONVERSIONTRIGGER_ASM

	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

	constrainedToMcuClockFrequencyHz 32000000 ; Timing-sensitive code

_NCO1CLK_N1CKS_FOSC equ (b'0000' << N1CKS0)

_NCO1INC_ABOUT_8KHZ equ (262 * 2)

.powersupply code
	global _powerSupplyNco1Initialise

_powerSupplyNco1Initialise:
	banksel PMD1
	bcf PMD1, NCO1MD

_initialiseNcoAsAutoConversionTrigger:
	banksel NCO1CON
	clrf NCO1CON

	banksel NCO1CLK
	movlw _NCO1CLK_N1CKS_FOSC
	movwf NCO1CLK

	banksel NCO1ACCU
	clrf NCO1ACCU
	clrf NCO1ACCH
	clrf NCO1ACCL

	banksel NCO1INCU
	clrf NCO1INCU
	movlw high(_NCO1INC_ABOUT_8KHZ)
	movwf NCO1INCH
	movlw low(_NCO1INC_ABOUT_8KHZ)
	movwf NCO1INCL

	return

	end
