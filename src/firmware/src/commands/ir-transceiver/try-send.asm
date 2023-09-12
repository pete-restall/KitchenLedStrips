	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiver code
	global irTransceiverTrySend

irTransceiverTrySend:
	banksel PIR3
	btfss PIR3, TX2IF
	retlw 0

	banksel T1CON
	bsf T1CON, ON_T1CON

	banksel TX2REG
	movwf TX2REG
	retlw 1

	end
