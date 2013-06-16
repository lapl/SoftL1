

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

	;; Pegamos a entrada do usuario e colocamos numa pilha, guardando tambem o tamanho.
	;; Para imprimir tiramos da pilha e imprimos. Isso ja vai reverter a string
	;; Implementamos tambem a opção de usar backspace.
	xor cx,cx
read:	
	mov ah, 0h
	int 16h
	push ax
	inc cx
	cmp al,13
	je fim			;se for Enter entao acabou de ler
	cmp al,8		;se for backspace vamos tratar de forma diferente
	je remove
	mov ah,0Eh
	int 10h
volta:	
	jmp read

fim:
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

	;; quando eh backspace precisamos primeiro tirar o proprio backspace da pilha, e reduzir cx. Depois voltamos o cursor,
	;; imprimimos um espaço, e voltamos o cursor novamente. Checamos se a pilha nao esta vazia, e caso nao esteja, reduzimos
	;; cx e tiramos o topo da pilha
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
	dec cx
	cmp cx,0
	je volta
	pop ax
	dec cx
	jmp volta

acabou:	
	
	;Fim do seu código. 
	

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
