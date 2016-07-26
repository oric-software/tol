shift_areas
	ldx #05
	lda area_active,x
	bmi
	ldy area_ypos,x
	lda ylocl_bg,y
	sta $10
	lda yloch_bg,y
	sta $11
	ldy area_xpos,x
	lda ($10),y

;the problem is that when ab moves into c, bc is occupied.
;we need to rearrange the character definitions to return
;to abc for the next scroll.
;so...
;a.
;b.
;c.
;scroll ab to bc
;unplot a
;(Move down)
;(bc)
;copy b to a
;plot a where b was
;copy c to b
;plot b where c was
;erase c
;plot c below ab
reposition_south
	;unplot a


scroll6_continue_east
	jsr scroll_bmp_east
	jsr scroll_msk_east
	jsr merge_gfx
	dec x_count
	bne
	inc scroll_completed
	rts

scroll_bmp_east
	lda #
;To do...
;allow setting of scroll buffer loc
;cycles calculated
buffer_loc_lo	.byt $00
buffer_loc_hi	.byt $00

smooth_scroll_block_nX1	;based on 2*3(24)
	lda buffer_loc_lo
	ldx buffer_loc_hi
	sta $10
	stx $11
	sta ssbnx1_02+1
	stx ssbnx1_02+2
	clc
	adc #01
	sta ssbnx1_01+1
	bcc ssbnx1_03
	inx
ssbnx1_03	stx ssbnx1_01+2
	ldx #00	;34
ssbnx1_01	lda $bf00,x	;scroll_buffer+1,x
ssbnx1_02	sta $bf00,x	;scroll_buffer+0,x
	inx
	cpx #47
	bcc ssbnx1_01
	ldy #23
	lda #00
	sta ($10),y
	ldy #47
	sta ($10),y
	rts	;808 Cycles

smooth_scroll_block_sX1	;based on 2*3(24)
	lda buffer_loc_lo
	ldx buffer_loc_hi
	sta $10
	stx $11
	sta ssbsx1_02+1
	stx ssbsx1_02+2
	clc
	adc #01
	sta ssbsx1_01+1
	bcc ssbsx1_03
	inx
ssbsx1_03	stx ssbsx1_01+2
	ldx #46	;+34
ssbsx1_01	lda $bf00,x
ssbsx1_02	sta $bf00,x
	dex
	bpl ssdsx1_01
	ldy #00
	tya
	sta ($10),y
	ldy #24
	sta ($10),y
	rts	;714 Cycles

smooth_scroll_block_wX1	;based on 3*2(16)
	lda buffer_loc_lo
	ldx buffer_loc_hi
	sta ssbwx1_01+1
	clc
	adc #16
	sta ssbwx1_02+1
	sta ssbwx1_03+1
	stx ssbwx1_01+2
	bcc ssbwx1_06
	inx
	clc
ssbwx1_06	stx ssbwx1_02+2
	stx ssbwx1_03+2
	adc #16
	sta ssbwx1_04+1
	sta ssbwx1_05+1
	bcc ssbwx1_07
	inx
ssbwx1_07	stx ssbwx1_04+2
	stx ssbwx1_05+2
	ldx #15	;+66
ssbwx1_04	lda $bf00,x	;scroll_buffer+24,x
	asl
	and #%01111111
	cmp #%01000000
ssbwx1_05	sta $bf00,x			;scroll_buffer+24,x
ssbwx1_02	lda $bf00,x			;scroll_buffer+12,x
	rol
	and #%01111111
	cmp #%01000000
ssbwx1_03	sta $bf00,x			;scroll_buffer+12,x
ssbwx1_01	rol $bf00,x			;scroll_buffer,x
	dex
	bpl ssbwx1_04
	;extend by
	rts	;722 cycles

smooth_scroll_block_eX1	;based on 3*2(16)
	lda buffer_loc_lo
	ldx buffer_loc_hi
	sta ssbex1_01+1
	clc
	adc #16
	sta ssbex1_02+1
	sta ssbex1_03+1
	stx ssbex1_01+2
	bcc ssbex1_06
	inx
	clc
ssbex1_06	stx ssbex1_02+2
	stx ssbex1_03+2
	adc #16
	sta ssbex1_04+1
	sta ssbex1_05+1
	bcc ssbex1_07
	inx
ssbex1_07	stx ssbex1_04+2
	stx ssbex1_05+2
	ldx #15	  	;+66
ssbex1_01	lsr $bf00,x		;scroll_buffer,x
ssbex1_02	lda $bf00,x		;scroll_buffer+12,x
	and #%00111111
	bcc ssbex1_08
	ora #64
ssbex1_08	lsr
ssbex1_03	sta $bf00,x		;scroll_buffer+12,x
ssbex1_04	lda $bf00,x		;scroll_buffer+24,x
	and #%00111111
	bcc
	ora #64
	lsr
ssbex1_05	sta $bf00,x		;scroll_buffer+24,x
	dex
	bpl ssbex1_01
	rts	;786 Cycles



;Map Characters
;256*(2*12) == 6144 Bytes
;Maps
;64*(20*10) == 12800 Bytes

~19K

;Sprites and Tables
;128*(2*12) == 3072 Bytes

~22K

;Code
;8K

~30K

;Screen, System and ROM
;8159+1280+16384 == 26K

~56K

;Music, Title and Disc
;8K

~64K
