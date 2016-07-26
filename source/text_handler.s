;TOL Text handler
;Routines...

;1) Display sentences with embedded ?
;2) On-Page Scroll
;3) Display Characters (6*6)
;4) Identifies objects and their setting
;5) Develops the game plot

;Plot1
; Seek Asp in Eralan
; Go north into dark forest and collect runes
; return to Asp (he'll send you to Ganestor to see the regent)
; go south-east to Ganestor

;Items
;0) Key (Silver, Gold, Wooden, Glass or Stone)
;1) Scroll (Magical Weapon)
;2) Gold Coin (Money for buying and lodging)
;3) Dagger (When thrown, may be picked up again)
;4) Rum Potion (Full energy)
;5) Clay Potion (double energy)
;6) Juniper Potion
;7) Lepa Potion (Halve Energy!)
;8) Rune (Artifact to progress game)
;9) Magical Boots (Speed up)
;10) Old Scroll (Invisibility)
;11) Zap Stone (Teleport)
;12) Magical Hat (For Performing Magic against enemies)
;13) Magical Bow&Arrow (Infinite Arrows)
;14) Wine Vessel (Make Serfs and Guards Freinds again)
;15) Silver Cross (keep ghosts away)

;TextBuffer is 256 bytes long (Over 13 Lines) and resides at #b800
;The TextBuffer is cyclic meaning that their exist pointers to frame
;the window, and these pointers move through the Buffer synchronously.
;Start of Window Buffer Position == SOWBPos
;Window Cursor X == Window_x
;Window Cursor Y == Window y
;Window Cursor Buffer Position == WCBPos

;Everytime the window is completely filled, a next-page icon is
;displayed. This is displayed until (1) the player presses the special
;key or (2) the WCBPos reaches SOWBPos.
;At this point, the complete window is cleared (including icon) and
;the whole process starts again.
;Note This was decided because the scrolling of the window (Whichever
;     way it was done) would consume too much time.

;At every event, a specific message will be formed into the textbuffer
;starting at the cursor position. This process solely deals with the
;text buffer.
;A different process deals with displaying the text in the window.
;Therefore a second cursor position is used for the position in the
;window.

// 0-31 Keyword
form_new_message

clear_pagedownicon
	lda #
	ldx #19
	ldy #07
	jmp display_character

;A == Character (0-75)
;X == TEXT position on window
;Y == TEXT position on window
display_character
.(
	sta temp_a
	stx temp_x
	sty temp_y
	// Calc screen address
	txa
	clc
	adc window_ylocl,y
	sta zero_00
	lda window_yloch,y
	adc #00
	sta zero_01
	// Calc character address
	ldy temp_a
	lda character_address_lo,y
	sta vector1+1
	lda character_address_hi,y
	sta vector1+2
	ldx #05
	ldy window_yoffset,x
vector1	lda $DEAD,x
	sta (zero_00),y
	dex
	bpl
	ldx temp_x
	ldy temp_y
	rts
.)


