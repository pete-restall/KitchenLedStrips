	#define __KITCHENLEDS_COMMANDS_IRTRANSCEIVER_CLC3TXBODGEWIRE_ASM
	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

_CLCCON_LCMODE_AND4 equ (b'010' << LC3MODE0)
_CLCSEL_CLCIN1PPS_RA7 equ 0x01

.irtransceiver code
	global _irTransceiverInitialiseClc3AsUart2TxBodgeWire

_irTransceiverInitialiseClc3AsUart2TxBodgeWire:
	banksel PMD5
	bcf PMD5, CLC3MD

	banksel CLC3SEL0
	movlw _CLCSEL_CLCIN1PPS_RA7
	movwf CLC3SEL0

	clrf CLC3GLS0
	bsf CLC3GLS0, LC3G1D1T

	clrf CLC3GLS1
	clrf CLC3GLS2
	clrf CLC3GLS3

	movlw (1 << LC3G2POL) | (1 << LC3G3POL) | (1 << LC3G4POL)
	movwf CLC3POL

	movlw _CLCCON_LCMODE_AND4 | (1 << EN)
	movwf CLC3CON

	return

	end
