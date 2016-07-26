// SFX Player and init routines
// Remember Hum of Underwurlde Barred Doors

sfx_driver
.(
	ldx #02
loop1	ldy sfx_hero_trigger,x
	bmi skip1
	jsr new_sfx
skip1	dex
	bpl loop1
.)
	jsr proc_sfx
	jsr send_ay
	rts

// Standard AY Send Routine with ref table to both avoid writing to reg 13
// when not appropriate and to speed up by avoiding registers whose values
// have not changed.
send_ay
	ldy #$dd
	ldx #13
loop1	stx via_porta
	lda #$ff
	sta via_pcr
	sty via_pcr
	lda ay_table,x
	cmp ay_refer,x
	beq skip1
	sta ay_refer,x
	sta via_porta
	lda #$fd
	sta via_pcr
	sty via_pcr
skip1	dex
	bpl loop1
	rts


new_sfx
	// Fetch sfx address
	lda sfx_address_lo,y
	sta sfx_runtime_addresslo,x
	lda sfx_address_hi,y
	sta sfx_runtime_addresshi,x
	// disable previous effect
	lda #00
	sta sfx_index,x
	sta sfx_off,x
	sta sfx_time4channel,x
	sta sfx_bend_pitch_flag,x
	sta sfx_bend_noise_flag,x
	sta sfx_bend_volume_flag,x
	sta sfx_volume4channel,x
	sta sfx_bend_envper_flag,x
	sta sfx_envflag4channel,x
	sta sfx_cyc4channel,x
	sta sfx_in_conditionalloop_flag,x
	sta sfxproceed_flag
	rts

proc_sfx
	ldx #02	;Channels
loop1	lda sfx_off,x
	bne skip2
	lda time_frac,x
	clc
	adc sfx_time4channel,x
	sta time_frac,x
	bcs sfx_next_index
	lda sfx_bend_pitch_flag,x
	beq skip3
	jsr proc_pitchbend
skip3	lda sfx_bend_noise_flag,x
	beq skip4
	jsr proc_noisebend
skip4	lda sfx_bend_volume_flag,x
	beq skip5
	jsr proc_volumebend
skip5	lda sfx_bend_envper_flag,x
	beq skip2
	jsr proc_envperbend
skip2	dex
	bpl loop1
	rts

// Ensure all elements are executed
sfx_next_index
	jsr proc_next_entry
	lda sfxproceed_flag
	beq sfx_next_index
	lda #00
	sta sfxproceed_flag
	rts

proc_next_entry
	ldy sfx_index,x
	lda sfx_runtime_addresslo,x
	sta zero_00
	lda sfx_runtime_addresshi,x
	sta zero_00
	lda (zero_00),y
	pha
	lsr
	lsr
	lsr
	sta sfxdata_x0
	inc sfx_index,x
	pla
	and #07
	tay
	lda sfx_action_vector_lo,y
	sta vector1+1
	lda sfx_action_vector_hi,y
	sta vector1+2
	// Load extended bytes
	lda sfx_extended_byte_count,y
	beq skip1
	ldy sfx_index,x
	sta sfxtemp_01
	iny
	inc sfx_index,x
	lda (zero_00),y
	sta sfxdata_x1
	dec sfxtemp_01
	beq skip1
	iny
	inc sfx_index,x
	lda (zero_00),y
	sta sfxdata_x2
skip1	// Setup channel
	txa
	asl
	tay
	// Go their
vector1	jsr $dead
	?

SFXAction_SetPitch
	lda sfxdata_x0
	sta ay_table+1,y
	lda sfxdata_x1
	sta ay_table,y
	rts
SFXAction_SetNoise
	lda sfxdata_x0
	sta sfx_noise4channel,x
	sta ay_table+6
	rts
SFXAction_SetStatus
	lda sfxdata_x0
	// Extract Noise and Tone Bits
	and #03
	tay
	lda sfx_base_status_bits,y
	stx sfxtemp_01
	cpx #00
	beq skip2
loop1	asl
	dex
	bne loop1
skip2	ldx sfxtemp_01
	sta sfxtemp_01
	lda ay_table+7
	and sfx_status_bitmask,x
	ora sfxtemp_01
	sta ay_table+7
	// Extract Envelope Flag
	lda sfxdata_x0
	and #04
	asl
	asl
	sta sfx_envflag4channel,x
	// Extract CYC for Env Shape
	lda sfxdata_x0
	lsr
	lsr
	lsr
	beq skip1
	tay
	lda sfx_cycle_value-1,y
	sta sfx_cyc4channel,x
skip1	rts

SFXAction_SetVolume
	lda sfxdata_x0
	sta sfx_volume4channel,x
	sta ay_table+8,x
	rts

SFXAction_SetEnvPer
	lda sfxdata_x1
	sta sfx_envperlo4channel,x
	sta ay_table+11
	lda sfxdata_x2
	sta sfx_envperhi4channel,x
	sta ay_table+12
	rts

SFXAction_InitBend
	// Extract Bend Direction
	ldy sfxdata_x0
	and #04
	beq skip1
	ldy #80
skip1	// Extract Bend Mode
	lda sfxdata_x0
	and #03
	beq init_pitchbend
	cmp #02
	bcc init_volumebend
	beq init_noisebend
init_envperbend
	tya
	sta sfx_envperbend_dir,x
	// Store step
	lda sfxdata_x1
	sta sfx_envperbend_step,x
	// Store rate
	lda sfxdata_x2
	sta sfx_envperbend_rate,x
	// Reset Frac
	lda #00
	sta sfx_envperbend_frac,x
	inc sfx_bend_envper_flag,x
	rts
