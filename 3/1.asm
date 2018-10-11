.386
.MODEL FLAT

.DATA
	x REAL4 ?
	d REAL4 ?
	dp REAL4 ?
	c3 REAL4 3.
	c2 REAL4 2.

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
.CODE

;------------------------------------------------------------------------------
f PROC ; d = f(x)
	; log2((x-1)/3)/log2(e)/3 = 1 1 x - 3 / log2 log2(e) / 3 /
	FLD1   ; Stack: 1
	FLD1   ; Stack: 1, 1
	FLD x  ; Stack: 1, 1, x
	FSUBRP ; Stack: 1, x-1
	FLD c3 ; Stack: 1, x-1, 3
	FDIVP  ; Stack: 1, (x-1)/3
	FYL2X  ; Stack: log2((x-1)/3)
	FLDL2E ; Stack: log2((x-1)/3), log2(e)
	FDIVP  ; Stack: ln((x-1)/3)
	FLD c3 ; Stack: ln((x-1)/3), 3
	FDIVP  ; Stack: ln((x-1)/3)/3

	FSTP d

	RET
f ENDP

;------------------------------------------------------------------------------
fp PROC ; dp = f'(x)
	; 1/(x-1)/3 = 1 x 1 - / 3 /
	FLD1   ; Stack: 1
	FLD x  ; Stack: 1, x
	FLD1   ; Stack: 1, x, 1
	FSUBP  ; Stack: 1, x-1
	FDIVP  ; Stack: 1/(x-1)
	FLD c3 ; Stack: 1/(x-1), 3
	FDIVP  ; Stack: 1/(x-1)/3

	FSTP dp

	RET
fp ENDP

;------------------------------------------------------------------------------
;@newton_movable_pole@12 PROC
?newton_movable_pole@@YIXPAM0PAH@Z PROC
	PUSH EBP
	MOV EBP, [ESP+8]

	; ECX - float eps address
	; EDX - float x address
	; EBP - int iterations address

	; iterations = 0
	MOV dword ptr [EBP], 0 

	; x = x0
	MOV EAX, [EDX]
	MOV x, EAX

	FINIT
	START:
		; d = f(x)
		CALL f

		; while (fabs(f(x)) > eps)
		FLD dword ptr [ECX] ; push eps
		FLD d               ; push fabs(f(x))
		FABS
		FCOMPP              ; fabs(f(x)) > eps
		FSTSW AX
		SAHF
		JBE END_OF_CYCLE

		; dp = f'(x)
		CALL fp

		; x - d/dp/(1 - d/(d - 2)) = x d dp / 1 d d 2 - / - / -
		FLD x  ; Stack: x
		FLD d  ; Stack: x, d
		FLD dp ; Stack: x, d, dp
		FDIVP  ; Stack: x, d/dp
		FLD1   ; Stack: x, d/dp, 1
		FLD d  ; Stack: x, d/dp, 1, d
		FLD d  ; Stack: x, d/dp, 1, d, d
		FLD c2 ; Stack: x, d/dp, 1, d, d, 2
		FSUBP  ; Stack: x, d/dp, 1, d, d - 2
		FDIVP  ; Stack: x, d/dp, 1, d/(d - 2)
		FSUBP  ; Stack: x, d/dp, 1 - d/(d - 2)
		FDIVP  ; Stack: x, d/dp/(1 - d/(d - 2))
		FSUBP  ; Stack: x - d/dp/(1 - d/(d - 2))

		; x = x - d/dp/(1 - d/(d - 2))
		FSTP x

		; iterations++
		INC dword ptr [EBP]

		JMP START
	END_OF_CYCLE:

	; внешний x = внутренний x
	MOV EAX, x
	MOV [EDX], EAX 

	POP EBP
	RET 4
;@newton_movable_pole@12 ENDP
?newton_movable_pole@@YIXPAM0PAH@Z ENDP

END