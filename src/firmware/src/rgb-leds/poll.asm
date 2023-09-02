	#include "../mcu.inc"
	#include "../working-registers.inc"

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

_stopModulatorTimer:
	banksel T2CON
	bcf T2CON, EN

_waitForFrameSync:
	banksel PIR0
	btfss PIR0, TMR0IF
	retlw 0 ; waiting for frame sync - don't need calling again for a while
	bcf PIR0, TMR0IF

	; TODO: THIS IS TEMPORARY DEBUGGING
	pagesel _TEMPORARY_DEBUGGING
	call _TEMPORARY_DEBUGGING

_syncFrameBufferForBlitting:
	banksel _frameBufferFlags
	movlw (1 << 0);_FRAME_BUFFER_FLAG_FRAMESYNC)
	xorwf _frameBufferFlags, F

_fillCircularBufferAndStartTransmissionOfFrame:
	pagesel frameBufferTryBlit
	call frameBufferTryBlit
	movwf workingD

	pagesel rgbLedsModulatorTryStartFrame
	call rgbLedsModulatorTryStartFrame

_returnUsingResultOfAttemptedBlit:
	movf workingD, W
	btfsc STATUS, Z
	retlw 1 ; blitting didn't succeed (in its entirety) - need calling again
	retlw 0 ; blitting was completed - don't need calling again for a while



	; TODO: BELOW HERE IS FOR DEBUGGING PURPOSES - REMOVE WHEN MORE FUNCTIONALITY HAS BEEN COMPLETED:

.TEMPORARY_DEBUGGING_UDATA udata
_frameCount res 1
_throbValue res 1
_throbDirection res 1

.TEMPORARY_DEBUGGING_CODE code
_TEMPORARY_DEBUGGING:
	banksel _frameCount
	decfsz _frameCount, F
	return

	movlw 2
	movwf _frameCount

_throb:
	movf _throbDirection, F
	movlw 1
	btfsc STATUS, Z
	movlw -1
	addwf _throbValue, W
	andlw 0x1f
	movwf _throbValue
	btfss STATUS, Z
	bra _updatePixel

_reverseThrob:
	clrw
	movf _throbDirection, F
	btfss STATUS, Z
	movlw 0x1e
	movwf _throbValue ; adjust pixel backwards because of overflow on increment

	clrw
	movf _throbDirection, F
	btfsc STATUS, Z
	movlw 1
	movwf _throbDirection

_updatePixel:
; use _throbValue to populate first pixel...
	extern _frameBufferStart
	extern _frameBufferFlags
	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart ; RRRR GGGG  BBBB rgb_
	bcf _frameBufferStart + 1, 3
	btfsc STATUS, C
	bsf _frameBufferStart + 1, 3
	movlw 0x0f
	andwf _frameBufferStart + 0, F
	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart
	swapf WREG, W
	iorwf _frameBufferStart + 0, F

	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart ; RRRR GGGG  BBBB rgb_
	bcf _frameBufferStart + 3, 2
	btfsc STATUS, C
	bsf _frameBufferStart + 3, 2
	movlw 0xf0
	andwf _frameBufferStart + 2, F
	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart
	iorwf _frameBufferStart + 2, F

	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart ; RRRR GGGG  BBBB rgb_
	bcf _frameBufferStart + 5, 1
	btfsc STATUS, C
	bsf _frameBufferStart + 5, 1
	movlw 0x0f
	andwf _frameBufferStart + 5, F
	banksel _throbValue
	lsrf _throbValue, W
	banksel _frameBufferStart
	swapf WREG, W
	iorwf _frameBufferStart + 5, F

	banksel LATC
	movlw 1 << 5
	xorwf LATC, F
	return

	end
