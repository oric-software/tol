;Glove code
;Simple Plot Glove at specified Y pos (Always central)

GloveX		.byt 13
GloveY		.byt 9
	
;B800 Glove Bitmap Temp(5x21)
;B869 Glove Mask(5x21)
;B8D2 -
;BC00 Glove Mask Buffer(5x32)
;
PlotGloveAtXY
	;Calculate 'screen'
	ldx GloveX
	ldy GloveY
	lda ScreenXLOC,x
	clc
	adc ScreenYLOCL,y
	sta GloveScreen
	lda ScreenYLOCH,y
	adc #00
	sta GloveScreen+1
	;Transfer Glove X Frame(5x21) to Absolute location(B800,B820..) to ease next step
	ldy GloveX
	ldx DivideBy6Remainder,y
	;x=0-5
	lda GloveBMPFrameLo,x
.(
	sta vector1+1
	lda GloveBMPFrameHi,x
	sta vector1+2
	lda GloveMSKFrameLo,x
	sta vector2+1
	lda GloveMSKFrameHi,x
	sta vector2+2
	ldy #104
loop1
vector1	lda $dead,y
	sta $B800,y
vector2	lda $dead,y
	sta $B869,y
	dey
	bpl loop1
.)	
 	;Plot Glove frame within Character Block
	ldx #160
.(
loop1	lda #00
	sta $B70F,x
	lda #127
	sta $B8FF,x
	dex
	bne loop1
.)
	ldy GloveY
	ldx VerticalcharacterOffset,y
	ldy #00
.(
loop1	;Transfer Bitmap Graphic
	lda $b800,y
	sta $b710,x
	lda $b815,y	;$b800+21*1
	sta $b730,x
	lda $B82A,y	;$B800+21*2
	sta $b750,x
	lda $B83F,y	;$B800+21*3
	sta $b770,x
	lda $B854,y	;$B800+21*4
	sta $b790,x
	
	;Transfer Mask Graphic to Mask Buffer location(same size as Character block)
	lda $b869,y
	sta $BC00,x
	lda $b87e,y
	sta $BC20,x
	lda $b893,y
	sta $BC40,x
	lda $b8a8,y
	sta $BC60,x
	lda $b8bd,y
	sta $BC80,x

	inx
	iny
	cpy #21
	bcc loop1
.)
	
	;Mask Character block with Background using the Mask Buffer
	ldx #19
	;Use table to fetch each Character Offset
.(
loop1	lda UnderlyingCharacter,x
	ldy BackgroundRestoredFlag
	beq skip3
	ldy TextGloveBlockOffset,x
	lda (GloveScreen),y
	sta UnderlyingCharacter,x

skip3	cmp #32
	bcs skip1
	
	;Use Space if Attribute
	lda #<SpaceChar
	sta bgchar+1
	lda #>SpaceChar
	sta bgchar+2
	jmp skip2
	
skip1	;If not attribute fetch Character address
	tay
	lda CharacterAddressLo-32,y
	sta bgchar+1
	lda CharacterAddressHi-32,y
	sta bgchar+2
	
skip2	lda CharacterOffsetWithinGloveMaskdef,x
	sta MaskVect+1
	lda CharacterOffsetWithinGloveChardef,x
	sta BmpVect1+1
	sta BmpVect2+1
	
	ldy #7
bgchar	lda $DEAD,y	;Fetch Background definition
MaskVect	and $BC00,y	;Mask with Glove mask
BmpVect1	ora $B700,y	;Combine with Glove Bitmap
BmpVect2	sta $B700,y	;Store back into Glove bitmap
	dey
	bpl bgchar
	
	;Now plot Glove character
	lda GloveCharacter,x
	ldy TextGloveBlockOffset,x
	sta (GloveScreen),y
	
	dex
	bpl loop1
.)	
	rts

RestoreGloveBackground
	ldx #19
.(
loop1	ldy TextGloveBlockOffset,x
	lda UnderlyingCharacter,x
	sta (OldGloveScreen),y
	dex
	bpl loop1
.)
	rts

