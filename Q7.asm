; alguns defines úteis do linux. 
sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

	SECTION .data
ganhou1: db'Jogador 1 ganhou!', 10
ganhou1_len: equ $-ganhou1
ganhou2: db'Jogador 2 ganhou!', 10
ganhou2_len: equ $-ganhou2
linha: db'',10
linha_len: equ $-linha
empate:	db'Empate!', 10
empate_len:	equ $-empate
invalida:	db'Jogada invalida!', 10
invalida_len:	equ $-invalida

	SECTION .bss

num:	resb 5
num_len: resb 5
string:	resb 5
a: resb 5
b: resb 5
tabuleiro: resb 5

	SECTION .text

	global _start:
	
_start:
	xor esi, esi
	call init
main:
	call read  ; metodo para leitura
	push esi
	call strToInt ; transformando string que contem proximo movimento em inteiro.
	pop esi       ; posicao x esta em [a] e y em [b]
	xor eax, eax  
	mov eax, [a]  ; o tabuleiro eh uma string de 9 posicoes que vai de 0 ate 8.
	dec eax       ; por isso, as operacoes feitas abaixo trasnformam o input
	xor ebx, ebx  ; na casa apropriada do tabuleiro. A operacao feita eh 
	mov ebx, [b]  ; (x-1)*3+(y-1)
	dec ebx
	imul eax, 3
	add eax, ebx
	cmp byte[tabuleiro+eax], '.' ; o tabuleiro eh inicializado com '.' em todas
	jne jog_invalida             ; as posicoes. por isso, se tiver algo diferente
	xor ecx, ecx                 ; de '.' em alguma posicao que acabou de ser 
	mov ecx, esi                 ; jogada, a jogada eh invalida.
	and ecx, 1
	jnz par
	mov byte[tabuleiro+eax], 'X' ; caso contrario, identificamos qual eh o jogador
	jmp continua				 ; atual posicionamos no tabuleiro
par:
	mov byte[tabuleiro+eax], 'O' 
continua:
	push esi
	call imprime_tab  ; apos cada jogada, imprimimos o tabuleiro
	call verifical1   ; fazemos a verificacao de se o jogo ja acabou
	call verifical2   ; a verificacao eh feita por linha, depois por coluna
	call verifical3   ; e finalmente por diagonais.
	call verificac1
	call verificac2
	call verificac3
	call verificad1
	call verificad2
	pop esi
	inc esi           ; esi conta quantas jogadas validas foram executadas
	cmp esi, 9        ; caso ja tenham sido executadas 9 jogadas e o ninguem venceu
	jne main          ; nas verificacoes, o jogo acabou empatado.
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, empate
	mov edx, empate_len
	int 0X80
	jmp final
	
jog_invalida:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, invalida
	mov edx, invalida_len
	int 0X80
	jmp main
	
imprime_tab:      ; para imprimir o tabuleiro, fazemos dois loops, um para cada 
	xor esi, esi  ; linha, e dentro desse, imprimir todas as colunas correspodentes
faz1:
	xor edi, edi
	call faz2
	inc esi
	cmp esi, 3
	jne faz1
ret
	
faz2:
	push esi
	imul esi, 3
	add esi, edi
	add esi, tabuleiro
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, esi
	mov edx, 1
	int 0X80
	pop esi
	inc edi
	cmp edi, 3
	jne faz2
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, linha
	mov edx, linha_len
	int 0X80
ret

verifical1:      ; a verificacao para as linhas eh feita somando +1 no contador
	xor edi, edi ; para ver se as posicoes horizontalmente consecutivas estao 
loop11:          ; marcadas primeiro com 'X' e depois com 'O'.
	cmp byte[tabuleiro+edi], 'X'
	jne acabaj11
	inc edi
	cmp edi, 3
	jne loop11
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabaj11:
	xor edi, edi
loop12:
	cmp byte[tabuleiro+edi], 'O'
	jne acaba1
	inc edi
	cmp edi, 3
	jne loop12
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acaba1:
ret

verifical2:
	xor edi, edi
	mov edi, 3
loop21:
	cmp byte[tabuleiro+edi], 'X'
	jne acabaj21
	inc edi
	cmp edi, 6
	jne loop21
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabaj21:
	xor edi, edi
	mov edi, 3
loop22:
	cmp byte[tabuleiro+edi], 'O'
	jne acaba2
	inc edi
	cmp edi, 6
	jne loop22
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acaba2:
ret
	
