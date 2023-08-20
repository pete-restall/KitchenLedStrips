	#include <xc.inc>

	psect bitstext,global,class=CODE,delta=2,merge=1,split=1,optim=
	global _bitsReverseUint8

_bitsReverseUint8:
	;
	; Operation is as follows:
	;   Shift bit 0 into C and clear bit 7.  This leaves bits 7-1 in bits 6-0, ie. _7654321.
	;   A 128-byte (7-bit) look-up is performed to reverse the lowest 7 bits; the bits are returned in the MSbs as 1234567_
	;   The carry from the previous right-shift (bit 0) is rotated back into bit 7, leaving 01234567.
	;
	; A 256-byte look-up table is faster and executes in 4 cycles but uses almost twice as much flash.  This hybrid takes 10 cycles.
	;
	lsrf WREG, W
	fcall reversedSeven
	rrf WREG, W
	return

reversedSeven:
	brw
	retlw 0b00000000
	retlw 0b10000000
	retlw 0b01000000
	retlw 0b11000000
	retlw 0b00100000
	retlw 0b10100000
	retlw 0b01100000
	retlw 0b11100000
	retlw 0b00010000
	retlw 0b10010000
	retlw 0b01010000
	retlw 0b11010000
	retlw 0b00110000
	retlw 0b10110000
	retlw 0b01110000
	retlw 0b11110000
	retlw 0b00001000
	retlw 0b10001000
	retlw 0b01001000
	retlw 0b11001000
	retlw 0b00101000
	retlw 0b10101000
	retlw 0b01101000
	retlw 0b11101000
	retlw 0b00011000
	retlw 0b10011000
	retlw 0b01011000
	retlw 0b11011000
	retlw 0b00111000
	retlw 0b10111000
	retlw 0b01111000
	retlw 0b11111000
	retlw 0b00000100
	retlw 0b10000100
	retlw 0b01000100
	retlw 0b11000100
	retlw 0b00100100
	retlw 0b10100100
	retlw 0b01100100
	retlw 0b11100100
	retlw 0b00010100
	retlw 0b10010100
	retlw 0b01010100
	retlw 0b11010100
	retlw 0b00110100
	retlw 0b10110100
	retlw 0b01110100
	retlw 0b11110100
	retlw 0b00001100
	retlw 0b10001100
	retlw 0b01001100
	retlw 0b11001100
	retlw 0b00101100
	retlw 0b10101100
	retlw 0b01101100
	retlw 0b11101100
	retlw 0b00011100
	retlw 0b10011100
	retlw 0b01011100
	retlw 0b11011100
	retlw 0b00111100
	retlw 0b10111100
	retlw 0b01111100
	retlw 0b11111100
	retlw 0b00000010
	retlw 0b10000010
	retlw 0b01000010
	retlw 0b11000010
	retlw 0b00100010
	retlw 0b10100010
	retlw 0b01100010
	retlw 0b11100010
	retlw 0b00010010
	retlw 0b10010010
	retlw 0b01010010
	retlw 0b11010010
	retlw 0b00110010
	retlw 0b10110010
	retlw 0b01110010
	retlw 0b11110010
	retlw 0b00001010
	retlw 0b10001010
	retlw 0b01001010
	retlw 0b11001010
	retlw 0b00101010
	retlw 0b10101010
	retlw 0b01101010
	retlw 0b11101010
	retlw 0b00011010
	retlw 0b10011010
	retlw 0b01011010
	retlw 0b11011010
	retlw 0b00111010
	retlw 0b10111010
	retlw 0b01111010
	retlw 0b11111010
	retlw 0b00000110
	retlw 0b10000110
	retlw 0b01000110
	retlw 0b11000110
	retlw 0b00100110
	retlw 0b10100110
	retlw 0b01100110
	retlw 0b11100110
	retlw 0b00010110
	retlw 0b10010110
	retlw 0b01010110
	retlw 0b11010110
	retlw 0b00110110
	retlw 0b10110110
	retlw 0b01110110
	retlw 0b11110110
	retlw 0b00001110
	retlw 0b10001110
	retlw 0b01001110
	retlw 0b11001110
	retlw 0b00101110
	retlw 0b10101110
	retlw 0b01101110
	retlw 0b11101110
	retlw 0b00011110
	retlw 0b10011110
	retlw 0b01011110
	retlw 0b11011110
	retlw 0b00111110
	retlw 0b10111110
	retlw 0b01111110
	retlw 0b11111110

	end
