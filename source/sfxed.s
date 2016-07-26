;SFX Editor V1.0 (For TOL)
;0500-2FFF BASIC (For Disc Ops and Menu)
;3000-4FFF SFX Editor (Here) and IRQ Player (new_sfx.s)
;5000-5FFF Compiled SFX Memory
;6000-603F Compiled Effect Address Table Lo
;6040-607F Compiled Effect Address Table Lo
;6080-6080 Compiled Effect Count
;6081-6FFF Spare
;7000-7FFF SFX Memory (4096 Bytes)
;8000-81FF SFX Names
;8200-823F SFX Area Table
;8240-B3FF Spare
;B400-B47F Current SFX Buffer
#define sfx_trigger	$bfe0
#define via_porta	$030f
#define via_pcr	$030c
#define effect_area	$8200

	.zero
*=$00

;Need to be aware we are dealing with BASIC
source
source_buffer	.dsb 2	;00-01
screen		.dsb 2	;02-03
row_counter	.dsb 1	;04
counter		.dsb 1	;05
action_byte	.dsb 1	;06
row_offset	.dsb 1	;07
destination	.dsb 2	;08-09
sfx_zero_00	.dsb 1	;0A
sfx_zero_01	.dsb 1	;0B Last Free Byte in sequence

	.text
*=$3000

driver	lda $bfe4
	beq exec_editor
	cmp #02
	bcc exec_compile
	beq exec_heading
	rts


exec_heading
	lda $bfe5
	asl
	sta $bfe5
	asl
	asl
	asl
	adc $bfe5
	tax
	ldy #00
.(
loop1	lda heading_text,x
	sta $bb80,y
	inx
	iny
	cpy #18
	bcc loop1
.)
	rts

exec_editor
	jsr reset_arrow_location
	jsr setup_chars
	jsr Setup_IRQ
	;Force update of all registers
	jsr force_ay_update
	jsr display_screen
	jsr scan_names
	jsr extract_effect
	jsr plot_loop_position
.(
loop1	jsr plot_event_list
	jsr plot_event_cursor
	jsr plot_info
	jsr inkey
	jmp loop1
.)
	rts

setup_chars
	ldx #39
