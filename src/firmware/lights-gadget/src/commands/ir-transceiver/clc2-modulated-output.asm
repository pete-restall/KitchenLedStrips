	#define __KITCHENLEDS_COMMANDS_IRTRANSCEIVER_CLC2MODULATEDOUTPUT_ASM
	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

_CLCCON_LCMODE_JK_FLIPFLOP_R equ (b'110' << LC2MODE0)
_CLCSEL_CCP1_2XCARRIER equ 15
_CLCSEL_UART2_TX equ 33

.irtransceiver code
	global _irTransceiverInitialiseClc2AsModulatedOutput

_irTransceiverInitialiseClc2AsModulatedOutput:
	banksel PMD5
	bcf PMD5, CLC2MD

	banksel CLC2SEL0
	movlw _CLCSEL_CCP1_2XCARRIER
	movwf CLC2SEL0

	movlw _CLCSEL_UART2_TX
	movwf CLC2SEL1

	clrf CLC2GLS0
	bsf CLC2GLS0, LC2G1D1T ; clock

	clrf CLC2GLS1
	bsf CLC2GLS1, LC2G2D2T ; J=TX

	clrf CLC2GLS2 ; reset=0

	clrf CLC2GLS3 ; K=0 (inverted below)

	clrf CLC2POL
	bsf CLC2POL, LC2G4POL ; K=1

	movlw _CLCCON_LCMODE_JK_FLIPFLOP_R | (1 << EN)
	movwf CLC2CON

_ensureClcIsReset:
	bsf CLC2POL, LC2G3POL
	nop
	bcf CLC2POL, LC2G3POL

	return

	end
