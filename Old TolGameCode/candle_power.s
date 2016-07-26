;Candle_Power
;Candle control
;In order for this to work properly...
;Candle frames need to be in B800-B85F
;Altset needs to be in $b900-
;
;A000 - Hires inlay
;A300?- MC
;B500 - Standard charset
;B800 - Candle animations
;B900 - Alt charset
;BB80 - Hires switch
;BBF8 - Screen
;BFE0 - ?
;C000 - Refer to top16k.s

*=$9ffd
#include "main.h"
	jmp menu_control
;Method of display...
;Messages that need to be plotted on the main
;window and placed directly onto main_window
;Subwindows are formed directly on screen.
;When restoring, main_window is sent to rs.
;Candle animation modifies main_window

#include "tol_inlay.txt"


menu_control
;this is for testing only...
	lda #47
	sta hero_health
	ldx #00
mctrl_01	lda alt_charset,x
	sta $b900,x
	lda alt_charset+256,x
	sta $ba00,x
	lda alt_charset+512,x
	sta $bb00,x
	dex
	bne mctrl_01
	ldx #95
mctrl_02	lda candle_frame_00_left,x
	sta $b800,x
	dex
	bpl mctrl_02
;end of test!
mctrl_03	jsr control_candle_animation
	ldx #00
mctrl_04	inx
	bpl mctrl_04
	jmp mctrl_03

mw2rs	lda #<main_window
	sta $80
	lda #>main_window
	sta $81
	lda #<$bb80+40*18
	sta $82
	lda #>$bb80+40*18
	sta $83
	ldx #09
mw2rs_02	ldy #39
mw2rs_01	lda ($80),y
	sta ($82),y
	dey
	bpl mw2rs_01
	lda #40
	jsr add_80
	lda #40
	adc $82
	sta $82
	bcc cffa_03
	inc $83
cffa_03	dex
	bne mw2rs_02
cffa_02	rts


control_candle_animation
ccanim_01	lda #00
	clc
	adc #2
	sta ccanim_01+1
	bcc cffa_02

	dec hero_health
	bpl ccanim_02
	lda #47
	sta hero_health
ccanim_02
	lda hero_health
	cmp old_hero_health
	bcs stem_reenter
	jsr scroll_stem_down
stem_reenter
	lda hero_health
	sta old_hero_health
	jsr plot_candle_and_stem
	lda flame_anim_frame
	clc
	adc #01
	and #03
	sta flame_anim_frame
	cmp #03
	bcc cffa_01
	lda #01
cffa_01	ldy ypos_in_char
	jsr redef_candle_anim_in_char
	jmp mw2rs


scroll_stem_down
	lda $b800+7+8*62
	pha
	lda $b800+7+8*64
	pha
	ldx #06
ssdn_01	lda $b800+8*62,x
	sta $b800+1+8*62,x
	lda $b800+8*64,x
	sta $b800+1+8*64,x
	dex
	bpl ssdn_01
	pla
	sta $b800+8*64
	pla
	sta $b800+8*62
	rts


;hero health is 0-47(0==Dead)
plot_candle_and_stem
	lda #47
	sec
	sbc hero_health
	pha
	and #07
	sta ypos_in_char
	lda #<main_window+36
	sta $80
	lda #>main_window+36
	sta $81
	ldx #00
	pla
	lsr	;/8
	lsr
	lsr
	sta ypos_on_screen
	beq pcas_05
pcas_01	ldy #02	;Clear rows down to flame
	lda #09
	sta ($80),y
	dey
	sta ($80),y
	lda #40
	jsr add_80
	inx
	cpx ypos_on_screen
	bcc pcas_01
pcas_05	ldx #08	;Display Flame
pcas_02	ldy candle_offset,x
	lda candle_char,x
	sta ($80),y
	dex
	bpl pcas_02
	lda #120	;Display remaining Stem
	ldx ypos_on_screen
	inx
	inx
pcas_03	jsr add_80
	inx
	cpx #08
	bcs pcas_04
	ldy #02
	lda #64
	sta ($80),y
	dey
	lda #62
	sta ($80),y
	dey
	lda #07
	sta ($80),y
	lda #40
	jmp pcas_03
pcas_04	rts

candle_offset
 .byt 0,40,80
 .byt 1,41,81
 .byt 2,42,82
