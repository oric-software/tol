'// Region Map (128 Bytes long arranged as 16*8
'// X Res of map is 128, Y is 64.
'// Region = (YRes/16)+(XRes/16)

'// Region Byte breakdown
'                                               Code to Enter
'B0-2 Residing Sprite Groups
'        0 Serf & Guard (Towns)                 Ser
'        1 Serf & Orcs (Moors)                  Orc
'        2 Orc & Archer (Forest)                Arc
'        3 Ghost & Slime (Underwurlde)          Gho
'        4 Skeleton & Orc (Dessert)             Ske
'        5 Black Asp & Black Asp (Monastaries   Asp

'B3-5   Environment Sounds
'          0 Silence                            Sil
'          1 Dessert (Dessert Wind)             Des
'          2 Forest  (Bird Song)                For
'          3 Moor (Wind)                        Moo
'          4 Sea (Waves)                        Sea
'          5 UnderWurlde                        Und
'          6 Water (Trickle)                    Wat
'
' Note that additional sounds like those for the underworld will need to be detected
' since the region map is not always precise enough.
'B5-7   -
#define   ser       0
#define   orc       1
#define   arc       2
#define   gho       3
#define   ske       4
#define   asp       5

#define   sil       0
#define   des       8
#define   for       16
#define   moo       24
#define   sea       32
#define   und       40
#define   wat       48

'Codes are entered like Serf+Sea or Archer+Forest
'Table Orientation X = X, Y = Y
Region_Map
Region
'line1 0-15
 .byt ser+sea,arc+sea,arc+for,arc+for,arc+for,arc+for,arc+for,arc+for
 .byt arc+for,arc+for,arc+moo,arc+moo,arc+moo,asp+moo,gho+und,gho+und
'Line2
 .byt ser+sea,arc+sea,arc+for,arc+for,arc+for,arc+for,arc+for,arc+for
 .byt arc+for,ser+moo,ser+wat,arc+wat,asp+moo,asp+moo,gho+und,gho+und
'Line3
 .byt arc+sea,arc+for,arc+for,arc+for,arc+for,arc+for,arc+for,arc+for
 .byt arc+wat,arc+wat,arc+wat,arc+wat,arc+wat,arc+wat,asp+moo,asp+moo
'Line4
 .byt arc+sea,arc+sea,arc+for,arc+for,arc+for,ser+moo,arc+moo,arc+wat
 .byt arc+wat,ser+wat,arc+for,arc+for,arc+wat,arc+wat,asp+moo,asp+moo
'Line5
 .byt ser+sea,arc+sea,arc+sea,arc+for,ser+moo,ser+moo,ser+moo,arc+wat
 .byt arc+for,arc+wat,arc+for,ser+for,arc+for,0,0,0
'Line6
 .byt gho+und,arc+sea,arc+sea,arc+sea,orc+sea,orc+wat,orc+wat,orc+wat
 .byt orc+wat,arc+wat,arc+for,ser+for,ser+moo,0,0,0
'Line7
 .byt arc+sea,arc+sea,arc+sea,arc+sea,orc+sea,orc+moo,ske+des,ske+des
 .byt ske+des,ske+des,ske+des,ske+des,arc+moo,ser+moo,ser+moo,0
'Line8
 .byt arc+sea,gho+und,gho+und,ske+sea,arc+sea,ser+moo,ske+des,ske+des
 .byt ske+moo,ske+des,ske+des,ske+des,arc+moo,ser+moo,ser+moo,0
