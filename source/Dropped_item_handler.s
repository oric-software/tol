// display dropped Items and items found on ground

;HP or high priority items total 12 and may exist anywhere on the map.
;HP items include Artifacts and keys but since the hero has no facility
;to drop anything, they will only be on the ground if they were their at
;the start of the game!


;All LP items are simply deposited in BGBuffer, if the hero fails to pick
;them up before the bgbuffer scrolls them away, then the hero will lose
;them!
;However, since most dropped items are of lower significance, this will
;not matter so much.
;bgbuffer holds codes 0-159, 160-163 hold lp items dropped
;114 Food    	lp	160
;115 Gold           lp	161
;116 Key            HP
;117 Potion         lp	162
;118 Weapon         lp	163
;119 Artifact       HP
#define	sb_ylocl		$b40d
#define	sb_yloch		$b424
#define	original_ccc_under_posession	$b2e6
#define	item_text_number	$b2ea
#define	posessionlist	$b457
#define	bg_ylocl		$b46c
#define	bg_yloch		$b481

plot_ground_Items
	// Setup loop
	ldx #11
.(
loop1	lda ground_item_character,x
	beq skip1
	// If Cloak, must avoid plotting if tin clasp is not posessed
	cpx #2
	bne skip2
	lda clasp_posessed_flag
	beq skip1
skip2	// Ok, so calculate screen coordinates and branch if out of bounds
	lda ground_item_xl,x
	sec
	sbc sb_extremeWl
	sta test_xl
	lda ground_item_xh,x
	sbc sb_extremeWh
	bne skip1	;Out of bounds
	lda ground_item_yl,x
	sec
	sbc sb_extremeNl
	tay
	lda ground_item_yh,x
	sbc sb_extremeNh
	bne skip1	;Out of bounds
	// Check if within eastern and southern boundaries
	lda test_xl
	cmp #43
	bcs skip1
	cpy #23
	bcs skip1
	// Convert to screen buffer loc and store
	adc sb_ylocl,y
	sta vector1+1
	lda sb_yloch,y
	adc #00
	sta vector1+2
	lda ground_item_character,x
vector1	sta $dead
skip1	dex
	bpl loop1
.)
	rts

;X Creature index
;A Dropped posession
drop_creatures_posession
	// Drop creatures posession on background buffer as codes 160-163
	// Ensure position is wihin bg buffer
	lda creature_screen_x,x
	cmp #39
.(
	bcs skip3	;If can't drop, then don't drop!
;	lda #38
	ldy creature_screen_y,x
	cpy #21
	bcs skip3 ;If can't drop, then don't drop!
;	ldy #20
	// Calculate bg buffer location
	clc
	adc bg_ylocl,y
	sta zero_00
	lda bg_yloch,y
	adc #00
	sta zero_01
	// Fetch current character code (ccc)
	ldy #00
	lda (zero_00),y
	// Ensure original character is not pick-up
	cmp #160
	bcs skip3
	pha
	// Fetch colour attribute of this (ccca)
	tay
	lda character_attribute_table,y
	// and store ccca to posessions (about to be dropped) colour attribute
	// (Although this may muck up duplicate characters, much better than doing nothing!!)
	ldy creature_posessionbgbufnum,x
	sta character_attribute_table,y
	// Also store ccc to table indexed by posession(160-163)
	pla
	sta original_ccc_under_posession-160,y
	// Then store posession
	tya
	ldy #00
	sta (zero_00),y
skip3
.)
	rts

;(zero_00),y 	background buffer location of dropped item
;A		Dropped Item (160-163)
hero_pickup_lpitem
	tax
	// Fetch and store original ccc to posession location (Delete from bgbuf)
	lda original_ccc_under_posession-160,x
	sta (zero_00),y
	// Randomise actual Item based on categories (160-163)
	cpx #161
	beq add_hero_gold	;Gold - Random quantity (1-99)
	bcc add_hero_food	;Food - Single Ration
	lda rnd_byte0
	and #03
	ora item_text_number-162,x
	sta new_posession
add_hero_posession
	// Now find spare slot for it
	ldx #00
.(
loop1	lda posessionlist,x
	beq skip4
	inx
	cpx #20
	bcc loop1
	lda #222
	jsr message2window
	clc
	rts
skip4	lda new_posession
.)
	sta posessionlist,x
	lda #223
	jsr message2window
	sec
	rts
add_hero_gold
	lda #182
	sta new_posession
	lda rnd_byte0
	// Convert random byte to BCD 00-99
	sed
	clc
	adc #01
	cld
	// Add to posessed gold
	jsr add_money
	lda #223
	jmp message2window
add_hero_food
	// Add food Ration
	jsr increment_ration
	lda #197
	sta new_posession
	lda #223	;You take the +
	jmp message2window
;A == Hero Posession to remove
sub_hero_posession
	ldy #21
.(
loop1	cmp posessionlist,y
	beq skip1
	dey
	bpl loop1
	rts
skip1	lda #00
.)
	sta posessionlist,y
	rts

increment_ration
	lda hero_rations
	sed
	clc
	adc #01
	sta hero_rations
	cld
	rts


hero_pickup_hpitem
	;We don't need to delete this item, it will be deleted next time
	;plot_ground_items is called

	;Whilst HP item character is known(A), we'll need to locate the exact code
	;to work out what the item is.
	;Since HP items are widespread but very few, we can limit a single HP item
	;to a Region, and just compare ground_item_xh to hero_xh, etc.
	ldx #11
.(
loop1	lda ground_item_xh,x
	cmp hero_xh
	bne skip1
	lda ground_item_yh,x
	cmp hero_yh
	beq skip2
skip1	dex
	bpl loop1
	rts
skip2	;Found ground item (X)
	lda ground_item_textnum,x
	stx temp_02
	;Add to inventory
	sta new_posession
	jsr add_hero_posession
	bcc skip3	;Not enough room
	;Remove from ground_item's
	lda #00
	ldx temp_02
	sta ground_item_character,x
skip3	rts
.)
