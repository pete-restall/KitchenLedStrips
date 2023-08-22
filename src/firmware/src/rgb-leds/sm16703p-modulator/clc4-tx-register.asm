	#include "sm16703p-modulator.inc"

	radix decimal

.sm16703pmodulator code
	global sm16703pModulatorInitialiseClc4AsUart1DtRegisterClockedByLongPwm

sm16703pModulatorInitialiseClc4AsUart1DtRegisterClockedByLongPwm:
_initialiseClc4AsUart1DtRegisterClockedByLongPwm:
	banksel PMD5
	bcf PMD5, CLC4MD

	banksel CLC4SEL0
	movlw _CLCSEL_UART1_DT
	movwf CLC4SEL0

	movlw _CLCSEL_PWM3_LONG
	movwf CLC4SEL1

	clrf CLC4GLS0
	bsf CLC4GLS0, LC4G1D2N ; clock

	clrf CLC4GLS1
	bsf CLC4GLS1, LC4G2D1T ; data

	clrf CLC4GLS2
	clrf CLC4GLS3

	clrf CLC4POL

	movlw _CLCCON_LCMODE_D_FLIPFLOP_SR | (1 << EN)
	movwf CLC4CON

	return

	end
