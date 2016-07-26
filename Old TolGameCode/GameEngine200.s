;Tol Game Engine V2.0
;0200 Game Variants
;0400 ? (256)
;0500 gameengine200.s
;A000 Hires_Inlay
;A3B8 Menu_management.s (3656)
;b200 Tol_irq.s
;B500 std charset
;B800 Candle Frames
;B860 ? (160)
;B900 Alt Charset
;BBF8 Screen
;BFE0 ? (32)
;C000 ? (15360)
;FC00 Tol_disc.s

;Missing...
;Game animations (768)
;Text messages
;
*=$500

#include "menu.h"



	jmp game_driver

 .dsb 256-(*&255)

;$0600
#include "tol_col.txt"	;256
;$0700
ByteEntity2char_table	;256 byte table
 .byt 0,1,2,3,4,5,6,7,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
 .byt 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
 .byt 80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95
 .byt 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
 .byt 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
 .byt 80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95
 .byt 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
 .byt 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
 .byt 80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95
 .byt 160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175
 .byt 176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191
;$0800
byte_mask_table
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
 .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
 .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
 .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
 .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
 .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
 .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
 .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
 .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
 .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
 .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
 .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
;$0900
;current_region_byte0...
;B0-3 - Low Priority creature (0==None)
;	0 - NONE!!
;	1 - Ghost
;	2 - Skeleton
;	3 - Orc
;	4 - Rogue
;	5 - Peasant
;	6 - Serf
;	7 - Slime
;	8-15 - Spare
;B4-6 - Incidental sound effects
;	0 - None
;	16 - Wild (Wind)
;	32 - Sea (Waves&Sea)
;	48 - Forest (Birdsong)
;	64 - Distant Sea and Forest
;	80/96/112 - Spare
;B7   - Animation Set
;	0
;	128
region_table0
 .dsb 256,2	;Start with friendlies only
;$0A00 region Table1
;current_region_byte1...
;B0-3 - High Priority creature(0==None)
;	0 - NONE!!
;	1 - Wraith      (M)
;	2 - Guard       (M)
;	3 - Grey Abbot  (M)
;	4 - Advisor     (S)
;	5 - Duke        (S)
;	6 - Prince      (S)
;	7 - Lyche       (M)
;	8 - Acolyte     (S)
;	9 - Noble       (S)
;	10- Black Asp   (M)
;	11- Archmage    (S)
;	12- Old Man     (S)
;	13- Prisoner    (S)
;	14- Woodsman    (S)
;	15 Thug        (M)
;B4-7 - Rumours
;	0  - I hear there's a dragon near the northern mountains.
;	16 - A dark fog is forming in the northeast.
;	32 - A wild dust storm ran through the desert the other day.
;	48 - A sorcery tower lies over a bridge north of the desert.
;	64 - I've heard tell of magical boots in Treela.
;	80 - A great giant is reputed to live east of Rhyder.
;	96 - A man from Lankwell boasted he knew about a magical axe.
;	112- People say that there is a scroll with the power to transport you around the kingdom.
region_table1
 .dsb 256,0

#include "tolobjchs.txt"	;256 (Dropped Object Character definitions (16) with masks)
#include "tol_map.txt"	;12288
#include "tol_tiles.txt"	;8192
#include "tol_block.txt"	;4096
#include "tol_chs.txt"	;1536
#include "tol_sprites.txt"	;3080
			;29448 !!
#include "barbarian.txt"	;Barbarian Sprites (1152 bytes)
#include "main.h"             ;0 (Defs)
#define inkey	$eb78
game_driver
	lda #25
	sta hero_xl
	lda #05
	sta hero_xh
	lda #96
	sta hero_yl
	lda #50
	sta hero_delay
	lda #09
	sta hero_yh
	lda #00
	sta hero_dir
	sta hero_frame
	sta hero_hit
	jsr setup_charset
	jsr refresh_game_screen	;refresh bg
game_loop
	jsr transfer_bg2sb
;	jsr display_dropped_objects
	jsr plot_creatures
	jsr plot_hero
	jsr plot_colour_column
	jsr transfer_sb2rs
	jsr creature_control
	jsr manage_hero ;(Which in turn manages screen scroll/position)
	jmp game_loop

