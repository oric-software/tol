;Storybook -

;Consisting of
; Inlay screens 1-7(Packed)	MusicTempo
;  Story1 23x103 @1,24
;  Story2 22x103 @17,16
;  Story3 22x96 @17,72
;  Story4 23x96 @1,24
;  Story5 22x87 @1,64
;  Story6 24x98 @15,80
;  Story7 25x96 @14,24
; Corner motif(Mirrored and flipped for all 4 corners)
;  12(2)x12
; Text font
;  Fonte.h(Text Font)
; Storybook Text
; Selection inlay screen(Packed)
;  31x96 @4,0
; Portraits 1-3(Packed)
;  Warrior 21x184 @16,8
;  Valkyrie 22x176 @15,8
;  Knight 20x184 @17,8
; Music containing tunes 1-8
#define	GAME_CONTROLLER		$900
#define	GAME_AUDIO			GAME_CONTROLLER+1
#define	GAME_DIFFICULTY		GAME_CONTROLLER+2
#define	GAME_CHARACTER		GAME_CONTROLLER+3

#define	HIRES			$EC33
#define	CR24			128+24
#define	CR25			128+25
#define	CR3			128+3
#define	VIA_PORTB			$0300
#define	VIA_DDRB			$0302
#define	VIA_DDRA			$0303
#define	VIA_T1CL			$0304
#define VIA_T1LL   			$306
#define VIA_T1LH   			$307

#define	VIA_T2LL			$0308
#define	VIA_T2CH			$0309
#define	VIA_SR			$030A
#define	VIA_ACR			$030B
#define	VIA_PCR			$030C
#define	VIA_IFR			$030D
#define	VIA_IER			$030E
#define	VIA_PORTA			$030F




#ifdef TARGET_TELEMON24
#define	SYS_IRQLO			$2fb
#define	SYS_IRQHI			$2fc


#define SWITCH_HIRES\
	.byt $00,$1a ;

#else

#define SWITCH_HIRES\
	jsr $ec33;
#define	SYS_IRQLO			$245
#define	SYS_IRQHI			$246

	
#endif

	
 .zero
*=$D0

StoryID		.dsb 1
source		.dsb 2
screen		.dsb 2
TempGraphicID	.dsb 1

TempInlayWidth	.dsb 1
TempStoryID	.dsb 1

ptr_source	.dsb 2
ptr_destination	.dsb 2
ptr_destination_end	.dsb 2
ptr_source_back	.dsb 2
offset		.dsb 2
mask_value	.dsb 2
nb_src		.dsb 2
nb_dst		.dsb 2

char		.dsb 2
TempCharacterX	.dsb 1
TempCharacterY	.dsb 1

text		.dsb 2
CharacterXPos	.dsb 1
CharacterYPos	.dsb 1
TempXCalc		.dsb 1
CharacterID	.dsb 1

RowMovingDown	.dsb 1
RowMovingUp         .dsb 1
IRQA                .dsb 1
IRQX                .dsb 1
IRQY                .dsb 1
IRQDelay            .dsb 1
ControllerRegister	.dsb 1

 .text
*=$1000

Driver	
#ifdef TARGET_TELEMON24
	lda #$f7
	sta VIA_DDRB
	lda #$ff
	sta VIA_DDRA
	lda #$10
	sta VIA_T1LL
		
	lda #$27
	sta VIA_T1LH
	
	lda #$c0
	sta VIA_IER
	lda #$f7
	sta $030f
	lda #$00
	sta $30d
	
#endif
	SWITCH_HIRES

	lda #00
	sta GAME_CHARACTER
	;Clear text rows
	ldx #119
	
	lda #8
.(
loop1	sta GAME_CONTROLLER-120,x
	dex
	bpl loop1
.)


	
	 jsr SetupMusicIRQ

	
;	jmp Test999

	ldx #00
	stx StoryID
.(
loop1	;Display Black ink template
	jsr DrawTemplate 

	;Eye open it
 	jsr EyeOpen 
 
	;Commence playing of Story tune

	;Display Inlay Picture
	ldx StoryID
	jsr Depack2Screen

	;Display text
	lda #00
	sta FlashText
	ldx StoryID
	jsr DisplayText

	;Wait on Key
	jsr WaitOnInput ; FIXME

	;Eye close
	jsr EyeClose 
	;Proceed story
	inc StoryID
	lda StoryID
	cmp #8
	bcc loop1
.)
	;Display Portrait of selected character
	jsr DrawTemplate
	jsr EyeOpen
	ldx GAME_CHARACTER
	jsr Depack2Screen
	ldx StoryID
	jsr DisplayText


