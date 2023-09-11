	#include "mcu.inc"

	radix decimal

_CLCDATA_TX_HELD_IN_RESET_AND_PORT_LATCHED_LOW equ (1 << MLC4OUT) | (1 << MLC1OUT)

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
	clrw

_timer2UsagePrecludesSleep:
	banksel T2CON
	btfsc T2CON, EN
	iorlw 1 << IDLEN

_timer0UsagePrecludesSleep:
	banksel T0CON0
	btfsc T0CON0, EN
	iorlw 1 << IDLEN

_setSleepOrIdleDependingOnPeripheralUse:
	banksel CPUDOZE
	bcf CPUDOZE, IDLEN
	bcf CPUDOZE, DOZEN
	iorwf CPUDOZE, F

; TODO: SEEMS TO STOP EVERYTHING WORKING - FIX THIS
;	sleep
	nop

_doneSleeping:
	return

	end
