;********* Effect Player(TOL Variant) for SFXED *************
; The TOL variant of effect player does not contain code for
; LEV or EOE
; It also adds Maximum and environmental volume control.
;

;***** Effect IRQ *****
sfx_effect_irq
	; sfx_proc_sfx
	; Scan for new effects
	jsr sfx_scan_effect
	;Process existing Events
	jsr sfx_process_events
	;Process existing Envelopes
	jsr sfx_proc_envelopes
	jsr sfx_generate_random_byte
	jsr sfx_proc_rrb
	jsr sfx_ay_send
	rts

sfx_process_events
	ldx #02
.(
loop1	dec sfx_event_period_lo,x
	bne skip1
	dec sfx_event_period_hi,x
	bpl skip1
	jsr sfx_proc_effect_event
skip1	dex
	bpl loop1
.)
	rts


sfx_proc_envelopes
	ldx #11
.(
loop1	lda sfx_envelope_activity,x
	beq skip1
	sta sfx_envelope_behaviour_flags
	lda sfx_envelope_frac_table,x
	sec
	adc sfx_envelope_delay_table,x
	sta sfx_envelope_frac_table,x
	bcc skip1

	lda sfx_envelope_direction_table,x
	cmp #128
	ldy sfx_envelope_register_table,x
	lda sfx_ay_registers,y
	bcs skip2

	adc sfx_envelope_step_table,x
	bcs skip5
	cmp sfx_envelope_conditional_high,x
	bcc skip3
skip4	bit sfx_envelope_behaviour_flags	;Fetch b6 Flag - Conditional
	bvc skip3
skip6	lda #00
	sta sfx_envelope_activity,x
skip3	sta sfx_ay_registers,y
	jmp skip1

skip2	sbc sfx_envelope_step_table,x
	bcc skip7
	sta sfx_ay_registers,y
skip1	dex
	bpl loop1
	rts
skip5	;Check for 16 bit up
	bit sfx_envelope_behaviour_flags
	bvs skip6	;Follow Conditional rules, ignore 16 bit
	bpl skip3 ;Normal Envelope, not Conditional or 16 bit
	;16 bit up
	sta sfx_ay_registers,y
	lda sfx_ay_registers+1,y
	clc
	adc #01
	sta sfx_ay_registers+1,y
	jmp skip1
skip7	;Check for 16bit down
	bit sfx_envelope_behaviour_flags
	bvs skip6	;Follow Conditional rules, ignore 16 bit
	bpl skip3 ;Normal Envelope, not Conditional or 16 bit
	;16 bit up
	sta sfx_ay_registers,y
	lda sfx_ay_registers+1,y
	sec
	sbc #01
	sta sfx_ay_registers+1,y
	jmp skip1
.)

;***** Effect Initiailisation **********
sfx_scan_effect
	ldy #02
.(
loop1	lda sfx_trigger,y
	bmi skip1
	tax
	ora #128
	sta sfx_trigger,y
	sty sfx_zero_00
	lda loop_error_flag
	bne skip2
	jsr sfx_init_effect
skip2	ldy sfx_zero_00
skip1	dey
	bpl loop1
.)
	rts

;Y == Channel
;X == Effect number
sfx_init_effect
	;Ensure effect 0-63
	txa
	and #63
	tax
	;
	sta sfx_effect_number,y
	;Set SFX Event period to 1(lo),0(hi) for area
	;So that it gets executed immediately
	lda #1
	sta sfx_event_period_lo,y
	lda #0
	sta sfx_event_index,y
	sta sfx_event_period_hi,y
	;Stop rrb if acting in this area
	cpy rrb_area
	bne skip1
	lda #128
	sta rrb_register,y
skip1	;Also stop existing envelopes running in area
.)
	tya
	asl
	asl
	tay
	lda #00
	sta sfx_envelope_activity,y
	sta sfx_envelope_activity+1,y
	sta sfx_envelope_activity+2,y
	sta sfx_envelope_activity+3,y
	rts

;***** Effect Processing **********
sfx_proc_effect_event
.(
	ldy sfx_effect_number,x
	bmi skip1	;Effect finished
	;Calculate envelope group into Y_index
	txa
	asl
	asl
	sta sfx_envelope_tables_index
	;
	lda sfx_effect_event_address_table_lo,y
	sta sfx_zero_00
	lda sfx_effect_event_address_table_hi,y
	sta sfx_zero_01

loop2	ldy sfx_event_index,x
	;Fetch Event Register
	lda (sfx_zero_00),y
	pha
	and #15
	sta sfx_event_register
	;Fetch Event Action
	pla
	inc sfx_event_index,x
	lsr
	lsr
	lsr
	lsr
	tay
	lda sfx_event_action_vector_lo,y
	sta vector1+1
	lda sfx_event_action_vector_hi,y
	sta vector1+2

vector1	jsr $dead
	bcc loop2
skip1	rts
.)


