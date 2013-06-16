;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

	;;A string Palavras guarda a concatenação das palavras do jogo.
	;;O string tam serve para saber onde as palavras presentes em Palavras
	;; começam e onde terminam. Supondo que queremos a terceira palavra,
	;; temos que ela começa em Palavras[tam[2]-tam[0]] e termina em Palavras[tam[3]-tam[0]]
	;; Para formar a string tam, começamos do caractere '!' que representa o início,
	;; e temos que tam[i]=tam[i-1]+tamanho_palavra. e.g. '!'+len(typeracer) = '!'+9='*'
Palavras db'typeracerisaquitenicegame'
tam db'!*,-26:'
deacuracia db' de acuracia'
voceteve db'Voce teve '
string:	resb 20			;palavra digitada
total:	resw 1			;acumulador da porcentagem de acertos

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
	je not_space		;se for a primeira palavra nao imprime o espaco
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
	push bx			;guarda o indice das palavras na pilha
	mov bl,dl
print_palavra_texto:
	mov al,[Palavras+bx]
	call print
	inc bx
	cmp bx,cx
	jne print_palavra_texto
	pop bx			;pega o indice das palavras de volta
	inc bx
	cmp bx,6		;qtd de palavras
	jne print_phrase

	mov al,10		;quebra linha e volta pro inicio da linha
	call print
	mov al,13
	call print
	xor bx,bx

game:
	push bx			;guarda o indice das palavras
	xor bx,bx
get_word:			;pega a palavra digitada pelo usuario
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
print_palavra_usuario:
	mov al,[string+bx]
	call print
	inc bx
	cmp cx,bx
	jne print_palavra_usuario

	;; calcular acuracia
	pop bx			;pega o indice das palavras de volta, ja que precisa para poder calcular acuracia
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
	push bx			;bota indice das palavras na pilha
	mov si,dx		;contador na string de Palavras
	xor bx,bx		;contador na string digitada
	xor dx,dx		;acertos

compara:
	mov al,[Palavras+si]
	cmp al,[string+bx]	;compara palavra esperada com palavra digitada
	jne erro
	inc dx			;se acertou, entao aumenta o numero de acertos
erro:	
	inc si
	inc bx
	cmp si,cx
	jne compara

	mov al,' '
	call print
	pop bx
	pop cx			;queremos pegar o tamanho da palavra digitada para poder comparar com o da esperada
	push bx
	cmp cx, di
	;; a acuracia sera acertos/max(len(digitada),len(esperada). Isso porque da uma acuracia 100% num caso como:
	;; palavra desejada: soft. palavra digitada: software. seria sem sentido. Sendo assim precisamos saber qual a maior
	jg bla		
	mov ax, dx
	xor dx, dx
	imul ax, 1000		;multiplicamos por 1000 para nao precisar trabalhar com double
	div di			;divide por di, porque di eh maior
	add [total],ax		;adiciona ao acumulador a acuracia dessa palavra
	mov cx, ax
	call print_seta
	call print2
	push bx
	xor bx,bx
	call print_de_acuracia
	pop bx
	jmp cont
bla:				;palavra digitada foi maior que a palavra esperada
	mov ax,dx
	xor dx, dx
	imul ax, 1000
	div cx			;divide por cx, porque cx eh maior
	add [total],ax		;adiciona ao acumulador a acuracia dessa palavra
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
	mov al, ' ' ; primeiro imprimimos um espaco para distanciar da palavra digitada
	call print
	xor ax, ax
	mov ax, cx
	xor si, si
	xor cx, cx
	mov cx, 10

puxapilha:     ; o procedimento seguinte transforma o resultado da acuracia
	xor dx, dx ; em string, para pudermos imprimir. o resto da divisao vai 
	div cx     ; para dx, e o quociente para ax. botamos na pilha e guardamos
	push dx    ; quantos caracteres sao em si.
	inc si
	cmp ax, 0
	jne puxapilha
imprime:
	pop ax     ; depois de acabado o procedimento, eh so ir tirando os numeros
	add ax, '0' ; da pilha, e ir somando '0' para trasformar no caractere
	call print  ; correspondente. Assim, imprimimos caractere por caractere.
	dec si
	cmp si, 1   ; se tiver faltando apenas 1 depois desse, então coloca uma virgula
	jne continua
	mov al, ','
	call print
continua:
	cmp si, 0
	jne imprime
	mov al, '%'  ; impressao do simbolo de porcentagem depois que o resultado
	call print   ; foi impresso
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
	;; o metodo utilizado para calcular a acuracia foi a media aritmetica entre as acuracias das palavras
	add di,6		;total de palavras. se mudar as palavras tem que mudar isso daqui
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
