	#include "led-patterns.inc"

	radix decimal

.ledpatterns code
	global ledPatternsInitialise

ledPatternsInitialise:
	banksel _ledPatternsFlags
	clrf _ledPatternsFlags

	pagesel _ledPatternsBicolourInterlacedInitialise
	call _ledPatternsBicolourInterlacedInitialise

	pagesel _ledPatternsSwipeInOutInitialise
	call _ledPatternsSwipeInOutInitialise

	return

	end
