	#include "sm16703p-modulator.inc"

	radix decimal

_CLCDATA_TX_HELD_IN_RESET_AND_PORT_LATCHED_LOW equ (1 << MLC2OUT) | (1 << MLC1OUT)

.sm16703pmodulator code
	global rgbLedsModulatorIsBusy
	global sm16703pModulatorIsBusy

;
; Ascertain if the modulator is still busy / bits are being transmitted.
;
; Returns W=0 if the modulator is not in use, else W=1 if it's busy.
;
rgbLedsModulatorIsBusy:
sm16703pModulatorIsBusy:
_busyIfStillTransmitting:
	banksel TX1STA
	btfss TX1STA, TRMT
	retlw 1

_busyIfLedsAreNotBeingHeldInReset:
	banksel CLCDATA
	movlw _CLCDATA_TX_HELD_IN_RESET_AND_PORT_LATCHED_LOW
	andwf CLCDATA, W
	btfss STATUS, Z
	retlw 1 ; still modulating and transmitting bits (not reset, not held low) - need calling again

_notBusy:
	retlw 0

	end
