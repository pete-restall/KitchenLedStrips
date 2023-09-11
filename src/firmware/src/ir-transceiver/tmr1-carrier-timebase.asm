	#define __KITCHENLEDS_IRTRANSCEIVER_TMR1CARRIERTIMEBASE_ASM
	#include "../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

_T1CON_SYNCHRONISED_16BIT equ (1 << RD16)

_T1CLK_FOSC_OVER_4 equ (b'0001' << T1CS0)

.irtransceiver code
	global _irTransceiverInitialiseTimer1ForDoubledCarrierWave

_irTransceiverInitialiseTimer1ForDoubledCarrierWave:
	banksel PMD1
	bcf PMD1, TMR1MD

	banksel T1GCON
	clrf T1GCON

	movlw _T1CLK_FOSC_OVER_4
	movwf T1CLK

	clrf TMR1H
	clrf TMR1L

	movlw _T1CON_SYNCHRONISED_16BIT
	movwf T1CON

	return

	end