sfx_eav_lev	;Loop Event not used for TOL
sfx_eav_end	;May also constitute RTS(Return) is nested (Called via EOE)
	;Turn off Effect - But envelopes may continue
	lda #128
	sta sfx_effect_number,x
	jsr sfx_eav_zrg
	sec
	rts
sfx_eav_swm	;Set Register using mask and Value
	ldy sfx_event_register
	lda sfx_ay_registers,y
	ldy sfx_event_index,x
	and (sfx_zero_00),y
	iny
	ora (sfx_zero_00),y
	ldy sfx_event_register
	sta sfx_ay_registers,y
	;Skip Two data bytes
	inc sfx_event_index,x
	inc sfx_event_index,x
	clc
	rts
sfx_eav_set
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	ldy sfx_event_register
	sta sfx_ay_registers,y
	;Skip One data byte
	inc sfx_event_index,x
	clc
	rts
sfx_eav_evu	;Set Envelope Up using Delay and Step
	lda #00

	jmp sfx_eav_evd_rent
sfx_eav_evd
	lda #128
sfx_eav_evd_rent
	ldy sfx_envelope_tables_index
	sta sfx_envelope_direction_table,y
	lda sfx_event_register
	sta sfx_envelope_register_table,y
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	inc sfx_event_index,x
	ldy sfx_envelope_tables_index
	sta sfx_envelope_step_table,y
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	inc sfx_event_index,x
	ldy sfx_envelope_tables_index
	sta sfx_envelope_delay_table,y
	lda #00
	sta sfx_envelope_frac_table,y
	lda #1
	sta sfx_envelope_activity,y
	inc sfx_envelope_tables_index
	clc
	rts
sfx_eav_16u	;Envelope Up 16 Bit
	jsr sfx_eav_evu
	lda #128
	sta sfx_envelope_activity,y
	rts
sfx_eav_16d	;Envelope Down 16 Bit
	jsr sfx_eav_evd
	lda #128
	sta sfx_envelope_activity,y
	rts
sfx_eav_ceu
	jsr sfx_eav_evu
	lda #64
	sta sfx_envelope_activity,y
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	inc sfx_event_index,x
	ldy sfx_envelope_tables_index
	dey
	sta sfx_envelope_conditional_high,y
	rts
sfx_eav_ced
	jsr sfx_eav_evd
	lda #64
	sta sfx_envelope_activity,y
	rts
sfx_eav_ste	;Stop Envelope by specifying register
	;So locate Envelope acting on register
	lda #04
	sta sfx_env_count
	ldy sfx_envelope_tables_index
.(
loop1	lda sfx_envelope_register_table,y
	cmp sfx_event_register
	beq skip1
	iny
	dec sfx_env_count
	bne loop1
	;Or Locate RRB acting on register
	lda sfx_event_register
	cmp rrb_register
	beq skip2
	;Cannot find register, so assume stop all
	lda #04
	sta sfx_env_count
	ldy sfx_envelope_tables_index
	lda #00
loop2	sta sfx_envelope_activity,y
	iny
	dec sfx_env_count
	bne loop2
	clc
	rts
skip1	;Stop Y Envelope
	lda #00
	sta sfx_envelope_activity,y
	;Or Locate RRB acting on register
	lda sfx_event_register
	cmp rrb_register
	beq skip2
	clc
	rts
skip2	;Stop RRB action
	lda #128
	sta rrb_register
	clc
	rts
.)

sfx_eav_per	;Period (Register is Period)
	lda sfx_event_register
	sta sfx_event_period_lo,x
	lda #00
	sta sfx_event_period_hi,x
	sec
	rts
sfx_eav_lpr	;Period (in next byte)
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	sta sfx_event_period_lo,x
	lda sfx_event_register
	sta sfx_event_period_hi,x
	inc sfx_event_index,x
	sec
	rts
sfx_eav_zrg	;Zero Register
	ldy sfx_event_register
	cpy #$0E
.(
	bcs skip1
	lda #00
	sta sfx_ay_registers,y
skip1	clc
.)
	rts
sfx_generate_random_byte
	ldx rb_index
	inc rb_index
	lda Setup_IRQ,x
	adc re_index
	sbc sfx_zero_00
	sbc sfx_zero_00
	sta random_byte
	rts
