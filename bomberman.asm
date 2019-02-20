BACKGROUND_COLOR = $5100
BACKGROUND_SCROLLx = $5101


CHR_ROW = $5103
CHR_COL = $5104
CHR_PIXEL = $5105

BACKGROUND_MODE = $5107

BACKGROUND0 = $4000
BACKGROUND1 = $4400

INPUT = $5106

SPRITEPLAYER = $5000
SPRITENEMY = $5004

LDA #$01
STA BACKGROUND_MODE


LOADSPRITEPLAYER:
LDA #147
STA SPRITEPLAYER
LDA #230
STA SPRITEPLAYER +1
LDA #220
STA SPRITEPLAYER +2
LDA #$0b
STA SPRITEPLAYER +3


LOADSPRITENEMY:
    LDA #89
    STA SPRITENEMY
    LDA #0
    STA SPRITENEMY +1
    LDA #0
    STA SPRITENEMY +2
    LDA #$0b
    STA SPRITENEMY +3


fill0:
    LDA map0,X
    STA BACKGROUND0,X
    INX
    BNE fill0

loop:
    JMP loop

;==================================collision================================
 setplayertile:
    LDA SPRITEPLAYER +1
    LSR A
    LSR A
    LSR A
    LSR A
    CLC
    STA PlayercurrentTileX
    LDA SPRITEPLAYER +2
    LSR A
    LSR A
    LSR A
    LSR A
    CLC
    STA PlayercurrentTileY
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    STA playerindex  

RTS

enemychecktile:
    LDA SPRITENEMY +1
    LSR A
    LSR A
    LSR A
    LSR A
    CLC
    STA EnemycurrentTileX
    LDA SPRITENEMY +2
    LSR A
    LSR A
    LSR A
    LSR A
    CLC
    STA EnemycurrentTileY
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC EnemycurrentTileX
    TAX
    STA enemyindex
RTS

collisionWithEnemy:
    CLC
    LDA playerindex
    ADC PlayercurrentTileX
    TAX
    CMP enemyindex , X
    BEQ collide
    RTS
    
collide:
    LDA #88
    STA SPRITEPLAYER
RTS

;======================================end-collision=================================
vblank:

LDA #147
STA SPRITEPLAYER

    ; LDA map1, X
    ; STA BACKGROUND1 , X
    ; INX
    ; BNE collide

;==========================move_player=======================================
checkmoveleft:
    LDA playerindex
    CLC
    ADC PlayercurrentTileX
    TAX
    LDA map0, X
    CMP #8
    BEQ MOSDS2
    DEC SPRITEPLAYER +1
 
MOSDS2:
    LDA #00
    STA bool
    INC SPRITEPLAYER +1


JSR setplayertile
JSR enemychecktile
JSR collisionWithEnemy

moveright:
    LDA INPUT
    AND #$04
    BEQ moveleft
    INC SPRITEPLAYER +1
    LDA #148
    STA SPRITEPLAYER
    LDA playerindex
    CLC
    ADC PlayercurrentTileX
    ADC #$1
    TAX
    LDA map0, X
    CMP #8
    BEQ MOSDS
    INC SPRITEPLAYER +1

MOSDS:
    LDA #01
    STA bool
    DEC SPRITEPLAYER +1

moveleft:
    LDA INPUT
    AND #$08
    BEQ moveup
    DEC SPRITEPLAYER +1
    LDA #148
    STA SPRITEPLAYER

moveup:
    LDA INPUT
    AND #$01
    BEQ movedown
    DEC SPRITEPLAYER +2
    LDA #148
    STA SPRITEPLAYER
    LDA playerindex
    CLC
    ADC PlayercurrentTileX
    TAX
    LDA map0, X
    CMP #8
    BEQ MOSDS3
    DEC SPRITEPLAYER +2

MOSDS3:
    LDA #00
    STA bool
    INC SPRITEPLAYER +2

movedown:
    LDA INPUT
    AND #$02
    BEQ endpoint
    INC SPRITEPLAYER +2
    LDA #148
    STA SPRITEPLAYER
    LDA playerindex
    CLC
    ADC PlayercurrentTileX
    ADC #16
    TAX
    LDA map0, X
    CMP #8
    BEQ MOSDS4
    INC SPRITEPLAYER +2

MOSDS4:
    LDA #00
    STA bool
    DEC SPRITEPLAYER +2

;============================and_move_player=======================================

endpoint:
    RTI

map0:
.byte 1,1,1,1,1,1,1,8,8,8,8,8,8,8,8,8
.byte 1,8,8,8,8,8,8,8,1,1,1,1,8,8,8,1
.byte 1,8,1,1,1,1,1,1,1,8,8,1,8,8,8,1
.byte 1,8,1,8,8,8,8,1,1,8,8,1,1,1,1,1
.byte 1,8,1,1,1,1,8,1,1,8,8,1,1,8,1,1
.byte 1,1,1,8,8,1,8,8,1,1,1,1,1,8,1,1
.byte 8,8,8,8,8,1,1,1,8,8,8,8,1,8,1,1
.byte 8,8,8,8,8,8,8,1,8,8,1,1,1,8,8,1
.byte 1,8,1,1,1,1,8,1,8,8,1,1,1,8,1,1
.byte 1,8,1,8,1,8,8,1,8,8,8,1,1,8,1,1
.byte 1,8,1,8,1,8,8,1,1,1,8,8,8,8,8,1
.byte 1,8,1,8,1,8,8,8,8,1,1,1,1,1,1,1
.byte 1,8,1,8,1,1,8,8,8,8,8,1,1,8,8,1
.byte 1,1,1,8,1,1,1,1,1,8,8,8,1,8,8,1
.byte 1,1,1,1,1,8,8,8,1,8,8,8,1,8,8,1
.byte 1,8,8,8,8,8,8,8,1,1,1,1,1,1,1,1


map1:
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,8,8,8,1,1,1,1,1,1,1,1,8,8,8,1
.byte 1,8,8,8,1,8,8,8,1,8,8,1,8,8,8,1
.byte 1,8,8,8,1,8,8,8,1,8,8,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,8,8,8,8,1,1,1,8,8,8,8,1,1,1,1
.byte 1,8,8,8,8,8,1,1,8,8,8,8,1,1,1,1
.byte 1,1,1,1,1,1,1,1,8,8,8,8,1,1,1,1
.byte 1,8,1,8,1,8,8,1,1,1,1,1,1,1,1,1
.byte 1,8,1,8,1,8,8,1,1,1,1,1,1,1,1,1
.byte 1,8,1,8,1,8,8,8,8,1,1,1,1,8,8,1
.byte 1,8,1,8,1,1,8,8,8,8,8,1,1,8,8,1
.byte 1,1,1,1,1,1,1,1,1,8,8,8,1,8,8,1
.byte 1,1,1,1,1,8,8,8,1,8,8,8,1,8,8,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1


.segment "RAM"
PlayercurrentTileX:
.byte 0
PlayercurrentTileY:
.byte 0
EnemycurrentTileX:
.byte 0
EnemycurrentTileY:
.byte 0
playerindex:
.byte 0
enemyindex:
.byte 0
bool:
.byte 0

.segment "VECTORS"
.word vblank
