#ifndef __KITCHEN_LEDS_CIRCULARBUFFER_H
#define __KITCHEN_LEDS_CIRCULARBUFFER_H
#include <stdbool.h>
#include <stdint.h>

struct CircularBuffer
{
	uint8_t *start;
	uint8_t *end;
	uint8_t sizeInBytes;
	uint8_t *readPtr;
	uint8_t *writePtr;
	bool nextWriteOverflows;
};

extern void circularBufferCreate(volatile struct CircularBuffer *buf, uint8_t *start, uint8_t sizeInBytes);
extern bool circularBufferTryRead(struct CircularBuffer *buf, uint8_t *value);
extern bool circularBufferTryWrite(struct CircularBuffer *buf, uint8_t value);
extern void circularBufferForceWrite(struct CircularBuffer *buf, uint8_t value);

extern bool circularBufferIsrTryRead(volatile struct CircularBuffer *buf, uint8_t *value);
extern bool circularBufferIsrTryWrite(volatile struct CircularBuffer *buf, uint8_t value);
extern void circularBufferIsrForceWrite(volatile struct CircularBuffer *buf, uint8_t value);

#endif
