	#ifndef __KITCHENLEDS_POWERSUPPLY_POWERSUPPLY_INC
	#define __KITCHENLEDS_POWERSUPPLY_POWERSUPPLY_INC

	radix decimal

	#ifndef __KITCHENLEDS_POWERSUPPLY_ADCASVOLTAGEMONITOR_ASM
	extern _powerSupplyAdcInitialise
	#endif

	#ifndef __KITCHENLEDS_POWERSUPPLY_FVRASADCVREF_ASM
	extern _powerSupplyFvrInitialise
	#endif

	#ifndef __KITCHENLEDS_POWERSUPPLY_NCO1ASADCCONVERSIONTRIGGER_ASM
	extern _powerSupplyNco1Initialise
	#endif

	#ifndef __KITCHENLEDS_POWERSUPPLY_UDATA_ASM
	extern _powerSupplyBlankingTimer
	#endif

	#endif
