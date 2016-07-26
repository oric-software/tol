#define	posessionlist	$b457


inventory_chosen
	lda #226
	jmp message2window




;In...
;A == Item to look for
;Out...
;C == Set if Found
is_posessed
	ldx #20
.(
loop1	cmp posessionlist,x
	beq skip1
	dex
	bpl loop1
	clc
skip1	rts
.)


