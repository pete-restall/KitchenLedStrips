	#define __KITCHENLEDS_LEDPATTERNS_UDATA_ASM
	#include "led-patterns.inc"

	radix decimal

.ledpatternsUdata udata
	global _ledPatternsFlags
_ledPatternsFlags res 1

	global _ledPatternsColourParameters
	global _ledPatternsFirstColour
	global _ledPatternsFirstColourRed
	global _ledPatternsFirstColourGreen
	global _ledPatternsFirstColourBlue
_ledPatternsColourParameters:
_ledPatternsFirstColour:
_ledPatternsFirstColourRed res 1
_ledPatternsFirstColourGreen res 1
_ledPatternsFirstColourBlue res 1

	global _ledPatternsSecondColour
	global _ledPatternsSecondColourRed
	global _ledPatternsSecondColourGreen
	global _ledPatternsSecondColourBlue
_ledPatternsSecondColour:
_ledPatternsSecondColourRed res 1
_ledPatternsSecondColourGreen res 1
_ledPatternsSecondColourBlue res 1

	end
