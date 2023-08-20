#include <xc.h>
#include <stdint.h>

#include "pwm-timer.h"

#define T2CON_PRESCALER_1 (0b000 << _T2CON_CKPS_POSITION)
#define T2CON_POSTSCALER_1 (0b0000 << _T2CON_OUTPS_POSITION)

#define T2CLKCON_FOSC_OVER_4 0b00000001

#define T2HLT_NO_PRESCALER_SYNC 0
#define T2HLT_RISING_EDGE 0
#define T2HLT_ON_SYNC _T2HLT_CKSYNC_MASK
#define T2HLT_MODE_FREE 0
#define T2HLT_MODE_SOFTGATE 0

#define PR2_800KHZ 9

static uint8_t enableCount;

void pwmTimerInitialise(void)
{
	PMD1bits.TMR2MD = 0;
	enableCount = 0;

	T2CON = T2CON_PRESCALER_1 | T2CON_POSTSCALER_1;
	T2CLKCON = T2CLKCON_FOSC_OVER_4;
	T2HLT =
		T2HLT_NO_PRESCALER_SYNC |
		T2HLT_RISING_EDGE |
		T2HLT_ON_SYNC |
		T2HLT_MODE_FREE |
		T2HLT_MODE_SOFTGATE;

	PR2 = PR2_800KHZ;
	PIR4bits.TMR2IF = 0;
	PIE4bits.TMR2IE = 0;
}

void pwmTimerEnable(void)
{
	if (enableCount++ > 0)
		return;

	PIR4bits.TMR2IF = 0;
	T2CONbits.ON = 1;
}

void pwmTimerDisable(void)
{
	if (enableCount <= 1)
	{
		T2CONbits.ON = 0;
		PIR4bits.TMR2IF = 0;
		enableCount = 0;
	}
	else
		--enableCount;
}
