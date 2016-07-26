// * Hand Icon Control *
// USE
;When Hand icon is selected from Icon menu, the message "Select object" will be displayed.
;The Options window will then display a scrollable window of objects for the hero to choose from.
;Objects include magical artifacts and weapons
;Magical Artifacts 	- Attempt to Use Object here
;Weapons		- Upgrade current weapon to this one
;27
;Once an object has been chosen, the routine will know what the object is for...
; NUM    OBJECT         USE                              		FOUND
// Magical Items
; 176    TIN CLASP      Used with cloak to 'activate' disguise        Calibor, Crannoth
; 200    CLOAK          See Tin Clasp                                 Castle, Phang Province
; 188    BOOTS          SpeedUp                                       Barton, Treela
; 201    MEDALLION      Restores friendship if friend killed          Agrechant Underworld
; 202    MEAD CHIME     Use at 103,10 to raise gold from ground 	Bombadil, Sleepy River
; 203    RING           Temporary Invisibility, Saps life!            South of Dessert
; 189    MAP BOOK       Teleport                                      Agrechant Underworld
; 190    STONES         Guides the hero through the first quest       Head Orc, Dark Forest
; 195    TABLET         Required for main quest                       Head Orc, Dark Forest
; 177    WAND           Creates bridge to inner isle                  Bombadil, Sleepy River
// Magical Weapons
; 191    MAGIC HAT      Invincibility for 5 minutes                   Agrechant Underworld
; 192    BOW&ARROW      Infinite Arrows (Fires at rate 1)             Temple of Angor Grounds
; 193    HOLY WATER     Dispells Skeletons once posessed              Dark Prior, Rhyder
; 194    CROSS          Dispells Ghosts once posessed                 Inner Isle
; 199    AXE            Infinite Axes (Fires at rate 20)              Samson
; 204    PARCHMENT      Kills all enemy on screen                     Dropped by Asps
; 184    OLD SCROLL     Hurts creatures repeatedly for 1 min          Dropped by Black Asps
; 187    WHITE VIAL     Vanishes other Creatures!                     Dropped by Ghosts
; 185    SKULL          Creatures attack each other                   Dropped by Rogues
// Magical Replenishments
; 186    GREEN VIAL     Restores Life                                 Dropped by Rogues
// Artifacts
; 178    GLASS KEY      Opens Agrechant Gate                          Underworld #1
; 179    STONE KEY      Opens Angor Gate                              Calibor, Crannoth
; 180    QUARTZ KEY     Opens Crannoth Gate                           Calibor, Crannoth
; 181    NOTE           Information only                              Midraths Lodge, Dessert
// Weapons
; 183    DAGGER         Fires once, item is dropped                   Woodmans Lodge, D'Forest


;Items can be used inside or outside buildings, however instant weapons will only take effect
;outside.
#define	posessed_keywords	$b2ec
#define	posessionlist	$b457
#define	matching_item	$b4b2
#define	hurt_creature_count	$b383

hand_icon_selected
	lda #219	;Select Item (to use)
	jsr message2window
	jsr posesseditems2optionbuffer
	jsr select_option
.(
	bcc skip1	;Abort selection
	ldy optionbuffer,x
;	sty held_object
	;Now Use a vector jump to decipher how to use the object
	;Any attempt to use a different item (regardless of success) will disable cloak
	lda #00
	sta hero_disguise
	lda object_utility_vector_lo-176,y
	sta vector1+1
	lda object_utility_vector_hi-176,y
	sta vector1+2
vector1	jsr $DEAD
skip1	rts
.)

;Magic Weapons are...
;184 - OLD SCROLL	Magic Weapon #1 - Hurt creatures repeatedly for 1 min - BlueOut
;185 - SKULL     	Magic Weapon #2 - Vanish all Creatures		    - XScroll
;187 - WHITE VIAL	Magic Weapon #3 - Turns all creatures to friendGhosts - Whiteout
;204 - PARCHMENT	Magic Weapon #4 - Kill all enemy on screen            - RedOut
ouv_um_skull
	;Perform visual Effect
	;xscroll - Only affects background graphics
	ldy #8
	ldx #00
.(
	;wrap left first half
loop1	lda $b500,x
	asl
	bcc skip1
	ora #1
skip1	sta $b500,x
	;wrap right second half
	lda $b600,x
	lsr
	bcc skip2
	ora #128
skip2	sta $b600,x
	;
	dex
	bne loop1
	;Pause and wrap 8 times to bring set back to original
	lda #1
	jsr delay
	dey
	bne loop1
.)
	;SFX
	nop
	nop
	nop
	nop
	nop
	;Vanish all creatures
	ldx #02
	lda #00
.(
loop1	sta creature_activity,x
	dex
	bpl loop1
.)
	;SPIDERY RUNES EMERNATE FROM THE SCROLL..
	lda #209
	jmp ouv_um_exit_point


