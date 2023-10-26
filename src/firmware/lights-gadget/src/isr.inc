	#ifndef __KITCHENLEDS_ISR_INC
	#define __KITCHENLEDS_ISR_INC

	radix decimal

RGBLEDS_NUMBER_OF_BYTES_IN_TX_BUFFER equ 16 * 3

	#ifdef __NEED_ISR_INTERNALS
	extern _txBufferStart
	extern _txBufferEnd
	extern _txBufferPastEnd
	extern _txUnreadCount
	#endif

	#endif
