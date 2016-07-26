;Create Exclusion mask over Page 2 Temp Code

;The original idea was to keep the page2 code in the screenbuffer area of the original
;game, but this would have only been possible to do right at the end of the development
;cycle because page 2 jsr's many routines in lower-memory that may change as the game
;development progresses.
;So instead, we keep page 2 code where it is, copy it to page 2 on init, then create the
;256 byte exclusion mask over the old copy.
;
;The Exclusion mask looks like this
;exclusion_mask
; .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
; .byt 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
; .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
; .byt 56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56
; .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
; .byt 63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63
;
; So we just need a little code to create this...
exclusion_code
 .byt 0,7,56,63

create_exclusion_mask
	ldx #00
.(
loop1	txa
	;Shift X so that B6-B7 become B0-B1
	asl
	rol
	rol
	;Then exclude B2-7
	and #03
	;And use as index to get actual code
	tay
	lda exclusion_code,y
	;Store that code over old page 2
	sta exclusion_mask,x
	;Repeat for all 256 bytes
	inx
	bne loop1
.)
	rts
