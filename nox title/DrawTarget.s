;              1
              1
;1 1 1 1 1 1 1 1
; 1 1 1 1 1 1 1
               1
              1
               1
              1
               1
              1
TargetX	.byt 20	;0-39
TargetY	.byt 30	;0-59
InvertTarget
	ldy TargetY
	lda TargetScreenYLOCL,y
	sta screen
	lda TargetScreenYLOCH,y
	sta screen+1
	ldy #39
	sty EvenRow
	ldy #79
	sty OddRow
.(	
loop1	ldy OddRow
	lda (screen),y
	eor #%101010
	sta (screen),y
	ldy EvenRow
	lda (screen),y
	eor #%010101
	sta (screen),y
	dec OddRow
	dec EvenRow
	bne loop1
.)
	lda #<$A028
	sta screen
	lda #>$A028
	sta screen+1
	lda TargetX
	clc
	adc #40
	sta TargetXOddRow
	ldx #58
.(	
loop1	ldy TargetX
	lda (screen),y
	eor #%001000
	sta (screen),y
	ldy TargetXOddRow
	lda (screen),y
	eor #%000100
	sta (screen),y
	
	lda screen
	adc #80
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bpl loop1
.)
	rts
	
TargetScreenYLOCL
 .byt <$A028
 .byt <$A028+80*1
 .byt <$A028+80*2
 .byt <$A028+80*3
 .byt <$A028+80*4
 .byt <$A028+80*5
 .byt <$A028+80*6
 .byt <$A028+80*7
 .byt <$A028+80*8
 .byt <$A028+80*9
 .byt <$A028+80*10
 .byt <$A028+80*11
 .byt <$A028+80*12
 .byt <$A028+80*13
 .byt <$A028+80*14
 .byt <$A028+80*15
 .byt <$A028+80*16
 .byt <$A028+80*17
 .byt <$A028+80*18
 .byt <$A028+80*19
 .byt <$A028+80*20
 .byt <$A028+80*21
 .byt <$A028+80*22
 .byt <$A028+80*23
 .byt <$A028+80*24
 .byt <$A028+80*25
 .byt <$A028+80*26
 .byt <$A028+80*27
 .byt <$A028+80*28
 .byt <$A028+80*29
 .byt <$A028+80*30
 .byt <$A028+80*31
 .byt <$A028+80*32
 .byt <$A028+80*33
 .byt <$A028+80*34
 .byt <$A028+80*35
 .byt <$A028+80*36
 .byt <$A028+80*37
 .byt <$A028+80*38
 .byt <$A028+80*39
 .byt <$A028+80*40
 .byt <$A028+80*41
 .byt <$A028+80*42
 .byt <$A028+80*43
 .byt <$A028+80*44
 .byt <$A028+80*45
 .byt <$A028+80*46
 .byt <$A028+80*47
 .byt <$A028+80*48
 .byt <$A028+80*49
 .byt <$A028+80*50
 .byt <$A028+80*51
 .byt <$A028+80*52
 .byt <$A028+80*53
 .byt <$A028+80*54
 .byt <$A028+80*55
 .byt <$A028+80*56
 .byt <$A028+80*57
 .byt <$A028+80*58
 .byt <$A028+80*59

TargetScreenYLOCH
 .byt >$A028
 .byt >$A028+80*1
 .byt >$A028+80*2
 .byt >$A028+80*3
 .byt >$A028+80*4
 .byt >$A028+80*5
 .byt >$A028+80*6
 .byt >$A028+80*7
 .byt >$A028+80*8
 .byt >$A028+80*9
 .byt >$A028+80*10
 .byt >$A028+80*11
 .byt >$A028+80*12
 .byt >$A028+80*13
 .byt >$A028+80*14
 .byt >$A028+80*15
 .byt >$A028+80*16
 .byt >$A028+80*17
 .byt >$A028+80*18
 .byt >$A028+80*19
 .byt >$A028+80*20
 .byt >$A028+80*21
 .byt >$A028+80*22
 .byt >$A028+80*23
 .byt >$A028+80*24
 .byt >$A028+80*25
 .byt >$A028+80*26
 .byt >$A028+80*27
 .byt >$A028+80*28
 .byt >$A028+80*29
 .byt >$A028+80*30
 .byt >$A028+80*31
 .byt >$A028+80*32
 .byt >$A028+80*33
 .byt >$A028+80*34
 .byt >$A028+80*35
 .byt >$A028+80*36
 .byt >$A028+80*37
 .byt >$A028+80*38
 .byt >$A028+80*39
 .byt >$A028+80*40
 .byt >$A028+80*41
 .byt >$A028+80*42
 .byt >$A028+80*43
 .byt >$A028+80*44
 .byt >$A028+80*45
 .byt >$A028+80*46
 .byt >$A028+80*47
 .byt >$A028+80*48
 .byt >$A028+80*49
 .byt >$A028+80*50
 .byt >$A028+80*51
 .byt >$A028+80*52
 .byt >$A028+80*53
 .byt >$A028+80*54
 .byt >$A028+80*55
 .byt >$A028+80*56
 .byt >$A028+80*57
 .byt >$A028+80*58
 .byt >$A028+80*59


	
	