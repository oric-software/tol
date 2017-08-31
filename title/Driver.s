;Title section

;Consisting of TOL Intro
; Draw template
; Draw with chisel
; Colourise
;Display Door frames and title on IRQTimeout
;During wait process Menu Selection
;Play Music on IRQ with IRQTimer and Read Keyboard
;Also allow selection of options and if memory permits display map and options

;For title menus see menudisplay.s

#define	GAME_CONTROLLER		$BFE0
#define	GAME_AUDIO		$BFE1
#define	GAME_DIFFICULTY		$BFE2

#define	SYS_IRQLO			$245
#define	SYS_IRQHI			$246

#define	VIA_PORTB			$0300
#define	VIA_T1CL			$0304
#define	VIA_T2LL			$0308
#define	VIA_T2CH			$0309
#define	VIA_SR			$030A
#define	VIA_ACR			$030B
#define	VIA_PCR			$030C
#define	VIA_IFR			$030D
#define	VIA_IER			$030E
#define	VIA_PORTA			$030F

#define	KEY_UP			1
#define	KEY_DOWN            	2
#define	KEY_SPACE           	3
#define	KEY_RETURN          	4


;FLIP TAPE AND REWIND
 .zero
*=$00

text		.dsb 2
screen		.dsb 2
Temp01		.dsb 1
Temp02		.dsb 1

IRQDelay		.dsb 1

source		.dsb 2
EventCount	.dsb 1
dither		.dsb 2
char		.dsb 2

pcTempX		.dsb 1
pcTempY		.dsb 1
ChiselPoint	.dsb 2
GoldPoint		.dsb 2
chisel		.dsb 2
chisel2		.dsb 2
chisel3		.dsb 2
chiselgfx		.dsb 2
chiselmsk		.dsb 2
ChiselFrame	.dsb 1

Mult8		.dsb 2
Mult40Hi
Mult32Hi		.dsb 1
TempX		.dsb 1

;sp		.dsb 2
ptr_source	.dsb 2
ptr_destination	.dsb 2
ptr_destination_end	.dsb 2
ptr_source_back	.dsb 2
offset		.dsb 2
mask_value	.dsb 2
nb_src		.dsb 2
nb_dst		.dsb 2

rndRandom		.dsb 2
rndTemp		.dsb 1

KeyRegister	.dsb 1
GloveDestinationX	.dsb 1
GloveDestinationY	.dsb 1

GloveScreen	.dsb 2
OldGloveScreen	.dsb 2
GloveDelayFrac	.dsb 1

MenuList		.dsb 2
pmeYIndex		.dsb 1
MenuEntryStartX
HalfTextWidth
TotalTextWidth	.dsb 1
TextIndex		.dsb 1
block		.dsb 2
screen2		.dsb 2
RowCount		.dsb 1
EntryLineLength	.dsb 1

;Borders
bX		.dsb 1
bY		.dsb 1
bData		.dsb 2
bByteCount	.dsb 1
bNibbleIndex	.dsb 1
bNibbleByte	.dsb 1
bByteIndex	.dsb 1

;IRQ driven menu system
irqscreen		.dsb 1


 .text
*=$500

Driver	;Setup new IRQ
	sei
	jsr InitIRQ
	
	;Restore altset lowercase letters
	ldx #00
.(
loop1	lda RemainingLowercase,x
	sta $BB80,x
	inx
	bpl loop1
.)	
	;Fade in Template
	jsr CycleInInk
	
	;Display bottom menu
	jsr PlotMenu	;PlotOptions
	jsr DitherInCharset
	
	;Display Selected Option then enable it
	jsr DisplaySelectedOptionCursor
	lda #1
	sta OptionEnableFlag
	
	;Process Chisel
	jsr ProcessChisel
	
	;Then introduce music
	jsr SetupMusic
	
	;We may prematurely quit Chiselling if the map is selected
	lda DisplayMapFlag
	bne MainLoopSkip
	
	;Turn our chiselled masterpiece into Gold
	jsr Stone2Gold
	
	;And again the colourising may be shortlived if the map is selected prematurely
	lda DisplayMapFlag
	bne MainLoopSkip

