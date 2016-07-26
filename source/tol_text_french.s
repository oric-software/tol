;TOL-Text - French Version (With added comments)
;All Text used in TOL Game
;All text within the game is handled with code in text_window_handler.s and
;option_window_handler.s

;Q How do we know that a particular location is an Inn?
;A The TSMAP entry will be 14.


// eog,keywords,ascii,creatures,place,object,passage,questtext,caption,sentinels
// RANGE		CATEGORY		QUANTITY	Notes
// 000-000 	eog(0)		1	End Of Game Flag (?)
// 001-031	keywords		31	Links
// 032-090	ascii Codes	58	Letters
// 091-110	Region Names	19	Names of places visited
// 111-117	chitchats		7	Communications with Creatures
// 118-122	intonements	5	Hints for Main Quest
// 123-141	creatures		18	Creature names and posessions
// 142-175	places		33	Places
// 176-204	objects		28	Items found in game
// 205-253	texts		48	General Text Messages
// 254-255	Sentinels		2	End of Text or Field seperators
#define	spare8		$AB37

// This table breaks down any supplied 0-255 code into an index that points to the
// Text Category (0-10) as above.
// Whilst their are many more code types, categories group common offsets together.
code_breakdown
 .byt 0,123,142,176
// This table defines the offset of the category to displayable Text when referred to in
// embedded codes.
// This table is used exclusively by the Option handler, so that any optionlist text can
// be easily located.
// 0   - Offset 0
// 3   - Offset 3
// 254 - Text starts beyond byte 254
offset_type
 .byt 0,254,3,0
// These tables hold direct reference to the text message number.
text_vector_lo
 .byt 0	;0

 .byt <keyword1,<keyword2,<keyword3,<keyword4,<keyword5,<keyword6,<keyword7	;1-31
 .byt <keyword8,<keyword9,<keyword10,<keyword11,<keyword12,<keyword13,<keyword14,<keyword15
 .byt <keyword16,<keyword17,<keyword18,<keyword19,<keyword20,<keyword21,<keyword22,<keyword23
 .byt <keyword24,<keyword25,<keyword26,<keyword27,<keyword28,<keyword29,<keyword30,<keyword31

 .byt <spare8		;32 _
 .byt <tolwinchs+6*36         ;33 !
 .byt <spare8                 ;34 Speech marks
 .byt <spare8                 ;35 #
 .byt <spare8                 ;36 $
 .byt <spare8                 ;37 %
 .byt <tolwinchs+6*37         ;38 &
 .byt <tolwinchs+6*39         ;39 '
 .byt <spare8         	;40 (
 .byt <spare8         	;41 )
 .byt <spare8                 ;42 *
 .byt <tolwinchs+6*43         ;43 +
 .byt <tolwinchs+6*40         ;44 ,
 .byt <tolwinchs+6*38         ;45 -
 .byt <tolwinchs+6*41         ;46 .
 .byt <spare8                 ;47 /
 .byt <tolwinchs+6*26         ;48 0
 .byt <tolwinchs+6*27         ;49 1
 .byt <tolwinchs+6*28         ;50 2
 .byt <tolwinchs+6*29         ;51 3
 .byt <tolwinchs+6*30         ;52 4
 .byt <tolwinchs+6*31         ;53 5
 .byt <tolwinchs+6*32         ;54 6
 .byt <tolwinchs+6*33         ;55 7
 .byt <tolwinchs+6*34         ;56 8
 .byt <tolwinchs+6*35         ;57 9
 .byt <spare8                 ;58 :
 .byt <spare8                 ;59 ;
 .byt <spare8                 ;60 <
 .byt <spare8                 ;61 =
 .byt <spare8         	;62 >
 .byt <tolwinchs+6*42         ;63 ?
 .byt <spare8                 ;64 @
 .byt <tolwinchs              ;65 A
 .byt <tolwinchs+6*1          ;66 B
 .byt <tolwinchs+6*2          ;67 C
 .byt <tolwinchs+6*3          ;68 D
 .byt <tolwinchs+6*4          ;69 E
 .byt <tolwinchs+6*5          ;70 F
 .byt <tolwinchs+6*6          ;71 G
 .byt <tolwinchs+6*7          ;72 H
 .byt <tolwinchs+6*8          ;73 I
 .byt <tolwinchs+6*9          ;74 J
 .byt <tolwinchs+6*10         ;75 K
 .byt <tolwinchs+6*11         ;76 L
 .byt <tolwinchs+6*12         ;77 M
 .byt <tolwinchs+6*13         ;78 N
 .byt <tolwinchs+6*14         ;79 O
 .byt <tolwinchs+6*15         ;80 P
 .byt <tolwinchs+6*16         ;81 Q
 .byt <tolwinchs+6*17         ;82 R
 .byt <tolwinchs+6*18         ;83 S
 .byt <tolwinchs+6*19         ;84 T
 .byt <tolwinchs+6*20         ;85 U
 .byt <tolwinchs+6*21         ;86 V
 .byt <tolwinchs+6*22         ;87 W
 .byt <tolwinchs+6*23         ;88 X
 .byt <tolwinchs+6*24         ;89 Y
 .byt <tolwinchs+6*25         ;90 Z

 .byt <region_name91          ;91
 .byt <region_name92          ;92
 .byt <region_name93          ;93
 .byt <region_name94          ;94
 .byt <region_name95          ;95
 .byt <region_name96          ;96
 .byt <region_name97          ;97
 .byt <region_name98          ;98
 .byt <region_name99          ;99
 .byt <region_name100         ;100
 .byt <region_name101         ;101
 .byt <region_name102         ;102
 .byt <region_name103         ;103
 .byt <region_name104         ;104
 .byt <region_name105         ;105
 .byt <region_name106         ;106
 .byt <region_name107         ;107
 .byt <region_name108         ;108
 .byt <region_name109         ;109
 .byt <region_name110         ;110
 .byt <chitchat_interaction111
 .byt <chitchat_interaction112
 .byt <chitchat_interaction113
 .byt <chitchat_interaction114
 .byt <chitchat_interaction115
 .byt <chitchat_interaction116
 .byt <chitchat_interaction117

 .byt <progressive_stone_intonement118,<progressive_stone_intonement119
 .byt <progressive_stone_intonement120,<progressive_stone_intonement121
 .byt <progressive_stone_intonement122

 .byt <creature123,<creature124,<creature125,<creature126,<creature127	;123-143
 .byt <creature128,<creature129,<creature130,<creature131,<creature132
 .byt <creature133,<creature134,<creature135,<creature136,<creature137
 .byt <creature138,<creature139,<creature140,<creature141

 .byt <place142,<place143
 .byt <place144,<place145,<place146,<place147,<place148,<place149,<place150,<place151	;144-175
 .byt <place152,<place153,<place154,<place155,<place156,<place157,<place158,<place159
 .byt <place160,<place161,<place162,<place163,<place164,<place165,<place166,<place167
 .byt <place168,<place169,<place170,<place171,<place172,<place173,<place174,<place175

 .byt <object176,<object177,<object178,<object179,<object180,<object181,<object182,<object183	;176-204
 .byt <object184,<object185,<object186,<object187,<object188,<object189,<object190,<object191
 .byt <object192,<object193,<object194,<object195,<object196,<object197,<object198,<object199
 .byt <object200,<object201,<object202,<object203,<object204

 .byt <text205
 .byt <text206
 .byt <text207
 .byt <text208
 .byt <text209
 .byt <text210
 .byt <text211
 .byt <text212,<text213,<text214,<text215,<text216,<text217,<text218,<text219,<text220
 .byt <text221,<text222,<text223,<text224,<text225,<text226,<text227,<text228,<text229,<text230
 .byt <text231,<text232,<text233,<text234,<text235,<text236,<text237,<text238,<text239,<text240
 .byt <text241,<text242,<text243,<text244,<text245,<text246,<text247,<text248,<text249,<text250
 .byt <text251,<text252,<text253

