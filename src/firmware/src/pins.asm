	radix decimal

	#include "mcu.inc"

_PPSIN_RA7 equ 0x07
_PPSIN_RB0 equ 0x08
_PPSOUT_CLC1OUT equ 0x01
_PPSOUT_CLC2OUT equ 0x02
_PPSOUT_CLC3OUT equ 0x03

.pins code
	global pinsInitialise
	global pinsSetPeripherals

pinsInitialise:
_initialisePortA:
	banksel LATA
	clrf LATA

	banksel WPUA
	clrf WPUA

	banksel SLRCONA
	movlw b'01000000'
	movwf SLRCONA

	banksel ODCONA
	movlw b'10000000'
	movwf ODCONA

	banksel ANSELA
	clrf ANSELA

_initialisePortB:
	banksel LATB
	clrf LATB

	banksel WPUB
	movlw b'11000000'
	movwf WPUB

	banksel SLRCONB
	movlw b'11111111'
	movwf SLRCONB

	banksel ODCONB
	movlw b'00000110'
	movwf ODCONB

	banksel ANSELB
	movlw b'00001000'
	movwf ANSELB

_initialisePortC:
	banksel LATC
	clrf LATC

	banksel WPUC
	movlw b'11001111'
	movwf WPUC

	banksel SLRCONC
	movlw b'11001111'
	movwf SLRCONC

	banksel ODCONC
	clrf ODCONC

	banksel ANSELC
	clrf ANSELC

_enableOutputs:
	banksel TRISA
	movlw b'10000000'
	movwf TRISA

	banksel TRISB
	movlw b'11011110'
	movwf TRISB

	banksel TRISC
	movlw b'11001111'
	movwf TRISC

	return


pinsSetPeripherals:
	banksel RC2PPS
	clrf RC2PPS ; Defaults to CCP1 - we don't want this as we redirect it through the CLCs for modulation

	banksel RC6PPS
	clrf RC6PPS ; Defaults to TX1 - we don't want this as we redirect it through the CLCs for modulation
	clrf RC7PPS ; Ditto for RX1

	banksel RB6PPS
	clrf RB6PPS ; Defaults to TX2 - we don't want this as we redirect it through the CLCs for modulation
	clrf RB7PPS ; Ditto for RX2

	banksel RA0PPS
	movlw _PPSOUT_CLC1OUT
	movwf RA0PPS
	movwf RA1PPS
	movwf RA2PPS
	movwf RA3PPS
	movwf RA4PPS
	movwf RA5PPS

	banksel RA6PPS
	movlw _PPSOUT_CLC2OUT
	movwf RA6PPS

_useClc3AsBodgeWireFromRa7ToRb0DueToUart2PpsPortRestrictions:
	banksel CLCIN1PPS
	movlw _PPSIN_RA7
	movwf CLCIN1PPS

	banksel RB0PPS
	movlw _PPSOUT_CLC3OUT
	movwf RB0PPS

	banksel RX2DTPPS
	movlw _PPSIN_RB0 ; _PPSIN_RA7
	movwf RX2DTPPS

	return

	end
