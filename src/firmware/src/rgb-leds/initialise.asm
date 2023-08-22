	#include "rgb-leds.inc"
	#include "sm16703p-modulator.inc"

	radix decimal

	extern isrTxBufferReset

.rgbleds code
	global rgbLedsInitialise

rgbLedsInitialise:
	pagesel isrTxBufferReset
	call isrTxBufferReset

	pagesel sm16703pModulatorInitialise
	call sm16703pModulatorInitialise

	return

	end
