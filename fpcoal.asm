[org 0x0100]
jmp start
BallDelayCounter: dw 0
BallDelayLimit:   dw 10000
Win_y: db 'YOU WIN! Congrats (^-^) ',0
Defeat: db 'YOU LOOSE! Better luck next time <^-^> ',0
score_msg: db 'FINAL SCORE: ',0
screen: 
db 1,2,2,3,3,3,2,2,3,3,3,1,2,2,1,3,3,3,2,2,3,3,3,1,2,2,3,3,3,1,2,2,1,1,3,3,3,1,3,3,3,1,3,3,3,2,2,3,3,3,1,2,2,1,3,3,3,2,2,3,3,3,2,2,3,3,3,1,2,2,3,3,3,1,2,2,3,3,3,1 
db 2,2,1,3,3,3,2,2,3,3,3,1,3,3,3,2,2,1,2,2,3,3,3,2,2,1,2,2,1,3,3,3,1,3,3,3,2,2,3,3,3,1,3,3,3,2,2,3,3,3,2,2,1,3,3,3,1,3,3,3,2,2,1,3,3,3,2,2,1,3,3,3,2,2,3,3,3,2,2,1 
db 3,3,3,1,2,2,1,2,2,3,3,3,2,2,1,3,3,3,2,2,3,3,3,2,2,1,3,3,3,2,2,3,3,3,2,2,1,3,3,3,2,2,1,3,3,3,1,2,2,1,3,3,3,1,3,3,3,2,2,3,3,3,2,2,1,3,3,3,2,2,3,3,3,1,2,2,3,3,3,1
db 2,2,1,3,3,3,2,2,3,3,3,1,2,2,1,3,3,3,2,2,3,3,3,1,2,2,3,3,3,1,2,2,1,3,3,3,2,2,3,3,3,1,3,3,3,1,3,3,3,1,2,2,1,2,2,1,3,3,3,2,2,1,2,2,3,3,3,1,3,3,3,2,2,1,3,3,3,1,2,2
db 0
ScLi: db 'Lives: ','Score: ',
Welcome:db '                                                                                  ',0
		db '                                                                                 ',0
		db '7                                                                                  ',0
		db '4                =================================================',0
        db '2                           ATARI BREAKOUT ARCADE ',0
        db '4                =================================================',0
		db '7                                                                                 ',0
        db '6                                  DEVELOPED   BY                                  ',0
		db '7                                                                                  ',0
		db'4                            24F-0507   FATIMA kOSAR  (^-^)                           ',0
		db'4                            24F-0619   AREEBA FATIMA (^-^)                          ',0
		db'7                                                                                   ',0
		db'7                                                                                    ',0
		db'7                                                                                    ',0
        db '3                            PRESS ENTER TO BEGIN GAME',0
        db '3                                PRESS ESC TO EXIT',0
		db'7                                                                                ',0
		db'7                                                                                ',1
	Rules :
	db'                                                                                    ',0
	db'7                                                                                    ',0
	db'7                                                                                    ',0
	db'7                                                                                    ',0
	db "3                               MASTER THE BOUNCE!   ;) ",0
	db'7                                                                                    ',0
        db "6                                 [ HOW TO PLAY ]",0
        db "5                    -> SCORE                                                    ",0
        db "4                                Red brick cell = 3 points",0
        db "2                                Green brick cell = 2 points",0
        db "1                                Blue brick cell = 1 point",0
        db "5                    -> LIVES    : Ball drops = life lost",0
        db "5                    -> WIN      : Destroy all bricks",0
        db "6                                  [ CONTROLS ]",0
        db "4                    +---------------------------------------+",0
        db "3                    |   LEFT    | Move paddle left          |",0
        db "3                    |   RIGHT   | Move paddle right         |",0
        db "3                    |   SPACE   | Launch ball / Pause       |",0
        db "3                    |   ESC     | Return to menu            |",0
        db "4                    +---------------------------------------+",1	
		
padpos: dw 3754
ballpos: dw 2000
balldx: dw 0
balldy: dw 160
padsize: dw 7
Lives: dw 3
Score: dw 0
clrscr:;clear the screen
push 0xb800
pop es
mov di,0
mov cx,2000
mov ax,0720h
rep stosw
ret
print_string:
    push si
    push di
    push ax
    push es
print_loop_ps:
    mov al, [si]   
    cmp al, 0
    je print_done_ps
    mov word [es:di], ax 
    add di, 2
    inc si
    jmp print_loop_ps
print_done_ps:
    pop es
    pop ax
    pop di
    pop si
	ret
