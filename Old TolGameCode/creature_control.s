;Creature Control
;#include "main.h"             ;0 (Defs)
;Missing...
;Creatures still don't appear from correct sides
;Creatures appear from facing side when hero stands still, should switch to random side
;Creatures always toying to ensure 3 on screen, add random occurence element
;Allow some Creatures to fire weapons
;Allow hero to kill Creatures
;Allow creatures to kill hero
;Generate and Enable Environment to dictate new creature identity
;Freeze creature position off-screen until 10 paces away
;Guard Stands to attention when passing Gate/Door
;Allow Friendlies to enter/exit buildings (threesome per building!!!)
#define	via_t1cl	$0304

creature_control
;	lda creature_health
;	jsr plot_hex

	lda #00
	adc #64
	sta creature_control+1
	bcc cctl_04
	ldx #02
cctl_01	lda creature_activity,x
	bmi cctl_03
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	jsr calc_creature_limits	;deposit sb/bg-loc into sb_lo/sb_hi/sb_x/sb_y/bb_lo/bb_hi
	bcs cctl_02
	jsr move_creature
	ldx creature_index
cctl_02	dex
	bpl cctl_01
cctl_04	rts
cctl_03	lda #00
	adc #15
	sta cctl_03+1
	bcc cctl_02
	jmp init_new_creature

plot_creatures
	ldx #02
plotc_02	lda creature_activity,x
	bmi plotc_01
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	jsr calc_creature_limits	;deposit sb/bg-loc into sb_lo/sb_hi/sb_x/sb_y/bb_lo/bb_hi
	bcs plotc_01
	jsr plot_creature
plotc_01	dex
	bpl plotc_02
	rts

;find out if creature is within screen_buffer, set carry if not
;deposit sb/bg-loc into sb_lo/sb_hi/sb_x/sb_y/bb_lo/bb_hi if ok
calc_creature_limits
	lda creature_xl,x
	sec
	sbc tx_lo
	sta temp_01
	lda creature_xh,x
	sbc tx_hi
	bne terminate_creature
	lda temp_01
	cmp #41
	bcs terminate_creature
	lda creature_yl,x
	sec
	sbc ty_lo
	sta temp_02
	lda creature_yh,x
	sbc ty_hi
	bne terminate_creature
	lda temp_02
	cmp #17
	bcs terminate_creature
	lda temp_01
	sta sb_x
	ldy temp_02
	sty sb_y
	adc bgbuffer_ylocl,y
	sta bb_lo
	lda bgbuffer_yloch,y
	adc #00
	sta bb_hi
	lda bb_lo
	adc #<screen_buffer-bg_buffer
	sta sb_lo
	lda bb_hi
	adc #>screen_buffer-bg_buffer
	sta sb_hi
	rts

;Terminate creature is different from kill_creature in
;that the creature is just instantly removed from the game
terminate_creature
	lda #128
	sta creature_activity,x
	sec
	rts





;Plot creature to Screen_buffer, based on...
;sb_lo/sb_hi
;creature_dir/creature_frame/creature_base_frame
;creature_dying/
plot_creature
	stx creature_index
	txa
	asl
	sta temp_01
	asl
	adc temp_01
	sta creature_character_base

	lda sb_lo
	sta 00
	lda sb_hi
	sta 01

	lda creature_health,x
	bpl pcreat_10
	cmp #128+4
	bcs pcreat_12	;if wait_by_grave
	and #03
	adc #65	;base frame for death
	jmp pcreat_11
pcreat_12 lda #68	;Wait by grave
	jmp pcreat_11
pcreat_10	lda creature_dir,x
	asl
	adc creature_frame,x
	adc creature_base_frame,x
pcreat_11	tax
	lda creature_frame_address_lo,x
	sta pcreat_03+1
	lda creature_frame_address_hi,x
	sta pcreat_04+1
	ldy creature_frame_style,x

	lda style_charposition_pattern_lo,y
	sta pcreat_02+1
	sta pcreat_20+1
	lda style_charposition_pattern_hi,y
	sta pcreat_02+2
	sta pcreat_20+2
	ldx style_length,y	;#05
	stx pcreat_21+1

;loop
pcreat_07	stx temp_02
	lda creature_character_base	;Calculate creature character base
	clc
	adc temp_02
	asl
	asl
	asl
	sta pcreat_01+1	;$b700-

pcreat_02	ldy $bf00,x	;Calculate bg character address
	lda #00
	sta 03
	lda (00),y	;Note it may have objects on ground (123-125)
	asl
	asl
	rol 03
	asl
	rol 03
	sta 02
	lda 03
	adc #$b4
	sta 03

	;Calculate sprite bitmap/mask address
	txa
	asl
	asl
	asl
pcreat_03	adc #00
	sta 04
pcreat_04	lda #00
	adc #00
	sta 05

	ldy #07
pcreat_06	lda (04),y
	sta pcreat_05+1
pcreat_05	lda byte_mask_table
	and (02),y	;bg
	ora (04),y
