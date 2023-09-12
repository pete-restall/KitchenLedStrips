	#include "sm16703p-modulator.inc"

	radix decimal

_DUTYCYCLE equ 10

.sm16703pmodulator code
	global _sm16703pModulatorInitialisePwm4AsShortDutyCycleForZeroes

_sm16703pModulatorInitialisePwm4AsShortDutyCycleForZeroes:
	banksel PMD3
	bcf PMD3, PWM4MD

	banksel PWM4DCL
	movlw (_DUTYCYCLE << 6) & b'11000000'
	movwf PWM4DCL

	movlw (_DUTYCYCLE >> 2) & b'00111111'
	movwf PWM4DCH

	bsf PWM4CON, EN

	return

	end