verifical3:
	xor edi, edi
	mov edi, 6
loop31:
	cmp byte[tabuleiro+edi], 'X'
	jne acabaj31
	inc edi
	cmp edi, 9
	jne loop31
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabaj31:
	xor edi, edi
	mov edi, 6
loop32:
	cmp byte[tabuleiro+edi], 'O'
	jne acaba3
	inc edi
	cmp edi, 9
	jne loop32
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acaba3:
ret	

verificac1:       ; para a verificacao para as colunas, somamos 3, pois isso faz
	xor edi, edi  ; nos pularmos para a linha de baixo. Assim, checamos posicoes
loopc11:          ; consecutivas verticalmente. Primeiro para 'X' e depois para 'O'
	cmp byte[tabuleiro+edi], 'X'
	jne acabac11
	add edi, 3
	cmp edi, 9
	jne loopc11
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabac11:
	xor edi, edi
loopc12:
	cmp byte[tabuleiro+edi], 'O'
	jne acabac1
	add edi, 3
	cmp edi, 9
	jne loopc12
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acabac1:
ret

verificac2:
	xor edi, edi
	mov edi, 1
loopc21:
	cmp byte[tabuleiro+edi], 'X'
	jne acabac21
	add edi, 3
	cmp edi, 10
	jne loopc21
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabac21:
	xor edi, edi
	mov edi, 1
loopc22:
	cmp byte[tabuleiro+edi], 'O'
	jne acabac2
	add edi, 3
	cmp edi, 10
	jne loopc22
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acabac2:
ret

verificac3:
	xor edi, edi
	mov edi, 2
loopc31:
	cmp byte[tabuleiro+edi], 'X'
	jne acabac31
	add edi, 3
	cmp edi, 11
	jne loopc31
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabac31:
	xor edi, edi
	mov edi, 2
loopc32:
	cmp byte[tabuleiro+edi], 'O'
	jne acabac3
	add edi, 3
	cmp edi, 11
	jne loopc32
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acabac3:
ret

verificad1:          ; o primeiro metodo de diagonal comeca na posicao 0 e vai 
	xor edi, edi     ; somando 4, verificando primeiro para 'X' e depois 'O'
loopd11:
	cmp byte[tabuleiro+edi], 'X'
	jne acabad11
	add edi, 4
	cmp edi, 12
	jne loopd11
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabad11:
	xor edi, edi
loopd12:
	cmp byte[tabuleiro+edi], 'O'
	jne acabad1
	add edi, 4
	cmp edi, 12
	jne loopd12
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acabad1:
ret

verificad2:      ; O segundo, comeca na posicao 2 e vai somando 2, assim 
	xor edi, edi ; conseguimos acessar a segunda diagonal.
	mov edi, 2
loopd21:
	cmp byte[tabuleiro+edi], 'X'
	jne acabad21
	add edi, 2
	cmp edi, 8
	jne loopd21
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou1
	mov edx, ganhou1_len
	int 0X80
	jmp final
acabad21:
	xor edi, edi
	mov edi, 2
loopd22:
	cmp byte[tabuleiro+edi], 'O'
	jne acabad2
	add edi, 2
	cmp edi, 8
	jne loopd22
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, ganhou2
	mov edx, ganhou2_len
	int 0X80
	jmp final
acabad2:
ret
	
read:
	mov eax, sys_read
	mov ebx, stdin
	mov ecx, num
	mov edx, 21
	int 0X80
ret

init:
	xor edi, edi
loopinit:
	mov byte[tabuleiro+edi], '.'
	inc edi
	cmp edi, 9
	jne loopinit
	xor edi, edi
ret
	
strToInt:      ; parser
	xor esi,esi
	xor ebx, ebx
	xor eax, eax
	call loopstrToInt1
	mov [a],edx
	inc ebx
	xor esi,esi
	xor eax,eax
	call loopstrToInt1
	mov[b],edx
ret
	
loopstrToInt1:
	mov al, [num+ebx]
	cmp eax, 40
	jl parte2
	sub eax, '0'
	push eax
	inc esi
	inc ebx
	jmp loopstrToInt1

	
parte2:
	xor edx, edx
	mov ecx, 1

loopstrToInt2:
	pop eax
	imul eax, ecx
	add edx, eax
	imul ecx, 10
	dec esi
	cmp esi, 0
	jne loopstrToInt2
ret


final:
	mov eax,1
	mov ebx,0
	int 0x80

