MenuID		.byt 0

ManageOptionSelection
	;Prevent menu selection if not dithered in yet
	lda OptionEnableFlag
.(
	beq skip3
	;Don't allow same key to be pressed (autorepeat will be way too fast)
	ldy KeyRegister
	bne skip5
	lda #128
	sta OldKey
	rts
skip5	cpy OldKey
	beq skip3
	sty OldKey

	;KeyRegister can be Up, Down or Return/Space
	lda SelectedOptionID
	ldx MenuID
	
	cpy #KEY_UP
	bne skip1
	jmp ProcessUp
skip1	cpy #KEY_DOWN
	bne skip2
	jmp ProcessDown
skip2	cpy #KEY_SPACE
	beq skip4
	cpy #KEY_RETURN
	bne skip3
skip4	jmp ProcessSelect
skip3	rts
.)

ProcessUp
	cmp MinimumOptionID,x
.(
	beq skip1
	jsr DeleteSelectedOptionCursor
	dec SelectedOptionID
	jmp DisplaySelectedOptionCursor
skip1	rts
.)
MinimumOptionID
 .byt 0,0,2
 
	
ProcessDown
	cmp #3
.(
	beq skip1
	jsr DeleteSelectedOptionCursor
	inc SelectedOptionID
	jmp DisplaySelectedOptionCursor
skip1	rts
.)
ProcessSelect
	cpx #0
	beq SelectOptionFromMainMenu
	cpx #2
	bcc SelectOptionFromOptions
SelectOptionFromMapStats
	;2)Show another Region
	;3)Return to main menu
	cmp #3
	bcs Return2MainMenu

	;Move to next Region
	lda RegionID
	clc
	adc #1
	cmp #15
.(
	bcc skip1
	lda #00
skip1	sta RegionID
.)

	;Update Map
	ldx #04
	jsr Depack2Screen
	
	;Update Stats
	jmp DisplayRegionStats

SelectOptionFromMainMenu
	;0)Start New Game
	;1)Return to times of lore
	;2)Options
	;3)Map Stats
	cmp #1
.(
	bcs skip1
	jmp StartNewGame
skip1	bne skip2
	jmp ReturnToTimesOfLore
skip2	cmp #2
.)
	beq SelectOptions
SelectMapStats
	lda #2
	sta MenuID
	sta DisplayMapFlag
	jsr PlotMenu
	jsr DisplayRegionStats
	jmp DisplaySelectedOptionCursor

SelectOptions
	lda #1
	sta MenuID
	jsr PlotMenu
	jmp DisplaySelectedOptionCursor
	
SelectOptionFromOptions
	;0)Controller
	;1)Audio
	;2)Difficulty
	;3)Return to main menu
	cmp #1
	bcc SelectController
	beq SelectAudio
	cmp #2
	beq SelectDifficulty
Return2MainMenu
	lda #0
	sta MenuID
	sta DisplayMapFlag
	jsr PlotMenu
	jmp DisplaySelectedOptionCursor

SelectController
	;Inc Controller type
	lda GAME_CONTROLLER
	clc
	adc #1
	cmp #3
.(
	bcc skip1
	lda #0
skip1	sta GAME_CONTROLLER
.)
	;Change the menu item id
	clc
	adc #4
	sta MenuList1
	
	;Update screen
	jsr PlotMenu
	jmp DisplaySelectedOptionCursor
	
SelectAudio
	;Toggle Audio Flag
	lda GAME_AUDIO
	clc
	adc #1
	and #1
	sta GAME_AUDIO

	;Change the menu item id
	clc
	adc #7
	sta MenuList1+1
	
	;Update screen
	jsr PlotMenu
	jmp DisplaySelectedOptionCursor

SelectDifficulty
	;Inc Difficulty type
	lda GAME_DIFFICULTY
	clc
	adc #1
	cmp #3
.(
	bcc skip1
	lda #0
skip1	sta GAME_DIFFICULTY
.)
	;Change the menu item id
	clc
	adc #9
	sta MenuList1+2
	
	;Update screen
	jsr PlotMenu
	jmp DisplaySelectedOptionCursor
	
	
	
	

	

