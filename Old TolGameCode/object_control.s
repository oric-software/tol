;Now split to here
;Object Control

;in...
;x==Xpos on bgbuffer to plot object
;y==Ypos on bgbuffer to plot object
;a==Object to plot (0-15)
check_for_posessions
	lda creature_posession,x	;primarily, look at
;display_drop
;	?
;	pha
;	txa
;	clc
;	adc bgbuffer_ylocl,y
;	sta 00
;	lda bgbuffer_yloch,y
;	adc #00
;	sta 01
;	ldy #00
;	lda (00),y
;
;	pla
;	sta (00),y
;	rts
;merge_drop
;	asl
;	asl
;	asl
;	tax

;For objects that are dependant on location
;For objects that have just been dropped, redundancy rules apply
display_dropped_objects
	;Deal with location specific objects
	;The objects are arranged so the last 8 are processed first, these are the -
	;location specific objects (of high priority)
	;Then the first 3 are any other dropped objects
	lda #255
	sta object_list_index
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	lda #123
	sta temp_03
	ldx #15
ddobj_01	jsr locate_object_region
	sta ls_region,x
	lda ls_object_number,x
	bmi ls_off_scrn
	lda ls_object_xl,x
	sec
	sbc tx_lo
	sta temp_01
	lda ls_object_xh,x
	sbc tx_hi
	bne ls_off_scrn
	lda temp_01
	cmp #41
	bcs ls_off_scrn
	lda ls_object_yl,x
	sec
	sbc ty_lo
	sta temp_02
	lda ls_object_yh,x
	sbc ty_hi
	bne ls_off_scrn
	lda temp_02
	cmp #17
	bcs ls_off_scrn
	lda temp_01	;x
	cmp #19	;check if object next to hero
	bcc ddobj_02
	cmp #24
	bcs ddobj_02
	ldy temp_02	;y
	cpy #7
	bcc ddobj_02
	cpy #12
	bcs ddobj_02
	ldy object_list_index
	lda ls_object_number,x
	sta object_list,y
	inc object_list_index
ddobj_02	lda temp_01	;x
	ldy temp_02	;y
	adc bgbuffer_ylocl,y
	tay
	lda #00
	adc bgbuffer_yloch,y
	sta 01
	tya
	adc #<screen_buffer-bg_buffer
	sta 00
	lda 01
	adc #>screen_buffer-bg_buffer
	sta 01
	ldy temp_03
	lda ls_object_number,x
	sta object_assignment-123,y
	jsr plot_object
	inc temp_03
	lda temp_03	;If we have no more characters to spare (>3), then quit plotting
	cmp #126
	bcs no_more_objects
	jmp next_ls
ls_off_scrn
	;process redundency checks...
	;
	;Need to ensure that low priority objects such as Food, gold, scrolls and potions are removed
	;from tables once they are not on the screen anymore, to make room
	;
	;An object is redundant when it is off-screen and does not fall within the same
	;region location and is an object less than 8
	cpx #08
	bcs next_ls
	lda ls_region
	cmp current_region_index
	beq next_ls
	lda #128
	sta ls_object_number,x
next_ls   dex
	bpl ddobj_01
	rts

locate_object_region
	lda ls_object_xh,x
	sta temp_04
	lda ls_object_yl,x
	asl
	lda ls_object_yh,x
	rol
	asl		;Now y shifted 0-3, need to shift again 4-7
	asl
	asl
	asl
	ora temp_04	;and ORA with
	rts

plot_object
	;1) fetch sbuffer char
	ldy #00
	lda (00),y
	;2) calc sbuffer char address
	sty 03
	asl
	asl
	rol 03
	asl
	rol 03
	sta 02
	lda 03
	adc #$b5
	sta 03
	;3) calc object char address
	lda temp_03
	sec
	sbc #123
	asl
	asl
	asl
	adc #$d8
	sta pobj_01+1
	;4) calc object bitmap address
	lda ls_object_number,x
	asl
	asl
	asl
	pha
	adc #<dropped_object_chs
	sta pobj_02+1
	lda #>dropped_object_chs
	adc #00
	sta pobj_02+2
	;5) calc object mask address
	pla
	adc #<dropped_object_msk
	sta pobj_03+1
	lda #>dropped_object_msk
	adc #00
	sta pobj_03+1
	;6) Combine them
	ldy #07
	lda (02),y	;bg
pobj_03	and $bf00,y	;msk
pobj_02	ora $bf00,y	;bmp
pobj_01	sta $b700,y	;char
	dey
	bpl pobj_03
	rts

;When a dropped object is found under the hero, it will result in a char from 123 to 125
;use the char to index this table (-123) to find the object number
object_assignment
 .byt 128,128,128
;ls_object_xl,ls_object_xh,ls_object_yl,ls_object_yh and ls_object_number are held in
;page 2 so that they can be saved/recalled at each game session

;the init_new_creature code must search through the list of 16 objects
;to primarily look for an object that is required for this region area,
;and for the creature held in ls_creature, then deposit the object number (in B0-B3) in
;the creature_posession table, and reset ls_object_number to 128+object, Also set creature
;to higher health than the rest.
ls_region
 .dsb 16,0
ls_creature
 .dsb 16,0

;When a creature is required to hold an item in a specific region location...
;find object in ls tables, cmp object xy env with req', if different or not found
;assume creature has already been down that path!!
;change ls_object_number to 128+64+Object
;Set ls_object_xl/h/yl/h to region location required

;So if the object has already been picked up, and dropped in same area, then it is logical
;that another creature may pick it up again.

; 00 ?
; 01 Tablet of Truth     17
; 02 Dagger              15
; 03 Ring of Power       03
; 04 Chime               07
; 05 Medallion           12
; 06 Yellow Key          05
; 07 Brown Key           05
; 08 Black Key           05
; 09 Pink Key            05
; 10 Orange Key          05
; 11 Magenta Key         05
; 12 Note                01
; 13 Confession          02
; 14 ?
; 15 Magical Axe         16
; 16 Magical Boots	     06
; 17 Magical Arrows      08
; 18 Pile/ChainMail      10
; 19 Holy water    	     04
; 20 Red Scroll          13
; 21 Green Scroll        13
; 22 Blue Scroll         13
; 23 White Scroll        13
; 24 Amber Potion        00
; 25 Turquoise Potion    00
; 26 Spherical Potion    00
; 27 Ivory Potion        00
; 28 Bag of Gold         09
; 29 Food                14
; 30 Urn                 ?
; 31 ?
