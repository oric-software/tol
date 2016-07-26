// Region
// Tables and Code relating to Region
//
// Region Map (128 Bytes long arranged as 16*8
// X Res of map is 128, Y is 64.
// Region = (YRes/16)+(XRes/16)

//// Region Byte breakdown
//                                               Code to Enter
//B0-2 Residing Sprite Groups
//        0 Serf & Guard (Towns)                 Ser
//        1 Serf & Orcs (Moors)                  Orc
//        2 Orc & Archer (Forest)                Arc
//        3 Ghost & Slime (Underwurlde)          Gho
//        4 Skeleton & Orc (Dessert)             Ske
//        5 Black Asp & Black Asp (Monastaries   Asp
#define   ser       0
#define   orc       1
#define   arc       2
#define   gho       3
#define   ske       4
#define   asp       5
//
//B3-4   Environment Sounds
//          0 Silence                            Sil
//          1 Forest  (Bird Song)                For
//          2 River (Babbling Brook)             Riv
//          3 Sea (Waves)                        Sea
#define   sil       0
#define   for       8
#define	riv	16
#define   sea       24
//
// Note that additional sounds like those for the underworld will need to be detected
// since the region map is not always precise enough.
//B5-7   Volume of Environment Sound
#define	rv0	0
#define	rv1       32
#define	rv2       64
#define	rv3       96
#define	rv4       128
#define	rv5       160
#define	rv6       192
#define	rv7       224
//Codes are entered like Serf+Sea or Archer+Forest
//Table Orientation X = X, Y = Y
Region_Map
Region
//line1 0-15
 .byt ser+sea+rv7,arc+sea+rv7,arc+for+rv2,arc+for+rv5
 .byt arc+for+rv6,arc+for+rv6,arc+for+rv6,arc+for+rv6
 .byt arc+for+rv6,arc+for+rv6,arc+riv+rv1,arc+riv+rv1
 .byt arc+riv+rv2,asp+riv+rv1,gho+sil+rv0,gho+sil+rv0
//Line2
 .byt ser+sea+rv7,arc+sea+rv7,arc+for+rv3,arc+for+rv5
 .byt arc+for+rv7,arc+for+rv7,arc+for+rv6,arc+for+rv4
 .byt arc+riv+rv1,ser+riv+rv1,ser+riv+rv7,arc+riv+rv7
 .byt asp+riv+rv3,asp+riv+rv2,gho+riv+rv1,gho+sil+rv0
//Line3
 .byt arc+sea+rv7,arc+for+rv6,arc+for+rv4,arc+for+rv6
 .byt arc+for+rv7,arc+for+rv7,arc+for+rv7,arc+riv+rv3
 .byt asp+riv+rv7,asp+riv+rv3,arc+riv+rv7,arc+riv+rv7
 .byt arc+riv+rv4,arc+riv+rv4,asp+riv+rv2,asp+riv+rv1
//Line4
 .byt arc+sea+rv7,arc+sea+rv6,arc+for+rv3,arc+for+rv6
 .byt arc+for+rv6,ser+riv+rv5,arc+riv+rv4,arc+riv+rv6
 .byt arc+riv+rv5,ser+riv+rv5,arc+riv+rv2,arc+riv+rv3
 .byt arc+riv+rv6,arc+riv+rv7,asp+riv+rv3,asp+riv+rv1
//Line5
 .byt ser+sea+rv7,arc+sea+rv6,arc+sea+rv5,arc+for+rv4
 .byt ser+sea+rv1,ser+sil+rv0,ser+riv+rv6,arc+for+rv2
 .byt arc+for+rv5,arc+riv+rv6,arc+for+rv5,ser+for+rv7
 .byt arc+for+rv3,0,0,0
//Line6
 .byt gho+sea+rv7,arc+sea+rv6,arc+sea+rv7,arc+sea+rv5
 .byt orc+sea+rv3,orc+riv+rv7,orc+riv+rv6,orc+riv+rv6
 .byt orc+riv+rv6,arc+riv+rv7,arc+riv+rv3,ser+for+rv3
 .byt ser+for+rv1,0,0,0
//Line7
 .byt arc+sea+rv7,arc+sea+rv5,arc+sea+rv6,arc+sea+rv5
 .byt orc+sea+rv3,orc+sea+rv2,ske+sea+rv1,ske+sil+rv0
 .byt ske+sil+rv0,ske+sil+rv0,ske+sil+rv0,ske+sil+rv0
 .byt arc+sil+rv0,ser+sil+rv0,ser+sil+rv0,0
//Line8
 .byt arc+sea+rv7,gho+sea+rv7,gho+sea+rv7,ske+sea+rv4
 .byt arc+sea+rv3,ser+sea+rv2,ske+sea+rv1,ske+sil+rv0
 .byt ske+for+rv3,ske+sil+rv1,ske+sil+rv0,ske+sil+rv0
 .byt arc+sil+rv0,ser+sil+rv0,ser+sil+rv0,0

// To Display the current region, the easiest, fastest way is to have a table 128 bytes long
// that contains the message name number of each region and is indexed by region.
region_name_pointer
 .byt 094,095,095,096,096,096,096,096,096,096,098,098,000,000,000,000
 .byt 094,096,096,096,096,096,096,096,097,097,098,098,099,099,000,000
 .byt 096,096,096,096,096,096,096,096,102,102,098,098,098,098,105,105
 .byt 096,096,096,096,096,096,096,102,102,103,102,102,098,098,105,105
 .byt 106,096,096,096,100,100,100,102,102,102,102,104,102,110,110,110
 .byt 000,096,096,096,100,100,108,108,108,102,102,109,109,110,110,110
 .byt 092,092,093,093,108,108,108,101,101,101,101,101,091,091,110,110
 .byt 092,092,093,093,107,107,101,101,101,101,101,101,091,091,110,110

;ccbbbsss ssss
;ccbbbsss sss
fetch_hero_region
	lda hero_yh
	asl
	asl
	asl
	asl
	ora hero_xh
fhregion_01
	tay
	lda Region_Map,y
	rts

;A == Xh
;Y == Yh
fetch_region
.(
	sta vector1+1
	tya
	asl
	asl
	asl
	asl
vector1	ora #00
.)
	jmp fhregion_01
;	tay
;	lda Region_Map,y
;	rts

;Examine_region is used to issue messages to text window whenever a new region is reached
;
examine_region
	jsr fetch_hero_region
	cmp previous_sampled_region
.(
	beq skip1
	// Region has changed
	sta previous_sampled_region
	ldx region_name_pointer,y
	jsr fetch_textloc00y0
	jsr messageaddress2window
skip1	rts
.)