MainLoop	;Then onto main cycle of HIRES inlays to display
	jsr ShowDoorFrame0
	lda DisplayMapFlag
	bne MainLoopSkip
	
	jsr ShowDoorFrame1
	lda DisplayMapFlag
	bne MainLoopSkip
	
	jsr ShowDoorFrame2
	lda DisplayMapFlag
	bne MainLoopSkip
	
	jsr ShowDoorFrame3
	lda DisplayMapFlag
	bne MainLoopSkip
	
	jsr ShowTitle	;Also shine
	lda DisplayMapFlag
	beq MainLoop

MainLoopSkip
	;Display Inlay map
	ldx #04
	jsr Depack2Screen
	
	;And loop on drawing region border
.(
loop1	jsr DrawBorder
	lda DisplayMapFlag
	bne loop1
.)
	;If Return to main menu selected then DisplayMapFlag will be reset and we can then
	;return to displaying the normal inlays again
	jmp MainLoop

StartNewGame
ReturnToTimesOfLore
	rts
	
	
OldKey		.byt 0
OptionEnableFlag	.byt 0
SelectedOptionID	.byt 0

;RegionNameIndex
; .byt 0 
; .byt 11
; .byt 25
; .byt 36
; .byt 42
; .byt 56
; .byt 63
; .byt 72
;ShowRegionID	.byt 0
;ShowTownID	.byt 0
;RegionNameText
; .byt "DARK FORES","T"+128		;0
; .byt "TEMPLE o ANGO","R"+128          ;11
; .byt "CRATOR WAL","D"+128              ;25
; .byt "DESER","T"+128                  ;36
; .byt "ENCHANTED WOO","D"+128         ;42
; .byt "EQUINO","S"+128                  ;56
; .byt "THE MERE","S"+128                ;67
; .byt "TEMPLEMEA","D"+128               ;76
;
;TownNameIndex
; .byt 0 
; .byt 6 
; .byt 14
; .byt 21
; .byt 29
; .byt 35
; .byt 47
;
;TownNameText
; .byt "ERALA","N"+128		;0
; .byt "GANESTO","R"+128                 ;6
; .byt "HAMPTO","N"+128                  ;14
; .byt "LANKWEL","L"+128                 ;21
; .byt "RHYDE","R"+128                   ;29
; .byt "SLEEPY RIVE","R"+128             ;35
; .byt "TREEL","A"+128                   ;47


DisplayMapFlag	.byt 0

GenericDelay
	sta IRQDelay
.(
loop1	lda IRQDelay
	bne loop1
.)
	rts

ShowDoorFrame0
	ldx #00
	jsr Depack2Screen
	jmp DoorDelay

	
ShowDoorFrame1
	ldx #01
	jsr Depack2Screen
DoorDelay
	lda #100
GenericLoopDelay
	sta IRQDelay
.(
loop1	lda DisplayMapFlag
	bne skip1
	lda IRQDelay
	bne loop1
skip1	rts

.)

ShowDoorFrame2
	ldx #02
	jsr Depack2Screen
	jmp DoorDelay
ShowDoorFrame3
	ldx #03
	jsr Depack2Screen
	lda #200
	jsr GenericDelay
ShowTitle	;Also shine
	lda #<GoldScreen
	sta source
	lda #>GoldScreen
	sta source+1
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #120
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	lda source
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1
	dex
	bne loop2
.)
	lda #255
	jmp GenericLoopDelay
	
InitIRQ	sei
	lda #<IRQServiceRoutine
	sta SYS_IRQLO
	lda #>IRQServiceRoutine
	sta SYS_IRQHI
	cli
	rts
SetupMusic
	rts
	

IRQServiceRoutine
	;Clear IRQ
	sta IRQAcc+1
	stx IRQXRg+1
	sty IRQYRg+1
	lda VIA_T1CL
	
	;Sense Keys(Return,Space,Up,Down)
	jsr ScanKeyboard
	jsr ManageOptionSelection
	
	;Proc Music
	lda MusicJob