CharacterAddressLo
 .byt <$B400+8*32
 .byt <$B400+8*33
 .byt <$B400+8*34
 .byt <$B400+8*35
 .byt <$B400+8*36
 .byt <$B400+8*37
 .byt <$B400+8*38
 .byt <$B400+8*39
 .byt <$B400+8*40
 .byt <$B400+8*41
 .byt <$B400+8*42
 .byt <$B400+8*43
 .byt <$B400+8*44
 .byt <$B400+8*45
 .byt <$B400+8*46
 .byt <$B400+8*47
 .byt <$B400+8*48
 .byt <$B400+8*49
 .byt <$B400+8*50
 .byt <$B400+8*51
 .byt <$B400+8*52
 .byt <$B400+8*53
 .byt <$B400+8*54
 .byt <$B400+8*55
 .byt <$B400+8*56
 .byt <$B400+8*57
 .byt <$B400+8*58
 .byt <$B400+8*59
 .byt <$B400+8*60
 .byt <$B400+8*61
 .byt <$B400+8*62
 .byt <$B400+8*63
 .byt <$B400+8*64
 .byt <$B400+8*65
 .byt <$B400+8*66
 .byt <$B400+8*67
 .byt <$B400+8*68
 .byt <$B400+8*69
 .byt <$B400+8*70
 .byt <$B400+8*71
 .byt <$B400+8*72
 .byt <$B400+8*73
 .byt <$B400+8*74
 .byt <$B400+8*75
 .byt <$B400+8*76
 .byt <$B400+8*77
 .byt <$B400+8*78
 .byt <$B400+8*79
 .byt <$B400+8*80
 .byt <$B400+8*81
 .byt <$B400+8*82
 .byt <$B400+8*83
 .byt <$B400+8*84
 .byt <$B400+8*85
 .byt <$B400+8*86
 .byt <$B400+8*87
 .byt <$B400+8*88
 .byt <$B400+8*89
 .byt <$B400+8*90
 .byt <$B400+8*91
 .byt <$B400+8*92
 .byt <$B400+8*93
 .byt <$B400+8*94
 .byt <$B400+8*95
 .byt <$B400+8*96
 .byt <$B400+8*97
CharacterAddressHi
 .byt >$B400+8*32
 .byt >$B400+8*33
 .byt >$B400+8*34
 .byt >$B400+8*35
 .byt >$B400+8*36
 .byt >$B400+8*37
 .byt >$B400+8*38
 .byt >$B400+8*39
 .byt >$B400+8*40
 .byt >$B400+8*41
 .byt >$B400+8*42
 .byt >$B400+8*43
 .byt >$B400+8*44
 .byt >$B400+8*45
 .byt >$B400+8*46
 .byt >$B400+8*47
 .byt >$B400+8*48
 .byt >$B400+8*49
 .byt >$B400+8*50
 .byt >$B400+8*51
 .byt >$B400+8*52
 .byt >$B400+8*53
 .byt >$B400+8*54
 .byt >$B400+8*55
 .byt >$B400+8*56
 .byt >$B400+8*57
 .byt >$B400+8*58
 .byt >$B400+8*59
 .byt >$B400+8*60
 .byt >$B400+8*61
 .byt >$B400+8*62
 .byt >$B400+8*63
 .byt >$B400+8*64
 .byt >$B400+8*65
 .byt >$B400+8*66
 .byt >$B400+8*67
 .byt >$B400+8*68
 .byt >$B400+8*69
 .byt >$B400+8*70
 .byt >$B400+8*71
 .byt >$B400+8*72
 .byt >$B400+8*73
 .byt >$B400+8*74
 .byt >$B400+8*75
 .byt >$B400+8*76
 .byt >$B400+8*77
 .byt >$B400+8*78
 .byt >$B400+8*79
 .byt >$B400+8*80
 .byt >$B400+8*81
 .byt >$B400+8*82
 .byt >$B400+8*83
 .byt >$B400+8*84
 .byt >$B400+8*85
 .byt >$B400+8*86
 .byt >$B400+8*87
 .byt >$B400+8*88
 .byt >$B400+8*89
 .byt >$B400+8*90
 .byt >$B400+8*91
 .byt >$B400+8*92
 .byt >$B400+8*93
 .byt >$B400+8*94
 .byt >$B400+8*95
 .byt >$B400+8*96
 .byt >$B400+8*97

DivideBy6Remainder	;But can be alot shorter if we confine glove to left side
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5

VerticalcharacterOffset
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7
 .byt 0,1,2,3,4,5,6,7

