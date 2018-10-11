.386
.MODEL FLAT

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
.CODE

@findminmax@12 PROC
	PUSH EBP
	MOV EBP, [ESP+8]

	MOV ESI, ECX
	MOV AL, [ESI]
	MOV BL, [ESI]
	MOV CL, [ESI]

	CMP CL, 0
	JE END_PROC

	START:
		CMP CL, AL
		JAE NOT_MIN
			MOV AL, CL
		NOT_MIN:

		CMP CL, BL
		JBE NOT_MAX
			MOV BL, CL
		NOT_MAX:

		INC ESI
		MOV CL, [ESI]
		CMP CL, 0
		JNE START

	END_PROC:

	MOV [EDX], AL
	MOV [EBP], BL

	POP EBP
	RET 4
@findminmax@12 ENDP

END