	#define __KITCHENLEDS_RGBLEDS_TMR0FRAMESYNC_ASM
	#include "../mcu.inc"
	#include "rgb-leds.inc"

	radix decimal

	constrainedToMcuClockFrequencyHz 32000000 ; Timing-sensitive code

;
; A frame-rate of 32Hz gives the longest time to calculate the pixel values but when interlacing to mix colours there is a lot of flicker.
; Higher frame-rates (>= 2 * ~60 = ~120Hz) avoid the flickering when interlacing but the computation time for frames is minimal.  A
; frame-rate of 50Hz provides (a maximum of) around 1000 instructions per LED in a strip of 128 but interlacing is not viable.
;
; For the frame sync to work during sleep it must be derived from HFINTOSC and not synchronous to the instruction clock.
;
; Prescaler    Postscaler    TMR0H    F (Hz)        Error
;       512             9      216    32.002048...  ~0.0064%, about 1 frame every 8 minutes or so
;       256            12      216    48.003072...  ~0.0064%
;      1024             5      124    50            0
;       256            15      138    59.952038...  ~0.0799%
;       256             9      216    64.004096...  ~0.0064%
;

_T0CON0_POSTSCALER_5 equ (b'0100' << T0OUTPS0)
_T0CON0_POSTSCALER_9 equ (b'1000' << T0OUTPS0)
_T0CON0_POSTSCALER_15 equ (b'1110' << T0OUTPS0)
_T0CON0_POSTSCALER_12 equ (b'1011' << T0OUTPS0)
_T0CON1_HFINTOSC equ (b'011' << T0CS0)
_T0CON1_ASYNC_TO_INSTRUCTIONS equ (1 << T0ASYNC)
_T0CON1_PRESCALER_256 equ (b'1000' << T0CKPS0)
_T0CON1_PRESCALER_512 equ (b'1001' << T0CKPS0)
_T0CON1_PRESCALER_1024 equ (b'1010' << T0CKPS0)

.rgbleds code
	global frameSyncTimerInitialise

frameSyncTimerInitialise:
_setTimer0ToInterruptAt50Hz:
	banksel PMD1
	bcf PMD1, TMR0MD

	banksel TMR0H
	movlw 124
	movwf TMR0H
	clrf TMR0L

	banksel T0CON1
	movlw _T0CON1_HFINTOSC | _T0CON1_PRESCALER_1024 | _T0CON1_ASYNC_TO_INSTRUCTIONS
	movwf T0CON1

	banksel PIR0
	bcf PIR0, TMR0IF

	banksel T0CON0
	movlw _T0CON0_POSTSCALER_5 | (1 << EN)
	movwf T0CON0

	return

	end
