// Tables for TOL Game

// $503
;spare now
// This table determines whether any of the 63 characters have a second character set
// or whether the upper character range is just used for 'same character, different colour'
// scenario.
second_set
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,128,0,0,0,128,0
 .byt 128,128,128,0,128,128,128,128,128,128,128,128,128,128,128,128
 .byt 128,128,128,128,128,128,128,128,128,128,128,0,0,128,128
 .byt 128,128,128,128	;Last 4 for dropped lp items (160-163)

// $542
character_attribute_table	// 160 Bytes
#include "..\MapBinaries\tol04col.txt" // Mininote tol04 on cbmtext.dsk
// $5E2
// Spare
 .dsb 22,0

character_set0	// 512 Bytes($600-7FF)
    .byt  $36,$30,$36,$06,$36,$30,$36,$06,$16,$12,$04,$26,$16,$22,$1c,$00
    .byt  $37,$1d,$16,$00,$3a,$1f,$25,$00,$32,$34,$36,$16,$26,$36,$36,$36
    .byt  $0e,$26,$36,$00,$2a,$2c,$0e,$00,$3e,$3e,$1c,$00,$37,$37,$23,$00
    .byt  $36,$0e,$36,$30,$36,$0e,$36,$30,$2a,$06,$2a,$16,$2e,$16,$3e,$00
    .byt  $10,$08,$27,$10,$08,$06,$01,$00,$20,$18,$04,$22,$21,$11,$11,$11
    .byt  $36,$30,$36,$06,$36,$30,$36,$06,$26,$10,$24,$12,$04,$22,$10,$02
    .byt  $3e,$3b,$1f,$36,$37,$3e,$2f,$3d,$15,$02,$2f,$2b,$36,$13,$07,$15
    .byt  $1f,$24,$2f,$02,$37,$19,$2b,$00,$37,$25,$3a,$10,$3c,$09,$3e,$00
    .byt  $00,$3d,$00,$34,$01,$26,$0e,$30,$00,$20,$30,$3a,$3a,$3a,$3a,$3a
    .byt  $00,$00,$00,$10,$10,$14,$14,$14,$3a,$1a,$2f,$00,$3a,$1f,$25,$00
    .byt  $14,$15,$3f,$00,$1b,$3f,$1a,$00,$12,$24,$36,$16,$16,$16,$16,$16
    .byt  $12,$14,$06,$06,$16,$16,$16,$16,$2a,$10,$20,$10,$20,$00,$20,$00
    .byt  $3f,$10,$3f,$08,$3f,$04,$3f,$00,$17,$2d,$36,$30,$13,$25,$36,$36
    .byt  $3b,$13,$0e,$00,$06,$03,$02,$00,$26,$26,$0c,$20,$27,$17,$33,$00
    .byt  $29,$09,$28,$20,$29,$0b,$2b,$20,$2a,$08,$2a,$22,$2a,$08,$2a,$22
    .byt  $20,$20,$30,$30,$34,$14,$26,$36,$00,$32,$06,$10,$36,$0e,$36,$30
    .byt  $00,$1b,$20,$26,$28,$09,$2a,$22,$2a,$15,$22,$15,$2a,$15,$28,$15
    .byt  $2a,$35,$2e,$15,$2a,$1d,$2a,$15,$2e,$35,$2a,$1d,$2a,$17,$3a,$15
    .byt  $0a,$35,$1a,$31,$9c,$b7,$ba,$1f,$2a,$15,$28,$10,$20,$00,$20,$00
    .byt  $22,$00,$00,$00,$00,$00,$00,$00,$00,$30,$1a,$30,$9c,$b6,$ba,$1f
    .byt  $1e,$21,$1e,$37,$28,$07,$1e,$2f,$2a,$14,$21,$14,$22,$08,$20,$10
    .byt  $2a,$11,$04,$00,$00,$00,$00,$00,$2a,$10,$20,$10,$20,$00,$20,$00
    .byt  $00,$00,$20,$00,$20,$10,$28,$14,$15,$17,$1b,$0e,$0b,$01,$02,$01
    .byt  $00,$01,$04,$0b,$0a,$19,$07,$15,$3b,$2f,$3d,$1b,$3d,$2b,$1e,$27
    .byt  $1e,$15,$0f,$09,$2d,$07,$23,$10,$2a,$15,$0a,$0d,$06,$05,$02,$01
    .byt  $2f,$2d,$1f,$37,$1e,$3d,$32,$05,$20,$34,$20,$35,$18,$15,$2e,$11
    .byt  $05,$05,$00,$00,$05,$01,$01,$00,$1f,$0f,$07,$05,$05,$05,$05,$05
    .byt  $12,$24,$36,$36,$16,$26,$36,$36,$00,$00,$00,$01,$00,$01,$02,$15
    .byt  $26,$10,$24,$12,$04,$22,$10,$02,$01,$1f,$1f,$1f,$1f,$1f,$1f,$3f
    .byt  $2a,$05,$02,$01,$02,$01,$00,$01,$00,$1b,$00,$2e,$00,$1b,$00,$00
    .byt  $00,$1e,$1a,$1c,$1a,$14,$1a,$00,$20,$08,$20,$14,$20,$08,$20,$10
    .byt  $28,$15,$2a,$1d,$2a,$15,$2a,$15,$00,$00,$00,$00,$00,$00,$00,$00
