	#define __KITCHENLEDS_COMMANDS_IRTRANSCEIVER_UDATA_ASM
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiverUdata udata
	global _irTransceiverLastReceivedByteTimestamp
	global _irTransceiverPollState
_irTransceiverLastReceivedByteTimestamp res 1
_irTransceiverPollState res 1

	end