.(
	beq skip2
	jsr ProcMusic
	
skip2	lda IRQDelay
.)
	beq IRQAcc
	dec IRQDelay
IRQAcc	lda #00
IRQXRg	ldx #00
IRQYRg	ldy #00
	rti
	
MusicJob	.byt 0

ScanKeyboard
	ldx #3
.(
loop1	lda KeyColumn,x
	ldy #$0E
	jsr SendAYRegister
	lda KeyRow,x
	sta VIA_PORTB
	nop
	nop
	nop
	nop
	nop
	nop
	lda VIA_PORTB
	and #8
	bne skip1
	dex
	bpl loop1
	inx
	stx KeyRegister
	rts
skip1	inx
.)
	stx KeyRegister
	rts
	
KeyColumn
 .byt $F7	;Up
 .byt $BF	;Down
 .byt $DF	;Return
 .byt $FE	;Space
KeyRow
 .byt 4
 .byt 4
 .byt 7
 .byt 4
	
	
SendAYRegister
	;Send AY reg.
	sty VIA_PORTA
	ldy #$FF
	sty VIA_PCR
	ldy #$DD
	sty VIA_PCR
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	sty VIA_PCR
	rts


ProcMusic
	rts

SendAYBank
	ldy #$DD
	ldx #13
.(
loop1	stx VIA_PORTA
	lda #$FF
	sta VIA_PCR
	sty VIA_PCR
	lda AYBank,x
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	sty VIA_PCR
	dex
	bpl loop1
.)
	rts
;Chip chisel
AYBank
AYPokeX
 .byt 17	;Vary between 0 to 39 ;)
 .byt 0,0,0,0,0,0,$76,$10,0,0
AYPokeY
 .byt $43	;Vary between 0 and 119 ;)
 .byt 0,0


InkColumn
	sta Temp01
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #120
	ldy #00
.(
loop1	lda Temp01
	sta (screen),y
	jsr nl_screen
	dex
	bne loop1
.)
	rts	

CycleInInk
	ldx #6
.(
loop1	lda FadeInInkColour,x
	stx Temp02
	jsr InkColumn
	lda #10
	jsr GenericDelay
	ldx Temp02
	dex
	bne loop1
	;For last entry use 6/3 combo
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #60
loop3	ldy #00
	lda #3
	sta (screen),y
	ldy #40
	lda #6
	sta (screen),y
	jsr nl_screen
	jsr nl_screen
	dex
	bne loop3
.)
	rts	

FadeInInkColour
 .byt 7,3,6,2,5,1,4

nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts

Depack2Screen
	lda PackedSourceAddressLo,x
	sta ptr_source
	lda PackedSourceAddressHi,x
	sta ptr_source+1
	
	lda #<$A000
	sta ptr_destination
	lda #>$A000
	sta ptr_destination+1
	
	lda #<$B2bf
	sta ptr_destination_end
	lda #>$B2bf
	sta ptr_destination_end+1
	
	jmp Unpack
	
PackedSourceAddressLo
 .byt <tolDF02
 .byt <tolDF12
 .byt <tolDF22
 .byt <tolDF32
 .byt <tolmap
PackedSourceAddressHi
 .byt >tolDF02
 .byt >tolDF12
 .byt >tolDF22
 .byt >tolDF32
 .byt >tolmap
	
SelectedOption	.byt 0
	
DitherInCharset
	ldx #00
.(
loop1	lda LetterCharset,x
	sta $b500,x
	lda LetterCharset+256,x
	sta $b600,x
	lda LetterCharset+512,x
	sta $b700,x
	dex
	bne loop1
.)
	rts
	
	lda #<DitherMasks
	sta dither
	lda #>DitherMasks
	sta dither+1
;skip998	nop
;	jmp skip998
	lda #4
	sta EventCount
