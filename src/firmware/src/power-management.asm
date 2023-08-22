	#include "mcu.inc"

	radix decimal

.powermanagement code
	global powerManagementInitialise

powerManagementInitialise:
	banksel PMD0
	movlw ~((1 << SYSCMD) | (1 << NVMMD))
	movwf PMD0

	movlw 0xff
	movwf PMD1

	movlw 0xff
	movwf PMD2

	movlw 0xff
	movwf PMD3

	movlw 0xff
	movwf PMD4

	movlw 0xff
	movwf PMD5

	return

	end
