#include "event.h"
#include "poll.h"

void poll(void)
{
	asm("clrwdt");
	if (!eventDispatchNext())
		eventPublish(ALL_EVENTS_DISPATCHED, &eventEmptyArgs);
}
