;lighting control
;Contains the following routines...
; handle_tod      - Called via main game loop (So paused whenever icon menu used)
; sunNmoon_scroll - Called via main game loop (So paused whenever icon menu used)
;Note - the actual timing is handled in the irq routines
#define	colour_transformation_index	$b26e
#define	colour_transformation	$b276
#define	sunmoon_graphic		$bb20
#define	sunmoon_ylocl		$b363
#define	sunmoon_yloch		$b373
#define	hurt_creature_count		$b383

disable_toxic_mist
	;Set hurt_creature_count to 128
	lda #128
	sta hurt_creature_count
	;Re-establish correct lighting
	lda sunmoon_lighting
	jmp control_lighting

// This replaces the Messages (Dbugs idea)
sunNmoon_scroll
	lda sunmoon_delay
	clc
	adc #01
	and #7	;Could save two bytes if using fractional step instead
	sta sunmoon_delay
.(
	bne skip1
	; We'll also use this interval to hurt creature for hurt_creature EFX
	lda hurt_creature_count
	; 0     - Finished
	; 1-127 - Active count
	; +128  - Inactive
	bmi skip2
	beq disable_toxic_mist
	dec hurt_creature_count
	and #08
	beq skip5	;Delay the actual hurting
	ldx #02
loop2	lda creature_activity,x
	bpl skip4
	jsr hurt_creature
skip4	dex
	bpl loop2
	;stop lighting if toxic mist
	jmp skip5
skip2	;Control gamearena lighting
	lda sunmoon_lighting
	jsr control_lighting
skip5	;Work out screen loc
	jsr update_sunandmoon
	bcc skip1
	;Control hero's health (through hunger and rations)
	jsr proc_life_control
	;prevent creatures repetitive paths
	sta creature_repeatrotate_bitmap
	sta creature_repeatrotate_bitmap+1
	sta creature_repeatrotate_bitmap+2
skip1	rts
.)



update_sunandmoon
	ldy sunmoon_screeny	;0-15
	lda sunmoon_ylocl,y
	sta zero_00
	lda sunmoon_yloch,y
	sta zero_01
	;Fetch scan line
	ldx sunmoon_source_scan	;0,3,6,...
	ldy #00
.(
loop1	lda sunmoon_graphic,x
	sta (zero_00),y
	iny
	inx
	cpy #03
	bcc loop1
	;Advance source line
	lda sunmoon_source_scan
	jsr add_special
	;Advance scan line to next line
	lda sunmoon_screeny
	clc
	adc #01
	and #15
	sta sunmoon_screeny
	bne skip6	;Still scanning
	;Increment sunmoon_source_scan
	lda sunmoon_source_origin
	jsr add_special
	sta sunmoon_source_origin
	;Increment lighting
	lda sunmoon_lighting
	clc
	adc #01
	and #31
	sta sunmoon_lighting
	sec
skip6	rts
.)

;Since this is for the source image, we can assume...
; 0 - Night
; 15
add_special
	clc
	adc #03
	cmp #96
.(
	bcc skip3
	lda #00
skip3	sta sunmoon_source_scan
.)
	rts


control_lighting
	;0 == Day
	;1 == Day
	;2 == Day
	;3 == Day
	;4 == Dusk
	;5 == Night
	;6 == Night
	;7 == Dawn
	;lda sunmoon_source_origin
	;Convert 0-31 >> 0-7
	lsr
	lsr
	tax
	// Update actual_character_code
	ldy colour_transformation_index,x
control_lighting_withy
	ldx #07
.(
loop1	lda colour_transformation,y
	sta actual_character_code,x
	dey
	dex
	bpl loop1
.)
	rts

toxic_mist_colourscheme
	ldy #31
	jmp control_lighting_withy

