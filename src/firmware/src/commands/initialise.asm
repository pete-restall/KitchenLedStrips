	#include "../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.commands code
	global commandsInitialise

commandsInitialise:
	pagesel irTransceiverInitialise
	call irTransceiverInitialise

	return

	end