text_vector_hi
 .byt 0	;0

 .byt >keyword1,>keyword2,>keyword3,>keyword4,>keyword5,>keyword6,>keyword7	;1-31
 .byt >keyword8,>keyword9,>keyword10,>keyword11,>keyword12,>keyword13,>keyword14,>keyword15
 .byt >keyword16,>keyword17,>keyword18,>keyword19,>keyword20,>keyword21,>keyword22,>keyword23
 .byt >keyword24,>keyword25,>keyword26,>keyword27,>keyword28,>keyword29,>keyword30,>keyword31

 .byt >spare8		;32 _
 .byt >tolwinchs+6*36         ;33 !
 .byt >spare8                 ;34 Speech marks
 .byt >spare8                 ;35 #
 .byt >spare8                 ;36 $
 .byt >spare8                 ;37 %
 .byt >tolwinchs+6*37         ;38 &
 .byt >tolwinchs+6*39         ;39 '
 .byt >spare8         	;40 (
 .byt >spare8         	;41 )
 .byt >spare8                 ;42 *
 .byt >tolwinchs+6*43         ;43 +
 .byt >tolwinchs+6*40         ;44 ,
 .byt >tolwinchs+6*38         ;45 -
 .byt >tolwinchs+6*41         ;46 .
 .byt >spare8                 ;47 /
 .byt >tolwinchs+6*26         ;48 0
 .byt >tolwinchs+6*27         ;49 1
 .byt >tolwinchs+6*28         ;50 2
 .byt >tolwinchs+6*29         ;51 3
 .byt >tolwinchs+6*30         ;52 4
 .byt >tolwinchs+6*31         ;53 5
 .byt >tolwinchs+6*32         ;54 6
 .byt >tolwinchs+6*33         ;55 7
 .byt >tolwinchs+6*34         ;56 8
 .byt >tolwinchs+6*35         ;57 9
 .byt >spare8                 ;58 :
 .byt >spare8                 ;59 ;
 .byt >spare8                 ;60 >
 .byt >spare8                 ;61 =
 .byt >spare8         	;62 >
 .byt >tolwinchs+6*42         ;63 ?
 .byt >spare8                 ;64 @
 .byt >tolwinchs              ;65 A
 .byt >tolwinchs+6*1          ;66 B
 .byt >tolwinchs+6*2          ;67 C
 .byt >tolwinchs+6*3          ;68 D
 .byt >tolwinchs+6*4          ;69 E
 .byt >tolwinchs+6*5          ;70 F
 .byt >tolwinchs+6*6          ;71 G
 .byt >tolwinchs+6*7          ;72 H
 .byt >tolwinchs+6*8          ;73 I
 .byt >tolwinchs+6*9          ;74 J
 .byt >tolwinchs+6*10         ;75 K
 .byt >tolwinchs+6*11         ;76 L
 .byt >tolwinchs+6*12         ;77 M
 .byt >tolwinchs+6*13         ;78 N
 .byt >tolwinchs+6*14         ;79 O
 .byt >tolwinchs+6*15         ;80 P
 .byt >tolwinchs+6*16         ;81 Q
 .byt >tolwinchs+6*17         ;82 R
 .byt >tolwinchs+6*18         ;83 S
 .byt >tolwinchs+6*19         ;84 T
 .byt >tolwinchs+6*20         ;85 U
 .byt >tolwinchs+6*21         ;86 V
 .byt >tolwinchs+6*22         ;87 W
 .byt >tolwinchs+6*23         ;88 X
 .byt >tolwinchs+6*24         ;89 Y
 .byt >tolwinchs+6*25         ;90 Z
 .byt >region_name91          ;91
 .byt >region_name92          ;92
 .byt >region_name93          ;93
 .byt >region_name94          ;94
 .byt >region_name95          ;95
 .byt >region_name96          ;96
 .byt >region_name97          ;97
 .byt >region_name98          ;98
 .byt >region_name99          ;99
 .byt >region_name100         ;100
 .byt >region_name101         ;101
 .byt >region_name102         ;102
 .byt >region_name103         ;103
 .byt >region_name104         ;104
 .byt >region_name105         ;105
 .byt >region_name106         ;106
 .byt >region_name107         ;107
 .byt >region_name108         ;108
 .byt >region_name109         ;109
 .byt >region_name110         ;110
 .byt >chitchat_interaction111
 .byt >chitchat_interaction112
 .byt >chitchat_interaction113
 .byt >chitchat_interaction114
 .byt >chitchat_interaction115
 .byt >chitchat_interaction116
 .byt >chitchat_interaction117

 .byt >progressive_stone_intonement118,>progressive_stone_intonement119
 .byt >progressive_stone_intonement120,>progressive_stone_intonement121
 .byt >progressive_stone_intonement122

 .byt >creature123,>creature124,>creature125,>creature126,>creature127	;123-143
 .byt >creature128,>creature129,>creature130,>creature131,>creature132
 .byt >creature133,>creature134,>creature135,>creature136,>creature137
 .byt >creature138,>creature139,>creature140,>creature141

 .byt >place142,>place143
 .byt >place144,>place145,>place146,>place147,>place148,>place149,>place150,>place151	;144-175
 .byt >place152,>place153,>place154,>place155,>place156,>place157,>place158,>place159
 .byt >place160,>place161,>place162,>place163,>place164,>place165,>place166,>place167
 .byt >place168,>place169,>place170,>place171,>place172,>place173,>place174,>place175

 .byt >object176,>object177,>object178,>object179,>object180,>object181,>object182,>object183	;176-204
 .byt >object184,>object185,>object186,>object187,>object188,>object189,>object190,>object191
 .byt >object192,>object193,>object194,>object195,>object196,>object197,>object198,>object199
 .byt >object200,>object201,>object202,>object203,>object204

 .byt >text205
 .byt >text206
 .byt >text207
 .byt >text208
 .byt >text209
 .byt >text210
 .byt >text211
 .byt >text212,>text213,>text214,>text215,>text216,>text217,>text218,>text219,>text220
 .byt >text221,>text222,>text223,>text224,>text225,>text226,>text227,>text228,>text229,>text230
 .byt >text231,>text232,>text233,>text234,>text235,>text236,>text237,>text238,>text239,>text240
 .byt >text241,>text242,>text243,>text244,>text245,>text246,>text247,>text248,>text249,>text250
 .byt >text251,>text252,>text253


