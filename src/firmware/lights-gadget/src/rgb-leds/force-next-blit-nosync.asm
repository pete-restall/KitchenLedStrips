	#include "rgb-leds.inc"

	radix decimal

.rgbleds code
	global rgbLedsForceNextBlitBeforeFrameSync

rgbLedsForceNextBlitBeforeFrameSync:
	banksel _rgbLedsPollState
	bsf _rgbLedsPollState, _POLL_FLAG_FORCE_BLIT
	return

	end
