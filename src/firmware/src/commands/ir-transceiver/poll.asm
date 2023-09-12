	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiver code
	global irTransceiverPoll

;
; Polling for the infrared transceiver.
;
; Returns W=0 if no further polling is required, W!=0 if another poll is necessary in case of further work.
; Specifically:
;     W=1 if a byte was received; poll again as commands are multiple bytes and processing will be split across polls
;     W=2 if a framing error occurred; poll again to give any state machines a chance to progress
;     W=3 if an overrun error occurred and the receiver was reset; poll again in case of state change
;
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

	banksel TX2STA
	btfsc WREG, TRMT
	bcf TX2STA, TXEN

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

	movlw 1 ; return 1 (byte received, poll again)
	bra _resetReceiverIfShiftRegisterBufferOverflowed

_framingError:
	banksel RC2REG
	movf RC2REG, W

	pagesel irTransceiverOnReceiverFramingError
	call irTransceiverOnReceiverFramingError

	movlw 2 ; return 2 (framing error, poll again)
	bra _resetReceiverIfShiftRegisterBufferOverflowed

_didNotReceiveByte:
	movlw 0 ; return 0 (no byte received, don't poll again)

_resetReceiverIfShiftRegisterBufferOverflowed:
	banksel RC2STA
	btfss RC2STA, OERR
	return

	bcf RC2STA, CREN
	nop
	bsf RC2STA, CREN

	pagesel irTransceiverOnReceiverReset
	call irTransceiverOnReceiverReset

	retlw 3 ; return 3 (overflow error, receiver reset, poll again)

	end
