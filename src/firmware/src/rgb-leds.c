#include <xc.h>
#include <stdbool.h>
#include <stdint.h>

#include "circular-buffer.h"
#include "event.h"
#include "pwm-timer.h"
#include "rgb-leds.h"
#include "sm16703p-modulator.h"

#define SPBRG_800KHZ 9

struct RgbLedsState
{
	uint8_t rgbTransmissionBuffer[9];
	uint8_t nextRgb[3];
	uint8_t nextRgbCountRemaining;
	uint8_t enableCount;
};

static struct RgbLedsState state;

volatile struct CircularBuffer rgbLedsUartTransmissionBuffer;

static void initialiseUart(void);
static void onNextRgbLedValueShifted(const struct Event *event);

void rgbLedsInitialise(void)
{
	initialiseUart();
	sm16703pModulatorInitialise();
	circularBufferCreate(&rgbLedsUartTransmissionBuffer, state.rgbTransmissionBuffer, sizeof(state.rgbTransmissionBuffer));
	state.nextRgbCountRemaining = 0;
	state.enableCount = 0;

	static const struct EventSubscription onNextRgbLedValueShiftedSubscription =
	{
		.type = NEXT_RGB_LED_VALUE_SHIFTED,
		.handler = &onNextRgbLedValueShifted,
		.state = (void *) 0
	};

	eventSubscribe(&onNextRgbLedValueShiftedSubscription);
}

static void initialiseUart(void)
{
	PMD4bits.UART1MD = 0;
	asm("nop");
	TX1STA = _TX1STA_CSRC_MASK | _TX1STA_TXEN_MASK | _TX1STA_SYNC_MASK;
	RC1STA = _RC1STA_SPEN_MASK;
	SP1BRG = SPBRG_800KHZ;
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

void rgbLedsEnable(void)
{
	if (state.enableCount++ > 0)
		return;

	pwmTimerEnable();
}

void rgbLedsDisable(void)
{
	if (state.enableCount <= 1)
	{
		pwmTimerDisable();
		PIE3bits.TX1IE = 0;
		state.enableCount = 0;
		state.nextRgbCountRemaining = 0;
		circularBufferIsrReset(&rgbLedsUartTransmissionBuffer);
	}
	else
		--state.enableCount;
}

bool rgbLedsTryShiftNext(const struct RgbLed *led)
{
	if (state.enableCount == 0 || state.nextRgbCountRemaining != 0)
		return false;

	state.nextRgb[0] = (uint8_t) led->red;
	state.nextRgb[1] = (uint8_t) led->green;
	state.nextRgb[2] = (uint8_t) led->blue;
	state.nextRgbCountRemaining = 3;
	onNextRgbLedValueShifted(&eventEmptyArgs);
	if (!PIE3bits.TX1IE)
	{
		PWM3CONbits.EN = 1;
		PWM4CONbits.EN = 1; // TODO: WILL THIS CAUSE GLITCHES ?
		PIE3bits.TX1IE = 1;
	}
// TODO: PWM SHOULD BE ENABLED HERE AS WELL ?  OR THE LINE ABOVE TX1IE ?  ALSO FIGURE OUT HOW TO DISABLE THE PWM ONCE TRMT INDICATES ALL UART IS DONE.
// TODO: FIGURE OUT HOW TO WORK THE 80us END-OF-FRAME INTO THE MIX, TOO.
	return true;
}
