;Hero Code
;1) Plot Hero on screen-buffer
;2) Navigate Hero (Checking collision and updating animation frame)
#define	square_hero_offset_bg	$b2a4
#define	square_hero_offset_sb	$b2ad
#define	frame_sequence		$b2b6
#define	hero_bgoffset_lo		$b2c6
#define	hero_bgoffset_hi		$b2ca
#define	hero_sboffset_lo		$b2ce
#define	hero_sboffset_hi		$b2d2

manage_hero
	// Control hero speed
	lda magical_boots
.(
	bne skip3
	lda hero_frac
	sec
	adc #128
	sta hero_frac
	bcc skip2
skip3	// Check on keys
	lda key_register
	sta key_instance
	ldx #07
loop1	lda key_instance
	and key_stroke,x
	bne skip1
	dex
	bpl loop1
	lda #00
	sta hero_moving
	sta hero_hit
	jmp calc_hero_frame

skip1	lda key_vectorlo,x
	sta vector1+1
	lda key_vectorhi,x
	sta vector1+2
	//
	lda #01
	sta hero_moving
	// Animate
	lda hero_anim_frame
	cpx #04	;Don't animate if currently hitting
	beq skip4
	clc
	adc #01
skip4	and #03
	sta hero_anim_frame
	and #01
	beq vector1
	// Capture the central character of the hero from the bg buffer
	ldy $acb2	;$AB40+19+9*39
	// Fetch the attribute of this character
	lda character_attribute_table,y
	// Extract Characters surface definition
	and %01100000
	asl	;11000000
	asl	;C 10000000
	rol	;1C 0...
	rol	;11 0...
	// A will be 0-3 corresponding with
	//  0) Sand
	//  1) Grass
	//  2) Stone
	//  3) Stone
	tay
	lda sfx_step_sound,y
;	sta sfx_trigger
vector1	jmp $DEAD
skip2	rts
.)

calc_hero_frame
.(
	// The hero frame primarily depends on his or her disguise
	lda hero_disguise
	bne skip4
	// if no disguise, the frame may depend on hero attack
	lda hero_hit
	bne skip3
	// If no disguise or hit, each direction has 3 frames, arranged in sequence of 0,1,2,1
skip1	lda hero_direction
	;multiply by 4
	asl
	asl
	;add anim
	adc hero_anim_frame
	tax
	lda frame_sequence,x
	sta hero_frame
	rts
skip3	// Hero Hitting
	lda hero_direction
	clc
	adc #12
	sta hero_frame
	dec hero_hit
	rts
skip4	// Hero in disguise
	// Reduce animations from 4 to 2
	lda hero_anim_frame
	and #01
	sta temp_01
	// Now calculate frame, note that their are no hit frames, since hitting will
	// de-cloak the disguise!
	lda hero_direction
	asl
	adc temp_01
	adc hero_disguise ;Aswell as flagging disguise, hero_disguise points to creature frame
	sta hero_frame
.)
	rts


key_left
	// Because the hero may change direction at any time, the new direction and move
	// is always stored in a temp area. Only when the new position is legitamised will
	// the temp become the new heo position and direction.

	ldx hero_direction
	lda #03	;change dir
	sta hero_direction
	cpx #03
.(
	bne skip3	;if changing direction, don't move (looks like a skid!)
	lda #00
	sta hero_hit
	ldx #03
skip3	jsr check_hero_collision
	bcs skip1
	lda hero_xl
	bne skip2
	dec hero_xh
skip2	dec hero_xl
	jsr projectiles_east4hero_west
	jsr manage_bg4hero_west
skip1	rts
.)

;X = Direction to check
check_hero_collision
	// For Hero-background and Hero-itemsDropped Collision
	lda #<BackgroundBuffer
	clc
	adc hero_bgoffset_lo,x
	sta zero_00
	lda #>BackgroundBuffer
	adc hero_bgoffset_hi,x
	sta zero_01
	// For Hero-Creature Collision
	lda #<ScreenBuffer
	adc hero_sboffset_lo,x
	sta zero_02
	lda #>ScreenBuffer
	adc hero_sboffset_hi,x
	sta zero_03

	jsr calc_hero_frame

	// Detect Background-collision and item-collision
	ldx #08
