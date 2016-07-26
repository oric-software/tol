;DisplayText.s

;X==StoryID
DisplayText
;	nop
;	jmp DisplayText
	lda StoryTextAddressLo,x
	sta text
	lda StoryTextAddressHi,x
	sta text+1
	lda StoryInitialXPos,x
	sta CharacterXPos
	lda StoryInitialYPos,x
	sta CharacterYPos
.(
loop1	lda #3
	sta IRQDelay
loop2	lda IRQDelay
	bne loop2
	ldy #00
	lda (text),y
	bmi skip2
	sta CharacterID
	
	ldx CharacterXPos
	ldy CharacterYPos
	
	jsr DisplayCharacter
	
	;Move character right by width (which includes gap between characters)
	ldx CharacterID
	lda CharacterXPos
	clc
	adc CharacterWidth-32,x
	sta CharacterXPos
	
rent1	;Proceed to next character
	inc text
	bne skip1
	inc text+1
skip1	jmp loop1
skip2	;Codes over 128 indicate behavioural changes
	;128-161==Carriage Return to next row(range for column)
	;255    ==End of passage
	cmp #255
	beq EndOfPassage
	and #63
	asl
	sta TempXCalc
	asl
	adc TempXCalc
	sta CharacterXPos
	lda CharacterYPos
	adc #8
	sta CharacterYPos
	jmp rent1
EndOfPassage
.)
	rts

	
	

	
;A Character(32-127)
;X (0-239)
;Y (0-191)
DisplayCharacter
	stx TempCharacterX
	sty TempCharacterY
	;Fetch Character Address
	tax
	lda CharacterAddressLo-32,x
	sta char
	lda CharacterAddressHi-32,x
	sta char+1
	
	;Copy Character to Buffer
	ldy #7
.(
loop1	lda #00
	sta CharacterRightBuffer,y
	lda (char),y
	sta CharacterLeftBuffer,y
	dey
	bpl loop1
.)	
	;Fetch number of shifts required
	ldx TempCharacterX
	ldy HIRESBitOffset,x
.(
	beq skip2

loop2	;Shift right to bitpos
	ldx #7
loop1	lsr CharacterLeftBuffer,x
	lda CharacterRightBuffer,x
	bcc skip1
	ora #64
skip1	lsr
	sta CharacterRightBuffer,x
	dex
	bpl loop1
	
	;Proceed to next shift
	dey
	bne loop2

skip2	;Calculate Position on screen
.)
	ldx TempCharacterX
	ldy TempCharacterY
	lda HIRESXLoc,x
	clc
	adc HiresYLOCL,y
	sta screen
	lda HiresYLOCH,y
	adc #00
	sta screen+1
	
	;Plot Buffer
	clc
	ldx #0
.(
loop1	lda CharacterLeftBuffer,x
	ldy #00
	eor (screen),y
	sta (screen),y
	lda CharacterRightBuffer,x
	iny
	eor (screen),y
	sta (screen),y
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	inx
	cpx #8
	bcc loop1
.)
	rts
	
CharacterAddressLo
 .byt <fonte	;32
 .byt <fonte+8*1
 .byt <fonte+8*2
 .byt <fonte+8*3
 .byt <fonte+8*4
 .byt <fonte+8*5
 .byt <fonte+8*6
 .byt <fonte+8*7
 .byt <fonte+8*8
 .byt <fonte+8*9
 .byt <fonte+8*10	;42
 .byt <fonte+8*11
 .byt <fonte+8*12
 .byt <fonte+8*13
 .byt <fonte+8*14
 .byt <fonte+8*15
 .byt <fonte+8*16
 .byt <fonte+8*17
 .byt <fonte+8*18
 .byt <fonte+8*19
 .byt <fonte+8*20	;52
 .byt <fonte+8*21
 .byt <fonte+8*22
 .byt <fonte+8*23
 .byt <fonte+8*24
 .byt <fonte+8*25
 .byt <fonte+8*26
 .byt <fonte+8*27
 .byt <fonte+8*28
 .byt <fonte+8*29
 .byt <fonte+8*30	;62
 .byt <fonte+8*31
 .byt <fonte+8*32
 .byt <fonte+8*33
 .byt <fonte+8*34
 .byt <fonte+8*35
 .byt <fonte+8*36
 .byt <fonte+8*37
 .byt <fonte+8*38
 .byt <fonte+8*39
 .byt <fonte+8*40	;72
 .byt <fonte+8*41
 .byt <fonte+8*42
 .byt <fonte+8*43
 .byt <fonte+8*44
 .byt <fonte+8*45
 .byt <fonte+8*46
 .byt <fonte+8*47
 .byt <fonte+8*48
 .byt <fonte+8*49
 .byt <fonte+8*50	;82
 .byt <fonte+8*51
 .byt <fonte+8*52
 .byt <fonte+8*53
 .byt <fonte+8*54
 .byt <fonte+8*55
 .byt <fonte+8*56
 .byt <fonte+8*57
 .byt <fonte+8*58
 .byt <fonte+8*59
 .byt <fonte+8*60	;92
 .byt <fonte+8*61
 .byt <fonte+8*62
 .byt <fonte+8*63
 .byt <fonte+8*64
 .byt <fonte+8*65
 .byt <fonte+8*66
 .byt <fonte+8*67
 .byt <fonte+8*68
 .byt <fonte+8*69
 .byt <fonte+8*70	;102
 .byt <fonte+8*71
 .byt <fonte+8*72
 .byt <fonte+8*73
 .byt <fonte+8*74
 .byt <fonte+8*75
 .byt <fonte+8*76
 .byt <fonte+8*77
 .byt <fonte+8*78
 .byt <fonte+8*79
 .byt <fonte+8*80	;112
 .byt <fonte+8*81
 .byt <fonte+8*82
 .byt <fonte+8*83
 .byt <fonte+8*84
 .byt <fonte+8*85
 .byt <fonte+8*86
 .byt <fonte+8*87
 .byt <fonte+8*88
 .byt <fonte+8*89
 .byt <fonte+8*90	;122
 .byt <fonte+8*91
 .byt <fonte+8*92
 .byt <fonte+8*93
 .byt <fonte+8*94
 .byt <fonte+8*95
