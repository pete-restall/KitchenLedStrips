#include <xc.h>

#include "event.h"
#include "initialise.h"
#include "power-management.h"
#include "pwm-timer.h"
#include "rgb-leds.h"

static void initialisePins(void);

void initialise(void)
{
	initialisePins();
	eventInitialise();
	powerManagementInitialise();
	pwmTimerInitialise();
	rgbLedsInitialise();
	eventPublish(SYSTEM_INITIALISED, &eventEmptyArgs);
}

static void initialisePins(void)
{
	LATA = 0b00000000;
	WPUA = 0b00000000;
	SLRCONA = 0b01000000;
	ODCONA = 0b00000000;
	ANSELA = 0b00000000;

	LATB = 0b00000000;
	WPUB = 0b11000001;
	SLRCONB = 0b11111111;
	ODCONB = 0b00000110;
	ANSELB = 0b00001000;

	LATC = 0b00000000;
	WPUC = 0b11001111;
	SLRCONC = 0b11001111;
	ODCONC = 0b00000000;
	ANSELC = 0b00000000;

	TRISA = 0b01111111;
	TRISB = 0b11011111;
	TRISC = 0b11001111;
}