init_pitchbend
	tya
	sta sfx_pitchbend_dir,x
	lda sfxdata_x1
	sta sfx_pitchbend_step,x
	// Store rate
	lda sfxdata_x2
	sta sfx_pitchbend_rate,x
	// Reset Frac
	lda #00
	sta sfx_pitchbend_frac,x
	inc sfx_bend_pitch_flag,x
	rts
init_volumebend
	tya
	sta sfx_volumebend_dir,x
	lda sfxdata_x1
	sta sfx_volumebend_step,x
	// Store rate
	lda sfxdata_x2
	sta sfx_volumebend_rate,x
	// Reset Frac
	lda #00
	sta sfx_volumebend_frac,x
	inc sfx_bend_volume_flag,x
	rts
init_noisebend
	tya
	sta sfx_noisebend_dir,x
	lda sfxdata_x1
	sta sfx_noisebend_step,x
	// Store rate
	lda sfxdata_x2
	sta sfx_noisebend_rate,x
	// Reset Frac
	lda #00
	sta sfx_noisebend_frac,x
	inc sfx_bend_noise_flag,x
	rts

SFXAction_CondLoop
	lda sfx_in_conditionalloop_flag,x
	bne in_loop
	inc sfx_in_conditionalloop_flag,x
	lda sfxdata_x0
	sta sfx_loop_count,x
continue_repeat
	lda sfx_index,x
	sec
	sbc sfxdata_x1
	sta sfx_index,x
	rts
in_loop	dec sfx_loop_count,x
	bne continue_repeat
	rts

SFXAction_Change
;7 Action		1	silence(1X),Action(3X),period(8)
// B0
//  0 Silence		-
//  1 Normal
// B1-3			Data Byte/s
//  0 End                     (0)None
//  1 End All Bends           (0)None
//  2 End Pitch Bend          (0)None
//  3 End Noise Bend          (0)None
//  4 End Volume Bend         (0)None
//  5 End EnvPer Bend	(0)None
//  6 Extended Loop     	(2)Count,Steps Back
//  7 Proceed		(1)Period
	lda sfxdata_x0
// B0-2 End Type
	cmp #02
	bcs end_attribute
	lda sfxdata_x0
	and #01
	bne skip1
	lda #00
	sta ay_table+8,x
skip1	inc sfx_off,x
	rts
SFXAction_Proceed
	lda sfxdata_x0
	sta timehi4channel,x
	lda sfxdata_x1
	sta timelo4channel,x
	inc sfxproceed_flag
	rts
end_attribute
	bne skip2
end_pitchbend
	lda #00
	sta sfx_bend_pitch_flag,x
	rts
skip2	cmp #4
	bcs skip3
end_noisebend
	lda #00
	sta sfx_bend_noise_flag,x
	rts
skip3	bne end_envperbend
end_volumebend
	lda #00
	sta sfx_bend_volume_flag,x
	rts
end_envperbend
	lda #00
	sta sfx_bend_envper_flag,x
	rts




proc_pitchbend
.(
	txa
	asl
	tay
	lda sfx_pitchbend_frac,x
	clc
	adc sfx_pitchbend_rate,x
	sta sfx_pitchbend_frac,x
	bcc skip1
	lda sfx_pitchbend_dir,x
	beq skip2
	lda ay_table,y
	clc
	adc sfx_pitchbend_step,x
	sta ay_table,y
	lda ay_table+1,y
	adc #00
	and #15
	sta ay_table+1,y
skip1	rts
skip2	lda ay_table,y
	sec
	sbc sfx_pitchbend_step,x
	sta ay_table,y
	lda ay_table+1,y
	sbc #00
	and #15
	sta ay_table+1,y
.)
	rts

proc_noisebend
.(
	lda sfx_noisebend_frac,x
	clc
	adc sfx_noisebend_rate,x
	sta sfx_noisebend_frac,x
	bcc skip1
	lda sfx_noisebend_dir,x
	beq skip2
	lda sfx_noise4channel,x
	clc
	adc sfx_noisebend_step,x
	and #31
	sta sfx_noise4channel,x
	sta ay_table+6
skip1	rts
skip2	lda sfx_noise4channel,x
	sec
	sbc sfx_noisebend_step,x
	and #31
	sta sfx_noise4channel,x
	sta ay_table+6
.)
	rts

proc_volumebend
.(
	lda sfx_volumebend_frac,x
	clc
	adc sfx_volumebend_rate,x
	sta sfx_volumebend_frac,x
	bcc skip1
	lda sfx_volumebend_dir,x
	beq skip2
	lda ay_table+8,x
	clc
	adc sfx_volumebend_step,x
	and #15
	ora sfx_envflag4channel,x
	sta ay_table+8,x
skip1	rts
skip2	lda ay_table+8,x
	sec
	sbc sfx_volumebend_step,x
	and #15
	ora sfx_envflag4channel,x
	sta ay_table+8,x
.)
	rts

proc_envperbend
.(
	lda sfx_envperbend_frac,x
	clc
	adc sfx_envperbend_rate,x
	sta sfx_envperbend_frac,x
	bcc skip1
	lda sfx_envperbend_dir,x
	beq skip2
	lda sfx_envperlo4channel,x
	clc
	adc sfx_envperbend_step,x
	sta sfx_envperlo4channel,x
	sta ay_table+11
	lda sfx_envperhi4channel,x
	adc #00
	sta ay_table+12
	sta sfx_envperhi4channel,x
skip1	rts
skip2	lda sfx_envperlo4channel,x
	sec
	sbc sfx_envperbend_step,x
	sta sfx_envperlo4channel,x
	sta ay_table+11
	lda sfx_envperhi4channel,x
	sbc #00
	sta ay_table+12
	sta sfx_envperhi4channel,x
.)
	rts
