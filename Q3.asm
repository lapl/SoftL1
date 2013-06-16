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
	mov eax, sys_read   ; leitura
	mov ebx, stdin
	mov ecx, string
	mov edx, 21 		; 21 por causa do \n
	int 0X80

	mov edi, 1

imprime:                 ; loop para escrever 
	mov eax, sys_write
	mov ebx, stdout
	int 0X80
	
	inc edi
	cmp byte[ecx+edi], 0 ; loop acontecera ate que proxima posicao da string
	jnz imprime 		 ; nao seja 0. quando isso acontecer, a string acabou.
	jmp final			 ; se nao imprime mais, pula para o fim do programa.

final:
	mov eax, 1 
	mov ebx, 0
	int 0X80
