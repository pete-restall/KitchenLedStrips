	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_TRYBLIT_ASM
	#include "../../mcu.inc"

	#include "../rgb-leds.inc"

	#include "frame-buffer.inc"

	radix decimal

.framebufferUdata udata
_unpackedRgb:
_green res 1
_red res 1
_blue res 1

.framebuffer code
	global frameBufferTryBlit

;
; Blit the frame, or part of the frame; the LEDs' circular buffer will be filled as much as possible.
;
; Returns W=0 if there is still more to blit, W=1 if the entire frame has been blitted.
;
frameBufferTryBlit:
	banksel _frameBufferFlags
	movlw (1 << _FRAME_BUFFER_FLAG_FRAMESYNC) | (1 << _FRAME_BUFFER_FLAG_FRAMESYNC_BLIT)
	andwf _frameBufferFlags, W
	btfsc STATUS, Z
	retlw 1
	xorlw (1 << _FRAME_BUFFER_FLAG_FRAMESYNC) | (1 << _FRAME_BUFFER_FLAG_FRAMESYNC_BLIT)
	btfsc STATUS, Z
	retlw 1

_unpackCurrentFrameBufferPixel:
_unpackMostSignificantNybblesFromCurrentFrameBufferPixel:
	movf _frameBufferDisplayPtrLow, W
	movwf FSR0L
	movf _frameBufferDisplayPtrHigh, W
	movwf FSR0H

	banksel _unpackedRgb
	moviw FSR0++
	movwf _green
	movwf _red
	swapf _red, F

	moviw FSR0++
	swapf WREG, W
	movwf _blue

_prependLeastSignificantBitsOntoUnpackedColourComponents:
	lslf WREG, W
	rlf _red, F
	lslf WREG, W
	rlf _green, F
	lslf WREG, W
	rlf _blue, W

_applyGammaCorrectionToColourComponents:
	pagesel _gammaCorrection
	call _gammaCorrection
	movwf _blue

	movf _green, W
	call _gammaCorrection
	movwf _green

	movf _red, W
	call _gammaCorrection
	movwf _red

_tryPuttingUnpackedPixelIntoTransmissionBuffer:
	movlw low(_unpackedRgb)
	movwf FSR0L
	movlw high(_unpackedRgb)
	movwf FSR0H

	pagesel rgbLedsTryPutNextPixelIntoTransmissionBuffer
	call rgbLedsTryPutNextPixelIntoTransmissionBuffer
	xorlw 0
	btfsc STATUS, Z
	retlw 0

_updateFrameBufferPointerToNextPixel:
	banksel _frameBufferDisplayPtrLow
	movlw 2
	addwf _frameBufferDisplayPtrLow, F
	btfsc STATUS, C
	incf _frameBufferDisplayPtrHigh, F

_tryBlittingAnotherPixelIfNotOverrunTheFrameBuffer:
	movf _frameBufferDisplayPtrLowPastEnd, W
	xorwf _frameBufferDisplayPtrLow, W
	btfss STATUS, Z
	bra _unpackCurrentFrameBufferPixel

_resetFrameBufferPointerToStartOfBuffer:
	movlw low(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(_frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh

_flagThatBlittingHasCompletedForThisFrame:
	movlw (1 << _FRAME_BUFFER_FLAG_FRAMESYNC_BLIT)
	xorwf _frameBufferFlags, F
	retlw 1


_gammaCorrection:
	andlw b'00011111'
	brw
 ; TODO: TEMPORARY DEBUGGING - EVEN WITH TWO LEVELS, THE LEDS FLICKER WHEN UPDATING TO THE SAME VALUE AT 32FPS.  SUSPECT THE BREADBOARD DECOUPLING, MORE INVESTIGATION REQUIRED.
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0x00
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
 retlw 0xff
	retlw b'00000000'
	retlw b'00000000'
	retlw b'10000000'
	retlw b'10000000'
	retlw b'11000000'
	retlw b'10100000'
	retlw b'11100000'
	retlw b'01010000'
	retlw b'10110000'
	retlw b'10001000'
	retlw b'10101000'
	retlw b'01011000'
	retlw b'00000100'
	retlw b'01100100'
	retlw b'00110100'
	retlw b'00101100'
	retlw b'00111100'
	retlw b'00100010'
	retlw b'10110010'
	retlw b'11101010'
	retlw b'10000110'
	retlw b'00110110'
	retlw b'00011110'
	retlw b'00100001'
	retlw b'10001001'
	retlw b'11111001'
	retlw b'10110101'
	retlw b'00111101'
	retlw b'00110011'
	retlw b'00111011'
	retlw b'10110111'
	retlw b'11111111'

	end
