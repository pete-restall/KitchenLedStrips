	radix decimal

	#include "mcu.inc"

_PPSOUT_CLC1OUT equ 0x01

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
	clrf ODCONA

	banksel ANSELA
	clrf ANSELA

_initialisePortB:
	banksel LATB
	clrf LATB

	banksel WPUB
	movlw b'11000001'
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
	movlw b'11011111'
	movwf TRISB

	banksel TRISC
	movlw b'11001111'
	movwf TRISC

	return


pinsSetPeripherals:
	banksel RC6PPS
	clrf RC6PPS ; Defaults to TX1 - we don't want this as we redirect them through the CLCs for modulation
	clrf RC7PPS ; Ditto for RX1

	banksel RA0PPS
	movlw _PPSOUT_CLC1OUT
	movwf RA0PPS
	movwf RA1PPS
	movwf RA2PPS
	movwf RA3PPS
	movwf RA4PPS
	movwf RA5PPS

	return

	end
