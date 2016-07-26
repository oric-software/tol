// proc_life_control (For Hero)
// Manages life_force by ration consumption over time (Very sensitive area!)

;text215
; .byt "YOU'RE HUNGRY"
;text216
; .byt "TAKING RATIONS FROM YOUR PACK, YOU QUENCH YOUR HUNGER"

// life control is linked into tod only so that it can act at specific times during
// the day...
proc_life_control
	lda sunmoon_lighting	;0-31
	;break down to 4 times
	and #7
.(
	bne skip2
	;Now deal with rations
	lda hero_rations
	beq skip1	;You're hungry / dec candle
	;Display
	lda #216
	jsr message2window
	;Decrement rations
	dec hero_rations
skip2	rts
skip1	;Display
	lda #215
	jsr message2window
	;Decrement life_force by 2
	lda #128+2
	jmp adjust_hero_life
.)
