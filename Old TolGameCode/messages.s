;Messages and message-code


;X==Message number from main list
;The generated Message in message_buffer with message_buffer_index pointing
;to last entry is in complete text form apart from a keyword flag that may
;exist prior to a NEW keyword (text) as zero. This gives the display routine
;the chance to sound an sfx on the occurrence of it.
;
fetch_major_main_message
	lda list_type_base_address_lo	;Locate major main message start into $b0
	sta $b0
	lda list_type_base_address_hi
	sta $b1
	jsr locate_255type_message

fmmm_03	ldy #00		;Now read 255 message byte
	lda ($b0),y
	bmi fmmm_09
	cmp #32
	bcs fmmm_10
fmmm_09	jmp proc_types
;proc char
fmmm_10	ldx #05
fmmm_01	cmp current_type_char,x
	beq fmmm_02
	dex
	bpl fmmm_01
fmmm_05	jsr store2buffer
fmmm_06	jsr inc_b0
	jmp fmmm_03
fmmm_02	ldy current_format,x
	bmi fmmm_decimal
	lda Current_types,x	;Fetch value
	ldx list_type_base_address_lo,y
	stx $b2
	ldx list_type_base_address_hi,y
	stx $b3
	tax
	jsr locate_128type_message
;add 128message
fmmm_07	ldy #00
	lda ($b2),y
	cmp #32
	bcc fmmm_21	;proc_128keyword
	pha
	and #127
	jsr store2buffer
fmmm_11	inc $b2
	bne fmmm_08
	inc $b3
fmmm_08	pla
	bpl fmmm_07
	jmp fmmm_06
fmmm_decimal
	tya
	and #127
	tay
	lda current_types+1,y
	ldx #03
	jsr store_numerics
	lda current_types,y
	jsr store_numerics
	ldx #03
fmmmd_02	lda numeric_buffer,x
	bne fmmmd_01
	dex
	bne fmmmd_02
fmmmd_01	lda numeric_buffer,x
	ora #48
	jsr store2buffer
	dex
	bpl fmmmd_01
	jmp fmmm_06
fmmm_21	jsr proc_128keyword
	jmp fmmm_11

proc_128keyword
	ldy #31	;Check if hero has this keyword yet
p128kw_01	cmp keyword_inventory,y
	beq p128kw_05	;he does
	dey
	bpl p128kw_01
;he does not, so find spare slot (128)!
	ldy #31
p128kw_02	ldx keyword_inventory,y
	bmi p128kw_03
	dey
	bpl p128kw_02
p128kw_05	tax
	jmp p128kw_04	;Could not add it, no spare entries so just store it
p128kw_03	sta keyword_inventory,y	;Store it
	tax
;	ldx #         	Don't sound sfx here, do it when actually displaying message
;	stx sfx_number
	;If we have enough mem remaining, add significance instead of just Zero, so different
	;sfx may be heard depending on the significance of the keyword!
	lda #00         	;Indicate it's presence so when we do display it, we can sound it!
	jsr store2buffer
p128kw_04 ldy #06
p128kw_20	lda $b2	;reserve original 128 message pointer
	sta $b4
	lda $b3
	sta $b5
	lda list_type_base_address_lo,y
	sta $b2
	lda list_type_base_address_hi,y
	sta $b3
	jsr locate_128type_message
p128kw_07	ldy #00	;Now store keyword
	lda ($b2),y
	pha
	and #127
	jsr store2buffer
	inc $b2
	bne p128kw_06
	inc $b3
p128kw_06	pla
	bpl p128kw_07
	lda $b4	;Restore original 128 message
	sta $b2
	lda $b5
	sta $b3
	rts

proc_types
	cmp #255
	beq ptypes_01
	cmp #32
	bcs ptypes_02
	jsr proc_128keyword
	jmp fmmm_06
ptypes_02 cmp #224
	bcc ptypes_03
;224-254 == Common Messages
	sbc #224
	ldy #10
