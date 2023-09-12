	#include "sm16703p-modulator.inc"

	radix decimal

_T2CON_PRESCALER_1 equ (b'000' << T2CKPS0)
_T2CON_POSTSCALER_8 equ (b'0111' << T2OUTPS0)

_T2CLKCON_FOSC_OVER_4 equ b'00000001'

_T2HLT_NO_PRESCALER_SYNC equ 0
_T2HLT_RISING_EDGE equ 0
_T2HLT_MODE_FREE equ 0
_T2HLT_MODE_SOFTGATE equ 0

_PR2_800KHZ equ 9

.sm16703pmodulator code
	global _sm16703pModulatorInitialiseTimer2ForPwm

_sm16703pModulatorInitialiseTimer2ForPwm:
	banksel PMD1
	bcf PMD1, TMR2MD

	banksel T2CON
	movlw _T2CON_PRESCALER_1 | _T2CON_POSTSCALER_8
	movwf T2CON

	movlw _T2CLKCON_FOSC_OVER_4
	movwf T2CLKCON

	movlw _T2HLT_NO_PRESCALER_SYNC | _T2HLT_RISING_EDGE | _T2HLT_MODE_FREE | _T2HLT_MODE_SOFTGATE
	movwf T2HLT

	movlw _PR2_800KHZ
	movwf PR2
	clrf TMR2

	return

	end