DisplaySelectedOptionCursor
	ldx SelectedOptionID
	lda MenuScreenYLOCL,x
	sec
	sbc #40
	sta irqscreen
	lda MenuScreenYLOCH,x
	sbc #00
	sta irqscreen+1
	ldx #69
.(
loop1	ldy ScreenOffset4Cursor,x
	lda ScreenCharacter4Cursor,x
	sta (irqscreen),y
	dex
	bpl loop1
.)
	rts
	
ScreenOffset4Cursor
 .byt 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
 .byt 122,3+120,4+120,5+120,6+120,7+120,8+120,9+120,10+120,11+120,12+120,13+120,14+120,15+120,16+120
 .byt 17+120,18+120,19+120,20+120,21+120,22+120,23+120,24+120,25+120,26+120,27+120,28+120,29+120
 .byt 30+120,31+120,32+120,33+120,34+120,35+120,36+120
ScreenCharacter4Cursor
 .byt 1,97,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,98,97
 .byt 1,99,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,99
	
DeleteSelectedOptionCursor
	ldx SelectedOptionID
	lda MenuScreenYLOCL,x
	sec
	sbc #40
	sta irqscreen
	lda MenuScreenYLOCH,x
	sbc #00
	sta irqscreen+1
	lda #8
	ldx #69
.(
loop1	ldy ScreenOffset4Cursor,x
	sta (irqscreen),y
	dex
	bpl loop1
.)
	rts


PlotMenu
	;Clear existing menu
	ldx #118
	lda #8
.(
loop1	sta $BB80+15*40,x
	sta $BB80+16*40,x
	sta $BB80+19*40,x
	sta $BB80+22*40,x
	sta $BB80+25*40,x
	dex
	bpl loop1
.)
	;Restore last rows switch back to b500 text
	lda #26
	sta $BFB8

	ldx MenuID
	lda MenuListLo,x
	sta MenuList
	lda MenuListHi,x
	sta MenuList+1
	ldy #00
.(
loop1	lda (MenuList),y
	bmi skip1
	jsr PlotMenuEntry
skip1	iny
	cpy #4
	bcc loop1
.)
	rts

;A==MenuEntryID
;Y==Y Index
;Preserve Y
PlotMenuEntry
	sty pmeYIndex
	tax
	lda MenuEntryLocLo,x
	sta text
	lda MenuEntryLocHi,x
	sta text+1
	lda #00
	sta TotalTextWidth
	;Count length of text
	ldy #255
.(
loop1	iny
	lda (text),y
	php
	and #127
	
	;Locate character Index
	ldx #27
loop2	dex
	cmp ValidCharacters,x
	bne loop2
	
	;Fetch Width of Block character (based on IndexID)
	lda TotalTextWidth
	clc
	adc CharacterWidth,x
	sta TotalTextWidth
	
	plp
	bpl loop1
.)
	sty EntryLineLength
	;Divide length by 2
	lsr
	
	;Subtract from 20
	sta HalfTextWidth
	lda #20
	sec
	sbc HalfTextWidth
	sta MenuEntryStartX
	
	;Store (x6)+30 for glove to know where to go
	ldy pmeYIndex
	pha
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	adc #30
	sta MenuRowsGloveX,y
	pla

	;We now have the xpos(A) to begin plotting the text
	adc MenuScreenYLOCL,y
	sta irqscreen
	sta screen2
	lda MenuScreenYLOCH,y
	adc #00
	sta irqscreen+1
	sta screen2+1
	
	ldy #00
	sty TextIndex
.(
loop4	ldy TextIndex
	lda (text),y
	and #127
	
	;Locate character Index
	ldx #27
loop2	dex
	cmp ValidCharacters,x
	bne loop2

	;Fetch Character block address
	lda CharacterBlockAddressLo,x
	sta block
	lda CharacterBlockAddressHi,x
	sta block+1

	;
	lda #2
	sta RowCount
	
loop3	ldy CharacterWidth,x
	dey

loop1	lda (block),y
	sta (irqscreen),y
	dey
	bpl loop1
	
	lda block
	clc
	adc CharacterWidth,x
	sta block
	lda block+1
	adc #00
	sta block+1
	lda irqscreen
	clc
	adc #40
	sta irqscreen
	lda irqscreen+1
	adc #00
	sta irqscreen+1
	
	dec RowCount
	bne loop3
	
	;Restore screen but adding the width of last character
	lda screen2
	clc
	adc CharacterWidth,x
	sta screen2
	sta irqscreen
	lda screen2+1
	adc #00
	sta screen2+1
	sta irqscreen+1
	
	inc TextIndex
	lda TextIndex
	cmp EntryLineLength
	beq loop4
	bcc loop4
.)
	ldy pmeYIndex
	rts
	


