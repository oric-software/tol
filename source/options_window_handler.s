;Option Handler
#define hires_window_character_yofs	$b44b

select_option	;cc==Aborted x==Option Index
	lda #00
	sta option_index
	sta option_cursory
	jsr display_options
.(
loop3	jsr plot_option_cursor
loop2	jsr waiton_window_key
	ldx #03
loop1	cmp option_key,x
	beq skip1
	dex
	bpl loop1
	jmp loop2
skip1	lda option_key_vectorlo,x
	sta vector1+1
	lda option_key_vectorhi,x
	sta vector1+2
	jsr erase_option_cursor
vector1	jsr $DEAD
	jmp loop3
.)

plot_option_cursor
	lda #5+16
plot_oc	ldy option_cursory
	iny
	iny
	ldx #22
	jsr wxy202
	ldx #05
.(
loop1	ldy hires_window_character_yofs,x
	sta (zero_02),y
	dex
	bpl loop1
.)
	rts

erase_option_cursor
	lda #7+16
	jmp plot_oc

option_key_up
.(
	lda option_cursory
	beq skip1
	dec option_cursory
	rts
skip1	lda option_index
	beq skip2
	dec option_index
	jsr display_options
skip2	rts
.)


option_key_down
.(
	lda option_cursory
	cmp #05
	bcs skip1
	adc option_index
	tax
	lda optionbuffer+1,x
	beq skip2
	inc option_cursory
	rts
skip1	ldx option_index
	lda optionbuffer+6,x
	beq skip2
	inc option_index
	jsr display_options
skip2	rts
.)

option_key_select
	pla
	pla
	jsr clear_options_window
	lda option_index
	clc
	adc option_cursory
	tax
	sec
	rts
option_key_abort
	pla
	pla
	jsr clear_options_window
	clc
	rts
;option_resume_game
;	;Regress to Icon Menu
;	pla
;	pla
;	;It is assumed that each tier of areas are linked by a single jsr in the stack
;	;Regress to Game
;	pla
;	pla
;	rts


;Waits on single key press (no repeat), then Returns...
;0        Cursor Up           Up
;1        Cursor Down         Down
;2        Left-CTRL           Use Held Object(Fire)
;3        D		Drop Item
;Note that this is a subset of the key register
waiton_window_key
.(
	;Flush keyboard
loop1	jsr flush_key
;	lda key_register
;	bne loop1
	;Then wait for any key
loop2	lda key_register
	beq loop2
	;Filter window key (Single Key)
	ldx #07
loop3	cmp key_high_bit_sequence,x
	bcs skip2
	dex
	bpl loop3
	jmp loop1
skip2	txa
.)
	rts

clear_options_window
	// Clear Options Window
	lda #<$a569
	sta zero_00
	lda #>$a569
	sta zero_01
	ldx #36
.(
loop2	ldy #09
	lda #$40
loop1	sta (zero_00),y
	dey
	bpl loop1
	lda #40
	jsr add_zero00
	dex
	bne loop2
.)
	rts

display_options
	jsr clear_options_window
	lda #02	;Top (Y) of option display
	sta ot_cursor_y
	ldy option_index
	sty temp_index
.(
loop1	ldy temp_index
	ldx optionbuffer,y
	beq skip1	;End of option list
	// Now fetch correct offset to displayed text
	jsr fetch_option_text_loc	;into zero_00/01
	// Display line
;	ldy ot_cursor_y
	jsr display_option_line
	// Update pointers
	inc temp_index
	inc ot_cursor_y
	lda ot_cursor_y
	cmp #08	;bottom(Y+1) of option display
	bcc loop1
	// Now sort out <<MORE>> flags
;	ldx #01	;X flags more options below
skip1     //show_moreoptions_ahead
;	lda moreoptions_code,x
;	sta $ab07
; 	ldx option_index	;option index (0/ non-zero) can be used to say more options above!)
;	beq skip3
;	ldx #01
skip3
;	lda moreoptions_code,x
.)
;	sta $a53e
	rts

;In...
;A == Message Code (0-255)
;Out...
;Y == Code Type
;
fetch_code_type
          ldy #04
.(
loop1	dey
	cmp code_breakdown,y
	bcc loop1
skip1     rts
.)


;Should only ever contain text
; So terminated by codes below 32 or above 122
display_option_line
	lda zero_00
	sta $bfe0
	lda zero_01
	sta $bfe1

	ldx #23
	stx ot_cursor_x
	ldx #00
	stx source_index
.(
loop1	ldy source_index
	lda (zero_00),y
	cmp #254
	bcs skip1
	ldx ot_cursor_x
	ldy ot_cursor_y
	jsr wxy202
	jsr plot_window_character
	inc source_index
	inc ot_cursor_x
	lda ot_cursor_x
	cmp #25+08
	bcc loop1
skip1	rts
.)

;In...
;A == ASCII character to display (32-127)
;zero_00/zero_01 == HIRES screen loc
plot_window_character
	// Calculate window character address
	;calc_window_character_address
	tax
	lda text_vector_hi,x
	pha
	lda text_vector_lo,x
	tax
	pla
.(
	stx vector1+1
	sta vector1+2

	ldx #05
loop1
vector1	lda $DEAD,x
	ldy hires_window_character_yofs,x
	ora #64
	sta (zero_02),y
	dex
	bpl loop1
.)
	rts

fetch_option_text_loc
	// Fetch pointer to start of code data
	jsr fetch_textloc00
	txa
	// X contains code (0-255), now need to work out code type based on ranges
	jsr fetch_code_type
	// Y == Code type (0-3)
	// However eog,ascii,passage,questtext,caption,sentinels are not used here
	lda offset_type,y
	// offset_type
	// 0   Offset 0
	// 3   Offset 3
	// 254 Offset starts beyond byte 254
.(
	bpl skip1
	jsr lookbeyond254in00y0
	tya
skip1	;Now A will contain offset
	clc
	adc zero_00
	sta zero_00
	bcc skip2
	inc zero_01
skip2	rts
.)