;manage_creatures
; delete single creature from screen_buffer (Delete with known bg char)
; start loop
;  move/detect collision (Detect bg collision in bg_buffer, Detect creature collision in screen_buffer)
;  plot creature
; loop

;manage left/right/up/down first (Bunched for Testing only, should replace with proper irq later!!)
setup_charset
	ldx #00
sucs_01	lda tol_chs,x
	sta $b500,x
	lda tol_chs+256,x
	sta $b600,x
	dex
	bne sucs_01
	rts

manage_hero
	lda #00
	sec
	adc #128	;hero_delay
	sta manage_hero+1
	bcc mhero_05
	jsr inkey
	bpl mhero_05
	ldx #04
mhero_01	cmp key_ascii,x
	beq mhero_02
	dex
	bpl mhero_01
	rts	;jmp manage_hero
mhero_02	lda key_vector_lo,x
	sta mhero_03+1
	lda key_vector_hi,x
	sta mhero_03+2
mhero_03	jsr $bf00
	lda hero_hit
	bne mhero_05
	lda hero_frame
	clc
	adc #01
	and #03
mhero_04	sta hero_frame
mhero_05	rts
hero_attack
	lda #01
	sta hero_hit
	rts


plot_hero	ldx #08		;First combine hero
phero_03	ldy sb_offset,x	;Fetch bg char address into 00/01
	lda screen_buffer+20+8*43,y
	sec
	sbc #32
	asl
	asl
	asl
	sta phero_04+1
	lda #$b5
	adc #00
	sta phero_04+2
	lda hero_character,x
	sta screen_buffer+20+8*43,y
	lda hero_char_address_lo,x	;Fetch hero char address into 02/03
	sta phero_05+1
	lda hero_hit
	beq phero_06
	lda #15
	adc hero_dir
	tay
	jmp phero_07
	;hero_direction=0-3
phero_06	lda hero_dir		;fetch hero bitmap/mask address into 04/05
	asl
	asl
	adc hero_frame
	tay	;0-14
phero_07	txa
	asl
	asl
	asl
	adc hero_bitmap_address_lo,y
	sta 04
	lda hero_bitmap_address_hi,y
	adc #00
	sta 05
	ldy #07			;combine and store them
phero_01	lda (04),y
	sta phero_02+1
phero_02	lda byte_mask_table
phero_04	and $bf00,y
	ora (04),y
phero_05	sta $b700,y
	dey
	bpl phero_01
	dex
	bpl phero_03
	;physically plot hero
	lda #00
	sta hero_hit
	rts




hero_bitmap_address_lo
 .byt <hero_bitmap
 .byt <hero_bitmap+72*1
 .byt <hero_bitmap+72*2
 .byt <hero_bitmap+72*1

 .byt <hero_bitmap+72*3
 .byt <hero_bitmap+72*4
 .byt <hero_bitmap+72*5
 .byt <hero_bitmap+72*4

 .byt <hero_bitmap+72*6
 .byt <hero_bitmap+72*7
 .byt <hero_bitmap+72*8
 .byt <hero_bitmap+72*7

 .byt <hero_bitmap+72*9
 .byt <hero_bitmap+72*10
 .byt <hero_bitmap+72*11
 .byt <hero_bitmap+72*10

 .byt <hero_bitmap+72*12
 .byt <hero_bitmap+72*13
 .byt <hero_bitmap+72*14
 .byt <hero_bitmap+72*15


hero_bitmap_address_hi
 .byt >hero_bitmap
 .byt >hero_bitmap+72*1
 .byt >hero_bitmap+72*2
 .byt >hero_bitmap+72*1

 .byt >hero_bitmap+72*3
 .byt >hero_bitmap+72*4
 .byt >hero_bitmap+72*5
 .byt >hero_bitmap+72*4

 .byt >hero_bitmap+72*6
 .byt >hero_bitmap+72*7
 .byt >hero_bitmap+72*8
 .byt >hero_bitmap+72*7

 .byt >hero_bitmap+72*9
 .byt >hero_bitmap+72*10
 .byt >hero_bitmap+72*11
 .byt >hero_bitmap+72*10

 .byt >hero_bitmap+72*12	;North
 .byt >hero_bitmap+72*13
 .byt >hero_bitmap+72*14
 .byt >hero_bitmap+72*15

