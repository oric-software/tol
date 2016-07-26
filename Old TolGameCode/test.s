;test
;Various test routines
*=$500


Flow_demo
;	;clear chars
;	ldx #00
;	txa
;fd_01	sta b700,x
;	dex
;	bne fd_01
;	;plot chars diagonally
	ldx #39
	stx x_ref
	ldy #00
	sty y_ref
	lda #96

fd_02	jsr plot_char
	inx
	iny
	cpy #28
	bcs fd_04
	cpx #40
	bcc fd_02
fd_04	ldx x_ref
	beq fd_03
	dec x_ref
	ldx x_ref
	ldy y_ref
fd_05	clc
	adc #01
	bpl ic_01
	lda #96
ic_01	jmp fd_02
fd_03	inc y_ref
	ldy y_ref
	cpy #28
	bcc fd_05
	rts

	;start loop
	;loop sine
	;fetch sine+index and use to fetch flow chardef frame
	;store
	;delay
	;loop

plot_char
	pha
	txa
	clc
	adc text_ylocl,y
	sta pc_01+1
	lda text_yloch,y
	adc #00
	sta pc_01+2
	pla
pc_01	sta $bf00
	rts



text_ylocl
 .byt $80,$A8,$D0,$F8,$20,$48,$70,$98
 .byt $C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18
 .byt $40,$68,$90,$B8
text_yloch
 .byt $BB,$BB,$BB,$BB,$BC,$BC,$BC,$BC
 .byt $BC,$BC,$BD,$BD,$BD,$BD,$BD,$BD
 .byt $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BF
 .byt $BF,$BF,$BF,$BF
x_ref	.byt 0
y_ref	.byt 0


;;Test1, try processing one key every irq, to allow a more balanced cpu-load and also use ay_send
;
;;left
;;right
;;up
;;down
;
;;fire
;;menu
;;smart1
;;smart2
;*=$500
;#include "main.h"
;
;test_driver
;	sei
;	lda #<test_irq
;	sta $0245
;	lda #>test_irq
;	sta $0246
;	cli
;test_03	ldx #07	;display key presses as binary byte
;test_02	lda key_press_register
;	ldy #"0"
;	and key_bit,x
;	beq test_01
;	ldy #"1"
;test_01	tya
;	sta $bb80,x
;	dex
;	bpl test_02
;	jmp test_03
;
;
;
;
;
;test_irq	sta tst1_01+1
;	stx tst1_02+1
;	sty tst1_03+1
;	lda via_t1cl
;	ldx key_index
;	lda key_assignments,x
;	lsr
;	lsr
;	lsr
;	lsr
;	tay
;	lda key_column,y
;	sta ay_column
;	lda key_assignments,x
;	and #15
;	sta via_portb
;	inx
;	txa
;	and #07
;	sta key_index
;	jsr send_ay
;	lda via_portb
;	ldx key_index
;	and #08
;	beq key_up_event
;key_down_event
;	lda key_bit,x
;	ora key_press_register
;	sta key_press_register
;tst1_01	lda #00
;tst1_02	ldx #00
;tst1_03	ldy #00
;	rti
;key_up_event
;	lda key_bit,x
;	eor #255
;	and key_press_register
;	sta key_press_register
;	jmp tst1_01
;
;
;send_ay	ldx #14
;say_02	lda ay_table,x
;	cmp ay_refer,x
;	beq say_01
;	sta ay_refer,x
;	ldy ay_register,x
;	sty via_porta
;	ldy #$ff
;	sty via_pcr
;	ldy #$dd
;	sty via_pcr
;	sta via_porta
;	lda #$FD
;	sta via_pcr
;	sty via_pcr
;say_01	dex
;	bpl say_02
;	rts
;
;ay_table
; .byt 0,0,0	;ay pitch lo
; .byt 0,0,0	;ay pitch hi
; .byt 0		;ay noise
; .byt %01000000	;ay status
; .byt 0,0,0	;ay Volume
; .byt 0,0		;ay period
; .byt 0		;ay cycle
;ay_column
; .byt 0		;ay key column
;ay_refer
; .byt 0,0,0
; .byt 0,0,0
; .byt 0
; .byt %01000000
; .byt 0,0,0
; .byt 0,0
; .byt 0
; .byt 0
;ay_register
; .byt 0,3,1,4,2,5
; .byt 6
; .byt 7
; .byt 8,9,10
; .byt 11,12
; .byt 13
; .byt 14
;key_column
; .byt %11111110
; .byt %11111101
; .byt %11111011
; .byt %11110111
; .byt %11101111
; .byt %11011111
; .byt %10111111
; .byt %01111111
;key_assignments
; .byt $54,$74,$64,$34,$42,$04,$35,$66
;key_bit
; .byt 1,2,4,8,16,32,64,128
;
;key_index		.byt 0
;key_press_register	.byt 0


