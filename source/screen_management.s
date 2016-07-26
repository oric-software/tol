;screen_management.s
;This handles background management including...
;background scrolling
;background refresh
;background2screenbuffer
;plotColourColumn
;screenbuffer2screen

;*Memory areas*

;BackgroundBuffer (39*19) [741] (Fixed Memory @AB40 - AE24)
;Note that the background buffer will hold the characters direct from the map, so will
;not show their displayable ascii. This allows certain aspects of the game to be sped up.
;1) The hero can detect collisions using the background buffer (instead of scanning map)
;2) The colour column update can scan the left column (instead of scanning map)
;3) When the hero walks, the surface type will sound different. the background buffer
;   may also be used to detect the character below the heroes feet.
;However, to break down the workload, any character plotted on this map for we validated
;for it's correct character set (0 or 1) and changed if appropriate.
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBoBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;
;B Background
;
;ScreenBuffer (43*23) [989] (Fixed Memory @AE91 - B26D)
;sssssssssssssssssssssssssssssssssssssssssss
;sssssssssssssssssssssssssssssssssssssssssss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBoBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sssssssssssssssssssssssssssssssssssssssssss
;sssssssssssssssssssssssssssssssssssssssssss
;
;s extra space allocated for plotting sprites on borders
;C Colour column (Based on first A column)
;
;Screen (40*19) [760] (Fixed Memory @BCE8 - BFDF(End of Screen))
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;
;Origin Map (Origin of Hero X/Y on screen ())
;The origin is exceedingly important since it marks the point from which we will calculate
;the new data to refresh background with. Refer to...
;sourcesafe/software projects/games/tol/images/game_grid.bmp for an example.
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBoBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;CBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

;o Origin
;h Actual Hero Position

;The first step is to refresh the complete background. This does take time, regardless
;how it is done, because every character is fetched using the fetch_character routine.
#define	spare8		$AB37


background_refresh
;first, locate the start position (Top-left of background)
          jsr calc_bg_left_edge
          jsr calc_bg_top_edge
;Next, setup some pointers and counters
          ;// Setup Background Buffer start
          jsr setup_backgroundbuffer    ;into zero_00/zero_01
;Reserve test_xl/test_xh since these will need resetting at the end of every line
          lda test_xl
          sta ref_test_xl
          lda test_xh
          sta ref_test_xh
          ;// Setup row index
          ldx #19
.(
loop1     ldy #00
	txa
	pha
;	stx temp_04
	jsr refresh_bg_row
	pla
	tax
;	ldx temp_04
          ;// Restore test_xl/xh
          lda ref_test_xl
          sta test_xl
          lda ref_test_xh
          sta test_xh
          ;// increment ypos
          inc test_yl
          bne skip1
          inc test_yh
          ;// increment bg screen
skip1     lda #39
          jsr add_zero00
	dex
          bne loop1
.)
          rts

;The next steps are going to be the scroll routines. Physically refreshing the complete
;background whenever the hero moves is both too slow and unneccasary.

;The scroll routines just need to be fast, we don't care how it's done.
;Each scroll routine will fundamentally leave a gap on the opposite side to the direction
;of the scroll. This gap will be filled with column and row refresh routines.

scroll_background_west
          jsr setup_backgroundbuffer
	ldx #19
.(
loop2     ldy #01
loop1     lda (zero_00),y
	dey
          sta (zero_00),y
	iny
	iny
          cpy #39
          bcc loop1
          lda #39
          jsr add_zero00
	dex
          bne loop2
.)
          rts

scroll_background_east
          jsr setup_backgroundbuffer
	ldx #19
.(
loop2     ldy #37
loop1     lda (zero_00),y
	iny
	sta (zero_00),y
	dey
	dey
          bpl loop1
          lda #39
          jsr add_zero00
	dex
          bne loop2
.)
          rts

scroll_background_north
          jsr setup_backgroundbuffer
	ldx #19
.(
loop2     lda #38
          sta zero_02
          lda #77
          sta zero_03
loop1     ldy zero_03
          lda (zero_00),y
          ldy zero_02
          sta (zero_00),y
          dec zero_03
          dec zero_02
          bpl loop1
          lda #39
	jsr add_zero00
	dex
          bne loop2
.)
          rts

scroll_background_south
          lda #<$ab40+39*17
          sta zero_00
          lda #>$ab40+39*17
          sta zero_01
	ldx #19
.(
loop2     lda #38
          sta zero_02
          lda #77
          sta zero_03
loop1     ldy zero_02
          lda (zero_00),y
          ldy zero_03
          sta (zero_00),y
          dec zero_03
          dec zero_02
          bpl loop1
          lda #39
	jsr sub_zero00
	dex
          bne loop2
.)
          rts