hero_char_address_lo
 .byt <46080+8*114,<46080+8*115,<46080+8*116
 .byt <46080+8*117,<46080+8*118,<46080+8*119
 .byt <46080+8*120,<46080+8*121,<46080+8*122
sb_offset
 .byt 0,1,2,43,44,45,86,87,88
hero_character
 .byt 114,115,116
 .byt 117,118,119
 .byt 120,121,122

key_ascii
 .byt 8,9,10,11,32
key_vector_lo
 .byt <hero_left,<hero_right,<hero_down,<hero_up,<hero_attack
key_vector_hi
 .byt >hero_left,>hero_right,>hero_down,>hero_up,>hero_attack

hero_left
	lda #<bg_buffer+19+8*43
	ldy #>bg_buffer+19+8*43
	jsr check_hero_collision_vertical
	bcs hleft_01
	lda hero_xl
	sec
	sbc #01
	sta hero_xl
	lda hero_xh
	sbc #00
	sta hero_xh
	lda #01
	sta hero_dir
	jmp scroll_bgb_right
hleft_01	rts
hero_right
	lda #<bg_buffer+23+8*43
	ldy #>bg_buffer+23+8*43
	jsr check_hero_collision_vertical
	bcs hleft_01
	lda hero_xl
	clc
	adc #01
	sta hero_xl
	lda hero_xh
	adc #00
	sta hero_xh
	lda #03
	sta hero_dir
	jmp scroll_bgb_left
hero_down
	lda #<bg_buffer+20+11*43
	ldy #>bg_buffer+20+11*43
	jsr check_hero_collision_horizontal
	bcs hleft_01
	lda hero_yl
	clc
	adc #01
	sta hero_yl
	lda hero_yh
	adc #00
	sta hero_yh
	lda #02
	sta hero_dir
	jmp scroll_bgb_up
hero_up
	lda #<bg_buffer+20+7*43
	ldy #>bg_buffer+20+7*43
	jsr check_hero_collision_horizontal
	bcs hleft_01
	lda hero_yl
	sec
	sbc #01
	sta hero_yl
	lda hero_yh
	sbc #00
	sta hero_yh
	lda #00
	sta hero_dir
	jmp scroll_bgb_down

check_hero_collision_vertical
	sta chcv_01+1
	sty chcv_01+2
	ldx #02
chcv_02	ldy vertical_check_offset,x
	stx temp_01
chcv_01	ldx $bf00,y
	cpx #32
	bcc chcv_04
	lda $0600,x
	and #%00111000
	bne chcv_04
	ldx temp_01
	dex
	bpl chcv_02
	clc
chcv_03	rts
chcv_04	sec
	rts
temp_01		.byt 0
temp_02		.byt 0
temp_03		.byt 0
check_hero_collision_horizontal
	sta chch_01+1
	sty chch_01+2
	ldx #02
chch_01	ldy $bf00,x
	cpy #32
	bcc chcv_04
	lda $0600,y
	and #%00111000
	bne chcv_04
	dex
	bpl chch_01
	clc
chch_03	rts


vertical_check_offset
 .byt 0,43,86
scroll_bgb_left	;and fill right-column
	jsr setup_bgb
	ldx #19
sbgbl_02	ldy #01
sbgbl_01	lda (00),y
	dey
	sta (00),y
	iny
	iny
	cpy #43
	bcc sbgbl_01
	lda #43
	jsr add_00
	dex
	bne sbgbl_02
refresh_right_bg	;update column
	lda #42
	sta bgbuffer_col
	jsr locate_bg_origin_right
	jsr locate_bg_origin_top
	jmp refresh_bg_column

scroll_bgb_right	;and fill left-column
	jsr setup_bgb
	ldx #19
sbgbr_02	ldy #41
sbgbr_01	lda (00),y
	iny
	sta (00),y
	dey
	dey
	bpl sbgbr_01
	lda #43
	jsr add_00
	dex
	bne sbgbr_02
refresh_left_bg	;update column
	lda #00
	sta bgbuffer_col
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	jmp refresh_bg_column


scroll_bgb_down	;and fill top-row
	lda #<bg_buffer+43*17
	sta 00
	lda #>bg_buffer+43*17
	sta 01
	ldx #19