Test999	nop
	jmp test999
test999	;Display Black ink template
	jsr DrawTemplate
	jsr EyeOpen
	ldx #6
	jsr Depack2Screen
test998	nop
	jmp test998


EyeOpen	;start from row 100 and restore ink up/down
	lda #100
	sta RowMovingUp
	sta RowMovingDown
.(
loop2	ldy RowMovingUp
	ldx #00
	jsr GetHIRESLoc
	lda #7
	ldy #00
	sta (screen),y
	ldy RowMovingDown
	ldx #00
	jsr GetHIRESLoc
	lda #7
	ldy #00
	sta (screen),y
	lda #2
	sta IRQDelay
loop1	lda IRQDelay
	bne loop1
	Inc RowMovingDown
	dec RowMovingUp
	bpl loop2
.)
	rts

WaitOnInput
	lda StoryID
	cmp #7
.(
	beq skip1
loop1	lda ControllerRegister
	beq loop1
	rts
skip1	;Allow Selection of Character
.)
.(
loop2	jsr DisplaySelectCursor
loop1	;0 - No key/joy
	;1 - Fire
	;2 - Left
	;3 - Right
	lda ControllerRegister
	beq loop1
	cmp #2
	bcc SelectionMade
	beq MoveSelectLeft
MoveSelectRight
	jsr DeleteSelectCursor
	lda SelectionX
	cmp #2
	bcs skip1
	inc SelectionX
skip1	jmp loop2
MoveSelectLeft
	jsr DeleteSelectCursor
	lda SelectionX
	beq skip1
	dec SelectionX
	jmp loop2
SelectionMade
.)
	lda SelectionX
	ora #8
	sta GAME_CHARACTER
	rts

DisplaySelectCursor
	ldx SelectionX
	lda ScreenLoc4SelectCursorLo,x
	sta screen
	lda ScreenLoc4SelectCursorHi,x
	sta screen+1
	ldx #34
