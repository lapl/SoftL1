; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data

par: db'Par', 10
len_par: equ $-par
impar: db'Impar', 10
len_impar: equ $-impar

	SECTION .bss

string: resb 5

	SECTION .text

	global _start

_start:

	mov eax, sys_read
	mov ebx, stdin
	mov ecx, string
	mov edx, 6
	int 0X80

	mov edi, eax
	dec edi
	dec edi
	mov esi, [ecx+edi]
	sub esi, '0'
	and esi, 1
	jz even
	jnz odd

odd:

	mov ecx, impar
	mov eax, sys_write
	mov ebx, stdout
	mov edx, len_impar
	int 0X80
	jmp final   

even:

	mov ecx, par
	mov eax, sys_write
	mov ebx, stdout
	mov edx, len_par
	int 0X80
	jmp final

final:
	mov eax,1 ; aqui ele encerra o programa >> exit
	mov ebx,0
	int 0X80
