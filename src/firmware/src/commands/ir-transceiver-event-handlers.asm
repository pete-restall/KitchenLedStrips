	#include "../mcu.inc"
	#include "commands.inc"

	radix decimal

.commands code
	global irTransceiverOnByteReceived
	global irTransceiverOnReceiverFramingError
	global irTransceiverOnReceiverTimeout
	global irTransceiverOnReceiverReset

irTransceiverOnByteReceived:
	banksel _commandsIrTransceiverState
	btfsc _commandsIrTransceiverState, _COMMANDS_IRSTATE_FLAG_RECEIVED_WAKEUP
	bra _consumeByte

_ensureWakeupByteReceived:
	xorlw 0x00
	btfsc STATUS, Z
	bsf _commandsIrTransceiverState, _COMMANDS_IRSTATE_FLAG_RECEIVED_WAKEUP
	return

_consumeByte:
	xorlw 0
	btfss STATUS, Z
	movlw 0x1f

	; !!! TODO: START OF TEMPORARY DEBUGGING (STORE THE RECEIVED VALUE AS THE CURRENT COLOUR) !!!
	extern _ledPatternsFirstColourRed
	extern _ledPatternsFirstColourGreen
	extern _ledPatternsFirstColourBlue

	banksel _ledPatternsFirstColourRed
	movwf _ledPatternsFirstColourRed
	clrf _ledPatternsFirstColourGreen
	clrf _ledPatternsFirstColourBlue

	extern _ledPatternsSecondColourRed
	extern _ledPatternsSecondColourGreen
	extern _ledPatternsSecondColourBlue
	clrf _ledPatternsSecondColourRed
	movwf _ledPatternsSecondColourGreen
	clrf _ledPatternsSecondColourBlue

	banksel _commandsIrTransceiverState
	clrf _commandsIrTransceiverState
	; !!! TODO: END OF TEMPORARY DEBUGGING !!!
	return


irTransceiverOnReceiverFramingError:
irTransceiverOnReceiverTimeout:
irTransceiverOnReceiverReset:
	banksel _commandsIrTransceiverState
	clrf _commandsIrTransceiverState
	return

	end
