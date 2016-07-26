;Object_handler

pickup_object
	// Something was picked up, so now we must examine object sb locs
	ldx #31
.(
loop1	lda zero_00
	clc
	adc offset_of_pickup
	tay
	lda zero_01
	adc #00
	cmp object_sbloch,x
	bne skip1
	tya
	cmp object_sblocl,x
	bne skip1
	lda object_character,x
	cmp item_picked_up
	beq skip2
skip1	dex
	bpl loop1
	rts
skip2	// Found object, The Hero may pick up any object so long as he has space
	// Unless the object is money or food parcels
	lda object_number,x	;176-207
	cmp #182
	beq gold
	cmp #196
	beq food
	ldy #00
loop2	lda posessed_objects,y
	beq skip3
	iny
	cpy #20
	bcc loop2
	rts	;Not enough space
skip3     // Store in hero posessions
	lda object_number,x	;176-207
	sta posessed_objects,y
	iny
	lda #00
	sta posessed_objects,y
	// display as held object
	jsr display_held_object
	// display message
	lda #243
	jsr message2window
	// Remove from real-world list
	jsr remove_object



	lda object_number,x	;176-207
	sta held_object
	sta posessed_objects



	rts
.)

	sta item_picked_up	;114-119
	sty offset_of_pickup


plot_objects
	// Plot items and Creatures
	rts
