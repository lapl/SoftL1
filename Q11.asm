;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

Nomes db'BlackBlueGreenCyanRedMagentaBrownLightGrayDarkGrayLightBlueLightGreenLightCyanLightRed'
tam db'!&*/36=BKS\fow'
Nomes_2 db'LightMagentaYellowWhite'
tam_2 db'!-38'
	
start:

	; nunca se esqueca de zerar o ds,
	; pois apartir dele que o processador busca os 
	; dados utilizados no programa.
	xor ax, ax
	mov ds, ax	
	
	; Início do seu código
	mov dx, 0 ; Set cursor to top left-most corner of screen
        mov bh, 0      
        mov ah, 0x2
        int 0x10
        mov cx, 2000 ; print 2000 chars
        mov bh, 0
        mov bl, 00001111b ; green bg/blue fg
        mov al, 0x20 ; blank char
        mov ah, 0x9
        int 0x10
        mov dx, 0 ; Set cursor to top left-most corner of screen
        mov bh, 0      
        mov ah, 0x2
        int 0x10
while:	
	mov ah,0h
	int 16h
	mov ah,0Eh
	int 10h
	;; vamos ver se ta entre '1' e '9' ou entre 'a' e 'h'
	cmp al,'9'
	jg hexa1
	sub al, '0'
volta1:
	
	xor dx,dx
	mov dl,al		;salvei primeira cor em dl

	xor ax,ax
	mov ah,0h
	int 16h
	mov ah,0Eh
	int 10h

	cmp al,'9'
	jg hexa2
	sub al,'0'

volta2:	
	xor cx,cx
	mov cl,al		;outra cor em cl

	cmp dl,cl
	je fim
	
	mov bl,dl		;primeira cor
	cmp bl,12
	jg outro_caso
	push cx			;botei cor 2 na pilha
	mov cl,[tam+bx]
	inc bx
	mov dl,[tam+bx]
	sub dl,cl		;dl guarda o tamanho da palavra
	dec bx
	pop ax 			;tirei cor 2 da pilha
	push bx
	imul bx, 16
	add bx,ax
	push ax			;bota de volta
	push cx

	mov al,32
	mov ah,09h
	mov cx,dx
	int 10h

	pop cx
	sub cl,'!'
	mov bl, cl		;bl guarda onde começa a olhar
	add dl,bl		;dl guarda onde termina de olhar

print1:
	mov al,[Nomes+bx]
	mov ah,0Eh
	int 10h
	inc bx
	cmp bl,dl
	jne print1
	jmp segunda_palavra

outro_caso:
	push cx			;botei cor 2 na pilha
	push bx
	sub bl,13
	mov cl,[tam_2+bx]
	inc bx
	mov dl,[tam_2+bx]
	sub dl,cl		;dl guarda o tamanho da palavra
	pop bx
	pop ax			;tirei cor 2 da pilha
	push bx
	imul bx, 16
	add bx,ax
	push ax			;bota de volta
	push cx
	mov al,32
	mov ah,09h
	mov cx,dx
	int 10h
	pop cx
	
	sub cl,'!'
	mov bl, cl		;bl guarda onde começa a olhar
	add dl,bl		;dl guarda onde termina de olhar

print2:
	mov al,[Nomes_2+bx]
	mov ah,0Eh
	int 10h
	inc bx
	cmp bl,dl
	jne print2
	jmp segunda_palavra
	
hexa1:
	sub al,'A'
	add al,10
	jmp volta1

hexa2:
	sub al,'A'
	add al,10
	jmp volta2

segunda_palavra:

	pop cx 			;segunda cor
	mov al,cl
	pop dx			;primeira cor
	mov al,dl

	push dx
	imul dx,16
	add dx,cx

	push cx
	mov bx,dx
	mov al,32
	mov ah,09h
	mov cx,1
	int 10h
	
	mov al,'&'
	mov ah,0Eh
	int 10h

	pop dx			;segunda
	pop cx			;primeira
	mov bl,dl		
	cmp bl,12
	jg outro_caso_2
	push cx		
	mov cl,[tam+bx]
	inc bx
	mov dl,[tam+bx]
	sub dl,cl
	dec bx
	
	pop ax
	imul ax,16
	add ax,bx
	mov bx,ax
	push cx

	mov al,32
	mov ah,09h
	mov cx,dx
	int 10h

	pop cx
	sub cl,'!'
	mov bl,cl
	add dl,bl

print3:
	mov al,[Nomes+bx]
	mov ah,0Eh
	int 10h
	inc bx
	cmp bl,dl
	jne print3
	jmp next
outro_caso_2:
	push cx
	push bx
	sub bl,13
	mov cl,[tam_2+bx]
	inc bx
	mov dl,[tam_2+bx]
	sub dl,cl
	pop bx
	pop ax
	imul ax,16
	add ax,bx
	mov bx,ax
	push cx

	mov al,32
	mov ah,09h
	mov cx,dx
	int 10h

	pop cx
	sub cl,'!'
	mov bl,cl
	add dl,bl

print4:
	mov al,[Nomes_2+bx]
	mov ah,0Eh
	int 10h
	inc bx
	cmp bl,dl
	jne print4

	jmp next
next:
	mov al,10
	mov ah,0Eh
	int 10h
	mov al,13
	mov ah,0Eh
	int 10h
	jmp while
fim:
	;Fim do seu código. 
	

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
