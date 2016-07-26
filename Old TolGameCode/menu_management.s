;Menu & Candle
;Including icon control, menu window management, Candle control and realtime events (TOD etc.)
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



add_80	clc
	adc $80
	sta $80
	bcc add_801
	inc $81
	clc
add_801	rts

;left submenus are headers only.
;Even if the hero wants to talk to someone, the left subwindow will
;ask "Who do you wish to talk to?"
;X==Width of text area within (5-14)
;Y==Height of text area within (1-4)
;A==Message (0-255)
plot_left_submenu
	sta message_number
	stx window_width
	sty window_height
	lda #03
	ldx #01
	ldy #00
	jsr generic_window_template
	ldx message_number
	jsr locate_message	;and deposit start address in $92-93
	lda #<$bb80+3+18*40
	sta $90
	lda #>$bb80+3+18*40
	sta $91
	jmp display_message

;Options submenu
;Y==Number of entries
;A==list type (Creatures, objects, locations)
;option_list==List of message numbers (Of "A" type) (max8)
;Result:-
;A 0-7==Option selected or 128==Operation aborted


control_right_submenu
	pha
	sty number_of_options
	cpy #04
	bcc crsm_01
	ldy #04
crsm_01	sty window_height
	lda #16
	sta window_width
	ldx #18
	ldy #00
	jsr generic_window_template
	pla
	tay
	lda message_type_base_lo,y
	sta message_base_lo
	lda message_type_base_hi,y
	sta message_base_hi
	lda #00
	sta page_base_option
	sta selected_option

crsm_02	jsr refresh_page
	jsr highlight_selection
	jsr menu_key_control
	bcc crsm_02
	jmp ww2rs

refresh_page
	lda page_base_option
	sta option_index
	lda #<$bb80+16+19*40
	sta $94
	lda #>$bb80+16+19*40
	sta $95
	lda window_height
	sta line_count
	ldy window_width
	dey
	sty end_of_window
refpage_03
	lda message_base_lo
	sta $92
	lda message_base_hi
	sta $93
	ldy option_index
	ldx option_list,y
	jsr locate_message_02
	ldy #00
refpage_01
	lda ($92),y
	pha
	and #127
	sta ($94),y
	iny
	pla
	bpl refpage_01
	lda #32
refpage_04
	cpy end_of_window
	bcs refpage_05
	sta ($94),y
	iny
	jmp refpage_04
refpage_05
	lda $94
	clc
	adc #40
	sta $94
	bcc refpage_02
	inc $95
refpage_02
	inc option_index
	dec line_count
	bne refpage_03
	rts

highlight_selection
	lda selected_option
	sec
	sbc page_base_option
	tay
	lda option_list_ylocl,y
	sta $94
	lda option_list_yloch,y
	sta $95
	ldy end_of_window
hlwms_01	lda ($94),y
	eor #128
	sta ($94),y
	dey
	bpl hlwms_01
	rts

menu_key_control
	?

mk_up     lda page_base_option
	beq mkup_03
	dec page_base_option
mkup_01	dec selected_option
mkup_02	clc
	rts
mkup_03	lda selected_option
	beq mkup_02
	jmp mkup_01
mk_down	lda selected_option
	cmp number_of_options
	bcs mkdn_01
	cmp window_height
	bcc mkdn_02
	inc page_base_option
mkdn_02	inc selected_option
mkdn_01	clc
	rts
mk_select	lda selected_option
	sec
	rts
mk_escape lda #128
	sec
	rts









; x==message_number
locate_message	;and deposit start address in $92-93
	lda #<messages
	sta $92
	lda #>messages
	sta $93
locate_message_02
	cpx #00
	beq lmes_03
lmes_02	ldy #00
lmes_01	iny
	lda ($92),y
	bpl lmes_01
	iny
	tya
	adc $92
	sta $92
	lda $93
	adc #00
	sta $93
	dex
	bne lmes_02
lmes_03	rts


