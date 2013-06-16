; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data

primo:	db'Primo',10
primo_len:	equ $-primo
notprimo:	db'Nao primo',10
notprimo_len:	equ $-notprimo
	
	SECTION .bss

num:	resb 5
string:	resb 5
a:	resb 5

	SECTION .text

	global _start

_start:
	call read
	call strToInt
	mov [a],edx

	;; 0 e 1 nao sao primos
	cmp edx,0
	je notPrime
	cmp edx,1
	je notPrime

	;; Vamos fazer um loop de 2 ate sqrt(n), e ve se ha algum divisor, se nao tiver, sabemos que eh primo
	mov esi, 2

loop:
	mov ecx,esi
	imul ecx,ecx		;ao inves de fazermos i < sqrt(n), fazemos i*i<n
	cmp ecx,[a]
	jg prime

	mov eax,[a]
	mov ecx,esi
	xor edx,edx
	idiv ecx
	cmp edx,0		;se o resto for zero, entao eh divisivel
	je notPrime
	inc esi
	jmp loop


prime:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx, primo
	mov edx, primo_len
	int 0x80
	jmp final
	
notPrime:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx, notprimo
	mov edx, notprimo_len
	int 0x80
	jmp final

	
	
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


final:
	mov eax,1
	mov ebx,0
	int 0x80
