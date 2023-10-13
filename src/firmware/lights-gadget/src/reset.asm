	#define __KITCHENLEDS_RESET_ASM

	#include "mcu.inc"
	#include "reset.inc"
	#include "working-registers.inc"

	radix decimal

.resetUdata udata
resetStatus res 1
resetPcon0 res 1
resetPcon1 res 1

.reset code
	global resetInitialise
	global resetGetTypeFlags

resetInitialise:
_saveResetRegistersForDebugging:
	movf STATUS, W
	banksel resetStatus
	movwf resetStatus

	banksel PCON0
	movf PCON0, W
	movwf resetPcon0
	movf PCON1, W
	movwf resetPcon1

_clearResetRegisters:
	movlw b'00111111'
	movwf PCON0
	movlw b'00000010'
	movwf PCON1

	return


_setFlagInWorkingAFor macro flag, workingBMask, workingCMask
	movf workingB, W
	andlw workingBMask
	xorlw workingBMask
	btfsc STATUS, Z
	bsf workingA, flag

	#if (workingCMask != 0)
		movf workingC, W
		andlw workingCMask
		xorlw workingCMask
		btfss STATUS, Z
		bcf workingA, flag
	#endif

	endm

;
; Determine the cause of the last reset.
;
; Returns a bitmask in W constructed using the _RESET_TYPE_FLAG_* values.
;
resetGetTypeFlags:
	clrf workingA

_extractPertinentFlags:
	banksel resetPcon0
	movf resetPcon0, W
	andlw (1 << STKOVF) | (1 << STKUNF) | (1 << NOT_RWDT) | (1 << NOT_RMCLR) | (1 << NOT_RI) | (1 << NOT_POR) | (1 << NOT_BOR)
	movwf workingB

	movf resetStatus, W
	andlw (1 << NOT_TO) | (1 << NOT_PD)
	movwf workingC

	movf resetPcon1, W
	andlw (1 << NOT_MEMV)
	iorwf workingC, F

_testIfPowerOnReset:
 ;;;;;;;;;;;;;; TODO: THIS IS WRONG - THE (0 << xxx) STILL NEED TO BE '1' FOR andlw BUT '0' FOR xorlw...(IE. THEY'RE NOT MASKED FOR THE COMPARISON AT PRESENT, SO EVEN IF THEY WERE '1' THEN THE COMPARISON WOULD STILL SUCCEED)
	_setFlagInWorkingAFor _RESET_TYPE_FLAG_POR, (0 << STKOVF) | (0 << STKUNF) | (1 << NOT_RWDT) | (1 << NOT_RMCLR) | (1 << NOT_RI) | (0 << NOT_POR), (1 << NOT_TO) | (1 << NOT_PD) | (1 << NOT_MEMV)
	movf workingA, F
	btfss STATUS, Z
	bra _resetReasonDetermined

_testIfBrownOutReset:
	_setFlagInWorkingAFor _RESET_TYPE_FLAG_BOR, (0 << STKOVF) | (0 << STKUNF) | (1 << NOT_RMCLR) | (1 << NOT_RI) | (0 << NOT_BOR), (1 << NOT_TO) | (1 << NOT_PD)
	movf workingA, F
	btfss STATUS, Z
	bra _resetReasonDetermined

_testIfMasterClearReset:
	_setFlagInWorkingAFor _RESET_TYPE_FLAG_MCLR, (0 << NOT_RMCLR), 0

_resetReasonDetermined:
_returnTheCompositeFlags:
	movf workingA, W
	return

	end
