	#ifndef __KITCHENLEDS_RGBLEDS_SM16703MODULATOR_SM16703MODULATOR_INC
	#define __KITCHENLEDS_RGBLEDS_SM16703MODULATOR_SM16703MODULATOR_INC
	#include "../../mcu.inc"

	radix decimal

_CLCCON_LCMODE_D_FLIPFLOP_SR equ (b'100' << LC1MODE0)
_CLCCON_LCMODE_ANDOR equ (b'000' << LC1MODE0)

_CLCSEL_TMR2_POSTSCALED equ 14
_CLCSEL_PWM3_LONG equ 17
_CLCSEL_PWM4_SHORT equ 18
_CLCSEL_CLC4OUT_NOTRESET equ 29
_CLCSEL_UART1_DT equ 30

	#ifdef __NEED_INITIALISATION_EXTERNS
	extern _sm16703pModulatorInitialiseClc4AsByteSynchronisedReset
	extern _sm16703pModulatorInitialiseClc1AsModulatedOutput

	extern _sm16703pModulatorInitialisePwm3AsLongDutyCycleForOnes
	extern _sm16703pModulatorInitialisePwm4AsShortDutyCycleForZeroes

	extern _sm16703pModulatorInitialiseTimer2ForPwm

	extern _sm16703pModulatorInitialiseUart1
	#endif

	#endif