.(
loop1	lda editor_chars,x	;35(#),36($),37(%)
	sta $b518,x
	dex
	bpl loop1
.)
	rts

scan_names	;Scan names to ensure within ascii range
	ldx #00
.(
loop1	lda $8000,x
	bmi skip1
	cmp #32
	bcs skip2
skip1	lda #32
	sta $8000,x
skip2
	lda $8100,x
	bmi skip3
	cmp #32
	bcs skip4
skip3	lda #32
	sta $8100,x
skip4	inx
	bne loop1
.)
	rts

exec_compile
;5000-5FFF Compiled SFX Memory
;6000-603F Compiled Effect Address Table Lo
;6040-607F Compiled Effect Address Table Lo
;6080-6080 Compiled Effect Count
	;
	lda #$00
	sta destination
	lda #$50
	sta destination+1
	ldx #00
.(
loop2	lda sfx_effect_event_address_table_lo,x
	sta source
	lda sfx_effect_event_address_table_hi,x
	sta source+1
	lda destination
	sta $6000,x
	lda destination+1
	sta $6040,x
	stx $6080
	ldy #00
loop1	lda (source),y
	sta (destination),y
	pha
	;need to include data before looking for END
	lsr
	lsr
	lsr
	lsr
	tay
	lda mnemonic_data_bytes,y
	sta counter
	ldy #00

loop3	inc source
	bne skip1
	inc source+1
skip1	inc destination
	bne skip2
	inc destination+1
skip2	lda (source),y
	sta (destination),y
	dec counter
	bpl loop3

	pla
	and #$f0
	bne loop1
	inx
	cpx #64
	bcc loop2
.)
	;Now store end loc
	lda destination
	sta $bfe6
	lda destination+1
	sta $bfe7
	rts

force_ay_update
	ldx #13
.(
loop1	lda sfx_ay_registers,x
	eor #255
	sta sfx_ay_reference,x
	dex
	bpl loop1
.)
	rts

reset_arrow_location
	lda #$f8
	sta previous_arrow_lo
	sta previous_arrow_lo+1
	sta previous_arrow_lo+2
	lda #$bb
	sta previous_arrow_hi
	sta previous_arrow_hi+1
	sta previous_arrow_hi+2
	rts

plot_loop_position ;Also ensure PER or LPR between
	;look for Loop Action in current effect
	jsr re_index
	ldx IndexKey_EndPosition
.(
loop1	ldy IndexKey_ByByteOffset,x
	lda $b400,y
	and #$f0
	cmp #$50
	beq skip1
	dex
	bpl loop1
	;Not found - Restore right column
	jsr restore_right_column
	;This flag would prevent Effect Playing
	lda #00
	sta loop_error_flag
	rts
skip1
	;The byte offset in Y is the offset to the Loop Action
	;and the register in the loop action is the loop row
	;from start
	lda $b400,y
	and #15
	sta row_offset
	;Check that loop is going backwards
	cpx row_offset
	beq error	; lev looping back on itself!
	bcc error	; lev before loop back row!
	;Check that from loop back to loop is atleast a PER or LPR
	stx temp_01
	ldx row_offset

loop2	ldy IndexKey_ByByteOffset,x
	lda $b400,y
	and #$f0
	cmp #$60
	beq cool
	cmp #$B0
	beq cool
	inx
	cpx temp_01
	bcc loop2
	;Error
error	jsr restore_right_column
	lda #"E"
	jsr plot_loop_marker
	lda #01
	sta loop_error_flag
	rts
cool	;Cool
	jsr restore_right_column
	lda #39
	jsr plot_loop_marker
	lda #00
	sta loop_error_flag
	rts
.)

restore_right_column
	lda #35
	ldx #23
.(
loop1	ldy event_display_loc_lo,x
	sty screen
	ldy event_display_loc_hi,x
	sty screen+1
	ldy #17
	sta (screen),y
	dex
	bpl loop1
.)
	rts

plot_loop_marker
	ldx row_offset
	ldy event_display_loc_lo,x
	sty screen
	ldy event_display_loc_hi,x
	sty screen+1
	ldy #17
	sta (screen),y
	rts

eve_silence
	sei
	;Set Volumes on all channels to 0
	lda #00
	sta sfx_ay_registers+8
	sta sfx_ay_registers+9
	sta sfx_ay_registers+10
	;Turn off all effects
	lda #128
	sta rrb_register
	lda #128
	sta sfx_effect_number
	sta sfx_effect_number+1
	sta sfx_effect_number+2
	lda #00
	ldx #11
.(
loop1	sta sfx_envelope_activity,x
	dex
	bpl loop1
.)
	cli
	rts

eve_deceffect
	jsr inject_effect
	lda effect_number
.(
	beq skip1
	dec effect_number
	jsr extract_effect
	jsr plot_loop_position
	;reset cursor
	lda #00
	sta event_row
skip1	rts
.)

eve_inceffect
	jsr inject_effect
	lda effect_number
	cmp #63
.(
	bcs skip1
	inc effect_number
	jsr extract_effect
	jsr plot_loop_position
	;reset cursor
	lda #00
	sta event_row
skip1	rts
.)

plot_message	;A=Message Number (Messages are 10 long)
	rts

eve_decarea
	ldx effect_number
	lda effect_area,x
.(
	beq skip1
	dec effect_area,x
skip1	rts
.)

eve_incarea
	ldx effect_number
	lda effect_area,x
	cmp #02
.(
	bcs skip1
	inc effect_area,x
skip1	rts
.)

extract_effect
	ldx effect_number
	lda sfx_effect_event_address_table_lo,x
	sta source
	lda sfx_effect_event_address_table_hi,x
	sta source+1
	ldy #63
.(
loop1	lda (source),y
	sta $b400,y
	dey
	bpl loop1
.)
	rts


;Each Effect can be up to 64 Bytes
;However for editing purposes, the currently loaded effect
;can be up to 96 bytes long, so we need to check that first
inject_effect
	jsr re_index
	jsr plot_info
	lda effect_size
	cmp #65
.(
	bcc skip1
	lda #00
	jsr plot_message
	rts
skip1	;Now inject $b400-3F into memory
	ldx effect_number
	lda sfx_effect_event_address_table_lo,x
	sta source
	lda sfx_effect_event_address_table_hi,x
	sta source+1
	;
	ldy #63
loop1	lda $b400,y
	sta (source),y
	dey
	bpl loop1
.)
	rts



plot_info	;Plot Bytes (1=96)
	jsr re_index
	ldx IndexKey_EndPosition
	lda IndexKey_ByByteOffset,x
	clc
	adc #01
	sta effect_size
	ldy #<$bb80
	sty screen
	ldy #>$bb80
	sty screen+1
	ldy #31+120
	jsr display_2dd
	;Plot Effect (0-63)
	lda effect_number
	ldy #22+40
	jsr display_2dd
	;Plot Effect x
	ldx effect_number
	cpx #16
	lda #"x"
.(
	bcc skip1
	lda #" "
skip1	sta $bb80+64
	;Plot Area (0-2)
	ldx effect_number
	lda effect_area,x
	;Multiply by 8
	asl
	asl
	asl
	;
	tax
	ldy #00
loop1	lda area_name,x
	sta $bb80+111,y
	inx
	iny
	cpy #8
	bcc loop1
	;Plot Name
	jsr calc_name_address
	ldy #07
loop2	lda (source),y
	sta $bbc7,y
	dey
	bpl loop2
	rts
.)


inkey	jsr $eb78
	bpl inkey
	ldx #35
.(
loop1	cmp event_key,x
	beq skip1
	dex
	bpl loop1
	jmp inkey
skip1     lda event_key_vector_lo,x
	sta vector1+1
	lda event_key_vector_hi,x
	sta vector1+2
vector1	jmp $DEAD
.)

eve_help	lda help_page
	clc
	adc #01
	and #03
	sta help_page
	tax
	lda help_page_address_lo,x
	sta source
	lda help_page_address_hi,x
	sta source+1
	lda #<$bb92+40*4
	sta screen
	lda #>$bb92+40*4
	sta screen+1
	ldx #18
.(
loop2	ldy #20
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda source
	clc
	adc #21
	sta source
	bcc skip1
	inc source+1
skip1	lda screen
	clc
	adc #40
	sta screen
	bcc skip2
	inc screen+1
skip2	dex
	bne loop2
.)
	rts

eve_copy
	lda effect_number
	sta sfx2copy
	jmp plot_cpy
eve_paste
	ldx sfx2copy
	lda sfx_effect_event_address_table_lo,x
	sta source
	lda sfx_effect_event_address_table_hi,x
	sta source+1
	ldy effect_number
	lda sfx_effect_event_address_table_lo,y
	sta destination
	lda sfx_effect_event_address_table_hi,y
	sta destination+1
	lda effect_area,x
	sta effect_area,y
	ldy #63
.(
loop1	lda (source),y
	sta (destination),y
	dey
	bpl loop1
	jsr plot_cpy
	jmp extract_effect
.)
	;
plot_cpy	lda sfx2copy
	ldy #22+120
	jmp display_2dd

eve_mns	; Mnemonic Shortcut
	txa
	sbc #15
	asl
	asl
	asl
	asl
	pha
	jsr re_index
	pla
	ldx event_row
	jsr replace_mnemonic	;A==New Action X==Mnemonic Row
	jsr zero_any_data_bytes
	jmp plot_loop_position


eve_esc	;Ensure rts returns to basic
	jsr inject_effect
	pla
	pla
	;Turn off this irq routine
	lda #$40
	sta $024a
	;
	rts

eve_name	;Enter Name of Effect (8 characters)
.(
	;Remove inverse from Editor cursor (Show focus)
	ldx event_row	;0-15 depending on events
	lda event_display_loc_lo,x
	clc
	adc #01
	sta screen
	lda event_display_loc_hi,x
	adc #00
	sta screen+1
	ldx event_column	;0-4 depending on Mnemonic
	ldy event_cursor_xofs,x
	lda event_cursor_length,x
	tax
loop5	lda (screen),y
	and #127
	sta (screen),y
	iny
	dex
	bne loop5
	;Setup vars
	lda #00
	sta input_cursor_position
	;Clear out input_input_buffer
	ldx #07
	lda #32
loop4	sta input_input_buffer,x
	dex
	bpl loop4
	;Plot Cursor
loop2	ldx input_cursor_position
	lda $bbc7,x
	ora #128
	sta $bbc7,x
	;inkey
loop1	jsr $eb78
	bpl loop1
	;Delete cursor
	ldx input_cursor_position
	pha
	lda $bbc7,x
	and #127
	sta $bbc7,x
	pla
	;act on key
	cmp #127
	beq skip1
	cmp #13
	beq skip2
	cmp #32
	bcc loop2
	;Act on valid ascii
	ldx input_cursor_position
	cpx #08
	beq loop2
	sta input_input_buffer,x
	sta $bbc7,x
	inc input_cursor_position
	jmp loop2
skip1	;Back Space
	ldx input_cursor_position
	beq loop2
	dec input_cursor_position
	dex
	lda #32
	sta input_input_buffer,x
	sta $bbc7,x
	jmp loop2
skip2	;Return
	ldx input_cursor_position
	;If Return at start of line, don't modify
	beq skip3
	jsr calc_name_address
	ldy #07
loop3	lda $bbc7,y
	sta (source),y
	dey
	bpl loop3
skip3	jsr plot_info
.)
	rts

input_input_buffer
 .dsb 8,32
input_cursor_position	.byt 0

calc_name_address
	lda effect_number
	;multiply by 8
	asl
	asl
	asl
	sta source
	lda #$80
	adc #0
	sta source+1
	rts

eve_hear_Effect
	lda loop_error_flag
.(
	bne skip1
	jsr inject_effect
	ldx effect_number
	ldy effect_area,x
	txa
	sta sfx_trigger,y
skip1	rts
.)

eve_delval
	jsr re_index
	ldy event_column
	cpy #02
.(
	bcc skip1
	;Zero data byte
	;Adjust Y so offset from byte
	dey
	;Include byte offset to entry
	ldx event_row
	tya
	clc
	adc IndexKey_ByByteOffset,x
	tay
	;Now update memory buffer
	lda #00
	sta (source),y
	jsr plot_loop_position
skip1	rts
.)

eve_dec	jsr re_index
	ldy event_column
	cpy #00
	beq decrement_mnemonic
	cpy #01
	beq decrement_register
	;decrement data byte
	;Adjust Y so offset from byte
	dey
	;Include byte offset to entry
	ldx event_row
	tya
	clc
	adc IndexKey_ByByteOffset,x
	tay
	;Now update memory buffer
	lda (source),y
	sec
	sbc #01
	sta (source),y
	jsr plot_loop_position
	rts
decrement_mnemonic
	;calc current mnemonic
	jsr re_index
	ldx event_row
	ldy IndexKey_ByByteOffset,x
	lda (source),y
	and #$f0
	sec
	sbc #$10
	and #$f0
	ora #15
	jsr replace_mnemonic	;A==New Action X==Mnemonic Row
	jsr zero_any_data_bytes
	jmp plot_loop_position

zero_any_data_bytes
	;Zero any data bytes
	ldx event_row
	ldy IndexKey_ByMnemonic,x
	lda mnemonic_data_bytes,y
.(
	beq skip1	;No Data Bytes
	ldy IndexKey_ByByteOffset,x
	;Adjust to start of data bytes
	iny
	;store data byte counter
	sta counter
	lda #00
loop1	sta (source),y
	iny
	dec counter
	bne loop1
skip1	rts
.)

decrement_register
	jsr re_index
	ldx event_row
	ldy IndexKey_ByByteOffset,x
	lda (source),y
	and #$f0
	sta temp_01
	lda (source),y
	and #15
	sec
	sbc #01
	and #15
	ora temp_01
	sta (source),y
	jmp plot_loop_position

eve_inc	jsr re_index
	ldy event_column
	cpy #00
	beq increment_mnemonic
	cpy #01
	beq increment_register
	;decrement data byte
	;Adjust Y so offset from byte
	dey
	;Include byte offset to entry
	ldx event_row
	tya
	clc
	adc IndexKey_ByByteOffset,x
	tay
	;Now update memory buffer
	lda (source),y
	clc
	adc #01
	sta (source),y
	jsr plot_loop_position
	rts
increment_mnemonic
	;calc current mnemonic
	jsr re_index
	ldx event_row
	ldy IndexKey_ByByteOffset,x
	lda (source),y
	and #$f0
	clc
	adc #$10
	and #$f0
	ora #15
	jsr replace_mnemonic	;A==New Action X==Mnemonic Row
	jsr zero_any_data_bytes
	jmp plot_loop_position

increment_register
	jsr re_index
	ldx event_row
	ldy IndexKey_ByByteOffset,x
	lda (source),y
	and #$f0
	sta temp_01
	lda (source),y
	and #15
	clc
	adc #01
	and #15
	ora temp_01
	sta (source),y
	jmp plot_loop_position

eve_insert
	jsr setup_b400
	jsr store_data_in_vertical_tables
	ldx event_row
	jsr scroll_vertical_tables_down
	ldx event_row
	lda #$10
	sta vertical_action,x
	jsr recompile_from_vertical_tables
	jsr re_index
	jmp zero_any_data_bytes

eve_delete
	jsr setup_b400
	jsr store_data_in_vertical_tables
	ldx event_row
	jsr scroll_vertical_tables_up
	jsr recompile_from_vertical_tables
	jsr re_index
	jmp plot_loop_position

scroll_vertical_tables_down
	stx temp_01	;Start point
	ldx #22
.(
loop1	lda vertical_action,x
	sta vertical_action+1,x
	lda vertical_db1,x
	sta vertical_db1+1,x
	lda vertical_db2,x
	sta vertical_db2+1,x
	lda vertical_db3,x
	sta vertical_db3+1,x
	dex
	bmi skip1
	cpx temp_01
	bcs loop1
skip1	rts
.)

scroll_vertical_tables_up
.(
loop1	lda vertical_db1+1,x
	sta vertical_db1,x
	lda vertical_db2+1,x
	sta vertical_db2,x
	lda vertical_db3+1,x
	sta vertical_db3,x
	lda vertical_action+1,x
	sta vertical_action,x
	and #$f0
	beq skip1
	inx
	cpx #23
	bcc loop1
skip1	rts
.)

store_data_in_vertical_tables
	ldx #00
.(
loop1	ldy IndexKey_ByByteOffset,x
	lda (source),y
	sta vertical_action,x
	pha
	iny
	lda (source),y
	sta vertical_db1,x
	iny
	lda (source),y
	sta vertical_db2,x
	iny
	lda (source),y
	sta vertical_db3,x
	pla
	and #$f0
	beq skip1
	inx
	cpx #24
	bcc loop1
skip1	rts
.)

replace_action
	ldx row_offset
	lda temp_01
	sta vertical_action,x
	rts

recompile_from_vertical_tables
	ldx #00
	stx row_offset
.(
loop2	lda vertical_action,x
	ldy row_offset
	sta (source),y
	inc row_offset
	lsr
	lsr
	lsr
	lsr
	tay
	lda mnemonic_data_bytes,y
	beq skip3
	sta counter
	lda vertical_db1,x
	ldy row_offset
	sta (source),y
	inc row_offset
	dec counter
	beq skip3
	lda vertical_db2,x
	ldy row_offset
	sta (source),y
	inc row_offset
	dec counter
	beq skip3
	lda vertical_db3,x
	ldy row_offset
	sta (source),y
	inc row_offset
skip3	lda vertical_action,x
	and #$f0
	beq skip2
	inx
	cpx #24
	bcc loop2
skip2	rts
.)

replace_mnemonic	;A==New Action X==Mnemonic Row
	sta temp_01
	stx row_offset
	;Store data to vertical tables
	jsr store_data_in_vertical_tables
	;Replace Action
	jsr replace_action
	;Recompile
	jsr recompile_from_vertical_tables
	jsr re_index
	rts





eve_down
	jsr re_index
	ldx event_row
	cpx #23
.(
	bcs skip1
	lda IndexKey_ByMnemonic,x
	beq skip1
	inc event_row
	lda event_column
	beq skip1
	;Reset Column to 1
	lda #01
	sta event_column
skip1	rts
.)

eve_up
	ldx event_row
.(
	beq skip1
	dec event_row
	lda event_column
	beq skip1
	;Reset Column to 1
	lda #01
	sta event_column
skip1	rts
.)

eve_left
	lda event_column
.(
	beq skip1
	dec event_column
skip1	rts
.)

eve_right
	jsr re_index
	ldx event_row
	ldy IndexKey_ByMnemonic,x
	lda event_column
	cmp mnemonic_data_bytes,y
.(
	beq skip2
	bcs skip1
skip2	inc event_column
skip1	rts
.)
setup_b400
	lda #<$b400
	sta source_buffer
	lda #>$b400
	sta source_buffer+1
	rts

re_index
	lda #<$b400
	sta source_buffer
	lda #>$b400
	sta source_buffer+1
	ldx #00
	stx source_index
	lda #24
	sta row_counter

.(
loop1	ldy source_index
	tya
	sta IndexKey_ByByteOffset,x
	lda (source_buffer),y
	lsr
	lsr
	lsr
	lsr
	sta IndexKey_ByMnemonic,x
	beq skip2
	inx
	tay
	lda mnemonic_data_bytes,y
	sec
	adc source_index
	sta source_index
	dec row_counter
	bne loop1
skip2	;Now locate end of list
	ldx #00
loop2	lda IndexKey_ByMnemonic,x
	beq skip1
	inx
	cpx #24
	bcc loop2
	;Force End at position 23
	ldx #23
	ldy IndexKey_ByByteOffset,x
	;but be careful we don't erase ENDs register
	lda (source_buffer),y
	and #$f0
	beq skip1
	;Erase it
	lda #00
	sta (source_buffer),y
skip1	stx IndexKey_EndPosition
	rts
.)


display_screen
	lda #<$bb80
	sta screen
	lda #>$bb80
	sta screen+1
	lda #<screen_map
	sta source
	lda #>screen_map
	sta source+1
	ldx #28
.(
loop2	ldy #39
loop1	lda (source),y
	and #127
	sta (screen),y
	dey
	bpl loop1
	lda source
	clc
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1

	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex
	bne loop2
.)
	rts

plot_event_cursor
	ldx event_row	;0-15 depending on events
	lda event_display_loc_lo,x
	clc
	adc #01
	sta destination	;screen
	lda event_display_loc_hi,x
	adc #00
	sta destination+1	;screen+1
	ldx event_column	;0-4 depending on Mnemonic
	ldy event_cursor_xofs,x
	lda event_cursor_length,x
	tax
.(
loop1	lda (destination),y
	ora #128
	sta (destination),y
	iny
	dex
	bne loop1
.)
	rts

store_test_values
	ldx #23
.(
loop1	lda test_values,x
	sta $b400,x
	dex
	bpl loop1
.)
	rts

plot_event_list
	lda #<$b400
	sta source_buffer
	lda #>$b400
	sta source_buffer+1

	lda #<$bb81+3*40
	sta screen
	lda #>$bb81+3*40
	sta screen+1

	lda #24
	sta row_counter
.(
loop2	; Clear complete row
;	jsr clear_event_row
	; Fetch and display mnemonic
	ldy #00
	lda (source_buffer),y
	sta action_byte
	jsr calculate_mnemonic_name_index
	ldy #00
	jsr display_mnemonic_name
	; Fetch and display Register
	lda action_byte
	and #$f0
	cmp #$60
	beq skip5	;PER - Register is period
	cmp #$B0
	beq skip5	;PER - Register is period Hi
	cmp #$50
	beq skip5	;LEV - Register is Row from start
	lda action_byte
	jsr calculate_register_name_index
	ldy #4
	jsr display_register_name
	; Now fetch any data bytes ans display them
skip4	jsr inc_source_buffer
	ldx mnemonic_index
	lda #8
	sta row_offset
	lda mnemonic_data_bytes,x
	beq skip1
	sta counter

loop1	ldy #00
	lda (source_buffer),y
	ldy row_offset
	jsr display_hex
	jsr inc_source_buffer
	inc row_offset
	inc row_offset
	inc row_offset
	dec counter
	bne loop1
skip1	; Delete from row_offset up to 15
	ldy row_offset
	lda #32
loop5	cpy #16
	bcs skip8
	sta (screen),y
	iny
	jmp loop5
skip8	lda action_byte
	and #$f0
	beq skip3
	;
	lda screen
	clc
	adc #40
	sta screen
	bcc skip2
	inc screen+1
skip2	;
	dec row_counter
	bne loop2
	rts
skip3	;If exiting because we've found End,
	;then clear remaining lines
	dec row_counter
	beq skip7
loop4	lda screen
	clc
	adc #40
	sta screen
	bcc skip6
	inc screen+1
skip6	;
	jsr clear_event_row
	dec row_counter
	bne loop4
skip7	rts

clear_event_row
	ldy #15
	lda #8
loop3	sta (screen),y
	dey
	bpl loop3
	rts

;Display Register as data byte
skip5     lda #32
	ldy #4
	sta (screen),y
	lda action_byte
	and #15
	iny
	jsr display_hex
	jmp skip4
.)



inc_source_buffer
	inc source_buffer
.(
	bne skip1
	inc source_buffer+1
skip1	rts
.)

display_mnemonic_name
	lda #03
	sta counter
.(
loop1	lda mnemonic_name,x
	sta (screen),y
	inx
	iny
	dec counter
	bne loop1
.)
	rts

calculate_mnemonic_name_index
	lsr
	lsr
	lsr
	lsr
	sta mnemonic_index
	;
calc_rent	sta temp_01
	asl
	adc temp_01
	tax
	rts

calculate_register_name_index
	and #15
	jmp calc_rent

display_register_name
	lda #03
	sta counter
.(
loop1	lda register_name,x
	sta (screen),y
	inx
	iny
	dec counter
	bne loop1
.)
	rts

display_hex
	pha
	lsr
	lsr
	lsr
	lsr
	jsr calc_hex
	sta (screen),y
	pla
	and #15
	jsr calc_hex
	iny
	sta (screen),y
	iny
	rts
calc_hex
	ora #48
	cmp #58
.(
	bcc skip1
	adc #06
skip1	rts
.)

display_3dd
	;Display 3 digit Decimal (A) from (source),y
	ldx #"0"-1
	sec
.(
loop1	inx
	sbc #100
	bcs loop1
.)
	adc #100
	pha
	txa
	sta (screen),y
	iny
	pla
display_2dd
	ldx #"0"-1
	sec
.(
loop2	inx
	sbc #10
	bcs loop2
.)
	adc #58
	pha
	txa
	sta (screen),y
	iny
	pla
	sta (screen),y
	rts

;Display AY Monitor @18,23
; "ENV:FFFF CYC:F NOI:1FI"
; "PTA:FFF Vol:15 E T N I"
; "PTB:FFF Vol:15 E T N I"
; "PTC:FFF Vol:>> E T N I"
ay_monitor
	;Sort Pitches
	ldx #05
.(
loop1	ldy ay_pitch_screen_ofs,x
	lda ay_pitch_format,x	;128 for 2 digit otherwise 1
	asl
	lda sfx_ay_registers,x
	jsr display_monitorhex
	dex
	bpl loop1
	;Sort Noise
	lda sfx_ay_registers+6
	sec
	ldy #13
	jsr display_monitorhex
	;Sort Status Flags E T N and Volumes
	ldx #02
	;Tone Flag
loop2	lda sfx_ay_registers+7
	ldy #"T"
	and status_monitor_tone,x
	beq skip1
	ldy #" "
skip1	tya
	ldy ay_monitor_stats_ofs,x
	sta $bf2b,y
	;Noise Flag
	lda sfx_ay_registers+7
	ldy #"N"
	and status_monitor_noise,x
	beq skip2
	ldy #" "
skip2	tya
	ldy ay_monitor_stats_ofs,x
	sta $bf2c,y
	;Envelope Flag
	ldy sfx_ay_registers+8,x
	cpy #$10
	bcs skip3
	;plot volume in decimal
	tya
	ldy #"0"
	pha
	cmp #10
	bcc skip5
	pla
	sbc #10
	pha
	iny
skip5	tya
	ldy status_monitor_vol_ofs,x
	sta $bf26,y
	pla
	ora #48
	sta $bf27,y
	lda #" "
	jmp skip4
skip3	;plot >> where volume was
	lda #">"
	ldy status_monitor_vol_ofs,x
	sta $bf26,y
	sta $bf27,y
	lda #"E"
skip4	ldy ay_monitor_stats_ofs,x
	sta $bf2a,y
	;
	dex
	bpl loop2
.)
	;plot Cycle
	lda sfx_ay_registers+13
	clc
	ldy #6
	jsr display_monitorhex
	;plot Envelope Period
	lda sfx_ay_registers+12
	ldy #2
	sec
	jsr display_monitorhex
	lda sfx_ay_registers+11
	ldy #4
	sec
	jsr display_monitorhex
	;Plot Effect triggers
	ldx #02
.(
loop1	lda sfx_trigger,x
	ldy sfx_trigger_ofs,x
	sec
	jsr display_monitorhex
	dex
	bpl loop1
.)
	rts

display_monitorhex
	php
	sta monitor_temp
	and #15
	cmp #10
.(
	bcc skip1
	adc #06
skip1	adc #48
	sta $bf2b,y
	plp
	bcc skip3
	lda monitor_temp
	lsr
	lsr
	lsr
	lsr
	cmp #10
	bcc skip2
	adc #06
skip2	adc #48
	sta $bf2a,y
skip3	rts
.)




status_monitor_tone
 .byt 1,2,4
status_monitor_noise
 .byt 8,16,32
status_monitor_vol_ofs
 .byt 52,92,132
ay_monitor_stats_ofs
 .byt 51,91,131
ay_pitch_screen_ofs
 .byt 44,42,84,82,124,122
ay_pitch_format
 .byt 128,0,128,0,128,0
sfx_trigger_ofs
 .byt 19,59,99

monitor_temp	.byt 0
;   0	END
;   1	SWM	Mask		Value
;   2	EVU	Step		Delay
;   3	EVD	Step		Delay
;   4	STE
;   5	LEV	Steps
;   6	PER	Period
;   7       SET	Value
;   8	ZRG
;   9	CEU	Step		Delay		Threshold
;   10      CED       Step		Delay

#include "new_sfx.s"

test_values
 .byt $78,$0F	  ;SET v-a $0F    	Set Volume A to 15 (No Env)
 .byt $17,$FE,$00	  ;SWM stt $FE $00	Enable Tone on A
 .byt $70,$10	  ;SET pal $10    	Set Pitch A Low to 16
 .byt $71,$08	  ;SET pah $08    	Set Pitch A High to 8
 .byt $96,$01,$FF,$1F ;CEU noi $01 $FF $1FRaise Noise (limit 31)
 .byt $A8,$01,$80	  ;CED v-a $01 $80    Drop Volume to Min
 .byt $20,$03,$40	  ;EVU pal $03 $40	Rising pitch Envelope
 .byt $B0,$10	  ;LPR     $10	Pause 16 cycles
 .byt $68		  ;PER $08		Pause 8 Cycles
 .byt $0F		  ;END		End


event_row		.byt 0
event_column	.byt 0
source_index	.byt 0
IndexKey_EndPosition .byt 0
effect_number	.byt 0
effect_size	.byt 0
temp_01		.byt 0
mnemonic_index	.byt 0
help_page		.byt 0
loop_error_flag	.byt 0
sfx2copy		.byt 0

event_display_loc_lo
 .byt <$bbF8
 .byt <$bbF8+40*1
 .byt <$bbF8+40*2
 .byt <$bbF8+40*3
 .byt <$bbF8+40*4
 .byt <$bbF8+40*5
 .byt <$bbF8+40*6
 .byt <$bbF8+40*7
 .byt <$bbF8+40*8
 .byt <$bbF8+40*9
 .byt <$bbF8+40*10
 .byt <$bbF8+40*11
 .byt <$bbF8+40*12
 .byt <$bbF8+40*13
 .byt <$bbF8+40*14
 .byt <$bbF8+40*15
 .byt <$bbF8+40*16
 .byt <$bbF8+40*17
 .byt <$bbF8+40*18
 .byt <$bbF8+40*19
 .byt <$bbF8+40*20
 .byt <$bbF8+40*21
 .byt <$bbF8+40*22
 .byt <$bbF8+40*23
event_display_loc_hi
 .byt >$bbF8
 .byt >$bbF8+40*1
 .byt >$bbF8+40*2
 .byt >$bbF8+40*3
 .byt >$bbF8+40*4
 .byt >$bbF8+40*5
 .byt >$bbF8+40*6
 .byt >$bbF8+40*7
 .byt >$bbF8+40*8
 .byt >$bbF8+40*9
 .byt >$bbF8+40*10
 .byt >$bbF8+40*11
 .byt >$bbF8+40*12
 .byt >$bbF8+40*13
 .byt >$bbF8+40*14
 .byt >$bbF8+40*15
 .byt >$bbF8+40*16
 .byt >$bbF8+40*17
 .byt >$bbF8+40*18
 .byt >$bbF8+40*19
 .byt >$bbF8+40*20
 .byt >$bbF8+40*21
 .byt >$bbF8+40*22
 .byt >$bbF8+40*23
event_cursor_xofs
 .byt 0,4,8,11,14
event_cursor_length
 .byt 3,3,2,2,2

mnemonic_data_bytes
 .byt 0
 .byt 2
 .byt 2
 .byt 2
 .byt 0
 .byt 0
 .byt 0
 .byt 1
 .byt 0
 .byt 3
 .byt 2
 .byt 1
 .byt 0
 .byt 1
 .byt 2
 .byt 2
mnemonic_name
 .asc "END"	;0
 .asc "SWM"         ;1
 .asc "EVR"         ;2
 .asc "EVF"         ;3
 .asc "STE"         ;4
 .asc "LEV"         ;5
 .asc "PER"         ;6
 .asc "SET"         ;7
 .asc "ZRG"         ;8
 .asc "CER"         ;9
 .asc "CEF"         ;A
 .asc "LPR"         ;B
 .asc "EOE"         ;C
 .asc "RRB"         ;D
 .asc "16R"         ;E
 .asc "16F"         ;F
register_name
 .asc "pal"
 .asc "pah"
 .asc "pbl"
 .asc "pbh"
 .asc "pcl"
 .asc "pch"
 .asc "noi"
 .asc "stt"
 .asc "v-a"
 .asc "v-b"
 .asc "v-c"
 .asc "evl"
 .asc "evh"
 .asc "evc"
 .asc "---"
 .asc "---"


;Note that Effects marked with a x can be EOE'd to (0-15)
screen_map
 ;     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 .asc "%$$$%$$$%$$%$$%$$%$$$$$$$$$$$$$$$$$$$$$%"
 .asc "£MNE£REG£D1£D2£D3£SFX:15x Name:BirdSng1£"
 .asc "%$$$%$$$%$$%$$%$$%        Area:Nature  £"
 .asc "£                £CPY:00  Byte:23 of 64£"
 .asc "£                £                     £"
 .asc "£                £ SFX Editor (For TOL)£"
 .asc "£                £ Twilighte 2005      £"
 .asc "£                £ V1.2                £"
 .asc "£                £                     £"
 .asc "£                £ 64 Effects          £"
 .asc "£                £ 3 Areas             £"
 .asc "£                £                     £"
 .asc "£                £ H for Help Pages    £"
 .asc "£                £                     £"
 .asc "£                £ This Page will not  £"
 .asc "£                £ Display again.      £"
 .asc "£                £                     £"
 .asc "£                £                     £"
 .asc "£                £                     £"
 .asc "£                £                     £"
 .asc "£                £                     £"
 .asc "£                £                     £"
 .asc "£                %$$$$$$$AY$$$$$$%$SFX$%"
 .asc "£                £E:FFFF-F NOI:00£A0:00£"
 .asc "£                £PA:FFF V15 ETN £A1:00£"
 .asc "£                £PB:FFF V15 ETN £A2:00£"
 .asc "£                £PC:FFF V15 ETN £IRQ:X£"
 .asc "%$$$$$$$$$$$$$$$$%$$$$$$$$$$$$$$$%$$$$$%"


help_page_address_lo
 .byt <help_page1,<help_page2,<help_page3,<help_page4
help_page_address_hi
 .byt >help_page1,>help_page2,>help_page3,>help_page4

 ;     ---------------------
;Help Page 1 - Instructions
help_page1
 .asc "-=Notes=-            "
 .asc "MNE is Action, REG is"
 .asc "acting Register and  "
 .asc "D!,D2,D3 are the data"
 .asc "For the Action. Press"
 .asc "H For further Help   "
 .asc "Pages.               "
 .asc "LPR provides a Long  "
 .asc "Period from 0 to FFF "
 .asc "Useful stt settings:-"
 .asc "    A1 2 B1 2 C1 2   "
 .asc "TN  F600 ED00 DB00   "
 .asc "-T  F608 ED10 DB20   "
 .asc "N-  F601 ED02 DB04   "
 .asc "--  F609 ED12 DB24   "
 .asc "Useful Cycle Settings"
 .asc "00 Descnd 08 Sawtooth"
 .asc "0D Ascend 0E Triangle"
;Help Page 2 - General Keys
help_page2
 .asc "-=General Keys=-     "
 .asc " Help Pages    H     "
 .asc " Select Effect ,.    "
 .asc " Select Area   []    "
 .asc " Navigation    CRSR  "
 .asc " Change Value  -=    "
 .asc " Delete Value  DEL   "
 .asc " Insert Row  CTRL+I  "
 .asc " Delete Row  CTRL+D  "
 .asc "*Highlight   SH+CRSR "
 .asc " Copy SFX    CTRL+C  "
 .asc " Paste SFX   CTRL+V  "
 .asc " Hear Effect Return  "
 .asc "*Test Row    Space   "
 .asc " Silence All   0     "
 .asc " Disc Menu  ESC      "
 .asc "*==Not Yet Done :(   "
 .asc "                     "

;Help Page 2 - Mnemonics
help_page3
 .asc "-=Mnemonic Actions=- "
 .asc "H - Help Pages       "
 .asc "E : END End SFX      "
 .asc "M : SWM Set with Mask"
 .asc "R : EVR Envelope Rise"
 .asc "F : EVF Envelope Fall"
 .asc "S : STE Stop Envelope"
 .asc "L : LEV Loop Envelope"
 .asc "P : PER Period!!     "
 .asc "T : SET Set Register "
 .asc "Z : ZRG Zero Register"
 .asc "C : CER Cond-Env-Rise"
 .asc "V : CEF Cond-Env-Fall"
 .asc "W : LPR Long Period!!"
 .asc "G : GSB Gosub SFX    "
 .asc "B : RRB RND Reg4Per' "
 .asc "6 : 16R 16Bit EnvRise"
 .asc "7 : 16F 16Bit EnvFall"
;Help Page 3 - Data Bytes
help_page4
 .asc "-=Data Bytes=-       "
 .asc "H - Help Pages       "
 .asc "E : END              "
 .asc "M : SWM Mask,Value   "
 .asc "R : EVR Step,F-Delay "
 .asc "F : EVF Step,F-Delay "
 .asc "S : STE              "
 .asc "L : LEV              "
 .asc "P : PER              "
 .asc "T : SET Value        "
 .asc "Z : ZRG              "
 .asc "C : CER Step,Dly,Limt"
 .asc "V : CEF Step,F-Delay "
 .asc "W : LPR Period Lo    "
 .asc "G : GSB              "
 .asc "B : RRB Bits         "
 .asc "6 : 16R Step,F-Delay "
 .asc "7 : 16F Step,F-Delay "

event_key
 .byt 10,11,8,9
 .byt "-","="
 .byt "I","D"
 .byt ",","."
 .byt "[","]"
 .byt 127
 .byt 13
 .byt 27
 .byt "EMRFSLPTZCVWGB67"
 .byt "H"
 .byt "N"
 .byt "0"
 .byt 3,22
event_key_vector_lo
 .byt <eve_down,<eve_up,<eve_left,<eve_right
 .byt <eve_dec,<eve_inc
 .byt <eve_insert,<eve_delete
 .byt <eve_deceffect,<eve_inceffect
 .byt <eve_decarea,<eve_incarea
 .byt <eve_delval
 .byt <eve_hear_Effect
 .byt <eve_esc
 .byt <eve_mns,<eve_mns,<eve_mns,<eve_mns
 .byt <eve_mns,<eve_mns,<eve_mns,<eve_mns
 .byt <eve_mns,<eve_mns,<eve_mns,<eve_mns
 .byt <eve_mns,<eve_mns,<eve_mns,<eve_mns
 .byt <eve_help
 .byt <eve_name
 .byt <eve_silence
 .byt <eve_copy,<eve_paste
event_key_vector_hi
 .byt >eve_down,>eve_up,>eve_left,>eve_right
 .byt >eve_dec,>eve_inc
 .byt >eve_insert,>eve_delete
 .byt >eve_deceffect,>eve_inceffect
 .byt >eve_decarea,>eve_incarea
 .byt >eve_delval
 .byt >eve_hear_Effect
 .byt >eve_esc
 .byt >eve_mns,>eve_mns,>eve_mns,>eve_mns
 .byt >eve_mns,>eve_mns,>eve_mns,>eve_mns
 .byt >eve_mns,>eve_mns,>eve_mns,>eve_mns
 .byt >eve_mns,>eve_mns,>eve_mns,>eve_mns
 .byt >eve_help
 .byt >eve_name
 .byt >eve_silence
 .byt >eve_copy,>eve_paste

IndexKey_ByMnemonic
 .dsb 24,0
IndexKey_ByByteOffset
 .dsb 24,0


data_byte_text
 .asc "Volume"
 .asc "Step  "
 .asc "Delay "
 .asc "Limit "
 .asc "Pitch "
 .asc "Noise "
 .asc "EGPer."
 .asc "Cycle "
 .asc "Period"

area_name
 .byt "Nature  "
 .byt "Creature"
 .byt "Hero    "
heading_text ;18 each (Called from BASIC, to be displayed on status line)
 .byt "Save Uncompiled   "
 .byt "Save Compiled SFX "
 .byt "Load Uncompiled   "
 .byt "DISC Menu         "

;Vertical Tables
vertical_action
 .dsb 24,0
vertical_db1
 .dsb 24,0
vertical_db2
 .dsb 24,0
vertical_db3
 .dsb 24,0

editor_chars
 .byt %001100	;Vertical Border (35 #)
 .byt %001100
 .byt %001100
 .byt %001100
 .byt %001100
 .byt %001100
 .byt %001100
 .byt %001100

 .byt %000000	;Horizontal Border (36 $)
 .byt %000000
 .byt %000000
 .byt %111111
 .byt %111111
 .byt %000000
 .byt %000000
 .byt %000000

 .byt %000000	;Border Joint (37 %)
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %010100	;Play Tracking Cursor (38 &)
 .byt %011000
 .byt %011100
 .byt %011110
 .byt %011100
 .byt %011000
 .byt %010100
 .byt %001100

 .byt %000100	;Loop Back Pointer (39 ')
 .byt %001000
 .byt %011100
 .byt %111110
 .byt %011111
 .byt %001011
 .byt %000101
 .byt %001101