// All Text in game...
// Text in game is always fed to the text-window and may be embedded into other text messages.
// This enables the user to embed keywords into any text and also allows for a much more
// compact format. All Messages must not exceed 108 characters when expanded.

// The messages have been split into categories that are used by various routines in the
// TOL system.

// Each category follows a unique format, usually consisting of a header followed by text
// fields.
// Each category also occupies a specific range of numbers.
// Text fields are always seperated with 254 and terminated (End of data) with 255.

// keywords (19 of 31) (1-31)
// Keywords are key words learnt by the hero throughout the game.
// Each keyword may be no longer that 10 characters, upper case only.
// They accumulate in the posessed_keyword buffer from creatures response text as the hero
// expands his knowledge of TOL.

// Every keyword may be enquired about in the Questions option (whilst speaking to a creature)
// The particular response may be dependant on the creature being asked, so a creature field
// is provided and duplicate keywords are permitted (See Silderon)

;name(Option Text),254,creature(0 if not creature specific),Response Text,255
;For options, first field up to 254
;Laurent- First field limited to ucase, 10 characters
;Laurent- Next text field contains embedded names (104 char limit)
keyword1
 .byt "STONES",254,130,"I BELIEVE",2,"POSESSES THEM",255
keyword2
 .byt "MOGROD",254,0,"HE RESIDES AT THE",3,"IN THE DARK FOREST NORTH OF HERE",255
