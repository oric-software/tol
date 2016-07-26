;Debug source

;test area

;PLOT 2 DIGIT HEX
plot_hex	ldx #00
	pha
	lsr
	lsr
	lsr
	lsr
	jsr plot_digit
	pla
plot_digit
	and #$0f
	cmp #$0a
	bcc pdt_01
	adc #06
pdt_01	clc
	adc #48
	sta $bfde,x
	inx
	rts