pcreat_01	sta $b700,y
	dey
	bpl pcreat_06
	dex
	bpl pcreat_07
;plot physical sprite
	lda creature_index
	asl
	sta temp_01
	asl
	adc temp_01
	adc #96
	sta pcreat_22+1
pcreat_21	ldx #00
pcreat_20 ldy $bf00,x
	txa
pcreat_22	adc #00	;creature_character_base
	sta (00),y
	dex
	bpl pcreat_20
	ldx creature_index
	rts

;ghost		3
;skeleton		2
;Guard		2
;Orc		0
;Archer		3
;serf		0
;Monk		3
;Goo		1


creature_frame_style
 .byt 4,4,0,0,9,9,0,0	;Ghoul
 .byt 2,2,1,2,2,2,8,10	;Skeleton
 .byt 0,0,0,5,6,3,3,4	;Guard
 .byt 2,1,0,7,1,2,0,0	;Orc
 .byt 0,0,0,0,0,0,0,0	;Rogue
 .byt 2,2,9,4,2,8,3,4	;serf
 .byt 2,4,2,2,2,2,2,2	;Asp
 .byt 0,11,0,11,0,11,0,11	;Slime
 .byt 0			;Standing Guard
 .byt 0,0,0,0		;Death Sequence

;0==west 1==south 2==east 3==north
creature_frame_address_lo
 .byt <tol_sprites+$000	;00 Ghoul North 0
 .byt <tol_sprites+$030       ;01 Ghoul North 1
 .byt <tol_sprites+$060       ;02 Ghoul West 0
 .byt <tol_sprites+$090       ;03 Ghoul West 1
 .byt <tol_sprites+$0c0       ;04 Ghoul South 0
 .byt <tol_sprites+$0f0       ;05 Ghoul South 1
 .byt <tol_sprites+$120       ;06 Ghoul East 0
 .byt <tol_sprites+$150       ;07 Ghoul East 1
 .byt <tol_sprites+$240       ;08 Skeleton North 0
 .byt <tol_sprites+$268       ;09 Skeleton North 1
 .byt <tol_sprites+$1e0       ;10 Skeleton West 0
 .byt <tol_sprites+$210       ;11 Skeleton West 1
 .byt <tol_sprites+$180       ;12 Skeleton South 0
 .byt <tol_sprites+$1b0       ;13 Skeleton South 1
 .byt <tol_sprites+$290       ;14 Skeleton East 0
 .byt <tol_sprites+$2c0       ;15 Skeleton East 1
 .byt <tol_sprites+$2f0       ;16 Guard North 0
 .byt <tol_sprites+$320       ;17 Guard North 1
 .byt <tol_sprites+$350       ;18 Guard West 0
 .byt <tol_sprites+$380       ;19 Guard West 1
 .byt <tol_sprites+$3b0       ;20 Guard South 0
 .byt <tol_sprites+$3e0       ;21 Guard South 1
 .byt <tol_sprites+$410       ;22 Guard East 0
 .byt <tol_sprites+$440       ;23 Guard East 1
 .byt <tol_sprites+$470       ;24 Orc North 0
 .byt <tol_sprites+$4a0       ;25 Orc North 1
 .byt <tol_sprites+$4d0       ;26 Orc West 0
 .byt <tol_sprites+$500       ;27 Orc West 1
 .byt <tol_sprites+$530       ;28 Orc South 0
 .byt <tol_sprites+$560       ;29 Orc South 1
 .byt <tol_sprites+$590       ;30 Orc East 0
 .byt <tol_sprites+$5c0       ;31 Orc East 1
 .byt <tol_sprites+$5f0       ;32 Rogue North 0
 .byt <tol_sprites+$620       ;33 Rogue North 1
 .byt <tol_sprites+$650       ;34 Rogue West 0
 .byt <tol_sprites+$680       ;35 Rogue West 1
 .byt <tol_sprites+$6b0       ;36 Rogue South 0
 .byt <tol_sprites+$6e0       ;37 Rogue South 1
 .byt <tol_sprites+$710       ;38 Rogue East 0
 .byt <tol_sprites+$740       ;39 Rogue East 1
 .byt <tol_sprites+$770       ;40 serf North 0
 .byt <tol_sprites+$7a0       ;41 serf North 1
 .byt <tol_sprites+$7d0       ;42 serf West 0
 .byt <tol_sprites+$800       ;43 serf West 1
 .byt <tol_sprites+$830       ;44 serf South 0
 .byt <tol_sprites+$860       ;45 serf South 1
 .byt <tol_sprites+$890       ;46 serf East 0
 .byt <tol_sprites+$8c0       ;47 serf East 1
 .byt <tol_sprites+$8e8       ;48 Asp North 0
 .byt <tol_sprites+$918       ;49 Asp North 1
 .byt <tol_sprites+$948       ;50 Asp West 0
 .byt <tol_sprites+$978       ;51 Asp West 1
 .byt <tol_sprites+$9a8       ;52 Asp South 0
 .byt <tol_sprites+$9d8       ;53 Asp South 1
 .byt <tol_sprites+$a08       ;54 Asp East 0
 .byt <tol_sprites+$a38       ;55 Asp East 1
 .byt <tol_sprites+$a68       ;56 Slime 0
 .byt <tol_sprites+$a98       ;57 Slime 1
 .byt <tol_sprites+$a68       ;58 Slime 0
 .byt <tol_sprites+$a98       ;59 Slime 1
 .byt <tol_sprites+$a68       ;60 Slime 0
 .byt <tol_sprites+$a98       ;61 Slime 1
 .byt <tol_sprites+$a68       ;62 Slime 0
 .byt <tol_sprites+$a98       ;63 Slime 1
 .byt <tol_sprites+$ab8       ;64 Guard Standing
 .byt <tol_sprites+$ae8       ;65 Death 0
 .byt <tol_sprites+$b30       ;66 Death 1
 .byt <tol_sprites+$b78       ;67 Death 2
 .byt <tol_sprites+$bc0       ;68 Death 3
