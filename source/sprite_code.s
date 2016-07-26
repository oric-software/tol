// Sprite(Creature) code
;Stepped development process
;1) Plot selected sprites to screen-buffer (Centre because on bridge!)

;ScreenBuffer (43*23) [989] (Fixed Memory @AE91 - B26D)
;sssssssssssssssssssssssssssssssssssssssssss
;sssssssssssssssssssssssssssssssssssssssssss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBoBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sssssssssssssssssssssssssssssssssssssssssss
;sssssssssssssssssssssssssssssssssssssssssss
#define	sb_ylocl		$b40d
#define	sb_yloch		$b424
#define	gnc_dironherodir	$b49e
#define	creature_xblock_factor	$b4c6
#define	creature_yblock_factor	$b4ca
#define	creature_xblock_offset	$b4ce
#define	creature_yblock_offset	$b4d2

process_creatures


	// Now work out if Creature is within screen buffer bounds
	ldx #02
.(
loop1	lda creature_activity,x
	bmi skip1
	beq skip4
	jsr creature_fatality
	jmp skip3
skip4	jsr generate_new_creature
	bcs skip6	;Two step jump
skip1	//
	lda creature_frac,x
	sec
	adc creature_rate,x
	sta creature_frac,x
	bcc skip3
	// sort animation frame
	lda creature_frame_interleave,x
	eor #01
	sta creature_frame_interleave,x
	// Process foe or friend?
	lda creature_foe,x
	bmi skip2
	jsr navigate_friend
	jmp skip3
skip2	jsr navigate_foe
skip3	// We need to hold a record of whether the creature was on or off screen
	// So by marking creatures screen x as >39, we can flag without additional table
	lda #128
	sta creature_screen_x,x
	// check if within western and northern boundaries
	lda creature_xl,x
	sec
	sbc sb_extremeWl
	sta test_xl
	lda creature_xh,x
	sbc sb_extremeWh
	bne skip5


	lda creature_yl,x
	sec
	sbc sb_extremeNl
	tay	;sta test_yl
	lda creature_yh,x
	sbc sb_extremeNh
	bne skip5
	// Check if within eastern and southern boundaries
	lda test_xl
	cmp #41
skip6	bcs skip5
	cpy #21
	bcs skip5
	// Convert to screen buffer loc and store
	sta creature_screen_x,x
	sty creature_screen_y,x
	adc sb_ylocl,y
	sta zero_00
	lda sb_yloch,y
	adc #00
	sta zero_01
	// Now calc creature character number
	txa
	asl
	sta temp_01
	asl
	adc temp_01
	adc #96
	//
	ldy creature_inverse,x
	sty sprite_method
	// Fetch creature frame
	ldy creature_frame,x
	stx temp_02
	tax
	// Plot Creature
	jsr plot_sprite
	ldx temp_02
	lda #00
	sta creature_inverse,x
skip5	dex
	bmi skip7
	jmp loop1
skip7	rts
.)

;creature_activity
;B0-2
; 0 Dead/Inactive
; 1 Death frame #4
; 2 Death frame #3
; 3 Death frame #2
; 4 Death frame #1
;B7
; 0 Die/dead creature
; 1 Alive
;creature_foe
;b7
; 0 Friend
; 1 Enemy
;creature_direction (Friend)
; 0 North
; 1 East
; 2 South
; 3 West


creature_fatality
	// Sort death frame
	sec
	sbc #01	;1,2,3,4 >> 0,1,2,3
	eor #03	;0,1,2,3 >> 3,2,1,0
	clc
	adc #73
	sta creature_frame,x
	// Update frame number (However, delay sequence)
	lda creature_frac,x
	adc #64	;speed = every 4th game cycle
	sta creature_frac,x
.(
	bcc skip1
;	dec creature_frame,x
	dec creature_activity,x
	bmi skip2
	bne skip1
skip2	lda #00
	sta creature_activity,x
	// Now creature is dead, check if it had a posession
	lda creature_posessionbgbufnum,x
	beq skip1
	// aha... So find a spare slot and deposit that posession in the map.
	jsr drop_creatures_posession
skip1	rts
.)