sbgbd_02	lda #42
	sta 02
	lda #85
	sta 03
sbgbd_01	ldy 02
	lda (00),y
	ldy 03
	sta (00),y
	dec 03
	dec 02
	bpl sbgbd_01
	lda #43
	jsr sub_00
	dex
	bne sbgbd_02
refresh_top_bg	;update row
	lda #00
	sta bgbuffer_row
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	jmp refresh_bg_row


scroll_bgb_up	;and fill bottom-row
	jsr setup_bgb
	ldx #19
sbgbu_02	lda #42
	sta 02
	lda #85
	sta 03
sbgbu_01	ldy 03
	lda (00),y
	ldy 02
	sta (00),y
	dec 03
	dec 02
	bpl sbgbu_01
	lda #43
	jsr add_00
	dex
	bne sbgbu_02
refresh_bottom_bg	;update row
	lda #18
	sta bgbuffer_row
	jsr locate_bg_origin_left
	jsr locate_bg_origin_bottom
	jmp refresh_bg_row


setup_bgb
	lda #<bg_buffer
	sta 00
	lda #>bg_buffer
	sta 01
	rts



transfer_bg2sb	;bg_buffer >> screen_buffer
;bg_buffer is 39*15 whilst screen_buffer is 43*19(817)
;offset bg_buffer +2X and +2Y
	lda #<bg_buffer
	sta 00
	lda #>bg_buffer
	sta 01
	lda #<screen_buffer
	sta 02
	lda #>screen_buffer
	sta 03
	ldx #19
bg2sb_02	ldy #42
bg2sb_01	lda (00),y
	sta sb2rs_03+1	;This would cetainly save on a few cycles!
sb2rs_03	lda $0700
	sta (02),y
	dey
	bpl bg2sb_01
	lda #43
	jsr add_00
	lda #43
	jsr add_02
	dex
	bne bg2sb_02
	rts

;Change of plan, we store the byte we get from mem directly into bg_buffer and Screen Buffer
;this makes it so damn easier then to detect collisions with hero/creatures.
;But just need to filter byte to screen char here (charset set in scroll routines)
transfer_sb2rs	;screen_buffer >> real screen
	lda #<screen_buffer+1+2*43
	sta 00
	lda #>screen_buffer+1+2*43
	sta 01
	lda #<$bb80+3*40
	sta 02
	lda #>$bb80+3*40
	sta 03
	ldx #15
sb2rs_02	ldy #39
sb2rs_01	lda (00),y
	sta (02),y
	dey
	bpl sb2rs_01
	lda #43
	jsr add_00
	lda #40
	jsr add_02
	dex
	bne sb2rs_02
	rts

plot_colour_column	;in screen_buffer
	lda #<bg_buffer+2+2*43
	sta 00
	lda #>bg_buffer+2+2*43
	sta 01
	lda #<screen_buffer+1+2*43
	sta 02
	lda #>screen_buffer+1+2*43
	sta 03
	ldx #14
	ldy #00
pccl_02	lda (00),y
	sta pccl_01+1
pccl_01	lda $0600
	and #07
	sta (02),y
	lda #43
	jsr add_00
	lda #43
	jsr add_02
	dex
	bpl pccl_02
	rts

refresh_game_screen	;Like at the start or when entering or exiting a building or underground
	jsr locate_bg_origin_left
	jsr locate_bg_origin_top
	lda tx_lo
	sta 08
	lda tx_hi
	sta 09
	ldx #00
rgsc_02	stx bgbuffer_row
	jsr refresh_bg_row
	ldx bgbuffer_row
	lda 08
	sta tx_lo
	lda 09
	sta tx_hi
	inc ty_lo
	bne rgsc_01
	inc ty_hi
rgsc_01	inx
	cpx #19
	bcc rgsc_02
	rts




locate_bg_origin_left
	lda hero_xl
	sec
	sbc #20
	sta tx_lo
	lda hero_xh
	sbc #00
	sta tx_hi
	rts
locate_bg_origin_right
	lda hero_xl
	clc
	adc #22
	sta tx_lo
	lda hero_xh
	adc #00
	sta tx_hi
	rts