creature_frame_address_hi
 .byt >tol_sprites+$000	;00 Ghoul North 0
 .byt >tol_sprites+$030       ;01 Ghoul North 1
 .byt >tol_sprites+$060       ;02 Ghoul West 0
 .byt >tol_sprites+$090       ;03 Ghoul West 1
 .byt >tol_sprites+$0c0       ;04 Ghoul South 0
 .byt >tol_sprites+$0f0       ;05 Ghoul South 1
 .byt >tol_sprites+$120       ;06 Ghoul East 0
 .byt >tol_sprites+$150       ;07 Ghoul East 1
 .byt >tol_sprites+$240       ;08 Skeleton North 0
 .byt >tol_sprites+$268       ;09 Skeleton North 1
 .byt >tol_sprites+$1e0       ;10 Skeleton West 0
 .byt >tol_sprites+$210       ;11 Skeleton West 1
 .byt >tol_sprites+$180       ;12 Skeleton South 0
 .byt >tol_sprites+$1b0       ;13 Skeleton South 1
 .byt >tol_sprites+$290       ;14 Skeleton East 0
 .byt >tol_sprites+$2c0       ;15 Skeleton East 1
 .byt >tol_sprites+$2f0       ;16 Guard North 0
 .byt >tol_sprites+$320       ;17 Guard North 1
 .byt >tol_sprites+$350       ;18 Guard West 0
 .byt >tol_sprites+$380       ;19 Guard West 1
 .byt >tol_sprites+$3b0       ;20 Guard South 0
 .byt >tol_sprites+$3e0       ;21 Guard South 1
 .byt >tol_sprites+$410       ;22 Guard East 0
 .byt >tol_sprites+$440       ;23 Guard East 1
 .byt >tol_sprites+$470       ;24 Orc North 0
 .byt >tol_sprites+$4a0       ;25 Orc North 1
 .byt >tol_sprites+$4d0       ;26 Orc West 0
 .byt >tol_sprites+$500       ;27 Orc West 1
 .byt >tol_sprites+$530       ;28 Orc South 0
 .byt >tol_sprites+$560       ;29 Orc South 1
 .byt >tol_sprites+$590       ;30 Orc East 0
 .byt >tol_sprites+$5c0       ;31 Orc East 1
 .byt >tol_sprites+$5f0       ;32 Rogue North 0
 .byt >tol_sprites+$620       ;33 Rogue North 1
 .byt >tol_sprites+$650       ;34 Rogue West 0
 .byt >tol_sprites+$680       ;35 Rogue West 1
 .byt >tol_sprites+$6b0       ;36 Rogue South 0
 .byt >tol_sprites+$6e0       ;37 Rogue South 1
 .byt >tol_sprites+$710       ;38 Rogue East 0
 .byt >tol_sprites+$740       ;39 Rogue East 1
 .byt >tol_sprites+$770       ;40 serf North 0
 .byt >tol_sprites+$7a0       ;41 serf North 1
 .byt >tol_sprites+$7d0       ;42 serf West 0
 .byt >tol_sprites+$800       ;43 serf West 1
 .byt >tol_sprites+$830       ;44 serf South 0
 .byt >tol_sprites+$860       ;45 serf South 1
 .byt >tol_sprites+$890       ;46 serf East 0
 .byt >tol_sprites+$8c0       ;47 serf East 1
 .byt >tol_sprites+$8e8       ;48 Asp North 0
 .byt >tol_sprites+$918       ;49 Asp North 1
 .byt >tol_sprites+$948       ;50 Asp West 0
 .byt >tol_sprites+$978       ;51 Asp West 1
 .byt >tol_sprites+$9a8       ;52 Asp South 0
 .byt >tol_sprites+$9d8       ;53 Asp South 1
 .byt >tol_sprites+$a08       ;54 Asp East 0
 .byt >tol_sprites+$a38       ;55 Asp East 1
 .byt >tol_sprites+$a68       ;56 Slime 0
 .byt >tol_sprites+$a98       ;57 Slime 1
 .byt >tol_sprites+$a68       ;58 Slime 0
 .byt >tol_sprites+$a98       ;59 Slime 1
 .byt >tol_sprites+$a68       ;60 Slime 0
 .byt >tol_sprites+$a98       ;61 Slime 1
 .byt >tol_sprites+$a68       ;62 Slime 0
 .byt >tol_sprites+$a98       ;63 Slime 1
 .byt >tol_sprites+$ab8       ;64 Guard Standing
 .byt >tol_sprites+$ae8       ;65 Death 0
 .byt >tol_sprites+$b30       ;66 Death 1
 .byt >tol_sprites+$b78       ;67 Death 2
 .byt >tol_sprites+$bc0       ;68 Death 3


