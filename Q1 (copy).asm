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
	mov [a], edx
	call read
	call strToInt
	mov [b], edx
	call read
	call strToInt
	mov [c], edx
	
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
	int 0x80
	xor eax,eax
	jz final
	
foi_igual:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, igual
	mov edx, igual_len
	int 0x80
	xor eax,eax
	jz final
ret
	
foi_menor:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, menor
	mov edx, menor_len
	int 0x80
	xor eax,eax
	jz final
ret

read:
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, num
	mov edx, 6
	int 0x80
ret
	
strToInt:
	xor ebx,ebx
	xor esi,esi
	xor edx,edx
	mov ebx,eax
	dec ebx
	mov esi, ebx		;tamanho
	mov ecx,1		;1,10,100
	
loopstrToInt:
	dec ebx
	mov al, [num+ebx]
	sub eax,'0'
	imul eax,ecx
	add edx,eax
	imul ecx,10
	dec esi
	cmp esi,0
	jne loopstrToInt
ret

imprimeInt:
	mov eax,edx		;guarda o inteiro
	xor esi,esi 		;tamanho

	mov ecx,10		;divisor
loopIntToStr1:
	xor edx,edx		;resto
	idiv ecx		;eax = eax/ecx, edx = eax%ecx
	push edx
	inc esi
	cmp eax,0
	jne loopIntToStr1

loopIntToStr2:
	xor eax,eax
	pop eax
	add eax,'0'
	mov [string], eax

	;; imprime
	mov eax,sys_write
	mov ebx,stdout
	mov ecx, string
	mov edx, 1
	int 0x80
	
	dec esi
	cmp esi,0
	jne loopIntToStr2
ret
	
final:
	mov eax,1
	mov ebx,0
	int 0x80