.(
loop1	ldy ScreenOffset5x7,x
	lda SelectCursorGraphic,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts
DeleteSelectCursor
	ldx SelectionX
	lda ScreenLoc4SelectCursorLo,x
	sta screen
	lda ScreenLoc4SelectCursorHi,x
	sta screen+1
	lda #127
	ldx #34
.(
loop1	ldy ScreenOffset5x7,x
	sta (screen),y
	dex
	bpl loop1
.)
	rts
SelectionX	.byt 0
ScreenLoc4SelectCursorLo
 .byt <$A000+9+106*40
 .byt <$A000+17+106*40
 .byt <$A000+26+106*40
ScreenLoc4SelectCursorHi
 .byt >$A000+9+106*40
 .byt >$A000+17+106*40
 .byt >$A000+26+106*40
ScreenOffset5x7
 .byt 0,1,2,3,4
 .byt 40,41,42,43,44
 .byt 80,81,82,83,84
 .byt 120,121,122,123,124
 .byt 160,161,162,163,164
 .byt 200,201,202,203,204
 .byt 240,241,242,243,244




EyeClose	;start from row 100 and restore ink up/down
	lda #199
	sta RowMovingUp
	lda #00
	sta RowMovingDown
.(
loop2	ldy RowMovingUp
	ldx #00
	jsr GetHIRESLoc
	jsr ClearRow
	ldy RowMovingDown
	ldx #00
	jsr GetHIRESLoc
	jsr ClearRow
	lda #2
	sta IRQDelay
loop1	lda IRQDelay
	bne loop1
	Inc RowMovingDown
	dec RowMovingUp
	lda RowMovingUp
	cmp #100
	bcs loop2
.)
	rts

ClearRow	lda #7
	ldy #39
.(
loop1	sta (screen),y
	dey
	bpl loop1
.)
	rts

SetupMusicIRQ
	sei
	lda #<IRQRoutine
	sta SYS_IRQLO
	lda #>IRQRoutine
	sta SYS_IRQHI
	cli
	rts

GetHIRESLoc
	txa
	clc
	adc HiresYLOCL,y
	sta screen
	lda #00
	adc HiresYLOCH,y
	sta screen+1
	rts

IRQRoutine
	sta IRQA
	stx IRQX
	sty IRQY
	
	dec IRQDelay
	

	lda VIA_T1CL
#ifdef TARGET_TELEMON24	
	lda $308
#endif
.(
	lda IRQDelay
	beq skip1
	dec IRQDelay
skip1
	jsr ReadControllers ; 
.)

	lda IRQA
	ldx IRQX
	ldy IRQY
	rti

;
ReadControllers
	ldx GAME_CONTROLLER
	cpx #2
	;bcs SenseJoystick
	lda KeyRowTableLo,x
.(
	sta vector1+1
	lda KeyRowTableHi,x
	sta vector1+2
	lda KeyColTableLo,x
	sta vector2+1
	lda KeyColTableHi,x
	sta vector2+2

	lda #00
	sta ControllerRegister
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR

	ldx #2
vector2	lda $dead,x
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR

vector1	lda $dead,x
	sta VIA_PORTB

	nop
	nop
	lda VIA_PORTB
	and #$8
	bne skip1
	dex
	bpl vector2
	rts
skip1	inx
.)
	stx ControllerRegister
	rts

KeyRowTableLo
 .byt <CtrlRow	;Ctrl + Cursor Keys
 .byt <FuncRow	;Func + Cursor Keys
KeyRowTableHi
 .byt >CtrlRow	;Ctrl + Cursor Keys
 .byt >FuncRow	;Func + Cursor Keys
KeyColTableLo
 .byt <CtrlCol	;Ctrl + Cursor Keys
 .byt <FuncCol	;Func + Cursor Keys
KeyColTableHi
 .byt >CtrlCol	;Ctrl + Cursor Keys
 .byt >FuncCol	;Func + Cursor Keys

CtrlRow	;Ctrl + Cursor Keys
 .byt
FuncRow	;Func + Cursor Keys
CtrlCol	;Ctrl + Cursor Keys
FuncCol	;Func + Cursor Keys

Depack2Screen
	;Depack to Buffer
	stx TempStoryID
	lda PackedInlayAddressLo,x
	sta ptr_source
	lda PackedInlayAddressHi,x
	sta ptr_source+1

	lda #<InlayBuffer
	sta ptr_destination
	lda #>InlayBuffer
	sta ptr_destination+1

	lda UnpackedInlayDestinationEndLo,x
	sta ptr_destination_end
	lda UnpackedInlayDestinationEndHi,x
	sta ptr_destination_end+1

	jsr Unpack

	;Now copy to screen
	ldy TempStoryID
	lda InlayX,y
	ldx InlayY,y
	clc
	adc HiresYLOCL,x
	sta screen
	lda HiresYLOCH,x
	adc #00
	sta screen+1
	lda #<InlayBuffer
	sta source
	lda #>InlayBuffer
	sta source+1

	ldx InlayH,y
	lda InlayW,y
	sta TempInlayWidth
.(
loop2	ldy TempInlayWidth
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1

	lda source
	clc
	adc TempInlayWidth
	sta source
	lda source+1
	adc #00
	sta source+1

	jsr nl_screen

	dex
	bne loop2
.)
	rts

InlayX
 .byt 2	;Story1
 .byt 17	;Story2
 .byt 17	;Story3
 .byt 2	;Story4
 .byt 2	;Story5
 .byt 15	;Story6
 .byt 14	;Story7
 .byt 4	;Select
 .byt 17	;Knight
 .byt 15	;Valkyrie
 .byt 16	;Warrior
InlayY
 .byt 18 	;Story1
 .byt 16	;Story2
 .byt 70	;Story3
 .byt 20 	;Story4
 .byt 66 	;Story5
 .byt 76	;Story6
 .byt 28	;Story7
 .byt 8  	;Select
 .byt 8 	;Knight
 .byt 8 	;Valkyrie
 .byt 8 	;Warrior
InlayW
 .byt 23 	;Story1
 .byt 22	;Story2
 .byt 22	;Story3
 .byt 23 	;Story4
 .byt 22 	;Story5
 .byt 24	;Story6
 .byt 25	;Story7
 .byt 31 	;Select
 .byt 20	;Knight
 .byt 22	;Valkyrie
 .byt 21	;Warrior
InlayH
 .byt 103	;Story1
 .byt 103	;Story2
 .byt 96 	;Story3
 .byt 96 	;Story4
 .byt 87 	;Story5
 .byt 98 	;Story6
 .byt 96 	;Story7
 .byt 96 	;Select
 .byt 184	;Knight
 .byt 176	;Valkyrie
 .byt 184	;Warrior
StoryMusicTempos
 .byt 23 	;Story1
 .byt 50	;Story2
 .byt 50	;Story3
 .byt 26 	;Story4
 .byt 22 	;Story5
 .byt 16	;Story6
 .byt 0	;Story7
 .byt 0 	;Select
StoryMusicListStart
 .byt 0 	;Story1
 .byt 6	;Story2
 .byt 9	;Story3
 .byt 13 	;Story4
 .byt 20 	;Story5
 .byt 25	;Story6
 .byt 0	;Story7
 .byt 0 	;Select
 .byt 0	;Knight
 .byt 0	;Valkyrie
 .byt 0	;Warrior

StoryTextAddressLo
 .byt <Text_Story1 	;Story1
 .byt <Text_Story2	;Story2
 .byt <Text_Story3	;Story3
 .byt <Text_Story4 	;Story4
 .byt <Text_Story5 	;Story5
 .byt <Text_Story6	;Story6
 .byt <Text_Story7	;Story7
 .byt <Text_Select 	;Select
 .byt <Text_Knight	;Knight
 .byt <Text_Valkyrie	;Valkyrie
 .byt <Text_Warrior	;Warrior
StoryTextAddressHi
 .byt >Text_Story1	;Story1
 .byt >Text_Story2	;Story2
 .byt >Text_Story3	;Story3
 .byt >Text_Story4 	;Story4
 .byt >Text_Story5 	;Story5
 .byt >Text_Story6	;Story6
 .byt >Text_Story7	;Story7
 .byt >Text_Select 	;Select
 .byt >Text_Knight	;Knight
 .byt >Text_Valkyrie	;Valkyrie
 .byt >Text_Warrior	;Warrior
StoryInitialXPos
 .byt 25*6	;Story1
 .byt 3*6		;Story2
 .byt 3*6		;Story3
 .byt 25*6 	;Story4
 .byt 3*6 	;Story5
 .byt 3*6		;Story6
 .byt 3*6		;Story7
 .byt 3*6 	;Select
 .byt 3*6	;Knight
 .byt 3*6	;Valkyrie
 .byt 3*6	;Warrior
StoryInitialYPos
 .byt 16 	;Story1
 .byt 16	;Story2
 .byt 16	;Story3
 .byt 16 	;Story4
 .byt 16 	;Story5
 .byt 16	;Story6
 .byt 16	;Story7
 .byt 120	;Select
 .byt 16	;Knight
 .byt 16	;Valkyrie
 .byt 16	;Warrior

UnpackedInlayDestinationEndLo
 .byt <InlayBuffer+23*103	;Story1
 .byt <InlayBuffer+22*103	;Story2
 .byt <InlayBuffer+22*96 	;Story3
 .byt <InlayBuffer+23*96 	;Story4
 .byt <InlayBuffer+22*87 	;Story5
 .byt <InlayBuffer+24*98 	;Story6
 .byt <InlayBuffer+25*96 	;Story7
 .byt <InlayBuffer+31*96	;Selection inlay
 .byt <InlayBuffer+20*184	;Knight
 .byt <InlayBuffer+22*176	;Valkyrie
 .byt <InlayBuffer+21*184	;Warrior
UnpackedInlayDestinationEndHi
 .byt >InlayBuffer+23*103	;Story1
 .byt >InlayBuffer+22*103	;Story2
 .byt >InlayBuffer+22*96 	;Story3
 .byt >InlayBuffer+23*96 	;Story4
 .byt >InlayBuffer+22*87 	;Story5
 .byt >InlayBuffer+24*98 	;Story6
 .byt >InlayBuffer+25*96 	;Story7
 .byt >InlayBuffer+31*96	;Selection inlay
 .byt >InlayBuffer+20*184	;Knight
 .byt >InlayBuffer+22*176	;Valkyrie
 .byt >InlayBuffer+21*184	;Warrior
PackedInlayAddressLo
 .byt <story1
 .byt <story2
 .byt <story32
 .byt <story4
 .byt <story5
 .byt <story6
 .byt <story7
 .byt <select9
 .byt <knight
 .byt <valkyrie
 .byt <warrior
PackedInlayAddressHi
 .byt >story1
 .byt >story2
 .byt >story32
 .byt >story4
 .byt >story5
 .byt >story6
 .byt >story7
 .byt >select9
 .byt >knight
 .byt >valkyrie
 .byt >warrior

;Template is 39x200 with motifs and black ink to start
DrawTemplate
	;Plot White sheet but with blank ink
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #200
	ldy #00
.(
loop2	lda #00
	tay
	sta (screen),y
	iny
	lda #%01100101
	sta (screen),y
	lda #127
loop1	iny
	sta (screen),y
	cpy #39
	bcc loop1
	lda #%01101001
	sta (screen),y
	jsr nl_screen
	dex
	bne loop2
.)
	;Draw Top/Bottom Border
	ldy #35
	lda #%01000000
.(
loop1	sta $BE7A,y
	sta $BE7A+80,y
	sta $BE7A+120,y
	sta $A02A,y
	sta $A02A+40,y
	sta $A02A+120,y
	dey
	bpl loop1
.)
	;Plot TL Motif
	ldx #01
	ldy #00
	lda #00
	jsr PlotBlockGraphic

	;Plot TR Motif
	ldx #38
	ldy #00
	lda #01
	jsr PlotBlockGraphic

	;Plot BL Motif
	ldx #01
	ldy #188
	lda #02
	jsr PlotBlockGraphic

	;Plot BR Motif
	ldx #38
	ldy #188
	lda #03
	jsr PlotBlockGraphic

	rts

PlotBlockGraphic
	sta TempGraphicID
	txa
	clc
	adc HiresYLOCL,y
	sta screen
	lda HiresYLOCH,y
	adc #00
	sta screen+1
	ldx TempGraphicID
	lda GraphicAddressLo,x
	sta source
	lda GraphicAddressHi,x
	sta source+1
	ldx #12
.(
loop2	ldy #1
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #2
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	jsr nl_screen
	dex
	bne loop2
.)
	rts

nl_screen	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
GraphicAddressLo
 .byt <TLCornerMotif
 .byt <TRCornerMotif
 .byt <BLCornerMotif
 .byt <BRCornerMotif
GraphicAddressHi
 .byt >TLCornerMotif
 .byt >TRCornerMotif
 .byt >BLCornerMotif
 .byt >BRCornerMotif

TLCornerMotif
 .byt $7F,$7F
 .byt $6B,$42
 .byt $76,$5E
 .byt $6E,$6F
 .byt $7C,$4F	;
 .byt $70,$7B
 .byt $65,$63
 .byt $69,$4F
 .byt $6F,$53
 .byt $6E,$53
 .byt $7F,$7F
 .byt $67,$7F
TRCornerMotif
 .byt $7F,$7F
 .byt $50,$75
 .byt $5E,$5B
 .byt $7D,$5D
 .byt $7C,$4F
 .byt $77,$43
 .byt $71,$69
 .byt $7C,$65
 .byt $72,$7D
 .byt $72,$5D
 .byt $7F,$7F
 .byt $7F,$79
BLCornerMotif
 .byt $67,$7F
 .byt $7F,$7F
 .byt $6E,$53
 .byt $6F,$53
 .byt $69,$4F
 .byt $65,$63
 .byt $70,$7B
 .byt $7C,$4f
 .byt $6E,$6F
 .byt $76,$5E
 .byt $6B,$42
 .byt $7F,$7F
BRCornerMotif
 .byt $7F,$79
 .byt $7F,$7F
 .byt $72,$5D
 .byt $72,$7D
 .byt $7C,$65
 .byt $71,$69
 .byt $77,$43
 .byt $7C,$4F
 .byt $7D,$5D
 .byt $5E,$5B
 .byt $50,$75
 .byt $7F,$7F

InlayBuffer	;For depacking inlays to
 .dsb 3864,0

HiresYLOCL
 .byt <$A000
 .byt <$A000+40*1
 .byt <$A000+40*2
 .byt <$A000+40*3
 .byt <$A000+40*4
 .byt <$A000+40*5
 .byt <$A000+40*6
 .byt <$A000+40*7
 .byt <$A000+40*8
 .byt <$A000+40*9
 .byt <$A000+40*10
 .byt <$A000+40*11
 .byt <$A000+40*12
 .byt <$A000+40*13
 .byt <$A000+40*14
 .byt <$A000+40*15
 .byt <$A000+40*16
 .byt <$A000+40*17
 .byt <$A000+40*18
 .byt <$A000+40*19
 .byt <$A000+40*20
 .byt <$A000+40*21
 .byt <$A000+40*22
 .byt <$A000+40*23
 .byt <$A000+40*24
 .byt <$A000+40*25
 .byt <$A000+40*26
 .byt <$A000+40*27
 .byt <$A000+40*28
 .byt <$A000+40*29
 .byt <$A000+40*30
 .byt <$A000+40*31
 .byt <$A000+40*32
 .byt <$A000+40*33
 .byt <$A000+40*34
 .byt <$A000+40*35
 .byt <$A000+40*36
 .byt <$A000+40*37
 .byt <$A000+40*38
 .byt <$A000+40*39
 .byt <$A000+40*40
 .byt <$A000+40*41
 .byt <$A000+40*42
 .byt <$A000+40*43
 .byt <$A000+40*44
 .byt <$A000+40*45
 .byt <$A000+40*46
 .byt <$A000+40*47
 .byt <$A000+40*48
 .byt <$A000+40*49
 .byt <$A000+40*50
 .byt <$A000+40*51
 .byt <$A000+40*52
 .byt <$A000+40*53
 .byt <$A000+40*54
 .byt <$A000+40*55
 .byt <$A000+40*56
 .byt <$A000+40*57
 .byt <$A000+40*58
 .byt <$A000+40*59
 .byt <$A000+40*60
 .byt <$A000+40*61
 .byt <$A000+40*62
 .byt <$A000+40*63
 .byt <$A000+40*64
 .byt <$A000+40*65
 .byt <$A000+40*66
 .byt <$A000+40*67
 .byt <$A000+40*68
 .byt <$A000+40*69
 .byt <$A000+40*70
 .byt <$A000+40*71
 .byt <$A000+40*72
 .byt <$A000+40*73
 .byt <$A000+40*74
 .byt <$A000+40*75
 .byt <$A000+40*76
 .byt <$A000+40*77
 .byt <$A000+40*78
 .byt <$A000+40*79
 .byt <$A000+40*80
 .byt <$A000+40*81
 .byt <$A000+40*82
 .byt <$A000+40*83
 .byt <$A000+40*84
 .byt <$A000+40*85
 .byt <$A000+40*86
 .byt <$A000+40*87
 .byt <$A000+40*88
 .byt <$A000+40*89
 .byt <$A000+40*90
 .byt <$A000+40*91
 .byt <$A000+40*92
 .byt <$A000+40*93
 .byt <$A000+40*94
 .byt <$A000+40*95
 .byt <$A000+40*96
 .byt <$A000+40*97
 .byt <$A000+40*98
 .byt <$A000+40*99
 .byt <$A000+40*100
 .byt <$A000+40*101
 .byt <$A000+40*102
 .byt <$A000+40*103
 .byt <$A000+40*104
 .byt <$A000+40*105
 .byt <$A000+40*106
 .byt <$A000+40*107
 .byt <$A000+40*108
 .byt <$A000+40*109
 .byt <$A000+40*110
 .byt <$A000+40*111
 .byt <$A000+40*112
 .byt <$A000+40*113
 .byt <$A000+40*114
 .byt <$A000+40*115
 .byt <$A000+40*116
 .byt <$A000+40*117
 .byt <$A000+40*118
 .byt <$A000+40*119
 .byt <$A000+40*120
 .byt <$A000+40*121
 .byt <$A000+40*122
 .byt <$A000+40*123
 .byt <$A000+40*124
 .byt <$A000+40*125
 .byt <$A000+40*126
 .byt <$A000+40*127
 .byt <$A000+40*128
 .byt <$A000+40*129
 .byt <$A000+40*130
 .byt <$A000+40*131
 .byt <$A000+40*132
 .byt <$A000+40*133
 .byt <$A000+40*134
 .byt <$A000+40*135
 .byt <$A000+40*136
 .byt <$A000+40*137
 .byt <$A000+40*138
 .byt <$A000+40*139
 .byt <$A000+40*140
 .byt <$A000+40*141
 .byt <$A000+40*142
 .byt <$A000+40*143
 .byt <$A000+40*144
 .byt <$A000+40*145
 .byt <$A000+40*146
 .byt <$A000+40*147
 .byt <$A000+40*148
 .byt <$A000+40*149
 .byt <$A000+40*150
 .byt <$A000+40*151
 .byt <$A000+40*152
 .byt <$A000+40*153
 .byt <$A000+40*154
 .byt <$A000+40*155
 .byt <$A000+40*156
 .byt <$A000+40*157
 .byt <$A000+40*158
 .byt <$A000+40*159
 .byt <$A000+40*160
 .byt <$A000+40*161
 .byt <$A000+40*162
 .byt <$A000+40*163
 .byt <$A000+40*164
 .byt <$A000+40*165
 .byt <$A000+40*166
 .byt <$A000+40*167
 .byt <$A000+40*168
 .byt <$A000+40*169
 .byt <$A000+40*170
 .byt <$A000+40*171
 .byt <$A000+40*172
 .byt <$A000+40*173
 .byt <$A000+40*174
 .byt <$A000+40*175
 .byt <$A000+40*176
 .byt <$A000+40*177
 .byt <$A000+40*178
 .byt <$A000+40*179
 .byt <$A000+40*180
 .byt <$A000+40*181
 .byt <$A000+40*182
 .byt <$A000+40*183
 .byt <$A000+40*184
 .byt <$A000+40*185
 .byt <$A000+40*186
 .byt <$A000+40*187
 .byt <$A000+40*188
 .byt <$A000+40*189
 .byt <$A000+40*190
 .byt <$A000+40*191
 .byt <$A000+40*192
 .byt <$A000+40*193
 .byt <$A000+40*194
 .byt <$A000+40*195
 .byt <$A000+40*196
 .byt <$A000+40*197
 .byt <$A000+40*198
 .byt <$A000+40*199
HiresYLOCH
 .byt >$A000
 .byt >$A000+40*1
 .byt >$A000+40*2
 .byt >$A000+40*3
 .byt >$A000+40*4
 .byt >$A000+40*5
 .byt >$A000+40*6
 .byt >$A000+40*7
 .byt >$A000+40*8
 .byt >$A000+40*9
 .byt >$A000+40*10
 .byt >$A000+40*11
 .byt >$A000+40*12
 .byt >$A000+40*13
 .byt >$A000+40*14
 .byt >$A000+40*15
 .byt >$A000+40*16
 .byt >$A000+40*17
 .byt >$A000+40*18
 .byt >$A000+40*19
 .byt >$A000+40*20
 .byt >$A000+40*21
 .byt >$A000+40*22
 .byt >$A000+40*23
 .byt >$A000+40*24
 .byt >$A000+40*25
 .byt >$A000+40*26
 .byt >$A000+40*27
 .byt >$A000+40*28
 .byt >$A000+40*29
 .byt >$A000+40*30
 .byt >$A000+40*31
 .byt >$A000+40*32
 .byt >$A000+40*33
 .byt >$A000+40*34
 .byt >$A000+40*35
 .byt >$A000+40*36
 .byt >$A000+40*37
 .byt >$A000+40*38
 .byt >$A000+40*39
 .byt >$A000+40*40
 .byt >$A000+40*41
 .byt >$A000+40*42
 .byt >$A000+40*43
 .byt >$A000+40*44
 .byt >$A000+40*45
 .byt >$A000+40*46
 .byt >$A000+40*47
 .byt >$A000+40*48
 .byt >$A000+40*49
 .byt >$A000+40*50
 .byt >$A000+40*51
 .byt >$A000+40*52
 .byt >$A000+40*53
 .byt >$A000+40*54
 .byt >$A000+40*55
 .byt >$A000+40*56
 .byt >$A000+40*57
 .byt >$A000+40*58
 .byt >$A000+40*59
 .byt >$A000+40*60
 .byt >$A000+40*61
 .byt >$A000+40*62
 .byt >$A000+40*63
 .byt >$A000+40*64
 .byt >$A000+40*65
 .byt >$A000+40*66
 .byt >$A000+40*67
 .byt >$A000+40*68
 .byt >$A000+40*69
 .byt >$A000+40*70
 .byt >$A000+40*71
 .byt >$A000+40*72
 .byt >$A000+40*73
 .byt >$A000+40*74
 .byt >$A000+40*75
 .byt >$A000+40*76
 .byt >$A000+40*77
 .byt >$A000+40*78
 .byt >$A000+40*79
 .byt >$A000+40*80
 .byt >$A000+40*81
 .byt >$A000+40*82
 .byt >$A000+40*83
 .byt >$A000+40*84
 .byt >$A000+40*85
 .byt >$A000+40*86
 .byt >$A000+40*87
 .byt >$A000+40*88
 .byt >$A000+40*89
 .byt >$A000+40*90
 .byt >$A000+40*91
 .byt >$A000+40*92
 .byt >$A000+40*93
 .byt >$A000+40*94
 .byt >$A000+40*95
 .byt >$A000+40*96
 .byt >$A000+40*97
 .byt >$A000+40*98
 .byt >$A000+40*99
 .byt >$A000+40*100
 .byt >$A000+40*101
 .byt >$A000+40*102
 .byt >$A000+40*103
 .byt >$A000+40*104
 .byt >$A000+40*105
 .byt >$A000+40*106
 .byt >$A000+40*107
 .byt >$A000+40*108
 .byt >$A000+40*109
 .byt >$A000+40*110
 .byt >$A000+40*111
 .byt >$A000+40*112
 .byt >$A000+40*113
 .byt >$A000+40*114
 .byt >$A000+40*115
 .byt >$A000+40*116
 .byt >$A000+40*117
 .byt >$A000+40*118
 .byt >$A000+40*119
 .byt >$A000+40*120
 .byt >$A000+40*121
 .byt >$A000+40*122
 .byt >$A000+40*123
 .byt >$A000+40*124
 .byt >$A000+40*125
 .byt >$A000+40*126
 .byt >$A000+40*127
 .byt >$A000+40*128
 .byt >$A000+40*129
 .byt >$A000+40*130
 .byt >$A000+40*131
 .byt >$A000+40*132
 .byt >$A000+40*133
 .byt >$A000+40*134
 .byt >$A000+40*135
 .byt >$A000+40*136
 .byt >$A000+40*137
 .byt >$A000+40*138
 .byt >$A000+40*139
 .byt >$A000+40*140
 .byt >$A000+40*141
 .byt >$A000+40*142
 .byt >$A000+40*143
 .byt >$A000+40*144
 .byt >$A000+40*145
 .byt >$A000+40*146
 .byt >$A000+40*147
 .byt >$A000+40*148
 .byt >$A000+40*149
 .byt >$A000+40*150
 .byt >$A000+40*151
 .byt >$A000+40*152
 .byt >$A000+40*153
 .byt >$A000+40*154
 .byt >$A000+40*155
 .byt >$A000+40*156
 .byt >$A000+40*157
 .byt >$A000+40*158
 .byt >$A000+40*159
 .byt >$A000+40*160
 .byt >$A000+40*161
 .byt >$A000+40*162
 .byt >$A000+40*163
 .byt >$A000+40*164
 .byt >$A000+40*165
 .byt >$A000+40*166
 .byt >$A000+40*167
 .byt >$A000+40*168
 .byt >$A000+40*169
 .byt >$A000+40*170
 .byt >$A000+40*171
 .byt >$A000+40*172
 .byt >$A000+40*173
 .byt >$A000+40*174
 .byt >$A000+40*175
 .byt >$A000+40*176
 .byt >$A000+40*177
 .byt >$A000+40*178
 .byt >$A000+40*179
 .byt >$A000+40*180
 .byt >$A000+40*181
 .byt >$A000+40*182
 .byt >$A000+40*183
 .byt >$A000+40*184
 .byt >$A000+40*185
 .byt >$A000+40*186
 .byt >$A000+40*187
 .byt >$A000+40*188
 .byt >$A000+40*189
 .byt >$A000+40*190
 .byt >$A000+40*191
 .byt >$A000+40*192
 .byt >$A000+40*193
 .byt >$A000+40*194
 .byt >$A000+40*195
 .byt >$A000+40*196
 .byt >$A000+40*197
 .byt >$A000+40*198
 .byt >$A000+40*199


#include "unpack.s"

#include "fonte.h"
#include "DisplayText.s"
#include "StorybookText.s"

#include "pacKnight.s"
#include "pacSelect9.s"
#include "pacStory1.s"
#include "pacStory2.s"
#include "pacStory32.s"
#include "pacStory7.s"
 .dsb 10,0
#include "pacStory4.s"
 .dsb 10,0
#include "pacStory5.s"
 .dsb 10,0
#include "pacStory6.s"
 .dsb 10,0
#include "pacValkyrie.s"
#include "pacWarrior.s"
SelectCursorGraphic
 .byt $86,$C0,$C8,$C0,$87
 .byt $7F,$7F,$7F,$7F,$7F
 .byt $86,$C0,$FE,$C0,$87
 .byt $7F,$7F,$7F,$7F,$7F
 .byt $86,$C3,$FF,$E0,$87
 .byt $7F,$7F,$7F,$7F,$7F
 .byt $86,$CF,$FF,$F8,$87


EndOfMemory
