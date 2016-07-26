// TOL Driver

#define	HIRES		$a000
#define	BackgroundBuffer	$ab40
#define	ScreenBuffer	$ae91 // At Start, holds page 0 and 2 memory
#define	StdCharset	$b500
#define	ScreenStart	$bce8
#define	via_t1ll		$0306
#define	via_t1lh            $0307

#include "ZP_Reference.s"


          .text

*=$500

	jmp start	//
#include "Data.s"	// Data and Tables for TOL Game

start     jsr initialise_game

.(
loop1	jsr manage_hero	;and scroll bg
	jsr background2screenbuffer
	jsr calculate_screen_bounds
	jsr plot_ground_Items
	jsr plot_hero
	jsr process_creatures
	jsr process_projectiles
	jsr plotColourColumn
	jsr screenbuffer2screen
	jsr sunNmoon_scroll
	jsr examine_region
	lda game_terminated
	beq loop1
	rts
.)

calculate_screen_bounds
	// Used by process_creatures and process_ground_items
	lda hero_xl
	sec
	sbc #19
	sta sb_extremeWl
	lda hero_xh
	sbc #00
	sta sb_extremeWh
	lda hero_yl
	sec
	sbc #9
	sta sb_extremeNl
	lda hero_yh
	sbc #00
	sta sb_extremeNh
	rts

plot_hero	ldy hero_frame	;frame number
	ldx #120		;sprite character number
	lda #<$b027	;sbuffer loc
	sta zero_00
	lda #>$b027
	sta zero_01
	lda hero_inverse
	sta sprite_method
	jsr plot_sprite
	lda #00
	sta hero_inverse
	rts



#define	game_hero	$b811

initialise_game
	;Copy Hero Pattern accross
	ldx game_hero
	ldy #15
.(
loop1	lda knight_pattern_number,x
	sta pattern_number,y
	dex
	dey
	bpl loop1
.)
	jsr wipe_icon_cursor
	// Setup page 0 and 2 and redirect irq (But not enabled until end of this routine)
	jsr relocate_page2N0_code
	// Create Exclusion Mask over the memory occupied by 'page 2 code'
	jsr create_exclusion_mask
	// Copy Charset 0
;	ldx #00
;.(
;loop1	lda character_set0,x
;	sta $b500,x
;	lda character_set0+256,x
;	sta $b600,x
;	dex
;	bne loop1
;.)

	// Set Life
;	lda #128
;	sta effect_ornament_index
;	sta effect_ornament_index+1
;	sta effect_ornament_index+2
;	sta effect_sample_index
;	sta effect_sample_index+1
;	sta effect_sample_index+2
;	lda #0
;	sta foot_interleave
;	sta creature_repeatrotate_bitmap
;	sta creature_repeatrotate_bitmap+1
;	sta creature_repeatrotate_bitmap+2
;	sta icg_glow_index
;	sta irq_fracspeed
;	sta old_life_force
;	sta candle_frame
;	sta game_terminated
;	lda #7
;	sta flame_colour
;	lda #31
; 	sta life_force
;	lda #45
;	sta sunmoon_source_origin
;	sta sunmoon_source_scan
;         lda #15
;         sta sunmoon_lighting
;         lda #00
;         sta sunmoon_screeny
;         sta key_register
;         sta aniframe_index
;         sta wt_cursor_x
;         sta wt_cursor_y
;         sta hero_disguise
;         ;// Setup hero start position
;         lda #<1326	;$f0
;         sta hero_xl
;         lda #>1326	;$07
;         sta hero_xh
;         lda #<1100	;$57
;         sta hero_yl
;         lda #>1100	;$05
;         sta hero_yh
;         lda #00
;         sta clasp_posessed_flag
;         sta hero_direction
;         sta hero_hit
;         sta hero_anim_frame
;         // Set initial maploc info
;         lda #$a0
;         sta hero_maploclo
;         lda #$00
;         sta hero_maplochi
;         lda #64
;         sta hero_mappeek
;         lda #08
;         sta hero_mapbitpos
;         lda #00
;         sta hero_gold0
;         sta hero_gold2
;         lda #05
;         sta hero_gold1
;         lda #2
;         sta hero_rations

	// Slow down irq
	lda #<30000
	sta via_t1ll
	lda #>30000
	sta via_t1lh
	// The refresh process takes about 3 seconds
;	lda #17
;	sta $bb80
	// Refresh buffers
	JSR background_refresh
	// Clear text and option windows
	jsr clear_text_window
	// Display welcome Message
	lda #230	;A == Message number
	jsr message2window
	// Clear Page icon
	lda #32
	ldx #20
	ldy #7
	jsr plot_window_characteratxy
	// Re-enable interrupts
	cli
	// Because we may load from tape, this cannot be removed
	lda #31
	sta $bb80
	rts

relocate_page2N0_code
	sei
	ldx #00
.(
loop1	lda exclusion_mask,x
	sta $0200,x
	lda $AB40,x	;page0code,x
	sta 00,x
	lda character_set0,x
	sta $b500,x
	lda character_set0+256,x
	sta $b600,x
	inx
	bne loop1
.)
	rts

;#include "test_display.s"	;Displayed bigmap x/y on Return Key
#include "Screen_management.s"          ;Routines to display the Map on the Game Arena
#include "plot_sprite.s"		;Plot Hero or Creature
#include "hero_code.s"		;Control Hero Movement
#include "Map.s"			;Graphic Map related routines
#include "tolsprites.txt"		;Sprite Bitmap/Mask Data
#include "sprite_patterns.s"		;Patterns for all sprites
#include "map_display.s"		;Display Hero on map
#include "irq_handler.s"		;Handles all irq stuff (Temp here, should finally go in sbuffer)
#include "tol_text.s"		;Text Data
#include "..\images\tolwinchs.s"	;Text Window CHS
#include "icon_handler.s"		;Control Icon Selection
#include "Options_window_handler.s"	;Control Option List Selection
#include "animations.s"		;Control Game arena Animations
#include "text_window_handler.s"	;Display window text
#include "candle_handler.s"		;Control and refresh Candle Animation
#include "speak_icon_selected.s"	;Called when Icon 'Mouth' Selected
#include "examine_icon_selected.s"	;Called when Icon 'Eye' Selected
#include "inventory_icon_selected.s"	;Called when Icon 'Swag Bag' Selected
#include "Hand_icon_selected.s"	;Called when Icon 'Hand' Selected
#include "sprite_code.s"		;Creature Code
#include "..\tolutilities\sfx_tables.s"	;Sound Effect Tables
#include "..\tolutilities\sfx_driver.s"	;Sound Effect Code
#include "..\tolutilities\sfx_data.s"	;Sound Effect Data
#include "dropped_item_handler.s"	;Handles items dropped and items on ground
#include "Projectile_code.s"		;Handle Projectiles
#include "lighting_control.s"		;Handle Messaging and dynamic lighting for Time Of Day
#include "underworld_switches.s"	;Handle Toggling underground Beam Gates
#include "create_exclusion_data.s"	;Create exclusion mask over page 2 temp memory
#include "life_control.s"		;Handle Rations and life force
#include "regional_sfx.s"		;Regional SFX control code
end_of_code
