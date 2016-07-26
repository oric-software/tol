;Glove code
;Simple Plot Glove at specified Y pos (Always central)

GloveX		.byt 13
GloveY		.byt 9
	
;B800 Glove Bitmap Temp(5x21)
;B869 Glove Mask(5x21)
;B8D2 -
;B900 Glove Mask Buffer(5x32)
;
PlotGloveAtXY
	;Calculate 'screen'
	jsr tn_main             ; Tobias
	rts
	
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
	sta $B900,x
	lda $b87e,y
	sta $B920,x
	lda $b893,y
	sta $B940,x
	lda $b8a8,y
	sta $B960,x
	lda $b8bd,y
	sta $B980,x

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
MaskVect	and $B900,y	;Mask with Glove mask
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
  rts ; Tobias
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
 
.dsb 256-(*&255)  ; Tobias - BMP is now pagealigned, MSK = BMP+128 
GloveBMPFrame0	;5x21 arranged as YxX
 .byt $40,$58,$5E,$4F,$43,$41,$40,$41,$43,$40,$42,$43,$40,$42,$43,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$60,$6F,$6F,$40,$60,$70,$5C,$45,$60,$50,$44,$76,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$70,$78,$7E,$5E,$7E,$7E,$78,$47,$5F,$7F,$7E,$5C,$40,$41,$41,$4F,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7C,$44,$44,$40,$60,$78,$70,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .dsb 23
 
GloveMSKFrame0
 .byt $47,$41,$40,$60,$70,$7C,$7E,$7C,$78,$7C,$78,$78,$7C,$78,$78,$7C,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$5F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$4F,$47,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$70
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$4F,$43,$41,$41,$41,$41,$43,$43,$47,$4F,$7F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .dsb 23 
  
GloveBMPFrame1
 .byt $40,$4C,$4F,$47,$41,$40,$40,$40,$41,$40,$41,$41,$40,$41,$41,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$70,$77,$77,$40,$70,$78,$4E,$42,$70,$48,$42,$7B,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$78,$7C,$5F,$4F,$5F,$5F,$7C,$43,$4F,$5F,$5F,$4E,$40,$40,$40,$47,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7E,$62,$42,$40,$50,$7C,$78,$60,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .dsb 23
 
GloveMSKFrame1
 .byt $63,$60,$60,$70,$78,$7E,$7F,$7E,$7C,$7E,$7C,$7C,$7E,$7C,$7C,$7E,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$4F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$7C,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$47,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$70,$78
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$5F,$5F,$5F,$5F,$47,$41,$40,$40,$40,$40,$41,$41,$43,$47,$5F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .dsb 23
  
GloveBMPFrame2
 .byt $40,$46,$47,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$60,$78,$7B,$5B,$40,$58,$7C,$47,$61,$78,$44,$61,$7D,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7C,$7E,$4F,$47,$4F,$4F,$5E,$41,$47,$4F,$6F,$47,$40,$40,$40,$43,$40
 .byt $40,$40,$40,$40,$40,$40,$60,$60,$60,$60,$40,$7C,$7F,$71,$61,$40,$48,$5E,$5C,$70,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .dsb 23
 
GloveMSKFrame2
 .byt $71,$70,$70,$78,$7C,$7F,$7F,$7F,$7E,$7F,$7E,$7E,$7F,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$5F,$47,$40,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7E,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$43,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$78,$7C
 .byt $7F,$7F,$7F,$7F,$7F,$5F,$4F,$4F,$4F,$4F,$43,$40,$40,$40,$40,$40,$40,$40,$41,$43,$4F
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$5F,$5F,$5F,$7F,$7F,$7F,$7F,$7F
 .dsb 23
 
GloveBMPFrame3
 .byt $40,$43,$43,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$70,$7C,$5D,$4D,$40,$4C,$5E,$43,$50,$5C,$42,$50,$5E,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7E,$7F,$47,$43,$47,$67,$6F,$40,$43,$67,$77,$43,$40,$40,$40,$41,$40
 .byt $40,$40,$40,$40,$40,$40,$70,$70,$70,$70,$40,$7E,$7F,$78,$70,$60,$44,$4F,$4E,$78,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$60,$60,$40,$40,$40,$40,$40,$40
 .dsb 23
 
