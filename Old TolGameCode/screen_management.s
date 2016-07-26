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
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
;BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
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
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
;sCBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBss
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
loop      jsr refresh_bg_row
          ;// Restore test_xl/xh
          lda ref_test_xl
          sta test_xl
          lda ref_test_xh
          sta test_xh
          ;// increment ypos
          inc test_yl
          bne skip
          inc test_yh
          ;// increment bg screen
          lda #39
          jsr add_zero00
          ;// update count
          dex
          bne loop
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
loop1     lda (Zero_00),y
	dey
          sta (Zero_00),y
	iny
	iny
          cpy #39
          bcc loop1
          lda #39
          jsr add_Zero00
	dex
          bne loop2
.)
          rts

scroll_background_east
          jsr setup_backgroundbuffer
	ldx #19
.(
loop2     ldy #38
loop1     lda (00),y
	iny
	sta (00),y
	dey
	dey
          bpl loop1
          lda #39
          jsr add_Zero00
	dex
          bne loop2
.)
          rts

scroll_background_north
          jsr setup_backgroundbuffer
	ldx #19
.(
loop2     lda #38
          sta Zero_02
          lda #78
          sta Zero_03
loop1     ldy Zero_03
          lda (Zero_00),y
          ldy Zero_02
          sta (Zero_00),y
          dec Zero_03
          dec Zero_02
          bpl loop1
          lda #39
	jsr add_00
	dex
          bne loop2
.)
          rts

scroll_background_south
          lda #<$ab40+39*17
          sta Zero_00
          lda #>$ab40+39*17
          sta Zero_01
	ldx #19
