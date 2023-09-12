	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiver code
	global irTransceiverPoll

irTransceiverPoll:
_disableCarrierIfFinishedTransmitting:
	banksel TX2STA
	movf TX2STA, W

	banksel CLCDATA
	btfsc CLCDATA, MLC2OUT
	bcf WREG, TRMT

	banksel T1CON
	btfsc WREG, TRMT
	bcf T1CON, ON_T1CON

_callEventHandlerIfReceivedByte:
	banksel PIR3
	btfss PIR3, RC2IF
	bra _didNotReceiveByte

	banksel RC2STA
	btfsc RC2STA, FERR
	bra _framingError

	banksel RC2REG
	movf RC2REG, W

	pagesel irTransceiverOnByteReceived
	call irTransceiverOnByteReceived

	bra _resetReceiverIfShiftRegisterBufferOverflowed

_framingError:
	banksel RC2REG
	movf RC2REG, W

	pagesel irTransceiverOnReceiverFramingError
	call irTransceiverOnReceiverFramingError

_didNotReceiveByte:
_resetReceiverIfShiftRegisterBufferOverflowed:
	banksel RC2STA
	btfss RC2STA, OERR
	return

	bcf RC2STA, CREN
	nop
	bsf RC2STA, CREN

	pagesel irTransceiverOnReceiverReset
	call irTransceiverOnReceiverReset

	return

	end