GloveMSKFrame3
 .byt $78,$78,$78,$7C,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $7F,$4F,$43,$40,$40,$60,$70,$60,$40,$60,$40,$40,$60,$40,$40,$60,$78,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$78,$7C,$7E
 .byt $7F,$7F,$7F,$7F,$7F,$4F,$47,$47,$47,$47,$41,$40,$40,$40,$40,$40,$40,$40,$40,$41,$47
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$4F,$4F,$4F,$4F,$5F,$5F,$7F,$7F,$7F
 .dsb 23
 
GloveBMPFrame4
 .byt $40,$41,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$60,$78,$7E,$4E,$46,$40,$46,$4F,$41,$48,$4E,$41,$48,$4F,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$7F,$7F,$43,$41,$43,$73,$57,$40,$41,$53,$5B,$41,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$60,$78,$78,$78,$78,$60,$5F,$7F,$7C,$78,$70,$42,$47,$47,$7C,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$50,$50,$40,$40,$60,$40,$40,$40
 .dsb 23
 
GloveMSKFrame4
 .byt $7C,$7C,$7C,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $5F,$47,$41,$40,$40,$70,$78,$70,$60,$70,$60,$60,$70,$60,$60,$70,$7C,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$7C,$7E,$7F
 .byt $7F,$7F,$7F,$7F,$5F,$47,$43,$43,$43,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$43
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$4F,$47,$47,$47,$47,$4F,$4F,$5F,$7F,$7F
 .dsb 23
 
GloveBMPFrame5
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$70,$7C,$5F,$47,$43,$40,$43,$47,$40,$44,$47,$40,$44,$47,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$5F,$5F,$41,$40,$61,$79,$4B,$40,$60,$49,$6D,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$60,$70,$7C,$7C,$7C,$7C,$70,$4F,$7F,$7E,$7C,$78,$41,$43,$43,$5E,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$78,$48,$48,$40,$40,$70,$60,$40,$40
 .dsb 23
 
GloveMSKFrame5
 .byt $7E,$7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $4F,$43,$40,$40,$60,$78,$7C,$78,$70,$78,$70,$70,$78,$70,$70,$78,$7E,$7F,$7F,$7F,$7F
 .byt $7F,$7F,$7F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$7E,$7F,$7F
 .byt $7F,$7F,$7F,$5F,$4F,$43,$41,$41,$41,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$61
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$5F,$47,$43,$43,$43,$43,$47,$47,$4F,$5F,$7F
 .dsb 23
 
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
 
 
 
;--------------------------------------------------------------------------------------------------
; data
;--------------------------------------------------------------------------------------------------

GloveCX     .byt 0    ; position in characters
GloveCY     .byt 0
GlovePX     .byt 0    ; "subpixel" position
GlovePY     .byt 0

; pointers - these must be in zeropage
BGMAPPTR      = 254   ; word
TMPMAPPTR     = 252   ; word
SPRITEPTR     = 250   ; word
ZEICHENADR    = 248   ; word
BGZEICHENADR  = 246   ; word
CHARSET       = 244   ; word
TMPPTR        = 242   ; word

; these are in zeropage just for speed, could be moved 
BBMERKEN      = 240   ; byte
ZPTMP1        = 239   ; byte
BGZEICHEN     = 238   ; byte
ZEICHEN       = 237   ; byte
BYTEOFFSET    = 236   ; byte
LOOP_XX       = 235   ; byte
AKTLINE       = 234   ; byte
NEXTFREECHAR  = 233   ; byte

CHARSETCHAR     .byt 8




tn_backgroundok   .byt 0      ; 1 = we have the actual menuscreen stored both in bgscreendata and tmpscreendata 

.dsb 256-(*&255)
tn_bgscreendata   .dsb 512
tn_tmpscreendata  .dsb 512    ; 40x13, but only 25x13 are used, Glove doesn't move further to the right
 
 
MUL8LODATA
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  .byt 0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
  
MUL8HIDATA
  .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byt 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  .byt 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
  .byt 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
  .byt 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
  .byt 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
  .byt 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
  .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
  
