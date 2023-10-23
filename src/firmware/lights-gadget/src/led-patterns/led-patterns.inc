	#ifndef __KITCHENLEDS_LEDPATTERNS_LEDPATTERNS_INC
	#define __KITCHENLEDS_LEDPATTERNS_LEDPATTERNS_INC

	radix decimal

_LED_PATTERNS_FLAG_FRAMESYNC equ 0

	#ifndef __KITCHENLEDS_LEDPATTERNS_BICOLOURINTERLACED_ASM
	extern _ledPatternsBicolourInterlacedInitialise
	extern _ledPatternsBicolourInterlacedPoll
	#endif

	#ifndef __KITCHENLEDS_LEDPATTERNS_SWIPEINOUT_ASM
	extern _ledPatternsSwipeInOutInitialise
	extern _ledPatternsSwipeInOutPoll
	#endif

	#ifndef __KITCHENLEDS_LEDPATTERNS_UDATA_ASM
	extern _ledPatternsFlags

	extern _ledPatternsColourParameters
	extern _ledPatternsFirstColour
	extern _ledPatternsFirstColourRed
	extern _ledPatternsFirstColourGreen
	extern _ledPatternsFirstColourBlue

	extern _ledPatternsSecondColour
	extern _ledPatternsSecondColourRed
	extern _ledPatternsSecondColourGreen
	extern _ledPatternsSecondColourBlue
	#endif

	#endif
