	#include "config.inc"
	#include "isr.inc"
	#include "mcu.inc"
	#include "power-supply.inc"

	radix decimal

	constrainedToMcuInstructionFrequencyHz 8000000 ; Timing-sensitive code

	extern _powerSupplyBlankingTimer

.isrSharedData udata
	global _txUnreadCount

_txReadPtrLow res 1
_txUnreadCount res 1

.isrTxBuffer udata
	global _txBufferStart
	global _txBufferEnd
	global _txBufferPastEnd

	#if (RGBLEDS_NUMBER_OF_BYTES_IN_TX_BUFFER > 255)
		error "The ISR is written in such a way that the circular buffer must not exceed 255 bytes; this simplifies bounds checking."
	#endif

_txBufferStart res 1
	res RGBLEDS_NUMBER_OF_BYTES_IN_TX_BUFFER - 2
_txBufferEnd res 1
_txBufferPastEnd:

_adcValue res 1

_txWritePtrLow equ FSR1L_SHAD
_txWritePtrHigh equ FSR1H_SHAD

.isr code 0x0004
	global isr
	global isrTxBufferReset

isr:
	banksel PIE3
	btfss PIE3, TX1IE
	bra _checkNonTx1Interrupts

	banksel PIR3
	btfss PIR3, TX1IF
	bra _checkNonTx1Interrupts

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
	movlw low(_txBufferPastEnd)
	xorwf FSR1L, W
	movlw low(_txBufferStart)
	btfsc STATUS, Z
	movwf FSR1L ; _txReadPtrLow == _txBufferPastEnd, so reset the pointer to _txBufferStart

_tx1ReadFromCircularBufferCompleted:
	banksel _txReadPtrLow
	movf FSR1L, W
	movwf _txReadPtrLow
	bra _checkNonTx1Interrupts

_tx1BufferEmpty:
_disableLedBitstreamOutputOnNextByteBoundary:
	banksel CLC4POL
	bcf CLC4POL, LC4G2POL ; data

	banksel PIE3
	bcf PIE3, TX1IE

_reEnableAdcInterruptForPowerSupplyMonitoringNowTheHigherFrequencyTransmissionInterruptHasBeenDisabled:
	banksel PIE1
	bsf PIE1, ADIE

_checkNonTx1Interrupts:
	banksel ADCON0
	btfss ADCON0, ADON
	retfie

_checkForNewPowerSupplyVoltageSample:
	banksel PIR1
	btfss PIR1, ADIF
	bra _checkPowerGoodFlagOfLedPowerSwitch
	bcf PIR1, ADIF

_skipMonitoringDuringRampUpBlankingTime:
	banksel _powerSupplyBlankingTimer
	movf _powerSupplyBlankingTimer, W
	btfss STATUS, Z
	bra _powerSupplyStillRampingUp

_checkPowerSupplyVoltageIsWithinInclusiveRange:
	banksel ADRESH
	movf ADRESH, W

	banksel _adcValue ; TODO: SHOULD BE OPTIMISED AWAY
	movwf _adcValue
	sublw CONFIG_POWERMONITOR_VHIGH
	btfss STATUS, C
	bra _powerMonitoringFailure

	movlw CONFIG_POWERMONITOR_VLOW
	subwf _adcValue, W
	btfss STATUS, C
	bra _powerMonitoringFailure

_checkPowerGoodFlagOfLedPowerSwitch:
	banksel _powerSupplyBlankingTimer
	movf _powerSupplyBlankingTimer, W
	btfss STATUS, Z
	retfie

	banksel PORTB
	btfss PORTB, RB4
	bra _powerMonitoringFailure

	banksel IOCBF
	btfss IOCBF, RB4
	retfie

_powerSupplyStillRampingUp:
	decfsz _powerSupplyBlankingTimer, F
	retfie

_unmuteLedBitstreamTransmissionAndResetPowerGoodNowThatPowerSupplyHasRampedUp:
	banksel CLC4POL
	bcf CLC4POL, LC4G2POL ; data
	bcf CLC4POL, LC4G3POL ; reset

	banksel IOCBF
	bcf IOCBF, RB4
	retfie

_powerMonitoringFailure:
_disablePowerSupplyAndLedBitstreamOutputImmediately:
	pagesel powerSupplyDisable
	call powerSupplyDisable

_alsoDisableLedBitstreamTransmissionInterrupt:
	banksel PIE3
	bcf PIE3, TX1IE
	retfie


isrTxBufferReset:
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