keyword3
 .byt "CAMP",254,0,"A PATH TO IT BEGINS NORTH OF THE FOREST SPRING",255
keyword4
 .byt "MIDRATH",254,0,"I KNOW MIDRATH. HE LIVES IN",13,255
keyword5
 .byt "MADREGATH",254,0,"MADREGATH IS THE SKELETON KING AND RESIDES BELOW "
 .byt "THE RUINS OF",14,255
keyword6
 .byt "SILDERON",254,0,"SILDERON'S MOUTH IS A FABLED ENTRANCE TO THE UNDERWURLDE AND IS SITUATED "
 .byt "ON THE ISLE OF",15,255
keyword7
 .byt "CALIBOR",254,0,"CALIBOR IS A WEALTHY MERCHANT AND KEEPER OF THE KEYS WHO LIVES ON",8
 .byt "ISLE",255
keyword8
 .byt "CRANNOTH",254,0,"AN OLD ALBORETH RHYME TELLS OF AN UNDERGROUND PASSAGE TO IT CALLED "
 .byt "THE MOUTH OF",9,255
keyword9
 .byt "EQUINOX",254,0,"THE MOUTH OF EQUINOX LYES DEEP IN THE FAR NORTH WEST OF THE DARK FOREST",255
keyword10	;Asking Tempus Innkeeper about
 .byt "SILDERON",254,131,"AN ARCHEVIST CALLED",11,"CLAIMED THE OTHER DAY HE HAD FOUND A WAY IN",255
keyword11	;Asking Peasant in Tempus Inn about
 .byt "CRODOR",254,136,"HE LIVES IN A LODGE JUST EAST OF",6," MOUTH",255
keyword12	;Asking Crodor
;Maybe use chitchat interaction instead?
 .byt "SILDERON",254,139,"I CAN GET YOU IN BUT IT'LL COST YOU",$05,$00,"GOLD?"
 .byt "THANKYOU, NOW FORGE A PASSAGE YONDER...",16,254,"OK, SUIT YOURSELF",255
keyword13
 .byt "AGRE LODGE",254,0,"IT LYES IN THE DESSERT, SOUTHEAST OF",17,255
keyword14
 .byt "AGRECHANT",254,0,"YE OLD DESSERT RUINS LYE DIRECTLY WEST ON THE ROAD OUT OF GANESTOR",255
keyword15
 .byt "TEMPUS",254,0,"THE LARGEST ISLAND OFFSHORE",255
keyword16
keyword17
 .byt "CRATOR",254,0,"I DO N0T KNOW, THOUGH THEIR IS A 'CRATOR WALD', SOUTH OF ERALAN",255
keyword18
 .byt "MEDALLION",254,0,"YE",18,"BESTOWS THE SANCTITY OF POWER OVER THINE KINGDOM",255
keyword19
 .byt "NESTEROTH",254,0,"REPUTED TO RAISE A BRIDGE TO THE",23,"!",255
keyword20
 .byt "ANGOR",254,0,"A HIGHLY GUARDED TEMPLE BEYOND THE EASTERN MOST LAKE",255
keyword21
 .byt "CROSS",254,0,"THE CROSS IS REPUTED TO RESIDE ON THE",23,255
keyword22
 .byt "HOLY WATER",254,0,"THE",24,"IS REKNOWNED FOR KEEPING IT",255
keyword23
 .byt "INNER ISLE",254,0,"SOUTH OF RHYDER AND APPARENTLY SWARMING WITH BLACK ASPS",255
keyword24
 .byt "DARK PRIOR",254,0,"I KNOW ONE WHO LIVES IN RHYDER",255
keyword25
 .byt "PHNANG",254,0,"PHNANG PROVINCE LYES HIGH IN THE MOUNTAINS OVERLOOKING ALBORETH",255
keyword26
 .byt "SAMSON",254,0,"SAMSON IS A DISTANT ISLAND",255
keyword27
keyword28
keyword29
keyword30
keyword31

