MenuID		.byt 0



PlotMenu
	;Clear existing menu
	ldx #118
	
	;lda #8   ; Tobias
	lda #00
	sta tn_backgroundok
  lda #97   ; the new "space"
	
.(
loop1	sta $BB80+16*40,x
	sta $BB80+19*40,x
	sta $BB80+22*40,x
	sta $BB80+25*40,x
	dex
	bpl loop1
.)
	ldx MenuID
	lda MenuListLo,x
	sta MenuList
	lda MenuListHi,x
	sta MenuList+1
	ldy #00
.(
loop1	lda (MenuList),y
	jsr PlotMenuEntry
	iny
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
	sta screen
	sta screen2
	lda MenuScreenYLOCH,y
	adc #00
	sta screen+1
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
	sta (screen),y
	dey
	bpl loop1
	
	lda block
	clc
	adc CharacterWidth,x
	sta block
	lda block+1
	adc #00
	sta block+1
	jsr nl_screen
	
	dec RowCount
	bne loop3
	
	;Restore screen but adding the width of last character
	lda screen2
	clc
	adc CharacterWidth,x
	sta screen2
	sta screen
	lda screen2+1
	adc #00
	sta screen2+1
	sta screen+1
	
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
 .byt 13
 .byt 14
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
 .byt "KEYBOARD SPACE&CRSR","S"+128    ;5  Tobias - removed a space before "&"
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
 .byt "SHOW REGION","S"+128
MenuEntry14
 .byt "SHOW INN","S"+128
MenuEntry15
 .byt "BROWSE MA","P"+128

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
 .byt "G",97
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
 .byt "&",97
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
 .byt "G",97
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
 .byt "S",97
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
 .byt "S",97
CharacterBlock_Of
 .byt "K"
 .byt 97
CharacterBlock_Ampersand
 .byt "9:"
 .byt "Z["
CharacterBlock_Space
 .byt 97
 .byt 97