DivideBy6
  .byt 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5
  .byt 5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10
  .byt 10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,14,14,14,14,14,14,15,15,15,15,15,15
  .byt 16,16,16,16,16,16,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,19,20,20,20,20,20,20,21,21
  .byt 21,21,21,21,22,22,22,22,22,22,23,23,23,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,26,26,26,26
  .byt 26,26,27,27,27,27,27,27,28,28,28,28,28,28,29,29,29,29,29,29,30,30,30,30,30,30,31,31,31,31,31,31
  .byt 32,32,32,32,32,32,33,33,33,33,33,33,34,34,34,34,34,34,35,35,35,35,35,35,36,36,36,36,36,36,37,37
  .byt 37,37,37,37,38,38,38,38,38,38,39,39,39,39,39,39,40,40,40,40,40,40,41,41,41,41,41,41,42,42,42,42  
  

  
;--------------------------------------------------------------------------------------------------
; main
;--------------------------------------------------------------------------------------------------  
tn_main    
  jsr tn_updatebuffers          ; if necessary, copy textscreen to bgscreendata and tmpscreendata 
  jsr tn_drawsprite             ; draws the Glove to tmpscreendata
  jsr tn_copytmpscreentofront   ; makes it visible
  jsr tn_restoretmpscreen       ; undo changes made to tmpscreen
  rts
  

