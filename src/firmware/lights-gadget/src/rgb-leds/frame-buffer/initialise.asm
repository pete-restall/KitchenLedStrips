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
	movlw low(frameBufferLinearPartition0PastEnd)
	movwf _frameBufferDisplayPtrPastEnd

_clearFrameBuffer:
	pagesel frameBufferClear
	call frameBufferClear

_loadRedPalette:
	movlw low(_frameBufferRedPalette)
	movwf FSR0L
	movlw high(_frameBufferRedPalette)
	movwf FSR0H
	pagesel _loadDefaultRedPaletteUsingDestinationOfFsr0
	call _loadDefaultRedPaletteUsingDestinationOfFsr0

_loadGreenPalette:
	movlw low(_frameBufferGreenPalette)
	movwf FSR0L
	movlw high(_frameBufferGreenPalette)
	movwf FSR0H
	pagesel _loadDefaultGreenPaletteUsingDestinationOfFsr0
	call _loadDefaultGreenPaletteUsingDestinationOfFsr0

_loadBluePalette:
	movlw low(_frameBufferBluePalette)
	movwf FSR0L
	movlw high(_frameBufferBluePalette)
	movwf FSR0H
	pagesel _loadDefaultBluePaletteUsingDestinationOfFsr0
	call _loadDefaultBluePaletteUsingDestinationOfFsr0

	return


_defineLoadDefaultPaletteUsingDestinationOfFsr0For macro paletteLookupFunction
	addfsr FSR0, 31
	movlw 32
	movwf workingA

	pagesel paletteLookupFunction
	local __loadNextByteFromPalette
__loadNextByteFromPalette:
	decf workingA, W
	call paletteLookupFunction
	movwi FSR0--
	decfsz workingA, F
	bra __loadNextByteFromPalette

	return
	endm

_loadDefaultRedPaletteUsingDestinationOfFsr0:
	_defineLoadDefaultPaletteUsingDestinationOfFsr0For _frameBufferDefaultRedPalette

_loadDefaultGreenPaletteUsingDestinationOfFsr0:
	_defineLoadDefaultPaletteUsingDestinationOfFsr0For _frameBufferDefaultGreenPalette

_loadDefaultBluePaletteUsingDestinationOfFsr0:
	_defineLoadDefaultPaletteUsingDestinationOfFsr0For _frameBufferDefaultBluePalette

	end
