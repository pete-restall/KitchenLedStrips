	#include "mcu.inc"

	radix decimal

	config FEXTOSC=OFF
	config RSTOSC=HFINT32
	config CLKOUTEN=OFF
	config CSWEN=OFF
	config FCMEN=OFF
	config MCLRE=ON
	config PWRTE=ON
	config LPBOREN=OFF
	config BOREN=ON
	config BORV=LO
	config ZCD=OFF
	config PPS1WAY=OFF
	config STVREN=ON
	config WDTE=NSLEEP
	config WDTCCS=HFINTOSC
	config WDTCWS=WDTCWS_6
	config WDTCPS=WDTCPS_3
	config BBEN=OFF
	config SAFEN=ON
	config WRTAPP=ON
	config WRTB=ON
	config WRTC=ON
	config WRTSAF=OFF
	config LVP=ON
	config CP=OFF

	end
