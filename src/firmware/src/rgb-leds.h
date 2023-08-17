#ifndef __KITCHEN_LEDS_RGBLEDS_H
#define __KITCHEN_LEDS_RGBLEDS_H
#include <stdbool.h>
#include <stdint.h>
#include "event.h"

#define NEXT_RGB_LED_VALUE_SHIFTED ((EventType) 0x04)
struct NextRgbLedValueShifted { EMPTY_EVENT_ARGS };

extern void rgbLedsInitialise(void);
extern bool rgbLedsTryShiftNext(uint8_t r, uint8_t g, uint8_t b);

#endif
