;Text Window Handler

#define message_buffer	$BBA8
#define hires_window_ylocl	$b43b
#define hires_window_yloch	$b443
#define hires_window_character_yofs	$b44b
#define posessed_keywords	$b2ec
#define posessionlist	$b457

// 1) form message in message_buffer (including embedded links and colour changes)
// 2) Scan line for 20 column and insert "-"
// 3) Display Message observing page full
// Note1 at the end of every new message sent, a carriage return is administered
// Note2 message_buffer is 64 bytes long and +128 terminated

;1) form message in message_buffer (including embedded links and colour changes)
;In...
;A == Message Number
message2window
        	sta message_number
        	tax
	jsr fetch_textloc00
;	lda text_vector_lo,x
;        	sta zero_00
;        	lda text_vector_hi,x
;        	sta zero_01
	// Check if keyword
	cpx #32
.(
	bcc skip1
	// Check if object
	cpx #176
	bcc messageaddress2window
	cpx #205
	bcs messageaddress2window
skip1	// If Call to display keyword, then it's the description we want
.)
	jsr lookbeyond254in00y0
;	ldy #00
;loop1	lda (zero_00),y
;	iny
;	cmp #254
;	bcc loop1

	cpx #32
.(
	bcs skip1
	iny
skip1	tya
.)
	jsr add_zero00
messageaddress2window
	ldx #00	;Message_buffer index
	stx message_buffer_index
        	ldy #00	;toltext index
	sty tol_text_index
.(
loop1     ldy tol_text_index
   	lda (zero_00),y
	// Now breakdown ranges
	// Since the actual text type is accessed above, the breakdown is based
	// only on embedded references within the text
	cmp #32
	bcs skip1
	jsr process_keyword_text
	jmp skip10
skip1	cmp #123
	bcs skip2
	jsr process_ascii_text
	jmp skip10
skip2	cmp #144
	bcs skip3
	jsr process_creature_text
	jmp skip10
skip3	cmp #176
	bcs skip4
	jsr process_creature_text	;Same Code - process_place_text
	jmp skip10
skip4	cmp #205
	bcs skip5
	jsr process_object_text
	jmp skip10
skip5
;	cmp #229
;	bcs skip6
;We can exclude this
;	jsr process_passage_text
;	jmp skip10
;skip6	cmp #240
;	bcs skip7
;We can exclude this
;	jsr process_quest_text
;	jmp skip10
skip7	cmp #254
        	bcs end_of_text
;We can exclude this
;	jsr process_caption_text
skip10	inc tol_text_index
        	jmp loop1
end_of_text
	// Terminate message buffer
	lda #128
	ldx message_buffer_index
	sta message_buffer,x
.)
;2) Scan line for 20 column and insert "-"
scan_message_buffer
	ldy #00	;column counter
	ldx #00
.(
loop1	lda message_buffer,x
	bmi skip3
	beq skip4	;0 resets colour change, so effectively the same
	cmp #" "
	bne skip1
skip4	stx last_space_offset
skip1	iny
	cpy #21
	bcc skip2
	// This is the clever bit, when Y reaches the 20th column, regress x to the
	// last known space position, then scan after that to the next 20th column
	ldx last_space_offset
	lda #"-"
	sta message_buffer,x
	ldy #01
skip2	inx
	cpx #108
	bcc loop1
	lda #00
	sta message_buffer+107
skip3
.)
;3) Display Message observing page full
	ldx #00
	stx ic_x
.(
loop1	ldx ic_x
	lda message_buffer,x
	bmi skip1
	cmp #08
	bcs skip4
	jsr plot_colours
	jmp skip5
skip4	cmp #"-"
	bne skip2
	jsr carriage_return
	jmp skip3
skip2	ldx wt_cursor_x
	ldy wt_cursor_y
	jsr plot_window_characteratxy
skip5	inc wt_cursor_x
skip3	inc ic_x
	ldx ic_x
	cpx #108
	bcc loop1
skip1	jsr carriage_return
	rts
.)

plot_colours
	// A = Colour
	ldx wt_cursor_x
	ldy wt_cursor_y
	jsr wxy202
	ldx #05
.(
loop1	ldy hires_window_character_yofs,x
	sta (zero_02),y
	dex
	bpl loop1
	rts
.)

