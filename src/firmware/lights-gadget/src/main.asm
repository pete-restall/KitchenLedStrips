	#define __KITCHENLEDS_MAIN_ASM

	#include "commands.inc"
	#include "config.inc"
	#include "initialise.inc"
	#include "led-patterns.inc"
	#include "main.inc"
	#include "mcu.inc"
	#include "power-management.inc"
	#include "power-supply.inc"
	#include "reset.inc"
	#include "rgb-leds.inc"

	radix decimal

_FLAG_POWER_SUPPLY_ENABLED equ 0

.mainUdata udata
	global mainTimebaseLow
	global mainTimebaseHigh
mainTimebaseLow res 1
mainTimebaseHigh res 1
_isMorePollingRequired res 1
_flags res 1

.main code
	global main

main:
_initialise:
	pagesel initialise
	call initialise

	banksel _flags
	clrf _flags

	banksel INTCON
	bsf INTCON, PEIE
	bsf INTCON, GIE

	banksel mainTimebaseLow
	clrf mainTimebaseLow
	clrf mainTimebaseHigh

_enablePowerToLedsOnlyIfPowerOnResetOrBrownOutOrMasterClear:
	#if (CONFIG_DEFAULT_LIGHTS_ON != 0)

	pagesel resetGetTypeFlags
	call resetGetTypeFlags
	andlw (1 << _RESET_TYPE_FLAG_POR) | (1 << _RESET_TYPE_FLAG_BOR) | (1 << _RESET_TYPE_FLAG_MCLR)

	pagesel powerSupplyEnable
	btfss STATUS, Z
	call powerSupplyEnable

	#endif

	; !!! TODO: START OF TEMPORARY DEBUGGING (ENABLE POWER SWITCH FOR LEDS AND DISABLE INTERLACING) !!!
	pagesel ledPatternsBicolourInterlacedDisableInterlacing
	call ledPatternsBicolourInterlacedDisableInterlacing
	; !!! TODO: END OF TEMPORARY DEBUGGING !!!

_pollingLoop:
	clrwdt

_startPolling:
	banksel _isMorePollingRequired
	clrf _isMorePollingRequired

_pollPowerSupplyModule:
	pagesel powerSupplyPoll
	call powerSupplyPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_forceBlitToAvoidFlashIfPowerSupplyHasBeenEnabledSinceLastPoll:
	pagesel powerSupplyIsEnabled
	call powerSupplyIsEnabled
	xorlw 0

	banksel _flags
	btfsc _flags, _FLAG_POWER_SUPPLY_ENABLED
	xorlw 1

	btfsc STATUS, Z
	bra _noNeedToForceBlit

	movlw (1 << _FLAG_POWER_SUPPLY_ENABLED)
	xorwf _flags, F

	pagesel rgbLedsForceNextBlitBeforeFrameSync
	btfss STATUS, Z
	call rgbLedsForceNextBlitBeforeFrameSync

_noNeedToForceBlit:

_pollRgbLedsModule:
	pagesel rgbLedsPoll
	call rgbLedsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_incrementMainTimebaseIfFrameCounterHasChanged:
	banksel rgbLedsFrameCounter
	movf rgbLedsFrameCounter, W

	banksel mainTimebaseLow
	xorwf mainTimebaseLow, W
	btfsc STATUS, Z
	bra _frameCounterUnchanged

	incf mainTimebaseLow, F
	btfsc STATUS, Z
	incf mainTimebaseHigh, F

_frameCounterUnchanged:
_pollLedPatternsModule:
	pagesel ledPatternsPoll
	call ledPatternsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_pollCommandsModule:
	pagesel commandsPoll
	call commandsPoll
	banksel _isMorePollingRequired
	iorwf _isMorePollingRequired, F

_sleepIfNoMorePollingIsRequired:
	banksel _isMorePollingRequired
	movf _isMorePollingRequired, F
	btfss STATUS, Z
	bra _pollingLoop

	pagesel powerManagementSleep
	call powerManagementSleep
	bra _pollingLoop

	end