.(
loop2     lda #38
          sta Zero_02
          lda #78
          sta Zero_03
loop1     ldy Zero_02
          lda (Zero_00),y
          ldy Zero_03
          sta (Zero_00),y
          dec Zero_03
          dec Zero_02
          bpl loop1
          lda #39
	jsr sub_00
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

;Now we'll need to refresh columns and rows dependant on scroll that took place
;Both of these routines require test_xl,test_xh,test_yl and test_yh and Y or X register
;(to specify where the column or row should be) to have been set up prior to calling them.
;Note that X register is for Ypos and Y is for X (Confusing huh?)

refresh_bg_right_column      'Plot vertical column of ascii characters on background
          jsr calc_bg_top_edge
          jsr calc_bg_right_edge
          ldy #38
          lda #19
          sta ycount
          jsr setup_backgroundbuffer
.(
loop      jsr fetch_character
          jsr check_charset
          sta (Zero_00),y
          inc test_yl
          bne skip
          inc test_yh
skip      lda #39
          jsr add_Zero00
          dec ycount
          bne loop
.)
          rts

refresh_bg_left_column      'Plot vertical column of ascii characters on background
          jsr calc_bg_left_edge
          jsr calc_bg_top_edge
          ldy #00
          lda #19
          sta ycount
          jsr setup_backgroundbuffer
.(
loop      jsr fetch_character
          jsr check_charset
          sta (Zero_00),y
          inc test_yl
          bne skip1
          inc test_yh
skip1     lda #39
          jsr add_Zero00
          dec ycount
          bne loop
.)
          rts

refresh_bg_top_row
          jsr calc_bg_left_edge
          jsr calc_bg_top_edge
          ldy #00
          jsr setup_backgroundbuffer
.(
loop      jsr fetch_character
          jsr check_charset
          sta (Zero_00),y
          inc test_xl
          bne skip1
          inc test_xh
skip1     iny
          cpy #39
          bcc loop
.)
          rts

refresh_bg_bottom_row
          jsr calc_bg_left_edge
          jsr calc_bg_bottom_edge
          ldy #00
          jsr setup_backgroundbuffer
refresh_bg_row      'Used to refresh screen
.(
loop      jsr fetch_character
          jsr check_charset
          sta (Zero_00),y
          inc test_xl
          bne skip1
          inc test_xh
skip1     iny
          cpy #39
          bcc loop
.)
          rts

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
calc_bg_bottom_edge
          lda hero_yl
          clc
          adc #11
          sta test_yl
          lda hero_yh
          adc #00
          sta test_yh
          rts
calc_bg_right_edge
          lda hero_xl
          clc
          adc #21
          sta test_xl
          lda hero_xh
          adc #00
          sta test_xh
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
;*Z This routine may well be better placed in Zero Page (Speed)
check_charset
.(
          cmp #32
          bcc skip
          cmp #96
          bcs check_charset1
check_charset0
          tax
          lda current_character_set-32,x
          bne Change_character2set0
          txa
skip      rts
character_set1
          tax
          lda current_character_set-96,x          '64 bytes long
          beq Change_character2set1
          txa
          rts

Change_character2set0
          '// Flag Character Set 0
          lda #00
          sta current_character_set-32,x
          '// fetch character address from 1
          lda character_set1_address_lo-32,x      '64 long
          sta Vector1+1
          lda character_set1_address_hi-32,x      '64 long
          sec
          sbc #2
          sta Vector1+2
          '// fetch actual ascii address
          lda ascii_character_address_lo-32,x     '64 long
          sta Vector2+1
          lda ascii_character_address_hi-32,x     '64 long
          sta Vector2+2
finish_copying
          stx temp_code
          ldx #07
Loop
Vector1   lda $DEAD,x
Vector2   sta $DEAD,x
          dex
          bpl Loop
          lda temp_code
          rts

Change_character2set1
          '// Flag Character Set 1
          lda #01
          sta current_character_set-96,x
          '// fetch character address from 1
          lda character_set1_address_lo-96,x      '64 long
          sta Vector1+1
          lda character_set1_address_hi-96,x      '64 long
          sta Vector1+2
          '// fetch actual ascii address
          lda ascii_character_address_lo-96,x     '64 long
          sta Vector2+1
          lda ascii_character_address_hi-96,x     '64 long
          sta Vector2+2
          jmp finish_copying
.)

;Finally, we'll need driver routines for each type of movement

manage_bg4hero_west
          jsr scroll_background_right
          jsr refresh_bg_left_column
          rts

manage_bg4hero_east
          jsr scroll_background_left
          jsr refresh_bg_right_column

manage_bg4hero_north
          jsr scroll_background_down
          jsr refresh_bg_top_row
          rts

manage_bg4hero_south
          jsr scroll_background_up
          jsr refresh_bg_bottom_row
          rts


;***********************

;Now to copy the background buffer to the screen-buffer. Unfortunately, oric hardware does
;not permit any shifting of the screen location (unlike other 8 bit computers) which is
;a terrible shame, but hey, let's software render!

;Their is a slight awkwardness in copying, since we must copy the background to a particular
;offset in the screen-buffer.
;We must also convert the character stored directly in the background to a displayable
;ascii code in the screen-buffer


background2screenbuffer
          jsr setup_backgroundbuffer
          lda #$e9
          sta Zero_02
          lda #$ae
          sta Zero_03
          ldx #19
.(
loop2     ldy #38
loop1     lda (Zero_00),y
          cmp #96   ;// Convert 0-159 to 0-95 (Character2ascii)
          bcc skip
          sbc #64
skip      sta (Zero_02),y
          dey
          bpl loop1
          lda #39
          jsr add_Zero00
          lda #43
          jsr add_Zero02
          dex
          bne loop2
.)
          rts



;We now need to plot the colour column.
;The colour column ensures that when scrolling, the associated colour for any character
;(or attribute) that falls off the left side of the screen are not lost.
;This is a classic fault of games like ?(Boing?)

;The process of fetching the colour for each character is pretty straight-forward.

;*Z - This routine may well be better placed in Zero Page (Speed)
plotColourColumn
          jsr setup_backgroundbuffer    'into Zero_00/01
          jsr setup_screenbuffer        'into zero_02/03
          ldx #19
.(
loop      ldy #00
          lda (Zero00),y
          tay
          lda character_attribute_table,y
          '// Extract Colour
          and #07
          ldy #00
          sta (Zero02),y
          lda #39
          jsr add_Zero00
          lda #43
          jsr add_Zero02
          dex
          bne loop
.)
          rts


;Note that low byte of both screen and screen-buffer are the same, this forces a balance
;when the need arises to increment the high byte.

screenbuffer2screen
          jsr setup_screenbuffer
          lda #$e8
          sta Zero_00
          sta Zero_02
          lda #$ae
          sta Zero_01
          lda #$bc
          sta Zero_03
          ldx #19
.(
loop2     ldy #39
loop1     lda (zero_00),y
          sta (zero_02),y
          dey
          bpl loop1
          lda #40
          jsr add_zero02
          lda #43
          jsr add_zero00
          dex
          bne loop2
.)
          rts

;4) Acquisition of a map
;The main problem with playing TOL outside of the usual commercial version is the clear
;lack of a physical map.
;The original intention was to either offer a map download as part of the game release
;or to offer a map in the main menu (Using some variation RGB panning screen).
;However neither would offer much benefit during the game.
;So the plan has slightly changed. The Game itself will contain an integrated map scope
;somewhere in the score panel at the top of the screen.
;The Map itself always resides in Game memory so fetching it will not be too difficult
;or expensive on time/memory.
;The Map should indicate position as flashing dot, and be of high enough resolution to
;identify the buildings nearby.
;A variable zoom facility would be neat, but not vital.
;
;Rather than completely attempting to emulate the c64 version, we optimise a bit by
;using the inlay at the top of the screen to display the icon menu.
;
; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII CCCCC
; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII CCCCC
; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
; MMMMMMMM TTTTTTTTTTTTTTTTTTTTTTTT CCCCC
;
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
; AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;
;I Icons
;M Map (Arranged as 8 * 6)
;T Text Area
;C Candle
;
;Note:
;I am thinking more and more about the advantages of placing the complete top section
;of the game in HIRES. This would free alt-charset for other data, HIRES would then consume
;up to AB40, whilst seperate 6*6 character set would be used in text area.
;It would also make the map plotting easier, since we wouldn't rely on 8*6 character array.
;The candle animation would be easier (Though slower).
;But the biggest concern is... Would it all fit into 48K?!!
;An example of the above scheme can be found in sourcesafe/games/tol/images/AI_Game.bmp
