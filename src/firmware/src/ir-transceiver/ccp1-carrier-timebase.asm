	#define __KITCHENLEDS_IRTRANSCEIVER_CCP1CARRIERTIMEBASE_ASM
	#include "../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

_CCP1CON_MODE_COMPARE_AND_RESET equ (b'0001' << CCP1MODE0)

_CCPR1L_80KHZ equ 49
_CCPR1H_80KHZ equ 0

.irtransceiver code
	global _irTransceiverInitialiseCcp1ForDoubledCarrierWave

_irTransceiverInitialiseCcp1ForDoubledCarrierWave:
	banksel PMD3
	bcf PMD3, CCP1MD

	banksel CCPR1L
	movlw _CCPR1L_80KHZ
	movwf CCPR1L
	movlw _CCPR1H_80KHZ
	movwf CCPR1H

	movlw _CCP1CON_MODE_COMPARE_AND_RESET | (1 << EN)
	movwf CCP1CON

	return

	end