ouv_usemagic
	sty test_tempy
	cpy #185
	beq ouv_um_skull
	bcc ouv_um_oldscroll
	cpy #187
	beq ouv_um_whitevial


ouv_um_parchment
	;Perform visual Effect
	;Red >> Magenta >> White >> Magenta >> Red >> Black
	lda #01+16
	ldy #05+16
	jsr se_out
	;Kill all creatures
	ldx #02
.(
loop1	lda creature_activity,x
	beq skip1
	lda #04
	sta creature_activity,x
skip1	dex
	bpl loop1
.)
	;SFX
	nop
	nop
	nop
	nop
	nop
	lda #208
ouv_um_exit_point
	jsr message2window
	;Decrement posession
	lda test_tempy
	jsr sub_hero_posession
	;refresh screen
	jsr background2screenbuffer
	jsr plotColourColumn
	jmp screenbuffer2screen






ouv_um_oldscroll
	;Perform visual Effect
	lda #04+16
	ldy #06+16
	jsr se_out
	;Now set hurt creature into motion
	lda #127
	sta hurt_creature_count
	;SFX
	nop
	nop
	nop
	nop
	nop
	; Set Colour mix for period
	jsr toxic_mist_colourscheme
	; A TOXIC MIST SPREADS ACCROSS THE LAND...
	lda #210
	jmp ouv_um_exit_point

ouv_um_whitevial
	;Perform visual Effect
	lda #07+16
	ldy #00+16
	jsr se_out
	;Turn all creatures to friendly ghosts
	ldx #02
.(
loop1	lda creature_activity,x
	beq skip1
	lda #16
	sta creature_base_frame,x
	lda #00
	sta creature_foe,x
skip1	dex
	bpl loop1
.)
	;SFX
	nop
	nop
	nop
	nop
	nop
	lda #207
	jmp ouv_um_exit_point





se_out	sta zero_list+2
	sty zero_list+1
	lda #16+0
	sta zero_list+3
	lda #16+7
	sta zero_list
	ldx #03
.(
loop1	;plot this to attribute column
	jsr setup_screenbuffer	;into zero_02/03
	ldy #00
	lda #19
	sta ycount
loop2	lda zero_list,x
	sta (zero_02),y
	lda #43
	jsr add_zero02
	dec ycount
	bne loop2
	;send buffer to screen
	txa
	pha
	jsr screenbuffer2screen	;But 00-03 get corrupted
	pla
	tax
	;delay it for about 2/10 second
	lda #20
	jsr delay
	;
	dex
	bpl loop1
.)
	jsr plotColourColumn
	jmp screenbuffer2screen

delay	sta zero_01
.(
loop1	adc #01
	bcc loop1
	dec zero_01
	bne loop1
.)
	rts


ouv_usemedallion
	;Restore Friendship
	lda #00
	sta friend_is_enemy
	;SFX
	lda #00
	nop
	nop
	nop
	;Message
	lda #214
	jmp message2window

ouv_usepotion	;Life Replenish
	;Display message
	lda #211	;Quaffing the potion, you feel restored
	jsr message2window
	;Increment life by random amount
	lda rnd_byte0
	and #15	;Limit to half-life
	ora #16
	adc life_force
	;Cap Top to 31
	cmp #32
.(
	bcc skip1
	lda #31
skip1	sta life_force
.)
	;Show special effect (whitening) on candle flame for one frame
	lda #128+7
	sta flame_colour
	;Sound Effect
	lda #01
	nop
	nop
	nop
	;Remove Green vial from Posessions
	lda #186
	jmp sub_hero_posession


ouv_usebook
	;The book should actually present a list of posessed keywords, not locations
	;The posessed keywords are matched to location_list and displayed as options
	;On selection, the hero is teleported to that location (indexed by loc list)
	lda #00
	sta option_index
	ldx #11
	;Fetch known location keyword number
.(
loop2	lda location_list,x
	;Find out if hero knows it
	ldy #19
loop1	cmp posessed_keywords,y
	beq skip1
	dey
	bpl loop1
	jmp skip2	;Not posessed, so next location
skip1	;Keyword is known, so add to option list
	ldy option_index
	sta optionbuffer,y
	inc option_index
skip2	;Next location
	dex
	bpl loop2
	ldy option_index
	beq skip3	;No locations found
	inx
	stx optionbuffer,y	;optionbuffer is in zp, so we can do this!
	stx option_index
	jsr select_option
	bcc skip5	;Book aborted
	lda optionbuffer,x
	;Now we have location, but we need to track back through location_list
	;to find correct index
	ldx #11
loop3	cmp location_list,x
	beq skip4
	dex
	bpl loop3
skip3	jmp ouv_not_here	;This should never happen
skip4	;Found index, so use it to index and store new hero loc
	lda location_destination_xl,x
	sta hero_xl
	lda location_destination_xh,x
	sta hero_xh
	lda location_destination_yl,x
	sta hero_yl
	;Special format to conserve bytes...
	;B0-3 - YH
	;B7   - Outside(0) or Island/Phang(128)
	lda location_destination_yh_and_elsewhere,x
	cmp #128
	and #15
	sta hero_yh
	lda #00
	ror
	;elsewhere_flag
	;0 - Outside
	;1 - In Tavern or Inn		 (Icon Menu Only)
	;2 - In House                            (Icon Menu Only)
	;3 - In Underworld or Underground Passage(Not shown on Map)
	;128 - On Island (Combination)           (Not shown on Map)
	sta elsewhere_flag
	//Kill all creatures
	jsr kill_all_creatures
	// If we find space for special effects, they should occur here
	// Like rotate Hero a few times
	//Now we need to refresh background
	jsr background_refresh
	pla	;Don't go back to menu
	pla
	pla
	pla
skip5	rts
.)