.(	
loop3	ldx #32
	
loop2	;Calculate Character and source Address
	lda #00
	sta char+1
	txa
	
	;Multiply character by 8
	asl
	
	asl
	rol char+1
	
	asl
	rol char+1
	
	sta char
	adc #<LetterCharset
	sta source
	ldy char+1
	tya
	adc #$B4
	sta char+1
	tya
	adc #>LetterCharset-256
	sta source+1
	
	ldy #7
loop1	lda (source),y
	and (dither),y
	sta (char),y
	dey
	bpl loop1
	inx
	cpx #97
	bcc loop2
	
	;Progress dither in time
	lda #20
	jsr GenericDelay

	lda dither
	adc #8
	sta dither
	bcc skip1
	inc dither+1
skip1	dec EventCount
	bne loop3
.)	
	rts
DitherMasks
 .byt %00000001
 .byt %00000010
 .byt %00000100
 .byt %00000100
 .byt %00001000
 .byt %00010000
 .byt %00100000
 .byt %00100000
	
 .byt %00100011
 .byt %00000111
 .byt %00001110
 .byt %00001110
 .byt %00011100
 .byt %00111000
 .byt %00110001
 .byt %00110001

 .byt %00110111
 .byt %00101111
 .byt %00011111
 .byt %00011111
 .byt %00111110
 .byt %00111101
 .byt %00111011
 .byt %00111011

 .byt %00111111
 .byt %00111111
 .byt %00111111
 .byt %00111111
 .byt %00111111
 .byt %00111111
 .byt %00111111
 .byt %00111111

ProcessChisel
	;
	lda #00
	sta ChiselFrame
	
	lda #<CutsX
.(
	sta VectorCutsX+1
	lda #>CutsX
	sta VectorCutsX+2
	
	lda #<CutsY
	sta VectorCutsY+1
	lda #>CutsY
	sta VectorCutsY+2
	
loop1	;If DisplayMapFlag then quit immediately
	lda DisplayMapFlag
	bne ExitCuts
	;Calc Offset of block(1x8) to plot
VectorCutsY
	lda $dead
	bmi ExitCuts
	
	;Multiply Y by 7
	sta Temp01
	asl
	asl
	asl
	sec
	sbc Temp01
	tay

VectorCutsX
	lda $dead
	clc
	adc #2
	
	jsr GenerateSFX
	jsr CalculateScreenOffset
	
	;Calc Screen Loc
	sta ChiselPoint
	tya
	adc #$A0
	sta ChiselPoint+1
	
	;Calc Gold loc
	lda ChiselPoint
	adc #<GoldScreen
	sta GoldPoint
	tya
	adc #>GoldScreen
	sta GoldPoint+1
	
	jsr ChipAtRockFace
	
	inc VectorCutsY+1
	bne skip1
	inc VectorCutsY+2
skip1	inc VectorCutsX+1
	bne skip2
	inc VectorCutsX+2
skip2
	jmp loop1
ExitCuts	rts
.)

GenerateSFX
.(
	sta vectorA+1
	sty vectorY+1
	jsr GetRandomNumber
	cmp #222
	bcs skip1
	and #31
	sta AYPokeX
	
	jsr SendAYBank
skip1
vectorA	lda #00
vectorY	ldy #00
.)
	rts


GetRandomNumber
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp
         clc
         adc rndRandom
         adc VIA_T1CL
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

Stone2Gold
.(
loop2	;Check DisplayMapFlag
	lda DisplayMapFlag
	bne skip2
	ldx #39
loop1	lda NthPositionOffsetLo,x
	sta vector2+1
	clc
	adc #<GoldScreen
	sta vector1+1
	lda NthPositionOffsetHi,x
	adc #>GoldScreen
	sta vector1+2
	lda NthPositionOffsetHi,x
	adc #$A0
	sta vector2+2
vector1	lda $dead
vector2	sta $dead
	
	lda NthPositionDropFrac,x
	adc NthPositionDropRate,x
	sta NthPositionDropFrac,x
	bcc skip1
	
	lda NthPositionHeight,x
	beq skip1
	dec NthPositionHeight,x
	
	lda NthPositionOffsetLo,x
	clc
	adc #40
	sta NthPositionOffsetLo,x
	lda NthPositionOffsetHi,x
	adc #00
	sta NthPositionOffsetHi,x
	
skip1	dex
	bpl loop1
	;Check all heights
	ldx #39
loop3	lda NthPositionHeight,x
	bne loop2
	dex
	bpl loop3
skip2	rts
.)	
	