setup_backgroundbuffer
          lda #$40
          sta zero_00
          lda #$ab
          sta zero_01
          rts
;AE91    989     Screen Buffer (AEE8 is actual start of screen data)
setup_screenbuffer
	lda #$e8
	sta zero_02
	lda #$ae
	sta zero_03
	rts


;Now we'll need to refresh columns and rows dependant on scroll that took place
;Both of these routines require test_xl,test_xh,test_yl and test_yh and Y or X register
;(to specify where the column or row should be) to have been set up prior to calling them.
;Note that X register is for Ypos and Y is for X (Confusing huh?)

refresh_bg_right_column      ;Plot vertical column of ascii characters on background
          jsr calc_bg_top_edge
	;calc_bg_right_edge
          lda hero_xl
          clc
          adc #21
          sta test_xl
          lda hero_xh
          adc #00
          sta test_xh
          jsr setup_backgroundbuffer
          ldy #38
          lda #19
          sta ycount
.(
loop1     jsr fetch_character
          sta (zero_00),y
          inc test_yl
          bne skip1
          inc test_yh
skip1     lda #39
          jsr add_zero00
          dec ycount
          bne loop1
.)
          rts

refresh_bg_left_column      ;Plot vertical column of ascii characters on background
          jsr calc_bg_left_edge
          jsr calc_bg_top_edge
          ldy #00
          lda #19
          sta ycount
          jsr setup_backgroundbuffer
.(
loop1     jsr fetch_character
          sta (zero_00),y
          inc test_yl
          bne skip1
          inc test_yh
skip1     lda #39
          jsr add_zero00
          dec ycount
          bne loop1
.)
          rts

refresh_bg_top_row
          jsr calc_bg_left_edge
          jsr calc_bg_top_edge
          ldy #00
          jsr setup_backgroundbuffer
.(
loop1     jsr fetch_character
          sta (zero_00),y
          inc test_xl
          bne skip1
          inc test_xh
skip1     iny
          cpy #39
          bcc loop1
.)
          rts

refresh_bg_bottom_row
	lda #<$ab40+18*39
	sta zero_00
	lda #>$ab40+18*39
	sta zero_01
          jsr calc_bg_left_edge
	;calc_bg_bottom_edge
          lda hero_yl
          clc
          adc #11       ;12
          sta test_yl
          lda hero_yh
          adc #00
          sta test_yh
          ldy #00
refresh_bg_row
.(
loop1     jsr fetch_character
          sta (zero_00),y
          inc test_xl
          bne skip1
          inc test_xh
skip1     iny
          cpy #39
          bcc loop1
.)
          rts

;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBoBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBhhhBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB


calc_bg_left_edge
          lda hero_xl
          sec
          sbc #17
          sta test_xl
          lda hero_xh
          sbc #00
          sta test_xh
          rts
calc_bg_top_edge
          lda hero_yl
          sec
          sbc #7
          sta test_yl
          lda hero_yh
          sbc #00
          sta test_yh
          rts

;Convert BG Character (A) to Charset Address or empty8 (Attribute) and store
;in zero_02/zero_03
character2address
	cmp #32
.(
	bcc skip1
;	cmp #96
;	bcc skip2
;	sbc #64
skip2	sec
	sbc #32
	asl
	asl
	rol vector1+1
	asl
	rol vector1+1
	sta zero_02
vector1	lda #00
	and #03
	clc
	adc #$b5
	sta zero_03
	rts
skip1	lda #<spare8
.)
	sta zero_02
	lda #>spare8
	sta zero_03
	rts


;Whenever anything new is displayed on the background (BG) buffer, the codes
;associated character set is checked. This must be done using the fastest
;method possible. If self-modifying madness shortens the delay, then that's
;what we'll use.
;Note that only X register may be corrupted.

;On entering the routine, the Accumulator will contain the code (From 0 to 159).
;00-31  Attribute
;32-95  Character Set 0
;97-159 Character Set 1
;*Z This routine may well be better placed in zero Page (Speed)

;second set
; +128 No second set
; 0 First set current
; 1 second set current

;Now to copy the background buffer to the screen-buffer. Unfortunately, oric hardware does
;not permit any shifting of the screen location (unlike other 8 bit computers) which is
;a terrible shame, but hey, let's software render!

;Their is a slight awkwardness in copying, since we must copy the background to a particular
;offset in the screen-buffer.
;We must also convert the character stored directly in the background to a displayable
;ascii code in the screen-buffer observing inverse on 40 and 41.