creature_character_base	.byt 0

style_charposition_pattern_lo
 .byt <sbo_style_0,<sbo_style_1,<sbo_style_2,<sbo_style_3,<sbo_style_4,<sbo_style_5
 .byt <sbo_style_6,<sbo_style_7,<sbo_style_8,<sbo_style_9,<sbo_style_10
 .byt <sbo_style_11
style_charposition_pattern_hi
 .byt >sbo_style_0,>sbo_style_1,>sbo_style_2,>sbo_style_3,>sbo_style_4,>sbo_style_5
 .byt >sbo_style_6,>sbo_style_7,>sbo_style_8,>sbo_style_9,>sbo_style_10
 .byt >sbo_style_11
style_length	;-1
 .byt 5,5,5,5,5
 .byt 5,5,5,4,5
 .byt 4,3

;styles_data_as_sboffset
sbo_style_0
;111
;111
;000
 .byt 0,1,2
 .byt 43,44,45
sbo_style_1
;110
;111
;100
 .byt 0,1
 .byt 43,44,45
 .byt 86
sbo_style_2
;110
;110
;110
 .byt 0,1
 .byt 43,44
 .byt 86,87
sbo_style_3
;111
;110
;010
 .byt 0,1,2
 .byt 43,44
 .byt 87
sbo_style_4
;110
;111
;010
 .byt 0,1
 .byt 43,44,45
 .byt 87
sbo_style_5
;111
;011
;001
 .byt 0,1,2
 .byt 44,45
 .byt 88
sbo_style_6
;110
;110
;101
 .byt 0,1
 .byt 43,44
 .byt 86,88
sbo_style_7
;011
;111
;001
 .byt 1,2
 .byt 43,44,45
 .byt 88
sbo_style_8
;110
;110
;010
 .byt 0,1
 .byt 43,44
 .byt 87
sbo_style_9
;011
;111
;010
 .byt 1,2
 .byt 43,44,45
 .byt 87
sbo_style_10
;110
;110
;100
 .byt 0,1
 .byt 43,44
 .byt 86
sbo_style_11
;110
;110
;000
 .byt 0,1
 .byt 43,44








animate_creature_dying
	lda creature_health,x
	and #127
	cmp #04
	bcs wait_on_grave
acdye_01	inc creature_health,x
	rts
wait_on_grave
	cmp #10	;wait 7 game cycles by grave
	bcc acdye_01
;	jsr check_for_posessions
	jmp terminate_creature




;Navigate creature, try to use left/right/direct rules dependant on creature intellect
;CREATURE  	INTILLECT
;ghost		3
;skeleton		2
;Guard		2
;Orc		0
;Archer		3
;serf		0
;Monk		3
;Goo		1
;
;intillect levels...
;0 Direct path only
;1 observe left hand rule for 4 places
;2 observe left hand rule for 8 places
;3 observe left & right hand rule for 12 places
move_creature
	stx creature_index
	lda creature_health,x
	bmi animate_creature_dying
	lda creature_foe,x	;is creature approaching?
	bne hero_approach
;Otherwise just follow standard direct line (Forward until obstacle, turn left)
	lda #00
	sta creature_on_the_attack,x
mcre_02	ldy creature_dir,x
	lda creature_move_vector_lo,y
	sta mcre_01+1
	lda creature_move_vector_hi,y
	sta mcre_01+2
mcre_01	jmp $bf00



;Foe creature_activity
;128 Inactive/Dead
;0 Select Random X(1)/Y(2)
;1 Approach on Axis X, when reached, turn to 2, if unable to reach then 3
;2 Approach on Axis Y, when reached, turn to 1, if unable to reach then 3
;3 Opposite direction, to 4
;4-15 move, then 0
hero_approach
	lda #01
	sta creature_on_the_attack,x
	lda creature_activity,x
	and #15
	tay
	lda activity_vector_lo,y
	sta fcac_01+1
	lda activity_vector_hi,y
	sta fcac_01+2
fcac_01	jmp $bf00

