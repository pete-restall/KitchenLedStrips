	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc1AsModulatedOutput

sm16703pModulatorInitialiseClc1AsModulatedOutput:
	banksel PMD5
	bcf PMD5, CLC1MD

	banksel CLC1SEL0
	movlw _CLCSEL_CLC3_MODULATOR_OUT
	movwf CLC1SEL0

	movlw _CLCSEL_CLC2_NOTRESET_OUT
	movwf CLC1SEL1

	clrf CLC1GLS0
	bsf CLC1GLS0, LC1G1D1T

	clrf CLC1GLS1
	bsf CLC1GLS1, LC1G2D2T

	clrf CLC1GLS2
	clrf CLC1GLS3

	movlw (1 << LC1G3POL) | (1 << LC1G4POL)
	movwf CLC1POL

	movlw _CLCCON_LCMODE_AND4 | (1 << EN)
	movwf CLC1CON

	return

	end
