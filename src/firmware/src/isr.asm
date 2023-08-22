	radix decimal

	#include "mcu.inc"

.isrSharedData udata
	global _txUnreadCount ;;;;;;;; TODO: ENCAPSULATE THIS BETTER - MACRO ?

_txReadPtrLow res 1
_txUnreadCount res 1

.isrTxBuffer udata
_txBufferStart res 1
	res 26 * 3 - 2
_txBufferEnd res 1
_txBufferPastEnd:

_txWritePtrLow equ FSR1L_SHAD
_txWritePtrHigh equ FSR1H_SHAD

.isr code 0x0004
	global isr
	global isrTxBufferReset

isr:
	banksel PIR3
	btfss PIR3, TX1IF
	reset ; interrupt cause was something other than the UART buffer being empty - unhandled at present so just reset

_tx1Isr:
	banksel _txReadPtrLow ; TODO: SEE IF THIS IS OPTIMISED AWAY; IF NOT THEN REMOVE IT SINCE IT'S A SHARED BANK (USE AN ASSERTION TO ENFORCE THIS)
	movf _txReadPtrLow, W
	movwf FSR1L ; FSR1H will already hold the correct value from the mainline code since it is used as _txWritePtrHigh

_tx1BufferPossiblyEmpty:
	movf _txUnreadCount, F
	btfsc STATUS, Z
	bra _tx1BufferEmpty ; _txReadPtrLow == _txWritePtrLow && _txUnreadCount == 0, so circular buffer is empty and there are no more bytes to transmit

_tx1ReadFromCircularBuffer:
	decf _txUnreadCount, F
	banksel TX1REG
	moviw FSR1++
	movwf TX1REG

_tx1WrapAndStoreCircularBufferReadPtr:
	banksel _txReadPtrLow
	movlw low(_txBufferEnd) + 1
	xorwf FSR1L, W
	movlw low(_txBufferStart)
	btfsc STATUS, Z
	movwf FSR1L ; _txReadPtrLow == _txBufferEnd, so reset the pointer to one byte before _txBufferStart

_tx1ReadFromCircularBufferCompleted:
	movf FSR1L, W
	movwf _txReadPtrLow
	retfie

_tx1BufferEmpty:
	banksel CLC2POL
	bcf CLC2POL, LC2G2POL ; data

	banksel PIE3
	bcf PIE3, TX1IE
	retfie


isrTxBufferReset:
	; TODO: ASSERTION THAT end - start is not more than 255 bytes
	banksel _txUnreadCount
	clrf _txUnreadCount

_resetTxReadPtrToStartOfBuffer:
	banksel _txReadPtrLow
	movlw low(_txBufferStart)
	movwf _txReadPtrLow

_resetTxWritePtrToStartOfBuffer:
	banksel _txWritePtrLow
	movlw low(_txBufferStart)
	movwf _txWritePtrLow
	movwf FSR1L

_setHighByteOfTxReadAndWritePtr:
	banksel _txWritePtrHigh
	movlw high(_txBufferStart)
	movwf _txWritePtrHigh
	movwf FSR1H

	return

	end
