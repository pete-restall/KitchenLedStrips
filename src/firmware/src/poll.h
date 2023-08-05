#ifndef __KITCHEN_LEDS_POLL_H
#define __KITCHEN_LEDS_POLL_H
#include "event.h"

#define ALL_EVENTS_DISPATCHED ((EventType) 0x02)
struct AllEventsDispatched { EMPTY_EVENT_ARGS };

extern void poll(void);

#endif
