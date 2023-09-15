	#define __KITCHENLEDS_LEDPATTERNS_BICOLOURINTERLACED_ASM
	#include "../mcu.inc"
	#include "../rgb-leds.inc"
	#include "../working-registers.inc"
	#include "led-patterns.inc"

	radix decimal

_NUMBER_OF_BLITTED_PIXEL_PAIRS_PER_POLL equ 8

_FLAG_FRAME_ODD equ 0
_FLAG_FRAME_DONE equ 1
_FLAG_FRAME_INTERLACING_DISABLED equ 2

.ledpatternsBicolourInterlacedUdata udata
_flags res 1
_pixelPairCounter res 1
_firstRed res 1
_firstGreen res 1
_firstBlue res 1
_secondRed res 1
_secondGreen res 1
_secondBlue res 1

.ledpatterns code
	global _ledPatternsBicolourInterlacedInitialise
	global _ledPatternsBicolourInterlacedPoll
	global ledPatternsBicolourInterlacedEnableInterlacing
	global ledPatternsBicolourInterlacedDisableInterlacing

_ledPatternsBicolourInterlacedInitialise:
	banksel _flags
	clrf _flags
	bsf _flags, _FLAG_FRAME_DONE

	banksel _ledPatternsFirstColourRed ; TODO: TEMPORARY INITIALISATION CODE - PARAMETERS SHOULD BE STORED IN FLASH
	movlw 0x1f
	movwf _ledPatternsFirstColourRed
	movlw 0x1e
	movwf _ledPatternsFirstColourGreen
	movlw 0x13
	movwf _ledPatternsFirstColourBlue

	movlw 0x1f
	movwf _ledPatternsSecondColourRed
	movlw 0x1e
	movwf _ledPatternsSecondColourGreen
	movlw 0x13
	movwf _ledPatternsSecondColourBlue
	return


_ledPatternsBicolourInterlacedPoll:
	banksel _flags
	btfss _flags, _FLAG_FRAME_DONE
	bra _blitNextBatchOfPixels

_resetStateForStartingNewFrame:
	bcf _flags, _FLAG_FRAME_DONE
	movlw (1 << _FLAG_FRAME_ODD)
	xorwf _flags, F

	movlw _NUMBER_OF_BLITTED_PIXEL_PAIRS_PER_POLL
	movwf _pixelPairCounter

	pagesel rgbLedsResetNextPixelPointer
	call rgbLedsResetNextPixelPointer

_cacheColourParametersForDurationOfCurrentFrameWhilstDeterminingIfTheyHaveChanged:
	clrf workingA
	banksel _ledPatternsFirstColourRed
	movf _ledPatternsFirstColourRed, W
	banksel _firstRed
	xorwf _firstRed, F
	btfss STATUS, Z
	bsf workingA, 0
	movwf _firstRed

	banksel _ledPatternsFirstColourGreen
	movf _ledPatternsFirstColourGreen, W
	banksel _firstGreen
	xorwf _firstGreen, F
	btfss STATUS, Z
	bsf workingA, 0
	movwf _firstGreen

	banksel _ledPatternsFirstColourBlue
	movf _ledPatternsFirstColourBlue, W
	banksel _firstBlue
	xorwf _firstBlue, F
	btfss STATUS, Z
	bsf workingA, 0
	movwf _firstBlue

	banksel _ledPatternsSecondColourRed
	movf _ledPatternsSecondColourRed, W
	banksel _secondRed
	xorwf _secondRed, F
	btfss STATUS, Z
	bsf workingA, 1
	movwf _secondRed

	banksel _ledPatternsSecondColourGreen
	movf _ledPatternsSecondColourGreen, W
	banksel _secondGreen
	xorwf _secondGreen, F
	btfss STATUS, Z
	bsf workingA, 1
	movwf _secondGreen

	banksel _ledPatternsSecondColourBlue
	movf _ledPatternsSecondColourBlue, W
	banksel _secondBlue
	xorwf _secondBlue, F
	btfss STATUS, Z
	bsf workingA, 1
	movwf _secondBlue

_ifColoursHaveChangedSinceLastFrameOrInterlacingIsEnabledThenBlittingMustBeDone:
	btfss _flags, _FLAG_FRAME_INTERLACING_DISABLED
	bra _thisFrameNeedsBlitting

	movf workingA, F
	btfss STATUS, Z
	bra _thisFrameNeedsBlitting

_coloursAreUnchangedAndNoInterlacingIsRequiredSoDisableBlitting:
	pagesel rgbLedsDisableBlitting
	call rgbLedsDisableBlitting
	bra _allPixelsBlitted

_thisFrameNeedsBlitting:
	pagesel rgbLedsEnableBlitting
	call rgbLedsEnableBlitting

_blitNextBatchOfPixels:
	btfsc _flags, _FLAG_FRAME_ODD
	bra _blitOddFrame

_blitEvenFrame:
	pagesel _blitFirstColour
	call _blitFirstColour
	btfsc STATUS, Z
	bra _allPixelsBlitted

	pagesel _blitSecondColour
	call _blitSecondColour
	btfsc STATUS, Z
	bra _allPixelsBlitted

	bra _pixelPairBlitted

_blitOddFrame:
	pagesel _blitSecondColour
	call _blitSecondColour
	btfsc STATUS, Z
	bra _allPixelsBlitted

	pagesel _blitFirstColour
	call _blitFirstColour
	btfsc STATUS, Z
	bra _allPixelsBlitted

_pixelPairBlitted:
	banksel _pixelPairCounter
	decfsz _pixelPairCounter, F
	bra _blitNextBatchOfPixels
	retlw 1

_allPixelsBlitted:
	bsf _flags, _FLAG_FRAME_DONE
	retlw 0


_blitFirstColour:
	banksel _firstRed
	movf _firstRed, W
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed

	banksel _firstGreen
	movf _firstGreen, W
	banksel rgbLedsPixelGreen
	movwf rgbLedsPixelGreen

	banksel _firstBlue
	movf _firstBlue, W
	banksel rgbLedsPixelBlue
	movwf rgbLedsPixelBlue

	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	xorlw 0
	return


_blitSecondColour:
	banksel _secondRed
	movf _secondRed, W
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed

	banksel _secondGreen
	movf _secondGreen, W
	banksel rgbLedsPixelGreen
	movwf rgbLedsPixelGreen

	banksel _secondBlue
	movf _secondBlue, W
	banksel rgbLedsPixelBlue
	movwf rgbLedsPixelBlue

	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel
	xorlw 0
	return


ledPatternsBicolourInterlacedEnableInterlacing:
	banksel _flags
	bcf _flags, _FLAG_FRAME_INTERLACING_DISABLED
	return


ledPatternsBicolourInterlacedDisableInterlacing:
	banksel _flags
	bsf _flags, _FLAG_FRAME_INTERLACING_DISABLED
	return

	end
