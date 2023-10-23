	#define __KITCHENLEDS_LEDPATTERNS_SWIPEINOUT_ASM
	#include "../config.inc"
	#include "../mcu.inc"
	#include "../rgb-leds.inc"
	#include "../working-registers.inc"
	#include "led-patterns.inc"

	radix decimal

_NUMBER_OF_BLITTED_PIXELS_PER_POLL equ 1
_NUMBER_OF_SHADES_PER_PALETTE_COLOUR equ 4

_CENTRE_LEFT_PIXEL_INDEX equ (CONFIG_NUMBER_OF_PIXELS - 1) >> 1
_CENTRE_RIGHT_PIXEL_INDEX equ CONFIG_NUMBER_OF_PIXELS >> 1

_FLAG_SWIPE_OUT equ 0
_FLAG_FRAME_DONE equ 1
_FLAG_ANIMATION_DONE equ 2

.ledpatternsSwipeInOutUdata udata
_flags res 1
_frameCounter res 1
_pixelCounter res 1
_numberOfPixelsPerStep res 1
_numberOfDelayFramesPerStep res 1
_leftIndex res 1
_rightIndex res 1
_currentPixelIndex res 1
_currentPixelValue res 1
_dimmestValue res 1

.ledpatterns code
	global _ledPatternsSwipeInOutInitialise
	global _ledPatternsSwipeInOutPoll
	global ledPatternsSwipeOut
	global ledPatternsSwipeIn

_ledPatternsSwipeInOutInitialise:
	banksel _flags
	clrf _flags
	bsf _flags, _FLAG_FRAME_DONE
	bsf _flags, _FLAG_SWIPE_OUT

	; TODO: START TEMPORARY DEBUGGING - THIS IS INITIALISATION CODE FOR PARAMETERS THAT SHOULD BE STORED IN FLASH SOMEWHERE...
	banksel _ledPatternsFirstColourRed
	movlw 4
	movwf _ledPatternsFirstColourRed
	movwf _ledPatternsFirstColourGreen
	movwf _ledPatternsFirstColourBlue

	movlw 7
	movwf _ledPatternsSecondColourRed
	movwf _ledPatternsSecondColourGreen
	movwf _ledPatternsSecondColourBlue
	; TODO: END TEMPORARY DEBUGGING

	banksel _pixelCounter
	clrf _pixelCounter

	movlw CONFIG_LEDPATTERNS_SWIPEINOUT_DEFAULT_NUMBER_OF_PIXELS_PER_STEP
	movwf _numberOfPixelsPerStep

	movlw CONFIG_LEDPATTERNS_SWIPEINOUT_DEFAULT_NUMBER_OF_DELAY_FRAMES_PER_STEP
	movwf _numberOfDelayFramesPerStep

	movlw 1
	movwf _frameCounter

_initialiseFirstIterationAsSwipeOut:
	movlw _CENTRE_LEFT_PIXEL_INDEX
	movwf _leftIndex

	movlw _CENTRE_RIGHT_PIXEL_INDEX
	movwf _rightIndex

	return


_ledPatternsSwipeInOutPoll:
	banksel _flags
	btfsc _flags, _FLAG_ANIMATION_DONE
	retlw 0

	btfss _flags, _FLAG_FRAME_DONE
	bra _blitNextBatchOfPixels

_delayUntilNumberOfFramesHasPassed:
	decfsz _frameCounter, F
	retlw 0

_resetStateForStartingNewSwipeInOrOutFrame:
	incf _numberOfDelayFramesPerStep, W
	movwf _frameCounter

	bcf _flags, _FLAG_FRAME_DONE
	btfss _flags, _FLAG_SWIPE_OUT
	bra _resetStateForStartingNewSwipeInFrame

_resetStateForStartingNewSwipeOutFrame:
	bra _resetStateForStartingNewFrame

_resetStateForStartingNewSwipeInFrame:

_resetStateForStartingNewFrame:
	movlw -1
	movwf _currentPixelIndex

	pagesel rgbLedsResetNextPixelPointer
	call rgbLedsResetNextPixelPointer

	pagesel rgbLedsEnableBlitting
	call rgbLedsEnableBlitting

_cacheColourParametersForDurationOfCurrentFrameWhilstDeterminingIfTheyHaveChanged:
	banksel _ledPatternsFirstColourRed
	movf _ledPatternsFirstColourRed, W
	banksel _dimmestValue
	movwf _dimmestValue

_blitNextBatchOfPixels:
	clrf _pixelCounter
	btfss _flags, _FLAG_SWIPE_OUT
	bra _swipeIn

_swipeOutBlitNextPixel:
	pagesel _tryStoreCurrentPixelValue
	call _tryStoreCurrentPixelValue
	xorlw 0
	btfsc STATUS, Z
	bra _swipeOutAllPixelsBlitted

_ifFirstPixelIsBrightestColourThenAnimationIsComplete:
	banksel _currentPixelIndex
	incfsz _currentPixelIndex, F
	bra _swipeOutBlitNextNonBrightestColour

	movf _dimmestValue, W
	addlw _NUMBER_OF_SHADES_PER_PALETTE_COLOUR - 1
	xorwf _currentPixelValue, W
	btfsc STATUS, Z
	bra _animationCompleted

