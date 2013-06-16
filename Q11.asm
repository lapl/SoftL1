;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

	;; A explicação do porquê desses strings e como eles funcionam eh a mesma da questao 10.
	;; A diferença eh que precisamos de mais 2 porque so temos caracteres imprimiveis ate 126,
	;; o que faz com que nao caiba em um tam so
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

	;; Codigo para limpar a tela
	mov dx, 0 ; Set the cursor to top left-most corner of screen
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
while:				;vai repetir enquanto as duas cores nao forem iguais
	mov ah,0h
	int 16h
	mov ah,0Eh
	int 10h
	;; vamos ver se ta entre '1' e '9' ou entre 'A' e 'H'
	cmp al,'9'
	jg hexa1
	sub al, '0'		;se ta entre '1' e '9'eh so subtrair de '0'
volta1:
	
	xor dx,dx
	mov dl,al		;salvei primeira cor em dl

	xor ax,ax
	mov ah,0h
	int 16h
	mov ah,0Eh
	int 10h

	cmp al,'9'		;pega a segunda cor e faz a mesma coisa
	jg hexa2
	sub al,'0'

volta2:	
	xor cx,cx
	mov cl,al		;outra cor em cl

	cmp dl,cl		;se forem iguais, entao acabou o programa
	je fim
	
	mov bl,dl		;primeira cor em bl
	cmp bl,12		;se a primeira cor for maior que 12, entao ta na outra string
	jg outro_caso
	push cx			;botei cor 2 na pilha
	mov cl,[tam+bx]		;começo do nome da cor
	inc bx
	mov dl,[tam+bx]		;fim do nome da cor
	sub dl,cl		;dl guarda o tamanho da palavra
	dec bx
	pop ax 			;tirei cor 2 da pilha
	push bx
	imul bx, 16		;temos que colocar em bx 16*background+foreground
	add bx,ax
	push ax			;bota de volta
	push cx

	mov al,32		;imprimos espaços em branco
	mov ah,09h		;pra pintar com cor
	mov cx,dx		;o tamanho estava em dx
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

outro_caso:			;eh a mesma coisa, so muda onde olhar e as contas algumas pequenas modificaçoes
	push cx			;botei cor 2 na pilha
	push bx
	sub bl,13		;começa de 13 pq de 0 a 12 ta na outra string
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
	;; no caso maior que '9' subtraimos de 'A' depois somamos com 10. Entao A = 10, B = 11, ..., F = 15
	sub al,'A'
	add al,10
	jmp volta1

hexa2:
	sub al,'A'
	add al,10
	jmp volta2

segunda_palavra:		;a mesma coisa q foi feita para a primeira cor, mas para a segunda

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
	mov al,10		;quebra a linha e volta o cursor pro começo da linha
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
