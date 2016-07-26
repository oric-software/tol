;Regional SFX
; Manage the slow reproduction of regional sound effects
;  0) Silence	-
;  1) Forest        Bird Song
;  2) Sea		SeaWaves
;  3) Underworld	Droplets
;  4) Water	Babbling


;  1) Sea    - Play the waves effect every (10+(random*16))Seconds
;  2) Forest - Play random Birdsongs 0-3 every (10+(Random*16))Seconds with random volumes
;  3) Babble -
;Contains...
; proc_regional_sfx

;Routine executed at 8Hz (Or every 8th of a second (1/8 Second))
;Single 8bit frac allows up to 32 seconds delay

proc_regional_sfx
	lda #00	;regional_sfx_frac
	sec
rsfxd_v	adc #7	;regional_sfx_delay
	sta proc_regional_sfx+1
.(
	bcc skip1
	jsr fetch_hero_region	;Into A
	;Extract Volume and Effect for region
	;Volume = B5-7
	;Regional SFX = B3-4
	lsr
	lsr
	lsr
	tay
	and #03
	beq skip1
regional sfx should only play after last one has finished
	tax	;X holds Regional SFX
	lda regional_sfx-1,x
	sta sfx_trigger
	tya
	lsr
	lsr
	;A hold Volume (0-7)
	eor #15
	;Store inverse for easy calc of volume
	sta regional_sfx_volume

	; Reset frac to random delay
	lda random_byte
	; Add default delay (8Hz >> 0.25 or less Seconds)
	and #7
	;
	sta rsfxd_v+1
skip1	rts
.)

regional_sfx
 .byt 7,1,6
regional_sfx_volume
 .byt 7

//          0 Silence                            Sil
//          1 Forest  (Bird Song)                For
//          2 River (Babbling Brook)             Riv
//          3 Sea (Waves)                        Sea

; Waves on Shore	100%        35      6	Nature
; Bird Song	100%        38      7	Creature
; Owl Hoot	90%                 11	Nature
; Babbling Brook    100%        14	1	Nature
; Chains		10%                           Nature
; Water Drops	100%        14	15	Nature