ouv_usecloak
	;Finding the disguise should only occur when the hero decides he wants to be
	;something on the screen, so look at the last active sprite for disguise
	ldx #02
.(
loop1	lda creature_base_frame,x
	ldy creature_activity,x
	bmi skip1
	dex
	bpl loop1
	;Default to Orc
	lda #33
skip1	sta hero_disguise
.)
	;Sound Effect
	rts
ouv_not_here	;CANNOT USE OBJECT HERE
	lda #245	;The * is of little use here
	jmp message2window
;Some items like keys cannot be 'used' parse, when parsing a door, the hero posessing
;the object is enough to warrant passage.
ouv_notinthisway
	lda #217	;TO POSESS THE ? IS ENOUGH
	jmp message2window
ouv_usewand
	;To use wand, hero must be standing on edge of river
	;First, fetch first tsmap-loc north of hero.
	jsr calc_tsmapxy
	lda temp_01
	ldy temp_02
	dey
	jsr calc_tsmapaddressY0
	lda (zero_00),y
	;and check for top edge of river bank tile
	cmp #26
	bne ouv_not_here
	;Now look at tile just south (Hero)
	ldy #128
	lda (zero_00),y
	;and check for bottom edge of river bank
	cmp #36
	bne ouv_not_here
	;Now plot the bridge
	lda #39
	sta (zero_00),y
	ldy #00
	lda #38
	sta (zero_00),y
	;Sound Effect
	;Refresh Background
	jmp background_refresh
ouv_usedagger
	;The Dagger becomes the hero's primary weapon
	lda #1
ouv_useweapon
	sta held_weapon
	;Sound Effect
	rts
ouv_usebow
	lda #2
	jmp ouv_useweapon
ouv_useaxe
	lda #3
	jmp ouv_useweapon

ouv_useboots
	lda #01
	sta magical_boots
	;Sound Effect
	lda #188
	jmp message2window

posesseditems2optionbuffer
	// This must be more intelligent than other option lists in that it must exclude
	// repeated posessions like multiple potions or scrolls of the same type.

;;This needs to be rewritten to encapsulate a quantity in the first character
;;of the posession in tol_text.s
;;We also need to limit each item to 9 max.
;	;Clear matching item list
;	ldx #20
;	lda #00
;.(
;loop3	sta matching_item,x
;	sta optionbuffer,x
;	dex
;	bpl loop3
;	lda #182
;	sta optionbuffer
;	lda #01
;	sta option_index
;
;	ldx #00
;loop2	;Fetch posession item number
;	lda matching_item,x
;	bne skip2
;	lda #48
;	sta item_count
;	lda posessionlist,x
;	inc matching_item,x
;	;Count up how many hero has
;	ldy #20
;loop1	cmp posessionlist,y
;	bne skip1
;	inc item_count
;skip1	dey
;	bpl loop1
;	ldy option_index
;	sta optionbuffer+1,y
;	inc option_index
;	;store count in first char of message
;	tay
;    	lda text_vector_lo,y
;        	sta vector1+1
;        	lda text_vector_hi,y
;        	sta vector1+2
;	lda item_count
;vector1	sta $dead
;skip2	inx
;	cpx #20
;	bcc loop2
;.)
;	rts



;**
	ldx #00
	stx last_matched
	stx option_index
	// Flush matching_item and optionbuffer
	ldy #20
	lda #00
.(
loop3	sta matching_item,y
	sta optionbuffer,y
	dey
	bpl loop3
	//
	lda #182	// Add Gold to list
	sta optionbuffer
	//
loop1	lda posessionlist,x
	ldy last_matched
loop2	cmp matching_item,y
	beq skip2
	dey
	bpl loop2
	ldy option_index
	sta optionbuffer+1,y
	inc option_index
	ldy last_matched
	sta matching_item,y
	inc last_matched
skip2	inx
	cpx #20
	bcc loop1
skip1	rts
.)


