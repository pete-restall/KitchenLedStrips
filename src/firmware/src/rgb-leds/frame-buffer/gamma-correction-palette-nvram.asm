	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_GAMMACORRECTIONPALETTENVRAM_ASM
	#include "frame-buffer.inc"

	radix decimal

.framebuffer code
	global _frameBufferGammaCorrectionPaletteNvram

_frameBufferGammaCorrectionPaletteNvram:
	andlw b'00011111'
	brw
	retlw b'00000000'
	retlw b'10000000'
	retlw b'01000000'
	retlw b'11000000'
	retlw b'00100000'
	retlw b'10100000'
	retlw b'11100000'
	retlw b'01010000'
	retlw b'10110000'
	retlw b'10001000'
	retlw b'10101000'
	retlw b'01011000'
	retlw b'00000100'
	retlw b'01100100'
	retlw b'00110100'
	retlw b'00101100'
	retlw b'00111100'
	retlw b'00100010'
	retlw b'10110010'
	retlw b'11101010'
	retlw b'10000110'
	retlw b'00110110'
	retlw b'00011110'
	retlw b'00100001'
	retlw b'10001001'
	retlw b'11111001'
	retlw b'10110101'
	retlw b'00111101'
	retlw b'00110011'
	retlw b'00111011'
	retlw b'10110111'
	retlw b'11111111'

	end
