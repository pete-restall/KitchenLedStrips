#include <xc.h>
#include <stdbool.h>
#include <stdint.h>

#include "bits.h"
#include "circular-buffer.h"
#include "event.h"
#include "rgb-leds.h"

struct RgbLedsState
{
	uint8_t rgbTransmissionBuffer[9];
	uint8_t nextRgb[3];
	uint8_t nextRgbCountRemaining;
};

static struct RgbLedsState state;

volatile struct CircularBuffer rgbLedsUartTransmissionBuffer;

static void onNextRgbLedValueShifted(const struct Event *event);

void rgbLedsInitialise(void)
{
	circularBufferCreate(&rgbLedsUartTransmissionBuffer, state.rgbTransmissionBuffer, sizeof(state.rgbTransmissionBuffer));
	state.nextRgbCountRemaining = 0;

	static const struct EventSubscription onNextRgbLedValueShiftedSubscription =
	{
		.type = NEXT_RGB_LED_VALUE_SHIFTED,
		.handler = &onNextRgbLedValueShifted,
		.state = (void *) 0
	};

	eventSubscribe(&onNextRgbLedValueShiftedSubscription);
}

static void onNextRgbLedValueShifted(const struct Event *event)
{
	while (state.nextRgbCountRemaining > 0)
	{
		if (!circularBufferIsrTryWrite(&rgbLedsUartTransmissionBuffer, state.nextRgb[3 - state.nextRgbCountRemaining]))
		{
			eventPublish(NEXT_RGB_LED_VALUE_SHIFTED, &eventEmptyArgs);
			break;
		}

		state.nextRgbCountRemaining--;
	}
}

bool rgbLedsTryShiftNext(uint8_t r, uint8_t g, uint8_t b)
{
	if (state.nextRgbCountRemaining != 0)
		return false;

	state.nextRgb[0] = bitsReverseUint8(g);
	state.nextRgb[1] = bitsReverseUint8(r);
	state.nextRgb[2] = bitsReverseUint8(b);
	state.nextRgbCountRemaining = 3;
	onNextRgbLedValueShifted(&eventEmptyArgs);
	return true;
}
