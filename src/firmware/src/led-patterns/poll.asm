	#include "../mcu.inc"
	#include "../rgb-leds.inc"
	#include "led-patterns.inc"

	radix decimal

.ledpatternsPollUdata udata
_frameCounter res 1

.ledpatterns code
	global ledPatternsPoll

ledPatternsPoll:
	banksel _ledPatternsFlags
	btfss _ledPatternsFlags, _LED_PATTERNS_FLAG_FRAMESYNC
	bra _pollCurrentPattern

_waitForNextFrame:
	banksel rgbLedsFrameCounter
	movf rgbLedsFrameCounter, W

	banksel _frameCounter
	xorwf _frameCounter, W
	btfsc STATUS, Z
	retlw 0

	banksel _ledPatternsFlags
	bcf _ledPatternsFlags, _LED_PATTERNS_FLAG_FRAMESYNC

_pollCurrentPattern:
	pagesel _ledPatternsBicolourInterlacedPoll
	call _ledPatternsBicolourInterlacedPoll

_returnIfPatternPollDidNotReturnZero:
	xorlw 0
	btfss STATUS, Z
	retlw 1

_setStateToWaitForNextFrameSincePatternPollReturnedZero:
	banksel _ledPatternsFlags
	bsf _ledPatternsFlags, _LED_PATTERNS_FLAG_FRAMESYNC

	banksel rgbLedsFrameCounter
	movf rgbLedsFrameCounter, W

	banksel _frameCounter
	movwf _frameCounter
	retlw 0

	end