activity_vector_lo
 .byt <fca_00,<fca_01,<fca_02,<fca_03
 .byt <fca_04_15,<fca_04_15,<fca_04_15,<fca_04_15
 .byt <fca_04_15,<fca_04_15,<fca_04_15,<fca_04_15
 .byt <fca_04_15,<fca_04_15,<fca_04_15,<fca_04_15
activity_vector_hi
 .byt >fca_00,>fca_01,>fca_02,>fca_03
 .byt >fca_04_15,>fca_04_15,>fca_04_15,>fca_04_15
 .byt >fca_04_15,>fca_04_15,>fca_04_15,>fca_04_15
 .byt >fca_04_15,>fca_04_15,>fca_04_15,>fca_04_15

fca_00	;0 Select Random X/Y
	lda via_t1cl
	and #01
	clc
	adc #01
	sta creature_activity,x
	rts

fca_01	lda creature_xh,x
	cmp hero_xh
	beq fcax_01
	bcc creature_moving_east
	bcs creature_moving_west
fcax_01	lda creature_xl,x
	cmp hero_xl
	beq fcax_02
	bcc creature_moving_east
	bcs creature_moving_west
fcax_02	lda #02
	sta creature_activity,x
	rts

fca_03	lda hero_dir
	sta creature_dir,x
	lda #04
	sta creature_activity,x
	rts

opposite_dir	;NWSE
 .byt 2,3,0,1

fca_04_15 jsr mcre_02
	inc creature_activity,x
	lda creature_activity,x
	cmp #16
	bcc fcat_01
	lda #00
	sta creature_activity,x
fcat_01	rts

creature_moving_west
	lda #01
	sta creature_dir,x
	jsr check_creature_west
	bcs turn_creature
	lda creature_xl,x
	sec
	sbc #01
	sta creature_xl,x
	lda creature_xh,x
	sbc #00
	sta creature_xh,x
	jmp invert_creature_frame

creature_moving_east
	lda #03
	sta creature_dir,x
	jsr check_creature_east
	bcs turn_creature
	lda creature_xl,x
	clc
	adc #01
	sta creature_xl,x
	lda creature_xh,x
	adc #00
	sta creature_xh,x
	jmp invert_creature_frame

fca_02	lda creature_yh,x
	cmp hero_yh
	beq fcay_01
	bcc creature_moving_south
	jmp creature_moving_north
fcay_01	lda creature_yl,x
	cmp hero_yl
	beq fcay_02
	bcc creature_moving_south
	jmp creature_moving_north
fcay_02	lda #01
	sta creature_activity,x
	rts


creature_moving_south
	lda #02
	sta creature_dir,x
	jsr check_creature_south
	bcs turn_creature
	lda creature_yl,x
	clc
	adc #01
	sta creature_yl,x
	lda creature_yh,x
	adc #00
	sta creature_yh,x
	jmp invert_creature_frame

turn_creature
	lda creature_on_the_attack,x
	beq turnc_01
	lda creature_activity,x
	cmp #04
	bcs turnc_01
	lda #03
	sta creature_activity,x
	rts
turnc_01	lda creature_dir,x
	clc
	adc #01
	and #03
	sta creature_dir,x
	rts

creature_moving_north
	lda #00
	sta creature_dir,x
	jsr check_creature_north
	bcs turn_creature
	lda creature_yl,x
	sec
	sbc #01
	sta creature_yl,x
	lda creature_yh,x
	sbc #00
	sta creature_yh,x
invert_creature_frame
	lda creature_frame,x
	eor #01
	sta creature_frame,x
	rts


;Check bg and other creatures
check_creature_west
	lda sb_x
	beq off_stage
	lda sb_lo	;a==lo y==hi
	sec
	sbc #01
	sta 00
	lda sb_hi
	sbc #00
	sta 01
	jmp check_sbnbb_vertical

;Check bg and other creatures
check_creature_south
	lda sb_y
	cmp #16
	bcs off_stage
	lda sb_lo	;a==lo y==hi
	clc
	adc #43*3
	sta 00
	lda sb_hi
	adc #00
	sta 01
	jmp check_sbnbb_horizontal

;Check bg and other creatures
check_creature_east
	lda sb_x
	cmp #40
	bcs off_stage
	lda sb_lo	;a==lo y==hi
	clc
	adc #03
	sta 00
	lda sb_hi
	adc #00
	sta 01
	jmp check_sbnbb_vertical

;Check bg and other creatures
check_creature_north
	lda sb_y
	beq off_stage
	lda sb_lo	;a==lo y==hi
	sec
	sbc #43
	sta 00
	lda sb_hi
	sbc #00
	sta 01
	jmp check_sbnbb_horizontal

off_stage	lda #128
	sta creature_activity,x
	rts
;check screen_buffer (sb_lo/sb_hi) horizontally for 3 positions (collision==0) for creature collision
;calculate same positions in bg_buffer and check background collision
check_sbnbb_horizontal
	stx creature_index
	ldy #02	;check creature/obstacle collision
