; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data

debug:	db 10
debug_len:	equ $-debug
resultado:	db'Resultado: '
res_len:	equ $-resultado
resto:	db'Resto: '
resto_len:	equ $-resto
	
	SECTION .bss

num:	resb 5
string:	resb 5
a:	resb 5
b:	resb 5
op:	resb 5
	
	
	SECTION .text

	global _start

_start:
	;; le entrada

	call read
	call strToInt
	mov [a],edx

	call read
	call strToInt
	mov [b],edx
	
	call read

	mov al,[num]

	xor ebx,ebx
	xor ecx,ecx
	mov ebx,[a]
	mov ecx,[b]
	
	cmp eax, '+'
	jnz sub
	add ebx,ecx
	mov [a],ebx
	call res
	mov edx,[a]
	call imprimeInt
	
	jz final
sub:
	cmp eax,'-'
	jnz mult
	mov edx,ecx
	sub ebx,ecx
	mov [a],ebx
	call res
	mov edx,[a]
	call imprimeInt
	jz final

mult:
	cmp eax,'*'
	jnz div
	imul ebx,ecx
	mov edx,ebx
	mov [a],ebx
	call res
	mov edx,[a]
	call imprimeInt
	jz final

div:
	xor eax,eax
	mov eax,ebx
	xor edx, edx
	idiv ecx
	mov [a],edx		;resto em a
	mov [b],eax		;resposta
	call res
	mov edx,[b]
	call imprimeInt
	call dbg
	call rest
	mov edx,[a]
	call imprimeInt
	jz final

read:
	xor ecx, ecx
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

loopIntToStr1:
	mov ecx,10		;divisor
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

dbg:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,debug
	mov edx,debug_len
	int 0x80
ret

res:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,resultado
	mov edx, res_len
	int 0x80
ret

rest:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,resto
	mov edx, resto_len
	int 0x80
ret
	
final:
	mov eax,1
	mov ebx,0
	int 0x80
