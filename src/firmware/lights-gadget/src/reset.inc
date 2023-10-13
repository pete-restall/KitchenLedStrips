	#ifndef __KITCHENLEDS_RESET_INC
	#define __KITCHENLEDS_RESET_INC

	radix decimal

_RESET_TYPE_FLAG_BOR equ 0
_RESET_TYPE_FLAG_POR equ 1
_RESET_TYPE_FLAG_MCLR equ 2

	#ifndef __KITCHENLEDS_RESET_ASM
	extern resetInitialise
	extern resetGetTypeFlags
	#endif

	#endif
