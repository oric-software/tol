// sfx_editor (oh fuck, an editor to do!)

;  B4-7	b0-3	NEXT	NOTES
;0 PITA	High	Low
;1 ENDT	Volume
;2 PITB	High	Low
;3 LOOP	LURZ	High Back
;4 PITC   High	Low
;5 BNDD	Register	Frac
;6 NOIS	B1-4	-	Crude set Noise
;7 STAT	T\N\E	-
;8 VOLA	0-15      -
;9 VOLB    0-15      -
;A VOLC    0-15      -
;B PERS	High	Low
;C BNDU	Register	Frac
;D CYCS	0-15	-
;E WAIT	High	Low
;F XWAI?   Reg       Value 	Wait until register reaches value?

// An Effect is limited to 24 entries whilst all entries are displayed on screen
#define	via_portb	$0300
#define	via_handa $0301
#define	via_t1ll	$0304
#define	via_pcr	$030c
#define	via_ifr	$030e
#define	via_porta $030F


 .zero
*=$00
zero_00	.dsb 1
zero_01	.dsb 1
zero_02	.dsb 1
zero_03	.dsb 1
source_lo	.dsb 1
source_hi	.dsb 1

irq_zero00	.dsb 1
irq_zero01	.dsb 1
irq_zero02	.dsb 1
irq_zero03	.dsb 1	;9
irq_nextbyte	.dsb 1

 .text


*=$500

	jmp start_sfxed
#include "sfx_editor_tables.s"
#include "sfx_tables.s"
#include "sfx_driver.s"

start_sfxed
	jsr intercept_irq
	ldx #00
	stx cursor_x
	stx cursor_y
	jsr clear_screen
	jsr recalc_sfx_address
	jsr plot_sfx
	jmp navigate


plot_sfx_number
	ldx #03
.(
loop1	lda sfxn_text,x
	sta $bb80+40*25,x
	dex
	bpl loop1
.)
	lda sfx_number
	ldx #<48000+40*25
	stx zero_02
	ldx #>48000+40*25
	stx zero_03
	ldy #04
	jmp plot_hex


plot_sfx  jsr plot_sfx_number
	lda source_lo
	sta zero_00
	lda source_hi
	sta zero_01
	ldy #00	;
	sty source_index
	sty screen_index
.(
loop1	ldy screen_index
	lda ylocl,y
	sta zero_02
	lda yloch,y
	sta zero_03

	ldy source_index
	lda (zero_00),y
	pha
	iny
	lda (zero_00),y
	sta next_byte
	pla
	jsr plot_line
	// Store line_source_index
	ldx screen_index
	lda source_index
	sta line_source_index,x
	// Increment source
	lda first_byte
	and #$f0
	cmp #$10
	beq skip1	;end
	lsr
	lsr
	lsr
	lsr
	tax
	lda source_index
	adc number_of_bytes,x
	sta source_index
	// loop for rest
	inc screen_index
	lda screen_index
	cmp #24
	bcc loop1
skip1
.)
	rts

clear_screen
	ldx #23
.(
loop2	lda ylocl,x
	sta zero_00
	lda yloch,x
	sta zero_01
	ldy #15
	lda #08
loop1	sta (zero_00),y
	dey
	bpl loop1
	dex
	bpl loop2
.)
	rts


navigate	jsr plot_cursor
	jsr $eb78
	bpl navigate
	pha
	jsr delete_cursor
	pla
	ldx #11
.(
loop1	cmp ascii_code,x
	beq skip1
	dex
	bpl loop1
	jmp navigate
skip1	lda key_vector_lo,x
	sta vector1+1
	lda key_vector_hi,x
	sta vector1+2
vector1	jsr $dead
.)
	jmp navigate


key_next
	lda sfx_number
.(
	clc
	adc #01
	and #63
	sta sfx_number
	// recalc sfx_address
	jsr recalc_sfx_address

skip1	jsr clear_screen
	jmp plot_sfx
.)

key_last
	lda sfx_number
.(
	sec
	sbc #01
	and #63
	sta sfx_number
	// recalc sfx_address
	jsr recalc_sfx_address

skip1	jsr clear_screen
	jmp plot_sfx
.)

