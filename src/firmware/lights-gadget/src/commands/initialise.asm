	#include "../mcu.inc"
	#include "commands.inc"
	#include "ir-transceiver.inc"

	radix decimal

.commands code
	global commandsInitialise

commandsInitialise:
	banksel _commandsIrTransceiverState
	clrf _commandsIrTransceiverState

	pagesel irTransceiverInitialise
	call irTransceiverInitialise

	return

	end
