	#include "rgb-leds.inc"

	radix decimal

	constrainedToMcuInstructionFrequencyHz 8000000 ; Timing-sensitive code

.rgbleds code
	global rgbLedsStartFrame

;
; Start frame transmission.  Once started, the circular buffer must not be allowed to empty until all LEDs have been addressed.
; At 8MIPS and an LED baud of 800kbps, there are 80 instructions between colour components (bytes) needing to be transmitted.
; One bit thus takes 10 instructions.
;
rgbLedsStartFrame:
_transmitDummyByteToAllowIsrAndClcPrimingTime:
	banksel TX1REG
	clrf TX1REG

_enablePwmChannelsForUartBitModulation:
	banksel T2CON
	clrf TMR2

_burn9CyclesToCompensateForPrescaledTimer2IntoClc2ResetRegisterBeingOneBitBehindPlusSettlingTimeForUartBitOnRisingEdge:
	movlw 3
	decfsz WREG, W
	bra $ - 1
	bsf T2CON, EN

_releaseResetOnNextByteBoundary:
	banksel CLC2POL
	bsf CLC2POL, LC2G2POL ; data

_enableCircularBufferTransmission:
	banksel PIE3
	bsf PIE3, TX1IE

	return

	end