;Start with Move N,E,S,W
;creature_xblock_offset
; .byt 7,0,7,14
;creature_yblock_offset
; .byt 8,4,0,4

generate_new_creature
	// Locate location where creature may start
	// Based on hero direction (Plot ahead but rnd l/r, moving towards)
	dec creature_counter
.(
	beq skip6
	sec
	rts
skip6	lda #128	;Every 16 game cycles
	sta creature_counter
	lda hero_moving
	bne skip3
	lda rnd_byte1
	and #03
	jmp skip4
skip3	ldy hero_direction	;0-3
	lda gnc_dironherodir,y
skip4	sta creature_direction,x
	tay
	// Convert hero coordinates to block coordinates
	lda hero_xl
	sta test_xl
	lda hero_xh
	lsr
	ror test_xl
	lsr
	ror test_xl
	sta test_xh

	lda hero_yl
	sta test_yl
	lda hero_yh
	lsr
	ror test_yl
	lsr
	ror test_yl
	sta test_yh

	// Locate top-left offscreen
	lda test_xl
	sec
	sbc #7
	sta test_xl
	lda test_xh
	sbc #00
	sta test_xh

	lda test_yl
	sbc #4
	sta test_yl
	lda test_yh
	sbc #00
	sta test_yh

	// Based on creature direction, set offset of x/y
	lda rnd_byte0
	and creature_xblock_factor,y
	clc
	adc creature_xblock_offset,y
	adc test_xl
	sta test_xl
	bcc skip1
	inc test_xh

skip1	lda rnd_byte1
	and creature_yblock_factor,y
	clc
	adc creature_yblock_offset,y
	adc test_yl
	sta test_yl
	bcc skip2
	inc test_yh
skip2



;         lda test_xl
;         clc
;         adc creature_xblock_offset,y
;         sta test_xl
;         lda test_xh
;         adc #00
;         sta test_xh
;
;         lda test_yl
;         clc
;         adc creature_yblock_offset,y
;         sta test_yl
;         lda test_yh
;         adc #00
;         sta test_yh

	// Now examine block at this coordinate
	jsr fetch_block
	cmp #17
	bcs skip5
	// Found empty block, so convert back to real-world
	asl test_xl
	rol test_xh
	asl test_xl
	rol test_xh
	//
	asl test_yl
	rol test_yh
	asl test_yl
	rol test_yh
	// store to new creature
	lda test_xl
	sta creature_xl,x
	lda test_xh
	sta creature_xh,x
	lda test_yl
	sta creature_yl,x
	lda test_yh
	sta creature_yh,x
	// Now determine the creature type from the region
	lda creature_yh,x
	asl
	asl
	asl
	asl
	ora creature_xh,x
	tay
	// Whilst the region will select a choice of two creatures, this bit decides on which
	lda rnd_byte0
	lsr
	//
	lda Region_map,y
	and #07
	// Use carry to decide on which
	rol
	tay
	// Y now contains index 0-15
	// 0 Serf
	// 1 Guard
	// 2 Serf
	// 3 Orc
	// 4 Orc
	// 5 Archer
	// 6 Ghost
	// 7 Skeleton
	// 8 Skeleton
	// 9 Orc
	// 10 Black Asp
	// 11 Black Asp
	lda creature12_rate,y
	sta creature_rate,x
	lda creature12_bframe,y
	sta creature_base_frame,x
	;This depends on whether hero has killed a Friend
	lda friend_is_enemy	;0(Friend) or 128(Foe)
	bne skip8
	lda creature12_foe,y
skip8	sta creature_foe,x
	lda creature12_code,y
	sta creature_code,x
	lda creature12_life,y
	sta creature_life,x
	lda #8
	sta creature_pause,x
	sta pausenfire_delay,x
	// Posessions depends on random element
	lda rnd_byte1
	asl
	lda #00
	sta creature_regress,x
	// Creature volume should start low
	sta creature_volume,x
	sta creature_frac,x
	bcc skip7
	lda creature12_posessionbgbufnumber,y
skip7	sta creature_posessionbgbufnum,x
	//
	lda #128
	sta creature_activity,x
	clc
skip5	rts
.)
;Their are now no hp creatures to generate, they all reside within buildings!
;This prevents the appearance of multiples, and simplifies the whole system

