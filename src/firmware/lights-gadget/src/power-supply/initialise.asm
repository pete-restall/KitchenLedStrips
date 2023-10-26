	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

	constrainedToMcuClockFrequencyHz 32000000 ; Timing-sensitive code

.powersupply code
	global powerSupplyInitialise

powerSupplyInitialise:
	banksel _powerSupplyBlankingTimer
	clrf _powerSupplyBlankingTimer

	pagesel _powerSupplyFvrInitialise
	call _powerSupplyFvrInitialise

	pagesel _powerSupplyNco1Initialise
	call _powerSupplyNco1Initialise

	pagesel _powerSupplyAdcInitialise
	call _powerSupplyAdcInitialise

	banksel PMD0
	bcf PMD0, IOCMD

	return

	end
