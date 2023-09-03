	#include "initialise.inc"
	#include "mcu.inc"
	#include "power-management.inc"
	#include "rgb-leds.inc"

	radix decimal

.mainUdata udata
_isMorePollingRequired res 1

.main code
	global main

main:
	pagesel initialise
	call initialise

	banksel INTCON
	bsf INTCON, PEIE
	bsf INTCON, GIE

_pollingLoop:
	clrwdt
	banksel _isMorePollingRequired
	clrf _isMorePollingRequired

_pollRgbLedsModule:
	pagesel rgbLedsPoll
	call rgbLedsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

	pagesel _TEMPORARY_DEBUGGING ; TODO: TEMPORARY DEBUGGING !
	call _TEMPORARY_DEBUGGING

_sleepIfNoMorePollingIsRequired:
	banksel _isMorePollingRequired
	movf _isMorePollingRequired, F
	btfss STATUS, Z
	bra _pollingLoop

	pagesel powerManagementSleep
	call powerManagementSleep
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
	return

	movlw 2
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
	pagesel rgbLedsResetNextPixelPointer
	call rgbLedsResetNextPixelPointer

	banksel _throbValue
	movf _throbValue, W
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed
	clrf rgbLedsPixelGreen
	clrf rgbLedsPixelBlue
	call rgbLedsTryPutNextPixel

	banksel _throbValue
	movf _throbValue, W
	banksel rgbLedsPixelRed
	clrf rgbLedsPixelRed
	movwf rgbLedsPixelGreen
	clrf rgbLedsPixelBlue
	call rgbLedsTryPutNextPixel

	banksel _throbValue
	movf _throbValue, W
	banksel rgbLedsPixelRed
	clrf rgbLedsPixelRed
	clrf rgbLedsPixelGreen
	movwf rgbLedsPixelBlue
	call rgbLedsTryPutNextPixel

	banksel LATC
	movlw 1 << 5
	xorwf LATC, F
	return

	end