navigate_friend
	// Reset s2a wall attribute
	lda #00
	sta creature_cch,x
	// Jump to direction
	ldy creature_direction,x	;Also includes S2A mode (4)
	lda friend_move_vector_lo,y
.(
	sta vector1+1
	lda friend_move_vector_hi,y
	sta vector1+2
vector1	jmp $dead
.)

friend_north
	jsr check_creature_range
	bcs deactivate_creature
	jsr check_creatures_north
.(
	bcc skip2
	// If creature is guard, then check if we can get him to stand to attention
	lda creature_base_frame,x
	cmp #24	;guard
	bne skip4
	lda creature_cch,x
	and #8
	bne skip5
skip4	jsr rotate_creature
	jmp sort_creature_frame
skip2	jsr move_creature_north
	jmp sort_creature_frame


skip5	// Change guard to stand to attention (S2A mode)
	lda #04
	sta creature_direction,x
.)

;Makes the guard (S)tand to(2) (A)ttention
guard_s2a
	jsr check_creature_range
	bcs deactivate_creature
	lda #32
	sta creature_frame,x
	rts

friend_east
	jsr check_creature_range	;may also be used to approximate feet sfx volume
	bcs deactivate_creature
	jsr check_creatures_east
.(
	bcc skip2
	jsr rotate_creature
	jmp sort_creature_frame

skip2	jsr move_creature_east
	jmp sort_creature_frame
.)

friend_south
	jsr check_creature_range	;may also be used to approximate feet sfx volume
	bcs deactivate_creature
	jsr check_creatures_south
.(
	bcc skip2
	jsr rotate_creature
	jmp sort_creature_frame

skip2	jsr move_creature_south
	jmp sort_creature_frame
.)

friend_west
	jsr check_creature_range
	bcs deactivate_creature
	jsr check_creatures_west
.(
	bcc skip2
	jsr rotate_creature
	jmp sort_creature_frame

skip2	jsr move_creature_west
	jmp sort_creature_frame
.)

deactivate_creature
	lda #00
	sta creature_activity,x
	sta creature_volume,x
	rts

kill_all_creatures
	ldx #02
.(
loop1	jsr deactivate_creature
	dex
	bpl loop1
.)
	rts

rotate_creature
	ldy creature_direction,x
	iny
	tya
	and #03
	// to prevent the creature going round in circles, we
	// use a bitmap byte that is reset every minute(TOD event)...
	// on every rotate, a bit is rolled into the byte
	// once carry, the creature is killed off!
	sec
	rol creature_repeatrotate_bitmap,x
.(
	bcc skip1
	// 0N>>2S 1E>>3W 2S>>0N 3W>>1E
	lda #04
	sta creature_activity,x
	lda #01
	sta creature_repeatrotate_bitmap,x
skip1	sta creature_direction,x
.)
	rts


;out Carry if out of range
check_creature_range
	// Creatures Xrange is about 10 locations either side of visible screen
	// The complete range is 0-63
	lda hero_xl
	sec
	sbc #31	;(43/2)+((64-43)/2)
	sta test_xl
	lda hero_xh
	sbc #00
	sta test_xh
	// Creatures Yrange is about 20 locations either side of visible screen
	// The complete range is 0-63
	lda hero_yl
	sec
	sbc #31	;(23/2)+((64-23)/2)
	sta test_yl
	lda hero_yh
	sbc #00
	sta test_yh
	//
	lda creature_xl,x
	sbc test_xl
	tay
	lda creature_xh,x
	sbc test_xh
.(
	bne skip1
	cpy #64
	bcs skip1
	tya
	and #31
	sta x_range
	//
	lda creature_yl,x
	sbc test_yl
	tay
	lda creature_yh,x
	sbc test_yh
	bne skip1
	cpy #64
	bcs skip1
	tya
	and #31
	adc x_range
	lsr
	lsr
	sta creature_volume,x
	clc
	rts
skip1	sec
.)
	rts

;out carry if obstacle found
check_creatures_north
	ldy #03
