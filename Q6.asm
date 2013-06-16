; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data

newline:	db 10
newline_len:	equ $-newline
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

	call read    ; metodo de leitura
	call strToInt ; transformamos para inteiro e transferimos
	mov [a],edx   ; o valor para [a]

	call read     ; mesma coisa, e trasnferimos o valor para [b]
	call strToInt
	mov [b],edx
	
	call read    ; metodo de leitura, trasferimos o resultado para [num]

	mov al,[num] 

	xor ebx,ebx
	xor ecx,ecx
	mov ebx,[a]  ; trasferimos as variaves para os registradores
	mov ecx,[b]  ; para poder operar.
	
	cmp eax, '+' ; comparamos a ultima string recebida ate achar qual
	jnz sub      ; operacao foi realizada
	add ebx,ecx  ; no caso da soma, somamos e imprimimos apos passar de volta
	mov [a],ebx  ; pra string
	call res
	mov edx,[a]
	call imprimeInt
	
	jmp final
sub:            ; no caso da subtracao, procedimento semelhante.
	cmp eax,'-'
	jnz mult
	mov edx,ecx
	sub ebx,ecx
	mov [a],ebx
	call res
	mov edx,[a]
	call imprimeInt
	jmp final

mult:          ; assim como no caso da multiplicacao
	cmp eax,'*'
	jnz div
	imul ebx,ecx
	mov edx,ebx
	mov [a],ebx
	call res
	mov edx,[a]
	call imprimeInt
	jmp final

div:      ; no caso da divisao, o resta fica em edx e o quociente em eax
	xor eax,eax  ; temos que imprimir os dois, e com uma quebra de linha no meio.
	mov eax,ebx  ; eh o que faz o metodo 'dbg'
	xor edx, edx
	idiv ecx
	mov [a],edx		;resto em a
	mov [b],eax		;resposta
	call res
	mov edx,[b]
	call imprimeInt
	call NL
	call rest
	mov edx,[a]
	call imprimeInt
	jmp final

read:
	xor ecx, ecx
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, num
	mov edx, 6
	int 0x80
ret

strToInt:  ; parser
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

NL:				;funcao pra imprimir uma nova linha
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,newline
	mov edx,newline_len
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
