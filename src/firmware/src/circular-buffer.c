#include <xc.h>

#include <stdbool.h>
#include <stdint.h>

#include "circular-buffer.h"

static bool circularBufferCanRead(const struct CircularBuffer *buf);
static bool circularBufferCanWrite(const struct CircularBuffer *buf);
static bool circularBufferIsrCanRead(const volatile struct CircularBuffer *buf);
static bool circularBufferIsrCanWrite(const volatile struct CircularBuffer *buf);

void circularBufferCreate(volatile struct CircularBuffer *buf, uint8_t *start, uint8_t sizeInBytes)
{
	if (!buf || !start || sizeInBytes < 2)
		return;

	buf->start = start;
	buf->end = start + sizeInBytes - 1;
	buf->sizeInBytes = sizeInBytes;
	buf->nextWriteOverflows = false;
	buf->readPtr = start;
	buf->writePtr = start;
}

bool circularBufferTryRead(struct CircularBuffer *buf, uint8_t *value)
{
	if (!circularBufferCanRead(buf))
		return false;

	if (value)
		*value = *buf->readPtr;

	if (++buf->readPtr > buf->end)
		buf->readPtr = buf->start;

	buf->nextWriteOverflows = false;
	return true;
}

static bool circularBufferCanRead(const struct CircularBuffer *buf)
{
	return buf && (buf->readPtr != buf->writePtr || buf->nextWriteOverflows);
}

bool circularBufferTryWrite(struct CircularBuffer *buf, uint8_t value)
{
	if (!circularBufferCanWrite(buf))
		return false;

	circularBufferForceWrite(buf, value);
	return true;
}

static bool circularBufferCanWrite(const struct CircularBuffer *buf)
{
	return buf && !buf->nextWriteOverflows;
}

void circularBufferForceWrite(struct CircularBuffer *buf, uint8_t value)
{
	if (!buf)
		return;

	*buf->writePtr = value;
	if (++buf->writePtr > buf->end)
		buf->writePtr = buf->start;

	buf->nextWriteOverflows = (buf->readPtr == buf->writePtr);
}

bool circularBufferIsrTryRead(volatile struct CircularBuffer *buf, uint8_t *value)
{
	if (!buf)
		return false;

	bool interruptsAreEnabled = INTCONbits.GIE != 0;
	INTCONbits.GIE = 0;

	bool isRead = circularBufferIsrCanRead(buf);
	if (isRead)
	{
		if (value)
			*value = *buf->readPtr;

		if (++buf->readPtr > buf->end)
			buf->readPtr = buf->start;

		buf->nextWriteOverflows = false;
	}

	if (interruptsAreEnabled)
		INTCONbits.GIE = 1;

	return isRead;
}

static bool circularBufferIsrCanRead(const volatile struct CircularBuffer *buf)
{
	return buf->readPtr != buf->writePtr || buf->nextWriteOverflows;
}

bool circularBufferIsrTryWrite(volatile struct CircularBuffer *buf, uint8_t value)
{
	if (!buf)
		return false;

	bool interruptsAreEnabled = INTCONbits.GIE != 0;
	INTCONbits.GIE = 0;

	bool isWritten = circularBufferIsrCanWrite(buf);
	if (isWritten)
		circularBufferIsrForceWrite(buf, value);

	if (interruptsAreEnabled)
		INTCONbits.GIE = 1;

	return isWritten;
}

static bool circularBufferIsrCanWrite(const volatile struct CircularBuffer *buf)
{
	return !buf->nextWriteOverflows;
}

void circularBufferIsrForceWrite(volatile struct CircularBuffer *buf, uint8_t value)
{
	if (!buf)
		return;

	bool interruptsAreEnabled = INTCONbits.GIE != 0;
	INTCONbits.GIE = 0;

	*buf->writePtr = value;
	if (++buf->writePtr > buf->end)
		buf->writePtr = buf->start;

	buf->nextWriteOverflows = (buf->readPtr == buf->writePtr);

	if (interruptsAreEnabled)
		INTCONbits.GIE = 1;
}
