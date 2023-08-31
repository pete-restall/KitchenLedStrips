	#define __KITCHENLEDS_RGBLEDS_UDATABUFFERS_ASM
	#include "rgb-leds.inc"

	radix decimal

.animationBuffer0 udata
	global animationBufferStart ; 512-byte linear-access buffer
animationBufferStart res 80

.animationBuffer1 udata
	res 80
.animationBuffer2 udata
	res 80
.animationBuffer3 udata
	res 80
.animationBuffer4 udata
	res 80
.animationBuffer5 udata
	res 80
.animationBuffer6 udata
	global animationBufferEnd
	global animationBufferPastEnd
	res 31
animationBufferEnd res 1
animationBufferPastEnd:

	end
