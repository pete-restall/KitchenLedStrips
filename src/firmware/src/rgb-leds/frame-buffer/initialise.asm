	#define __KITCHENLEDS_RGBLEDS_FRAMEBUFFER_INITIALISE_ASM
	#include "../../working-registers.inc"
	#include "frame-buffer.inc"

	radix decimal

.framebuffer code
	global frameBufferInitialise

frameBufferInitialise:
	banksel _frameBufferFlags
	clrf _frameBufferFlags

_initialiseFrameBufferPointers:
	movlw low(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrLow
	movlw high(frameBufferLinearStart)
	movwf _frameBufferDisplayPtrHigh

_referenceUnusedBankVariablesToPreventLinkerStrippingSymbolAndCorruptingTheMemoryMap:
	movlw low(_frameBufferPastEnd)

_clearFrameBuffer:
	pagesel frameBufferClear
	call frameBufferClear

_defaultColourComponentPalettesToGammaCorrection:
_loadRedPalette:
	movlw low(_frameBufferRedPalette)
	movwf FSR0L
	movlw high(_frameBufferRedPalette)
	movwf FSR0H
	pagesel _loadPaletteUsingDestinationOfFsr0
	call _loadPaletteUsingDestinationOfFsr0

_loadGreenPalette:
	movlw low(_frameBufferGreenPalette)
	movwf FSR0L
	movlw high(_frameBufferGreenPalette)
	movwf FSR0H
	pagesel _loadPaletteUsingDestinationOfFsr0
	call _loadPaletteUsingDestinationOfFsr0

_loadBluePalette:
	movlw low(_frameBufferBluePalette)
	movwf FSR0L
	movlw high(_frameBufferBluePalette)
	movwf FSR0H
	pagesel _loadPaletteUsingDestinationOfFsr0
	call _loadPaletteUsingDestinationOfFsr0

	return


_loadPaletteUsingDestinationOfFsr0:
	addfsr FSR0, 31
	movlw 32
	movwf workingA

	pagesel _frameBufferGammaCorrectionPaletteNvram
_loadNextByteFromPalette:
	decf workingA, W
	call _frameBufferGammaCorrectionPaletteNvram
	movwi FSR0--
	decfsz workingA, F
	bra _loadNextByteFromPalette

	return

	end
