

;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

start:

	; nunca se esqueca de zerar o ds,
	; pois apartir dele que o processador busca os 
	; dados utilizados no programa.
	xor ax, ax
	mov ds, ax
	;Início do seu código

	xor cx,cx
read:	
	mov ah, 0h
	int 16h
	push ax
	inc cx
	cmp al,13
	je fim
	cmp al,8
	je remove
	mov ah,0Eh
	int 10h
volta:	
	jmp read

fim:	
	inc cx
	mov al,10
	mov ah,0Eh
	int 10h
	
write:	
	pop ax
	mov ah, 0Eh
	int 10h
	dec cx
	cmp cx,0
	jne write
	jmp acabou

remove:
	pop ax
	mov ah,0Eh
	int 10h
	mov ax,32
	mov ah,0Eh
	int 10h
	mov ax,8
	mov ah,0Eh
	int 10h
	pop ax
	dec cx
	dec cx
	jmp volta

acabou:	
	
	;Fim do seu código. 
	

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