GloveBMPFrameLo
 .byt <GloveBMPFrame0
 .byt <GloveBMPFrame1
 .byt <GloveBMPFrame2
 .byt <GloveBMPFrame3
 .byt <GloveBMPFrame4
 .byt <GloveBMPFrame5
GloveBMPFrameHi
 .byt >GloveBMPFrame0
 .byt >GloveBMPFrame1
 .byt >GloveBMPFrame2
 .byt >GloveBMPFrame3
 .byt >GloveBMPFrame4
 .byt >GloveBMPFrame5
GloveMSKFrameLo
 .byt <GloveMSKFrame0
 .byt <GloveMSKFrame1
 .byt <GloveMSKFrame2
 .byt <GloveMSKFrame3
 .byt <GloveMSKFrame4
 .byt <GloveMSKFrame5
GloveMSKFrameHi
 .byt >GloveMSKFrame0
 .byt >GloveMSKFrame1
 .byt >GloveMSKFrame2
 .byt >GloveMSKFrame3
 .byt >GloveMSKFrame4
 .byt >GloveMSKFrame5
GloveBMPFrame0	;5x21 arranged as YxX
 .byt $40,$58,$5E,$4F,$43,$41,$40,$41,$43,$40,$42,$43,$40,$42,$43,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$60,$6F,$6F,$40,$60,$70,$5C,$45,$60,$50,$44,$76,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$70,$78,$7E,$5E,$7E,$7E,$78,$47,$5F,$7F,$7E,$5C,$40,$41,$41,$4F,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7C,$44,$44,$40,$60,$78,$70,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 
GloveBMPFrame1
 .byt $40,$4C,$4F,$47,$41,$40,$40,$40,$41,$40,$41,$41,$40,$41,$41,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$70,$77,$77,$40,$70,$78,$4E,$42,$70,$48,$42,$7B,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$78,$7C,$5F,$4F,$5F,$5F,$7C,$43,$4F,$5F,$5F,$4E,$40,$40,$40,$47,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7E,$62,$42,$40,$50,$7C,$78,$60,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 
GloveBMPFrame2
 .byt $40,$46,$47,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$60,$78,$7B,$5B,$40,$58,$7C,$47,$61,$78,$44,$61,$7D,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7C,$7E,$4F,$47,$4F,$4F,$5E,$41,$47,$4F,$6F,$47,$40,$40,$40,$43,$40
 .byt $40,$40,$40,$40,$40,$40,$60,$60,$60,$60,$40,$7C,$7F,$71,$61,$40,$48,$5E,$5C,$70,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

GloveBMPFrame3
 .byt $40,$43,$43,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$70,$7C,$5D,$4D,$40,$4C,$5E,$43,$50,$5C,$42,$50,$5E,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7E,$7F,$47,$43,$47,$67,$6F,$40,$43,$67,$77,$43,$40,$40,$40,$41,$40
 .byt $40,$40,$40,$40,$40,$40,$70,$70,$70,$70,$40,$7E,$7F,$78,$70,$60,$44,$4F,$4E,$78,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$60,$60,$40,$40,$40,$40,$40,$40

GloveBMPFrame4
 .byt $40,$41,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$60,$78,$7E,$4E,$46,$40,$46,$4F,$41,$48,$4E,$41,$48,$4F,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7F,$7F,$43,$41,$43,$73,$57,$40,$41,$53,$5B,$41,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$60,$78,$78,$78,$78,$60,$5F,$7F,$7C,$78,$70,$42,$47,$47,$7C,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$50,$50,$40,$40,$60,$40,$40,$40

GloveBMPFrame5
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$70,$7C,$5F,$47,$43,$40,$43,$47,$40,$44,$47,$40,$44,$47,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$5F,$5F,$41,$40,$61,$79,$4B,$40,$60,$49,$6D,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$60,$70,$7C,$7C,$7C,$7C,$70,$4F,$7F,$7E,$7C,$78,$41,$43,$43,$5E,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$78,$48,$48,$40,$40,$70,$60,$40,$40

GloveMSKFrame0
 .byt $47,$41,$40,$60,$70,$7C,$7E,$7C,$78,$7C,$78,$78,$7C,$78,$78,$7C,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$5F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$4F,$47,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$70
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$4F,$43,$41,$41,$41,$41,$43,$43,$47,$4F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F

