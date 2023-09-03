	#include "../mcu.inc"
	#include "frame-buffer.inc"
	#include "rgb-leds.inc"

	radix decimal

.rgbleds code
	global rgbLedsPoll

rgbLedsPoll:
_continueBlitting:
	pagesel frameBufferTryBlit
	call frameBufferTryBlit
	xorlw 0
	btfsc STATUS, Z
	retlw 1 ; not finished blitting - need calling again

_blittingDoneButReturnIfModulatorIsStillBusy:
	pagesel rgbLedsModulatorIsBusy
	call rgbLedsModulatorIsBusy
	xorlw 0
	btfss STATUS, Z
	retlw 1 ; modulator still transmitting - need calling again

_stopModulatorTimerAndIncrementFrameCounter:
	banksel T2CON
	btfss T2CON, EN
	bra _waitForFrameSync

	bcf T2CON, EN
	banksel rgbLedsFrameCounter
	incf rgbLedsFrameCounter, F

_waitForFrameSync:
	banksel PIR0
	btfss PIR0, TMR0IF
	retlw 0 ; waiting for frame sync - don't need calling again for a while
	bcf PIR0, TMR0IF

_syncFrameBufferAndStartBlitting:
	pagesel frameBufferSyncAndTryBlit
	call frameBufferSyncAndTryBlit

	pagesel rgbLedsModulatorTryStartFrame
	call rgbLedsModulatorTryStartFrame
	retlw 1 ; the circular buffer might be filled but the transmission won't have completed - need calling again

	end
