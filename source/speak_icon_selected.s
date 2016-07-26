// Steps
// *Creature
// 	*Subject
// 		*Item (Subject==Question)
// 		Deal (Subject==Lodging or Provisions)
#define	posessed_keywords		$b2ec

speak_chosen
.(
skip3	// Creature Menu
	jsr creatures2options
	bcc skip2	// No one around
	lda #225
skip7	jsr message2window
	jsr select_option
	bcc skip1	// Abort Creature menu
	// Check if all foes
	lda friend_is_enemy
	bmi skip8
	lda optionbuffer,x
	// Check If creature is foe
	bmi skip6
skip8	// If creature is <128 then always foe
	lda #243	// The creature ignores you
	jmp skip7
skip6	sta selectedcreature
skip4	// Subject Menu
	jsr subjects2options
	bcc skip2	// No subjects for creature
	lda #224
	jsr message2window
	jsr select_option
	bcc skip3	// Abort Subject menu
	lda optionbuffer,x
	sta selectedsubject
	// Matter Menu
	jsr matter2options
	bcc skip5	// Matter Implied
	lda #251	;Select something
	jsr message2window
	jsr select_option
	bcc skip4	// Abort Matter menu
	lda optionbuffer,x
	sta selectedmatter
skip5	// Response
	jsr find_response
	bcs skip1	;If creature was talkative, message would already have been given
skip2	jsr message2window
skip1	rts
.)

creatures2options
;elsewhere_flag
;0 - Outside
;1 - In Tavern or Inn		 (Icon Menu Only)
;2 - In House                            (Icon Menu Only)
;3 - In Underworld or Underground Passage(Not shown on Map)
;128 - On Island (Combination)           (Not shown on Map)
	lda elsewhere_flag
	and #127
.(
	beq skip6	;Outside
	cmp #02
	bcc skip5	;In Tavern
	bne skip6	;In Underworld
	jmp skip7	;In House
skip6	ldy #00
	ldx #02
loop1	lda creature_activity,x
	bpl skip1
	lda creature_code,x
	sta optionbuffer,y
	iny
skip1	dex
	bpl loop1
	inx
	stx optionbuffer,y
	cpy #01
	bcs skip2
skip3	lda #253	;No One Around
	clc
skip2	rts

skip5	// In Tavern or Inn
	lda friend_is_enemy	;0(Friend) or 128(Foe)
	bmi skip3
	lda #250	;InnKeeper
	sta optionbuffer
	ldy #01
	sty option_index
skip8	ldx #123	;Check for other Creatures
loop2	jsr fetch_textloc00y0
	lda (zero_00),y
	cmp #01
	bne skip4
	iny
	lda (zero_00),y
	cmp current_place
	bne skip4
	ldy option_index
	stx optionbuffer,y
	inc option_index
skip4	inx
	cpx #144
	bcc loop2
	ldx option_index
	lda #00
	sta optionbuffer,x
	rts

skip7	;In House, so similar to Tavern except no Innkeeper
	ldy #00
	sty option_index
	jmp skip8


.)

subjects2options
	// default are question and rumours(chitchat)
	lda #249
	sta optionbuffer
	lda #248
	sta optionbuffer+1
	// Then dependant on creature
	ldy #02
	ldx selectedcreature
	cpx #250
.(
	bne skip1	;Other creatures
	// Add lodging and food for innkeeper
	lda #247	// Rations
	sta optionbuffer,y
	iny
	lda #246	// Sleep Here
	sta optionbuffer,y
	iny
skip1	lda #00
.)
	sec
	sta optionbuffer,y
	rts

matter2options
	lda selectedsubject
	cmp #249	//Ask Question
.(
	bne skip2
	// Compile list of known keywords
	ldx #00
loop1	lda posessed_keywords,x
	sta optionbuffer,x
	beq skip1
	inx
	cpx #20
	bcc loop1
	lda #00
	sta optionbuffer,x
skip1	sec
	rts
skip2	clc
.)
	rts