;ASCII (32-90)
;ASCII codes between 32 and 90 are reserved for Text displayed in the message.
;In addition, particular symbols such as *,$,% and & trigger the routine to display
;current attributes such as hero gold, current location, held weapon, etc.

;Region Names (91 - 110)
;The Big Map is split into Regions. Their are 16 Regions accross by 8 regions down.
;Each region has a name but to prevent duplication, refer to region_name_pointer table
;which points to the name associated to the region the hero is currently in.
;Format - RegionName,255
region_name91
 .byt "GANESTOR",255
region_name92
 .byt "EYE OF SILDERON",255
region_name93
 .byt "TEMPUS ISLAND",255
region_name94
 .byt "CRANNOTH ISLE",255
region_name95
 .byt "EQUINOX",255
region_name96
 .byt "DARK FOREST",255
region_name97
 .byt "RHYDER",255
region_name98
 .byt "THE MERES",255
region_name99
 .byt "TEMPLEMEAD",255
region_name100
 .byt "ERALAN",255
region_name101
 .byt "DESSERT",255
region_name102
 .byt "ENCHANTED FOREST",255
region_name103
 .byt "SLEEPY RIVER",255
region_name104
 .byt "TREELA",255
region_name105
 .byt "TEMPLE ANGOR",255
region_name106
 .byt "SAMSON ISLAND",255
region_name107
 .byt "LANKWELL",255
region_name108
 .byt "CRATOR WALD",255
region_name109
 .byt "HAMPTON",255
region_name110
 .byt "PHNANG PROVINCE",255

;Chitchat_interaction
;The rules that define how a creature responds can depend on the Hero posessing certain
;Objects.
;The Creatures themselves may also posess objects (As defined in the Creature entry).
;Creatures that posess objects and who are willing to sell them will question the hero
;on contact (Chitchat_interaction main passage) with a question mark.
;The price of the object may be defined in the Object entry. If no price is given, the object
;will be free (Zero Gold).
;On purchasing an object, the object will be overwritten with a 0 in the creatures posession
;list.


;As you pass through the final hallowed gate in the Ruins of Agrechant, a large crowd
;swells before you, you are carried aloft to cheers and applause...

// keyword,creature(0 for any),posession/s required,254,Response text,255

;creature,posession/s required(176-204) or 0(First contact) or 1,254,Response text
;(1 is set after first contact is had, as marker)
chitchat_interaction111	;Talking to Prior in Eralan Tavern
 .byt 130,0,254,"TWO DAYS BACK, A CARAVAN CARRYING THE FORETELLING",1,"WAS PLUNDERED "
 .byt "BY A BAND OF ORCS.",255
chitchat_interaction112	;Talking to Head Orc in Camp Lodge
 .byt 131,254,"I AM MOGROD. I HAVE A NUMBER OF ARTIFACTS"
 .byt " IN MY POSESSION, DO YOU WISH TO BUY SOMETHING?",255
chitchat_interaction113	;Talking to Calibor on Crannoth Isle, who is Merchant
 .byt 132,254,"I AM CALIBOR, THE BEST MERCHANT IN THE WHOLE OF ALBORETH. CAN I INTEREST YOU IN ANYTHING?",255
chitchat_interaction114	;Barton Selling Boots
 .byt 135,254,"WELL... I HAVE A PAIR OF MAGICAL BOOTS FOR SALE, THEY'LL MAKE QUICK WORK OF WALKING, INTERESTED SIR?",255
chitchat_interaction115	;Bombadil selling Wand of Nestaroth
 .byt 134,254,"WOULD YOU BE INTERESTED IN THE WAND OF NESTAROTH?",255
chitchat_interaction116	;Dark Prior, Rhyder
 .byt 136,254,"YOU SEEK HOLY WATER, DON'T YOU?",255
chitchat_interaction117	;Wickerman, The Wickers, Lankwell
 .byt 138,254,"MY BUSINESS HAS ENDED BECAUSE I CAN NO LONGER GET TO",26,"ISLE",255

// Intonements (118-122)
//Intonements are messages issued by the 'Foretelling Stones' as a guide to the main quest
//in Times of Lore. As Such a number of posessions are required in order that the correct
//message is chosen. If no objects are requirement, then they can be ommitted as in the
//first message.
// Note that the response may contain embedded messages
;Format - required objects,response,255
progressive_stone_intonement118	;Stones
 .byt "SEEK",4,"THE TAKER, THOUGH HE LYES WITH HIS MAKER",255
progressive_stone_intonement119	;Stones, Note, Tablet
 .byt 181,195," ",6," AND ",7," HOLD THE NEXT STEP IN TIMES OF LORE",255
progressive_stone_intonement120	;Hat, Stones, Note, Tablet
 .byt 181,195,191,"THE UNDERWORLD IS VAST, FIND THE",194,"AND",193,"TO LAST",255
progressive_stone_intonement121	;Ring
 .byt 203,"AGRECHANT IS THE PLACE YOU SEEK, FOLLOW THE DESSERT EAST",255
