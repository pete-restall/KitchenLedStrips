	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc3AsMuxOfLongAndShortPwmsGatedByClc4

sm16703pModulatorInitialiseClc3AsMuxOfLongAndShortPwmsGatedByClc4:
	banksel PMD5
	bcf PMD5, CLC3MD

	banksel CLC3SEL0
	movlw _CLCSEL_CLC4_TXDATA_OUT
	movwf CLC3SEL0

	movlw _CLCSEL_PWM3_LONG
	movwf CLC3SEL1

	movlw _CLCSEL_PWM4_SHORT
	movwf CLC3SEL2

	clrf CLC3GLS0
	bsf CLC3GLS0, LC3G1D2T

	clrf CLC3GLS1
	bsf CLC3GLS1, LC3G2D1T

	clrf CLC3GLS2
	bsf CLC3GLS2, LC3G3D1N

	clrf CLC3GLS3
	bsf CLC3GLS3, LC3G4D3T

	clrf CLC3POL

	movlw _CLCCON_LCMODE_ANDOR | (1 << EN)
	movwf CLC3CON

	return

	end
