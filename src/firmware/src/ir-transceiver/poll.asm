	#include "../mcu.inc"
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

_appendToCircularBufferIfReceivedByte:
	banksel PIR3
	btfss PIR3, RC2IF
	bra _didNotReceiveByte

	; TODO: APPEND TO CIRCULAR BUFFER
	; TODO: HANDLE FRAMING ERROR (RC2STA.FERR) - JUST IGNORE THE BYTE / DO NOT APPEND IT TO THE CIRCULAR BUFFER

	banksel RC2REG
	movf RC2REG, W

	; TODO: THIS IS JUST DEBUGGING - ECHO THE RECEIVED CHARACTER BACK OUT TO CREATE A CONTINUOUS SEND-RECEIVE-ECHO LOOP
	banksel T1CON
	bsf T1CON, ON_T1CON

	banksel TX2REG
	movwf TX2REG

	banksel LATC
	xorlw 0xaa
	btfss STATUS, Z
	bsf LATC, 4 ; Green LED off...


_didNotReceiveByte:
_resetReceiverIfShiftRegisterBufferOverflowed:
	banksel RC2STA
	btfsc RC2STA, OERR
	bcf RC2STA, CREN
	nop
	bsf RC2STA, CREN


	; TODO: THIS IS TEMPORARY FOR DEBUGGING PURPOSES

	banksel LATC
	btfsc LATC, 5
	return

	bsf LATC, 5

	banksel T1CON
	bsf T1CON, ON_T1CON

	banksel TX2REG
	movlw 0xaa
	movwf TX2REG

	return

	end