is_creature_talkative
	ldx #111
.(
loop2	jsr fetch_textloc00y0
	; Check if creature we are talking to
	lda (zero_00),y
	cmp selectedcreature
	bne skip3	;Not creature we're talking to, so next chitchat_interaction
	; Now look at any possessions the hero should posess
loop1	iny
	lda (zero_00),y
	beq skip1	;First contact, so ok
	cmp #254
	bcs skip2	;end of list of posessions(Or no posessions required), so ok
	cmp #176
	bcc skip3	;First contact already passed, so look at next chitchat_interaction
	stx temp_x
	jsr is_posessed
	ldx temp_x
	bcc skip3	;not posessed, so look at next chitchat_interaction
	;Posessed, so look at next posession
	jmp loop1
skip1	;First Contact, so increment data and look for more posessions
	lda #01
	sta (zero_00),y
	jmp loop1
skip3	inx
	cpx #118
	bcc loop2
	;No more chitchat_interactions, so rts with none found
	clc
	rts
skip2	;This is the chitchat_interaction to use (X)
.)
	stx chitchat_number
	iny	;Increment Y and add to zero_00
	tya
	jsr add_zero00
	;So we're looking at response text just in zero_00
	jsr messageaddress2window
	;Now check if chitchat_interaction triggered a question
	ldx chitchat_number
	;Refetch chitchat message address
	jsr fetch_textloc00y0
	;Now search for first 255
	ldy #00
.(
loop1	lda (zero_00),y
	tax
	iny
	lda (zero_00),y
	cmp #255
	bne loop1
.)
	;X will contain last digit before 255
	cpx #"?"
.(
	beq skip9
skip13	jmp skip1	;Not a question
skip9	;Creature may be selling something, so get creature

	ldy #00
	lda (zero_00),y
	;And fetch creature address
	tax
	jsr fetch_textloc00y0
	;Only interesting in Type 1
	lda (zero_00),y
	cmp #1
	bne skip13
	;backup zero_00 (Need it later if we buy object)
	lda zero_00
	sta zero_06
	lda zero_01
	sta zero_07
	;Now look at offset 2 onwards for posession list (Up to 254)
	ldy #2
	ldx #00

loop1	lda (zero_00),y
	beq skip2	;void
	cmp #254
	bcs skip3	;End of List
	sta optionbuffer,x
	inx
skip2	iny
	jmp loop1
skip3	cpx #00
	beq skip1	;Creature sold all posessions
	lda #00
	sta optionbuffer,x
	jsr select_option
	bcc skip1	;Aborted list
	;Now hero has made a selection(x), we must capture the object
	lda optionbuffer,x
	;We must also remember the object and the offset in the creatures posessions
	sta new_posession
	inx
	inx
;	stx creatures_offset
	tax
	;We must capture the correct offset in the posession list (Not optionbuffer)
	ldy #2
loop3	cmp (zero_06),y
	beq skip7
	iny
	cpy #7
	bcc loop3
	;We hope this rem line is never reached!
skip7	sty creatures_offset
	;And fetch the object address
	jsr fetch_textloc00y0
	;then try to get it's value
loop2	lda (zero_00),y
	iny
	cmp #255
	bne loop2
	;If next byte is 255, then value included
	lda (zero_00),y
	cmp #255
	bne skip5	;Free item
	;Fetch value
	iny
	lda (zero_00),y
	sta posession_price	;Hi
	iny
	lda (zero_00),y	;Lo
	sta posession_price+1
	;Attempt to subtract from hero's pouch
	ldy posession_price
	jsr subtract_money
	bcc skip4		;Not enough gold
skip5	;add to hero inventory and confirm to text window
	jsr add_hero_posession
	bcc skip1		;Not enough room
	;subtract from creatures inventory
	ldy creatures_offset
	lda #00
	sta (zero_06),y
	;Now if the item was the tin clasp, we'll need to set the flag
	lda new_posession
	cmp #176
	bne skip11
	inc clasp_posessed_flag
skip11	;Or if Cross
	cmp #194
	bne skip12
	inc cross_posessed_flag
skip12	;Or if Holy Water
	cmp #193
	bne skip10
	inc holywater_posessed_flag
skip10	;Mark return as from chitchat
	sec
	rts
skip4	lda #232	;Not Enough Gold
skip6	jsr message2window
skip1	sec
.)
	rts