csnbh_01	lda (00),y
	sty temp_03
	jsr check_collision
	ldy temp_03
	bcs csnbh_03
	dey
	bpl csnbh_01
	;now calc bg_buffer and check collision their (bg only)
	lda 00
	sec
	sbc #<screen_buffer-bg_buffer
	sta csnbh_05+1
	lda 01
	sbc #>screen_buffer-bg_buffer
	sta csnbh_05+2
	ldy #02
csnbh_05	ldx $bf00,y
	lda $0600,x
	and #%00111000
	cmp #%00001000
	bcs csnbh_03
	dey
	bpl csnbh_05
csnbh_03	ldx creature_index
	rts

check_sbnbb_vertical
	stx creature_index
	ldx #02	;check creature/obstacle collision
csnbv_01	ldy vertical_check_offset,x
	lda (00),y
	jsr check_collision
	bcs csnbv_03
	dex
	bpl csnbv_01
	;now calc bg_buffer and check collision their (bg only)
	lda 00
	sec
	sbc #<screen_buffer-bg_buffer
	sta csnbv_05+1
	lda 01
	sbc #>screen_buffer-bg_buffer
	sta csnbv_05+2
	ldx #02
	ldy vertical_check_offset,x
csnbv_05	lda $bf00,y
	sta csnbv_04+1
csnbv_04	lda $0600
	and #%00111000
	cmp #%00001000
	bcs csnbv_03
	dex
	bpl csnbv_05
csnbv_03	ldx creature_index
	rts

check_collision
	ldy #08
	sta 48000+40*25
	cmp #32	;bg collision
	bcc bg_collision
	cmp #96
	bcc csnbh_02
	cmp #102
	bcc sprite0_collision
	cmp #108
	bcc sprite1_collision
	cmp #114
	bcc sprite2_collision
	cmp #123
	bcc hero_collision
	cmp #126
	bcs weapon_collision
csnbh_02	rts

sprite0_collision
	ldy #17
	sty 48000+40*25
	ldy creature_index
	lda creature_foe,y
	beq s0col_01	;Attacking creature is harmless
	ldy #00
	lda creature_health
	bmi s0col_01
	dec creature_health
	bpl s0col_01
	lda #128
	sta creature_health
bg_collision
s0col_01	sec
	rts

sprite1_collision
	ldy #18
	sty 48000+40*25
	ldy creature_index
	lda creature_foe,y
	beq s1col_01	;Attacking creature is harmless
	ldy #01
	lda creature_health+1
	bmi s1col_01
	dec creature_health+1
	bpl s1col_01
	lda #128
	sta creature_health+1
s1col_01	sec
	rts

sprite2_collision
	ldy #19
	sty 48000+40*25
	ldy creature_index
	lda creature_foe,y
	beq s2col_01	;Attacking creature is harmless
	ldy #02
	lda creature_health+2
	bmi s2col_01
	dec creature_health+2
	bpl s2col_01
	lda #128
	sta creature_health+2
s2col_01	sec	;flag carry to change direction
	rts

hero_collision
	ldy #20
	sty 48000+40*25
	ldy creature_index
	lda creature_foe,y
	beq heroc_01	;Attacking creature is harmless
	dec hero_health
	bmi kill_hero
heroc_01	sec
	rts

weapon_collision
	ldy #21
	sty 48000+40*25
	ldy creature_index
	lda creature_health,y
	sec
	sbc #01
	sta creature_health,y
	rts
kill_hero
	lda #128
	sta hero_dying
	sec
	rts

hero_dying	.byt 0
;32-95	BG
;96-101	Sprite 0
;102-107	Sprite 1
;108-113	Sprite 2
;114-122	Hero
;123-125	Object dropped or Special Object
;126-127	Weapon Fire


;check screen_buffer (sb_lo/sb_hi) horizontally for 3 positions (collision==0) for creature collision
;calculate same positions in bg_buffer and check background collision

creature_move_vector_lo
 .byt <creature_moving_north,<creature_moving_west,<creature_moving_south,<creature_moving_east
creature_move_vector_hi
 .byt >creature_moving_north,>creature_moving_west,>creature_moving_south,>creature_moving_east

creature_activity	;Creature inactive is always +128
 .byt 128,128,128
creature_xl	;Absolute X position of creature
 .byt 0,0,0
creature_xh
 .byt 0,0,0
creature_yl         ;Absolute Y position of creature
 .byt 0,0,0
creature_yh
 .byt 0,0,0
creature_dir	;Creature Direction 0==west 1==south 2==east 3==north
 .byt 0,0,0
creature_health	;0-3 (+128==dead or death sequence)
 .byt 3,3,3
creature_foe	;0==Friend 1==Foe(Enemy)
 .byt 0,0,0
creature_frame	;Creature frame is either 0 or 1
 .byt 0,0,0
creature_base_frame ;The starting frame for the type of creature...
 .byt 0,0,0
;CREATURE  	Base Frame Number
;ghost
;skeleton
;Guard
;Orc
;Archer
;serf
;Monk
;Goo
creature_identity	;the actual creatures identity (0-15(HP)/16-31(LP)) depending on creature_hp
 .byt 0,0,0