ptypes_06	jsr p128kw_20
	jmp fmmm_06
ptypes_03	cmp #192
	bcc ptypes_04
;192-223 == Creature Index
	sbc #192
	ldy #09
	jmp ptypes_06
ptypes_04	cmp #160
	bcc ptypes_05
;160-191 == Location Index
	sbc #160
	ldy #08
	jmp ptypes_06
;128-159 == Object Index
ptypes_05	sec
	sbc #128
	ldy #07
	jmp ptypes_06
ptypes_01	rts		;End of message!!!!

store_numerics
	pha
	lsr
	lsr
	lsr
	lsr
	sta numeric_buffer,x
	dex
	pla
	and #15
	sta numeric_buffer,x
	dex
	rts

store2buffer
	ldy message_buffer_index
	sta message_buffer,y
	;Increment the index
	inc message_buffer_index
	;if greter than window width, need to search back for last space and cr their
	iny
	cpy window_width
	bcc s2b_01
	jsr search_back_for_space
	jsr display_line
	jsr scroll_window
	jsr adjust_buffer
s2b_01	rts

	sta message_buffer_index


	rts

current_format
 .byt 128+8
 .byt 128+10
 .byt 9
 .byt 7
 .byt 8
 .byt 3

;$ Current Gold		;Decimal
;# Current Food Parcels       ;Decimal
;& Current Creature           ;Name
;* Current Object(Item)       ;Name
;^ Current Location           ;Name
;@ Current Action             ;Name






;255Type messages are field seperated with 255
;X==Message Number
locate_255type_message
	cpx #00
	beq l255tm_04
	ldy #00
l255tm_01	lda ($b0),y
	cmp #255
	bne l255tm_02
	dex
	beq l255tm_03
l255tm_02	iny
	bne l255tm_01
	inc $b1
	jmp l255tm_01
l255tm_03	tya
	sec
	adc $b0
	sta $b0
	bcc l255tm_04
	inc $b1
l255tm_04	rts

;128Type messages are field seperated with Bit 7==1
;X==Message Number
locate_128type_message
	cpx #00
	beq l128tm_04
	ldy #00
l128tm_01	lda ($b2),y
	bpl l128tm_02
	dex
	beq l128tm_03
l128tm_02	iny
	bne l128tm_01
	inc $b3
	jmp l128tm_01
l128tm_03	tya
	sec
	adc $b2
	sta $b2
	bcc l128tm_04
	inc $b3
l128tm_04	rts


;Message lists
;0-31 Keyword Index
;32-127 Characters
;+128 end
;Major Lists
;0-31 == Keyword Index
;32-127 == Character
;128-159 == Object Index
;160-191 == Location Index
;192-223 == Creature Index
;224-254 == Common Messages
;255 End of Message
;$ Current Gold
;# Current Food Parcels
;& Current Creature
;* Current Object(Item)
;^ Current Location
;@ Current Action
;( Location of Barton
;) Game Complete

;This must be kept in this order so that the above routines work!!
list_type_base_address_lo
 .byt <major_main_list,<major_left_list,<major_right_list			;0-2
 .byt <action_list,<tod_messages,<Health_messages,			;3-5
 .byt <keyword_list,<object_list,<location_list,<creature_list,<common_list	;6-10
list_type_base_address_hi
 .byt >major_main_list,>major_left_list,>major_right_list
 .byt >action_list,>tod_messages,>Health_messages,
 .byt >keyword_list,>object_list,>location_list,>creature_list,>common_list