sfx_proc_rrb
	ldx rrb_register
.(
	bmi skip1
	lda rrb_bits
	eor #255
	and sfx_ay_registers,x
	sta sfx_temp_02
	;generate random element
	lda random_byte
	and rrb_bits
	ora sfx_temp_02
	sta sfx_ay_registers,x
skip1	rts
.)
sfx_eav_rrb
	lda sfx_event_register
	sta rrb_register
	stx rrb_area
	ldy sfx_event_index,x
	lda (sfx_zero_00),y
	sta rrb_bits
	;Skip Two data bytes
	inc sfx_event_index,x
	clc
	rts
sfx_ay_send
	;Ensure stt is set correctly
;	lda sfx_ay_registers+7
;	and #%00111111
;	ora #%01000000
;	sta sfx_ay_registers+7
	;Adjust volume
	; 1) Maximum volume
	;	Channels A,B,C per Title Volume
	; 2) Environmental Volume
	;	Channel A Environmental
	;	Channel B Creature locality
	;	Channel C Hero (No Change)
	;Now send
	ldx #13
.(
loop1	lda sfx_ay_registers,x
	cmp sfx_ay_reference,x
	beq skip1
	sta sfx_ay_reference,x
	stx via_porta
	ldy #$ff
	sty via_pcr
	ldy #$dd
	sty via_pcr
	and sfx_ay_filter,x
	sta via_porta
	lda #$fd
	sta via_pcr
	sty via_pcr
skip1	dex
	bpl loop1
.)
	rts

sfx_envelope_behaviour_flags	.byt 0
sfx_envelope_tables_index	.byt 0
sfx_event_register		.byt 0
sfx_temp_01		.byt 0
sfx_temp_02		.byt 0
sfx_env_count		.byt 0
rrb_register		.byt 128
rrb_bits                      .byt 0
rrb_area			.byt 0
rb_index			.byt 0
random_byte		.byt 0
;For editor, each effect event will be 64 bytes long
;and 64 Effects (4096 Bytes)
;This may then be crunched when implemented into TOL
#include "sfx_addresses_lo.s"	;32
#include "sfx_addresses_hi.s"	;32

sfx_effect_number		;3
 .dsb 3,0
sfx_event_index		;3
 .dsb 3,0
sfx_event_period_lo		;3
 .byt 0,0,0
sfx_event_period_hi		;3
 .byt 0,0,0

sfx_envelope_activity		;12
 .dsb 12,0
sfx_envelope_frac_table		;12
 .dsb 12,0
sfx_envelope_delay_table	;12
 .dsb 12,0
sfx_envelope_direction_table	;12
 .dsb 12,0
sfx_envelope_register_table	;12
 .dsb 12,0
sfx_envelope_step_table		;12
 .dsb 12,0
sfx_envelope_conditional_high	;12
 .dsb 12,0

sfx_event_action_vector_lo	;16
 .byt <sfx_eav_end,<sfx_eav_swm,<sfx_eav_evu,<sfx_eav_evd
 .byt <sfx_eav_ste,<sfx_eav_spr,<sfx_eav_per,<sfx_eav_set
 .byt <sfx_eav_zrg,<sfx_eav_ceu,<sfx_eav_ced,<sfx_eav_lpr
 .byt <sfx_eav_spr,<sfx_eav_rrb,<sfx_eav_16u,<sfx_eav_16d
sfx_event_action_vector_hi	;16
 .byt >sfx_eav_end,>sfx_eav_swm,>sfx_eav_evu,>sfx_eav_evd
 .byt >sfx_eav_ste,>sfx_eav_spr,>sfx_eav_per,>sfx_eav_set
 .byt >sfx_eav_zrg,>sfx_eav_ceu,>sfx_eav_ced,>sfx_eav_lpr
 .byt >sfx_eav_spr,>sfx_eav_rrb,>sfx_eav_16u,>sfx_eav_16d

sfx_ay_registers		;14
 .byt 0,0
 .byt 0,0
 .byt 0,0
 .byt 0
 .byt 64
 .byt 0,0,0
 .byt 0
 .byt 0
 .byt 0
sfx_ay_reference		;14
 .byt 255,255
 .byt 255,255
 .byt 255,255
 .byt 255
 .byt 255
 .byt 255,255,255
 .byt 255
 .byt 255
 .byt 255
sfx_ay_filter			;14
 .byt 255,15
 .byt 255,15
 .byt 255,15
 .byt 31
 .byt 255
 .byt 31,31,31
 .byt 255
 .byt 255
 .byt 15
