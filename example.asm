.386
.MODEL FLAT, STDCALL
; ��������� ������� ������� (��������) ����������� ���������� EXTERN,
; ����� ����� @ ����������� ����� ����� ������������ ����������,
; ����� ��������� ����������� ��� �������� ������� � ���������
EXTERN GetStdHandle@4: PROC
EXTERN WriteConsoleA@20: PROC
EXTERN CharToOemA@8: PROC
EXTERN ReadConsoleA@20: PROC
EXTERN ExitProcess@4: PROC; ������� ������ �� ���������
EXTERN lstrlenA@4: PROC; ������� ����������� ����� ������
EXTERN wsprintfA: PROC; �.�. ����� ���������� ������� �� �����������,
; ������������ ����������, �������� �������� ������� ����
; ���������� ���������
.DATA; ������� ������
STRN DB "������� ������: ",13,10,0; ��������� ������, � ����� ���������
; ����������� �������: 13 � ������� �������, 10 � ������� �� �����
; ������, 0 � ����� ������; � �������������� ��������� DB
; ������������� ������ ������
FMT DB "����� %d", 0; ������ �� ������� �������� ��� ������� wsprintfA
DIN DD ?; ���������� �����; ��������� DD ����������� ������ �������
; 32 ���� (4 �����), ���� �?� ������������ ��� �������������������� ������
DOUT DD ?; ���������� ������
BUF DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
LENS DD ?; ���������� ��� ���������� ���������� ��������
.CODE; ������� ����
MAIN PROC; �������� ���������
; ������������ ������ STRN
MOV EAX, OFFSET STRN; �������� MOV �������� ������� ��������
; ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������������ ������ FMT
MOV EAX, OFFSET FMT
PUSH EAX
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������� ���������� �����
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX ; ����������� ��������� �� �������� EAX
; � ������ ������ � ������ DIN
; ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX
; ��������� ����� ������ STRN
PUSH OFFSET STRN; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX
; ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20
; ���� ������
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� �
; 10 � ������� �� ����� ������
; ����� ���������� ������
PUSH 0
PUSH OFFSET LENS
PUSH LENS; ����� �������� ������
PUSH OFFSET BUF
PUSH DOUT
CALL WriteConsoleA@20
; ����� ����� 123 � ����� BUF
PUSH 123
PUSH OFFSET FMT
PUSH OFFSET BUF
CALL wsprintfA
ADD ESP, 12; ������� ����� �� ���������� (��������� �������� ESP
; �� 3*4 = 12 ������)
; ����� ������ � ������ 123
PUSH 0
PUSH OFFSET LENS
PUSH EAX
PUSH OFFSET BUF
PUSH DOUT
CALL WriteConsoleA@20
; ��������� ��������
MOV ECX,03FFFFFFFH; ��������� � ������� ECX � ������� ����� �
; �������� ��������
L1: LOOP L1; ���� ��� ����
; ����� �� ���������
PUSH 0; ��������: ��� ������
CALL ExitProcess@4
MAIN ENDP
END MAIN