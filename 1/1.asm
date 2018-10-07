.386
.MODEL FLAT, STDCALL

EXTERN GetStdHandle@4: PROC
EXTERN WriteConsoleA@20: PROC
EXTERN CharToOemA@8: PROC
EXTERN ReadConsoleA@20: PROC
EXTERN ExitProcess@4: PROC
EXTERN lstrlenA@4: PROC

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
.DATA
enterStr1 DB "������� ������ ����� � 16 ������� ���������: ", 0
enterStr1Len DD ?

enterStr2 DB "������� ������ ����� � 16 ������� ���������: ", 0
enterStr2Len DD ?

writeStr DB "��������� ��������� ���� ����� � 10 ������� ���������: ", 0
writeStrLen DD ?

errorStr DB "�� ����� ����� �����������, ���������� �����: ", 0
errorStrLen DD ?

firstNumber DD ?
secondNumber DD ?

DIN DD ?
DOUT DD ?

BUF DB 16 dup (?)
readedLen DD ?

digitsCount DD ?

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
.CODE

;------------------------------------------------------------------------------
; ���������� � EAX ��������� ����� � ����������������� ������� ���������.
; ���� ����� ������� �����������, ��������� �����
EnterNumber PROC
	START:
	; ���� ������
	PUSH 0
	PUSH OFFSET readedLen
	PUSH 16
	PUSH OFFSET BUF
	PUSH DIN
	CALL ReadConsoleA@20
	SUB readedLen, 2

	CMP readedLen, 0
	JE WRITE_INCORRECT

	; ������� � ������ �������
	MOV ECX, readedLen
	MOV ESI, OFFSET BUF
	XOR EAX, EAX
	TOLOW:
		MOV AL, [ESI]
		CMP AL, 'A'
		JB ELSE_UPPER
		CMP AL, 'Z'
		JA ELSE_UPPER
			SUB AL, 'A'
			ADD AL, 'a'
			MOV [ESI], AL 
		ELSE_UPPER:
		INC ESI
	LOOP TOLOW

	; �������� �� ������������
	MOV ECX, readedLen
	MOV ESI, OFFSET BUF
	CHECK:
		XOR EAX, EAX
		XOR EBX, EBX
		MOV AL, [ESI]

		CMP AL, 'a'
		JB NOT_SYMBOL
		CMP AL, 'f'
		JA NOT_SYMBOL
			MOV BL, 1
		NOT_SYMBOL:

		CMP AL, '0'
		JB NOT_NUMBER
		CMP AL, '9'
		JA NOT_NUMBER
			JMP ALL_CORRECT
			WRITE_INCORRECT:
				PUSH 0
				PUSH OFFSET errorStrLen
				PUSH errorStrLen
				PUSH OFFSET errorStr
				PUSH DOUT
				CALL WriteConsoleA@20
				JMP START
		NOT_NUMBER:
			CMP BL, 1
			JNE WRITE_INCORRECT
		ALL_CORRECT:
		INC ESI
	LOOP CHECK

	; ������� ����� � ������� EAX
	MOV ECX, readedLen
	MOV ESI, OFFSET BUF
	XOR EAX, EAX
	TRANSLATION:
		XOR EBX, EBX
		MOV BL, [ESI]

		CMP BL, 'a'
		JB NOT_SYMBOL1
		CMP BL, 'f'
		JA NOT_SYMBOL1
			SUB BL, 'a'
			ADD BL, 10
			ADD EAX, EBX
		NOT_SYMBOL1:

		CMP BL, '0'
		JB NOT_NUMBER2
		CMP BL, '9'
		JA NOT_NUMBER2
			SUB BL, '0'
			ADD EAX, EBX
		NOT_NUMBER2:
		INC ESI
		MOV EDX, 16
		MUL EDX
	LOOP TRANSLATION
	MOV ECX, 16
	DIV ECX

	RET
EnterNumber ENDP