; welcome page ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prtscr:
mov si,Welcome
push 0xb800
pop es
mov di,0
mov cx,1
mov ah,7
; read for line end 
prtey:
cmp byte[si],0
je newl ; new line
cmp byte[si],1
je en ; end of page 
okay: ; print the character 
lodsb
stosw
jmp prtey
newl:;next line 
mov ah,0
mov al,160 
mul cl  ; lines counter 
mov di,ax
inc cx
inc si
mov ah,[si];first character at each line is the color attribute of that whole line
sub ah,'0' ; convert the attribute in decimal 
inc si
jmp okay
en:
inp:   ; check for enter or escape key
mov ah,01h
int 0x21
cmp al,13;enter
jne escs
jmp fatima
escs:
cmp al,27 ; esc 
je exit1
jmp inp
exit1:
ret
; rules page ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fatima:
call clrscr
mov si,Rules
push 0xb800
pop es
mov di,0
mov cx,1
mov ah,7
prt:
cmp byte[si],0
je newline
cmp byte[si],1
je endstr
ok:
lodsb
stosw
jmp prt
newline:;next line 
mov ah,0
mov al,160
mul cl
mov di,ax
inc cx;no of lines printed - 1
inc si
mov ah,[si];first character at each line is the color attribute of that whole line
sub ah,'0'
inc si
jmp ok
endstr:
input:
mov ah,01h
int 0x21
cmp al,13;enter
jne escape
jmp Game   
escape:
cmp al,27
je exit
jmp input
exit:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Prining loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Game:
; prints score and lives 
SL:
mov di,0
push 0xb800
pop es
mov si,ScLi  
mov bx,0
l4:     
mov cx,7 ; length of lives and score 
inc bx
mov ah,bl
add ah,0x07
dec bx
l3:  ; prints 
mov al,[si] ; loads the char 
mov [es:di],ax
add di,2
inc si
loop l3
mov al,[Lives+bx]   
add al,'0'
mov [es:di],ax  ; wrotes the score or lives on screen 
add di,2
mov ax,0720h
mov cx,61  ; spaces to go to the last columns of first row 
rep stosw
add bx,2
cmp bx,2
jng l4

Rows:;print the rows of brick from the array screen
mov si,screen;point to array of bricks(screen)
mov di,320
l2:;using the ASCIIs of 1,2,3 for color of the brick ,same number same color ,consective same colored cells are considered one brick
mov al,[si]
add al,'0'
cmp al,'1'
je blue;1=blue
cmp al,'2'
je green;2=green
cmp al,'3'
je red;3=red
cmp al,'0';end of bricks Rows
je remain
back:;color selected now print the brick cell
mov [es:di],ax
add di,2
inc si;next brick array location
jmp l2
blue:
mov ah,11h
jmp back
green:
mov ah,22h
jmp back
red:
mov ah,44h
jmp back
remain:;print spaces on the remaining screen now
mov word[es:di],0720h
add di,2
cmp di,4000
jne remain
call walls
call borders
call paddle
call ball
jmp l5

