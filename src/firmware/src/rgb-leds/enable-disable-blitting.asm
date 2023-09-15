	#include "rgb-leds.inc"

	radix decimal

.rgbleds code
	global rgbLedsEnableBlitting
	global rgbLedsDisableBlitting

rgbLedsEnableBlitting:
	banksel _rgbLedsPollState
	bcf _rgbLedsPollState, _POLL_FLAG_DISABLE_BLITTING
	return


rgbLedsDisableBlitting:
	banksel _rgbLedsPollState
	bsf _rgbLedsPollState, _POLL_FLAG_DISABLE_BLITTING
	return

	end