;Message Lists
keyword_list
 .byt "High Kin","g"+128	;0
 .byt "Spar","e"+128	;1
 .byt "orc","s"+128		;2
 .byt "cam","p"+128		;3
 .byt "Crannath Islan","d"+128;4
 .byt "Grego","r"+128	;5
 .byt "Heidri","c"+128	;6
 .byt "Forest of Enchantmen","t"+128	;7
 .byt "Lych","e"+128	;8
 .byt "Holy Wate","r"+128	;9
 .byt "Dark Cleric","s"+128	;10
 .byt "Dessert Ruin","s"+128	;11
 .byt "Hells Cryp","t"+128	;12
 .byt "Underwurld","e"+128	;13
 .byt "Crato","r"+128	;14
 .byt "Barto","n"+128	;15
 .byt "Temple of Phnan","g"+128	;16
 .byt "Magical Scrol","l"+128		;17
 .byt "Ring of powe","r"+128	;18
 .byt "Magical Ax","e"+128	;19
 .byt "Magical Boot","s"+128	;20
 .byt "Magical Arrow","s"+128	;21
 .byt "Silver Chainmai","l"+128	;22
 .byt "Secret Wa","y"+128	;23
 .byt "Green Doo","r"+128	;24
 .byt "Monks of the hidden orde","r"+128	;25
 .byt "other place","s"+128	;26
object_list
 .byt "Tablet of Trut","h"+128	;128
 .byt "Dagge","r"+128                   ;129
 .byt "Ring of Powe","r"+128            ;130
 .byt "Chim","e"+128                    ;131
 .byt "Medallio","n"+128                ;132
 .byt "Bronze Ke","y"+128               ;133
 .byt "Ebony Ke","y"+128                ;134
 .byt "Glass Ke","y"+128                ;135
 .byt "Gold Ke","y"+128                 ;136
 .byt "Iron Ke","y"+128                 ;137
 .byt "Stone Ke","y"+128                ;138
 .byt "Leather Not","e"+128             ;139
 .byt "Confessio","n"+128               ;140
 .byt "Magical Ax","e"+128              ;141
 .byt "Magical Boot","s"+128            ;142
 .byt "Magical Arrow","s"+128           ;143
 .byt "ChainMai","l"+128                ;144
 .byt "Holy wate","r"+128               ;145
 .byt "Red Scrol","l"+128               ;146
 .byt "Green Scrol","l"+128             ;147
 .byt "Blue Scrol","l"+128              ;148
 .byt "White Scrol","l"+128             ;149
 .byt "Amber Potio","n"+128             ;150
 .byt "Turquoise Potio","n"+128         ;151
 .byt "Silver Potio","n"+128            ;152
 .byt "Magnolia Potio","n"+128          ;153
 .byt "Bag of Gol","d"+128              ;154
 .byt "Foo","d"+128                     ;155
 .byt "Foretelling Stone","s"+128       ;156
location_list
 .byt 4+128		          ;160 (Crannoth Island)
 .byt "Samson Islan","d"+128            ;161
 .byt "Tempus Islan","d"+128            ;162
 .byt "Erala","n"+128                   ;163
 .byt "Rhyde","r"+128                   ;164
 .byt "Treel","a"+128                   ;165
 .byt "Hampto","n"+128                  ;166
 .byt "Lankwel","l"+128                 ;167
 .byt "Ganesto","r"+128                 ;168
 .byt "Temple of Ango","r"+128          ;169
 .byt "Temple of Phnan","g"+128         ;170
 .byt "Hells Cryp","t"+128              ;171
 .byt "Lost Temple of the Ancient","s"+128	;172
 .byt "The Mouth of Equino","x"+128     ;173
 .byt "Silderons Mout","h"+128          ;174
 .byt 14+128                            ;175 (Crator)
 .byt "Spar","e"+128                    ;176
 .byt "Ruins of Agrechan","t"+128       ;177
 .byt "Dark Forest Lodg","e"+128        ;178
 .byt "Dark Fores","t"+128		;179
 .byt "Hallowed entranc","e"+128	;180
