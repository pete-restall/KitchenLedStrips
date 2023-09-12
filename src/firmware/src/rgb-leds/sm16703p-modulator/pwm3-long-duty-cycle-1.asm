	#include "sm16703p-modulator.inc"

	radix decimal

_DUTYCYCLE equ 29

.sm16703pmodulator code
	global _sm16703pModulatorInitialisePwm3AsLongDutyCycleForOnes

_sm16703pModulatorInitialisePwm3AsLongDutyCycleForOnes:
	banksel PMD3
	bcf PMD3, PWM3MD

	banksel PWM3DCL
	movlw (_DUTYCYCLE << 6) & b'11000000'
	movwf PWM3DCL

	movlw (_DUTYCYCLE >> 2) & b'00111111'
	movwf PWM3DCH

	bsf PWM3CON, EN

	return

	end