NthPositionHeight
 .dsb 40,118
NthPositionOffsetLo
 .byt 0,1,2,3,4,5,6,7,8,9
 .byt 10,11,12,13,14,15,16,17,18,19
 .byt 20,21,22,23,24,25,26,27,28,29
 .byt 30,31,32,33,34,35,36,37,38,39
NthPositionOffsetHi
 .dsb 40,0
NthPositionDropFrac
 .dsb 40,0
NthPositionDropRate
 .byt 14	;3 
 .byt 24	;2 
 .byt 13	;3 
 .byt 16	;4 
 .byt 17	;8 
 .byt 23	;2 
 .byt 23	;2 
 .byt 22	;0 
 .byt 19	;9 
 .byt 23	;0 
 .byt 17	;7 
 .byt 21	;9 
 .byt 19	;6 
 .byt 22	;1 
 .byt 15	;1 
 .byt 16	;2 
 .byt 23	;9 
 .byt 17	;8 
 .byt 14	;9 
 .byt 14	;5 
 .byt 18	;7 
 .byt 13	;4 
 .byt 18	;5 
 .byt 17	;2 
 .byt 23	;0 
 .byt 25	;0 
 .byt 22	;4 
 .byt 16	;6 
 .byt 17	;8 
 .byt 24	;5 
 .byt 20	;4 
 .byt 20	;5 
 .byt 24	;7 
 .byt 18	;3 
 .byt 19	;4 
 .byt 25	;3 
 .byt 20	;2 
 .byt 23	;6 
 .byt 15	;6 
 .byt 25	;2 

	
	
	
	

ChipAtRockFace
	;Plot 7 bytes of block starting at bottom and working up and have cyclic Chisel frame tracking it all!
	ldx #6
.(
loop2	ldy ScreenOffsetFor1x7,x

	jsr PlotChisel
	
	;Fetch Gold Graphic Byte
	lda (GoldPoint),y
	
	;Remove Inverse
	bpl skip1
	eor #63+128
	
skip1	;Store on Screen
	sta (ChiselPoint),y
	
	;Progress
	lda #2
	jsr GenericDelay
	jsr DeleteChisel
	dex
	bpl loop2
.)
	rts

ScreenOffsetFor1x7
 .byt 0,40,80,120,160,200,240

PlotChisel
	stx pcTempX
	sty pcTempY
	tya
	clc
	adc ChiselPoint
	sta chisel
	lda ChiselPoint+1
	adc #00
	sta chisel+1
	;Chisel is 24(4)x17 so offset chisel UL
	lda chisel
	sec
	sbc #<3+17*40
	sta chisel
	lda chisel+1
	sbc #>3+17*40
	sta chisel+1
	
	;Validate chisel
	lda chisel
	sta chisel2
	sta chisel3
	lda chisel+1
	sta chisel2+1
	sta chisel3+1
	
	lda #<ChiselBGBuffer
.(
	sta chiselbg+1
	lda #>ChiselBGBuffer
	sta chiselbg+2
	
	;Capture ChiselBG
	ldx #17
loop2	ldy #3
loop1	lda (chisel),y
chiselbg	sta $dead
	inc chiselbg+1
	bne skip1
	inc chiselbg+2
skip1	dey
	bpl loop1
	lda chisel
	clc
	adc #40
	sta chisel
	lda chisel+1
	adc #00
	sta chisel+1
	dex
	bne loop2
.)	
	;Plot Chisel with Mask
	dec ChiselFrame
.(
	bpl skip1
	lda #5
	sta ChiselFrame
skip1	ldx ChiselFrame
.)
	lda ChiselBitmapFrameLo,x
	sta chiselgfx
	lda ChiselBitmapFrameHi,x
	sta chiselgfx+1
	
	lda ChiselMaskFrameLo,x
	sta chiselmsk
	lda ChiselMaskFrameHi,x
	sta chiselmsk+1
	
	ldx #17
