#include <xc.h>

#include "sm16703p-modulator.h"

#define _CLCCON_LCMODE_D_FLIPFLOP_SR (4 << _CLC1CON_LC1MODE_POSITION)
#define _CLCCON_LCMODE_ANDOR (0 << _CLC1CON_LC1MODE_POSITION)

#define CLCSEL_PWM3_LONG 17
#define CLCSEL_PWM4_SHORT 18
#define CLCSEL_UART1_DT 30
#define CLCSEL_CLC2_OUT 27

static void disablePowerOnSelfTestFullPowerWhiteModeWhilstEnablingModules(void);
static void initialiseClc2AsUart1DtRegisterClockedByLongPwm(void);
static void initialiseClc1AsMuxOfLongAndShortPwmsGatedByClc2(void);
static void initialisePwm3AsLongDutyCycleForOnes(void);
static void initialisePwm4AsShortDutyCycleForZeroes(void);

void sm16703pModulatorInitialise(void)
{
	disablePowerOnSelfTestFullPowerWhiteModeWhilstEnablingModules();
	initialiseClc2AsUart1DtRegisterClockedByLongPwm();
	initialiseClc1AsMuxOfLongAndShortPwmsGatedByClc2();
	initialisePwm3AsLongDutyCycleForOnes();
	initialisePwm4AsShortDutyCycleForZeroes();
}

static void disablePowerOnSelfTestFullPowerWhiteModeWhilstEnablingModules(void)
{
	LATA |= 0b00111111;
	PMD3bits.PWM3MD = 0;
	PMD3bits.PWM4MD = 0;
	PMD5bits.CLC1MD = 0;
	PMD5bits.CLC2MD = 0;
	LATA &= 0b11000000;
}

static void initialiseClc2AsUart1DtRegisterClockedByLongPwm(void)
{
	// g3 & g4 = 0
	// g1 = clk (!pwm3_long)
	// g2 = dat

	CLC2SEL0 = CLCSEL_UART1_DT;
	CLC2SEL1 = CLCSEL_PWM3_LONG;
	CLC2GLS0 = _CLC2GLS0_LC2G1D2N_MASK;
	CLC2GLS1 = _CLC2GLS1_LC2G2D1T_MASK;
	CLC2GLS2 = 0;
	CLC2GLS3 = 0;
	CLC2POL = 0;
	CLC2CON = _CLCCON_LCMODE_D_FLIPFLOP_SR | _CLC2CON_EN_MASK;
}

static void initialiseClc1AsMuxOfLongAndShortPwmsGatedByClc2(void)
{
	// g1 = pwm3_long
	// g2 = clc2 out
	// g3 = clc2 !out
	// g4 = pwm4_short

	CLC1SEL0 = CLCSEL_CLC2_OUT;
	CLC1SEL1 = CLCSEL_PWM3_LONG;
	CLC1SEL2 = CLCSEL_PWM4_SHORT;
	CLC1GLS0 = _CLC1GLS0_LC1G1D2T_MASK;
	CLC1GLS1 = _CLC1GLS1_LC1G2D1T_MASK;
	CLC1GLS2 = _CLC1GLS2_LC1G3D1N_MASK;
	CLC1GLS3 = _CLC1GLS3_LC1G4D3T_MASK;
	CLC1POL = 0;
	CLC1CON = _CLCCON_LCMODE_ANDOR | _CLC1CON_EN_MASK;
}

static void initialisePwm3AsLongDutyCycleForOnes(void)
{
	PWM3DCH = 0;
	PWM3DCL = 29;
	PWM3CON = _PWM3CON_EN_MASK;
}

static void initialisePwm4AsShortDutyCycleForZeroes(void)
{
	PWM4DCH = 0;
	PWM4DCL = 10;
	PWM4CON = _PWM4CON_EN_MASK;
}
