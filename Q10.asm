;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

Palavras db'typeracerisaquitenicegame'
tam db'!*,-26:'
deacuracia db' de acuracia'
voceteve db'Voce teve '
string:	resb 20
total:	resw 4

start:

	; nunca se esqueca de zerar o ds,
	; pois apartir dele que o processador busca os 
	; dados utilizados no programa.
	xor ax, ax
	mov ds, ax

	;Início do seu código
	mov word[total],0
	xor bx,bx		;bx eh o indice da palavra
print_phrase:
	cmp bx,0
	je not_space
	mov al,' '
	call print
not_space:	
	xor dx,dx
	xor cx,cx
	mov dl,[tam+bx]
	inc bx
	mov cl,[tam+bx]
	dec bx
	sub cl,dl		;cl guarda o tamanho
	sub dl,'!'		;dl onde começa
	add cl,dl		;cl onde termina
	push bx			;guarda bx na pilha
	mov bl,dl
printoso:
	mov al,[Palavras+bx]
	call print
	inc bx
	cmp bx,cx
	jne printoso
	pop bx			;pega bx de volta
	inc bx
	cmp bx,6		;qtd de palavras
	jne print_phrase

	mov al,10
	call print
	mov al,13
	call print
	xor bx,bx

game:
	push bx			;bota contador
	xor bx,bx
get_word:
	xor ax,ax
	mov ah,0h
	int 16h
	mov [string+bx],al
	inc bx
	cmp al,' '
	jne get_word

	mov cx,bx
	dec cx
	mov di,cx			;tamanho de string
	xor bx,bx
print_word:
	mov al,[string+bx]
	call print
	inc bx
	cmp cx,bx
	jne print_word

	;; calcular acuracia
	pop bx
	xor dx,dx
	xor cx,cx
	mov dl,[tam+bx]
	inc bx
	mov cl,[tam+bx]
	dec bx
	sub cl,dl		;cl guarda o tamanho
	push cx			;tamanho na pilha
	sub dl,'!'		;dl onde começa
	add cl,dl		;cl onde termina
	push bx			;bota contador na pilha
	mov si,dx		;contador na string de Palavras
	xor bx,bx		;contador na string digitada
	xor dx,dx		;acertos

compara:
	mov al,[Palavras+si]
	cmp al,[string+bx]
	jne erro
	inc dx
erro:	
	inc si
	inc bx
	cmp si,cx
	jne compara

	mov al,' '
	call print
	pop bx
	pop cx
	push bx
	cmp cx, di
	jg bla
	mov ax, dx
	xor dx, dx
	imul ax, 1000
	div di
	add [total],ax
	mov cx, ax
	call print_seta
	call print2
	push bx
	xor bx,bx
	call print_de_acuracia
	pop bx
	jmp cont
bla:
	mov ax,dx
	xor dx, dx
	imul ax, 1000
	div cx
	add [total],ax
	mov cx, ax
	call print_seta
	call print2
	push bx
	xor bx,bx
	call print_de_acuracia
	pop bx
cont:	
	mov al,10
	call print
	mov al,13
	call print
	pop bx			;pega contador
	inc bx
	cmp bx,6		;qtd de palavras
	
	jne game
	jmp fim

print:	
	mov ah,0Eh
	int 10h
ret

print_seta:
	mov al,'='
	call print
	mov al,'>'
	call print
ret
	
print2:
	mov al, ' '
	call print
	xor ax, ax
	mov ax, cx
	xor si, si
	xor cx, cx
	mov cx, 10

puxapilha:
	xor dx, dx
	div cx
	push dx
	inc si
	cmp ax, 0
	jne puxapilha
imprime:
	pop ax
	add ax, '0'
	call print
	dec si
	cmp si, 1
	jne continua
	mov al, ','
	call print
continua:
	cmp si, 0
	jne imprime
	mov al, '%'
	call print
ret	

print_voce_teve:
	mov al,[voceteve+bx]
	call print
	inc bx
	cmp bx,9
	jne print_voce_teve
ret

print_de_acuracia:
	mov al,[deacuracia+bx]
	call print
	inc bx
	cmp bx,12
	jne print_de_acuracia
ret
	
fim:
	xor bx,bx
	call print_voce_teve
	mov ax,[total]		
	xor dx,dx
	xor di,di
	add di,6		;total de palavras
	div di
	mov cx,ax
	call print2
	xor bx,bx
	call print_de_acuracia
	;Fim do seu código. 
	

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