character_set1	// 512 Bytes($800-9FF)
    .byt  $31,$23,$07,$0f,$1f,$1f,$3e,$3c,$37,$37,$37,$35,$32,$30,$21,$02
    .byt  $34,$20,$00,$00,$01,$00,$01,$0b,$2a,$04,$2a,$11,$2a,$04,$2a,$11
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$3f,$3f,$3f,$3d,$3a,$30,$21,$02
    .byt  $63,$31,$38,$bc,$be,$fe,$df,$0f,$f7,$ff,$db,$cf,$c5,$43,$31,$18
    .byt  $3f,$1d,$2e,$3b,$2d,$37,$1f,$2f,$25,$12,$29,$32,$29,$32,$25,$33
    .byt  $2e,$1d,$27,$3e,$3d,$2b,$36,$1f,$3f,$3e,$3b,$2f,$33,$3f,$1d,$37
    .byt  $00,$00,$02,$00,$24,$00,$08,$00,$2a,$06,$2a,$16,$2e,$16,$3e,$00
    .byt  $ce,$cf,$e7,$cb,$f5,$7a,$39,$1c,$22,$00,$08,$00,$22,$00,$08,$00
    .byt  $0f,$23,$11,$09,$24,$00,$22,$35,$20,$28,$2a,$09,$2a,$29,$2a,$2b
    .byt  $00,$10,$15,$32,$15,$33,$15,$3f,$00,$08,$2a,$19,$2a,$39,$2a,$3f
    .byt  $30,$34,$35,$14,$25,$34,$35,$35,$00,$04,$15,$2c,$15,$3c,$15,$2a
    .byt  $00,$02,$00,$2a,$10,$2a,$00,$22,$00,$02,$22,$00,$08,$04,$2e,$00
    .byt  $00,$00,$00,$00,$00,$20,$1a,$00,$3e,$09,$3d,$10,$39,$27,$35,$00
    .byt  $00,$00,$3e,$04,$08,$10,$3e,$00,$24,$12,$09,$24,$12,$09,$24,$00
    .byt  $1f,$38,$17,$1f,$07,$38,$3e,$18,$3e,$07,$3a,$3e,$18,$07,$1f,$06
    .byt  $00,$00,$00,$00,$3f,$00,$00,$3f,$00,$10,$15,$12,$15,$13,$15,$17
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$12,$00,$12,$00,$12,$00,$12
    .byt  $17,$31,$24,$0a,$24,$11,$25,$00,$10,$38,$10,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$28,$30,$02,$2e,$08,$16,$16,$07,$18,$17,$17,$37,$3f,$38,$2b
    .byt  $38,$06,$3a,$3e,$3f,$3f,$07,$3d,$00,$17,$33,$0d,$03,$1c,$1e,$1e
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $00,$00,$00,$00,$00,$00,$00,$00,$00,$16,$0a,$16,$0a,$16,$1e,$00
    .byt  $2a,$05,$02,$01,$02,$01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00
    .byt  $1e,$06,$3a,$3c,$0c,$30,$3c,$30,$00,$00,$00,$00,$00,$00,$00,$00



ascii_character_address_lo	// 64 Bytes
 .byt 000,008,016,024,032,040,048,056,064,072,080,088,096,104,112,120
 .byt 128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248
 .byt 000,008,016,024,032,040,048,056,064,072,080,088,096,104,112,120
 .byt 128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248

actual_character_code	// 160 Bytes
 // Attributes
 .byt 0,1,2,3,4,5,6,7
 .byt 8,9,10,11,12,13,14,15
 .byt 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 // ASCII Codes for 32-95 (64)
 .byt 32,33,34,35,36,37,38,39,40+128,41+128,42,43,44,45,46,47
 .byt 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
 .byt 80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,8
 // ASCII Codes for 96-159 (64)
 .byt 32,33,34,35,36,37,38,39,40+128,41+128,42,43,44,45,46,47
 .byt 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
 .byt 80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,8
 // ASCII Codes for 160-163 (LP items dropped)
 .byt 114,115,117,118

Region_map		// 128 Bytes
#include "Region.s"

