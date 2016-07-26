;game_menu_interface
;locate_neighbouring_creatures
;Fills creature_list, X contains last creature index(255=None, xmax is 2)
;locate_neighbouring_objects
;Fills object_list, Y contains last object index(255=None)
;locate_location
;A contains location Index...
;0 Location Of No Importance (LONI)
;1-8 Inns
;  1 Eralan	Below Dark Forest		Frothing Slosh Tavern
;  2 Ganestor	Bottom Right		Willow Arms
;  3 Lankwell	Bottom Left, Mainland	Naughty Widow Tavern.
;  4 -              Right of Crator               Last Hope Inn.
;  5 Rhyder	Right of Dark Forest	Sleepy Friar Inn.
;  6 Treela         Enchanted Forest		Green Oak Tavern.
;  7 Hampton	Below Enchanted Forest	little Tavern
;  8 Tempus	Biggest Island                Shorevale Arms
;  9 Crannath       NW Island			?
;20-19 Underwurlde Links
; 20 Mouth of Equinox(NW Alboreth)
; 21 Crannath Deep(Crannath)
; 22 Samsons Pit(Samson)
; 23 Crator(W Alboreth)
; 24 Silderons Mouth(Tempus)
; 25 Hells Crypt(Underwurlde)
; 26 Ruins of Agrechant(Centre of Dessert, Alboreth)
; 27 Lost Temple of the Ancients(E Alboreth)
; 28 Hampton Gorge(E Alboreth)
; 29 Temple of Phnang(NE Alboreth)
; 30 ?
; 31 ?


;Player Selects Menu
;passed:-
;Carry Clear
;creature_list and X contains end of index
;Object_list and Y contains end of index
;Location (See above) in A containing 0-31
game2menu_voluntary
	jsr locate_location
	pha
	jsr locate_neighbouring_creatures
	ldy object_list_index	;object finding if handled when plotting objects
	pla
	clc	;indicate voluntary menu
	jsr menu_vector
	CLD
	rts
;Game Selects Menu code
;Carry Set
;creature_list and X contains end of index
;Object_list and Y contains end of index
;A will contain one of the following...
;00 Hero Dies
;01 Hero meets someone who speaks to him first
;02 Hero attempts to pass locked Door or gate
;03 Hero picks up object using smartkey
;04 Maybe more later...
game2menu_involuntary
	pha
	jsr locate_neighbouring_creatures
	ldy object_list_index	;object finding if handled when plotting objects
	pla
	sec	;Indicate involuntary menu
	jsr menu_vector	;when finished, jede routine should RTS
	CLD
	rts


;Menu Background tasks
; Time of Day, a cyclic time of day clock, reporting...
;  Night has fallen 	(around 21:00)
;  It is morning		(around 05:00)
;  It is midday		(around 12:00)
; Hunger Report, reporting Health and Nourishment of Hero (Every half day)
;  You are hungry, taking rations from your pack...





;Result:-
;Fills creature_list, X contains last creature index
locate_neighbouring_creatures	;only neighbours immidiately next to hero
	lda inside_building_flag
	bne
	ldx #00
	stx sprite_list
	stx sprite_list+1
	stx sprite_list+2
	sta neighbour_list_index
	ldy #24
	sty temp_03
lnc_02	ldx neighbour_offset,y
	ldy screen_buffer+19+7*43,x
	cpy #114
	bcs lnc_01
	cpy #96
	bcc lnc_01
	ldx sprite_by_char-96,y
	inc sprite_list,x
	ldy temp_03
lnc_01	dey
	bpl lnc_02
	ldx #255
	ldy #02
lnc_04	lda sprite_list,y
	beq lnc_03
	inx
	lda creature_identity,y
	sta creature_list,x
lnc_03	dey
	bpl lnc_04
	rts

sprite_list
 .byt 0,0,0
creature_list
 .byt 0,0,0
sprite_by_char
 .byt 0,0,0,0,0,0
 .byt 1,1,1,1,1,1
 .byt 2,2,2,2,2,2

neighbour_offset
 .byt 0,1,2,3,4
 .byt 43,44,45,46,47
 .byt 86,87,88,89,90
 .byt 129,130,131,132,133
 .byt 172,173,174,175,176

;Result:-
;A contains location Index
;
;Notes...
;When the player hits collision types 3 or 4, this indicates that the hero
;is attempting to enter an inn (4) or building/gate (3).
;The system locates the hero by X/Y in map, and is then able to locate
;byte index
;


;X==MMMM MMMTTTBB
;Y==MMM MMMTTTBB
locate_location
	lda hero_xl	;Fetch hero x in map
	sta temp_01
	lda hero_xh
	asl temp_01
	rol
	asl temp_01
	rol
	asl temp_01
	rol
	sta temp_01	;Holds X
	lda hero_yl	;Fetch hero y in map
	sta temp_02
	lda hero_yh
	asl temp_02
	rol
	asl temp_02
	rol
	asl temp_02
	rol
	ldx #31