background2screenbuffer
          jsr setup_backgroundbuffer
          lda #$e9
          sta zero_02
          lda #$ae
          sta zero_03
          lda #19
	sta ycount
.(
loop2     ldy #38
loop1     lda (zero_00),y
	;We must check/update each char here
	tax
	cmp #32
          bcc skip1
          cmp #96
          bcs check_charset1
check_charset0
          tax
	lda second_set-32,x
	bmi skip1	;no second set
          bne Change_character2set0
	jmp skip1
check_charset1
	tax
	lda second_set-96,x
	bmi skip1
          beq Change_character2set1
skip1	// May need to change this bit to check on current charset (for screen corruption)
	lda actual_character_code,x
	sta (zero_02),y
          dey
          bpl loop1
          lda #39
          jsr add_zero00
          lda #43
          jsr add_zero02
          dec ycount
          bne loop2
          rts


Change_character2set0
          // Flag Character Set 0
          lda #00
          sta second_set-32,x
	lda ascii_character_address_lo-32,x
	sta Vector1 + 1
	sta Vector2 + 1
	cpx #64	// 32-63 or 64-95
	lda #$b5	;>StdCharset
	adc #00
	sta Vector2 + 2
	sec
	sbc #$ae	;Relies on chs0 @ 700
finish_copying
	sta Vector1 + 2
          stx temp_code
          ldx #07
Loop1
Vector1   lda $DEAD,x
Vector2   sta $DEAD,x
          dex
          bpl Loop1
          lda temp_code
          rts

Change_character2set1
	// Flag Character Set 1
          lda #1
          sta second_set-96,x
	lda ascii_character_address_lo-96,x
	sta Vector1 + 1
	sta Vector2 + 1
	cpx #128	// 96-127 or 128-159
	lda #$b5	;>StdCharset
	adc #00
	sta Vector2 + 2
	sec
	sbc #$ac	;Relies on chs1 @ 900
          jmp finish_copying
.)

;Finally, we'll need driver routines for each type of movement

manage_bg4hero_west
          jsr scroll_background_east
          jsr refresh_bg_left_column
          rts

manage_bg4hero_east
          jsr scroll_background_west
          jsr refresh_bg_right_column
	rts
manage_bg4hero_north
          jsr scroll_background_south
          jsr refresh_bg_top_row
          rts

manage_bg4hero_south
          jsr scroll_background_north
          jsr refresh_bg_bottom_row
          rts


;***********************




;We now need to plot the colour column.
;The colour column ensures that when scrolling, the associated colour for any character
;(or attribute) that falls off the left side of the screen are not lost.
;This is a classic fault of games like ?(Boing?)

;The process of fetching the colour for each character is pretty straight-forward.

;*Z - This routine may well be better placed in zero Page (Speed)
plotColourColumn
          jsr setup_backgroundbuffer    //into zero_00/01
          jsr setup_screenbuffer        //into zero_02/03
          ldx #19
.(
loop1     ldy #00
          lda (zero_00),y
          tay
          lda character_attribute_table,y
          // Extract Colour
          and #07
	// Transform colour for time of day
	tay
	lda actual_character_code,y
	// Store Colour
          ldy #00
          sta (zero_02),y
          lda #39
          jsr add_zero00
          lda #43
          jsr add_zero02
          dex
          bne loop1
.)
          rts


;Note that low byte of both screen and screen-buffer are the same, this forces a balance
;when the need arises to increment the high byte.

screenbuffer2screen
          lda #$e8
          sta zero_00
          sta zero_02
          lda #$ae
          sta zero_01
          lda #$bc
          sta zero_03
          ldx #19
	clc

.(
loop2     ldy #39
loop1     lda (zero_00),y
          sta (zero_02),y
	dey
	bpl loop1

	lda zero_00
	adc #43
	sta zero_00
	bcc skip1
	inc zero_01
	clc

skip1	lda zero_02
	adc #40
	sta zero_02
	bcc skip2
	inc zero_03
	clc

skip2
          dex
          bne loop2
.)
          rts

add_zero00
	clc
	adc zero_00
	sta zero_00
.(
	bcc skip
	inc zero_01
skip	rts
.)

add_zero02
	clc
	adc zero_02
	sta zero_02
.(
	bcc skip
	inc zero_03
skip	rts
.)

sub_zero00
	sta tempsub
	lda zero_00
	sec
	sbc tempsub
	sta zero_00
.(
	bcs skip
	dec zero_01
skip	rts
.)
