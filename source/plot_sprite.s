; plot sprite
; 1) Plot any 6 base sprite on screen-buffer (Background data taken from screen buffer)

;#define	exclusion_mask	$B800

;y 		frame number
;x		sprite character number
;zero_00/1	sbuffer loc
#define	sbYoffset		$b408

plot_sprite
	stx character_index
	lda sprite_bitmap_lo,y	;sd
	sta xtemp_01
	lda sprite_bitmap_hi,y
	sta xtemp_02
.(
	txa
	jsr character2address
	ldx pattern_number,y
	stx pattern_index
	lda #06
	sta CharacterNumber
	ldx sprite_method
	lda sprite_plot_method_lo,x
	sta vector2+1
	lda sprite_plot_method_hi,x
	sta vector2+2
	clc
loop2	; fetch bg character address(04-05) from sbuffer_loc + pattern x/y(based on x)
	ldx pattern_index
	ldy sprite_patterny0,x
	lda sbYoffset,y
	adc sprite_patternx0,x
	tay

	inc pattern_index

	lda #00
	sta zero_05

	lda (zero_00),y
	; Convert character to address (Same as character2address but 04/05 and faster)
	sec
	sbc #32
	asl
	asl
	rol zero_05
	asl
	rol zero_05
	sta zero_04
	lda zero_05
	adc #$b5
	sta zero_05
	// Now check if we can plot it or not
	lda (zero_00),y
	bmi skip3
	cmp #32
	bcc skip3
	// Also check if character is object that can be picked up (by hero or Creature!)
;	cmp #114
;	bcc skip4
;	cmp #120
;	bcs skip4
	// This data should be picked up after plot_sprite (it does mean only one item
	// can be picked up every plot_sprite.
;	sta item_picked_up
;	sty offset_of_pickup
skip4	; plot character
	lda character_index
	sta (zero_00),y
skip3	inc character_index
	; store bitmap
	clc
vector2	jsr $dead
	;inc ch
	lda zero_02
	adc #08
	sta zero_02
	bcc skip2
	inc zero_03
	clc
skip2	dec CharacterNumber
	bne loop2
.)
	rts

// Sprite display Methods

; 0) Normal    - (background AND mask) OR bitmap
sdm_00	ldy #07
	lda xtemp_01
.(
	sta vector1+1
	lda xtemp_02
	sta vector1+2
loop1
vector1	ldx $dead,y	;sd (contains bitmap + mask)
	stx temp_01        ;
	lda exclusion_mask,x ;mask of sprite_data
	and (zero_04),y	;bg (background)
	ora temp_01	;
	sta (zero_02),y	;ch (Character address)
	dey
	bpl loop1
	;inc sd
	lda xtemp_01
	adc #08
	sta xtemp_01
	bcc skip1
	inc xtemp_02
	clc
skip1
.)
	rts

; 1) Inverse   - (mask EOR 63) OR background
sdm_01	ldy #07
	lda xtemp_01
.(
	sta vector1+1
	lda xtemp_02
	sta vector1+2
loop1
vector1	ldx $dead,y	;sd (contains bitmap + mask)
	lda exclusion_mask,x;mask of sprite_data
	eor #63
	ora (zero_04),y	;bg (background)
	sta (zero_02),y	;ch (Character address)
	dey
	bpl loop1
	;inc sd
	lda xtemp_01
	adc #08
	sta xtemp_01
	bcc skip1
	inc xtemp_02
	clc
skip1
.)
	rts

; 2) Ghost     - bitmap OR background
sdm_02	ldy #07
	lda xtemp_01
.(
	sta vector1+1
	lda xtemp_02
	sta vector1+2
loop1
vector1	lda $dead,y	;sd (contains bitmap + mask)
	ora (zero_04),y	;bg (background)
	sta (zero_02),y	;ch (Character address)
	dey
	bpl loop1
	;inc sd
	lda xtemp_01
	adc #08
	sta xtemp_01
	bcc skip1
	inc xtemp_02
	clc
skip1
.)
	rts

; 3) Cloak     - mask AND background
sdm_03	ldy #07
	lda xtemp_01
.(
	sta vector1+1
	lda xtemp_02
	sta vector1+2
loop1
vector1	ldx $dead,y	;sd (contains bitmap + mask)
	lda exclusion_mask,x;mask of sprite_data
	and (zero_04),y	;bg (background)
	sta (zero_02),y	;ch (Character address)
	dey
	bpl loop1
	;inc sd
	lda xtemp_01
	adc #08
	sta xtemp_01
	bcc skip1
	inc xtemp_02
	clc
skip1
.)
	rts

; 4) Invisible - (background AND mask) OR (bitmap AND BG)
sdm_04	ldy #07
	lda xtemp_01
.(
	sta vector1+1
	lda xtemp_02
	sta vector1+2
loop1
vector1	ldx $dead,y	;sd (contains bitmap + mask)
	lda exclusion_mask,x;mask of sprite_data
	and (zero_04),y	;bg (background)
	sta temp_01
	txa
	and (zero_04),y	;bg
	ora temp_01
	sta (zero_02),y	;ch (Character address)
	;inc sd
	lda xtemp_01
	adc #08
	sta xtemp_01
	bcc skip1
	inc xtemp_02
	clc
skip1
	dey
	bpl loop1
.)
	rts
