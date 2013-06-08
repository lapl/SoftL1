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

	SECTION .bss

num:	resb 5
string:	resb 5
a: resb 5
b: resb 5
c: resb 5

	SECTION .text

	global _start:

_start:
	call read
	call strToInt
	xor ebx, ebx
	mov ebx, [a]
	xor ecx, ecx
	mov ecx, [b]
	xor edx, edx
	mov edx, [c]
	add ebx, ecx
	cmp ebx, edx
	je foi_igual
	jl foi_menor
	mov eax, sys_write
	mov ebx, stdout
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
	mov edx, 6
	int 0x80
ret
	
strToInt:
	mov esi, 0
	xor ebx, ebx
	xor eax, eax
	call loopstrToInt1
	xor edx, edx
	mov ecx, 1
	call loopstrToInt2
	mov [a], edx
	inc ebx
	call loopstrToInt1
	xor edx, edx
	mov ecx, 1
	call loopstrToInt2
	mov [b], edx
	inc ebx
	call loopstrToInt1
	xor edx, edx
	mov ecx, 1
	call loopstrToInt2
	mov [c], edx
ret
	
loopstrToInt1:
	mov al, [num+ebx]
	cmp eax, 40
	jl acaba
	sub eax, '0'
	push eax
	inc esi
	inc ebx
	jmp loopstrToInt1
	acaba:
ret

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
