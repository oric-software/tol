;********* Effect Driver *************
; Each effect contains an event list.
; Each event directs Envelopes for selected AY registers
; Each channel has up to 4 independant Envelopes
;
;
; The Formats are very simple.
; The Events take the form of Action,Data,Period
; If a particular Action requires bytes of data, then these
; immediately follow the action byte.
; The next Action byte follows the data.
; When all actions have been taken for the next stage in the
; effect development, the final action is always 'Period' which
; sets the period for the effect before resuming actions again.
;
; Action Byte
; The Action byte is split into two 4 bit nibbles.
; Te lower 4 bits specify the AY Register the action will be based
; upon.
; The upper 4 bits specify the action to take.
; Here is a breakdown of the Actions.
; Number Action	DataByte1	Data Byte2 Data Byte3  Key Name
;   0	END                                        E   End
;   1	SWM	Mask	Value                  M   Set Reg With Mask
;   2	EVU	Step	Delay                  U   EnVelope Up
;   3	EVD	Step	Delay                  D   EnVelope Down
;   4	STE                                        S   STop Envelope
;   5	LEV	Steps                            L   Loop EnVelope
;   6	PER				   P   PERiod
;   7     SET	Value                            T   SET register
;   8	ZRG                                        Z   ZeRo Register
;   9	CEU	Step	Delay	 Threshold   C   Cond'Env Up
;   10    CED       Step	Delay                  V   Cond'Env Down
;   11	LPR	Period                           W   Long Period
;   12	EOE                                        G   Execute Other SFX
;   13    rrb       Bits                             ?   Random Reg. Bits
;   14    16R       Step      Delay                  6   16Bit Env Up
;   15    16F	Step	Delay		   7   16Bit Env Down
;Need random element and way to invert bits in register
; And now Details of each Action

;envelope u/d should overide any other envelope also moving u/d on same
;register