creature_hp	;Specifies high (HP(1)) or Low (LP(0)) priority creature
 .byt 0,0,0
creature_on_the_attack
 .byt 0,0,0
creatures_posession	;Any important droppable object they have
 .byt 0,0,0
creature_index	.byt 0


init_new_creature	;Where x==new creature
	stx creature_index
	lda region_byte1
	and #15
	beq init_lp_creature	;No hp creature
	tay
	sty temp_01
	lda hp_creature_multiple,y
	bne apply_creature	;if multiple hp creatures
;One creature of this type only, so check if it already exists
	lda temp_01
	ldy other_creature0,x
	cmp creature_identity,y
	beq init_lp_creature
	ldy other_creature1,x
	cmp creature_identity,y
	beq init_lp_creature
;This creature is hp, only one and is not on yet, but check game-stats to see if it is still alive
	tay
	lda hp_creature_alive,y	;Table held in page 2, so return_to_tol will restore stats
	beq init_lp_creature
	jmp apply_creature
no_creature_here
	rts

;it is assumed that their will be multiples of all low priority (LP) creatures
init_lp_creature
	lda region_byte0
	and #15
	beq no_creature_here
	clc
	adc #16
	tay
;Apply this ceature identity(Y/,x)
apply_creature
;y==creature identity...
;	0 - NONE!!
;	1 - Wraith
;	2 - Guard
;	3 - Grey Abbot
;	4 - Advisor
;	5 - Duke
;	6 - Prince Regent
;	7 - Lyche
;	8 - Acolyte (Priests assistant)
;	9 - Noble
;	10- Black Asp
;	11- Archmage
;	12- Old Man
;	13- Prisoner
;	14- Woodsman
;	15  Thug
;	16 - NONE!!
;	17 - Ghost
;	18 - Skeleton
;	19 - Orc
;	20 - Rogue
;	21 - Peasant
;	22 - Serf
;	23 - Slime
;Creatures 24-31 are never seen (Inns)
;	24 - Bartender
;         25 - Prior
;         26-31 - Spare
	sty temp_01
	jsr position_new_creature	;if carry clear, x,y holds position and A holds dir
	bcs no_creature_here
	pha
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	txa
	ldx creature_index
	clc
	adc tx_lo	;sb's x-posl in map
	sta creature_xl,x
	lda tx_hi	;sb's x-posh in map
	adc #00
	sta creature_xh,x
	tya
	adc ty_lo	;sb's y-posl in map
	sta creature_yl,x
	lda ty_hi	;sb's y-posh in map
	adc #00
	sta creature_yh,x
	pla
	sta creature_dir,x
	lda #00
	sta creature_activity,x
	sta creature_frame,x
	ldy temp_01
	tya
	sta creature_identity,x
	lda identity_initial_health,y
	sta creature_health,x
	lda all_creatures_hate_me
	bne apcr_01
	lda identity_initial_foe,y
apcr_01	sta creature_foe,x
	lda identity_base_frame,y
	sta creature_base_frame,x
;the init_new_creature code must also search through the list of 16 objects
;to primarily look for an object that is required for this region area,
;and for the creature held in ls_creature, then deposit the object number (in B0-B3) in
;the creature_posession table, and reset ls_object_number to 128+object, Also set creature
;to higher health than the rest.
;	ldy #15
;apcr_03	lda ls_object_number,y
;	bmi apcr_02	;Creature has already picked up this object
;	lda creature_xh,x
;	sta temp_04
;	lda creature_yl,x
;	asl
;	lda creature_yh,x
;	rol
;	asl		;Now y shifted 0-3, need to shift again 4-7
;	asl
;	asl
;	asl
;	ora temp_04
;	cmp ls_region,y
;	bne apcr_02	;Object destined for different region
;	lda temp_01
;	cmp ls_creature,y
;	bne apcr_02	;Object destined for different creature
;	lda ls_object_number,y	;Assign object to creature
;	sta creature_posession,x
;	ora #128			;Mark object as picked up
;	sta ls_object_number,y
;	asl creature_health,x	;Adjust health of creature now holding object (*2)
;	rts
;apcr_02	dey
;	bpl apcr_03
	rts

;identity tables are indexed by Creature identity (0-15==HP / 16-31==LP)
identity_initial_health
 .byt 3                                 ;None
 .byt 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3	;HP Creatures
 .byt 3                                 ;None
 .byt 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3     ;LP Creatures
identity_initial_foe
 .byt 0
 .byt 1,0,1,0,0,0,1,1,0,1,0,0,0,0,1
 .byt 0
 .byt 1,1,1,1,0,0,1,0,0,0,0,0,0,0,0	;24-31 not currently used
