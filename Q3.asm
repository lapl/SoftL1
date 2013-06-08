; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .bss

string: resb 20

	SECTION .text

	global _start

_start:
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, string
	mov edx, 21 		;21 por causa do \n
	int 0X80

	mov edi, 1

imprime:
	mov eax, sys_write
	mov ebx, stdout
	int 0X80
	
	inc edi
	cmp byte[ecx+edi], 0
	jnz imprime
	jmp final

final:
	mov eax, 1 
	mov ebx, 0
	int 0X80
