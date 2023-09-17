	#include "led-patterns.inc"

	radix decimal

.ledpatterns code
	global ledPatternsInitialise

ledPatternsInitialise:
	banksel _ledPatternsFlags
	clrf _ledPatternsFlags

	pagesel _ledPatternsBicolourInterlacedInitialise
	call _ledPatternsBicolourInterlacedInitialise
	return

	end