.(
loop2	ldy #3
loop1	lda (chisel2),y
	cmp #16	;Don't corrupt ink
	bcc skip1
	and (chiselmsk),y
	ora (chiselgfx),y
	sta (chisel2),y
skip1	dey
	bpl loop1
	lda chisel2
	clc
	adc #40
	sta chisel2
	lda chisel2+1
	adc #00
	sta chisel2+1
	lda chiselmsk
	adc #4
	sta chiselmsk
	lda chiselmsk+1
	adc #0
	sta chiselmsk+1
	lda chiselgfx
	adc #4
	sta chiselgfx
	lda chiselgfx+1
	adc #0
	sta chiselgfx+1
	dex
	bne loop2
.)
	ldx pcTempX
	ldy pcTempY
	rts
ChiselBGBuffer
 .dsb 4*17,0

DeleteChisel
	stx pcTempX
	sty pcTempY
	lda #<ChiselBGBuffer
.(
	sta chiselbg+1
	lda #>ChiselBGBuffer
	sta chiselbg+2
	
	;Restore screen
	ldx #17
loop2	ldy #3
loop1
chiselbg	lda $dead
	sta (chisel3),y

	inc chiselbg+1
	bne skip1
	inc chiselbg+2
skip1	dey
	bpl loop1
	lda chisel3
	clc
	adc #40
	sta chisel3
	lda chisel3+1
	adc #00
	sta chisel3+1
	dex
	bne loop2
.)	
	ldx pcTempX
	ldy pcTempY
	rts
	
	
	
	
CalculateScreenOffset
	clc
	adc ScreenOffsetLo,y
	pha
	lda ScreenOffsetHi,y
	adc #00
	tay
	pla
	rts

ScreenOffsetLo
 .byt <0
 .byt <40*1
 .byt <40*2
 .byt <40*3
 .byt <40*4
 .byt <40*5
 .byt <40*6
 .byt <40*7
 .byt <40*8
 .byt <40*9
 .byt <40*10
 .byt <40*11
 .byt <40*12
 .byt <40*13
 .byt <40*14
 .byt <40*15
 .byt <40*16
 .byt <40*17
 .byt <40*18
 .byt <40*19
 .byt <40*20
 .byt <40*21
 .byt <40*22
 .byt <40*23
 .byt <40*24
 .byt <40*25
 .byt <40*26
 .byt <40*27
 .byt <40*28
 .byt <40*29
 .byt <40*30
 .byt <40*31
 .byt <40*32
 .byt <40*33
 .byt <40*34
 .byt <40*35
 .byt <40*36
 .byt <40*37
 .byt <40*38
 .byt <40*39
 .byt <40*40
 .byt <40*41
 .byt <40*42
 .byt <40*43
 .byt <40*44
 .byt <40*45
 .byt <40*46
 .byt <40*47
 .byt <40*48
 .byt <40*49
 .byt <40*50
 .byt <40*51
 .byt <40*52
 .byt <40*53
 .byt <40*54
 .byt <40*55
 .byt <40*56
 .byt <40*57
 .byt <40*58
 .byt <40*59
 .byt <40*60
 .byt <40*61
 .byt <40*62
 .byt <40*63
 .byt <40*64
 .byt <40*65
 .byt <40*66
 .byt <40*67
 .byt <40*68
 .byt <40*69
 .byt <40*70
 .byt <40*71
 .byt <40*72
 .byt <40*73
 .byt <40*74
 .byt <40*75
 .byt <40*76
 .byt <40*77
 .byt <40*78
 .byt <40*79
 .byt <40*80
 .byt <40*81
 .byt <40*82
 .byt <40*83
 .byt <40*84
 .byt <40*85
 .byt <40*86
 .byt <40*87
 .byt <40*88
 .byt <40*89
 .byt <40*90
 .byt <40*91
 .byt <40*92
 .byt <40*93
 .byt <40*94
 .byt <40*95
 .byt <40*96
 .byt <40*97
 .byt <40*98
 .byt <40*99
 .byt <40*100
 .byt <40*101
 .byt <40*102
 .byt <40*103
 .byt <40*104
 .byt <40*105
 .byt <40*106
 .byt <40*107
 .byt <40*108
 .byt <40*109
 .byt <40*110
 .byt <40*111
 .byt <40*112
 .byt <40*113
 .byt <40*114
 .byt <40*115
 .byt <40*116
 .byt <40*117
 .byt <40*118
 .byt <40*119
