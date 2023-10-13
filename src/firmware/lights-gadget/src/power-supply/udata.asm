	#define __KITCHENLEDS_POWERSUPPLY_UDATA_ASM
	#include "power-supply.inc"

	radix decimal

.powersupplyUdata udata
	global _powerSupplyBlankingTimer
_powerSupplyBlankingTimer res 1

	end
