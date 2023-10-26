	#define __KITCHENLEDS_POWERSUPPLY_ADCASVOLTAGEMONITOR_ASM

	#include "../mcu.inc"
	#include "power-supply.inc"

	radix decimal

	constrainedToMcuClockFrequencyHz 32000000 ; Timing-sensitive code

_ADCON0_CHS_ANB3_VINMON equ (b'001011' << CHS0)

_ADCON1_ADFM_LEFT_JUSTIFIED equ (0 << ADFM)
_ADCON1_ADCS_TAD_2US equ (b'110' << ADCS0)
_ADCON1_ADPREF_FVR equ (b'11' << ADPREF0)

_ADACT_TRIGGER_NCO1 equ 0x0b

.powersupply code
	global _powerSupplyAdcInitialise

_powerSupplyAdcInitialise:
	banksel PMD2
	bcf PMD2, ADCMD

_initialiseAdcToSampleVinmonPin:
	banksel ADCON0
	movlw _ADCON0_CHS_ANB3_VINMON
	movwf ADCON0

	banksel ADCON1
	movlw _ADCON1_ADFM_LEFT_JUSTIFIED | _ADCON1_ADCS_TAD_2US | _ADCON1_ADPREF_FVR
	movwf ADCON1

	banksel ADACT
	movlw _ADACT_TRIGGER_NCO1
	movwf ADACT

	return

	end
