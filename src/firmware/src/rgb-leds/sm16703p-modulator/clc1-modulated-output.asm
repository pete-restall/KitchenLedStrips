	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc1AsModulatedOutput

sm16703pModulatorInitialiseClc1AsModulatedOutput:
	banksel PMD5
	bcf PMD5, CLC1MD

	banksel CLC1SEL0
	movlw _CLCSEL_CLC3OUT_TXDATA
	movwf CLC1SEL0

	movlw _CLCSEL_PWM3_LONG
	movwf CLC1SEL1

	movlw _CLCSEL_PWM4_SHORT
	movwf CLC1SEL2

	movlw _CLCSEL_CLC2OUT_NOTRESET
	movwf CLC1SEL3

	clrf CLC1GLS0 ; 3-input AND (inputs and output need to be inverted), table 31-3 of DS40001853C
	bsf CLC1GLS0, LC1G1D1N ; ! (TX)
	bsf CLC1GLS0, LC1G1D2N ; ! (PWM3)
	bsf CLC1GLS0, LC1G1D4N ; ! (!RESET)

	clrf CLC1GLS1

	clrf CLC1GLS2

	clrf CLC1GLS3 ; 3-input AND (inputs and output need to be inverted), table 31-3 of DS40001853C
	bsf CLC1GLS2, LC1G4D1T ; ! (!TX)
	bsf CLC1GLS3, LC1G4D3N ; ! (PWM4)
	bsf CLC1GLS3, LC1G4D4N ; ! (!RESET)

	clrf CLC1POL
	bsf CLC1POL, LC1G1POL
	bsf CLC1POL, LC1G2POL
	bsf CLC1POL, LC1G3POL
	bsf CLC1POL, LC1G4POL

	movlw _CLCCON_LCMODE_ANDOR | (1 << EN)
	movwf CLC1CON

	return

	end
