;manage_candle

// The candle code must display the Candle flame and wick at 48 levels.
// 1) The candle colour (by default) is yellow
// 2) Will change to Red when the player is close to death.
// 2) Will change to Flashing when Hero is invincible

// Candle Flame - Yellow or Red	Definition is 4*11
//   Candle Lip - White		Definition is 4*5
//  Candle Wick - White		Definition is 4*4 (Reforms Candle)
#define	real_candle_frame	$b2d6
#define	flame_frame0	$b300
#define	flame_frame1	$b32c
#define	flame_frame2	$b358
#define	lip_frame0	$b384
#define	stem_frame0	$b398
#define	hires_ylocl	$b3a8
#define	hires_yloch	$b3d8


update_candle
	jsr update_candle_flame_colour
	lda #31
	sec
	sbc life_force	;0-31
	sta life_forcei
	cmp old_life_force
.(
	beq skip3		;Animation only
	bcc skip2		;Higher
	;Lower
	sbc old_life_force	;Get difference
	// Clear lines above flame
	tax
loop1	ldy old_life_force
	jsr clear_candle_line
	inc old_life_force
	dex
	bpl loop1
	jmp skip1
skip2	// Plot lines below lip
	lda old_life_force	;Calculate difference
	sec
	sbc life_forcei
	tax
	lda life_forcei	;locate top of stem
	clc
	adc #16	;height of Flame+Lip
	tay
	and #03	;Capture offset in stem graphic
loop2	jsr plot_candlestem_line
	iny
	dex
	bne loop2
skip1	// Plot Wick and Lip
	lda life_forcei
	clc
	adc #11	;height of Flame
	tay
	jsr plot_lip
skip3	// Plot Flame Animation
.)
	lda candle_frame	;3 frames spread to 4 as 0,1,2,1
	clc
	adc #01
	and #03
	sta candle_frame
	tay
	ldx real_candle_frame,y	;00,33,66,33
	ldy life_forcei
	jsr fetch_candle_yloc
	lda #11
	sta irq_zero02
.(
loop2	ldy #00
	lda flame_colour
	sta (irq_zero00),y
	iny
loop1	lda flame_frame0,x
	sta (irq_zero00),y
	inx
	iny
	cpy #04
	bcc loop1
	jsr nl_irq00
	dec irq_zero02
	bne loop2
.)
	rts

update_candle_flame_colour
	// Update candle flame colour
	// Either...
	//  1) Special Flame Effect when nourished with Potion - White
	//   if flame_colour = 7+128
	//     Set flame_colour to 7
	//   elseif flame_colour = 7
	//     Set Flame colour to 3
 	//  2) malnourished Flame when hero close to death - Red
	//   elseif if life_force < 8
	//     Set Flame colour to 1
	//  3) Normal Flame - Yellow
	//   else
	//     Set flame colour to 3
.(
	lda flame_colour
	cmp #128+7
	bne skip1
	lda #7
	sta flame_colour
	rts
skip1	cmp #7
	bne skip2
skip3	lda #3
	sta flame_colour
	rts
skip2	lda life_force
	cmp #8
	bcs skip3
.)
	lda #01
	sta flame_colour
	rts

;In...
;Y Ypos of candle line to clear
;Reserve X
clear_candle_line
	jsr fetch_candle_yloc
	ldy #03
	lda #00
.(
loop1	sta (irq_zero00),y
	dey
	bpl loop1
.)
	rts

;In...
;Y Ypos of Candle Stem line
;A Candle Stem Graphic y-offset
;Reserve X and Y and (A+1)AND3
plot_candlestem_line
	stx irq_zero03
	sty irq_zero04
	sta irq_zero02
	jsr fetch_candle_yloc
	lda irq_zero02
	asl
	asl
	tax
	ldy #00
.(
loop1	lda stem_frame0,x
	sta (irq_zero00),y
	inx
	iny
	cpy #04
	bcc loop1
.)
	lda irq_zero02
	clc
	adc #01
	and #03
	ldx irq_zero03
	ldy irq_zero04
	rts

fetch_candle_yloc
	lda hires_ylocl,y
	clc
	adc #12
	sta irq_zero00
	lda hires_yloch,y
	adc #00
	sta irq_zero01
	rts

plot_lip	jsr fetch_candle_yloc
	ldx #00
.(
loop2	ldy #00
loop1	lda lip_frame0,x
	sta (irq_zero00),y
	inx
	iny
	cpy #04
	bcc loop1
	jsr nl_irq00
	cpx #16
	bcc loop2
.)
	rts

nl_irq00
	lda irq_zero00
	clc
	adc #40
	sta irq_zero00
.(
	bcc skip1
	inc irq_zero01
skip1	rts
.)