// Carriage Return is a special scenario, since it must handle Next page,
// aswell as incrementing Y and resetting X
carriage_return
	lda #00
	sta wt_cursor_x
	inc wt_cursor_y
	lda wt_cursor_y
	cmp #08
.(
	bcc skip1
	lda #"+"
	ldx #20
	ldy #7
	jsr plot_window_characteratxy
	jsr waiton_window_key	;may change to Fire only
	lda #32
	ldx #20
	ldy #7
	jsr plot_window_characteratxy
	jsr clear_text_window
	lda #00
	sta wt_cursor_y
;	jsr flush_key
skip1	rts
.)

wxy202
	pha
	txa
	clc
	adc hires_window_ylocl,y
	sta zero_02
	lda hires_window_yloch,y
	adc #00
	sta zero_03
	pla
	rts

process_ascii_text
	// Check for current flags
;  * Current held Weapon
;  $ Current Gold Coins
;  % Current Percentage of game complete
;  = List of comma separated objects hero posesses
;  ^(94) Current location (Place)
;  + New Posession (Item just picked up)
;  [ Rations
;  ] Posession Price
	cmp #"*"
.(
	bne skip1
	jmp process_heldweapon_text
skip1	cmp #"$"
	bne skip2
	jmp process_goldcoins_text
skip2
;	cmp #"%"
;	bne skip3
;	jmp process_gamepercent_text
;skip3	cmp #"="
;	bne skip4
;	jmp process_posessionlist_text
skip4	cmp #"^"
	bne skip5
	jmp process_currentplace_text
skip5	cmp #"+"
	bne skip6
	jmp process_new_posession_text
skip6	cmp #"["
	bne skip7
	jmp process_ration_text
skip7	cmp #"]"
	bne skip8
	jmp process_posession_price
skip8	// Process plain ascii
.)
	ldx message_buffer_index
	sta message_buffer,x
	inc message_buffer_index
	rts

process_heldweapon_text
	ldx held_weapon
	bne send_02_text
	ldx #196
send_02_text
	jsr fetch_textloc02y0
;    	lda text_vector_lo,x
;        	sta zero_02
;        	lda text_vector_hi,x
;        	sta zero_03
;	ldy #00
	jmp store2messagebuffer
process_new_posession_text
	ldx new_posession
	jmp send_02_text

process_ration_text
	jsr flush_formed_numeric_string
	// Fetch BCD Ration
	lda hero_rations
	jsr bcdhi2digit
	sta formed_numeric_string+4
	lda hero_rations
	jsr bcdlo2digit
	sta formed_numeric_string+5
	jmp display_delimited_numeric

flush_formed_numeric_string
	ldx #05
	lda #48
.(
loop1	sta formed_numeric_string,x
	dex
	bpl loop1
.)
	rts

bcdhi2digit
	lsr
	lsr
	lsr
	lsr
bcdlo2digit
	and #15
	ora #48
	rts


process_posession_price
	// Display price of posession
	lda #48
	sta formed_numeric_string+0
	sta formed_numeric_string+1
	ldy #02
	ldx #01
.(
loop1	lda posession_price,x
	pha
	jsr bcdhi2digit
	sta formed_numeric_string+2,y
	pla
	jsr bcdlo2digit
	sta formed_numeric_string+3,y
	dey
	dey
	dex
	bpl loop1
.)
	jmp display_delimited_numeric

process_goldcoins_text
	// Display Gold in bank
	ldy #04
	ldx #02
.(
loop1	lda hero_gold0,x
	pha
	jsr bcdhi2digit
	sta formed_numeric_string,y
	pla
	jsr bcdlo2digit
	sta formed_numeric_string+1,y
	dey
	dey
	dex
	bpl loop1
.)
display_delimited_numeric
	// Count from MSB down to first digit >0
	ldx #00
.(
loop1	lda formed_numeric_string,x
	cmp #"0"
	bne skip1
	inx
	cpx #05
	bcc loop1
skip1	// Now display remainder
.)
	stx zero_04
.(
loop1	ldy message_buffer_index
	lda formed_numeric_string,x
	sta message_buffer,y
	inc message_buffer_index
	inc zero_04
	ldx zero_04
	cpx #06
	bcc loop1
.)
	rts

