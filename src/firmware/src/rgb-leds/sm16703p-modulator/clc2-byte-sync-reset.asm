	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc2AsByteSynchronisedReset

sm16703pModulatorInitialiseClc2AsByteSynchronisedReset:
	banksel PMD5
	bcf PMD5, CLC2MD

	banksel CLC2SEL0
	movlw _CLCSEL_TMR2_POSTSCALED
	movwf CLC2SEL0

	clrf CLC2GLS0
	bsf CLC2GLS0, LC2G1D1T ; clock

	clrf CLC2GLS1
	clrf CLC2GLS2
	clrf CLC2GLS3

	clrf CLC2POL

	movlw _CLCCON_LCMODE_D_FLIPFLOP_SR | (1 << EN)
	movwf CLC2CON

_resetOutput:
	bsf CLC2POL, LC2G3POL ; reset
	nop
	bcf CLC2POL, LC2G3POL ; reset

	return

	end