find_response
	// General subjects
	lda selectedsubject
	cmp #248	;chitchat
.(
	beq skip1
	cmp #246	;lodging
	beq skip2
	cmp #247	;Ration
	beq skip3
	// search on special (keyword) Subject
	jmp questionkeyword
skip1	// Chitchat, however check if creature wants to say something
	jsr is_creature_talkative
	bcs skip5	;If talkative, then the sentence will have already been given
	// Start random chitchat
;	lda rnd_byte1
;	and #01
;	adc #244	//244 OR 245
	lda #244
	jsr message2window
	lda rnd_byte1
	lsr
	and #07
	adc #235		//random Rumour or Blank response
	clc
skip5	rts
skip2	// Lodging
	lda #$00	;lo gold
	ldy #$02	;hi gold
	sty posession_price
	sta posession_price+1
	jsr subtract_money
	bcc skip4
	; Restore life-force
	lda #31
	sta life_force
	; Wait upon SunMoon reaching Morning
loop1	jsr update_sunandmoon
	lda sunmoon_lighting
	cmp #15
	bne loop1
	;AutoSave Current Game Here
	lda #233	;THE BED LOOKS SOFT AND INVITING.
	clc
	rts
	jmp save_game
skip3	// Food Pack
	lda #$00	;lo
	ldy #$01	;Hi
	sty posession_price
	sta posession_price+1
	jsr subtract_money
	bcc skip4
	jsr increment_ration
	lda #234	;THE INNKEEPER GIVES YOU ONE FOOD PARCEL
	clc
	rts
skip4	lda #232	;you do not have enough money
.)
	clc
	rts

questionkeyword
	ldx selectedmatter
	jsr fetch_textloc00y0
	// Locate creature field
.(
	jsr lookbeyond254in00r
;loop1	lda (zero_00),y
;	iny
;	cmp #254
;	bne loop1

	lda (zero_00),y
	beq skip1	;not creature specific
	cmp selectedcreature
	bne skip2	;"Don't know anything about that"
skip1	lda selectedmatter
	clc
	rts
skip2	lda #231
.)
	clc
	rts

;A == Lo BCD Money
;Y == Hi BCD Money
subtract_money
	sed
	sec
	sta temp_01
	sty temp_02
	lda hero_gold2
	sbc temp_01
	sta temp_01
	lda hero_gold1
	sbc temp_02
	sta temp_02
	lda hero_gold0
	sbc #00
.(
	bcc skip1
	sta hero_gold0
	lda temp_02
	sta hero_gold1
	lda temp_01
	sta hero_gold2
skip1	cld
	rts
.)

;A == BCD Money (0-99)
add_money
	sed
	clc
	adc hero_gold2
	sta hero_gold2
	lda hero_gold1
	adc #00
	sta hero_gold1
	lda hero_gold0
	adc #00
	sta hero_gold0
	cld
	rts

save_game
	rts


;We should be using this alot more elsewhere
fetch_textloc00y0
	ldy #00
fetch_textloc00
	lda text_vector_lo,x
	sta zero_00
	lda text_vector_hi,x
	sta zero_01
	rts

fetch_textloc02y0
	ldy #00
fetch_textloc02
	lda text_vector_lo,x
	sta zero_02
	lda text_vector_hi,x
	sta zero_03
	rts
