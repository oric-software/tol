;Test routine to display X/Y coordinates in text window when player presses RETURN key



;Form text line (20 wide) then messageaddress2window
testxy_code
	lda hero_xl
	sta testxy_templ
	lda hero_xh
	sta testxy_temph
	ldy #3
	jsr testxy_display_decimal
	lda hero_yl
	sta testxy_templ
	lda hero_yh
	sta testxy_temph
	ldy #12
	jsr testxy_display_decimal
	lda #<testxy_text
	sta zero_00
	lda #>testxy_text
	sta zero_01
	jmp messageaddress2window


testxy_display_decimal
	ldx #47
	sec
.(
loop1	inx
	lda testxy_templ
	sbc #<10000
	sta testxy_templ
	lda testxy_temph
	sbc #>10000
	sta testxy_temph
	bcs loop1
	lda testxy_templ
	adc #<10000
	sta testxy_templ
	lda testxy_temph
	adc #>10000
	sta testxy_temph
.)
	txa
	sta testxy_text,y
	iny
.(
	ldx #47
	sec
loop1	inx
	lda testxy_templ
	sbc #<1000
	sta testxy_templ
	lda testxy_temph
	sbc #>1000
	sta testxy_temph
	bcs loop1
	lda testxy_templ
	adc #<1000
	sta testxy_templ
	lda testxy_temph
	adc #>1000
	sta testxy_temph
.)
	txa
	sta testxy_text,y
	iny
.(
	ldx #47
	sec
loop1	inx
	lda testxy_templ
	sbc #100
	sta testxy_templ
	lda testxy_temph
	sbc #0
	sta testxy_temph
	bcs loop1
	lda testxy_templ
	adc #100
	sta testxy_templ
	lda testxy_temph
	adc #0
	sta testxy_temph
.)
	txa
	sta testxy_text,y
	iny
.(
	ldx #47
	sec
loop1	inx
	lda testxy_templ
	sbc #10
	sta testxy_templ
	bcs loop1
	adc #58
	sta testxy_text+1,y
	txa
	sta testxy_text,y
	rts

.)


testxy_text
 .byt " X xxxxx  Y xxxxx",255
testxy_templ	.byt 0
testxy_temph	.byt 0