.(
loop1	tya
	clc
	adc creature_xl,x
	sta test_xl
	lda creature_xh,x
	adc #00
	sta test_xh
	lda creature_yl,x
	sta test_yl
	lda creature_yh,x
	sta test_yh
	jsr is_collision
	bcs skip1
	dey
	bne loop1
skip1	rts
.)

check_creatures_east
	ldy #03
.(
loop1	lda #04
	clc
	adc creature_xl,x
	sta test_xl
	lda creature_xh,x
	adc #00
	sta test_xh
	tya
	adc creature_yl,x
	sta test_yl
	lda creature_yh,x
	adc #00
	sta test_yh
	jsr is_collision
	bcs skip1
	dey
	bne loop1
skip1	rts
.)

check_creatures_south
	ldy #03
.(
loop1	tya
	clc
	adc creature_xl,x
	sta test_xl
	lda creature_xh,x
	adc #00
	sta test_xh
	lda creature_yl,x
	adc #04
	sta test_yl
	lda creature_yh,x
	adc #00
	sta test_yh
	jsr is_collision
	bcs skip1
	dey
	bne loop1
skip1	rts
.)

check_creatures_west
	ldy #03
.(
loop1     lda creature_xl,x
	sta test_xl
	lda creature_xh,x
	sta test_xh
	tya
	clc
	adc creature_yl,x
	sta test_yl
	lda creature_yh,x
	adc #00
	sta test_yh
	jsr is_collision
	bcs skip1
	dey
	bne loop1
skip1	rts
.)

;in...
;test_xl/xh/yl/yh	== given coordinate
;out...
;Carry set if collision
;A		== 0 Creature >> Hero
;		   1 Creature >> Creature
;		   2 Creature >> BG
is_collision
	stx ic_x
	sty ic_y
	;1) check bg
	jsr fetch_character
	tay
	lda character_attribute_table,y
	tay
	ora creature_cch,x
	sta creature_cch,x
	tya
.(
	bmi skip3	;creature>>bg collision
	;2) check other creatures
	;3) check hero
	ldy #03
loop1	dey
	cpy ic_x
	php
	iny
	plp
	beq skip1	;ignore (as it is this creature)
	sty ic_i
	ldx hero_frame,y
	ldy pattern_number,x
	lda sprite_patterny0,y
	ldx ic_i
	sec	;Setting carry actually compliments top-down attack
	adc hero_yl,x
	; May reduce time and memory if using EOR to 'complete mask' to check
	sta sample_yl
	lda hero_yh,x
	adc #00
	sta sample_yh
	lda sprite_patternx0,y
	sec
	adc hero_xl,x
	sta sample_xl
	lda hero_xh,x
	adc #00
	sta sample_xh
	;3)
	cmp test_xh
	bne skip5
	lda sample_xl
	cmp test_xl
	bne skip5
	lda sample_yl
	cmp test_yl
	bne skip5
	lda sample_yh
	cmp test_yh
	beq skip2	;creature>>creature or creature>>hero collision
skip5	ldy ic_i
skip1	dey
	bpl loop1
	ldx ic_x
	ldy ic_y
	clc
	rts
skip2	// creature>>creature or creature>>hero collision
	cpx #00
	beq skip4
;A		== 0 Creature >> Hero
;		   1 Creature >> Creature
;		 128 Creature >> BG
	// creature>>creature collision (Creature is 1-3 in x)
	dex
	ldy ic_x	;Fetch acting-creature
	lda creature_foe,y	;Check if foe
	beq skip6
	// Acting creature is foe, reacting creature is irrelavant
	jsr hurt_creature
	jmp skip7
skip6	lda creature_foe,x
	beq skip7
	// Acting creature is friend, reacting creature is foe
	jsr hurt_creature
skip7	lda #1
	ldx ic_x
	ldy ic_y
	sec
	rts
skip3	// creature>>bg collision
	lda #2
	ldx ic_x
	ldy ic_y
	sec
	rts
skip4	// creature>>hero collision
.)
	ldx ic_x	;Possibly already set
	jsr creaturehero_collision
	lda #0
	ldy ic_y
	sec
	rts

hurt_creature
	lda #01
	sta creature_inverse,x
	dec creature_life,x
.(
	bne skip3
	lda #04
	sta creature_activity,x
skip3	rts
.)