TSMAP_Vector		;// 8192 Bytes
#include "..\Tilest~1\tolmaponly.s"	// Converted from tolmaponly in same dir
MAP_Vector		;// 5632 Bytes
#include "..\MapBinaries\tol04til.txt" // Mininote tol05 on cbmtext.dsk
BLOCK_Vector		;// 2864 Bytes
#include "..\MapBinaries\tol04blk.txt" // Mininote tol05 on cbmtext.dsk

// Icon Tables
icon_option	.byt 0	;0-3
icon_function_vectorlo	;speak,examine,inventory,hold
 .byt <speak_chosen
 .byt <examine_chosen
 .byt <inventory_chosen
 .byt <hand_icon_selected
icon_function_vectorhi
 .byt >speak_chosen
 .byt >examine_chosen
 .byt >inventory_chosen
 .byt >hand_icon_selected
icon_vector_lo
 .byt <icon_left,<icon_right,<icon_select,<icon_exit
icon_vector_hi
 .byt >icon_left,>icon_right,>icon_select,>icon_exit
//

//
// Options Tables
option_index	.byt 0
option_cursory	.byt 0
option_key
 .byt 0,1,4,5	;,6
option_key_vectorlo
 .byt <option_key_up,<option_key_down,<option_key_select,<option_key_abort	;,<option_resume_game
option_key_vectorhi
 .byt >option_key_up,>option_key_down,>option_key_select,>option_key_abort	;,>option_resume_game
key_high_bit_sequence
 .byt 1,2,4,8,16,32,64,128
moreoptions_code
 .byt 1,7
;optiontext_offset4creaturecode
; .byt 5,4,8
;optiontext_offset4othercodes
; .byt 1,0,0,0,3,0
;question2ask	.byt 0
;creature2speak2	.byt 0
// Text window
;messagecode_handling_vectorlo
; .byt <mc_other,<mc_other,<mc_other,<mc_other,<mc_place,<mc_object
; .byt <mc_passage,<mc_qtext,<mc_caption,<mc_other
;messagecode_handling_vectorhi
; .byt >mc_other,>mc_other,>mc_other,>mc_other,>mc_place,>mc_object
; .byt >mc_passage,>mc_qtext,>mc_caption,>mc_other