MenuScreenYLOCL
 .byt <$BB80+16*40
 .byt <$BB80+19*40
 .byt <$BB80+22*40
 .byt <$BB80+25*40
MenuScreenYLOCH
 .byt >$BB80+16*40
 .byt >$BB80+19*40
 .byt >$BB80+22*40
 .byt >$BB80+25*40

MenuListLo
 .byt <MenuList0
 .byt <MenuList1
 .byt <MenuList2
MenuListHi
 .byt >MenuList0
 .byt >MenuList1
 .byt >MenuList2
 
MenuRowsGloveX
 .dsb 4,0
MenuRowsGloveY
 .byt 14,38,62,86
MenuList0	;Main Menu
 .byt 0
 .byt 1
 .byt 2
 .byt 3
MenuList1	;Options
 .byt 4
 .byt 7
 .byt 9
 .byt 12
MenuList2	;Map & Stats
 .byt 128
 .byt 128
 .byt 15
 .byt 12

MenuEntryLocLo
 .byt <MenuEntry0
 .byt <MenuEntry1
 .byt <MenuEntry2
 .byt <MenuEntry3
 .byt <MenuEntry4
 .byt <MenuEntry5
 .byt <MenuEntry6
 .byt <MenuEntry7
 .byt <MenuEntry8
 .byt <MenuEntry9
 .byt <MenuEntry10
 .byt <MenuEntry11
 .byt <MenuEntry12
 .byt <MenuEntry13
 .byt <MenuEntry14
 .byt <MenuEntry15
MenuEntryLocHi
 .byt >MenuEntry0
 .byt >MenuEntry1
 .byt >MenuEntry2
 .byt >MenuEntry3
 .byt >MenuEntry4
 .byt >MenuEntry5
 .byt >MenuEntry6
 .byt >MenuEntry7
 .byt >MenuEntry8
 .byt >MenuEntry9
 .byt >MenuEntry10
 .byt >MenuEntry11
 .byt >MenuEntry12
 .byt >MenuEntry13
 .byt >MenuEntry14
 .byt >MenuEntry15
MenuEntry0
 .byt "START NEW GAM","E"+128		;0
MenuEntry1
 .byt "RETURN TO TIMES o LOR","E"+128   ;1
MenuEntry2
 .byt "OPTION","S"+128                  ;2
MenuEntry3
 .byt "MAP & STATISTIC","S"+128         ;3
MenuEntry4
 .byt "KEYBOARD CTRL & CRSR","S"+128    ;4
MenuEntry5
 .byt "KEYBOARD SPACE &CRSR","S"+128    ;5
MenuEntry6
 .byt "AUTO DETECT JOYSTIC","K"+128     ;6
MenuEntry7
 .byt "AUDIO O","N"+128                 ;7
MenuEntry8
 .byt "AUDIO OF","F"+128                ;8
MenuEntry9
 .byt "PLAYER PEASAN","T"+128           ;9
MenuEntry10
 .byt "PLAYER PARTISA","N"+128          ;10
MenuEntry11
 .byt "PLAYER WARRIO","R"+128           ;11
MenuEntry12
 .byt "RETURN TO MAIN MEN","U"+128      ;12
MenuEntry13
 .byt "SHOW DARK FORES","T"+128
 .dsb 8,0
MenuEntry14
 .byt "SHOW ERALA","N"+128
 .dsb 8,0
MenuEntry15
 .byt "SHOW ANOTHER REGIO","N"+128

ValidCharacters	;26
 .byt "ABCDEFGHIJKLMNOPQRSTUVWYo& "
 