recalc_sfx_address
	// Multiply sfx number by 48 in 16bits
	lda #00
	sta zero_01
	lda sfx_number
	asl
	rol zero_01
	asl
	rol zero_01
	asl
	rol zero_01
	asl
	rol zero_01
	sta zero_02
	lda zero_01
	sta zero_03
	lda zero_02
	asl
	rol zero_01
	adc zero_02
	sta zero_00
	lda zero_01
	adc zero_03
	sta zero_01
	// Now add base address
	lda zero_00
	adc #<effect_memory
	sta source_lo
	lda zero_01
	adc #>effect_memory
	sta source_hi
	rts



key_minus
	jsr reserve_remainder
	ldx cursor_y
	ldy line_source_index,x
	ldx cursor_x
.(
	cpx #01
	bcs skip1
	lda (source_lo),y
	and #$f0
	sec
	sbc #16
	and #$f0
	sta reserved
	lda (source_lo),y
	and #$0f
	ora reserved
	sta (source_lo),y
	jsr plot_sfx
	jmp restore_remainder
skip1	bne skip2
	lda (source_lo),y
	and #15
	sec
	sbc #1
	and #15
	sta reserved
	lda (source_lo),y
	and #$f0
	ora reserved
	sta (source_lo),y
	jmp plot_sfx
skip2	iny
.)
	lda (source_lo),y
	sec
	sbc #1
	sta (source_lo),y
	jmp plot_sfx




key_plus
	jsr reserve_remainder
	ldx cursor_y
	ldy line_source_index,x
	ldx cursor_x
.(
	cpx #01
	bcs skip1
	lda (source_lo),y
	and #$f0
	clc
	adc #16
	and #$f0
	sta reserved
	lda (source_lo),y
	and #$0f
	ora reserved
	sta (source_lo),y
	jsr plot_sfx
	jmp restore_remainder
skip1	bne skip2
	lda (source_lo),y
	and #15
	clc
	adc #1
	and #15
	sta reserved
	lda (source_lo),y
	and #$f0
	ora reserved
	sta (source_lo),y
	jmp restore_remainder
skip2	iny
.)
	lda (source_lo),y
	clc
	adc #1
	sta (source_lo),y
	jmp plot_sfx


key_l	lda cursor_x
.(
	beq skip1
	dec cursor_x
	jsr fetch_screen_char
	cmp #48
	bcs skip1
	inc cursor_x
skip1	rts
.)

key_r	lda cursor_x
.(
	cmp #02
	beq skip1
	inc cursor_x
	jsr fetch_screen_char
	cmp #48
	bcs skip1
	dec cursor_x
skip1	rts
.)

key_d	lda cursor_y
.(
	cmp #23
	bcs skip1
	inc cursor_y
	jsr fetch_screen_char
	cmp #48
	bcs skip1
	dec cursor_y
skip1	rts
.)

key_u	lda cursor_y
.(
	beq skip1
	dec cursor_y
	jsr fetch_screen_char
	cmp #48
	bcs skip1
	inc cursor_y
skip1	rts
.)

key_esc	pla
	pla
	rts

fetch_screen_char
	ldy cursor_y
	ldx cursor_x
	lda ylocl,y
	clc
	adc offset_x,x
	sta zero_00
	lda yloch,y
	adc #00
	sta zero_01
	ldy #00
	lda (zero_00),y
	rts

plot_cursor
	ldx cursor_x	;0 to 2 (Dependant on screen)
	ldy cursor_y	;dependant on end (controlled by parent)
	lda ylocl,y
	clc
	adc offset_x,x
	sta zero_00
	lda yloch,y
	adc #00
	sta zero_01
	ldy end_of_field,x
.(
loop1	lda (zero_00),y
	ora #128
	sta (zero_00),y
	dey
	bpl loop1
.)
	rts
delete_cursor
	ldx cursor_x	;0 to 2 (Dependant on screen)
	ldy cursor_y	;dependant on end (controlled by parent)
	lda ylocl,y
	clc
	adc offset_x,x
	sta zero_00
	lda yloch,y
	adc #00
	sta zero_01
	ldy end_of_field,x
.(
loop1	lda (zero_00),y
	and #127
	sta (zero_00),y
	dey
	bpl loop1
.)
	rts