CharacterAddressHi
 .byt >fonte	;32
 .byt >fonte+8*1
 .byt >fonte+8*2
 .byt >fonte+8*3
 .byt >fonte+8*4
 .byt >fonte+8*5
 .byt >fonte+8*6
 .byt >fonte+8*7
 .byt >fonte+8*8
 .byt >fonte+8*9
 .byt >fonte+8*10	;42
 .byt >fonte+8*11
 .byt >fonte+8*12
 .byt >fonte+8*13
 .byt >fonte+8*14
 .byt >fonte+8*15
 .byt >fonte+8*16
 .byt >fonte+8*17
 .byt >fonte+8*18
 .byt >fonte+8*19
 .byt >fonte+8*20	;52
 .byt >fonte+8*21
 .byt >fonte+8*22
 .byt >fonte+8*23
 .byt >fonte+8*24
 .byt >fonte+8*25
 .byt >fonte+8*26
 .byt >fonte+8*27
 .byt >fonte+8*28
 .byt >fonte+8*29
 .byt >fonte+8*30	;62
 .byt >fonte+8*31
 .byt >fonte+8*32
 .byt >fonte+8*33
 .byt >fonte+8*34
 .byt >fonte+8*35
 .byt >fonte+8*36
 .byt >fonte+8*37
 .byt >fonte+8*38
 .byt >fonte+8*39
 .byt >fonte+8*40	;72
 .byt >fonte+8*41
 .byt >fonte+8*42
 .byt >fonte+8*43
 .byt >fonte+8*44
 .byt >fonte+8*45
 .byt >fonte+8*46
 .byt >fonte+8*47
 .byt >fonte+8*48
 .byt >fonte+8*49
 .byt >fonte+8*50	;82
 .byt >fonte+8*51
 .byt >fonte+8*52
 .byt >fonte+8*53
 .byt >fonte+8*54
 .byt >fonte+8*55
 .byt >fonte+8*56
 .byt >fonte+8*57
 .byt >fonte+8*58
 .byt >fonte+8*59
 .byt >fonte+8*60	;92
 .byt >fonte+8*61
 .byt >fonte+8*62
 .byt >fonte+8*63
 .byt >fonte+8*64
 .byt >fonte+8*65
 .byt >fonte+8*66
 .byt >fonte+8*67
 .byt >fonte+8*68
 .byt >fonte+8*69
 .byt >fonte+8*70	;102
 .byt >fonte+8*71
 .byt >fonte+8*72
 .byt >fonte+8*73
 .byt >fonte+8*74
 .byt >fonte+8*75
 .byt >fonte+8*76
 .byt >fonte+8*77
 .byt >fonte+8*78
 .byt >fonte+8*79
 .byt >fonte+8*80	;112
 .byt >fonte+8*81
 .byt >fonte+8*82
 .byt >fonte+8*83
 .byt >fonte+8*84
 .byt >fonte+8*85
 .byt >fonte+8*86
 .byt >fonte+8*87
 .byt >fonte+8*88
 .byt >fonte+8*89
 .byt >fonte+8*90	;122
 .byt >fonte+8*91
 .byt >fonte+8*92
 .byt >fonte+8*93
 .byt >fonte+8*94
 .byt >fonte+8*95
CharacterWidth
 .byt 3	;32
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6 	;42
 .byt 6
 .byt 4
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;52
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;62
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;72
 .byt 5
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;82
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;92
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 5
 .byt 6
 .byt 6
 .byt 6	;102
 .byt 6
 .byt 6
 .byt 5
 .byt 6
 .byt 6
 .byt 4
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;112
 .byt 6
 .byt 5
 .byt 5
 .byt 5
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6	;122
 .byt 6
 .byt 6
 .byt 6
 .byt 6
 .byt 6
	
CharacterRightBuffer
 .dsb 8,0
CharacterLeftBuffer
 .dsb 8,0
HIRESBitOffset
 .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
 .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
 .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
 .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
HIRESXLoc
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39

	
	