CharacterWidth
 .byt 2,2,2,2,2,2,2,2,1,1,2,2,3,2,2,2,2,2,2,2,2,2,3,2,1,2,1



CharacterBlockAddressLo
 .byt <CharacterBlock_A
 .byt <CharacterBlock_B
 .byt <CharacterBlock_C
 .byt <CharacterBlock_D
 .byt <CharacterBlock_E
 .byt <CharacterBlock_F
 .byt <CharacterBlock_G
 .byt <CharacterBlock_H
 .byt <CharacterBlock_I
 .byt <CharacterBlock_J
 .byt <CharacterBlock_K
 .byt <CharacterBlock_L
 .byt <CharacterBlock_M
 .byt <CharacterBlock_N
 .byt <CharacterBlock_O
 .byt <CharacterBlock_P
 .byt <CharacterBlock_Q
 .byt <CharacterBlock_R
 .byt <CharacterBlock_S
 .byt <CharacterBlock_T
 .byt <CharacterBlock_U
 .byt <CharacterBlock_V
 .byt <CharacterBlock_W
 .byt <CharacterBlock_Y
 .byt <CharacterBlock_Of
 .byt <CharacterBlock_Ampersand
 .byt <CharacterBlock_Space
CharacterBlockAddressHi
 .byt >CharacterBlock_A
 .byt >CharacterBlock_B
 .byt >CharacterBlock_C
 .byt >CharacterBlock_D
 .byt >CharacterBlock_E
 .byt >CharacterBlock_F
 .byt >CharacterBlock_G
 .byt >CharacterBlock_H
 .byt >CharacterBlock_I
 .byt >CharacterBlock_J
 .byt >CharacterBlock_K
 .byt >CharacterBlock_L
 .byt >CharacterBlock_M
 .byt >CharacterBlock_N
 .byt >CharacterBlock_O
 .byt >CharacterBlock_P
 .byt >CharacterBlock_Q
 .byt >CharacterBlock_R
 .byt >CharacterBlock_S
 .byt >CharacterBlock_T
 .byt >CharacterBlock_U
 .byt >CharacterBlock_V
 .byt >CharacterBlock_W
 .byt >CharacterBlock_Y
 .byt >CharacterBlock_Of
 .byt >CharacterBlock_Ampersand
 .byt >CharacterBlock_Space

CharacterBlock_A
 .byt 32,"!"
 .byt "AB"
CharacterBlock_B
 .byt "./"
 .byt "CP"
CharacterBlock_C
 .byt ",%"
 .byt 94,95
CharacterBlock_D
 .byt "@-"
 .byt "C\"
CharacterBlock_E
 .byt 34,35
 .byt "CD"
CharacterBlock_F
 .byt 34,35
 .byt "G",8
CharacterBlock_G
 .byt ",%"
 .byt "EF"
CharacterBlock_H
 .byt ";&"
 .byt "GG"
CharacterBlock_I
 .byt "&"
 .byt "G"
CharacterBlock_J
 .byt "2"
 .byt "4"
CharacterBlock_K
 .byt ";<"
 .byt "G]"
CharacterBlock_L
 .byt "&",8
 .byt "CD"
CharacterBlock_M
 .byt "'()"
 .byt "HIJ"
CharacterBlock_N
 .byt "*+"
 .byt "GL"
CharacterBlock_O
 .byt ",-"
 .byt "MN"
CharacterBlock_P
 .byt "./"
 .byt "G",8
CharacterBlock_Q
 .byt ",-"
 .byt "MT"
CharacterBlock_R
 .byt "./"
 .byt "GO"
CharacterBlock_S
 .byt "01"
 .byt "QR"
CharacterBlock_T
 .byt "23"
 .byt "S",8
CharacterBlock_U
 .byt "&5"
 .byt "UV"
CharacterBlock_V
 .byt "6?"
 .byt "W",96
CharacterBlock_W
 .byt "678"
 .byt "WXY"
CharacterBlock_Y
 .byt "=>"
 .byt "S",8
CharacterBlock_Of
 .byt "K"
 .byt 8
CharacterBlock_Ampersand
 .byt "9:"
 .byt "Z["
CharacterBlock_Space
 .byt 8
 .byt 8