; ** SSR Action  1 ($01+Number)
; 0 A-TNX
; 1 A-TXX
; 2 A-XNX
; 3 A-XXX
; 4 A-TXE
; 4 B-TN
; 5 B-TX
; 6 B-XN
; 7 B-XX
; 8 C-TN
; 9 C-TX
; A C-Xn
; B C-XX
;
; ** END Action  0 ($00+Register)
; End will end the Event. It will not neccesarily end the Envelopes
; currently running.
; If the register is valid (00-0D) then Zero will be written to the
; register. This is useful to silence the sound when the effect has
; finished.
;
; For Example, to End Effect and silence the sound, we would use $08,
; and to End the effect but do not silence the sound, we would use $0F.
;
;
; ** SWM Action  1 ($10+Register), Mask, Value
; SWM (Set With Mask) will store the subsequent value in the specified
; register using the mask to filter bits that should not be changed.
;
; For example, to Set the Tone bit for Channel B, we would use
; $17,$FD,$02
;
; ** EVU Action  2 ($20+Register), Step, Delay
; EVU (EnVelope Up) will setup an Envelope to raise the value of the
; specified Register by a specified step at a specified speed.
; The Speed is held in Delay and is a fractional Delay so 0 will be
; very slow, and 255 will be at the speed of the interrupt (50Hz)
;
; For example, to setup a Volume rise on Channel C at steps of 1 and
; at half the speed of the Interrupt we would use $2A,$01,$80
;
; ** EVD Action  3 ($30+Register), Step, Delay
; EVD (EnVelope Down) will setup a envelope to drop the value of the
; specified Register by a specified step at a specified speed.
; The Speed is held in Delay and is a fractional Delay so 0 will be
; very slow, and 255 will be at the speed of the interrupt (50Hz)
;
; For example, to setup a Volume Drop on Channel C at steps of 1 and
; at half the speed of the Interrupt we would use $3A,$01,$80
;
; ** STE Action  4 ($40+Register)
; STE (STop Envelope) will Stop an Envelope by specifying the Register
; it is attached to. If the register cannot be linked to the Envelope
; then it is assumed that all Envelopes (on channel) should be stopped.
;
; For Example, to stop all envelopes on channel, we would use $4F or
; $4E and to stop an envelope currently attenuating on Noise, we would
; use $46
;
; ** LEV Action  5 ($50+Row from Start)
; LEV (Loop EVent) will jump to the row number specified and continue to
; execute from that point until the next Period.
;
; For example, to loop a list of events 20 Bytes long, we would use
; $50,$14
;
; ** PER Action  6 ($60+Period), Period
; PER (PERiod) will set the Period for the next wait state, and trigger
; the wait state to take place.
; If Longer periods than 15 interrupt cycles are required, use LPR
; instead.
; Based on an interrupt of 50Hz, A Period of Zero will wait 5.12 Seconds
; before moving onto the next event step.
; A Period of 1 will wait 0.02 Seconds, and a period of 2 will wait 0.04
; seconds.
;
; For example to wait 0.2 second, we would use $6A
; The following Table details all periods
; Secs Value
; 0.02 1
; 0.04 2
; 0.06 3
; 0.08 4
; 0.10 5
; 0.12 6
; 0.14 7
; 0.16 8
; 0.18 9
; 0.2  10
; 0.22 11
; 0.24 12
; 0.26 13
; 0.28 14
; 0.3  15
; 0.32 0
;
; ** SRV Action  7 ($70+Register), Value
; SRV (Set Register Value) is similar to SWM but does not have a mask
; byte. This reduces the number of bytes to write to registers that
; are not shared by other channels or that a direct write is all that
; is needed.
;
; For example, to set the Pitch of channel A with 2558 ($9FE in hex)
; we would use $70,$FE,$71,$09
;
; ** ZRG Action  8 ($80+Register)
; ZRG (Zero ReGister) will store 0 to the specified Register.
;
; For Example, if we wanted to silence Channel A, we would use $88 or
; if we wanted to set the high Period in the EG to 0, we would use $8B
;
; ** CEU Action  9 ($90+Register), Step, Delay, Threshold
; CEU (Conditional Envelope Up) is similar to EVU except that it will
; terminate the envelope when the threshold is reached. No Overflow
; will occur
;
; For example, to setup a Volume rise on Channel C at steps of 1 to
; the maximum volume of 15 and at half the speed of the Interrupt we
; would use $9A,$01,$80,$0F
;
; ** CED Action  10($A0+Register), Step, Delay
; CED (Conditional Envelope Down) is similar to EVD except that it will
; terminate the envelope when zero is reached. No Overflow will occur.
;
; For example, to setup a Volume fall on Channel C at steps of 1 to zero
; and at half the speed of the interrupt we would use $AA,$01,$80
;
; ** LPR Action  11($B0), Period
; LPR (Long PeRiod) will set the Period for the next wait state, and
; trigger the wait state to take place.
; If periods shorter than 16 interrupt cycles are required, use PER
; instead.
; Based on an interrupt of 50Hz, A Period of Zero will wait 5.12 Seconds
; before moving onto the next event step.
; A Period of 1 will wait 0.02 Seconds, and a period of 2 will wait 0.04
; seconds.
;
; For example to wait 1 second, we would use $40,$32
;
; ** EOE Action  12($C0+Effect)
; EOE (Execute Other Effect) will execute the effect specified then
; return to continue on the next action, just like JSR or GOSUB.
; This is a very powerful command, since it allows effects to be
; combined into much larger effects without the size penalty.
; Like nested Gosubs or JSRs, EOE's can also be nested, whilst they
; can be nested up to 4 levels.
; Note that the effect that is called may only be effect 0-15
;
; ** RRB Action  13($D0+Register),Bits
; RRB (Randomise Register Bits) generates a random number, which is
; then logically ANDed with Bits and those bits affected are written to
; the register specified. This action repeats until an STE, Envelope or
; another rrb Action is used on the same register.
; An RRB Actioned on a different register will also terminate this
; Action.
;
; The first 256 bytes of the memory area used for the SFX Player are
; sequentially read, added to an 8 bit counter and subtracted from the
; two zero page locations used by SFX player. The 8 bit result
; is the 8 bit random element.
;
; Their is one pseudo random source that must be shared across all 3
; areas.
;
; For example, to
; ** E16 Action  14($E0+Register),Step,Delay
; E16 (Envelope 16 bit) allows a register pair to be linked to a single
; Envelope event. The Register used forms the low order byte, whilst
; the next register up is for the high order byte.
; Steps from 0 to 80 will provide a 16 bit envelope up.
; Steps from FF to 81 will provide a 16 bit envelope down.
; The Envelope will occur at the specified fractional delay rate.
;
; Code 15 is not used.