GloveMSKFrame1
 .byt $63,$60,$60,$70,$78,$7E,$7F,$7E,$7C,$7E,$7C,$7C,$7E,$7C,$7C,$7E,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$4F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$7C,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$47,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$70,$78
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$5F,$5F,$5F,$5F,$47,$41,$40,$40,$40,$40,$41,$41,$43,$47,$5F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F

GloveMSKFrame2
 .byt $71,$70,$70,$78,$7C,$7F,$7F,$7F,$7E,$7F,$7E,$7E,$7F,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$5F,$47,$40,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7E,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$43,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$78,$7C
 .byt $7F,$7F,$7F,$7F,$7F,$5F,$4F,$4F,$4F,$4F,$43,$40,$40,$40,$40,$40,$40,$40,$41,$43,$4F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$5F,$5F,$5F,$7F,$7F,$7F,$7F,$7F

GloveMSKFrame3
 .byt $78,$78,$78,$7C,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$4F,$43,$40,$40,$60,$70,$60,$40,$60,$40,$40,$60,$40,$40,$60,$78,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7C,$7E
 .byt $7F,$7F,$7F,$7F,$7F,$4F,$47,$47,$47,$47,$41,$40,$40,$40,$40,$40,$40,$40,$40,$41,$47
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$4F,$4F,$4F,$4F,$5F,$5F,$7F,$7F,$7F

GloveMSKFrame4
 .byt $7C,$7C,$7C,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $5F,$47,$41,$40,$40,$70,$78,$70,$60,$70,$60,$60,$70,$60,$60,$70,$7C,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$7C,$7E,$7F
 .byt $7F,$7F,$7F,$7F,$5F,$47,$43,$43,$43,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$43
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$4F,$47,$47,$47,$47,$4F,$4F,$5F,$7F,$7F

GloveMSKFrame5
 .byt $7E,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $4F,$43,$40,$40,$60,$78,$7C,$78,$70,$78,$70,$70,$78,$70,$70,$78,$7E,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7E,$7F,$7F
 .byt $7F,$7F,$7F,$5F,$4F,$43,$41,$41,$41,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$61
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$47,$43,$43,$43,$43,$47,$47,$4F,$5F,$7F

TextGloveBlockOffset
 .byt 0,1,2,3,4
 .byt 40,41,42,43,44
 .byt 80,81,82,83,84
 .byt 120,121,122,123,124
CharacterOffsetWithinGloveMaskdef
 .byt 0,32,64,96,128
 .byt 8,40,72,104,136
 .byt 16,48,80,112,144
 .byt 24,56,88,120,152
CharacterOffsetWithinGloveChardef
 .byt 0+16,32+16,64+16,96+16,128+16
 .byt 8+16,40+16,72+16,104+16,136+16
 .byt 16+16,48+16,80+16,112+16,144+16
 .byt 24+16,56+16,88+16,120+16,152+16
SpaceChar
 .dsb 8,0
UnderlyingCharacter
 .dsb 20,8
GloveCharacter
 .byt 98,102,106,110,114
 .byt 99,103,107,111,115
 .byt 100,104,108,112,116
 .byt 101,105,109,113,117
ScreenXLOC	;Can be shorter if glove on left only
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
ScreenYLOCL	;Start only in text area at bottom
 .dsb 8,<$BB80+40*15
 .dsb 8,<$BB80+40*16
 .dsb 8,<$BB80+40*17
 .dsb 8,<$BB80+40*18
 .dsb 8,<$BB80+40*19
 .dsb 8,<$BB80+40*20
 .dsb 8,<$BB80+40*21
 .dsb 8,<$BB80+40*22
 .dsb 8,<$BB80+40*23
 .dsb 8,<$BB80+40*24
 .dsb 8,<$BB80+40*25
 .dsb 8,<$BB80+40*26
 .dsb 8,<$BB80+40*27
ScreenYLOCH	;Start only in text area at bottom
 .dsb 8,>$BB80+40*15
 .dsb 8,>$BB80+40*16
 .dsb 8,>$BB80+40*17
 .dsb 8,>$BB80+40*18
 .dsb 8,>$BB80+40*19
 .dsb 8,>$BB80+40*20
 .dsb 8,>$BB80+40*21
 .dsb 8,>$BB80+40*22
 .dsb 8,>$BB80+40*23
 .dsb 8,>$BB80+40*24
 .dsb 8,>$BB80+40*25
 .dsb 8,>$BB80+40*26
 .dsb 8,>$BB80+40*27