;bitmask
; .byt %01011111,%01101111,%01110111,%01111011,%01111101,%01111110
// Background Buffer Tables
;bgYoffset
; .byt 0,39,39*2,39*3,39*4
// Ground Item tables
ground_item_xl
 .byt <1822	;Note      (Midraths Lodge)
 .byt <591	;Glass Key (Underworld #1)
 .byt <3840	;Cloak	 (Phang Castle)
 .byt <4047	;Medallion (Underworld #2)
 .byt <1955	;Ring	 (South of Dessert)
 .byt <3920	;Map Book  ()
 .byt <3151	;Magic Hat (Underworld #2)
 .byt <3904	;Bow&Arrow (Angor Flame Pit)
 .byt <2415	;Cross     (Inner Isle)
 .byt <251	;Axe       (Samson Isle)
 .byt <1552	;Dagger	 (Woodmans Cabin, Dark Forest)
 .byt 0		;Last entry reserved for dropped Dagger
ground_item_xh
 .byt >1822
 .byt >591
 .byt >3840
 .byt >4047
 .byt >1955
 .byt >3920
 .byt >3151
 .byt >3904
 .byt >2415
 .byt >251
 .byt >1552
 .byt 0
ground_item_yl
 .byt <1728
 .byt <1820
 .byt <1917
 .byt <123
 .byt <1958
 .byt <315
 .byt <123
 .byt <784
 .byt <720
 .byt <1060
 .byt <510
 .byt 0
ground_item_yh
 .byt >1728
 .byt >1820
 .byt >1917
 .byt >123
 .byt >1958
 .byt >315
 .byt >123
 .byt >784
 .byt >720
 .byt >1060
 .byt >510
 .byt 0
;114-114 Dropped Food
;115-115 Dropped Gold
;116-116 Dropped Key
;117-117 Dropped Potion
;118-118 Dropped Weapon
;119-119 Dropped Artifact

ground_item_character	;If 0 then not present
 .byt 119
 .byt 116
 .byt 119
 .byt 119
 .byt 119
 .byt 119
 .byt 119
 .byt 118
 .byt 119
 .byt 118
 .byt 118
 .byt 0
ground_item_textnum
 .byt 181
 .byt 178
 .byt 200
 .byt 201
 .byt 203
 .byt 189
 .byt 191
 .byt 192
 .byt 194
 .byt 199
 .byt 183
 .byt 0
// Sprite Tables
;sprite_mask
; .byt 0,7,56,63
sprite_bitmap_lo	;Sprite Vectors
 .byt <$b820,<$b820+1*48,<$b820+2*48,<$b820+3*48	;Hero
 .byt <$b820+4*48,<$b820+5*48,<$b820+6*48,<$b820+7*48
 .byt <$b820+8*48,<$b820+9*48,<$b820+10*48,<$b820+11*48
 .byt <$b820+12*48,<$b820+13*48,<$b820+14*48,<$b820+15*48

 .byt <tolsprites,<tolsprites+1*48,<tolsprites+2*48,<tolsprites+3*48		;Creatures
 .byt <tolsprites+4*48,<tolsprites+5*48,<tolsprites+6*48,<tolsprites+7*48
 .byt <tolsprites+8*48,<tolsprites+9*48,<tolsprites+10*48,<tolsprites+11*48
 .byt <tolsprites+12*48,<tolsprites+13*48,<tolsprites+14*48,<tolsprites+15*48
 .byt <tolsprites+16*48,<tolsprites+17*48,<tolsprites+18*48,<tolsprites+19*48
 .byt <tolsprites+20*48,<tolsprites+21*48,<tolsprites+22*48,<tolsprites+23*48
 .byt <tolsprites+24*48,<tolsprites+25*48,<tolsprites+26*48,<tolsprites+27*48
 .byt <tolsprites+28*48,<tolsprites+29*48,<tolsprites+30*48,<tolsprites+31*48
 .byt <tolsprites+32*48,<tolsprites+33*48,<tolsprites+34*48,<tolsprites+35*48
 .byt <tolsprites+36*48,<tolsprites+37*48,<tolsprites+38*48,<tolsprites+39*48
 .byt <tolsprites+40*48,<tolsprites+41*48,<tolsprites+42*48,<tolsprites+43*48
 .byt <tolsprites+44*48,<tolsprites+45*48,<tolsprites+46*48,<tolsprites+47*48
 .byt <tolsprites+48*48,<tolsprites+49*48,<tolsprites+50*48,<tolsprites+51*48
 .byt <tolsprites+52*48,<tolsprites+53*48,<tolsprites+54*48,<tolsprites+55*48
 .byt <tolsprites+56*48,<tolsprites+57*48,<tolsprites+58*48,<tolsprites+59*48
 .byt <tolsprites+60*48,<tolsprites+61*48	;,<tolsprites+62*48,<tolsprites+63*48

; .byt <tolsprites+64*48,<tolsprites+65*48,<tolsprites+66*48,<tolsprites+67*48
; .byt <tolsprites+68*48,<tolsprites+69*48,<tolsprites+70*48,<tolsprites+71*48
; .byt <tolsprites+72*48,<tolsprites+73*48,<tolsprites+74*48,<tolsprites+75*48
; .byt <tolsprites+76*48,<tolsprites+77*48
sprite_bitmap_hi
 .byt >$b820,>$b820+1*48,>$b820+2*48,>$b820+3*48	;Hero
 .byt >$b820+4*48,>$b820+5*48,>$b820+6*48,>$b820+7*48
 .byt >$b820+8*48,>$b820+9*48,>$b820+10*48,>$b820+11*48
 .byt >$b820+12*48,>$b820+13*48,>$b820+14*48,>$b820+15*48

 .byt >tolsprites,>tolsprites+1*48,>tolsprites+2*48,>tolsprites+3*48		;Creatures
 .byt >tolsprites+4*48,>tolsprites+5*48,>tolsprites+6*48,>tolsprites+7*48
 .byt >tolsprites+8*48,>tolsprites+9*48,>tolsprites+10*48,>tolsprites+11*48
 .byt >tolsprites+12*48,>tolsprites+13*48,>tolsprites+14*48,>tolsprites+15*48
 .byt >tolsprites+16*48,>tolsprites+17*48,>tolsprites+18*48,>tolsprites+19*48
 .byt >tolsprites+20*48,>tolsprites+21*48,>tolsprites+22*48,>tolsprites+23*48
 .byt >tolsprites+24*48,>tolsprites+25*48,>tolsprites+26*48,>tolsprites+27*48
 .byt >tolsprites+28*48,>tolsprites+29*48,>tolsprites+30*48,>tolsprites+31*48
 .byt >tolsprites+32*48,>tolsprites+33*48,>tolsprites+34*48,>tolsprites+35*48
 .byt >tolsprites+36*48,>tolsprites+37*48,>tolsprites+38*48,>tolsprites+39*48
 .byt >tolsprites+40*48,>tolsprites+41*48,>tolsprites+42*48,>tolsprites+43*48
 .byt >tolsprites+44*48,>tolsprites+45*48,>tolsprites+46*48,>tolsprites+47*48
 .byt >tolsprites+48*48,>tolsprites+49*48,>tolsprites+50*48,>tolsprites+51*48
 .byt >tolsprites+52*48,>tolsprites+53*48,>tolsprites+54*48,>tolsprites+55*48
 .byt >tolsprites+56*48,>tolsprites+57*48,>tolsprites+58*48,>tolsprites+59*48
 .byt >tolsprites+60*48,>tolsprites+61*48	;,>tolsprites+62*48,>tolsprites+63*48

; .byt >tolsprites+64*48,>tolsprites+65*48,>tolsprites+66*48,>tolsprites+67*48
; .byt >tolsprites+68*48,>tolsprites+69*48,>tolsprites+70*48,>tolsprites+71*48
; .byt >tolsprites+72*48,>tolsprites+73*48,>tolsprites+74*48,>tolsprites+75*48
; .byt >tolsprites+76*48,>tolsprites+77*48
;0  Serf
;1  Guard
;2  Serf
;3  Orc
;4  Orc
;5  Rogue
;6  Ghost
;7  Slime
;8  Skeleton
;9  Orc
;10 Black Asp
;11 Black Asp
;sprite_base_frame
; .byt 57,24,57,33,33,49,16,65,65,33,41,41
;sprite_foe
; .byt 0,0,0,1,1,1,1,1,1,1,1,1
;Sprite Method's
; 0) Normal    - (background AND mask) OR bitmap
; 1) Inverse   - (mask EOR 63) OR background
; 2) Ghost     - bitmap OR background
; 3) Cloak     - mask AND background
; 4) Invisible - (background AND mask) OR (bitmap AND BG)
sprite_plot_method_lo
 .byt <sdm_00,<sdm_01,<sdm_02,<sdm_03,<sdm_04