creature_list
 .byt "Unknow","n"+128                  ;192
 .byt "Wrait","h"+128                   ;193
 .byt "Guar","d"+128                    ;194
 .byt "Grey-Abbo","t"+128               ;195
 .byt "Spar","e"+128                  ;196
 .byt "Spar","e"+128                     ;197
 .byt "Prince-Regen","t"+128            ;198
 .byt "Lych","e"+128                    ;199
 .byt "Acolyt","e"+128                  ;200
 .byt "Nobl","e"+128                    ;201
 .byt "Black As","p"+128                ;202
 .byt "Archmag","e"+128                 ;203
 .byt "Old-Ma","n"+128                  ;204
 .byt "Prisone","r"+128                 ;205
 .byt "Woodsma","n"+128                 ;206
 .byt "Thu","g"+128                     ;207
 .byt "Ghos","t"+128                    ;208
 .byt "Skeleto","n"+128                 ;209
 .byt "Or","c"+128                      ;210
 .byt "Rogu","e"+128                    ;211
 .byt "Peasan","t"+128                  ;212
 .byt "Ser","f"+128                     ;213
 .byt "Slim","e"+128                    ;214
 .byt "Bartende","r"+128                ;215
 .byt "Prio","r"+128                    ;216
 .byt "Barto","n"+128		;217
 .byt "Dark Cleric","s"+128		;218
 .byt "assassi","n"+128		;219
common_list
 .byt "You're "				;224
 .byt "Their is no"," "+128			;225
 .byt " nearby","!"+128			;226
 .byt "ite","m"+128				;227
 .byt "creatur","e"+128			;228
 .byt "The"," "+128				;229
 .byt "Welcome to"," "+128			;230
 .byt "The flask contains a murky liqui","d"+128	;231
 .byt "The key looks well use","d"+128		;232
 .byt "The scroll is covered with arcane rune","s"+128	;233
 .byt "Which objec","t"+128  			;234
 .byt " do you want to"," "+128		;235
 .byt " of"," "+128				;236
 .byt "you"," "+128				;237


major_left_list
 ;First 6 are questions
 .byt "Who",235,"talk to?",255
 .byt 234,235,"@?",255		;Which Object do you want to [Action]?
 .byt "What",235,"say to ",229,"&?",255
 ;Next are immidiate responses
 .byt 225,227,226,255	;Their is no item nearby!
 .byt 225,228,226,255	;Their is no creature nearby!
 .byt 229,228," ignores you!",255 ;The [creatures name] ignores you!"
 .byt 229,"Gateway is Locked",255 ;The Gateway is locked"

major_right_list

major_main_list
;0
 .byt 230,"Times",236,"Lore!",255
;1 Keys on Keyring
 .byt "Seven keys",236,"various descriptions are bound together on an old rusty keyring.",255
;2 Dagger
 .byt 229,129," gleams with a deadly sparkle",255
;3 Ring of Power
 .byt 237,"notice some runes inscribed on ",229,"ring",255
;4 Chime
 .byt 229,"metal ",131," is cold to ",229,"touch",255
;5 Medallion
 .byt 229,132," has an aura",236,"power",255
;6 Bronze Key
 .byt 232,255
;7 Note
 .byt "It seems to be a royal document",255
;8 Confession
 .byt 237,"recognize ",229,140,236,229,219,255
;9 Magical Axe
 .byt 229,"* is",236,"fine dwarven craft",255
;10 Magical Boots
 .byt 229,"* are strangely light and supple",255
;11 Magical Arrows
 .byt 229,"* appear to quiver in their pouch",255
;12 Pile/ChainMail
 .byt 229,"* looks light but strong",255
;13 Holy water
 .byt 229,"* is in a fine crystal vial",255
;14 Any colour Scroll
 .byt 233,255
;15 Amber Potion
 .byt 231,255
;16 Bag of Gold
 .byt 229,"bag is laden with coins",255
;17 Food
 .byt 229,155," looks edible",255
;18 Urn
 .byt 229,"urn contains some glowing stones",255
Health_messages	;Health messages are also part of the bigger 'main' list
;19
 .byt 224,"Hungry",255
;20
 .byt 224,"Starving!",255
;21
 .byt "Taking some rations from your pack, ",237,"quell your hunger",255
overdose_messages
;22
 .byt 237,"cannot carry anymore *",255
