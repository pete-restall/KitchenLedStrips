	#define __KITCHENLEDS_COMMANDS_IRTRANSCEIVER_UART2_ASM
	#include "../../mcu.inc"
	#include "ir-transceiver.inc"

	radix decimal

_TX2STA_ASYNCHRONOUS_8BIT_TRANSMISSION equ (1 << TXEN)
_RC2STA_CONTINUOUS_8BIT_RECEPTION equ (1 << SPEN) | (1 << CREN)
_BAUD2CON_TXIDLE0_16BIT_WAKEUP equ (1 << SCKP) | (1 << BRG16) | (1 << WUE)
_SP2BRG_1250HZ equ 1599

.irtransceiver code
	global irTransceiverInitialiseUart2

irTransceiverInitialiseUart2:
	banksel PMD4
	bcf PMD4, UART2MD

_configureBaudRateGenerator:
	banksel BAUD2CON
	movlw _BAUD2CON_TXIDLE0_16BIT_WAKEUP
	movwf BAUD2CON

_setBaudRateTo1250bps:
	banksel SP2BRGL
	movlw low(_SP2BRG_1250HZ)
	movwf SP2BRGL
	movlw high(_SP2BRG_1250HZ)
	movwf SP2BRGH

_enableAsynchronousMode:
	banksel RC2STA
	movlw _RC2STA_CONTINUOUS_8BIT_RECEPTION ; TODO: VERIFY RECEPTION WORKS IN SLEEP (START BIT NEEDS TO BE ABLE TO WAKE THE DEVICE)
	movwf RC2STA

	banksel TX2STA
	movlw _TX2STA_ASYNCHRONOUS_8BIT_TRANSMISSION
	movwf TX2STA

	return

	end
