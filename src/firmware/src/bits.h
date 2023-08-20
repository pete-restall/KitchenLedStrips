#ifndef __KITCHEN_LEDS_BITS_H
#define __KITCHEN_LEDS_BITS_H
#include <stdint.h>

#define _bitsReverseUint8Const(value, a, b) ((value) & (a) ? (b) : 0x00)
#define bitsReverseUint8Const(value) ((uint8_t) ( \
	_bitsReverseUint8Const((value), 0x80, 0x01) | \
	_bitsReverseUint8Const((value), 0x40, 0x02) | \
	_bitsReverseUint8Const((value), 0x20, 0x04) | \
	_bitsReverseUint8Const((value), 0x10, 0x08) | \
	_bitsReverseUint8Const((value), 0x08, 0x10) | \
	_bitsReverseUint8Const((value), 0x04, 0x20) | \
	_bitsReverseUint8Const((value), 0x02, 0x40) | \
	_bitsReverseUint8Const((value), 0x01, 0x80)))

extern uint8_t bitsReverseUint8(uint8_t value);

#endif