;23
 .byt "",255
;24
;First Quest
 .byt "A burden rests heavily upon my heart, and so I humbly request your aid. "
 .byt "Two weeks past, a caravan was sent from ",164," bearing ",229,156,"."
 .byt " It was raided by brigands in ",229,179," and ",229,"Stones were lost. Please "
 .byt "seek out these brigands and regain ",229,164," for ",229,"kingdom. Will ",237,"accept this task?",255
;25
 .byt "Thank you. I foresee a true greatness in thee.",255
;26
 .byt "Hmm . I thought I had seen a greater light in thee.",255
;27
 .byt "You've done well. Accept this gold as gratitude. Go and visit ",229,"Regent now, for he has need"
 .byt 236,"your skills.",255
;28 Second Quest
 .byt "Welcome, I am Dariel, steward",236,229,"kingdom and I have heard about your valiant deed from ",229,216,"."
 .byt " I ask",236,237,"a favor for which I will offer a fine reward. I am in need",236,"a worthy soul to recover"
 .byt " ",229,128," which has fallen into ",229,"hands",236,229,"southern Warden, Bauldric. he will use it"
 .byt " against us in hopes",236,"seizing ",229,"kingdom to rule as he sees fit. Can I trust ",237,"to journey to "
 .byt 168," and recover ",229,128,"?",255
;29
 .byt "Please be secretive, and speed be with you.",255
;30
 .byt "Traitor!",255
;31
 .byt "Thankyou, receive this gold as thanks",255
;32 Woodsman meeting
 .byt "Welcome friend. Don't get many visitors out here, with all ",229,2,"s about.",255
;33
 .byt "A vicious lot they are. ",229,"road is barely safe to travel with their ",3," being so close.",255
;34
 .byt "Beware, ",229,3," lies north along a winding trail through ",229,"woods, north",236,229,"pool further"
 .byt " along this forest road.",255
;35 Opening Door in Ganestor
 .byt "On uttering ",229,"question, ",229,"door unbars. ",237,"travel along a short tunnel and arrive"
 .byt "at ",229,"Castle. On a shelf in ",229,"far corner",236,229,"store room ",237,"now stand in lyes"
 .byt "a small stone tablet. ",237,"take ",229,"tablet and return to ",229,"doorway. ",229,"door barrs",255
;36 Talk to the Tablet
 .byt "Seek ",229,219," on ",4,255
;37 Asking about crannoth island
 .byt 229,"island",236,"Crannoth lyes 5 miles off ",229,"coast",236,"Alboreth near ",229,179,". "
 .byt "But no ships venture near it's shores. A fellow called ",5," boasted he knew a ",23
 .byt " to get to ",4,".",255
;38 Asking about Gregor
 .byt 5," Lives at ",229,178," hidden deep to ",229,"west",236,229,2," en",3,"ment.",255
;39 Ask Gregor about secret way
 .byt "To ",229,"north west",236,229,179,", close to ",229,"coast lyes a ",24," hidden"
 .byt " from most ",228,"s eyes.",255
;40 Ask Gregor about Green Door
 .byt "I hold ",229,"only Green key known to open it. I will sell it to ",237,"for five thousand"
 .byt "gold pieces.",235,255
;41 Using Green key on Door
 .byt 229,"door lock gives a satisfying click, ",229,"hero descends down a long flight",236,"stairs into"
 .byt "a dimly lit corridor.",255
;42 Exiting at Hallowed entrance on Crannoth
 .byt "Ascending a flight",236,"stairs, ",237,"feel a sudden rush",236,"cool sea air, and soon ",237,"stand "
 .byt "aside a shore. Beside ",237,"is ",229,180," back to ",229,"mainland.",255