progressive_stone_intonement122	;Medallion
 .byt 201,"TO THE SURFACE TAKE FLIGHT, TO BE SHOWN THE LIGHT",255


// creatures (11 of 22) (123-143)
;loc-type
;  0(Regional),254,Name(Option Text),255
;  1,Place,Posession/s,254,Name(Option Text),255
;    Posessions
;      176-207 Posession
;      0 No possession (Although only marker since these fields hold current posessions)
;    Sprites
;      0 Hero
;      1 Ghost
;      2 Guard
;      3 Orc
;      4 Asp
;      5 Rogue
;      6 Serf
;      7 Skeleton

 ;Low Priority creatures always at start
;For options, scan beyond 254
creature123
 .byt 0,254,"ORC",255
creature124
 .byt 0,254,"ROGUE",255
creature125
 .byt 0,254,"BLACK ASP",255
creature126
 .byt 0,254,"SKELETON",255
creature127
 .byt 0,254,"GHOST",255
creature128	;Creatures beyond 127 can be spoken to
 .byt 0,254,"SERF",255
creature129
 .byt 0,254,"GUARD",255
creature130
 .byt 1,144,0,254,"PRIOR",255
creature131
 .byt 1,143,190,195,254,"MOGROD",255
creature132
 .byt 1,152,180,176,179,254,"CALIBOR",255
creature133
 .byt 1,155,0,254,"CRODOR",255	;Serf when outside
creature134
 .byt 1,151,177,254,"BOMBADIL",255
creature135
 .byt 1,149,188,254,"BARTON",255
creature136
 .byt 1,150,193,254,"DARK PRIOR",255
creature137
 .byt 1,151,202,254,"JEROME",255
creature138
 .byt 1,154,0,254,"WICKERMAN",255
creature139
 .byt 1,153,191,254,"TISI",255
creature140
creature141

// places (142-175)
;Places are used for -
; Welcoming hero to Inn (PlaceText,tsmapx,tsmapy)
; Defining Location where creature/s reside (tsmapx,tsmapy)
; Transferring Hero (Shortname),fxl,fxh,fyl,fyh,txl,txh,tyl,tyh)

;LocationType
;	0 (Tavern),TSMapX,TSMapY,RegionText,254,NameText,255
;	1 (House),TSMapX,TSMapY,Posession/s,NameText,255
;	2 (Gate Jump),TSMapX,TSMapY,Xl,Xh,Yl,Yh,new_elsewhere*,Posession/s or Creature/s,255/0
;* New_elsewhere indicates whether the destination of the jump is outside, inside, underworld, etc.
place142
 .byt 0,27,15,"DARK FOREST",254,"DARK FOREST LODGE",255
place143	;Orc Camp Lodge, Dark Forest
 .byt 1,35,16,"DARK FOREST",254,"ORC CAMP LODGE",255
place144 	;Frothing Slosh Tavern, Eralan
 .byt 0,41,33,"ERALAN",254,"FROTHING SLOSH TAVERN",255
place145 	;Naughty Widow Tavern. Lankwell
 .byt 0,42,57,"LANKWELL",254,"NAUGHTY WIDOW TAVERN",255
place146 	;Last Hope Inn, Crator Wald
 .byt 0,52,49,"CRATORWALD",254,"LAST HOPE INN",255
place147 	;Trollsbane Tavern, Ganestor
 .byt 0,102,55,"GANESTOR",254,"TROLLSBANE TAVERN",255
place148  ;My Little Tavern, Hampton
 .byt 0,94,44,"HAMPTON",254,"MY LITTLE TAVERN",255
place149	; Green Oak Tavern, Treela
 .byt 0,90,32,"TREELA",254,"GREEN OAK TAVERN",255
place150  ; Sleepy Friar Inn, Rhyder
 .byt 0,73,9,"RHYDER",254,"SLEEPY FRIAR INN",255
place151	; Riverside Tavern, Sleepy River
 .byt 0,75,27,"SLEEPY",254,"RIVERSIDE TAVERN",255
place152	; Old Inn, Crannoth
 .byt 0,3,4,"CRANNOTH",254,"OLD INN",255
place153	; Sandy Tavern, Tempus
 .byt 0,26,59,"TEMPUS",254,"SANDY TAVERN",255
place154	; WillowBranch House, Lankwell (Never displayed in options!)
 .byt 1,40,57,0,"WILLOWBRANCH",255	;Posession required?
place155	; North Shore Lodge, Tempus (Never displayed in options!)
 .byt 1,15,49,0,"NORTH SHORE LODGE",255	;Posession required?
;Transferences (Even numbered places always take hero underground)
;Elsewhere_flag
;0 - Outside
;1 - In Tavern or Inn		 (Icon Menu Only)
;2 - In House                            (Icon Menu Only)
;3 - In Underworld or Underground Passage(Not shown on Map)
;128 - On Island (Combination)           (Not shown on Map)
;Gate Jump(2),TSMapX Start,TSMapY Start,Jump Xl,Jump Xh,Jump Yl,Jump Yh,new_elsewhere,Posession/s or Creature/s,255/0

