	#define __KITCHENLEDS_RGBLEDS_NEXTPIXEL_ASM
	#include "../mcu.inc"
	#include "../working-registers.inc"

	#include "frame-buffer.inc"
	#include "rgb-leds.inc"

	radix decimal

.rgbledsTryPutNextPixel udata
_pixelLowPtr res 1
_pixelHighPtr res 1

.rgbleds code
	global _rgbLedsNextPixelInitialise
	global rgbLedsResetNextPixelPointer
	global rgbLedsTryPutNextPixel
	global rgbLedsTryGetNextPixel

_rgbLedsNextPixelInitialise:
rgbLedsResetNextPixelPointer:
	banksel _pixelLowPtr
	movlw low(frameBufferLinearStart)
	movwf _pixelLowPtr
	movlw high(frameBufferLinearStart)
	movwf _pixelHighPtr
	return


;
; Append the pixel (rgbLedsPixelRed, rgbLedsPixelGreen, rgbLedsPixelBlue) to the frame-buffer and advance the pixel pointer.
;
; Returns W=0 if the pointer has reached the end of the frame-buffer, W!=0 if there are more pixels that can be added.
;
rgbLedsTryPutNextPixel:
	pagesel _loadCurrentPixelPointer
	call _loadCurrentPixelPointer
	xorlw 0
	btfsc STATUS, Z
	retlw 0

_encodeComponentsAsFiveBitsOverTwoBytes_RRRRGGGG_BBBBrgb0:
	banksel rgbLedsPixelRed
	lsrf rgbLedsPixelRed, W
	rlf workingA, F
	andlw 0x0f
	movwf workingB
	swapf workingB, F

	lsrf rgbLedsPixelGreen, W
	rlf workingA, F
	andlw 0x0f
	iorwf workingB, W
	movwi FSR0++

	lsrf rgbLedsPixelBlue, W
	rlf workingA, F
	andlw 0x0f
	movwf workingB

	lslf workingA, W
	andlw 0x0e
	swapf workingB, F
	iorwf workingB, W
	movwi FSR0++

_saveCurrentPixelPointer:
	banksel _pixelHighPtr
	movf FSR0H, W
	movwf _pixelHighPtr
	movf FSR0L, W
	movwf _pixelLowPtr

_return0IfCurrentPixelPointerIsNowPastBufferEnd:
	xorlw low(frameBufferLinearPastEnd)
	return


;
; Load the pixel pointer into FSR0.
;
; Returns W=0 if the pointer was not loaded because it has gone beyond the end of the frame-buffer, W!=0 if successful.
;
_loadCurrentPixelPointer:
	banksel _pixelHighPtr
	movf _pixelHighPtr, W
	movwf FSR0H
	movf _pixelLowPtr, W
	movwf FSR0L

_return1IfCurrentPixelIsWithinFrameBuffer:
	xorlw low(frameBufferLinearPastEnd)
	btfss STATUS, Z
	retlw 1

_testHighByteSinceCurrentPixelMightBeOn256ByteBoundary:
	movf FSR0H, W
	xorlw high(frameBufferLinearPastEnd)
	return


;
; Read the component values from the pixel pointer into (rgbLedsPixelRed, rgbLedsPixelGreen, rgbLedsPixelBlue).
;
; Returns W=0 if the pointer is past the end of the frame-buffer, W!=0 if pixel values were able to be retrieved.
;
rgbLedsTryGetNextPixel:
	pagesel _loadCurrentPixelPointer
	call _loadCurrentPixelPointer
	xorlw 0
	btfsc STATUS, Z
	retlw 0

_decodeComponentsAsFiveBitsOverTwoBytes_RRRRGGGG_BBBBrgb0:
	banksel rgbLedsPixelRed
	moviw FSR0++
	movwf rgbLedsPixelRed
	movwf rgbLedsPixelGreen
	swapf rgbLedsPixelRed, F
	movlw 0x0f
	andwf rgbLedsPixelRed, F
	andwf rgbLedsPixelGreen, F

	moviw FSR0++
	swapf WREG, W
	movwf rgbLedsPixelBlue
	lslf WREG, W
	rlf rgbLedsPixelRed, F
	lslf WREG, W
	rlf rgbLedsPixelGreen, F
	lslf WREG, W
	rlf rgbLedsPixelBlue, W
	andlw 0x1f
	movwf rgbLedsPixelBlue

	retlw 1

	end