;43 Examining Confession
 .byt "It pains me, but ... years ago I was hired by Lord Dariel to kill a cruel lord. "
 .byt "From 100 paces, I nocked an arrow ... his death was quick. When I inspected ",229,"body, I "
 .byt "saw ",229,"face",236,"King Valwyn! He had with him an infant, his only child. I left ",229,"child "
 .byt "at ",229,"stoop",236,"a woodman's cabin. ",229,132,", I took merely to betray Dariel. Long since "
 .byt "have I abandoned my foul art. ",229,132," was",236,"no use to me so I sold it to a cleric. Take "
 .byt "this ",140," to ",6,", he may be able to protect ",229,"kingdom from Dariel.",255
;44 Asking about Heidric
 .byt "Ahhh, ",6," is a good fellow, often i used to visit his house in ",164," for guidance in "
 .byt "private matters.",255
;45 Giving confession to Heidric
 .byt "Thankyou, but time is short. In my travels I have learned that ",218
 .byt "are brewing an evil storm to scour ",229,"land. go to ",229,203," Irial for"
 .byt "guidance, north",236,229,7,".",255
;46 Question people about "Forest of Enchantment"
 .byt 229,7," lyes to ",229,"North-west",236,166,".",255
;47 Entering Archmage House
 .byt "As ",229,"door opens, ",237,"feel yourself rise and ",224," carried by an unknown force to a distant "
 .byt "place. ",203," Irial sits upon a stone seat before you..."
 .byt "There is yet hope for this kingdom through a forgotten child. I shall guide ",237,"to a great "
 .byt "future, but first ",237,"must perform a task to prove your worthiness. An evil ",8," infests "
 .byt 229,11,". Search out his destruction and return here.",255
;48 Asking about the Dessert ruins...
 .byt "Aha, i believe ",237,"refer to ",229,177,"... They lye at ",229,"centre",236,229,"dessert.",255
;49 Asking about the Lyche
 .byt "I heard ",229,8," can only be destroyed with ",145,".",255
;50 Asking about Holy Water
 .byt "My friend, Everyone knows only ",229,25," hold such a substance!",255
;51 Asking about Monks of hidden order
 .byt "They are reputed to occupy ",229,169," beyond ",229,"Eastern Lakes.",255
;52 Reading the note #1
 .byt "It seems ",229,"Note is blank.",255
;53 Returning to Archmage Irial
 .byt 237,"have done well. It is now time to reveal your true destiny. ",10," "
 .byt "in ",229,"mountain ",16,", lead by ",229,195,", have gained use "
 .byt "of ",229,"royal ",132,236,"Power. ",229,195," imprisoned me in this tower, "
 .byt "and I cannot leave this ethereal plane whilst he lives. They must be stopped "
 .byt "and ",229,132," regained. To enter ",229,"temple one needs an instrument that "
 .byt "may only be found within ",12,". Take this key so ",237,"may descend into its depths.",255
;54 Asking about "Hells Crypt"
 .byt "Legend has it that ",12," is ",229,"centre",236,229,13,".",255
;55 Asking about Underwurlde
 .byt "Don't go meddling in that dark place, My good friend ",217," decided at his peral to "
 .byt "Enter ",14,", ",229,"reputed entrance to ",13,". i have never seen him since!",255
;56 Asking about Crator
 .byt 14," Lyes due south",236,229,"old house on ",229,"road between ",163," and ",166,".",255
;57 Entering Crator with Stone Key
 .byt "It takes all your strength to open ",229,"old Stone door, and ",229,"stench",236,"rotting flesh "
 .byt "within almost topples you. Instinctively, ",237,"find ",229,139," to cover your mouth"
 .byt " and ",237,"enter...",255
;58 Reading the Leather note again
 .byt "Spidery runes now burn deep into ",229,"leather, gradually revealing a map showing a western "
 .byt "passage from ",12," to an place called ",174,".",255
;59 Asking about "Temple of Phnang"
 .byt "I've heard a mountain path east",236,166," leads to ",229,"old temple.",255