place156	; Mouth of Equinox(Outside)
 .byt 2,19,4,<1039,>1039,<838,>838,3,0
place157  ; Mouth of Equinox(Inside)
 .byt 2,32,26,<625,>625,152,0,128,0
place158	; Crannoth Equinox(Outside)
 .byt 2,5,3,<622,>622,<840,>840,3,0
place159	; Crannoth Equinox(Inside)
 .byt 2,19,26,176,0,121,0,128,0
place160	; Crannoth Gate(Outside)
 .byt 2,3,12,47,0,<552,>552,3,180,0
place161	; Crannoth Gate(Inside)
 .byt 2,1,17,209,0,<312,>312,128,180,0
place162	; Tempus Gate(Outside)
 .byt 2,29,60,241,0,<1319,>1319,3,180,0
place163	; Tempus Gate(Inside)
 .byt 2,7,41,<976,>976,<1974,>1974,128,180,0
place164	; Silderons Mouth(Outside)
 .byt 2,10,50,47,0,<1959,>1959,3,139,0
place165	; Silderons Mouth(Inside)
 .byt 2,1,61,<337,>337,<1623,>1623,128,0
place166	; Crator(Outside)
 .byt 2,45,51,<687,>687,<1735,>1735,3,203,0
place167	; Crator(Inside)
 .byt 2,21,54,<1456,>1456,<1656,>1656,0,203,0
place168	; Agrechant Gate(Outside)	;Can only be opened at Night!
 .byt 2,85,56,<4047,>4047,<393,>393,3,178,0
place169	; Agrechant Gate(Inside)
 .byt 2,125,12,<2831,>2831,<1719,>1719,0,201,0
place170	; Angor Moor(Outside)
 .byt 2,122,29,<879,>879,<1065,>1065,3,179,0	;May need to replace 255 with 0
place171	; Angor Moor(Inside)
 .byt 2,27,33,<3921,>3921,<951,>951,0,179,0
place172	; Angor Gate(Outside)
 .byt 2,122,25,<879,>879,<970,>970,3,179,0
place173	; Angor Gate(Inside)
 .byt 2,27,30,<3921,>3921,<825,>825,0,179,0
place174
place175

// objects (23 of 32) (176-207)
;name(Option Text),254,Description,255,(255,Optional Price(MSB/LSB BCD Format))
object176
 .byt "TIN CLASP",254,"USED TO FASTEN A CLOAK AND ENGRAVED WITH A MOUNTAIN SYMBOL",255,255,$00,$99
object177
 .byt "WAND",254,"TWO WAVEY LINES AND A BRIDGE ARE MARKED ON IT",255,255,$30,$00
object178
 .byt "GLASS KEY",254,"THE KEY IS DEEPLY SCORCHED WITH THE WORD AGRECHANT",255
object179
 .byt "STONE KEY",254,"THE KEY IS INSCRIBED WITH THE WORD 'ANGOR'",255
object180
 .byt "QUARTZ KEY",254,"THE KEY IS MARKED WITH THE CRANNOTH INSIGNIA",255,255,$05,$00
object181
 .byt "NOTE",254,"'I MIDRATH MURDERED VALWYN FOR PITTANCE,AND FOR "
 .byt "MY GUILT I TAKE MY LIFE. HIS ",18," IS WITH ",5,255
object182
 .byt "GOLD",254,"EACH COIN HAS THE ALBORETH STAMP",255
object183
 .byt "DAGGER",254,"THE DAGGER IS OLD BUT RAZOR SHARP",255
object184
 .byt "OLD SCROLL",254,"THE SCROLL IS COVERED IN GLOWING RUNES",255
object185
 .byt "SKULL",254,"A HUMAN SKULL WITH PLUGGED EYE SOCKETS",255
object186
 .byt "GREEN VIAL",254,"THE VESSEL HAS A LARGE CROSS ON IT",255	;Quaffing the...
object187
 .byt "WHITE VIAL",254,"IT SMELLS OF ROTTEN PARSNIPS",255
object188
 .byt "BOOTS",254,"THE MAGICAL BOOTS FEEL SUPPLE AND WELL MADE",255,255,$10,$00
object189
 .byt "MAP BOOK",254,"THE BOOK OF PROVIDENCE",255,255,$20,$00
object190
 .byt "STONES",254,"THE STONES WARM TO YOUR TOUCH, AND FROM THEM THE FOLLOWING WORDS ARE UTTERED...",255,255,$05,$00
object191
 .byt "MAGIC HAT",254,"THE HAT IS BLACK WITH GOLD STARS ON IT",255,255,$50,$01
object192
 .byt "BOW&ARROW",254,"RUNES ARE SCRAWLED ALL OVER THE BOW",255
object193
 .byt "HOLY WATER",254,"THE CASKET HAS NO SPOUT",255
object194
 .byt "CROSS",254,"THE CROSS IS MADE OF AN UNKNOWN MATERIAL",255