;may be multiple lines, dictated by window_width
;$92-93 == Message start address (Terminated with single B7)
;$90-91 == plot start
;Includes calculation to limit words per line and locates keywords
display_message
	ldy #00
	sty window_cursor_x
	sty message_index
dmes_02	ldy message_index
	lda ($92),y
	sta temp_01
	and #127
dmes_03	inc message_index
	cmp #"*"
	beq found_keyword
	cmp #" "
	beq check_word_length
dmes_01	cmp #"-"	;Replace hyphen with space (Used for multiple keywords)
	bne dmes_04
	lda #" "
dmes_04	ldy window_cursor_x
	sta ($90),y
	inc window_cursor_x
	lda temp_01
	bpl dmes_02
dmes_end	rts
found_keyword
	;don't sound any sfx until we are sure it is a new keyword, just extract it (Later)
	lda window_colour
	eor #87
	jmp cwln_03
check_word_length
	lda window_colour	;this resets keyword highlights
	ora #80
cwln_03	pha	;could be space or colour!
	ldx window_cursor_x
cwln_01	ldy message_index
	lda ($92),y
	bmi cwln_02
	cmp #" "
	beq cwln_02
	iny
	inx
	cpx window_width
	bcc cwln_01
	jsr nl_90
	lda #00
	sta window_cursor_x
cwln_02	pla
	jmp dmes_01


;These refer to window size(Including colour attributes and borders), not text within
;x=xpos referring to colour attribute
;y=ypos referring to border
;a=Colour
;window_width referring to text width
;window_Height referring to text lines
generic_window_template
	sta window_colour
	txa
	clc
	adc window_ylocl,y
	sta $90
	lda window_yloch,y
	sta $91
	ldy #00	;Plot top row (Border)
	lda window_colour
	sta ($90),y
	iny
	lda #"#"
	sta ($90),y
	iny
	lda #"'"
	jsr gwrow_01
	lda #"$"
	sta ($90),y
	iny
	lda #6
	sta ($90),y
	iny
	lda #"#"
	sta ($90),y
	jsr nl_90
	lda window_height	;plot body (l/r borders)
	sta temp_01
	ldy #00
gwin_02	lda window_colour
	sta ($90),y
	iny
	lda #")"
	sta ($90),y
	iny
	lda #" "
	jsr gwrow_01
	lda #"*"
	sta ($90),y
	iny
	lda #6
	sta ($90),y
	iny
	lda #")"
	sta ($90),y
	jsr nl_90
	dec temp_01
	bne gwin_02
	ldy #00	;Plot top row (Border)
	lda window_colour
	sta ($90),y
	iny
	lda #"%"
	sta ($90),y
	iny
	lda #"("
	jsr gwrow_01
	lda #"&"
	sta ($90),y
	iny
	lda #6
	sta ($90),y
	iny
	lda #")"
	sta ($90),y
	jsr nl_90
	ldy #01	;Plot top row (Border)
	lda #"#"
	sta ($90),y
	iny
	lda #"'"
	jsr gwrow_01
	sta ($90),y
	iny
	sta ($90),y
	iny
	lda #"+"
	sta ($90),y
	rts

nl_90	lda $90
	clc
	adc #40
	sta $90
	bcc nl_901
	inc $91
	clc
nl_901	rts


gwrow_01	ldx window_width
gwin_01	sta ($90),y
	iny
	dex
	bne gwin_01
	rts


inkey	lda key_register	;Allow just one keypress
	cmp old_key
	beq inkey_01
	sta old_key
	rts
inkey_01	lda #00
	rts


; * Action
; $ Creature
; % Object
; ^ Location
current_location
current_action
current_object
current_creature


; #'''''''''''$6#''''''''''''''''$--
; )Their are  *6)                *--
; )no objects *6)                *--
; )nearby!    *6)                *--
; %(((((((((((&6)                *--
; #'''''''''''''+                *--
; )                              *--
; )Welcome to Times Of Lore...   *--
; %((((((((((((((((((((((((((((((&


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