ScreenOffsetHi
 .byt >0
 .byt >40*1
 .byt >40*2
 .byt >40*3
 .byt >40*4
 .byt >40*5
 .byt >40*6
 .byt >40*7
 .byt >40*8
 .byt >40*9
 .byt >40*10
 .byt >40*11
 .byt >40*12
 .byt >40*13
 .byt >40*14
 .byt >40*15
 .byt >40*16
 .byt >40*17
 .byt >40*18
 .byt >40*19
 .byt >40*20
 .byt >40*21
 .byt >40*22
 .byt >40*23
 .byt >40*24
 .byt >40*25
 .byt >40*26
 .byt >40*27
 .byt >40*28
 .byt >40*29
 .byt >40*30
 .byt >40*31
 .byt >40*32
 .byt >40*33
 .byt >40*34
 .byt >40*35
 .byt >40*36
 .byt >40*37
 .byt >40*38
 .byt >40*39
 .byt >40*40
 .byt >40*41
 .byt >40*42
 .byt >40*43
 .byt >40*44
 .byt >40*45
 .byt >40*46
 .byt >40*47
 .byt >40*48
 .byt >40*49
 .byt >40*50
 .byt >40*51
 .byt >40*52
 .byt >40*53
 .byt >40*54
 .byt >40*55
 .byt >40*56
 .byt >40*57
 .byt >40*58
 .byt >40*59
 .byt >40*60
 .byt >40*61
 .byt >40*62
 .byt >40*63
 .byt >40*64
 .byt >40*65
 .byt >40*66
 .byt >40*67
 .byt >40*68
 .byt >40*69
 .byt >40*70
 .byt >40*71
 .byt >40*72
 .byt >40*73
 .byt >40*74
 .byt >40*75
 .byt >40*76
 .byt >40*77
 .byt >40*78
 .byt >40*79
 .byt >40*80
 .byt >40*81
 .byt >40*82
 .byt >40*83
 .byt >40*84
 .byt >40*85
 .byt >40*86
 .byt >40*87
 .byt >40*88
 .byt >40*89
 .byt >40*90
 .byt >40*91
 .byt >40*92
 .byt >40*93
 .byt >40*94
 .byt >40*95
 .byt >40*96
 .byt >40*97
 .byt >40*98
 .byt >40*99
 .byt >40*100
 .byt >40*101
 .byt >40*102
 .byt >40*103
 .byt >40*104
 .byt >40*105
 .byt >40*106
 .byt >40*107
 .byt >40*108
 .byt >40*109
 .byt >40*110
 .byt >40*111
 .byt >40*112
 .byt >40*113
 .byt >40*114
 .byt >40*115
 .byt >40*116
 .byt >40*117
 .byt >40*118
 .byt >40*119
	

	
	
	
	
;	
;
#include "Cutsmem.s"	;X/Y sequence of chisel positions(plots blocks of 6x6?)
#include "hrsgold.s"	;Unpacked Gold screen but 37x118
#include "Chisels.s"	;Chisel Frames
#include "unpack.s"		;Unpack code
#include "pactoldf02.s"
#include "pactoldf12.s"
#include "pactoldf22.s"
#include "pactoldf32.s"
#include "pacTOLMap.s"
#include "MenuDisplay.s"
#include "DrawTarget.s"

Borders_DarkForest
#include "Borders_darkforest.s"
Borders_TempleOfAngor
#include "border_angor.s"
Borders_CratorWald
#include "border_crator.s"
Borders_Dessert
#include "border_dessert.s"
Borders_EnchantedForest
#include "border_enchant.s"
Borders_Equinox
#include "border_equinox.s"
Borders_Eralan
#include "border_eralan.s"
Borders_Ganestor
#include "border_ganestor.s"
Borders_Hampton
#include "border_hampton.s"
Borders_Lankwell
#include "border_lankwell.s"
Borders_TheMeres
#include "border_meres.s"
Borders_Rhyder
#include "border_rhyder.s"
Borders_SleepyRiver
#include "border_sleepy.s"
Borders_TempleMead
#include "border_temple.s"
Borders_Treela
#include "border_treela.s"
;;32-97   Letters
;;98-103  -
;;104-127 Hand(24(6x4))

