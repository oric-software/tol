//Page 0 Assignments
;This sits in Top of Memory from $AB40 to $AC3F and sets up the default settings of zero
;page bytes

 .byt 0	;game_direction	.dsb 1
// Game terminated - Flags when a game is over
// 0   - Game Running
// 1   - Game Terminated (Reason is held in game_direction)
 .byt 0	;game_terminated	.dsb 1
// IRQ WorkSpaces
;IRQ General
 .byt 99	;irq_zero00	.dsb 1
 .byt 99	;irq_zero01	.dsb 1
 .byt 99	;irq_zero02	.dsb 1
 .byt 99	;irq_zero03	.dsb 1
 .byt 99	;irq_zero04	.dsb 1
 .byt 0	;irq_fracspeed	.dsb 1
;Random Number Generator
 .byt 99	;rnd_byte0		.dsb 1	;Random Seed 1
 .byt 99	;rnd_byte1		.dsb 1	;Random Seed 2
 .byt 99	;rnd_counter0	.dsb 1
 .byt 99	;rnd_counter1	.dsb 1
;Sound Effects
 .byt 99	;irq_nextbyte	.byt 0
;Animations
 .byt 0	;aniframe_index	.dsb 1
;Keyboard
 .byt 0	;key_register	.dsb 1
 .byt 99	;key_instance	.dsb 1
;Icon Glow
 .byt 0	;icg_glow_index	.dsb 1
;Candle Flame
 .byt 0	;candle_frame	.dsb 1
 .byt 0	;old_life_force	.dsb 1
 .byt 7	;flame_colour	.dsb 1
;Map Pixel
 .byt $a0	;hero_maploclo	.dsb 1
 .byt $00	;hero_maplochi       .dsb 1
 .byt 64	;hero_mappeek        .dsb 1
 .byt 8	;hero_mapbitpos      .dsb 1
 .byt 99	;old_hero_xl	.dsb 1
 .byt 99	;old_hero_yl	.dsb 1
;TOD
 .byt 0	;oneminute_fraclo	.dsb 1
 .byt 0	;oneminute_frachi	.dsb 1
 .byt 15	;sunmoon_lighting	.dsb 1	;Cool(ab5c)
 .byt 0	;sunmoon_screeny	.dsb 1
 .byt 45	;sunmoon_source_scan	.dsb 1
 .byt 45	;sunmoon_source_origin	.dsb 1
 .byt 0	;sunmoon_delay	.dsb 1
// Runtime WorkSpaces
;Game Arena
 .byt 0	;test_xl		.dsb 1
 .byt 0	;test_xh		.dsb 1
 .byt 0	;test_yl		.dsb 1
 .byt 0	;test_yh		.dsb 1
 .byt 0	;test_tempx	.dsb 1
 .byt 0	;test_tempy	.dsb 1
 .byt 0	;test_tempa	.dsb 1
 .byt 0	;ref_test_xl         .dsb 1
 .byt 0	;ref_test_xh	.dsb 1
 .byt 0	;zero_00		.dsb 1
 .byt 0	;zero_01		.dsb 1
 .byt 0	;zero_02		.dsb 1
 .byt 0	;zero_03		.dsb 1
 .byt 0	;zero_04		.dsb 1
 .byt 0	;zero_05		.dsb 1
 .byt 0	;zero_06		.dsb 1
 .byt 0	;zero_07		.dsb 1
 .byt 0	;ycount		.dsb 1
// Hero bytes
 .byt 31	;life_force	.dsb 1
 .byt 0	;life_forcei	.dsb 1	;(31-life_force)
 .byt 0	;hero_gold0	.dsb 1	;MSB
 .byt 5	;hero_gold1	.dsb 1
 .byt 0	;hero_gold2	.dsb 1	;LSB
 .byt 0	;hero_direction	.dsb 1
 .byt 0	;hero_hit		.dsb 1
 .byt 0	;hero_disguise	.dsb 1
 .byt 0	;hero_anim_frame	.dsb 1
 .byt 2	;hero_rations	.dsb 1
 .byt 0	;hero_moving	.dsb 1
 .byt 0	;clasp_posessed_flag	.dsb 1
