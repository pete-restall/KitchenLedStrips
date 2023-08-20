#ifndef __KITCHEN_LEDS_RGBLEDS_H
#define __KITCHEN_LEDS_RGBLEDS_H
#include <stdbool.h>
#include <stdint.h>
#include "bits.h"
#include "event.h"

#define NEXT_RGB_LED_VALUE_SHIFTED ((EventType) 0x04)
struct NextRgbLedValueShifted { EMPTY_EVENT_ARGS };

typedef uint8_t RgbLedComponent;

struct RgbLed
{
	RgbLedComponent red;
	RgbLedComponent green;
	RgbLedComponent blue;
};

#define rgbLedComponent(x) ((RgbLedComponent) bitsReverseUint8(x))
#define rgbLedComponentConst(x) ((RgbLedComponent) bitsReverseUint8Const(x))

#define RGB(r, g, b) { .red = rgbLedComponent(r), .green = rgbLedComponent(g), .blue = rgbLedComponent(b) }
#define RGB_CONST(r, g, b) { .red = rgbLedComponentConst(r), .green = rgbLedComponentConst(g), .blue = rgbLedComponentConst(b) }

extern void rgbLedsInitialise(void);
extern void rgbLedsEnable(void);
extern void rgbLedsDisable(void);
extern bool rgbLedsTryShiftNext(const struct RgbLed *led);

#endif