.(
loop1	ldy square_hero_offset_bg,x
	lda (zero_00),y	;16,7
	cmp #92
	bne skip7
	jmp switch_detected
skip7	cmp #160
	bcs skip5	;Item dropped
	tay
	lda character_attribute_table,y
	bmi skip1
	dex
	bpl loop1
	// Detect hero-trajectile and floor-switch collision
	ldx #08
loop2	ldy square_hero_offset_sb,x
	lda (zero_02),y	;16,7
	bmi skip6
	cmp #126
	bcs collision_with_enemyfire
	cmp #96
	bcc skip6
	cmp #114
	bcc collision_with_creature
	;114-125
	cmp #120
	bcs skip6
	;Detected hp ground items (114-119)
	jsr hero_pickup_hpitem
skip6	dex
	bpl loop2
	clc
	rts
skip1	// Now check what sort of obstacle we have hit
	asl
	rol
	rol
	rol
	and #07
	cmp #5
	bcc skip2
	bne skip3
	jmp collision_with_door
skip3	cmp #7
	bne skip4
	jmp collision_with_death
skip4	jmp collision_with_damage
skip2	// Collision with BG
	lda #13
;	sta sfx_trigger+2
collision_with_enemyfire
collision_with_creature
	;hero-creature collision handled in sprite_code.s
	;since this code would only get executed if hero is on the move!
	sec
	rts
skip5	// Pick up dropped item
.)
	jmp hero_pickup_lpitem

key_right
	ldx hero_direction
	lda #01	;change dir
	sta hero_direction
	cpx #01
.(
	bne skip3	;if changing direction, don't move (looks like a skid!)
	lda #00
	sta hero_hit
	ldx #01
skip3	jsr check_hero_collision
	bcs skip1
	inc hero_xl
	bne skip2
	inc hero_xh
skip2	jsr projectiles_west4hero_east
	jsr manage_bg4hero_east
skip1	rts
.)



key_up
	ldx hero_direction
	lda #00	;change dir
	sta hero_direction
	cpx #00
.(
	bne skip3	;if changing direction, don't move (looks like a skid!)
	lda #00
	sta hero_hit
	ldx #00
skip3	jsr check_hero_collision
	bcs skip1
	lda hero_yl
	bne skip2
	dec hero_yh
skip2	dec hero_yl
	jsr projectiles_south4hero_north
	jsr manage_bg4hero_north
skip1	rts
.)



key_down
	ldx hero_direction
	lda #02	;change dir
	sta hero_direction
	cpx #02
.(
	bne skip3	;if changing direction, don't move (looks like a skid!)
	lda #00
	sta hero_hit
	ldx #02
skip3	jsr check_hero_collision
	bcs skip1
	jmp move_hero_down
skip1	rts
.)

key_fire  // Fire depends primarily on what the hero is currently holding
	ldx held_weapon
	; 0 - Default Sidearm
	; 1 - Dagger
	; 2 - Bow&Arrow
	; 3 - Axe
	;All other weapons act immediately when used
	lda weapon_fire_vector_lo,x
.(
	sta vector1+1
	lda weapon_fire_vector_hi,x
	sta vector1+2
vector1	jmp $dead
.)

weapon_fire_vector_lo
 .byt <weapon_default_sidearm,<weapon_dagger,<weapon_bow_n_arrow,<weapon_axe
weapon_fire_vector_hi
 .byt >weapon_default_sidearm,>weapon_dagger,>weapon_bow_n_arrow,>weapon_axe

;Hit Points - 3
;Note       -
weapon_default_sidearm
	lda #02
	sta hero_hit
	lda hero_direction
	clc
	adc #12
	sta hero_frame
	rts

;Hit Points - 9
;Note       - Can only shoot one, then hero must PICKUP dagger and USE it again
weapon_dagger
	;Dagger is a special case scenario, because once thrown the hero can only use
	;his default sidearm
	lda #0
	sta held_weapon
	jsr use_hero_weapon
	lda #183
	jmp sub_hero_posession


;Hit Points - 1
;Note       - Limited to 6 concurrent arrows
weapon_bow_n_arrow
	lda #1
use_hero_weapon
	sta zero_02 	; == Projectile Weapon
	lda #19
	sta zero_00	; == Projectile start X
	lda #9
	sta zero_01	; == Projectile start Y
	lda #0
	sta zero_03 	; == Hero(0) or Creature(1-3)
	ldy hero_direction	; == Projectile direction
	jsr shoot_projectile
	;This ought to be changed, so that effects are initiated from the irq routine
	;which means just 4 byte (lda,sta) instead of the current 7 byte method.
	lda #24	;Hero Hit (Temp)
;	sta sfx_trigger+2
	jmp weapon_default_sidearm

;Hit Points - 5
;Note       - Limited to 3 concurrent axes and short distance (10 characters)
weapon_axe
	lda #2
	jmp use_hero_weapon


;These represent the last 2 keys which are currently unassigned because held
;Objects have recently been made redundant
use_replenishment
	;Check if vial posessed
	lda #186
	jsr is_posessed
.(
	bcc skip1
	jmp ouv_usepotion
skip1	;Not posessed
.)
	rts

collision_with_door
	stx ic_x
