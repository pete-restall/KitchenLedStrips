#ifndef __KITCHEN_LEDS_POWERMANAGEMENT_H
#define __KITCHEN_LEDS_POWERMANAGEMENT_H
#include "event.h"

#define WOKEN_FROM_SLEEP ((EventType) 0x03)
struct WokenFromSleep { EMPTY_EVENT_ARGS };

extern void powerManagementInitialise(void);

#endif
