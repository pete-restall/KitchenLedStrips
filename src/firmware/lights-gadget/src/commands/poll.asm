	#include "../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.commands code
	global commandsPoll

commandsPoll:
	pagesel irTransceiverPoll
	call irTransceiverPoll
	return

	end
