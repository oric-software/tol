          .zero

// First half of zero Page MAY BE reserved for Fast fetch_Character Routine
*=$00
// Two Main areas
//  1) IRQ Workspace
//  2) Runtime Workspace
// IRQ Workspace
//  IRQ General		(irq_)
//  Random Number Generator	(rnd_)
//  Sound Effects		(sfx_)
//  Animations		(ani_)
//  Keyboard		(key_)
//  Icon Glow		(icg_)
//  Candle Flame		(cfl_)
//  Map Pixel		(mpx_)
//  TOD			(tod_)
// Runtime Workspace
//  Game Arena		(gma_)
//  Icon Menu 		(icm_)
//  Options		(opt_)
//  Text Window		(txw_)

// Game General
// Game Direction - Defines where the game should go after a game termination
// 0   - Game Over
// 1   - Game Completed
// 128 - Save Game
game_direction	.dsb 1
// Game terminated - Flags when a game is over
// 0   - Game Running
// 1   - Game Terminated (Reason is held in game_direction)
game_terminated	.dsb 1
// IRQ WorkSpaces
;IRQ General
irq_zero00	.dsb 1
irq_zero01	.dsb 1
irq_y_count
irq_zero02	.dsb 1
irq_current_y
irq_zero03	.dsb 1
irq_zero04	.dsb 1
irq_fracspeed	.dsb 1
;Random Number Generator
rnd_byte0		.dsb 1	;Random Seed 1
rnd_byte1		.dsb 1	;Random Seed 2
rnd_counter0	.dsb 1
rnd_counter1	.dsb 1
;Sound Effects
irq_nextbyte	.byt 0
;Animations
aniframe_index	.dsb 1
;Keyboard
key_register	.dsb 1
key_instance	.dsb 1
;Icon Glow
icg_glow_index	.dsb 1
;Candle Flame
candle_frame	.dsb 1
old_life_force	.dsb 1
flame_colour	.dsb 1
;Map Pixel
hero_maploclo	.dsb 1
hero_maplochi       .dsb 1
hero_mappeek        .dsb 1
hero_mapbitpos      .dsb 1
old_hero_xl	.dsb 1
old_hero_yl	.dsb 1
;TOD
oneminute_fraclo	.dsb 1
oneminute_frachi	.dsb 1
sunmoon_lighting	.dsb 1
sunmoon_screeny	.dsb 1
sunmoon_source_scan	.dsb 1
sunmoon_source_origin	.dsb 1
sunmoon_delay	.dsb 1
// Runtime WorkSpaces
;Game Arena
zero_list	;Used in USE whiteout (4 bytes)
test_xl		.dsb 1
test_xh		.dsb 1
test_yl		.dsb 1
test_yh		.dsb 1
test_tempx	.dsb 1
test_tempy	.dsb 1
test_tempa	.dsb 1
ref_test_xl         .dsb 1
ref_test_xh	.dsb 1
zero_00		.dsb 1
zero_01		.dsb 1
zero_02		.dsb 1
zero_03		.dsb 1
zero_04		.dsb 1
zero_05		.dsb 1
zero_06		.dsb 1
zero_07		.dsb 1
ycount		.dsb 1
// Hero bytes
life_force	.dsb 1
life_forcei	.dsb 1	;(31-life_force)
hero_gold0	.dsb 1	;MSB
hero_gold1	.dsb 1
hero_gold2	.dsb 1	;LSB
hero_direction	.dsb 1
hero_hit		.dsb 1
hero_disguise	.dsb 1
hero_anim_frame	.dsb 1
hero_rations	.dsb 1
hero_moving	.dsb 1
clasp_posessed_flag	.dsb 1
// Projectile variables
new_projectile_x	.dsb 1
new_projectile_y	.dsb 1
// Speak stuff
ss_tempx		.dsb 1
posession_price	.dsb 2
//
message_buffer_index	.dsb 1
tol_text_index		.dsb 1
last_space_offset		.dsb 1
// Hero frame and location is held together with other sprites for the is_collision routine
// This reduces memory and increases speed
hero_frame	.dsb 1
creature_frame	.dsb 3
hero_xl		.dsb 1
creature_xl	.dsb 3
hero_xh		.dsb 1
creature_xh	.dsb 3
hero_yl		.dsb 1
creature_yl	.dsb 3
hero_yh		.dsb 1
creature_yh	.dsb 3
// Other Hero variables
hero_frac		.dsb 1
// Sample_xx bytes used in is_collision as final single character location
// This is used both for object, creature and hero collision detections
sample_xl 	.dsb 1
sample_xh 	.dsb 1
sample_yl 	.dsb 1
sample_yh 	.dsb 1
// Creature stuff
creature_repeatrotate_bitmap	.dsb 3
creature_counter		.dsb 1
creature_screen_x	.dsb 3
creature_screen_y	.dsb 3
;Sprite Method
; 0) Normal    - (background AND mask) OR bitmap
; 1) Inverse   - (mask EOR 63) OR background
; 2) Ghost     - bitmap OR background
; 3) Cloak     - mask AND background
; 4) Invisible - (background AND mask) OR (bitmap AND BG)
sprite_method	.dsb 1
//
ic_x		.dsb 1
ic_y                .dsb 1
ic_i                .dsb 1
//
extracted_xl        .dsb 1
extracted_xh        .dsb 1
extracted_yl        .dsb 1
extracted_yh        .dsb 1
ScreenNumber        .dsb 1
MapNumber		.dsb 1
map_lo              .dsb 1
map_hi              .dsb 1
map_x               .dsb 1
BlockNumber         .dsb 1
block_lo            .dsb 1
block_hi            .dsb 1
block_x             .dsb 1
CharacterNumber     .dsb 1
tempsub
temp_code		.dsb 1
pattern_index
base_pattern	.dsb 1
character_index	.dsb 1
temp_count	.dsb 1
temp_01		.dsb 1
temp_02		.dsb 1
chitchat_number	.dsb 1
creatures_offset	;Used in speak_icon chosen when buying object
temp_03		.dsb 1
hero_x
temp_04		.dsb 1
temp_a              .dsb 1
temp_x		.dsb 1
temp_y              .dsb 1
;Creature Bytes
tsmap_x		.dsb 1
tsmap_y		.dsb 1
sb_extremeWl        .dsb 1
sb_extremeWh        .dsb 1
sb_extremeNl        .dsb 1
sb_extremeNh        .dsb 1
sb_extremeEl        .dsb 1
sb_extremeEh        .dsb 1
sb_extremeSl        .dsb 1
sb_extremeSh        .dsb 1
;Icon Menu
icon_pointer	.dsb 1
;Option List
optionbuffer	.dsb 20
temp_index	.dsb 1
source_index	.dsb 1
ot_cursor_x	.dsb 1
ot_cursor_y	.dsb 1
selectedcreature	.dsb 1
selectedsubject	.dsb 1
selectedmatter	.dsb 1
;Text Window
message_number	.dsb 1
wt_temp01		.dsb 1
wt_temp02		.dsb 1
wt_cursor_x	.dsb 1
wt_cursor_y	.dsb 1
formed_numeric_string	.dsb 6
;
xtemp_01		.dsb 1
xtemp_02		.dsb 1
;Sound Effect Variables

sfx_envelope_behaviour_flags	.dsb 1
sfx_envelope_tables_index	.dsb 1
sfx_event_register		.dsb 1
sfx_temp_01		.dsb 1
sfx_temp_02		.dsb 1
sfx_env_count		.dsb 1
rrb_register		.dsb 1
rrb_bits                      .dsb 1
rrb_area			.dsb 1
rb_index			.dsb 1
random_byte		.dsb 1
sfx_effect_number		.dsb 3
sfx_event_index		.dsb 3
sfx_event_period_lo		.dsb 3
sfx_event_period_hi		.dsb 3
sfx_trigger		.dsb 3
sfx_zero_00		.dsb 1
sfx_zero_01		.dsb 1

;Current Region Variables
previous_sampled_region	.dsb 1
;
foe_parrallel		.dsb 1
jcb_test01	.dsb 1
jcb_test02	.dsb 1

_ZP_END_


