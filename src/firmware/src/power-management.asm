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
_timers1And2AreDependentOnInstructionClockAndPrecludeSleeping:
	banksel T1CON
	btfsc T1CON, ON_T1CON
	bra _doneSleeping

	banksel T2CON
	btfsc T2CON, EN
	bra _doneSleeping

_useFullSleepAndNotIdleMode:
	banksel CPUDOZE
	bcf CPUDOZE, DOZEN
	bcf CPUDOZE, IDLEN

_enableUart2WakeupByte:
	banksel BAUD2CON
	bsf BAUD2CON, WUE

_disableGlobalInterruptsSoSomePeripheralsCanWakeFromSleep:
	banksel PIE0
	bcf INTCON, GIE
	bsf PIE0, TMR0IE
	bsf PIE3, RC2IE

_sleep:
	clrwdt
	sleep
	nop

_restoreGlobalInterrupts:
	bcf PIE3, RC2IE
	bcf PIE0, TMR0IE
	bsf INTCON, GIE

_disableUart2WakeupByte:
	banksel BAUD2CON
	bcf BAUD2CON, WUE

_doneSleeping:
	return

	end