Setup_IRQ	sei
	lda #<effect_irq
	sta $024b
	lda #>effect_irq
	sta $024c
	lda #$4c
	sta $024a
	cli
	rts



;***** Effect IRQ (Editor only) *****
effect_irq
	pha
	txa
	pha
	tya
	pha
	;Adjust speed from 100Hz to 33Hz
	lda tol_speed_reduction
	clc
	adc #85
	sta tol_speed_reduction
.(
	bcc skip1
	jsr sfx_proc_sfx
	jsr ay_monitor
skip1	pla
.)
	tay
	pla
	tax
	pla
	rti



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
	lda #0
	sta sfx_event_index,y
	sta sfx_event_period_hi,y
	lda #1
	sta sfx_event_period_lo,y
	;and reset previous arrow loc
	lda #00
	sta sfx_event_row,y
	lda previous_arrow_lo,y
.(
	sta vector1+1
	lda previous_arrow_hi,y
	sta vector1+2
	lda #35
vector1	sta $dead
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

sfx_proc_sfx
	; Scan for new effects
	jsr sfx_scan_effect
	;Process existing Events
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
	;Process existing Envelopes
	jsr sfx_proc_envelopes
	jsr generate_random_byte
	jsr sfx_proc_rrb
	jsr sfx_ay_send
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

replace_arrow
.(
	;Plot sfx marker on screen (if same sfx)
	;sfx_trigger indexed by x (and127) contains this effect
	lda sfx_trigger,x
	and #127
	cmp effect_number	;we are currently editing
	bne skip2
	;need to delete previous location of arrow
	lda previous_arrow_lo,x
	sta vector3+1
	lda previous_arrow_hi,x
	sta vector3+2
	lda #35
vector3	sta $dead
	;plot arrow
	ldy sfx_event_row,x
	inc sfx_event_row,x
	lda event_display_loc_lo,y
	sta vector2+1
	sta previous_arrow_lo,x
	lda event_display_loc_hi,y
	sta vector2+2
	sta previous_arrow_hi,x
	lda #38
vector2	sta $dead
	;
skip2	rts
.)


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

loop2	jsr replace_arrow
	ldy sfx_event_index,x
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



sfx_eav_eoe
	;GOSUB Effect
	;The Effect address tables hold the absolute address
	;of the effect
	ldy sfx_virtual_stack_pointer,x	;0-3
	cpy #03
.(
	bcs skip2	;Maximum nests reached
	;Merge Channel with stack pointer to get 0-11 pointer
	jsr sfx_merge_ChannelNstack
	;PUSH Current Effect Number to Stack
	lda sfx_effect_number,x
	sta sfx_virtual_stack_sfxnumber,y
	;PUSH Index of current Event to Stack
	lda sfx_event_index,x
	sta sfx_virtual_stack_addrindex,y
	;Increment nest
	inc sfx_virtual_stack_pointer,x
	;Now fetch new effect address
	ldy sfx_event_register
	lda sfx_effect_event_address_table_lo,y
	sta sfx_zero_00
	lda sfx_effect_event_address_table_hi,y
	sta sfx_zero_01
	;Reset Effect index
	lda #00
	sta sfx_event_index,x
	;Fetch Effect Number
	lda sfx_event_register
	sta sfx_effect_number,x
	;Force subsequent line in new effect
skip2	clc
.)
	rts

sfx_merge_ChannelNstack
	txa
	asl
	asl
	ora sfx_virtual_stack_pointer,x
	tay
	rts

sfx_eav_end	;May also constitute RTS(Return) is nested (Called via EOE)
	ldy sfx_virtual_stack_pointer,x
.(
	beq skip1
	;Pull nest
	dec sfx_virtual_stack_pointer,x
	jsr sfx_merge_ChannelNstack
	lda sfx_virtual_stack_addrindex,y
	sta sfx_event_index,x
	lda sfx_virtual_stack_sfxnumber,y
	sta sfx_effect_number,x
	;Re-Fetch Event Address into zero page
	tay
	lda sfx_effect_event_address_table_lo,y
	sta sfx_zero_00
	lda sfx_effect_event_address_table_hi,y
	sta sfx_zero_01
	;Force continue
	clc
	rts
skip1	;Turn off Effect - But envelopes may continue
	lda #128
	sta sfx_effect_number,x
.)
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
sfx_eav_lev	;Loop Event
	;Register holds row number to loop back to,
	;so we need to scan from start to row number
	;If row number proves invalid, then we'll
	;default to the start
.(
	stx sfx_temp_01
	ldy #00
	lda sfx_event_register
	sta sfx_event_row,x
	beq skip1
loop1	lda (sfx_zero_00),y
	lsr
	lsr
	lsr
	lsr
	beq skip1
	tax
	tya
	clc
	adc number_entry_bytes,x
	tay
	dec sfx_event_register
	bne loop1
	;y holds event index
	tya
skip1	ldx sfx_temp_01
	sta sfx_event_index,x
	;Also reset arrow position
	jsr replace_arrow
	clc
	rts
.)





sfx_eav_spr
	clc
	rts

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

generate_random_byte
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

;This requires an extra 24 bytes for tables but save on 2 bytes per sfx.
;sfx_eav_ssr ; Set status register bits
;	ldy sfx_event_register
;	lda sfx_ay_registers+7
;	and channel_mask,y
;	ora channel_bits,y
;	sta sfx_ay_registers+7
;	clc
;	rts


sfx_ay_send
	;Ensure stt is set correctly
	lda sfx_ay_registers+7
	and #%00111111
	ora #%01000000
	sta sfx_ay_registers+7
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
tol_speed_reduction		.byt 0
;For editor, each effect event will be 64 bytes long
;and 64 Effects (4096 Bytes)
;This may then be crunched when implemented into TOL
sfx_effect_event_address_table_lo	;Num of Effects
 .byt <$7000
 .byt <$7000+64*1
 .byt <$7000+64*2
 .byt <$7000+64*3
 .byt <$7000+64*4
 .byt <$7000+64*5
 .byt <$7000+64*6
 .byt <$7000+64*7
 .byt <$7000+64*8
 .byt <$7000+64*9
 .byt <$7000+64*10
 .byt <$7000+64*11
 .byt <$7000+64*12
 .byt <$7000+64*13
 .byt <$7000+64*14
 .byt <$7000+64*15
 .byt <$7000+64*16
 .byt <$7000+64*17
 .byt <$7000+64*18
 .byt <$7000+64*19
 .byt <$7000+64*20
 .byt <$7000+64*21
 .byt <$7000+64*22
 .byt <$7000+64*23
 .byt <$7000+64*24
 .byt <$7000+64*25
 .byt <$7000+64*26
 .byt <$7000+64*27
 .byt <$7000+64*28
 .byt <$7000+64*29
 .byt <$7000+64*30
 .byt <$7000+64*31
 .byt <$7000+64*32
 .byt <$7000+64*33
 .byt <$7000+64*34
 .byt <$7000+64*35
 .byt <$7000+64*36
 .byt <$7000+64*37
 .byt <$7000+64*38
 .byt <$7000+64*39
 .byt <$7000+64*40
 .byt <$7000+64*41
 .byt <$7000+64*42
 .byt <$7000+64*43
 .byt <$7000+64*44
 .byt <$7000+64*45
 .byt <$7000+64*46
 .byt <$7000+64*47
 .byt <$7000+64*48
 .byt <$7000+64*49
 .byt <$7000+64*50
 .byt <$7000+64*51
 .byt <$7000+64*52
 .byt <$7000+64*53
 .byt <$7000+64*54
 .byt <$7000+64*55
 .byt <$7000+64*56
 .byt <$7000+64*57
 .byt <$7000+64*58
 .byt <$7000+64*59
 .byt <$7000+64*60
 .byt <$7000+64*61
 .byt <$7000+64*62
 .byt <$7000+64*63
sfx_effect_event_address_table_hi	;Num of Effects
 .byt >$7000
 .byt >$7000+64*1
 .byt >$7000+64*2
 .byt >$7000+64*3
 .byt >$7000+64*4
 .byt >$7000+64*5
 .byt >$7000+64*6
 .byt >$7000+64*7
 .byt >$7000+64*8
 .byt >$7000+64*9
 .byt >$7000+64*10
 .byt >$7000+64*11
 .byt >$7000+64*12
 .byt >$7000+64*13
 .byt >$7000+64*14
 .byt >$7000+64*15
 .byt >$7000+64*16
 .byt >$7000+64*17
 .byt >$7000+64*18
 .byt >$7000+64*19
 .byt >$7000+64*20
 .byt >$7000+64*21
 .byt >$7000+64*22
 .byt >$7000+64*23
 .byt >$7000+64*24
 .byt >$7000+64*25
 .byt >$7000+64*26
 .byt >$7000+64*27
 .byt >$7000+64*28
 .byt >$7000+64*29
 .byt >$7000+64*30
 .byt >$7000+64*31
 .byt >$7000+64*32
 .byt >$7000+64*33
 .byt >$7000+64*34
 .byt >$7000+64*35
 .byt >$7000+64*36
 .byt >$7000+64*37
 .byt >$7000+64*38
 .byt >$7000+64*39
 .byt >$7000+64*40
 .byt >$7000+64*41
 .byt >$7000+64*42
 .byt >$7000+64*43
 .byt >$7000+64*44
 .byt >$7000+64*45
 .byt >$7000+64*46
 .byt >$7000+64*47
 .byt >$7000+64*48
 .byt >$7000+64*49
 .byt >$7000+64*50
 .byt >$7000+64*51
 .byt >$7000+64*52
 .byt >$7000+64*53
 .byt >$7000+64*54
 .byt >$7000+64*55
 .byt >$7000+64*56
 .byt >$7000+64*57
 .byt >$7000+64*58
 .byt >$7000+64*59
 .byt >$7000+64*60
 .byt >$7000+64*61
 .byt >$7000+64*62
 .byt >$7000+64*63
;8000 - 81FF - Names (Text 8 chars*64 effects)

number_entry_bytes	;Actually data bytes + 1
 .byt 1
 .byt 3
 .byt 3
 .byt 3
 .byt 1
 .byt 1
 .byt 1
 .byt 2
 .byt 1
 .byt 4
 .byt 3
 .byt 2
 .byt 1
 .byt 2
 .byt 3
 .byt 3

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
 .byt <sfx_eav_ste,<sfx_eav_lev,<sfx_eav_per,<sfx_eav_set
 .byt <sfx_eav_zrg,<sfx_eav_ceu,<sfx_eav_ced,<sfx_eav_lpr
 .byt <sfx_eav_eoe,<sfx_eav_rrb,<sfx_eav_16u,<sfx_eav_16d
sfx_event_action_vector_hi	;16
 .byt >sfx_eav_end,>sfx_eav_swm,>sfx_eav_evu,>sfx_eav_evd
 .byt >sfx_eav_ste,>sfx_eav_lev,>sfx_eav_per,>sfx_eav_set
 .byt >sfx_eav_zrg,>sfx_eav_ceu,>sfx_eav_ced,>sfx_eav_lpr
 .byt >sfx_eav_eoe,>sfx_eav_rrb,>sfx_eav_16u,>sfx_eav_16d

sfx_virtual_stack_pointer
 .dsb 3,0
sfx_virtual_stack_sfxnumber
 .dsb 12,0
sfx_virtual_stack_addrindex
 .dsb 12,0
sfx_event_row
 .dsb 3,0
previous_arrow_lo
 .dsb 3,0
previous_arrow_hi
 .dsb 3,0

sfx_ay_registers		;14
 .byt 0,0
 .byt 0,0
 .byt 0,0
 .byt 0
 .byt 0
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
