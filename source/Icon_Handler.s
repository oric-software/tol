;Icon Handler

;Their are 4 options, each 5 bytes apart.
; The cursor is composed of two single line patterns 5 bytes long plus an irq driven highlighter
; that shimmers the patterns
#define	cursor_pattern	$b2da
#define	icon_xoffset	$b2de
#define	icon_key		$b2e2

select_icon
	lda #18
;	sta sfx_trigger+2
.(
loop2	jsr draw_icon_cursor
	jsr waiton_window_key
	ldx #03
loop1	cmp icon_key,x
	beq skip1
	dex
	bpl loop1
	jmp loop2
skip1	lda icon_vector_lo,x
	sta vector1+1
	lda icon_vector_hi,x
	sta vector1+2
	jsr wipe_icon_cursor
vector1	jsr $Dead
	jmp loop2
.)


icon_left
	lda icon_option
	sec
	sbc #01
	and #03
	sta icon_option
	rts

icon_right
	lda icon_option
	clc
	adc #01
	and #03
	sta icon_option
	rts

icon_exit
	pla
	pla
flush_key	lda key_register
	bne flush_key
	rts

icon_select
	lda #19
;	sta sfx_trigger+2
	ldx icon_option
	lda icon_function_vectorlo,x
.(
	sta vector1+1
	lda icon_function_vectorhi,x
	sta vector1+2
vector1	jmp $DEAD
.)

draw_icon_cursor
	ldx icon_option
	ldy icon_xoffset,x
	ldx #00
.(
loop1	lda cursor_pattern,x
	sta $a000,y
	sta $a2d0,y
	inx
	iny
	cpx #04
	bcc loop1
.)
	rts

wipe_icon_cursor
	ldx icon_option
	ldy icon_xoffset,x
	ldx #04
.(
loop1	lda #$40
	sta $a000,y
	sta $a2d0,y
	iny
	dex
	bpl loop1
.)
	rts


