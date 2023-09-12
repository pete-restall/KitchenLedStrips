	#include "../mcu.inc"

	radix decimal

.commands code
	global irTransceiverOnByteReceived
	global irTransceiverOnReceiverFramingError
	global irTransceiverOnReceiverReset

irTransceiverOnByteReceived:
irTransceiverOnReceiverFramingError:
irTransceiverOnReceiverReset:
	return

	end