locate_bg_origin_top
	lda hero_yl
	sec
	sbc #08
	sta ty_lo
	lda hero_yh
	sbc #00
	sta ty_hi
	rts
locate_bg_origin_bottom
	lda hero_yl
	clc
	adc #10
	sta ty_lo
	lda hero_yh
	adc #00
	sta ty_hi
	rts


;in...
;tx_lo/tx_hi == left Xpos (0-4095)
;ty_lo/ty_hi == Left Ypos (0-2047)
;bgbuffer_row == The row to refresh
; C == undetermined
;out...
; Refresh full row of 39 characters, redefining chars (if appropriate)
;Corruption...
; 00,01
;Observation...
;
refresh_bg_row
	ldy bgbuffer_row
	lda bgbuffer_ylocl,y
	sta 00
	lda bgbuffer_yloch,y
	sta 01
	ldy #00
refrow_01	jsr fetch_entity_from_map
	jsr check_charset	;redefine, collision map etc.
	sta (00),y
	inc tx_lo
	bne refrow_02
	inc tx_hi
refrow_02	iny
	cpy #43
	bcc refrow_01
	rts

;in...
;tx_lo/tx_hi == Top Xpos (0-4095)
;ty_lo/ty_hi == Top Ypos (0-2047)
;bgbuffer_col == The column to refresh
; C == undetermined
;out...
; Refresh full column of 15 characters, redefining chars (if appropriate)
;Corruption...
; 00,01
;Observation...
;
refresh_bg_column
	lda bgbuffer_col
	clc
	adc #<bg_buffer
	sta 00
	lda #>bg_buffer
	adc #00
	sta 01
	ldy #00
	ldx #19	;Refresh full height
refcol_01 stx temp_01
	jsr fetch_entity_from_map
	jsr check_charset	;redefine, collision map etc.
	ldx temp_01
	ldy #00		;Store character to bg_buffer
	sta (00),y
	inc ty_lo
	bne refcol_02
	inc ty_hi
refcol_02	lda #43
	jsr add_00
	dex
	bne refcol_01
	rts

;in...
;tx_lo/tx_hi == Xpos (0-4095)
;ty_lo/ty_hi == Ypos (0-2047)
; C == undetermined
;out...
; A == Character identifier (0-255)
;Corruption...
; A,02,03,04,05
;
;  tx_lo/tx_hi   ty_lo/ty_hi
; 000011111111   00011111111
; MMMMMMMTTTBB   MMMMMMTTTBB
fetch_entity_from_map
;Fetch the tile from the map
	lda tx_hi		;Extract Mx
	sta 04
	lda tx_lo
	asl
	rol 04
	asl
	rol 04
	asl
	rol 04
	lda ty_hi		; MMM MMMTTTBB
	sta 03
	lda ty_lo
	asl		;multiply by 4 to get xxxxx x0000000
	rol 03
	sta 05
	and #%11000000
	asl
	rol 03
	ora 04		;add Mx
	clc
	adc #<tol_map	;Add Map bases
	sta fcfm_01+1
	lda #>tol_map
	adc 03
	sta fcfm_01+2
	lda #00
	sta 02
	sta 04
fcfm_01   lda $bf00		;Fetch Tile in Map
	and #127	;Their are 128 tiles, The top bit may be used for something else later
;calculate the tile address
	lsr	;0TTTTTTT >> 000TTTTT TT000000
	ror 02
	lsr
	ror 02
	sta 03
	lda 05	;Filter Ty
	and #%00111000
	sta 05
	lda tx_lo	;get Tx
	lsr
	lsr
	and #%00000111
	ora 05	;get offset in Tile
	ora 02	;add tile number
	clc
	adc #<tol_tiles	;Add tile base
	sta fcfm_02+1
	lda #>tol_tiles
	adc 03        	;Add tile number
	sta fcfm_02+2
fcfm_02	lda $bf00		;Fetch Block in Tile
;Calculate the Block address
	sta 02	;BBBBBBBB >> BBBB BBBB0000
	asl
	rol 04
	asl
	rol 04
	asl
	rol 04
	asl
	rol 04
	sta 05
	lda ty_lo
	and #3		;Extract By
	asl
	asl
	sta 02
	lda tx_lo		;Extract Bx
	and #03
	ora 02		;Get offset in Block
	ora 05		;Get offset in Block memory
	clc
	adc #<tol_blocks	;Add Block memory base
	sta fcfm_03+1
	lda #>tol_blocks
	adc 04
	sta fcfm_03+2
