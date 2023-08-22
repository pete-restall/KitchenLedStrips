	#include "sm16703p-modulator.inc"

	radix decimal

_TX1STA_SYNCHRONOUS_MASTER_MODE equ (1 << CSRC) | (1 << TXEN) | (1 << SYNC_TX1STA)
_RC1STA_NO_RECEPTION equ (1 << SPEN)

.sm16703pmodulator code
	global sm16703pModulatorInitialiseUart1

sm16703pModulatorInitialiseUart1:
	banksel PMD4
	bcf PMD4, UART1MD

_setBaudRateTo800kbps:
	banksel SP1BRGL
	movlw 9
	movwf SP1BRGL
	clrf SP1BRGH

_enableSynchronousMasterMode:
	banksel RC1STA
	movlw _RC1STA_NO_RECEPTION
	movwf RC1STA

	banksel TX1STA
	movlw _TX1STA_SYNCHRONOUS_MASTER_MODE
	movwf TX1STA

	return

	end