identity_base_frame
 .byt 0	;None		Under Guise of -
 .byt 0	;Wraith             Under Guise of Ghost
 .byt 16	;Guard              Under Guise of Guard
 .byt 48	;Grey Abbot         Under Guise of Asp
 .byt 48	;Advisor            Under Guise of Asp
 .byt 48	;Duke               Under Guise of Asp
 .byt 48	;Prince             Under Guise of Asp
 .byt 40	;Lyche              Under Guise of Serf
 .byt 40	;Acolyte            Under Guise of Serf
 .byt 48	;Noble              Under Guise of Asp
 .byt 48	;Black Asp          Under Guise of Asp
 .byt 48	;Archmage           Under Guise of Asp
 .byt 40	;Old Man            Under Guise of Serf
 .byt 40	;Prisoner           Under Guise of Serf
 .byt 40	;Woodsman           Under Guise of Serf
 .byt 40	;Thug               Under Guise of Serf

 .byt 0	;None               Under Guise of -
 .byt 0	;Ghost              Under Guise of Ghost
 .byt 8	;Skeleton           Under Guise of Skeleton
 .byt 24	;Orc                Under Guise of Orc
 .byt 32	;Rogue              Under Guise of Rogue
 .byt 40	;Peasant            Under Guise of Serf
 .byt 40	;Serf               Under Guise of Serf
 .byt 56	;Slime              Under Guise of Slime
 .byt 0,0,0,0,0,0,0,0	;24-31 not currently used

hp_creature_multiple	;flag to say whether their are multiples of the high priority creature
 .byt 0,1,1,1,0,0,0,1,0,0,1,0,0,0,0,1
other_creature0
 .byt 1,0,0
other_creature1
 .byt 2,2,1

;The new creature will be always run on Facing the hero
position_new_creature
	ldy hero_dir	;NWSE
	lda creature_initside_vector_lo,y
	sta pncr_01+1
	lda creature_initside_vector_hi,y
	sta pncr_01+2
pncr_01	jmp $bf00

creature_initside_vector_lo
 .byt <locate_creature_north,<locate_creature_west,<locate_creature_south,<locate_creature_east
creature_initside_vector_hi
 .byt >locate_creature_north,>locate_creature_west,>locate_creature_south,>locate_creature_east

locate_creature_north
	jsr lcn_setup_tlbase
icn_horz	lda #00
	sta temp_02
lcn_rent	jsr search_9square
	bcs lcn_collision
	ldx temp_02
	ldy #00
	lda #02
	rts
lcn_collision
	inc 00
	bne icn_01
	inc 01
icn_01	inc 02
	bne icn_02
	inc 03
icn_02	inc temp_02
	lda temp_02
	cmp #41
	bcc lcn_rent
	rts
locate_creature_west
	jsr lcn_setup_tlbase
	jsr lcn_vert
	ldx #00
	rts
locate_creature_south
	lda #<screen_buffer+16*43
	sta 00
	lda #>screen_buffer+16*43
	sta 01
	lda #<bg_buffer+16*43
	sta 02
	lda #>bg_buffer+16*43
	sta 03
	jsr icn_horz
	ldy #16
	rts
locate_creature_east
	lda #<screen_buffer+40
	sta 00
	lda #>screen_buffer+40
	sta 01
	lda #<bg_buffer+40
	sta 02
	lda #>bg_buffer+40
	sta 03
lcn_vert	lda #00
	sta temp_02
lcv_rent	jsr search_9square
	bcs lcv_collision
	ldy temp_02
	ldx #40
	lda #01
	rts
lcv_collision
	lda #43
	jsr add_00
	lda #43
	jsr add_02
	inc temp_02
	lda temp_02
	cmp #17
	bcc lcv_rent
	rts

search_9square
	ldx #08
lcn_loop	ldy sb_offset,x
	lda (00),y
	cmp #96
	bcs lcn_exit
	lda (02),y
	sta s9s_01+1
s9s_01	lda $0600
	and #%00111000
	bne lcn_cxit
	dex
	bpl lcn_loop
	clc
lcn_exit	rts
lcn_cxit	sec
	rts

lcn_setup_tlbase
	lda #<screen_buffer
	sta 00
	lda #>screen_buffer
	sta 01
	lda #<bg_buffer
	sta 02
	lda #>bg_buffer
	sta 03
	rts

;check_creature_shot
;	lda weapon_activity+1	;Check if weapon already used
;	bpl
;	lda random_element		;Choose to fire at random intervals
;	cmp #200
;	bcc
;	lda creature_activity,x	;Check Rogue is chasing hero, not running around
;	cmp #03
;	bcs
;	ldy creature_identity,x	;Check if creature can shoot projectile
;	lda shoot_capability,y
;	beq
;	lda creature_xl,x		;Ensure creature is on same X or Y to hero
;	cmp hero_xl
;	bne ccsh_01
;	lda creature_xh,x
;	cmp hero_xh
;	beq ccsh_02
;ccsh_01	lda creature_yl,x
;	cmp hero_yl
;	bne
;	lda creature_yh,x
;	cmp hero_yh
;	bne
;ccsh_02
				;Ensure creature is at least 7 paces from hero