sprite_plot_method_hi
 .byt >sdm_00,>sdm_01,>sdm_02,>sdm_03,>sdm_04

// Creature tables
friend_move_vector_lo
 .byt <friend_north,<friend_east,<friend_south,<friend_west,<guard_s2a
friend_move_vector_hi
 .byt >friend_north,>friend_east,>friend_south,>friend_west,>guard_s2a
;gnc_ahead_stepx
; .byt 0,50,0,1
;gnc_ahead_stepy
; .byt 1,0,24,0
creature12_rate
 .byt 120 // 0 Serf
 .byt 96  // 1 Guard
 .byt 110 // 2 Serf
 .byt 64  // 3 Orc
 .byt 64  // 4 Orc
 .byt 96  // 5 Rogue
 .byt 96 // 6 Ghost
 .byt 96  // 7 Skeleton
 .byt 96  // 8 Skeleton
 .byt 64  // 9 Orc
 .byt 110  // 10 Black Asp
 .byt 120 // 11 Black Asp
creature12_bframe
 .byt 57  // 0 Serf
 .byt 24  // 1 Guard
 .byt 57  // 2 Serf
 .byt 33  // 3 Orc
 .byt 33  // 4 Orc
 .byt 49  // 5 Rogue
 .byt 16  // 6 Ghost
 .byt 65  // 7 Skeleton
 .byt 65  // 8 Skeleton
 .byt 33  // 9 Orc
 .byt 41  // 10 Black Asp
 .byt 41  // 11 Black Asp
creature12_foe
 .byt 0   // 0 Serf
 .byt 0   // 1 Guard
 .byt 0   // 2 Serf
 .byt 128 // 3 Orc
 .byt 128 // 4 Orc
 .byt 128 // 5 Rogue
 .byt 128 // 6 Ghost
 .byt 128 // 7 Skeleton
 .byt 128 // 8 Skeleton
 .byt 128 // 9 Orc
 .byt 128 // 10 Black Asp
 .byt 128 // 11 Black Asp
creature12_code
 .byt 128 // 0 Serf
 .byt 129 // 1 Guard
 .byt 128 // 2 Serf
 .byt 123 // 3 Orc
 .byt 123 // 4 Orc
 .byt 124 // 5 Rogue
 .byt 127 // 6 Ghost
 .byt 126 // 7 Skeleton
 .byt 126 // 8 Skeleton
 .byt 123 // 9 Orc
 .byt 125 // 10 Black Asp
 .byt 125 // 11 Black Asp
creature12_life
 .byt 3   // 0 Serf
 .byt 6   // 1 Guard
 .byt 3   // 2 Serf
 .byt 2   // 3 Orc
 .byt 2   // 4 Orc
 .byt 1   // 5 Rogue
 .byt 1   // 6 Ghost
 .byt 3   // 7 Skeleton
 .byt 3   // 8 Skeleton
 .byt 2   // 9 Orc
 .byt 4   // 10 Black Asp
 .byt 4   // 11 Black Asp
creature12_posessiontextnumber	;16/16
 .byt 0   // 0 Serf
 .byt 182 // 1 Guard
 .byt 0   // 2 Serf
 .byt 182 // 3 Orc
 .byt 182 // 4 Orc
 .byt 186 // 5 Rogue
 .byt 187 // 6 Ghost
 .byt 182 // 7 Skeleton
 .byt 204 // 8 Skeleton
 .byt 184 // 9 Orc
 .byt 185 // 10 Black Asp
 .byt 184 // 11 Black Asp
