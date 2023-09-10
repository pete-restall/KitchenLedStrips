	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_TRYBLIT_ASM
	#include "../../mcu.inc"

	#include "../rgb-leds.inc"

	#include "frame-buffer.inc"

	radix decimal

	constrainedToFrameBufferOf256BytesOrLess

.framebufferUdata udata
_unpackedRgb:
_green res 1
_red res 1
_blue res 1

.framebuffer code
	global frameBufferSyncAndTryBlit
	global frameBufferTryBlit

;
; Synchronise and then try blitting the frame, or part of the frame; the LEDs' circular buffer will be filled as much as possible.
;
; Returns W=0 if there is still more to blit, W=1 if the entire frame has been blitted.
;
frameBufferSyncAndTryBlit:
	banksel _frameBufferFlags
	movlw (1 << _FRAME_BUFFER_FLAG_FRAMESYNC)
	xorwf _frameBufferFlags, F


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

_testIfUnpackingAlreadyDoneButThereWasNoSpaceInCircularBuffer:
	btfsc _frameBufferFlags, _FRAME_BUFFER_FLAG_RGB_UNPACKED
	bra _tryPuttingUnpackedPixelIntoTransmissionBuffer
	bsf _frameBufferFlags, _FRAME_BUFFER_FLAG_RGB_UNPACKED

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

_lookUpEightBitColourComponentsFromFiveBitComponentPalettes:
	pagesel _bluePaletteLookup
	call _bluePaletteLookup
	movwf _blue

	pagesel _greenPaletteLookup
	movf _green, W
	call _greenPaletteLookup
	movwf _green

	pagesel _redPaletteLookup
	movf _red, W
	call _redPaletteLookup
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
	movlw low(frameBufferLinearPastEnd)
	xorwf _frameBufferDisplayPtrLow, W
	btfss STATUS, Z
	bra _unpackCurrentFrameBufferPixel

_resetFrameBufferPointerToStartOfBuffer:
	movlw low(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh

_flagThatBlittingHasCompletedForThisFrame:
	bcf _frameBufferFlags, _FRAME_BUFFER_FLAG_RGB_UNPACKED
	movlw (1 << _FRAME_BUFFER_FLAG_FRAMESYNC_BLIT)
	xorwf _frameBufferFlags, F
	retlw 1


_redPaletteLookup:
	andlw b'00011111'
	addlw low(_frameBufferRedPalette)
	movwf FSR0L
	clrf FSR0H
	movlw high(_frameBufferRedPalette)
	addwfc FSR0H, F
	movf INDF0, W
	return

_greenPaletteLookup:
	andlw b'00011111'
	addlw low(_frameBufferGreenPalette)
	movwf FSR0L
	clrf FSR0H
	movlw high(_frameBufferGreenPalette)
	addwfc FSR0H, F
	movf INDF0, W
	return

_bluePaletteLookup:
	andlw b'00011111'
	addlw low(_frameBufferBluePalette)
	movwf FSR0L
	clrf FSR0H
	movlw high(_frameBufferBluePalette)
	addwfc FSR0H, F
	movf INDF0, W
	return

	end