// Projectile variables
 .byt 0	;new_projectile_x	.dsb 1
 .byt 0	;new_projectile_y	.dsb 1
 .byt 0	;ss_tempx		.dsb 1
 .byt 0	;posession_price	.dsb 2
 .byt 0	;posession_price	.dsb 2
//
 .byt 0	;message_buffer_index	.dsb 1
 .byt 0	;tol_text_index		.dsb 1
 .byt 0	;last_space_offset		.dsb 1
// Hero frame and location is held together with other sprites for the is_collision routine
// This reduces memory and increases speed
 .byt 0	;hero_frame	.dsb 1
 .byt 0	;creature_frame	.dsb 3
 .byt 0	;creature_frame	.dsb 3
 .byt 0	;creature_frame	.dsb 3
 .byt <1326	;hero_xl		.dsb 1	;Cool(ab8b)
 .byt 0	;creature_xl	.dsb 3
 .byt 0	;creature_xl	.dsb 3
 .byt 0	;creature_xl	.dsb 3
 .byt >1326	;hero_xh		.dsb 1
 .byt 0	;creature_xh	.dsb 3
 .byt 0	;creature_xh	.dsb 3
 .byt 0	;creature_xh	.dsb 3
 .byt <1100	;hero_yl		.dsb 1
 .byt 0	;creature_yl	.dsb 3
 .byt 0	;creature_yl	.dsb 3
 .byt 0	;creature_yl	.dsb 3
 .byt >1100	;hero_yh		.dsb 1
 .byt 0	;creature_yh	.dsb 3
 .byt 0	;creature_yh	.dsb 3
 .byt 0	;creature_yh	.dsb 3
// Other Hero variables
 .byt 0	;hero_frac		.dsb 1
// Sample_xx bytes used in is_collision as final single character location
// This is used both for object, creature and hero collision detections
 .byt 0	;sample_xl 	.dsb 1
 .byt 0	;sample_xh 	.dsb 1
 .byt 0	;sample_yl 	.dsb 1
 .byt 0	;sample_yh 	.dsb 1
// Creature stuff
 .byt 0	;creature_repeatrotate_bitmap	.dsb 3
 .byt 0	;creature_repeatrotate_bitmap	.dsb 3
 .byt 0	;creature_repeatrotate_bitmap	.dsb 3
 .byt 0	;creature_counter		.dsb 1
 .byt 0	;creature_screen_x	.dsb 3
 .byt 0	;creature_screen_x	.dsb 3
 .byt 0	;creature_screen_x	.dsb 3
 .byt 0	;creature_screen_y	.dsb 3
 .byt 0	;creature_screen_y	.dsb 3
 .byt 0	;creature_screen_y	.dsb 3
;Sprite Method
; 0) Normal    - (background AND mask) OR bitmap
; 1) Inverse   - (mask EOR 63) OR background
; 2) Ghost     - bitmap OR background
; 3) Cloak     - mask AND background
; 4) Invisible - (background AND mask) OR (bitmap AND BG)
 .byt 0	;sprite_method	.dsb 1
//
 .byt 0	;ic_x		.dsb 1
 .byt 0	;ic_y                .dsb 1
 .byt 0	;ic_i                .dsb 1