candle_char
 .byt 1,4,3
 .byt 91,92,93
 .byt 94,95,96
flame_anim_frame	.byt 0
ypos_on_screen	.byt 0
ypos_in_char	.byt 0
old_hero_health	.byt 0

;The actual number of frames displayed
;is 4, in sequence of 0,1,2,1


;y==Ypos in char(0-7)
;A==Flame Frame(0-2)
;   B800 - Flame Frame 0
;   B820 - Flame Frame 1
;   B840 - Flame Frame 2

redef_candle_anim_in_char
	asl	;*32
	asl
	asl
	asl
	asl
	sta pcaic_06+1
	ora #$10
	sta pcaic_05+1
	tya
	adc #16
	sta temp_02
	sty temp_01
	tya
	beq pcaic_02
	ldy #00
	;Clear Top of candle
	tya
pcaic_01	sta $bad8,y
	sta $baf0,y
	iny
	cpy temp_01
	bcc pcaic_01
pcaic_02	ldx #00
pcaic_06	lda $b800,x ;Store frame to chardef
	sta $bad8,y
pcaic_05	lda $b800,x
	sta $baf0,y
	inx
	iny
	cpy temp_02
	bcc pcaic_06
	ldx temp_01
pcaic_03	cpy #24	  ;Fill remainder with Stem
	bcs pcaic_04
	lda $b800+8*62,x
	sta $bad8,y
	lda $b800+8*64,x
	sta $baf0,y
	inx
	iny
	jmp pcaic_03
pcaic_04	rts

add_80	clc
	adc $80
	sta $80
	bcc add_801
	inc $81
	clc
add_801	rts

main_window
 .byt 9,6,"#''''''''''''''''''''''''''''''$",9,9,1,">@",9
 .byt 9,6,")                              *",9,9,3,"]^",9
 .byt 9,6,")                              *",9,9,7,"_`",9
 .byt 9,6,")                              *",9,9,7,"[\",9
 .byt 9,6,")                              *",9,9,7,"[\",9
 .byt 9,6,")                              *",9,9,7,"[\",9
 .byt 9,6,")                              *",9,9,7,"[\",9
 .byt 9,6,")                              *",9,9,7,"[\",9
 .byt 9,6,"%((((((((((((((((((((((((((((((&",2,"-//;<"

#include "altset.txt"

candle_frame_00_left
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000001
 .byt %000011
 .byt %000111
 .byt %001111
 .byt %011100

 .byt %011000
 .byt %011000
 .byt %001100
 .byt %000000
 .byt %000000
 .byt %100011
 .byt %111000
 .byt %011111
candle_frame_00_right
 .byt %011000
 .byt %011100
 .byt %111100
 .byt %111100
 .byt %111110
 .byt %111110
 .byt %001110
 .byt %000110

 .byt %000110
 .byt %100110
 .byt %001000
 .byt %000000
 .byt %011110
 .byt %000011
 .byt %000001
 .byt %000111
candle_frame_01_left
 .byt %000000
 .byt %000000
 .byt %000111
 .byt %001111
 .byt %001111
 .byt %011111
 .byt %111100
 .byt %111000

 .byt %111000
 .byt %111000
 .byt %001100
 .byt %000000
 .byt %000000
 .byt %100011
 .byt %111000
 .byt %011111
candle_frame_01_right
 .byt %000000
 .byt %000000
 .byt %110000
 .byt %111000
 .byt %111100
 .byt %111100
 .byt %011110
 .byt %001110

 .byt %001110
 .byt %000110
 .byt %001000
 .byt %000000
 .byt %011110
 .byt %000011
 .byt %000001
 .byt %000111
candle_frame_02_left
 .byt %000011
 .byt %000111
 .byt %001111
 .byt %001111
 .byt %001111
 .byt %011111
 .byt %011100
 .byt %011000

 .byt %011000
 .byt %011001
 .byt %001100
 .byt %000000
 .byt %000000
 .byt %100011
 .byt %111000
 .byt %011111
candle_frame_02_right
 .byt %000000
 .byt %100000
 .byt %110000
 .byt %110000
 .byt %110000
 .byt %111000
 .byt %011000
 .byt %001100

 .byt %001110
 .byt %000110
 .byt %001000
 .byt %000000
 .byt %011110
 .byt %000011
 .byt %000001
 .byt %000111