;X == Creature index
;
creaturehero_collision
	// Check if hero is hitting
	ldy hero_hit
.(
	beq skip1
	// Hero attacking Creature
	jsr hurt_creature
	// Check result
	cmp #04
	bne skip2
	// So hero has killed a creature, now we need to know whether creature was friend!
	lda creature_foe,x
	bmi skip2	;Creature was foe
	// Aargh!, creature was friend, so change all friends to foe from this day forth!
	lda #128
	sta friend_is_enemy	;0(Friend) or 128(Foe)
	rts

skip1	// Check if friend (Because hero is just passing creature)
	lda creature_foe,x
	beq skip2
	// Creature attacking Hero
	// Inverse Hero for one frame
	lda #01
	sta hero_inverse
	// decrement hero life here
	lda #128+1
	jsr adjust_hero_life
skip2	rts
.)

kill_specific_creature	;Specified in A
	sta temp_01
	ldx #02
.(
loop1	ldy creature_activity,x
	bpl skip1
	lda temp_01
	cmp creature_code,x
	bne skip1
	jsr deactivate_creature
skip1	dex
	bpl loop1
.)
	rts


kill_creature
	lda #04
	sta creature_activity,x
	jmp sort_creature_frame

navigate_foe
.(
	;If the holy water is posessed and the creature is a Skeleton, then make friend
	lda creature_base_frame,x
	ldy holywater_posessed_flag
	beq skip3
	cmp #65
	beq skip2

skip3	;If the Cross is posessed and the creature is a ghost, then make friend
	ldy cross_posessed_flag
	beq skip4
	cmp #16
	beq skip2

skip4	;If the hero is disguised, then all foes become friends
	lda hero_disguise
	beq skip1
skip2	jmp navigate_friend
skip1	jsr is_creature_overlapping_hero
.)
	bcs kill_creature
	lda creature_regress,x
.(
	beq skip1
	// Regress - Pace
	dec creature_pause,x
	bne skip4
	// had enough regressing
	lda #08
	sta creature_pause,x
	lda #00
	sta creature_regress,x
	jmp sort_creature_frame
skip4	jmp navigate_friend
skip1	lda creature_pause,x
	bne skip3
	// Pause - Fire
skip6	jsr pauseNfire
	jmp sort_creature_frame
skip3	// Attack
	jsr check_creature_range
	bcc skip5
	jmp deactivate_creature		;deactivate_creature
skip5     lda #00
	sta foe_parrallel
	// Check hero X
          lda creature_xh,x
          cmp hero_xh
          bcc foe_east
          bne foe_west
          lda creature_xl,x
          cmp hero_xl
         	bcc foe_east
         	bne foe_west
	// Creature is parallel to hero (X Plane)
	// However before we can pause, must check if creature is facing towards hero
	lda #01
	sta foe_parrallel
	jmp skip2
foe_west	lda #08	;Reset creature pause count
	sta creature_pause,x
	jsr check_creatures_west
	bcs skip2	;foeatobstacle
	jsr move_creature_west
	jmp sort_creature_frame
foe_east	lda #08	;Reset creature pause count
	sta creature_pause,x
	jsr check_creatures_east
	bcs skip2	;foeatobstacle
	jsr move_creature_east
	jmp sort_creature_frame
	// Check hero Y
skip2	lda creature_yh,x
	cmp hero_yh
	bcc foe_south
	bne foe_north
	lda creature_yl,x
	cmp hero_yl
	bcc foe_south
	bne foe_north
	// Creature is parallel to hero (Y Plane)
	dec creature_pause,x
	jmp sort_creature_frame
foe_north	lda #08	;Reset creature pause count
	sta creature_pause,x
	jsr check_creatures_north
	bcs foeatobstacle
	jsr move_creature_north
	lda foe_parrallel
	beq skip7
	jmp skip6
skip7	jmp sort_creature_frame
foe_south	lda #08	;Reset creature pause count
	sta creature_pause,x
	jsr check_creatures_south
	bcs foeatobstacle
	jsr move_creature_south
	lda foe_parrallel
	beq skip8
	jmp skip6
skip8	jmp sort_creature_frame
.)