creature12_posessionbgbufnumber	;16/16
 .byt 0   // 0 Serf
 .byt 161 // 1 Guard
 .byt 0   // 2 Serf
 .byt 160 // 3 Orc
 .byt 161 // 4 Orc
 .byt 162 // 5 Rogue
 .byt 162 // 6 Ghost
 .byt 161 // 7 Skeleton
 .byt 162 // 8 Skeleton
 .byt 162 // 9 Orc
 .byt 162 // 10 Black Asp
 .byt 162 // 11 Black Asp
// Creature index tables
creature_activity
 .dsb 3,0
creature_foe
 .dsb 3,0
creature_frac
 .dsb 3,0
creature_rate
 .dsb 3,0
creature_direction
 .dsb 3,0
creature_base_frame
 .dsb 3,0
creature_volume
 .dsb 3,0
creature_cat
 .dsb 3,0
creature_cch
 .dsb 3,0
creature_frame_interleave
 .dsb 3,0
creature_code
 .dsb 3,0
creature_life
 .dsb 3,0
creature_posessiontextnum
 .dsb 3,0
creature_posessionbgbufnum
 .dsb 3,0
creature_inverse
 .dsb 3,0
creature_pause
 .dsb 3,0
creature_regress
 .dsb 3,0
pausenfire_delay
 .dsb 3,0
// Creature variables
x_range			.byt 0
// Hero Stuff
current_place	.byt 0
held_weapon	.byt 0
hero_tsmap_entry	.byt 0
friend_is_enemy	.byt 0	;0(Friend) or 128(Foe)
holywater_posessed_flag	.byt 0
cross_posessed_flag		.byt 0
;elsewhere_flag
;0 - Outside
;1 - In Tavern or Inn		 (Icon Menu Only)
;2 - In House                            (Icon Menu Only)
;3 - In Underworld or Underground Passage(Not shown on Map)
;128 - On Island (Combination)           (Not shown on Map)
elsewhere_flag	.byt 0
hero_inverse	.byt 0
magical_boots	.byt 0
new_posession	.byt 0

// Projectile tables (Reference vectors)
projectile_dirvector_lo
 .byt <projectile_north,<projectile_east,<projectile_south,<projectile_west
projectile_dirvector_hi
 .byt >projectile_north,>projectile_east,>projectile_south,>projectile_west
// Projectile tables (Properties) indexed by Weapon
// The animation for Axe and Dagger are performed by animations.s
// Current weapons are...
// Nm Description	Creature	Character	Distance	potency	afterthought QuantityLimit
// 0) Dagger	Hero	95	10	9	1            1
// 1) Bow & Arrow	Hero	126/127	15	1	0            6
// 2) Axe		Hero	95	8	6	0            3
// 3) Arrow 	Rogue	126/127	20	1	0	   -
// 4) Arrow 	Skeleton	126/127	40	4	128          -
projectile_property_character
 .byt 95,126,95,126,126
projectile_property_distancelimiter
 .byt 10,15,8,20,40
projectile_property_potency
 .byt 9,1,6,1,4
projectile_property_afterthought
 .byt 1,0,0,0,128
projectile_property_quantitylimit
 .byt 1,6,3,8,8	;To save bytes, may be able to delete the latter two
// Projectile tables (Runtime)
projectile_direction
 .dsb 8,128
projectile_x
 .dsb 8,0
projectile_y
 .dsb 8,0
projectile_character	;95(Hero Special),126(Arrow H),127(Arrow V)
 .dsb 8,0
projectile_sourcecreature	;Hero(0) or Creature(1-3)
 .dsb 8,0
projectile_distancelimiter	;(0 to 38?)
 .dsb 8,0
projectile_potency		;How much it will take off a life
 .dsb 8,0
projectile_afterthought
 .dsb 8,0
heroes_projectile_quantitylimit	.byt 0
// Keyboard tables
;Bit      Key		Game Action	Icons Action	Options Action
;0        Up		Move Up				Options Up
;1	Down		Move Down				Options Down
;2	Left		Move Left		Icon Left
;3	Right		Move Right	Icon Right
;4	Fire		Use / Hit		Select Icon	Select Option
;5	Space		Icon Menu		Resume Game	Options Exit
;6	E		Replenish Life
;7	U		Use object

key_stroke
 .byt 1,8,2,4,16,32,64,128
key_vectorlo
 .byt <key_up,<key_right,<key_down,<key_left,<key_fire
 .byt <select_icon,<use_replenishment,<hand_icon_selected
key_vectorhi
 .byt >key_up,>key_right,>key_down,>key_left,>key_fire
 .byt >select_icon,>use_replenishment,>hand_icon_selected