;------------------------------------------------------------------------------
; ������� ����� �� �������� EAX � 10 ������� ���������
WriteNumber PROC
	MOV digitsCount, 0
	MOV ECX, 10
	DECOMPOSE:
		XOR EDX, EDX
		DIV ECX
		PUSH EDX
		INC digitsCount
		CMP EAX, 0
		JNE DECOMPOSE

	MOV ECX, digitsCount
	MOV ESI, OFFSET BUF
	WRITING:
		POP EAX
		ADD EAX, '0'
		MOV [ESI], AL
		INC ESI
	LOOP WRITING
	MOV AL, 13
	MOV [ESI], AL
	INC ESI
	MOV AL, 10
	MOV [ESI], AL
	INC ESI
	MOV AL, 0
	MOV [ESI], AL
	INC ESI

	ADD digitsCount, 2

	; ����� ���������� ������
	PUSH 0
	PUSH OFFSET digitsCount
	PUSH digitsCount
	PUSH OFFSET BUF
	PUSH DOUT
	CALL WriteConsoleA@20

	RET
WriteNumber ENDP

;------------------------------------------------------------------------------
MAIN PROC
	; ������� ���������� �����
	PUSH -10
	CALL GetStdHandle@4
	MOV DIN, EAX

	; ������� ���������� ������
	PUSH -11
	CALL GetStdHandle@4
	MOV DOUT, EAX

	;--------------------------------------------------------------------------
	; ������������ ������ enterStr
	MOV EAX, OFFSET enterStr1
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	MOV EAX, OFFSET enterStr2
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	; ������������ ������ writeStr
	MOV EAX, OFFSET writeStr
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	; ������������ ������ errorStr
	MOV EAX, OFFSET errorStr
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	;--------------------------------------------------------------------------
	; ��������� ����� ������ enterStr
	PUSH OFFSET enterStr1
	CALL lstrlenA@4
	MOV enterStr1Len, EAX

	PUSH OFFSET enterStr2
	CALL lstrlenA@4
	MOV enterStr2Len, EAX

	; ��������� ����� ������ writeStr
	PUSH OFFSET writeStr
	CALL lstrlenA@4
	MOV writeStrLen, EAX

	; ��������� ����� ������ erorrStr
	PUSH OFFSET errorStr
	CALL lstrlenA@4
	MOV errorStrLen, EAX

	;--------------------------------------------------------------------------
	;--------------------------------------------------------------------------
	;--------------------------------------------------------------------------

	;--------------------------------------------------------------------------
	; ������� enterStr1
	PUSH 0
	PUSH OFFSET enterStr1Len
	PUSH enterStr1Len
	PUSH OFFSET enterStr1
	PUSH DOUT
	CALL WriteConsoleA@20

	; ���� ������� �����
	CALL EnterNumber
	MOV firstNumber, EAX

	;--------------------------------------------------------------------------
	; ������� enterStr2
	PUSH 0
	PUSH OFFSET enterStr2Len
	PUSH enterStr2Len
	PUSH OFFSET enterStr2
	PUSH DOUT
	CALL WriteConsoleA@20

	; ���� ������� �����
	CALL EnterNumber
	MOV secondNumber, EAX

	;--------------------------------------------------------------------------
	; �������� ��� �����
	MOV EAX, firstNumber
	MOV EDX, secondNumber
	MUL EDX
	MOV firstNumber, EAX

	;--------------------------------------------------------------------------
	; ������� ������ � ����������� ����������
	PUSH 0
	PUSH OFFSET writeStrLen
	PUSH writeStrLen
	PUSH OFFSET writeStr
	PUSH DOUT
	CALL WriteConsoleA@20

	;--------------------------------------------------------------------------
	; ������� ����� � ���������� ������� ���������
	MOV EAX, firstNumber
	CALL WriteNumber

	;--------------------------------------------------------------------------
	;--------------------------------------------------------------------------
	;--------------------------------------------------------------------------

	;--------------------------------------------------------------------------
	MOV ECX,0FFFFFFFFH
	L1: LOOP L1

	PUSH 0
	CALL ExitProcess@4
MAIN ENDP

END MAIN