plot_line	sta first_byte
	and #$f0
	lsr
	lsr
	;A = steps of 4
	tax
	lda command_text,x
	ldy #00
	sta (zero_02),y
	iny
	lda command_text+1,x
	sta (zero_02),y
	iny
	lda command_text+2,x
	sta (zero_02),y
	iny
	lda command_text+3,x
	sta (zero_02),y
	iny
	iny
	lda first_byte
	and #15
	jsr plot_hex	;@02,y == A
	iny
	txa
	lsr
	lsr
	tax
	lda number_of_bytes,x
	cmp #01
.(
	beq skip1
	lda next_byte
	jsr plot_hex
skip1	rts
.)

plot_hex
	pha
	lsr
	lsr
	lsr
	lsr
	jsr calc_hex
	sta (zero_02),y
	pla
	and #15
	jsr calc_hex
	iny
	sta (zero_02),y
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




intercept_irq
	sei
	lda #<irq_intercepter
	sta $24b
	lda #>irq_intercepter
	sta $24c
	lda #$4c
	sta $24a
	cli
	rts

irq_intercepter
	pha
	txa
	pha
	tya
	pha
	jsr proc_sfx
	pla
	tay
	pla
	tax
	pla
	rti


;	          TRACKING
;	  PITA  VA TNE  ENVP CYC
;PITA 00 00  0000  00 000  0000  0
;STAT 01     0000  00 100  0000  0
;VOLA 0A     0000  10 100  0000  0
;BNDU 00 05  ^^^^  -- 100  0000  0
;WAIT 05 03  0005  10 100  0000  0

;Looks at subsequent entries of effect and stores to temporary buffer(rem_buffer)
reserve_remainder
	// Check if cursor already on bottom entry
	ldx cursor_y
	cpx #23
.(
	bcs skip1
	// look at first subsequent line
	inx
	ldy line_source_index,x
	//
	ldx #00
loop1	lda (source_lo),y
	sta rem_buffer,x
	inx
	iny
	cpy #48
	bcc loop1
skip1	rts
.)

;recalls rem_buffer to new subsequent entries
restore_remainder
	// the sfx has already been re-plotted in order to regenerate the line_source_index
	ldx cursor_y
	inx
	ldy line_source_index,x
	//
	ldx #00
.(
loop1	lda rem_buffer,x
	sta (source_lo),y
	inx
	iny
	cpy #48
	bcc loop1
.)
	// Now plot sfx once more to update the line_source_index
	jsr clear_screen
	jsr plot_sfx
	rts

key_play0
	// Play current Effect as index 0 Effect
	// 1) Validate effect (Check for infinite loops)
	// 2) Setup effect
	lda sfx_number
	jsr validate_effect
.(
	bcc skip1
	lda sfx_number
	ldx #00
	jsr setup_effect
skip1	rts
.)

key_play1
	// Play current Effect as index 1 Effect
	// 1) Validate effect (Check for infinite loops)
	// 2) Setup effect
	lda sfx_number
	jsr validate_effect
.(
	bcc skip1
	lda sfx_number
	ldx #01
	jsr setup_effect
skip1	rts
.)

key_play2
	// Play current Effect as index 2 Effect
	// 1) Validate effect (Check for infinite loops)
	// 2) Setup effect
	lda sfx_number
	jsr validate_effect
.(
	bcc skip1
	lda sfx_number
	ldx #02
	jsr setup_effect
skip1	rts
.)

insert_line
delete_line


;A - sfx_number
;C - Set if everything ok
validate_effect
	// look for invalid loop
	lda #128
	sta error_flag
	ldx #00
loop1	ldy line_source_index,x
	lda (source_lo),y
	and #$f0
	cmp #$10	;EndT
	beq skip2
	cmp #$30	;loop
	bne skip1
	jsr validate_loop
skip1     inx
	cpx #24
	bcc loop1
skip2	lda error_flag
	bmi skip3
	jsr plot_error
	clc
skip3	rts

validate_loop
	lda line_source_index,x
	iny
	iny
	?sbc (source_lo),y
	sta zero_00
	lda source_hi

	clc
	adc

plot_error


	// look for a wait before loop
	// look for an invalid loop
message_0
 .byt "LOOP points before this effect"
 .byt "LOOP points beyond this effect"
 .byt "LOOP points to an invalid pos!"
 .byt "LOOP has not been set         "

 .byt "no WAIT within LOOP"


;A - sfx_number
;X - SFX Index
setup_effect
