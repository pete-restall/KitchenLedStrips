	#define __KITCHENLEDS_MAIN_ASM
	#include "commands.inc"
	#include "initialise.inc"
	#include "led-patterns.inc"
	#include "main.inc"
	#include "mcu.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"
	#include "working-registers.inc"

	radix decimal

.mainUdata udata
	global mainTimebaseLow
	global mainTimebaseHigh
mainTimebaseLow res 1
mainTimebaseHigh res 1
_isMorePollingRequired res 1

.main code
	global main

main:
	pagesel initialise
	call initialise

	banksel INTCON
	bsf INTCON, PEIE
	bsf INTCON, GIE

	banksel mainTimebaseLow
	clrf mainTimebaseLow
	clrf mainTimebaseHigh

	; !!! TODO: START OF TEMPORARY DEBUGGING !!!
;	extern _frameBufferRedPalette
;	extern _frameBufferGreenPalette
;	extern _frameBufferBluePalette
;	movlw 0xff
;	banksel _frameBufferRedPalette
;	movwf _frameBufferRedPalette
;	clrf _frameBufferRedPalette + 1
;	banksel _frameBufferGreenPalette
;	clrf _frameBufferGreenPalette
;	movwf _frameBufferGreenPalette + 1
;	banksel _frameBufferBluePalette
;	clrf _frameBufferBluePalette
;	clrf _frameBufferBluePalette + 1
	; !!! TODO: END OF TEMPORARY DEBUGGING !!!

_pollingLoop:
	clrwdt

_incrementMainTimebaseIfFrameCounterHasChanged:
	banksel rgbLedsFrameCounter
	movf rgbLedsFrameCounter, W

	banksel mainTimebaseLow
	xorwf mainTimebaseLow, W
	btfsc STATUS, Z
	bra _startPolling

	incf mainTimebaseLow, F
	btfsc STATUS, Z
	incf mainTimebaseHigh, F

_startPolling:
	clrf _isMorePollingRequired

_pollRgbLedsModule:
	pagesel rgbLedsPoll
	call rgbLedsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_pollLedPatternsModule:
	pagesel ledPatternsPoll
	call ledPatternsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_pollCommandsModule:
	pagesel commandsPoll
	call commandsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_sleepIfNoMorePollingIsRequired:
	banksel _isMorePollingRequired
	movf _isMorePollingRequired, F
	btfss STATUS, Z
	bra _pollingLoop

	pagesel powerManagementSleep
	call powerManagementSleep

	; !!! TODO: START OF TEMPORARY DEBUGGING (TRANSMIT COLOUR NUMBER OVER IR LED) !!!
	banksel mainTimebaseLow
	movf mainTimebaseLow, W
	banksel _frameCount
	xorwf _frameCount, W
	btfss STATUS, Z
	bra _pollingLoop

	movlw 25
	addwf _frameCount, F
	movlw (1 << 5)
	banksel LATC
	xorwf LATC, F

	clrw

	extern irTransceiverTrySend
	pagesel irTransceiverTrySend
	call irTransceiverTrySend

	clrw
	banksel LATC
	btfsc LATC, 5
	movlw 1

	call irTransceiverTrySend


	pagesel ledPatternsBicolourInterlacedDisableInterlacing
	call ledPatternsBicolourInterlacedDisableInterlacing

	; !!! TODO: END OF TEMPORARY DEBUGGING !!!

	bra _pollingLoop







	; TODO: BELOW HERE IS FOR DEBUGGING PURPOSES - REMOVE WHEN MORE FUNCTIONALITY HAS BEEN COMPLETED:

.TEMPORARY_DEBUGGING_UDATA udata
_frameCount res 1
_throbValue res 1
_throbDirection res 1

.TEMPORARY_DEBUGGING_CODE code
_TEMPORARY_DEBUGGING:
	banksel rgbLedsFrameCounter
	movf rgbLedsFrameCounter, W

	banksel _frameCount
	xorwf _frameCount, W
	btfss STATUS, Z
	bra _updatePixels

	movlw 8;32 * 1
	addwf _frameCount, F

_throb:
	movf _throbDirection, F
	movlw 1
	btfsc STATUS, Z
	movlw -1
	addwf _throbValue, W
	andlw 0x1f
	movwf _throbValue
	btfss STATUS, Z
	bra _updatePixels

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

_updatePixels:
	pagesel rgbLedsResetNextPixelPointer
	call rgbLedsResetNextPixelPointer

;	banksel _throbValue
;	movlw 0x1e
;	movwf _throbValue

	banksel rgbLedsFrameCounter
	btfsc rgbLedsFrameCounter, 0
	bra _pattern2

_pattern1:
	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw -1
	call _putWhite

	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw 1
	call _putWhite

	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw -1
	call _putWhite
	bra _done

_pattern2:
	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw 1
	call _putWhite

	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw -1
	call _putWhite

	banksel _throbValue
	movf _throbValue, W
	btfss _throbValue, 0
	addlw 1
	call _putWhite

_done:
	banksel LATC
	movlw 1 << 5
	xorwf LATC, F
	return

_putRed:
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed
	clrf rgbLedsPixelGreen
	clrf rgbLedsPixelBlue
	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	return

_putGreen:
	banksel rgbLedsPixelRed
	clrf rgbLedsPixelRed
	movwf rgbLedsPixelGreen
	clrf rgbLedsPixelBlue
	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	return

_putBlue:
	banksel rgbLedsPixelRed
	clrf rgbLedsPixelRed
	clrf rgbLedsPixelGreen
	movwf rgbLedsPixelBlue
	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	return

_putWhite:
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed
	movwf rgbLedsPixelGreen
	movwf rgbLedsPixelBlue
;	xorlw 1
;	btfss STATUS, Z
;	lsrf rgbLedsPixelBlue, F

	movwf workingA
	movlw 152 ; 152/256 * blue
	call _mul8x8
	movf workingB, W
	movwf rgbLedsPixelBlue


;	swapf workingA, W
;	andlw 0x0f
;	swapf workingB, F
;	iorwf workingB, W
;	movwf rgbLedsPixelBlue

	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	return


_mul8x8:
	clrf workingB
	clrf workingC
	bsf workingC, 3
	rrf workingA, F

_mul8x8Loop:
	btfsc STATUS, C
	addwf workingB, F

	rrf workingB, F
	rrf workingA, F

	decfsz workingC, F
	bra _mul8x8Loop
	return

	end
