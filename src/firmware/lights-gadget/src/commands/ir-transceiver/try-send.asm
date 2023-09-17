	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiver code
	global irTransceiverTrySend

irTransceiverTrySend:
	banksel TX2STA
	btfss TX2STA, TXEN
	bra _startTransmission

	banksel PIR3
	btfss PIR3, TX2IF
	retlw 0

_startTransmission:
	banksel T1CON
	btfss T1CON, ON_T1CON
	bsf T1CON, ON_T1CON

	banksel TX2STA
	bsf TX2STA, TXEN
	movwf TX2REG

	retlw 1

	end
