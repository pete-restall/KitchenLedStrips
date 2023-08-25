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


.frameBuffer0 udata
	global frameBuffer0Start
	global frameBuffer0End
	global frameBuffer0PastEnd
frameBuffer0Start res 63
frameBuffer0End res 1
frameBuffer0PastEnd:

.frameBuffer1 udata
	global frameBuffer1Start
	global frameBuffer1End
	global frameBuffer1PastEnd
frameBuffer1Start res 63
frameBuffer1End res 1
frameBuffer1PastEnd:


.palette0 udata
	global palette1Start
	global palette1End
	global palette1PastEnd
palette0Start res 47
palette0End res 1
palette0PastEnd:

.palette1 udata
	global palette1Start
	global palette1End
	global palette1PastEnd
palette1Start res 47
palette1End res 1
palette1PastEnd:

.palette2 udata
	global palette2Start
	global palette2End
	global palette2PastEnd
palette2Start res 47
palette2End res 1
palette2PastEnd:

.palette3 udata
	global palette3Start
	global palette3End
	global palette3PastEnd
palette3Start res 47
palette3End res 1
palette3PastEnd:

	end
