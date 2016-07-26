;Transfer from one loc to another dependant on Posessions
;This code is not the same as
transfer_hero
	jsr calc_tsmapxy	;into temp_01/2
.(	ldx #17
loop1	lda temp_01
	cmp transfer_location_source_x,x
	bne skip2
	lda temp_02
	cmp transfer_location_source_y,x
	beq skip1
skip2	dex
	bpl loop1
	rts
skip1	// Check posession required
	lda transfer_location_pass_posession,x
	beq skip3	;No posession required
	ldy #20
loop2	cmp posessionlist,y
	beq skip3
	dey
	bpl loop2
	sta required_posession
	lda #218	;The * is required
	jmp message2window
skip3	// Transfer Hero
.)
	lda transfer_location_destination_xl,x
	sta hero_xl
	lda transfer_location_destination_xh,x
	sta hero_xh
	lda transfer_location_destination_yl,x
	sta hero_yl
	lda transfer_location_destination_yh,x
	sta hero_yh
	// Refresh BG
	jsr background_refresh
	// This routine should have been executed
	// from manage_hero, so returning will
	// update rest.
	rts

using_magic_hat
	jsr places2options


places2options
	ldx #143
	stx
	jsr fetch_textloc00y0
	lda (zero_00),y
	bne
	txa

	;	0 (Tavern(And Magic Hat Destinations)),TSMapX,TSMapY,RegionText,254,NameText,255
;Story Quest Transfers
; Locate Equinox and travel to Crannoth.
;Nm Description				Sx  Sy  Dx    Dy	Pose
;0) Mouth of Equinox >> Passage  == 		19  4   1039  840   0
;1) Passage >> Crannoth Island	== 	19  28  176   121   0
;2) Crannoth Island >> Passage   == 		5   3   622   920   0
;3) Passage >> Mouth of Equinox	== 	32  26  625   152   0
; Locate southern Gate
;4) Crannoth Gate >> Passage	== 		6   9   47    552   180
;5) Passage >> Tempus Island	== 		7   41  976   1974  180
;6) Tempus Island >> Passage	== 		30  61  241   1319  180
;7) Passage >> Crannoth Gate	== 		1   17  209   312   180
; Locate Silderons Mouth
;8) Silderons Mouth >> Silderon Underworld#1 ==   10  50  47    1959  139 (Creature (pointer) should be present)
;9) Silderon Underworld#1 >> Crator 	  == 	21  54  1456  1656  203
;10) Crator >> Silderon Underworld#1	  ==      45  51  687   1735  203
;11) Underworld#1 >> Silderons Mouth          == 	1   61  337   1623  0
; Locate Ruins of Agrechant
;12) Ruins of Agrechant	>> Underworld#2 == 	88  53  4047  393   178
;13) Underworld#2 >> Ruins of Agrechant ==        126 12  2831  1719  201
;Quest 1 Transfers
;14) Outside Angor >> Passage	      == 		121 29  879   1112  179
;15) Passage >> Inside Angor	      == 		27  31  3887  857 	179
;16) Inside Angor >> Passage	      == 		121 26  879   1001  179
;17) Passage >> Outside Angor	      == 		27  34  3888  953   179
