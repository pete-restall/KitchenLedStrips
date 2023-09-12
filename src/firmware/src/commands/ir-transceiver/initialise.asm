	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

.irtransceiver code
	global irTransceiverInitialise

irTransceiverInitialise:
	pagesel irTransceiverInitialiseUart2
	call irTransceiverInitialiseUart2

	pagesel _irTransceiverInitialiseTimer1ForDoubledCarrierWave
	call _irTransceiverInitialiseTimer1ForDoubledCarrierWave

	pagesel _irTransceiverInitialiseCcp1ForDoubledCarrierWave
	call _irTransceiverInitialiseCcp1ForDoubledCarrierWave

	pagesel _irTransceiverInitialiseClc2AsModulatedOutput
	call _irTransceiverInitialiseClc2AsModulatedOutput

	pagesel _irTransceiverInitialiseClc3AsUart2TxBodgeWire
	call _irTransceiverInitialiseClc3AsUart2TxBodgeWire

	return

	end
