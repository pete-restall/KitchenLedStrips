#include <xc.h>
#include <stdbool.h>
#include <stdint.h>

#include "circular-buffer.h"
#include "rgb-leds.h"

static bool terminateClcOutputWhenDummyByteTransferredToShiftRegister = false;

extern volatile struct CircularBuffer rgbLedsUartTransmissionBuffer;

void __interrupt() isr(void)
{
	if (PIR3bits.TX1IF)
	{
		if (!terminateClcOutputWhenDummyByteTransferredToShiftRegister)
		{
			uint8_t nextByte;
			if (!circularBufferIsrTryRead(&rgbLedsUartTransmissionBuffer, &nextByte))
			{
				TX1REG = 0;
				terminateClcOutputWhenDummyByteTransferredToShiftRegister = true;
			}
			else
				TX1REG = nextByte;
		}
		else
		{
			PIE3bits.TX1IE = 0;
			PWM3CONbits.EN = 0;
			PWM4CONbits.EN = 0;
			terminateClcOutputWhenDummyByteTransferredToShiftRegister = false;
		}
	}
}
