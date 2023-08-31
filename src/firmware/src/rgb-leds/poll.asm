	#include "../mcu.inc"

	#include "frame-buffer.inc"
	#include "rgb-leds.inc"

	radix decimal

.rgbleds code
	global rgbLedsPoll

rgbLedsPoll:
	; TODO: This is temporary.  We really need a state machine:
	;   If waiting for frame to start, just return 0.
	;   If frame has just started, blit and call rgbLedsModulatorTryStartFrame (if unsuccessful then frame is running slow, so exit the poll so we can try again).
	;   Else just call blit - when blit returns '1' then our polling is done, at least until the next frame timer interrupt.

	pagesel frameBufferTryBlit
	call frameBufferTryBlit

	banksel LATC
	btfsc LATC, 5
	retlw 0

	bsf LATC, 5

	pagesel rgbLedsModulatorTryStartFrame
	call rgbLedsModulatorTryStartFrame

	retlw 1

	end
