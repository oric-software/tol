// Weapon Special Effects (Graphical only)
// Screen wide Special Effects
// 1) White-Out
// 2) Red-out
// 3) XScroll (8 times)
// 4) ?

// Weapons	Graphical Effect
// DAGGER		Projectile
// RED POTION       Red-Out
// BLUE FLASK	?
// WHITE CAKE       White-Out
// BOW&ARROW	Projectile
// AXE		Projectile
// RED SCROLL	Red-Out
// BLU SCROLL       XScroll
// WHT SCROLL       Red-Out


;Simple effect, wraparound X scroll 8 times of BG character set (32-95)
xscroll
	;Only affect background graphics
	ldy #8
	ldx #00
.(
	;wrap left first half
loop1	lda $b500,x
	asl
	bcc skip1
	ora #1
skip1	sta $b500,x
	;wrap right second half
	lda $b600,x
	lsr
	bcc skip2
	ora #128
skip1	sta $b600,x
	;
	dex
	bne loop1
	;Pause and wrap 8 times to bring set back to original
	jsr mini_delay
	dey
	bne loop1
.)
	rts

white_out
	lda #23
out_code	jsr paper
	jmp mini_delay

red_out	lda #17
	jmp out_code


mini_delay
	lda #00
.(
loop1	nop
	clc
	adc #01
	bne loop1
.)
	rts

;rotate colours 8 times, so returning to original colours (Lothlin)