//
 .byt 0	;extracted_xl        .dsb 1
 .byt 0	;extracted_xh        .dsb 1
 .byt 0	;extracted_yl        .dsb 1
 .byt 0	;extracted_yh        .dsb 1
 .byt 0	;ScreenNumber        .dsb 1
 .byt 0	;MapNumber		.dsb 1
 .byt 0	;map_lo              .dsb 1
 .byt 0	;map_hi              .dsb 1
 .byt 0	;map_x               .dsb 1
 .byt 0	;BlockNumber         .dsb 1
 .byt 0	;block_lo            .dsb 1
 .byt 0	;block_hi            .dsb 1
 .byt 0	;block_x             .dsb 1
 .byt 0	;CharacterNumber     .dsb 1
 .byt 0	;temp_code		.dsb 1
 .byt 0	;base_pattern	.dsb 1
 .byt 0	;character_index	.dsb 1
 .byt 0	;temp_count	.dsb 1
 .byt 0	;temp_01		.dsb 1
 .byt 0	;temp_02		.dsb 1
 .byt 0	;chitchat_number	.dsb 1
 .byt 0	;temp_03		.dsb 1
 .byt 0	;temp_04		.dsb 1
 .byt 0	;temp_a              .dsb 1
 .byt 0	;temp_x		.dsb 1
 .byt 0	;temp_y              .dsb 1
;Creature Bytes
 .byt 0	;tsmap_x		.dsb 1
 .byt 0	;tsmap_y		.dsb 1
 .byt 0	;sb_extremeWl        .dsb 1
 .byt 0	;sb_extremeWh        .dsb 1
 .byt 0	;sb_extremeNl        .dsb 1
 .byt 0	;sb_extremeNh        .dsb 1
 .byt 0	;sb_extremeEl        .dsb 1
 .byt 0	;sb_extremeEh        .dsb 1
 .byt 0	;sb_extremeSl        .dsb 1
 .byt 0	;sb_extremeSh        .dsb 1
;Icon Menu
 .byt 0	;icon_pointer	.dsb 1
;Option List
 .dsb 20,0	;optionbuffer	.dsb 20
 .byt 0	;temp_index	.dsb 1
 .byt 0	;source_index	.dsb 1
 .byt 0	;ot_cursor_x	.dsb 1
 .byt 0	;ot_cursor_y	.dsb 1
 .byt 0	;selectedcreature	.dsb 1
 .byt 0	;selectedsubject	.dsb 1
 .byt 0	;selectedmatter	.dsb 1
;Text Window
 .byt 0	;message_number	.dsb 1
 .byt 0	;wt_temp01		.dsb 1
 .byt 0	;wt_temp02		.dsb 1
 .byt 0	;wt_cursor_x	.dsb 1
 .byt 0	;wt_cursor_y	.dsb 1
 .dsb 6,0	;formed_numeric_string	.dsb 6
;
 .byt 0	;xtemp_01		.dsb 1
 .byt 0	;xtemp_02		.dsb 1
;Sound Effect Variables
 .byt 0	;sfx_envelope_behaviour_flags	.dsb 1
 .byt 0	;sfx_envelope_tables_index	.dsb 1
 .byt 0	;sfx_event_register		.dsb 1
 .byt 0	;sfx_temp_01		.dsb 1
 .byt 0	;sfx_temp_02		.dsb 1
 .byt 0	;sfx_env_count		.dsb 1
 .byt 128	;rrb_register
 .byt 0	;rrb_bits                      .dsb 1
 .byt 0	;rrb_area			.dsb 1
 .byt 0	;rb_index			.dsb 1
 .byt 0	;random_byte		.dsb 1
 .byt 0,0,0	;sfx_effect_number		.dsb 3
 .byt 0,0,0	;sfx_event_index		.dsb 3
 .byt 0,0,0	;sfx_event_period_lo		.dsb 3
 .byt 0,0,0	;sfx_event_period_hi		.dsb 3
 .byt 0,0,0	;sfx_trigger		.dsb 3
 .byt 0		;sfx_zero_00		.dsb 1
 .byt 0		;sfx_zero_01		.dsb 1


;Current Region Variables
 .byt 0	;previous_sampled_region	.dsb 1
;
 .byt 0	;foe_parrallel		.dsb 1
 .byt 0	;jcb_test01	.dsb 1
 .byt 0	;jcb_test02	.dsb 1

 .dsb 37,255

