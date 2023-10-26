	#define __KITCHENLEDS_POWERSUPPLY_FVRASADCVREF_ASM

	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

_FVRCON_ADFVR_4V096 equ (b'11' << ADFVR0)

.powersupply code
	global _powerSupplyFvrInitialise

_powerSupplyFvrInitialise:
	banksel PMD0
	bcf PMD0, FVRMD

_initialiseFixedVoltageReferenceForAdc:
	banksel FVRCON
	movlw _FVRCON_ADFVR_4V096 | (1 << FVREN)
	movwf FVRCON

	return

	end
