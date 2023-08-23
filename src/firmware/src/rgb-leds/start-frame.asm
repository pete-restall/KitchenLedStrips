	#include "rgb-leds.inc"

	radix decimal

.rgbleds code
	global rgbLedsStartFrame

;
; Start frame transmission.  Once started, the circular buffer must not be allowed to empty until all LEDs have been addressed.
; At 8MIPS and an LED baud of 800kbps, there are 80 instructions between colour components (bytes) needing to be transmitted.
;
rgbLedsStartFrame:
_transmitDummyByteToAllowIsrAndClcPrimingTime:
	banksel TX1REG
	clrf TX1REG

_enablePwmChannelsForUartBitModulation:
	banksel T2CON
	clrf TMR2
	bsf T2CON, EN

_releaseResetOnNextByteBoundary:
	banksel CLC2POL
	bsf CLC2POL, LC2G2POL ; data

_enableCircularBufferTransmission:
	banksel PIE3
	bsf PIE3, TX1IE ; TODO !  WE SEEM TO BE STARTING ONE BIT TOO EARLY AGAIN, AND SENDING THE LAST BIT OF THE DUMMY BYTE

	return

	end
