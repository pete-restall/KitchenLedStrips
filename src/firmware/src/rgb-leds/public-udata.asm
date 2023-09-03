	#define __KITCHENLEDS_RGBLEDS_PUBLICUDATA_ASM
	#include "rgb-leds.inc"

	radix decimal

.rgbledsUdata udata
	global rgbLedsFrameCounter
	global rgbLedsPixelRed
	global rgbLedsPixelGreen
	global rgbLedsPixelBlue
rgbLedsFrameCounter res 1
rgbLedsPixelRed res 1
rgbLedsPixelGreen res 1
rgbLedsPixelBlue res 1

	end
