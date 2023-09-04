	#define __KITCHENLEDS_RGBLEDS_TMR0FRAMESYNC_ASM
	#include "../mcu.inc"
	#include "rgb-leds.inc"

	radix decimal

	constrainedToMcuInstructionFrequencyHz 8000000 ; Timing-sensitive code

;
; A frame-rate of 32Hz gives the longest time to calculate the pixel values but when interlacing to mix colours there is a lot of flicker.
; Higher frame-rates (>= 2 * ~25 = ~50Hz) avoid the flickering when interlacing but the computation time for frames is significantly reduced.
; A frame-rate of 50Hz provides (a maximum of) around 1000 instructions per LED in a strip of 128.
;
; Prescaler    Postscaler    TMR0H    F (Hz)        Error
;       128             9      216    32.002048...  ~0.0064%, about 1 frame every 8 minutes or so
;        64            12      216    48.003072...  ~0.0064%
;       256             5      124    50            0
;        64            15      138    60._82725060_ ~0.0799%
;        64             9      216    64.004096...  ~0.0064%
;

_T0CON0_POSTSCALER_5 equ (b'0100' << T0OUTPS0)
_T0CON0_POSTSCALER_9 equ (b'1000' << T0OUTPS0)
_T0CON0_POSTSCALER_15 equ (b'1110' << T0OUTPS0)
_T0CON0_POSTSCALER_12 equ (b'1011' << T0OUTPS0)
_T0CON1_FOSC_OVER_4 equ (b'010' << T0CS0)
_T0CON1_PRESCALER_64 equ (b'0110' << T0CKPS0)
_T0CON1_PRESCALER_128 equ (b'0111' << T0CKPS0)
_T0CON1_PRESCALER_256 equ (b'1000' << T0CKPS0)

.rgbleds code
	global frameSyncTimerInitialise

frameSyncTimerInitialise:
_setTimer0ToInterruptAtRoughly32Hz:
	banksel PMD1
	bcf PMD1, TMR0MD

	banksel TMR0H
	movlw 124
	movwf TMR0H
	clrf TMR0L

	banksel T0CON1
	movlw _T0CON1_FOSC_OVER_4 | _T0CON1_PRESCALER_256
	movwf T0CON1

	banksel PIR0
	bcf PIR0, TMR0IF

	banksel T0CON0
	movlw _T0CON0_POSTSCALER_5 | (1 << EN)
	movwf T0CON0

	return

	end
