.386
.MODEL FLAT

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
.CODE

;------------------------------------------------------------------------------
process_word MACRO from, to
	LOCAL start_cycle_1, end_cycle_1, start_cycle_2, end_cycle_2

	; Переписываем слово до тех пор, пока не встретим пробел, либо конец строки
	start_cycle_1:
	CMP byte ptr [from], 32
	JE end_cycle_1
	CMP byte ptr [from], 0
	JE end_cycle_1
		MOV AH, byte ptr [from]
		MOV byte ptr [to], AH
		INC from
		INC to
		JMP start_cycle_1
	end_cycle_1:

	; Записываем пробел
	MOV byte ptr [to], 32
	INC to

	; Проходим лишние пробелы
	start_cycle_2:
	CMP byte ptr [from], 32
	JNE end_cycle_2
	CMP byte ptr [from], 0
	JE end_cycle_2
		INC from
		JMP start_cycle_2
	end_cycle_2:
ENDM

;------------------------------------------------------------------------------
@delete_extra_spaces@8 PROC
	PUSH EBP
	; ECX - str
	; EDX - result

	; Костыль, на случай, если входная строка пустая
	MOV byte ptr [EDX], 0

	; Не учитываем первые пробелы
	start_cycle_1:
	CMP byte ptr [ECX], 32
	JNE end_cycle_1
	CMP byte ptr [ECX], 0
	JE end_cycle_1
		INC ECX
		JMP start_cycle_1
	end_cycle_1:

	; Обрабатываем каждое слово
	start_cycle:
	CMP byte ptr [ECX], 0
	JE end_cycle
		process_word ECX, EDX
		JMP start_cycle
	end_cycle:

	; Удалем последний пробел
	CMP byte ptr [EDX], 0
	JE not_delete_space_1
		DEC EDX
		CMP byte ptr [EDX], 32
		JE not_delete_space_2
			INC EDX	
		not_delete_space_2:
	not_delete_space_1:

	MOV byte ptr [EDX], 0

	POP EBP
	RET
@delete_extra_spaces@8 ENDP

END