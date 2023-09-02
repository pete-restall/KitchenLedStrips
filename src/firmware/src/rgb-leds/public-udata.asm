	#define __KITCHENLEDS_RGBLEDS_PUBLICUDATA_ASM
	#include "rgb-leds.inc"

	radix decimal

.rgbledsUdata udata
	global rgbLedsPixelRed
	global rgbLedsPixelGreen
	global rgbLedsPixelBlue
rgbLedsPixelRed res 1
rgbLedsPixelGreen res 1
rgbLedsPixelBlue res 1

	end