lloc_01	cmp location_y,x
	bne lloc_03
	ldy location_x,x
	cpy temp_01
	beq lloc_02
lloc_03	dex
	bpl lloc_01
	inx
lloc_02	txa
	rts

location_x	(32)
 .byt 31	;01 Frothing Slosh Tavern (Eralan)
 .byt 120	;02 Willow Arms (Treela)
 .byt 42	;03 Naughty Widow Tavern (Lankwell)
 .byt 74	;04 Last Hope Inn (N of Dessert)
 .byt 78	;05 Sleepy Friar Inn
 .byt 92	;06 Green Oak Tavern
 .byt 110	;07 little Tavern
 .byt 26	;08 Shorevale Arms
 .byt 3	;09 Crannoth Inn
 .byt 0	;10
 .byt 0	;11
 .byt 19	;12 Mouth of Equinox
 .byt 3	;13 Crannoth Deep
 .byt 6	;14 Samsons Pit
 .byt 56	;15 Crator(W Alboreth)
 .byt 10	;16 Silderons Mouth(Tempus)
 .byt 0	;17
 .byt 89	;18 Ruins of Agrechant
 .byt 0	;19
 .byt 112	;20 Hampton Gorge
 .byt 0	;21
 .byt 0	;22
 .byt 0	;23
 .byt 2	;24 Crannoth Shore Hut
 .byt 27	;25 The Dark Forest Lodge
 .byt 4	;26 Samson Lodge
 .byt 52	;27 Assassins Hut
 .byt 42	;28 Eralan Castle
 .byt 121	;29 Temple of Angor
 .byt 117	;30 Ganestor Castle
 .byt 0	;31
location_y	(32)
 .byt 39	;01 Frothing Slosh Tavern
 .byt 82	;02 Willow Arms
 .byt 76	;03 Naughty Widow Tavern
 .byt 57	;04 Last Hope Inn.
 .byt 7	;05 Sleepy Friar Inn
 .byt 40	;06 Green Oak Tavern.
 .byt 58	;07 little Tavern
 .byt 59	;08 Shorevale Arms
 .byt 4	;09 Crannoth Inn
 .byt 0	;10
 .byt 0	;11
 .byt 4   ;12 Mouth of Equinox
 .byt 8	;13 Crannoth Deep
 .byt 32	;14 Samsons Pit
 .byt 60	;15 Crator(W Alboreth)
 .byt 50	;16 Silderons Mouth(Tempus)
 .byt 0	;17
 .byt 66	;18 Ruins of Agrechant
 .byt 0	;19
 .byt 53	;20 Hampton Gorge
 .byt 0	;21
 .byt 0	;22
 .byt 0	;23
 .byt 11	;24 Crannoth Shore Hut
 .byt 15	;25 The Dark Forest Lodge
 .byt 35	;26 Samson Lodge
 .byt 87	;27 Assassins Hut
 .byt 34	;28 Eralan Castle
 .byt 24	;29 Temple of Angor
 .byt 79	;30 Ganestor Castle
 .byt 0	;31
;0 Location Of No Importance (LONI)
;1-8 Inns
;  1 Eralan	Below Dark Forest		Frothing Slosh Tavern
;  2 Ganestor	Bottom Right		Willow Arms
;  3 Lankwell	Bottom Left, Mainland	Naughty Widow Tavern
;  4 -              Right of Crator               Last Hope Inn
;  5 Rhyder	Right of Dark Forest	Sleepy Friar Inn
;  6 Treela         Enchanted Forest		Green Oak Tavern
;  7 Hampton	Below Enchanted Forest	little Tavern
;  8 Tempus	Biggest Island                Shorevale Arms
;  9 Crannath       NW Island			?
; 10 ?
; 11 ?
;12-23 Underwurlde Links
; 12 Mouth of Equinox(NW Alboreth)
; 13 Crannath Deep(Crannath)
; 14 Samsons Pit(Samson)
; 15 Crator(W Alboreth)
; 16 Silderons Mouth(Tempus)
; 17 Hells Crypt(Underwurlde)                              ?
; 18 Ruins of Agrechant(Centre of Dessert, Alboreth)
; 19 Lost Temple of the Ancients(E Alboreth)               ?
; 20 Hampton Gorge(E Alboreth)
; 21 Temple of Phnang(NE Alboreth)
; 22 Hallowed Portal
; 23 ?
;24-31 Other Important Locations
; 24 Crannoth Shore Hut
; 25 The Dark Forest Lodge
; 26 Samson Lodge
; 27 Assassins Hut
; 28 Eralan Castle
; 29 Temple of Angor
; 30 Ganestor Castle
; 31


;character assignment
;32-95	BG
;96-101	Sprite 0
;102-107	Sprite 1
;108-113	Sprite 2
;114-122	Hero
;123-125	Object dropped or Special Object
;126-127	Weapon Fire


