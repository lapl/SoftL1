;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

msg db'(Programa encerrado com sucesso!)'
len equ $-msg

start:

	; nunca se esqueca de zerar o ds,
	; pois apartir dele que o processador busca os 
	; dados utilizados no programa.
	xor ax, ax
	mov ds, ax

	;Início do seu código


	xor bx,bx
	;; Suporta as operaçoes de inserção, deleção na mesma linha e quebra de linha
read:
	mov ah, 0h
	int 16h
	cmp al,17		;se for ctrl+Q entao acabou
	je fim
	cmp al,8		;se for backspace removemos
	je remove
	cmp al,13		;se for enter quebramos a linha
	je enter
	mov ah,0Eh		;se nao, so escrevemos o digitado
	int 10h
volta:
	jmp read		;continuamos lendo
fim:				 
	mov al,10		;quebramos a linha e voltamos o cursor, para depois exibir a mensagem exigida
	mov ah,0Eh
	int 10h
	mov al,13
	mov ah,0Eh
	int 10h
	xor bx,bx
		
print:
	mov ax,[msg+ebx]
	mov ah, 0Eh
	int 10h
	inc bx
	cmp bx,len
	jne print

	jmp acabou

	;; Voltamos o cursor, imprimimos um espaço, dps voltamos o cursor.
remove:
	mov ah,0Eh
	int 10h
	mov ax,32
	mov ah,0Eh
	int 10h
	mov ax,8
	mov ah,0Eh
	int 10h
	jmp volta

	;; quebra a linha e volta pro começo da linha
enter:
	mov ax,10
	mov ah,0Eh
	int 10h
	mov ax,13
	mov ah,0Eh
	int 10h
	jmp volta
	
acabou:	
	;Fim do seu código. 


times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
