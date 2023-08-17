#include <xc.h>
#include <stdint.h>

#include "circular-buffer.h"
#include "rgb-leds.h"

extern volatile struct CircularBuffer rgbLedsUartTransmissionBuffer;

void __interrupt() isr(void)
{
	if (PIR3bits.TX1IF)
	{
		uint8_t nextByte;
		if (circularBufferIsrTryRead(&rgbLedsUartTransmissionBuffer, &nextByte))
			TX1REG = nextByte;
		else
			PIE3bits.TX1IE = 0;
	}
}
