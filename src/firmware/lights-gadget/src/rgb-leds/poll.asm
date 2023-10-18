	#define __KITCHENLEDS_RGBLEDS_POLL_ASM
	#include "../config.inc"
	#include "../mcu.inc"
	#include "../pins.inc"
	#include "frame-buffer.inc"
	#include "rgb-leds.inc"

	radix decimal

.rgbledsUdata udata
	global _rgbLedsPollState
_rgbLedsPollState res 1

.rgbleds code
	global rgbLedsPoll

rgbLedsPoll:
_continueBlitting:
	pagesel frameBufferTryBlit
	call frameBufferTryBlit
	xorlw 0
	btfsc STATUS, Z
	retlw 1 ; not finished blitting - need calling again

_testIfBlittingHasCompletedForTheCurrentPartitionOrTheEntireFrame:
	xorlw _FRAME_BUFFER_TRYBLIT_WAITING_PARTITIONSYNC
	btfss STATUS, Z
	bra _blittingFrameDoneButReturnIfModulatorIsStillBusy

_blittingFirstPartitionDoneButReturnIfModulatorIsStillBusy:
	pagesel rgbLedsModulatorIsBusy
	call rgbLedsModulatorIsBusy
	xorlw 0
	btfss STATUS, Z
	retlw 1 ; modulator still transmitting - need calling again

_stopModulatorTimerNowThatPartition0HasBeenBlittedAndModulatorHasFinished:
	banksel T2CON
	bcf T2CON, EN

_directPinsBackToAppropriateLedStripForPartition1:
	pinsDirectClc1outToLedsForPartition1

	pagesel frameBufferSyncPartitionAndTryBlit
	call frameBufferSyncPartitionAndTryBlit

	pagesel rgbLedsModulatorTryStartFrame
	call rgbLedsModulatorTryStartFrame
	retlw 1 ; the circular buffer might be filled but the transmission won't have completed - need calling again

_blittingFrameDoneButReturnIfModulatorIsStillBusy:
	pagesel rgbLedsModulatorIsBusy
	call rgbLedsModulatorIsBusy
	xorlw 0
	btfss STATUS, Z
	retlw 1 ; modulator still transmitting - need calling again

_stopModulatorTimerNowThatFrameHasBeenBlittedAndModulatorHasFinished:
	banksel T2CON
	bcf T2CON, EN

_directPinsBackToAppropriateLedStripForPartition0:
	pinsDirectClc1outToLedsForPartition0

_waitForFrameSync:
	banksel PIR0
	btfss PIR0, TMR0IF
	retlw 0 ; waiting for frame sync - don't need calling again for a while
	bcf PIR0, TMR0IF

	banksel rgbLedsFrameCounter
	incf rgbLedsFrameCounter, F

_enableOrDisableBlittingOnlyOnFrameSync:
	banksel _rgbLedsPollState
	btfsc _rgbLedsPollState, _POLL_FLAG_DISABLE_BLITTING
	retlw 0 ; don't blit - don't need calling again for a while

_syncFrameBufferAndStartBlitting:
	pagesel frameBufferSyncFrameAndTryBlit
	call frameBufferSyncFrameAndTryBlit

	pagesel rgbLedsModulatorTryStartFrame
	call rgbLedsModulatorTryStartFrame
	retlw 1 ; the circular buffer might be filled but the transmission won't have completed - need calling again

	end
