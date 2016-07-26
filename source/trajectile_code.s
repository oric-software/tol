// Process projectiles
// 8 projectiles, dynamically assigned.

// projectiles collision is based on
// 1) BG Buffer for Background collision
// 2) Screen Buffer for Hero or Creature Collision
// projectiles are limited to BG Buffer dimensions

;projectile_x		;0-38
;projectile_y		;0-18
;projectile_character	;95(Hero Special),126(Arrow H),127(Arrow V)
;projectile_sourcecreature	;Hero(0) or Creature(1-3)
;projectile_direction	;North(0), East(1), South(2), West(3), Inactive(128)
;projectile_distancelimiter	;(0 to 38?)
;projectile_potency		;How much it will take off a life -
;Note that if projectile continues, it may decrement up to three times!
;projectile_afterthought	;How the projectile behaves after hitting the hero or creature
;Behaviours...
; 1) projectile dissappears (Arrow)
; 2) projectile Turns to Dropped Item (Dagger)
; 3) projectile rotates and continues?

// zero_00 == Projectile start X
// zero_01 == Projectile start Y
// zero_02 == Projectile Weapon
// zero_03 == Hero(0) or Creature(1-3)
// Y == Projectile direction
shoot_projectile
	stx skip2+1
	ldx #07
.(
loop1	lda projectile_direction,y
	bmi skip1
	dey
	bpl loop1
	jmp skip2
skip1	lda zero_00
	sta projectile_x,x
	lda zero_01
	sta projectile_y,x
	tya
	sta projectile_direction,x
	lsr	;will put carry as WestEast(1) or NorthSouth(0)
	ldy zero_02
	lda projectile_property_character,y
	bcc skip3
	cmp #96
	adc #00	;If WestEast, make
skip3	sta projectile_character,x		;95(Hero Special),126(Arrow H),127(Arrow V)
	lda zero_03
	sta projectile_sourcecreature,x	;Hero(0) or Creature(1-3)
	lda projectile_property_distancelimiter,y
	sta projectile_distancelimiter,x	;(0 to 38?)
	lda projectile_property_potency,y
	sta projectile_potency,x		;How much it will take off a life
	lda projectile_property_afterthought,y
	sta projectile_afterthought,x		;How the projectile behaves after hitting the hero or creature
skip2	ldx #00
.)
	rts

stop_all_projectiles
	ldx #07
	lda #128
.(
loop1	sta projectile_direction,x
	dex
	bpl loop1
.)
	rts

process_projectiles
	ldx #07
.(
loop1	ldy projectile_direction,x
	bmi skip1
	lda projectile_dirvector_lo,y
	sta vector1+1
	lda projectile_dirvector_hi,y
	sta vector1+2
vector1	jsr $dead
skip1	dex
	bpl loop1
.)
	rts

projectile_north
projectile_east
projectile_south
projectile_west

projectile_north
	ldy projectile_y,x
	lda projectile_x,x
	dey
	jmp process_projectile

projectile_east
	ldy projectile_y,x
	lda projectile_x,x
	clc
	adc #01
	jmp process_projectile

projectile_south
	ldy projectile_y,x
	lda projectile_x,x
	iny
	jmp process_projectile

projectile_west
	ldy projectile_y,x
	lda projectile_x,x
	sec
	sbc #01
	jmp process_projectile

process_projectile
	// ** Check for collision with new trajectory **
	sta new_projectile_x
	sty new_projectile_y
	// Check screen bounds
	cpy #19
.(
	bcs skip3
	cmp #38
	bcs skip3
	// Check BG collision
	clc
	adc bg_ylocl,y
	sta zero_00
	lda bg_yloch,y
	adc #00
	sta zero_01
	ldy #00
	lda (zero_00),y
	tay
	bmi skip1	;Inversed, so allow move but don't plot
	cpy #32
	bcc skip1	;Attribute, so allow move but don't plot
	lda character_attribute_table,y
	bmi skip3	;BG collision
skip1     // Check Creature or Hero collision
	lda new_projectile_x
	ldy new_projectile_y
	clc
	adc #02
	adc sb_ylocl+2,y
	sta zero_02
	lda sb_yloch+2,y
	adc #00
	sta zero_03
	ldy #00
	lda (zero_02),y
	cmp #96
	bcc skip4
	cmp #126
	bcs skip4
	cmp #120
	bcs skip2
	iny
	cmp #114
	bcs skip4
	cmp #108
	bcs skip2
	iny
	cmp #102
	bcs skip2
	iny
skip2	tya
	cmp projectile_sourcecreature,x	;Hero(0) or Creature(1-3)
	beq skip4	;Protects against projectile leaving the creature who threw it
	tay
	beq skip6	;Hero collision
	bmi skip3	;General BG
	dey
	// Hitting creature (Not Hero)
	lda #01	;Highlight creature being hit
	sta creature_inverse,y
	lda creature_life,y
	sec
	sbc projectile_potency,x
	sta creature_life,y
	bpl skip7
	// Kill Creature
	lda #04
	sta creature_activity,y
skip7	// now decide how projectile should behave after hitting the creature
	// 0) Projectile ends here and disappears
	// 1) Projectile ends here but is plotted in bg to be picked up again
	// 128) Projectile continues until screen bounds or distancelimiter
	lda projectile_afterthought,x
	bmi skip4
skip9	lda projectile_afterthought,x	;Loaded twice because we don't don't want skip9 to skip4
	beq skip3
	// 1) Projectile ends here but is plotted in bg to be picked up again
	ldy #00
	lda #163
	sta (zero_00),y
skip3	// 0) Projectile ends here and disappears
	lda #128
	sta projectile_direction,x
	rts
skip4	// Manage distance travelled
	dec projectile_distancelimiter,x
	bmi skip9
	// 128) Projectile continues until screen bounds or distancelimiter
	// Also for no collision
	// Still need to check sb for attribute or inverse (no plot)
	ldy #00
	lda (zero_02),y	;Fetch sb again
	bmi skip5	;don't plot if inverse
	cmp #32
	bcc skip5	;don't plot if attribute
	lda projectile_character,x
	sta (zero_02),y
	// Now store new positions
	lda new_projectile_x
	sta projectile_x,x
	lda new_projectile_y
	sta projectile_y,x
skip5	rts

skip6	// Hero Collision
	lda #01	;Highlight Hero
	sta hero_inverse
	lda life_force
	sec
	sbc projectile_potency,x
	sta life_force
	bpl skip8
	// Kill Hero ;(
	;lda #04
	;sta creature_activity,y
	;Not sure?
skip8	jmp skip7
.)