fcfm_03	lda $bf00		;Fetch Character entity in Block
	rts


;in...
; A == Character identifier
; C == undetermined
;out...
; A  == Character (32-95)
; 02 == Associated Collision
; 03 == Associated Character colour (Ink)
;Corruption...
; A,04,05,06,07
;Observation...
; Calculates character inversion, definition. Redefines character
check_charset
	cmp #32
	bcc cc2p_04
	sta 07
	stx 06
	sbc #32
	tax
	and #63
	sta 04
	lda attribute_association_table,x
	and #%11000000	;Extract Character bank
	ldx 04	;fetch real char (0-63)
	cmp current_bank,x	;(0-63)
	beq cc2p_05	;If the same, don't redefine
	sta current_bank,x
;Fetch new char location
	asl	;Reformat to 000000BB 00000000
	rol
	rol
	sta 05
	txa	;Fetch current real char (0-63)
	asl
	asl
	asl
	php
	sta cc2p_02+1
	rol 05
	adc #<tol_chs
	sta cc2p_03+1
	lda 05
	adc #>tol_chs
	sta cc2p_03+2
;Fetch real character address
	lda #$b5
	plp
	adc #00
	sta cc2p_02+2
;Redefine character
	ldx #07
cc2p_03	lda $bf00,x
cc2p_02	sta $bf00,x
	dex
	bpl cc2p_03
cc2p_05	lda 07	;Fetch character
	ldx 06
cc2p_04	rts


add_00	clc
	adc 00
	sta 00
	lda 01
	adc #00
	sta 01
	rts

sub_00	sta sub_01+1
	lda 00
	sec
sub_01	sbc #00
	sta 00
	lda 01
	sbc #00
	sta 01
	rts

add_02	clc
	adc 02
	sta 02
	lda 03
	adc #00
	sta 03
	rts


bg_buffer
 .dsb 43*19,8
bgbuffer_ylocl
 .byt <bg_buffer
 .byt <bg_buffer+43*1
 .byt <bg_buffer+43*2
 .byt <bg_buffer+43*3
 .byt <bg_buffer+43*4
 .byt <bg_buffer+43*5
 .byt <bg_buffer+43*6
 .byt <bg_buffer+43*7
 .byt <bg_buffer+43*8
 .byt <bg_buffer+43*9
 .byt <bg_buffer+43*10
 .byt <bg_buffer+43*11
 .byt <bg_buffer+43*12
 .byt <bg_buffer+43*13
 .byt <bg_buffer+43*14
 .byt <bg_buffer+43*15
 .byt <bg_buffer+43*16
 .byt <bg_buffer+43*17
 .byt <bg_buffer+43*18
bgbuffer_yloch
 .byt >bg_buffer
 .byt >bg_buffer+43*1
 .byt >bg_buffer+43*2
 .byt >bg_buffer+43*3
 .byt >bg_buffer+43*4
 .byt >bg_buffer+43*5
 .byt >bg_buffer+43*6
 .byt >bg_buffer+43*7
 .byt >bg_buffer+43*8
 .byt >bg_buffer+43*9
 .byt >bg_buffer+43*10
 .byt >bg_buffer+43*11
 .byt >bg_buffer+43*12
 .byt >bg_buffer+43*13
 .byt >bg_buffer+43*14
 .byt >bg_buffer+43*15
 .byt >bg_buffer+43*16
 .byt >bg_buffer+43*17
 .byt >bg_buffer+43*18

screen_buffer
 .dsb 43*19,8
current_bank	;64
 .dsb 64,0

tx_lo		.byt 0
tx_hi               .byt 0
ty_lo               .byt 0
ty_hi               .byt 0
bgbuffer_row	.byt 0
bgbuffer_col	.byt 0
sb_lo               .byt 0
sb_hi               .byt 0
sb_x                .byt 0
sb_y                .byt 0
bb_lo               .byt 0
bb_hi               .byt 0




#include "creature_control.s"
;#include "object_control.s"
#include "screen.h"