;;Hand code
;;We use both character sets and a screen template holding the original Letter characters.
;;Alt charset will leak into screen but this will not matter since using HIRES overlay.
;
;;$A000-$B2BF HIRES Overlay
;;$B2C0
;;$B500-$B707 Letter Charset
;;$B708-$B7FF Hand Characters
;;$B800
;;$B900-$BB07 Letter Charset
;;$BB08-$BBFF Hand Characters
;;$BC00
;;$BDD8-$BFDF Text Screen
;
;;Characters 104 to 127 (24) are reserved for the hand.
;;The shifted hand is placed onto these characters observing the shifted mask against the bg letters
;
;;In order to remove any flicker the characters are dynamically shifted about.
;;Initially the character arrangement is..
;
;;104 108 112 116 120
;;105 109 113 117 121
;;106 110 114 118 122
;;107 111 115 119 123

;Initial Layout
Himem
ChiselOverlap	;$0500-$9DCF Code
 .dsb $9DD0-*
ChiselSpace	;$9DD0-$9FFF Preserved 14x40 rows for Chisel out of screen(Zero Filled)
 .dsb 14*40,0
HiresOverlay	;$A000-$B2BE Canvas HIRES Overlay (black ink)
#include "hrsCanvas.s"
SwitchBack2Text	;$B2BF-$B2BF 26
 .byt 26
LetterCharset	;$B2C0-$B4C7 Letter Charset
#include "OptionsCharset.s"
#include "MenuOptionCursor.s"
SpareBit1		;$B4C8-$B4FF -
 .dsb $B500-*
VoidedCharset	;$B500-$B7FF Zero Filled
 .dsb 3*256,0
;$B800-$B868 Glove Bitmap Temp(5x21)
;$B869-$B8D1 Glove Mask(5x21)
;$B8D2-$B8FF Spare
 .dsb $b900-*
;$B900-$BB7F Alt set for Stats text
#include "fonte.h"
;$BB80-$BBA7 Status line of screen (destroyed in tape load)
 .dsb 40,8
;$BBA8-$BC27 Rest of lower case character set (moved back to $BB80 after load)
RemainingLowercase
    .byt  $00,$00,$0c,$32,$12,$1c,$10,$38,$00,$00,$18,$24,$24
    .byt  $1c,$05,$06,$00,$00,$2c,$32,$10,$10,$10,$00,$00,$00,$0e,$10,$0c
    .byt  $22,$3c,$00,$00,$10,$1c,$30,$10,$12,$0c,$00,$00,$00,$00,$12,$22
    .byt  $26,$1b,$00,$00,$00,$00,$22,$14,$14,$08,$00,$00,$00,$04,$22,$2a
    .byt  $2a,$14,$00,$00,$00,$00,$22,$24,$18,$26,$00,$00,$00,$12,$22,$26
    .byt  $1a,$04,$38,$00,$00,$00,$3c,$08,$10,$3e,$00,$05,$0b,$16,$2b,$17
    .byt  $3d,$2f,$3f,$2f,$37,$1d,$1d,$1d,$19,$25,$3f,$2f,$37,$23,$1d,$01
    .byt  $1f,$21,$3f,$23,$1d,$23,$1d,$01,$1f,$21,$3f,$00,$00,$00,$00,$00
    .byt  $00,$00,$00
;$BC28-$BDD7 Spare
SpareBit2
 .dsb $BDD8-*
TextScreen	;$BDD8-$BFDE 8 Filled
 .dsb 519-39,8
LastTextRow	;Switch last row to std B400 text
 .byt 26,1
 .dsb 37,8
Switch2HIRES	;$BFDF-$BFDF 28
 .byt 28
CurrentController
 .byt 0
CurrentAudio
 .byt 0
CurrentDifficulty
 .byt 0
;$BFE3-$BFFF -

