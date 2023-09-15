	#include "frame-buffer.inc"
	#include "rgb-leds.inc"

	radix decimal

	extern isrTxBufferReset

.rgbleds code
	global rgbLedsInitialise

rgbLedsInitialise:
	banksel _rgbLedsPollState
	clrf _rgbLedsPollState

	pagesel isrTxBufferReset
	call isrTxBufferReset

	pagesel rgbLedsModulatorInitialise
	call rgbLedsModulatorInitialise

	pagesel frameBufferInitialise
	call frameBufferInitialise

	pagesel frameSyncTimerInitialise
	call frameSyncTimerInitialise

	pagesel _rgbLedsNextPixelInitialise
	call _rgbLedsNextPixelInitialise

	banksel rgbLedsFrameCounter
	clrf rgbLedsFrameCounter

	return

	end
