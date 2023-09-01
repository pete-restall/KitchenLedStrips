	#define __KITCHENLEDS_RGBLEDS_TMR0FRAMESYNC_ASM
	#include "../mcu.inc"
	#include "rgb-leds.inc"

	radix decimal

	constrainedToMcuInstructionFrequencyHz 8000000 ; Timing-sensitive code

_T0CON0_POSTSCALER_9 equ (b'1000' << T0OUTPS0)
_T0CON1_FOSC_OVER_4 equ (b'010' << T0CS0)
_T0CON1_PRESCALER_128 equ (b'0111' << T0CKPS0)

.rgbleds code
	global frameSyncTimerInitialise

frameSyncTimerInitialise:
_setTimer0ToInterruptAtRoughly32Hz:
	banksel PMD1
	bcf PMD1, TMR0MD

	banksel TMR0H
	movlw 216 ; 32.002048...Hz (~0.0064% error, about 1 extra frame every 8 minutes or so)
	movwf TMR0H
	clrf TMR0L

	banksel T0CON1
	movlw _T0CON1_FOSC_OVER_4 | _T0CON1_PRESCALER_128
	movwf T0CON1

	banksel PIR0
	bcf PIR0, TMR0IF

	banksel T0CON0
	movlw _T0CON0_POSTSCALER_9 | (1 << EN)
	movwf T0CON0

	return

	end
