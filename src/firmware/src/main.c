#include <xc.h>
#include <stdbool.h>

#include "event.h"
#include "initialise.h"
#include "poll.h"

static void onSystemInitialised(const struct Event *event);

void main(void)
{
	static const struct EventSubscription onSystemInitialisedSubscription =
	{
		.type = SYSTEM_INITIALISED,
		.handler = &onSystemInitialised,
		.state = (void *) 0
	};

	initialise();
	eventSubscribe(&onSystemInitialisedSubscription);
	while (true)
		poll();
}

#include "rgb-leds.h" // TODO: TEMPORARY DEBUGGING

static void onSystemInitialised(const struct Event *event)
{
	INTCONbits.GIE = 1;
	rgbLedsEnable();

	static const struct RgbLed white = RGB_CONST(0xff, 0xff, 0xff);

	rgbLedsTryShiftNext(&white); // TODO: TEMPORARY DEBUGGING
}