object195
 .byt "TWINE",254,"USED TO BIND WILLOW BRANCHES",255,255,$00,$50
object196
; .byt "SIDE ARM",254,"YOUR PERSONAL WEAPON",255
object197
 .byt "RATIONS",254,255	;OOD PROVISIONS FOR A DAYS TRAVEL",255
object198
 .byt "BOARDING",254,255
object199
 .byt "AXE",254,"THE AXE IS LIGHT YET LONG AND STURDY",255
object200
 .byt "CLOAK",254,"THE CLOAK IS FINELY WOVEN AND GLISTENS LIKE SILK",255
object201
 .byt "MEDALLION",254,"THE MEDALLION GLOWS WITHIN YOUR GRASP",255
object202
 .byt "MEAD CHIME",254,"THE CHIME IS INSCRIBED 'TEMPLEMEAD'",255,255,$05,$00
object203
 .byt "RING",254,"THE RING IS INSCRIBED WITH STRANGE RUNES",255
object204
 .byt "PARCHMENT",254,"THE HIDE HAS MANY SYMBOLS ON IT",255

text205
text206
text207
 .byt "A DEEP PUNGENT MIST RISES FROM THE SPOUT..",255
text208
 .byt "SPIDERY RUNES EMANATE FROM THE SCROLL..",255
text209
 .byt "AS THE SKULL HITS THE GROUND, IT VANISHES..",255
text210
 .byt "A TOXIC MIST SPREADS ACCROSS THE LAND..",255
text211
 .byt "QUAFFING THE POTION, YOU FEEL RESTORED",255
text212
 .byt "A GATE OPENS",255
text213
 .byt "A GATE CLOSES",255
text214
 .byt "FRIENDS ARE ONCE MORE MET!",255
text215
 .byt "YOU'RE HUNGRY",255
text216
 .byt "TAKING RATIONS FROM YOUR PACK, YOU QUELL YOUR HUNGER",255
;When the hero is trying to use an object that only needs to be held on to, to be used.
text217
 .byt "POSESSION IS ENOUGH",255
;When the hero comes accross a door or gate that needs something to open it.
text218
 .byt "THE ] IS REQUIRED",255
text219
 .byt "SELECT ITEM",255
text220
 .byt "YOUR WEAPON IS NOW THE *",255
text221
 .byt "ALAS, YOUR LIFE HAS ENDED...",255
text222
 .byt "THEE IS OVERLAIDEN",255
text223
 .byt "YOU TAKE THE +",255
text224
 .byt "SELECT A SUBJECT",255
text225
 .byt "SELECT SOMEONE TO SPEAK TO",255
text226	;% reflects items possessed against total items required
 .byt "YOU HAVE $ GOLD COINS AND [ RATIONS",255
text227
 .byt "YOU HOLD NOTHING",255
text228
 .byt "WELCOME TO ^",255
text229
 .byt "THE DOOR IS LOCKED",255
text230
 .byt "WELCOME TO TIMES OF LORE...",255
text231	;Possibly not used
 .byt "SORRY, I CANNOT HELP YOU",255
text232
 .byt "] GOLD COINS ARE NOT POSESSED",255
text233
 .byt "YOU CLIMB INTO BED AND LYE ON THE COOL PILLOW...",255
text234
 .byt "THE INNKEEPER SELLS YOU ONE FOOD RATION",255
;Rumours
text235
 .byt "I HEARD TELL OF A CHIME THAT CAN RAISE GOLD FROM THE GROUND",255
text236
 .byt "SOMEONE MENTIONED LOSING A MAGICAL RING SOUTH OF THE DESSERT",255
text237
 .byt "I HEARD TELL OF A MAGICIAN WHOSE HAT GAVE HIM INVINCIBILITY",255
text238
 .byt "BOMBADIL IN SLEEPY RIVER CLAIMS TO HAVE THE WAND OF",19,255
text239
 .byt "BARTON IN TREELA CLAIMS TO HAVE MAGICAL BOOTS",255
text240
 .byt "A FRIEND OF MINE SAW A MAGICAL BOW IN",20,"TEMPLE GROUNDS",255
text241
 .byt "PEOPLE SAY THAT ONLY WITH",22,"AND THE",21,", WILL ALBORETH BE SANCTIFIED",255
text242
 .byt "WE DON'T HEAR FROM",25," PROVINCE ANYMORE",255
;
text243
 .byt "HE IGNORES YOU",255
text244
 .byt "HEARD ANY RUMOURS?",255
text245
 .byt "THE ITEM IS OF LITTLE USE HERE",255
text246
 .byt "BOARDING",255
text247
 .byt "RATIONS",255
text248
 .byt "CHITCHAT",255
text249
 .byt "QUESTION",255
text250
 .byt "INNKEEPER",255
text251
 .byt "SELECT SUBJECT MATTER",255
text252
; .byt "THE CREATURE IGNORES YOU",255
text253
 .byt "YOU ARE ALONE",255
