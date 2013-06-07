SECTION .data

par: db'Par', 10
impar: db'Impar', 10

SECTION .bss

string: resb 5

SECTION .text

	global _start

_start:

mov eax, 3
mov ebx, 0
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
mov eax, 4
mov ebx, 1	
int 0X80
jmp final   

even:

mov ecx, par
mov eax, 4
mov ebx, 1
int 0X80
jmp final

final:
	mov eax,1 ; aqui ele encerra o programa >> exit
	mov ebx,0
	int 0X80