;60 Asking Barton about Magical Scroll
 .byt "Whilst on a crusade in ",13,", i found it hidden in an old chest. I was chased by ",229,"devil"
 .byt " himself for stealing his posession, but managed to find time to work out how to use it."
 .byt 229,"scroll can transport ",237,"around ",229,"kingdom to a number",236,"well known places and a number"
 .byt "of ",26," i'd never heard of. ",229,"runes mention it may be used up to 10 times. I used it three"
 .byt " or four times to lose ",229,"Devil, ",237,"can have it for 500 goldies, if ",237,"want?",255
;61 Ask about other places
 .byt "It mentions ",229,16," and ",229,"Keep",236,229,"Keys? and an isle i'd never heard",236,"called "
 .byt "Samson. Look, i can see ",224," an honest stranger, i can let ",237,"have it for 400 goldies?",255
;62 Attempting to kill Barton (2 hit health)
 .byt 237,"servant",236,229,"Devil, i thought i saw a better person in you...   "
 .byt 15," removes ",229,"scroll from inside his tunic and disappears...",255
;63 Asking people about Barton
 .byt "Yes, i hear tell he was last seen in (",255
;64 Collecting last key from keep of the keys
 .byt "As ",237,"drop ",229,"last",236,229,"keys from ",229,"keep into your pouch, a wisp",236,"smoke rises from it."
 .byt "On further inspection, ",229,"keys are now joined by an old iron keyring with no clear clasp.",255
;65 Using Sphere on Grey Abbot
 .byt 237,"hurl ",229,"sphere at ",229,195,". It shatters, releasing a frenzy",236,"wisps which engulf"
 .byt " ",229,"screaming Abbot. ",229,"mist slowly dissipates, revealing a ",132," upon a pile",236,"ash.",255
;66 Returning to the Archmage
 .byt 237,"have done well, very well, ",237,"have freed me. However, ",229,"centrepiece",236,"our kingdom"
 .byt "is still absent. ",229,18," was stolen by a ",211," whilst i was being transported"
 .byt "to this place. ",229,"ring will return order to this land whoever wears it upon their finger."
 .byt 229,"ring cannot be stolen or bought. Only ",229,"one who finds ",229,"ring can claim its power.",255
;67 Asking about ring
 .byt "Last i heard, ",229,8," knew where it was.",255
;68 Using the ebony key on the White door
 .byt 229,"door opens easily, and ",237,"enter into ",229,"bowels",236,229,"earth once more...",255
;69 Using the Red Scroll
 .byt "As ",237,"look upon ",229,"scroll, it's runes burn a deeper red than ",229,"scroll itself..."
 .byt " Cool Flames now engulf you, and for an instance, ",237,"feel ",224," somewhere else."
 .byt "Gradually ",229,"flames diminish, and ",237,"feel strangely lighter than before.",255
;70 slip on the ring
 .byt "As ",237,"hold ",229,"old iron ring aloft, it rolls forward all",236,"its own accord and onto your"
 .byt " middle finger. A strange glow stirs behind its rusty surface, and on touching it, ",229,"rust "
 .byt "dissolves, revealing a golden ",18,"... )",255

;71 Rumours
 .byt "I hear there is a dragon near ",229,"northern mountains.",255
;72
 .byt "A dark fog is forming in ",229,"northeast.",255
;73
 .byt "A wild dust storm ran through ",229,"desert ",229,"other day.",255
;74
 .byt "A sorcery tower lies over a bridge north",236,229,"desert.",255
;75
 .byt "I've heard tell",236,"magical boots in ",165,".",255
;76
 .byt "A man from ",167," boasted he knew about a magical axe.",255
;77
 .byt "A man from Crannoth Island is reputed to hold a scroll with the"
 .byt " power to transport ",237,"around ",229,"kingdom.",255




action_list
 .byt "examin","e"+128
 .byt "tak","e"+128
 .byt "dro","p"+128
 .byt "giv","e"+128
 .byt "us","e"+128


tod_messages
 .byt "Morning has broken"
 .byt "It is midday already"
 .byt "Night has fallen"

 .byt "The $ Says,"
 .byt "Welcome to Times of Lore!"