// Window Tables
// Text window is 19*8 characters (6*6)

;Keys...
;Keys now held in prefs top of memory ($B800)
;Bit      Key		Game Action	Icons Action	Options Action
;0        Up		Move Up				Options Up
;1	Down		Move Down				Options Down
;2	Left		Move Left		Icon Left
;3	Right		Move Right	Icon Right
;4	Fire		Use / Hit		Select Icon	Select Option
;5	Space		Icon Menu		Resume Game	Options Exit
;6	,		Last held Object
;7	.                   Next held Object

;When we use an object, these tables dictate what happens
; NUM    OBJECT         USE                              		FOUND
// Magical Items
; 176    TIN CLASP      Used with cloak to 'activate' disguise        Calibor, Crannoth
; 200    CLOAK          See Tin Clasp                                 Castle, Phang Province
; 188    BOOTS          SpeedUp                                       Barton, Treela
; 201    MEDALLION      Required for main quest                       Agrechant Underworld
; 202    MEAD CHIME     Use at 103,10 to raise gold from ground 	Bombadil, Sleepy River
; 203    RING           Temporary Invisibility, Saps life!            South of Dessert
; 189    MAP BOOK       Teleport                                      Agrechant Underworld
; 190    STONES         Guides the hero through the first quest       Head Orc, Dark Forest
; 195    TABLET         Required for main quest                       Head Orc, Dark Forest
; 177    WAND           Creates bridge to inner isle                  Bombadil, Sleepy River
// Magical Weapons
; 191    MAGIC HAT      Invincibility for 5 minutes                   Agrechant Underworld
; 192    BOW&ARROW      Infinite Arrows (Fires at rate 1)             Temple of Angor Grounds
; 193    HOLY WATER     Dispells Skeletons once posessed              Dark Prior, Rhyder
; 194    CROSS          Dispells Ghosts once posessed                 Inner Isle
; 199    AXE            Infinite Axes (Fires at rate 20)              Samson
; 204    PARCHMENT      Kills all enemy on screen                     Dropped by Asps
; 184    OLD SCROLL     Hurts creatures repeatedly for 1 min          Dropped by Black Asps
; 187    WHITE VIAL     Vanishes other Creatures!                     Dropped by Ghosts
; 185    SKULL          Creatures attack each other                   Dropped by Rogues
// Magical Replenishments
; 186    GREEN VIAL     Restores Life                                 Dropped by Rogues
// Artifacts
; 178    GLASS KEY      Opens Agrechant Gate                          Underworld #1
; 179    STONE KEY      Opens Angor Gate                              Calibor, Crannoth
; 180    QUARTZ KEY     Opens Crannoth Gate                           Calibor, Crannoth
; 181    NOTE           Information only                              Midraths Lodge, Dessert
// Weapons
; 183    DAGGER         Fires once, item is dropped                   Woodmans Lodge, D'Forest
object_utility_vector_lo
 .byt <ouv_not_here		; 176    TIN CLASP	Artifact
 .byt <ouv_usewand		; 177    WAND	Artifact
 .byt <ouv_notinthisway	; 178    GLASS KEY	Artifact
 .byt <ouv_notinthisway	; 179    STONE KEY	Artifact
 .byt <ouv_notinthisway	; 180    QUARTZ KEY	Artifact
 .byt <ouv_not_here		; 181    NOTE     	Artifact
 .byt <ouv_notinthisway 	; 182    GOLD     	-
 .byt <ouv_usedagger   	; 183    DAGGER   	Weapon	(Weapon=1)
 .byt <ouv_usemagic   	; 184    OLD SCROLL	Weapon
 .byt <ouv_usemagic		; 185    SKULL     	Weapon
 .byt <ouv_usepotion	; 186    GREEN VIAL	Artifact
 .byt <ouv_usemagic  	; 187    WHITE VIAL	Weapon
 .byt <ouv_useboots		; 188    BOOTS    	Artifact
 .byt <ouv_usebook		; 189    MAP BOOK 	Artifact
 .byt <ouv_not_here		; 190    STONES   	Artifact
 .byt <ouv_not_here		; 191    MAGIC HAT	Artifact
 .byt <ouv_usebow   	; 192    BOW&ARROW	Weapon	(Weapon=2)
 .byt <ouv_not_here		; 193    HOLY WATER	Weapon
 .byt <ouv_not_here		; 194    CROSS    	Weapon
 .byt <ouv_not_here		; 195    TABLET   	Artifact
 .byt <ouv_not_here		; 196    Not Used
 .byt <ouv_not_here		; 197    RATIONS  	-
 .byt <ouv_not_here 	; 198    BOARDING 	-
 .byt <ouv_useaxe		; 199    AXE      	Weapon	(Weapon=3)
 .byt <ouv_usecloak		; 200    CLOAK    	Artifact
 .byt <ouv_usemedallion	; 201    MEDALLION	Artifact
 .byt <ouv_not_here		; 202    MEAD CHIME	Artifact
 .byt <ouv_not_here		; 203    RING     	Artifact
 .byt <ouv_usemagic		; 204    PARCHMENT	Weapon
