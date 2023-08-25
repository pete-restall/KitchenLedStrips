	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc3AsUart1DtRegisterClockedByLongPwm

sm16703pModulatorInitialiseClc3AsUart1DtRegisterClockedByLongPwm:
_initialiseClc3AsUart1DtRegisterClockedByLongPwm:
	banksel PMD5
	bcf PMD5, CLC3MD

	banksel CLC3SEL0
	movlw _CLCSEL_UART1_DT
	movwf CLC3SEL0

	movlw _CLCSEL_PWM3_LONG
	movwf CLC3SEL1

	clrf CLC3GLS0
	bsf CLC3GLS0, LC3G1D2T ; clock

	clrf CLC3GLS1
	bsf CLC3GLS1, LC3G2D1T ; data

	clrf CLC3GLS2
	clrf CLC3GLS3

	clrf CLC3POL

	movlw _CLCCON_LCMODE_D_FLIPFLOP_SR | (1 << EN)
	movwf CLC3CON

	return

	end
