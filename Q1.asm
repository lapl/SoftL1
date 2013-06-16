; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data
	
igual:	db'Igual'
igual_len:	equ $-igual
maior:	db'Maior'
maior_len:	equ $-maior
menor:	db'Menor'
menor_len:	equ $-menor
debug:	db'Debug',10
debug_len:	equ $-debug
newline: db 10
newline_len:	 equ $-newline

	SECTION .bss

num:	resb 20
string:	resb 5
a: resb 5
b: resb 5
c: resb 5

	SECTION .text

	global _start:

_start:
	call read   ; a operacao de leitura
	call strToInt ; todos os numeros na mesma linha, chamamos esse metodo
	xor ebx, ebx  ; e ele guarda os numeros em [a], [b] e [c]
	mov ebx, [a]  ; abaixo, movemos as variaveis para os registrados, para
	xor ecx, ecx  ; podermos operar.
	mov ecx, [b]
	xor edx, edx
	mov edx, [c]
	add ebx, ecx  ; somamos [a] e [b].
	cmp ebx, edx
	je foi_igual  ; se [a]+[b] foi igual a c, pulamos para a label 
	jl foi_menor  ; e imprimimos que foi igual. Caso foi menor, tambem pulamos
	mov eax, sys_write ; e imprimimos. Caso nenhum dos dois aconteca. eh maior.
	mov ebx, stdout    ; imprimimos aqui mesmo.
	mov ecx, maior
	mov edx, maior_len
	int 0X80
	jmp final
	
foi_igual:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, igual
	mov edx, igual_len
	int 0X80
	jmp final
	
foi_menor:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, menor
	mov edx, menor_len
	int 0X80
	jmp final

read:
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, num
	mov edx, 21
	int 0x80
ret
	
strToInt:  ; parser cada loopstrToInt1 eh responsavel por ler um numero
	xor esi,esi ; ate achar um espaco
	xor ebx, ebx
	xor eax, eax
	call loopstrToInt1
	mov [a],edx
	inc ebx
	xor esi,esi
	xor eax,eax
	call loopstrToInt1
	mov[b],edx
	inc ebx
	xor esi,esi
	xor eax,eax
	call loopstrToInt1
	mov[c],edx
ret
	
loopstrToInt1:
	mov al, [num+ebx]
	cmp eax, 40		;sabemos que nao eh mais um algarismo do numero, entao podemos parar
	jl parte2
	sub eax, '0'
	push eax		;vamos colocando na pilha
	inc esi
	inc ebx
	jmp loopstrToInt1

	
parte2:
	xor edx, edx
	mov ecx, 1

	;; unidades*1+dezenas*10+centenas*100...
	;; ecx = 1,10,100,...
	;; o algarismo vem da pilha
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
