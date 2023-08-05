#ifndef __KITCHEN_LEDS_INITIALISE_H
#define __KITCHEN_LEDS_INITIALISE_H
#include "event.h"

#define SYSTEM_INITIALISED ((EventType) 0x01)
struct SystemInitialised { EMPTY_EVENT_ARGS };

extern void initialise(void);

#endif