_swipeOutBlitNextNonBrightestColour:
_swipeOutTestIfCurrentPixelWithinRangeOfStep:
	btfsc _leftIndex, 7
	bra _swipeOutTestIfCurrentPixelWithinRangeOfStep2 ; _leftIndex is negative so _currentPixelIndex is always greater

	movf _leftIndex, W
	subwf _currentPixelIndex, W
	btfss STATUS, C ; skip if _currentPixelIndex >= _leftIndex
	bra _swipeOutCurrentPixelUnchanged

_swipeOutTestIfCurrentPixelWithinRangeOfStep2:
	btfsc _rightIndex, 7
	bra _swipeOutCurrentPixelUnchanged ; _rightIndex is negative so _currentPixelIndex is always greater

	movf _currentPixelIndex, W
	subwf _rightIndex, W
	btfss STATUS, C ; skip if _currentPixelIndex <= _rightIndex:
	bra _swipeOutCurrentPixelUnchanged

_swipeOutCurrentPixelWithinRange:
_swipeOutTestIfCurrentPixelIsToBeChangedForFirstTime:
	movf _leftIndex, W
	addwf _numberOfPixelsPerStep, W
	btfsc WREG, 7
	bra _swipeOutTestIfCurrentPixelIsToBeChangedForFirstTime2 ; _leftIndex + _numberOfPixelsPerStep < 0 and _currentPixelIndex is always positive

	movwf workingA
	movf _currentPixelIndex, W
	subwf workingA, W
	btfsc STATUS, C ; do not skip if _currentPixelIndex < _leftIndex + _numberOfPixelsPerStep
	bra _swipeOutCurrentPixelHasNotBeenChangedBeforeAndNeedsSeeding

_swipeOutTestIfCurrentPixelIsToBeChangedForFirstTime2:
	movf _numberOfPixelsPerStep, W
	subwf _rightIndex, W
	btfsc WREG, 7
	bra _swipeOutCurrentPixelHasNotBeenChangedBeforeAndNeedsSeeding ; _rightIndex - _numberOfPixelsPerStep < 0 and _currentPixelIndex is always positive

	movwf workingA
	movf _currentPixelIndex, W
	subwf workingA, W
	btfsc STATUS, C ; skip if _currentPixelIndex > _rightIndex - _numberOfPixelsPerStep
	bra _swipeOutCurrentPixelHasBeenChangedBefore

_swipeOutCurrentPixelHasNotBeenChangedBeforeAndNeedsSeeding:
	movf _dimmestValue, W
	movwf _currentPixelValue
	bra _swipeOutBlitCurrentPixel

_swipeOutCurrentPixelHasBeenChangedBefore:
	movf _dimmestValue, W
	addlw _NUMBER_OF_SHADES_PER_PALETTE_COLOUR - 1
	xorwf _currentPixelValue, W
	btfsc STATUS, Z
	bra _swipeOutCurrentPixelUnchanged

_swipeOutBrightenCurrentPixel
	incf _currentPixelValue, F
	bra _swipeOutBlitCurrentPixel

_swipeOutCurrentPixelUnchanged:

_swipeOutBlitCurrentPixel:
	movf _currentPixelValue, W
	banksel rgbLedsPixelRed
	movwf rgbLedsPixelRed
	movwf rgbLedsPixelGreen
	movwf rgbLedsPixelBlue

	pagesel rgbLedsTryPutNextPixel
	call rgbLedsTryPutNextPixel

_swipeOutYieldIfCurrentBatchOfPixelsHasBeenBlitted:
	banksel _pixelCounter
	incf _pixelCounter, F
	movf _pixelCounter, W
	xorlw _NUMBER_OF_BLITTED_PIXELS_PER_POLL
	btfss STATUS, Z
	bra _swipeOutBlitNextPixel

	retlw 1


_swipeOutAllPixelsBlitted:
	banksel _flags
	bsf _flags, _FLAG_FRAME_DONE

	movf _numberOfPixelsPerStep, W
	subwf _leftIndex, F
	addwf _rightIndex, F

	retlw 0


_swipeIn:
	; TODO: FUNCTIONALITY NEEDS WRITING !


_animationCompleted:
	banksel _flags
	bsf _flags, _FLAG_ANIMATION_DONE

	pagesel rgbLedsDisableBlitting
	call rgbLedsDisableBlitting

	retlw 0


_tryStoreCurrentPixelValue:
	pagesel rgbLedsTryGetNextPixel
	call rgbLedsTryGetNextPixel
	xorlw 0
	btfsc STATUS, Z
	retlw 0

	banksel rgbLedsPixelRed
	movf rgbLedsPixelRed, W
	banksel _currentPixelValue
	movwf _currentPixelValue

	retlw 1


ledPatternsSwipeOut:
	; TODO: FUNCTIONALITY NEEDS WRITING !  Something like this, though:
;	banksel _leftIndex
;	movlw _CENTRE_LEFT_PIXEL_INDEX
;	movwf _leftIndex
;
;	movlw _CENTRE_RIGHT_PIXEL_INDEX
;	movwf _rightIndex

	return


ledPatternsSwipeIn:
	; TODO: FUNCTIONALITY NEEDS WRITING !  Something like this, though:
;	banksel _numberOfPixelsPerStep
;	decf _numberOfPixelsPerStep, W
;	movwf _leftIndex
;
;	movf _numberOfPixelsPerStep, W
;	sublw CONFIG_NUMBER_OF_PIXELS
;	movwf _rightIndex

	return

	end
