examine_chosen
	;outside
	lda #219	;Select Item to examine
	jsr message2window
	jsr posesseditems2optionbuffer
	jsr select_option
.(
	bcc skip2	;Abort selection
	lda optionbuffer,x
	sta selectedmatter
	// Now display description of item
	jsr message2window
	lda selectedmatter
	cmp #190
	beq intonement_code
skip2	rts
.)

;The intonements depend on the hero's current posessions.
intonement_code
	ldx #122
.(
loop2	jsr fetch_textloc00y0
loop1	lda (zero_00),y
	cmp #123
	bcc skip2	;All posessed!
	sty temp_01
	stx temp_02
	jsr is_posessed
	ldy temp_01
	ldx temp_02
	bcc skip1	;Not posessed!
	iny
	jmp loop1
skip1	dex	;Works in reverse so that we always look at max objects posessed
	cpx #118
	bcs loop2
	rts
skip2	;Now we can display the message
.)
	tya
	jsr add_zero00
	jmp messageaddress2window
