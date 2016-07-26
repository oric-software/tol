;Weapons.s
;Weapons_control
;Controls weapons thrown


;126 is thrown by hero
;127 is thrown by Creature
weapon_control
	ldx #01
wctrl_02	lda weapon_activity,x
	bmi wctrl_03
	ldy weapon_dir,x
	lda weapon_dir_vector_lo,y
	sta wctrl_01+1
	lda weapon_dir_vector_hi,y
	sta wctrl_01+2
wctrl_01	jsr $bf00
wctrl_03	dex
	bpl wctrl_02
	rts

wctrl_north
	lda weapon_yl,x
	sec
	sbc #01
	sta weapon_yl,x
	lda weapon_yh,x
	sbc #00
	sta weapon_yh,x
	rts
wctrl_west
	lda weapon_xl,x
	sec
	sbc #01
	sta weapon_xl,x
	lda weapon_xh,x
	sbc #00
	sta weapon_xh,x
	rts
wctrl_south
	lda weapon_yl,x
	clc
	adc #01
	sta weapon_yl,x
	lda weapon_yh,x
	adc #00
	sta weapon_yh,x
	rts
wctrl_east
	lda weapon_xl,x
	clc
	adc #01
	sta weapon_xl,x
	lda weapon_xh,x
	adc #00
	sta weapon_xh,x
	rts




weapon_dir_vector_lo
 .byt <wctrl_north,<wctrl_west,<wctrl_south,<wctrl_east
weapon_dir_vector_hi
 .byt >wctrl_north,>wctrl_west,>wctrl_south,>wctrl_east






weapon_activity
 .dsb 2,128
weapon_xl
 .dsb 2,128
weapon_xh
 .dsb 2,128
weapon_yl
 .dsb 2,128
weapon_yh
 .dsb 2,128
weapon_dir
 .dsb 2,0


plot_weapons
	ldx #01
pwpn_02	lda weapon_activity,x
	bmi pwpn_01
	jsr calc_weapon_limits
	bcs pwpn_01
	jsr check_weapon_collision
	bcs pwpn_01
	jsr plot_weapon
pwpn_01	dex
	bpl pwpn_02
	rts

terminate_weapon
	lda #128
	sta weapon_activity,x
	jmp pwpn_01

calc_weapon_limits
	lda weapon_xl,x
	sec
	sbc tx_lo
	sta temp_01
	lda weapon_xh,x
	sbc tx_hi
	bne terminate_weapon
	lda temp_01
	cmp #41
	bcs terminate_weapon
	lda weapon_yl,x
	sec
	sbc ty_lo
	sta temp_02
	lda weapon_yh,x
	sbc ty_hi
	bne terminate_weapon
	lda temp_02
	cmp #17
	bcs terminate_weapon
	lda temp_01
	ldy temp_02
	adc bgbuffer_ylocl,y
	sta 00	;bb_lo
	lda bgbuffer_yloch,y
	adc #00
	sta 01	;bb_hi
	lda 00	;bb_lo
	adc #<screen_buffer-bg_buffer
	sta 02	;sb_lo
	lda 01	;bb_hi
	adc #>screen_buffer-bg_buffer
	sta 03	;sb_hi
	rts

check_weapon_collision
	ldy #00
	lda (02),y	;sb
	bmi	;Sea, Fire,
	cmp #123
	bcs	;objects, other weapon
	cmp #32
	bcc 	;attributes
	cmp #96
	bcc cwcol_02	;BG
	cmp #102
	bcc weapon_hits_creature
	iny
	cmp #108
	bcc weapon_hits_creature
	iny
	cmp #114
	bcc weapon_hits_creature
	jmp weapon_hits_hero
cwcol_02	ldy #00
	lda (00),y	;bb
	sta cwcol_01+1
cwcol_01	lda $0600
	and #%00111000
	cmp #01	;keep as one, should be set exact later
	bcs	;Wall, Mountain, Gate, Door
	rts

weapon_hits_creature
	lda creature_health,y
	bmi whcr_01
	sec
	sbc weapon_strength,x
	sta creature_health,y
whcr_01	lda #128
	sta weapon_activity,x
	sec
	rts
weapon_hits_hero
	cpx #00
	beq whhero_01
	dec hero_health
whhero_01	rts

;Weapon chardefs (bitmaps and masks reside in $0503-$05FF
plot_weapon
	lda weapon_animation,x
	beq pweap_04
	lda weapon_type,x
	eor #01
	sta weapon_type,x
pweap_04	ldy #00	;calc bg address
	sty temp_01
	lda (02),y
	bmi	;don't plot
	cmp #32
	bcc       ;don't plot
	sbc #32
	asl
	asl
	rol temp_01
	asl
	rol temp_01
	sta 00
	lda temp_01
	adc #$b5
	sta 01
	txa	;calc char address
	asl
	asl
	asl
	adc #$f0
	sta pweap_01+1
	ldy weapon_type,x	;calc chardef bitmap
	lda weapon_chardef_bmp,y
	sta pweap_02+2
	lda weapon_chardef_msk,y	;calc chardef mask
	sta pweap_03+2
	ldy #07
pweap_05	lda (00),y
pweap_03	and $0500,y
pweap_02	ora $0500,y
pweap_01	sta $b700,y
	dey
	bpl pweap_05
	rts




;Weapons                    Animated?  Type
;Rogues Horizontal Arrow      No       00
;Rogues Vertical Arrow        No       01
;Asps Magical Star            Yes      02
;Heroes Magical Axe           Yes      04
;Heroes Knife		No       06
;
;8*8*2==128

weapon_type
 .dsb 8,0
weapon_animation
 .dsb 8,0
weapon_strength
 .dsb 2,2