;process_gamepercent_text
;	ldx #00
;.(
;loop1	lda posessionlist,x
;	beq skip1
;	inx
;	cpx #20
;	bcc loop1
;skip1	txa
;.)
;	// 0-19
;	lsr
;	// 0-9
;	ldx message_buffer_index
;	ora #48
;	sta message_buffer,x
;	lda #48
;	sta message_buffer+1,x
;	lda #"%"
;	sta message_buffer+2,x
;	inc message_buffer_index
;	inc message_buffer_index
;	inc message_buffer_index
;	rts

;process_posessionlist_text
;	ldy #00
;.(
;loop2	ldx posessionlist,y
;	beq skip3
;	sty temp_01
;	jsr fetch_textloc02y0
;;    	lda text_vector_lo,x
;;        	sta zero_02
;;        	lda text_vector_hi,x
;;        	sta zero_03
;;	ldy #00
;	jsr store2messagebuffer
;skip1
;	lda #","
;	sta message_buffer,x
;	inc message_buffer_index
;	lda #" "
;	sta message_buffer+1,x
;	inc message_buffer_index
;	inc temp_01
;	ldy temp_01
;	cpy #20
;	bcc loop2
;skip3	dec message_buffer_index
;	dec message_buffer_index
;skip2	rts
;.)

process_currentplace_text
	ldx current_place
	jsr fetch_textloc02y0
;    	lda text_vector_lo,x
;        	sta zero_02
;        	lda text_vector_hi,x
;        	sta zero_03
;	ldy #00
.(
loop1	lda (zero_02),y
	iny
	cmp #254
	bcc loop1
.)
;	jmp store2messagebuffer
store2messagebuffer
	ldx message_buffer_index
.(
loop2	lda (zero_02),y
	cmp #254
	bcs skip1
	iny
	sta message_buffer,x
	inc message_buffer_index
	ldx message_buffer_index
	cpx #108
	bcc loop2
skip1	rts
.)


process_keyword_text
	// Need to ensure keyword has not been used before in order to highlight and sfx it
	ldx #255
.(
loop1	inx
	cmp posessed_keywords,x
	beq skip1
	ldy posessed_keywords,x
	bne loop1	;May need additional limiter since 26 keywords but table is 20 long!
	// not posessed, so add it, and colour it
	sta posessed_keywords,x
	pha
	lda #01
	jsr store_single_character
	pla
	jmp skip2
skip1	// If word not highlighted, we still need to insert space
	pha
	lda #32
	jsr store_single_character
	pla
	// now display keyword
skip2	tay	;ldy posessed_keywords,x
    	lda text_vector_lo,y
        	sta zero_02
        	lda text_vector_hi,y
        	sta zero_03
	ldy #00
	jsr store2messagebuffer
	ldx message_buffer_index
	lda #00
	sta message_buffer,x
	inc message_buffer_index
	rts
.)

store_single_character
	ldx message_buffer_index
	sta message_buffer,x
	inc message_buffer_index
	rts

process_creature_text
	tax
	jsr fetch_textloc02
;    	lda text_vector_lo,x
;        	sta zero_02
;        	lda text_vector_hi,x
;        	sta zero_03
	ldy #01
	jmp store2messagebuffer

lookbeyond254in02y0
	ldy #00
lookbeyond254in02r
.(
loop1	lda (zero_02),y
	cmp #254
	iny
	bcc loop1
.)
	rts

lookbeyond254in00y0
	ldy #00
lookbeyond254in00r
.(
loop1	lda (zero_00),y
	cmp #254
	iny
	bcc loop1
.)
	rts


;process_place_text
;	jmp process_creature_text	;exactly the same process

process_object_text
	tax
	jsr fetch_textloc02y0
;    	lda text_vector_lo,x
;        	sta zero_02
;        	lda text_vector_hi,x
;        	sta zero_03
;	ldy #00
	jmp store2messagebuffer

plot_window_characteratxy
	jsr wxy202
	jmp plot_window_character

clear_text_window
	lda #<$a002+22*40
	sta zero_02
	lda #>$a002+22*40
	sta zero_03
	ldx #48
.(
loop2	ldy #19
	lda #$40
loop1	sta (zero_02),y
	dey
	bpl loop1
	lda #40
	jsr add_zero02
	dex
	bne loop2
.)
	rts

