	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global _sm16703pModulatorInitialiseClc4AsByteSynchronisedReset

_sm16703pModulatorInitialiseClc4AsByteSynchronisedReset:
	banksel PMD5
	bcf PMD5, CLC4MD

	banksel CLC4SEL0
	movlw _CLCSEL_TMR2_POSTSCALED
	movwf CLC4SEL0

	clrf CLC4GLS0
	bsf CLC4GLS0, LC4G1D1T ; clock

	clrf CLC4GLS1
	clrf CLC4GLS2
	clrf CLC4GLS3

	clrf CLC4POL

	movlw _CLCCON_LCMODE_D_FLIPFLOP_SR | (1 << EN)
	movwf CLC4CON

_resetOutput:
	bsf CLC4POL, LC4G3POL ; reset
	nop
	bcf CLC4POL, LC4G3POL ; reset

	return

	end