walls:;printing walls on right and left sides
mov cx,24
mov di,160
mov dh,06h
mov dl,'|'
wall1:
mov [es:di],dx
add di,158
mov [es:di],dx
add di,2
loop wall1
ret
borders:
mov di,160
mov dl,'*'
mov dh,06h
b1:;printing the ceiling
mov [es:di],dx
add di,2
cmp di,320
jne b1
mov dl,'_'
mov di,3840
b2:;printing the floor
mov [es:di],dx
add di,2
cmp di,4000
jne b2
ret
paddle:
mov ah,3h
mov al,'='
push di
mov di,[padpos]
mov cx,[padsize]
rep stosw
pop di
ret
ball:
mov di,[ballpos]
mov ah,2
mov al,'O'
mov [es:di],ax
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Main game loop ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
l5:;main Loop
mov ah, 01h  ; check for key press 
int 0x16
jz continuing
mov ah, 00h     
int 0x16
cmp ah, 4Bh  ; left arrow 
je near left
cmp ah, 4Dh  ; right arrow 
je near right
cmp ah,0x39   ; spacebar to stop
je stop
jmp continuing   
stop:
mov ah,01h    ; waits for space 
int 0x21
cmp al,20h
jne stop
continuing:
call paddle  ; draws paddle 
;delay loop
inc word [BallDelayCounter]  ; slow down the ball movement 
mov ax, [BallDelayLimit]
cmp [BallDelayCounter], ax
jl skipc
mov word [BallDelayCounter], 0
mov di, [ballpos]
mov word [es:di], 0720h  ; clear old ball 
call walls ; draw walls again 
call borders ; draw borders again 
; updates position of ball 
mov ax, [balldx] ; 
add [ballpos], ax
mov ax, [balldy]
add [ballpos], ax
mov ax, [ballpos]
; checks for collision against walls ceiling and folor 
mov di, ax
mov dx, 0
mov bl, 160
div bl
cmp ah, 0;left wall
je wall
cmp ah, 158;right wall
je wall
cmp al, 1;ceiling
je ceiling
cmp al, 24;floor
jge floor
;  compare paddle collision 
cmp word [es:di], 033Dh;Paddle
je near padcol
; checks for brick collision  means ball hittinga nything that is not a space char 
cmp word [es:di], 0720h;nothing above and not space so Brick
jne near brickcol
; draw new ball 
mov ah, 2
mov al, 'O'
mov [es:di], ax
skipc:
jmp l5
moveon:
mov di,152
mov ax,[Score]
mov bx, 10
mov cx, 0
call convert
jmp l5
convert:;using the num%10 for last digit of decimal number
mov dx,0
div bx
push dx;pushing in stack to store and reverse the output
inc cx;count of digits pushed
cmp ax, 0
jne convert
print:
pop dx
add dl, '0'; for ASCII of the Number popped from stack
mov dh,51h
mov [es:di], dx
add di,2
loop print; using cx(count of digits pushed)
mov di,[ballpos]
mov ah,2
mov al,'O'
mov [es:di],ax
ret
wall:;balldx*-1 and balldy*1 
mov ax,[balldx]
neg ax
mov [balldx],ax
jmp moveon
ceiling:;balldx*1 and balldy*-1
mov ax,[balldy]
neg ax
mov [balldy],ax
jmp moveon
floor:  ; if touches floor the live dec 
sub word[Lives],1
push ax
push di
mov di,14
mov ax,[Lives]
mov ah,53h
add al,'0'
mov [es:di],ax
pop di
pop ax
cmp word[Lives],0
jle near Gameover
mov word[balldx],0
mov word[balldy],160
mov word[ballpos],2000
mov cx,[padsize]
mov ax,0720h
mov di,[padpos]
rep stosw
mov word[padpos],3754
mov ah,1
mov al,'='
mov di,[padpos]
mov cx,[padsize]
rep stosw
jmp moveon
padcol: ; calculate the collision between paddle and ball
mov ax,[ballpos]
sub ax,[padpos]
cmp ax,2
jle deg45a 
cmp ax,8
jle ceiling
cmp ax,12
jle deg45b
deg45a:  
cmp word[balldx],0
jl skip 
sub word[balldx],2
jmp skip
deg45b:
cmp word[balldx],0
jg skip
add word[balldx],2
jmp skip
skip:
mov ax,[balldy]
neg ax
mov [balldy],ax
jmp moveon
brickcol:   ; reverse the vertical direction 
mov ax,[balldy]
neg ax
mov [balldy],ax
ScoreCalculation:  ; calculate score 
mov ax,[es:di]
mov bl,al
push bx
sub bl,'0'
mov bh,0
add [Score],bx
pop bx
mov word[es:di],0720h
mov cx,6
mov si,di
left_loop:
sub si,2
cmp si,0
jl right_check
mov ax,[es:si]
cmp al,bl
jne right_check
push bx
sub bl,'0'
mov bh,0
add [Score],bx
pop bx
mov word[es:si],0720h
loop left_loop
right_check:
mov cx,6
mov si,di
right_loop:
add si,2
cmp si,4000
jge moveon
mov ax,[es:si]
cmp al,bl
jne moveon
push bx
sub bl,'0'
mov bh,0
add [Score],bx
pop bx
mov word[es:si],0720h
loop right_loop
cmp word[Score],738
je near win

jmp moveon
left: ; paddle movement 
mov di,[padpos]
mov cx,[padsize]
mov ax,0720h
rep stosw
sub word[padpos],2
cmp word[padpos],3680
jle Llimits
printpad:
mov ah,1
mov al,'='
mov di,[padpos]
mov cx,[padsize]
rep stosw
jmp continuing
Llimits:   ; check left limit of screen
mov word[padpos],3682
jmp printpad
right: ; paddle movement 
mov di,[padpos]
mov cx,[padsize]
mov ax,0720h
rep stosw
add word[padpos],2
mov dx,3840
sub dx,[padsize]
sub dx,[padsize]
cmp [padpos],dx
jge Rlimits
printpad1:
mov ah,1
mov al,'='
mov di,[padpos]
mov cx,[padsize]
rep stosw
jmp continuing
r:
jmp return1
Rlimits: ; check right side limit of screen 
sub dx,2
mov [padpos],dx
jmp printpad1
return1:
jmp l5
Gameover:
push 0xb800
pop es
    call clrscr
    mov di, 1950
    mov si, Defeat
    mov ah, 0x04
	call print_string

print_score_label_go:
 
    mov di, 2310
    mov si, score_msg
    mov ah, 0x04
    call print_string

    mov ax, [Score]
    mov bx, 10      
    mov cx, 0       
    mov di, 2340   
    call convert    
p:
    push es
    push 0xb800
    pop es
    mov di,[ballpos]
    mov word[es:di],0720h ; Erase the ball
    pop es

    ret
win:
    call clrscr
    mov di, 1950
    mov si, Win_y
    mov ah, 0x02 
	call print_string

print_score_label_win:
    mov di, 2310 
    mov si, score_msg
    mov ah, 0x0A 
    call print_string

    mov ax, [Score]
    mov bx, 10
    mov cx, 0
    mov di, 2340 
    call convert
	
	p1:
    push es
    push 0xb800
    pop es
    mov di,[ballpos]
    mov word[es:di],0720h ; Erase the ball
    pop es

ret
start:
call clrscr
call prtscr
exiting:
mov ax,0x4c00
int 0x21