; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data
	
aries: db'aries', 10
aries_len: equ $-aries
touro: db'touro', 10
touro_len: equ $-touro
gemeos: db'gemeos', 10
gemeos_len: equ $-gemeos
cancer: db'cancer', 10
cancer_len: equ $-cancer
leao: db'leao', 10
leao_len: equ $-leao
virgem: db'virgem', 10
virgem_len: equ $-virgem
libra: db'libra', 10
libra_len: equ $-libra
escorpiao: db'escorpiao', 10
escorpiao_len: equ $-escorpiao
sagitario: db'sagitario', 10
sagitario_len: equ $-sagitario
capricornio: db'capricornio', 10
capricornio_len: equ $-capricornio
aquario: db'aquario', 10
aquario_len: equ $-aquario
peixes: db'peixes', 10
peixes_len: equ $-peixes

	SECTION .bss

num:	resb 5
len: resb 5
string:	resb 5
a: resb 5
b: resb 5

	SECTION .text

	global _start:

_start:
	
	call read     ; chamando metodo de leitura
	call strToInt ; parser de string pra inteiro, guarda dia em [a] e mes em [b]
	mov eax, [a]  ; move para registrador pra realizar operacoes
	mov ebx, [b]
	cmp ebx, 1    ; sao feitas varias comparacoes para identificar qual 
	jne mes1      ; eh o signo certo. cada label tem um if e um jump 
	cmp eax, 20   ; para identificar se estamos no lugar certo
	jg mes0_1     ; caso isso aconteca, podemos imprimir o signo resultante
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, capricornio
	mov edx, capricornio_len
	int 0X80
	jmp final
mes0_1:          ; as labels foram separadas por meses, para simplificar
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, aquario
	mov edx, aquario_len
	int 0X80
	jmp final
mes1:            ; como cada mes conta com 2 signos, cada label se divide 
	cmp ebx, 2   ; em duas sublabels, uma para cada signo. asim que acharmos
	jne mes2     ; a label correta, imprimimos e pulamos para o fim.
	cmp eax, 19  ; o codigo eh assim ate o final.
	jg mes1_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, aquario
	mov edx, aquario_len
	int 0X80
	jmp final
mes1_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, peixes
	mov edx, peixes_len
	int 0X80
	jmp final
mes2:
	cmp ebx, 3
	jne mes3
	cmp eax, 20
	jg mes2_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, peixes
	mov edx, peixes_len
	int 0X80
	jmp final
mes2_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, aries
	mov edx, aries_len
	int 0X80
	jmp final
mes3:
	cmp ebx, 4
	jne mes4
	cmp eax, 20
	jg mes3_1 
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, aries
	mov edx, aries_len
	int 0X80
	jmp final
mes3_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, touro
	mov edx, touro_len
	int 0X80
	jmp final
mes4:
	cmp ebx, 5
	jne mes5
	cmp eax, 20
	jg mes4_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, touro
	mov edx, touro_len
	int 0X80
	jmp final
mes4_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, gemeos
	mov edx, gemeos_len
	int 0X80
	jmp final
mes5:
	cmp ebx, 6
	jne mes6
	cmp eax, 20
	jg mes5_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, gemeos
	mov edx, gemeos_len
	int 0X80
	jmp final
mes5_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, cancer
	mov edx, cancer_len
	int 0X80
	jmp final
mes6:
	cmp ebx, 7
	jne mes7
	cmp eax, 20
	jg mes6_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, cancer
	mov edx, cancer_len
	int 0X80
	jmp final
mes6_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, leao
	mov edx, leao_len
	int 0X80
	jmp final
mes7:
	cmp ebx, 8
	jne mes8
	cmp eax, 22
	jg mes7_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, leao
	mov edx, leao_len
	int 0X80
	jmp final
mes7_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, virgem
	mov edx, virgem_len
	int 0X80
	jmp final
mes8:
	cmp ebx, 9
	jne mes9
	cmp eax, 22
	jg mes8_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, virgem
	mov edx, virgem_len
	int 0X80
	jmp final
mes8_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, libra
	mov edx, libra_len
	int 0X80
	jmp final
mes9:
	cmp ebx, 10
	jne mes10
	cmp eax, 22
	jg mes9_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, libra
	mov edx, libra_len
	int 0X80
	jmp final
mes9_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, escorpiao
	mov edx, escorpiao_len
	int 0X80
	jmp final
mes10:
	cmp ebx, 11
	jne mes11
	cmp eax, 21
	jg mes10_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, escorpiao
	mov edx, escorpiao_len
	int 0X80
	jmp final
mes10_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, sagitario
	mov edx, sagitario_len
	int 0X80
	jmp final
mes11:
	cmp eax, 20
	jg mes11_1
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, sagitario
	mov edx, sagitario_len
	int 0X80
	jmp final
mes11_1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, capricornio
	mov edx, capricornio_len
	int 0X80
	jmp final
	

read:
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, num
	mov edx, 21
	int 0x80
ret

	;; Conforme explicado na Q1
strToInt:
	xor esi,esi
	xor ebx, ebx
	xor eax, eax
	call loopstrToInt1
	mov [a],edx
	inc ebx
	xor esi,esi
	xor eax,eax
	call loopstrToInt1
	mov[b],edx
ret
	
loopstrToInt1:
	mov al, [num+ebx]
	cmp eax, 40
	jl parte2
	sub eax, '0'
	push eax
	inc esi
	inc ebx
	jmp loopstrToInt1

	
parte2:
	xor edx, edx
	mov ecx, 1

loopstrToInt2:
	pop eax
	imul eax, ecx
	add edx, eax
	imul ecx, 10
	dec esi
	cmp esi, 0
	jne loopstrToInt2
ret

final:
	mov eax,1
	mov ebx,0
	int 0x80
