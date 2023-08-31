	#include "mcu.inc"

	radix decimal

.powermanagement code
	global powerManagementInitialise
	global powerManagementSleep

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


powerManagementSleep:
	; TODO: Needs writing properly - perhaps the low-current regulator (or off entirely), do not sleep if certain peripherals still running, etc.
	banksel TX1STA
	btfss TX1STA, TRMT
	bra _doneSleeping

	banksel PORTA ; TODO: NOT A RELIABLE TEST SINCE THE LAST BIT TRANSMITTED COULD BE A 0...
	btfss PORTA, 0
	sleep
	nop

_doneSleeping:
	return

	end