;--------------------------------------------------------------------------------------------------
; copy StdChrTable to AltChrTable (char #32 - #97) - call it once at start
;--------------------------------------------------------------------------------------------------
tn_copychrtable
    .(
    ldy #8
loop_y      
    ldx #00
loop_x
sourc lda $b400+32*8,x
dest  sta $b800+32*8,x
    inx 
    cpx #66
    bne loop_x
    
    dey
    beq copyend
    
    lda sourc+1
    clc
    adc #66
    sta sourc+1
    lda sourc+2
    adc #00
    sta sourc+2
    
    lda dest+1
    clc
    adc #66
    sta dest+1
    lda dest+2
    adc #00
    sta dest+2
    
    jmp loop_y
    
copyend  
    .)  
    .(
    lda #97
    ldx #24
loop
    sta $bb80+28*40,x
    sta $bb80+29*40,x
    dex
    bne loop
    rts  
    .)
    
;--------------------------------------------------------------------------------------------------
; if necessary (new menu was drawn, tn_backgroundok == 0), copys textscreen to tn_bgscreendata and tn_tmpscreendata
;--------------------------------------------------------------------------------------------------
tn_updatebuffers
  .(    
  lda #01
  cmp tn_backgroundok
  bne weiter
  rts 
weiter
  sta tn_backgroundok ; set flag to 1
   
   
  lda #97     ; don't know why, but have to clear the first line (line 15)
  ldx #9
loop_d
  sta $bb80+15*40,x
  dex
  bne loop_d 
       
    
  ; copy 13 rows
  ldx #24 
loop
  lda $bb80+15*40,x:sta tn_bgscreendata+00*40,x:sta tn_tmpscreendata+00*40,x
  lda $bb80+16*40,x:sta tn_bgscreendata+01*40,x:sta tn_tmpscreendata+01*40,x
  lda $bb80+17*40,x:sta tn_bgscreendata+02*40,x:sta tn_tmpscreendata+02*40,x
  lda $bb80+18*40,x:sta tn_bgscreendata+03*40,x:sta tn_tmpscreendata+03*40,x
  lda $bb80+19*40,x:sta tn_bgscreendata+04*40,x:sta tn_tmpscreendata+04*40,x
  lda $bb80+20*40,x:sta tn_bgscreendata+05*40,x:sta tn_tmpscreendata+05*40,x
  lda $bb80+21*40,x:sta tn_bgscreendata+06*40,x:sta tn_tmpscreendata+06*40,x
  lda $bb80+22*40,x:sta tn_bgscreendata+07*40,x:sta tn_tmpscreendata+07*40,x
  lda $bb80+23*40,x:sta tn_bgscreendata+08*40,x:sta tn_tmpscreendata+08*40,x
  lda $bb80+24*40,x:sta tn_bgscreendata+09*40,x:sta tn_tmpscreendata+09*40,x
  lda $bb80+25*40,x:sta tn_bgscreendata+10*40,x:sta tn_tmpscreendata+10*40,x
  lda $bb80+26*40,x:sta tn_bgscreendata+11*40,x:sta tn_tmpscreendata+11*40,x
  lda $bb80+27*40,x:sta tn_bgscreendata+12*40,x:sta tn_tmpscreendata+12*40,x  
  dex
  bne loop               
  rts
  .)
 
 
;--------------------------------------------------------------------------------------------------
; draws the Glove to the tmpscreen 
;--------------------------------------------------------------------------------------------------
tn_drawsprite                                                
        ; calculate position in characters and "subpixel" 
        ldx GloveX
        lda DivideBy6,x
        sta GloveCX
        lda DivideBy6Remainder,x
        sta GlovePX
                                
        lda GloveY        
        lsr:lsr:lsr
        sta GloveCY        
        lda GloveY
        and #07        
        sta GlovePY 
                                        
        ; calculate offsets (cy*40+cx) in backbuffers (HGMAPPTR, BGMAPPTR)
        ldx GloveCY        
        lda ScreenOffsetLo,x
        clc
        adc GloveCX        
        sta BGMAPPTR
        sta TMPMAPPTR        
        lda ScreenOffsetHi,x
        adc #>tn_bgscreendata                
        sta BGMAPPTR+1
        clc
        adc #02
        sta TMPMAPPTR+1                
                                        
        ; SPRITEPTR
        lda #00
        sta SPRITEPTR
        lda #>GloveBMPFrame0
        clc
        adc GlovePX
        sta SPRITEPTR+1 
                                                               
        ; NEXTFREECHAR
        lda #98
        sta NEXTFREECHAR
                
        ; CHARSET
        .(
        lda CHARSETCHAR
        cmp #08 
        beq setalt
        
        dec CHARSETCHAR
        lda #$b4
        sta CHARSET+1
        
        jmp weiter  
setalt        
        inc CHARSETCHAR
        lda #$b8
        sta CHARSET+1
weiter
        lda #00
        sta CHARSET
        .)                                
                                                                               
          
        lda #$00           ; Byteoffset auf Null setzen
        sta BYTEOFFSET  
;----------------------------------------------------------------------------------  
; äussere Schleife (XX) in x zählen
        lda #5  ; 5 xxxxx                              
        sta LOOP_XX
loop_xx        
        lda #0
        sta AKTLINE
        
        
        ; innere Schleife (YY) in x zählen
        ldx #4 
        ;stx LOOP_YY       ; neu +3

        
loop_yy        
        ldy BYTEOFFSET
                 
;       Glove - we have only one sprite, so always draw on a fresh screen, no check needed        
;        lda (TMPMAPPTR),y       ;zeichen = tmpmap[spritey1+yy][spritex1+xx];
;        cmp #98                 
;        bcc neueszeichen        ;if (zeichen < 64) // neues nehmen
        
;          sta BGZEICHEN
;          sta ZEICHEN
;          jmp weiter2          
;neueszeichen
          
          lda NEXTFREECHAR
          inc NEXTFREECHAR
          sta ZEICHEN             ; brauch ich das überhaupt noch?
          sta (TMPMAPPTR),y
                              
          lda (BGMAPPTR),y
          sta BGZEICHEN
weiter2
        ; ZEICHEN und HGZEICHEN enthalten jetzt korrekte Werte    
        
                  
        
        ; rts    
; mittlerer Abschnitt            
        ; zeichen = peek(ZEICHEN);
        ; hgzeichen = peek(HGZEICHEN);
        
        ; zeichenadr = STDCHRTABLE+zeichen*8+charset;
        ; hgzeichenadr = STDCHRTABLE+hgzeichen*8+charset;        
        
        ; doke(HGZEICHENADR, hgzeichenadr);
        ; doke(ZEICHENADR, zeichenadr);     

        clc                   ; +2
        ldy ZEICHEN        
        lda MUL8LODATA,y         
        ;adc CHARSET          ; Lobyte immer Null
        sta ZEICHENADR        
        lda MUL8HIDATA,y        
        adc CHARSET+1
        sta ZEICHENADR+1

        ldy BGZEICHEN        
        lda MUL8LODATA,y                           
        sta BGZEICHENADR        
        lda MUL8HIDATA,y        
        adc CHARSET+1
        sta BGZEICHENADR+1
        
                
        ldy #0  ; y zählt von 0-7 die Zeilen runter
naechstezeile      
      lda (BGZEICHENADR),y
      sta BBMERKEN   ; aktuelles bb (a) merken       
      
      lda AKTLINE   ; if ((aktline>=ystart)&&(aktline<(ystart+21)))
      sbc GlovePY
      bmi weiter
      sbc #21   ; #16
      bpl weiter
                
        sty ZPTMP1    ; aktuellen Byteoffset merken
        lda BBMERKEN ;  txa OPT
        ldy #128         ; war 64 - Offset Maske
        and (SPRITEPTR),y
        ldy #0       
        ora (SPRITEPTR),y
        inc SPRITEPTR       ;  highbyte evtl. auch nötig        
einweiter
        sta BBMERKEN  ; tax
        ldy ZPTMP1      ; aktuellen Byteoffset wieder herstellen
weiter
      lda BBMERKEN   ; txa OPT   ; bb ggf. wiederherstellen      
      sta (ZEICHENADR),y
      inc AKTLINE 
            
      iny
      cpy #8
      bne naechstezeile      
                                           
      clc                 ; BYTEOFFSET y+1 
      lda BYTEOFFSET      ; 3 T
      adc #40             ; 2 T    
      sta BYTEOFFSET      ; 3 T            

      ; inner loop (YY)        
      dex      
      bne loop_yy  
          
          
      ; outer loop (XX)
      sec
      lda BYTEOFFSET      
      sbc #159         ; 4*40-1        
      sta BYTEOFFSET
                             
      dec LOOP_XX            
      beq weiter3
      jmp loop_xx
weiter3            
      rts
      
      
      
;--------------------------------------------------------------------------------------------------
; make changes visible
;--------------------------------------------------------------------------------------------------
tn_copytmpscreentofront               
      .(
      lda GloveCX
      
      cmp #02
      bmi nodec
      
      sec
      sbc #01
      sta startx+1            
      clc
      adc #01 
nodec                              
      clc
      adc #06
      sta endx+1
      
      ldy GloveCY               
      cpy #00
      beq weiter_x
      dey
      jsr kopierezeile
      iny
weiter_x
                        
      jsr kopierezeile
      iny
      jsr kopierezeile
      iny
      jsr kopierezeile
      iny
      jsr kopierezeile
      iny
      jsr kopierezeile     
      rts
      
      
kopierezeile      
      
      cpy #12
      bpl copyend       ; = rts from kopierezeile
      
      lda ScreenOffsetLo,y
      clc
      adc #<$bb80+15*40
      sta dest1+1
      sta dest2+1
      lda ScreenOffsetHi,y
      adc #>$bb80+15*40
      sta dest1+2
      sta dest2+2
      
      lda ScreenOffsetLo,y
      clc
      adc #<tn_tmpscreendata
      sta sourc+1
      lda ScreenOffsetHi,y
      adc #>tn_tmpscreendata
      sta sourc+2
            
      lda CHARSETCHAR
dest1 sta $ffff
startx ldx #1
loop      
sourc lda $ffff,x
dest2 sta $ffff,x
      inx
endx  cpx #23
      bne loop
copyend
      rts
      .)
      
      
                        
;--------------------------------------------------------------------------------------------------
; restore tmpscreen 
;--------------------------------------------------------------------------------------------------      
tn_restoretmpscreen
      .(
      lda GloveCX
      sta startx+1
      clc
      adc #5
      sta endx+1
      
      ldy GloveCY                                             
      jsr kopierezeile2
      iny
      jsr kopierezeile2
      iny
      jsr kopierezeile2
      iny
      jsr kopierezeile2                
      rts      
      
kopierezeile2      
      
      cpy #12
      bpl copyend       ; = rts from kopierezeile2
      
      lda ScreenOffsetLo,y
      clc
      adc #<tn_tmpscreendata      
      sta dest2+1
      lda ScreenOffsetHi,y
      adc #>tn_tmpscreendata
      sta dest2+2
      
      lda ScreenOffsetLo,y
      clc
      adc #<tn_bgscreendata
      sta sourc+1
      lda ScreenOffsetHi,y
      adc #>tn_bgscreendata
      sta sourc+2
            
startx ldx #1
loop      
sourc lda $ffff,x
dest2 sta $ffff,x
      inx
endx  cpx #23
      bne loop
copyend
      rts
      .)
      
      
      
      


          
              
              
              
              