object_utility_vector_hi
 .byt >ouv_not_here		; 176    TIN CLASP	Artifact
 .byt >ouv_usewand		; 177    WAND	Artifact
 .byt >ouv_notinthisway	; 178    GLASS KEY	Artifact
 .byt >ouv_notinthisway	; 179    STONE KEY	Artifact
 .byt >ouv_notinthisway	; 180    QUARTZ KEY	Artifact
 .byt >ouv_not_here		; 181    NOTE     	Artifact
 .byt >ouv_notinthisway 	; 182    GOLD     	-
 .byt >ouv_usedagger   	; 183    DAGGER   	Weapon	(Weapon=1)
 .byt >ouv_usemagic   	; 184    OLD SCROLL	Magic Weapon #1
 .byt >ouv_usemagic		; 185    SKULL     	Magic Weapon #2
 .byt >ouv_usepotion	; 186    GREEN VIAL	Artifact
 .byt >ouv_usemagic  	; 187    WHITE VIAL	Magic Weapon #3
 .byt >ouv_useboots		; 188    BOOTS    	Artifact
 .byt >ouv_usebook		; 189    MAP BOOK 	Artifact
 .byt >ouv_not_here		; 190    STONES   	Artifact
 .byt >ouv_not_here		; 191    MAGIC HAT	Artifact
 .byt >ouv_usebow   	; 192    BOW&ARROW	Weapon	(Weapon=2)
 .byt >ouv_not_here		; 193    HOLY WATER	Weapon
 .byt >ouv_not_here		; 194    CROSS    	Weapon
 .byt >ouv_not_here		; 195    TABLET   	Artifact
 .byt >ouv_not_here		; 196    Not Used
 .byt >ouv_not_here		; 197    RATIONS  	-
 .byt >ouv_not_here 	; 198    BOARDING 	-
 .byt >ouv_useaxe		; 199    AXE      	Weapon	(Weapon=3)
 .byt >ouv_usecloak		; 200    CLOAK    	Artifact
 .byt >ouv_usemedallion	; 201    MEDALLION	Artifact
 .byt >ouv_not_here		; 202    MEAD CHIME	Artifact
 .byt >ouv_not_here		; 203    RING     	Artifact
 .byt >ouv_usemagic		; 204    PARCHMENT	Magic Weapon #4
;The Location List contains a list of keywords that represent locations on the map
;that are jumped to when hero uses the map book.
;Locations are dependant on known keywords
location_list
 .byt 3	;Camp - Orc Camp, Dark Forest
 .byt 6	;Silderon - Silderons Mouth, Tempus
 .byt 8	;Crannoth - Crannoth Isle
 .byt 9   ;Equinox - Mouth of Equinox, Dark Forest
 .byt 13	;Agre Lodge - Midraths Lodge, Dessert
 .byt 14  ;Agrechant - Ruins of Agrechant, Outside, Dessert
 .byt 15  ;Tempus - Outside Inn, Tempus Island
 .byt 17  ;Crator - Crator Wald, Alboreth
 .byt 20  ;Angor - Angor Moor next to gate, Alboreth
 .byt 23	;Inner Isle - Inner Isle, next to Castle
 .byt 25  ;Phnang - Phnang Wald, Phnang Province
 .byt 26	;Samson - Samson Isle
location_destination_xl
 .byt <1134
 .byt <336
 .byt <109
 .byt <624
 .byt <1857
 .byt <2736
 .byt <849
 .byt <1456
 .byt <3921
 .byt <2432
 .byt <3570
 .byt <184
location_destination_xh
 .byt >1134
 .byt >336
 .byt >109
 .byt >624
 .byt >1857
 .byt >2736
 .byt >849
 .byt >1456
 .byt >3921
 .byt >2432
 .byt >3570
 .byt >184
location_destination_yl
 .byt <547
 .byt <1626
 .byt <172
 .byt <154
 .byt <1751
 .byt <1818
 .byt <1919
 .byt <1658
 .byt <954
 .byt <721
 .byt <1168
 .byt <1123
;Special format to conserve bytes...
;B0-3 - YH
;B7   - Outside(0) or Island/Phnang(128)
location_destination_yh_and_elsewhere
 .byt >547
 .byt 6+128
 .byt 128
 .byt 0
 .byt >1751
 .byt >1818
 .byt 7+128
 .byt >1658
 .byt >954
 .byt >721
 .byt 4+128
 .byt 4+128
item_count
last_matched	.byt 0