// places (18 of 32) (144-175)
;TSMAPX,TSMAPY,TSMAP entry,City,254,Name,255
	// Precalc current tsmapx/tsmapy
	jsr calc_tsmapxy

	// Search for place using the test tsmap coordinates
	ldx #142
.(
loop1
	jsr fetch_textloc00
	ldy #01
	lda (zero_00),y
	cmp temp_01
	bne skip1
	iny
	lda (zero_00),y
	cmp temp_02
	beq skip5	;found_gate
skip1	inx
	cpx #176
	bcc loop1
skip2	// door is locked
	lda #229
	jsr message2window
	jmp skip6
skip5	// Store current place
	stx current_place
	// Fetch tsmap door type to conclude Inn, Gate or Location
	ldy #00
	lda (zero_00),y
	sta hero_tsmap_entry	;0,1,2
	;If Inn, no object required (However, hero friend must be active)
	beq skip4
;	0 (Tavern(And Magic Hat Destinations)),TSMapX,TSMapY,RegionText,254,NameText,255
;	1 (House),TSMapX,TSMapY,Posession/s,NameText,255
;	2 (Gate Jump),TSMapX,TSMapY,Xl,Xh,Yl,Yh,Posession/s or Creature/s,255/0

	// Fetch object required to open door
	;Calculate correct offset in text data
	ldy #3
	cmp #01
	beq skip7
	ldy #8
skip7	lda (zero_00),y
	beq skip3	;0 means don't need to posess an object (Like woodsman's Cabin)
	cmp #123
	bcc skip3	;Alternatively a character can also indicate this (No Posession)
	cmp #142
	bcs skip9
	;Creature required
	jsr is_withhero
	bcc skip2
	jmp skip8
	;Posession required
skip9	jsr is_posessed
	bcc skip2	;If not posessed then door is locked!
skip8	iny
	jmp skip7	;And loop for more things required
skip3	// Access to gate granted
	;However, only a message for types 0 and 1
	lda #9
;	sta sfx_trigger+2
	lda hero_tsmap_entry
	cmp #02
	bne skip11
	;Deal with Type 2 Here
	;Fetch and store new xl,yl,xh,yh
	ldy #3
	lda (zero_00),y
	sta hero_xl
	iny
	lda (zero_00),y
	sta hero_xh
	iny
	lda (zero_00),y
	sta hero_yl
	iny
	lda (zero_00),y
	sta hero_yh
	// Set the Elsewhere_flag
	iny
	lda (zero_00),y
	sta elsewhere_flag
	// Ensure input is empty
	jsr flush_key
	// Kill off creatures
	jsr kill_all_creatures
	// Refresh Screen
	jsr background_refresh
	jsr background2screenbuffer
	jsr plotColourColumn
	jmp screenbuffer2screen
skip11	lda #228
	jsr message2window
	lda elsewhere_flag
	and #128	;May be on island
	ora #2
	sta elsewhere_flag
	jmp skip10
skip4	// Check that hero hasn't killed a friend
	lda friend_is_enemy	;0(Friend) or 128(Foe)
	beq skip12
	jmp skip2
skip12	// Flag inside tavern
	lda elsewhere_flag
	and #128	;May be on island
	ora #1
	sta elsewhere_flag
	// Hero now stands in inn, so welcome him to Inn
	lda #228
	jsr message2window
skip10	jsr flush_key
	// Clear hero from screen
	JSR background2screenbuffer
	jsr plotColourColumn
	JSR screenbuffer2screen
	// goto icon menu
	jsr select_icon
	lda elsewhere_flag
	and #128	;May still be on island
	sta elsewhere_flag
skip6	jsr flush_key
	ldx ic_x
	lda #2
	sta hero_direction
	lda #6
	sta hero_frame
.)
move_hero_down
	inc hero_yl
.(
	bne skip7
	inc hero_yh
skip7	jsr projectiles_north4hero_south
	jsr manage_bg4hero_south
.)
	sec
	rts

collision_with_death
	lda #128+127
	jmp adjust_hero_life
collision_with_damage
	lda #128+4
;In...
;A	(0-31 is value) (+128 to take away otherwise add)
adjust_hero_life
	cmp #128
	and #127
.(
	bcs skip2
	adc life_force
	cmp #32
	bcc skip1
	lda #31
skip1	sta life_force
	rts
skip2	sta temp_01
	lda life_force
	sbc temp_01
	bmi skip3
	sta life_force
	rts
skip3	;Hero deaded!
.)
	;Kick off sound effect
;	lda #
;	jsr ?
	;Animate Hero Death

	;display message "Alas, Your Life has Ended."
	lda #221
	jsr message2window
	;sfx
	lda #14
;	sta sfx_trigger+2
	;wait until sfx finished

	;load back to title
	lda #00
	sta game_direction
	inc game_terminated
	brk	;Testing only
	rts