foeatobstacle
;A		== 0 Creature >> Hero
;		   1 Creature >> Creature
;		   2 Creature >> BG
;	cmp #2
;	beq 	;If BG,

	// Now set initial direction as opposite to current
	lda creature_direction,x
	;N=W E=S S=E W=N
	eor #03
	sta creature_direction,x
	// Continue
	lda #10
	sta creature_pause,x
	lda #1
	sta creature_regress,x
	jmp sort_creature_frame


;Their is an extreme case whereby the creature has achieved both x and y hero position
;in such a case, the creature must die.
is_creature_overlapping_hero
	lda creature_xl,x
	cmp hero_xl
.(
	bne skip1
	lda creature_xh,x
	cmp hero_xh
	bne skip1
	lda creature_yl,x
	cmp hero_yl
	bne skip1
	lda creature_yh,x
	cmp hero_yh
	bne skip1
	sec
	rts
skip1	clc
	rts
.)

pauseNfire
// zero_00 == Projectile start X
// zero_01 == Projectile start Y
// zero_02 == Projectile Weapon
// zero_03 == Hero(0) or Creature(1-3)
// Y == Projectile direction
	dec pausenfire_delay,x
.(
	bne skip3
	lda #32
	sta pausenfire_delay,x
	lda creature_base_frame,x
	ldy #3
	cmp #49	;Rogue
	beq skip1
	iny
	cmp #65
	bne skip2
skip1     tya
// 3) Arrow 	Rogue	126/127	20	1	0
// 4) Arrow 	Skeleton	126/127	40	4	128
	sta zero_02	;Weapon
	stx zero_03	;Creature
	inc zero_03
	lda #8
;	sta sfx_trigger+1
	lda creature_screen_x,x	;Last known screen X
	sta zero_00
	lda creature_screen_y,x	;Last known screen Y
	sta zero_01
	ldy creature_direction,x
	jsr shoot_projectile
skip2	lda #04	;Delay between successive shots
	sta creature_pause,x
skip3	rts
.)


move_creature_north
	lda creature_yl,x
.(
	bne skip1
	dec creature_yh,x
skip1	dec creature_yl,x
.)
	lda #00
	sta creature_direction,x
	rts

move_creature_east
	inc creature_xl,x
.(
	bne skip1
	inc creature_xh,x
skip1	lda #01
	sta creature_direction,x
	rts
.)

move_creature_south
	inc creature_yl,x
.(
	bne skip1
	inc creature_yh,x
skip1	lda #02
	sta creature_direction,x
	rts
.)

move_creature_west
	lda creature_xl,x
.(
	bne skip1
	dec creature_xh,x
skip1	dec creature_xl,x
	lda #03
	sta creature_direction,x
.)
	rts

sort_creature_frame
	lda creature_direction,x
	asl
	adc creature_frame_interleave,x
	adc creature_base_frame,x
	sta creature_frame,x
	rts

;This is another special case scenario, which is used on Tempus isle for when the
;hero must be with Crodor in order to gain access to Silderon Underworld.
is_withhero
	ldx #00
.(
loop1	lda creature_activity,x
	beq skip3
	cmp creature_code,x
	beq skip1
skip3	inx
	bne loop1
	clc
skip1	rts
.)

;y 		frame number
;x		sprite character number
;zero_00/1	sbuffer loc


;B---B---Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--B---B---
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
;Bl--B---B---B---B---B---B---B---B---B---B---B---B---Bl--
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
;Bl--B---CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSB---Bl--
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;Bl--B---CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSB---Bl--
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSOSSSSSSSSSSSSSSSSSSSSS--------
;Bl--B---CSSSSSSSSSSSSSSSSSSHHHSSSSSSSSSSSSSSSSSSB---Bl--
;--------CSSSSSSSSSSSSSSSSSSHHHSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSHHHSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;Bl--B---CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSB---Bl--
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;Bl--B---CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSB---Bl--
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------CSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS--------
;--------------------------------------------------------
;Bl--B---B---B---B---B---B---B---B---B---B---B---B---Bl--
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
;B---B---Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--Bl--B---B---
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
;Vanishing limit is +5 blocks beyond screen boundary

;l=-26
;r=+26
;t=-15
;b=+17

