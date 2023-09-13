	#include "sm16703p-modulator.inc"

	radix decimal

	constrainedToMcuInstructionFrequencyHz 8000000 ; Timing-sensitive code

.sm16703pmodulator code
	global rgbLedsModulatorTryStartFrame
	global sm16703pModulatorTryStartFrame

;
; Try to start the next frame transmission.  Once started, the circular buffer must not be allowed to empty until all LEDs have
; been addressed.  At 8MIPS and an LED baud of 800kbps, there are 80 instructions between colour components (bytes) needing to
; be transmitted.  One bit thus takes 10 instructions.
;
; Returns W=0 if a frame is still in progress, else W=1 if successfully started transmission.
;
rgbLedsModulatorTryStartFrame:
sm16703pModulatorTryStartFrame:
_ensureFrameNotInProgress:
	banksel T2CON
	btfsc T2CON, EN
	retlw 0

_disableInterruptsToPreventTimingIssuesAndResetBaudRateCounter:
	bcf INTCON, GIE
	banksel TX1REG
	movf SP1BRGH, F

_transmitDummyByteToAllowIsrAndClcResetPrimingTime:
	clrf TX1REG

_enablePwmChannelsForUartBitModulation:
	banksel T2CON
	clrf TMR2

_burn12CyclesToCompensateForPrescaledTimer2IntoClc4ResetRegisterBeingOneBitBehindPlusSettlingTimeForUartBitOnRisingEdge:
;;;;;;; TODO: VERIFY THIS ON THE BENCH - CAN IT BE REMOVED / DOES IT IMPROVE THE TIMING MARGIN ?
;	movlw 3
;	decfsz WREG, W
;	bra $ - 1
	bsf T2CON, EN

_releaseResetOnNextByteBoundary:
	banksel CLC4POL
	bsf CLC4POL, LC4G2POL ; data

_enableCircularBufferTransmissionByRestoringInterrupts:
	banksel PIE3
	bsf PIE3, TX1IE
	bsf INTCON, GIE

	retlw 1

	end
