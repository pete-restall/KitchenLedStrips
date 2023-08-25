	#include "../mcu.inc"
	#include "../working-registers.inc"

	radix decimal

.bits code
	global bitsSetCount

;
; Take a byte in W, count the bits that are set (1), and return the result in W.
;
; Operation is the result of the following equation (proof in Hacker's Delight):
;   y = x - x/2 - x/4 - x/8 - x/16 - x/32 - x/64 - x/128
;
; Takes 17 cycles, which is 3 cycles less than a nybble-based lookup (with one less register used) or the brute force btfsc approach.
;
bitsSetCount:
	movwf workingA
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, F
	lsrf WREG, W
	subwf workingA, W
	return

	end
