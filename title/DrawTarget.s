;
;0-3
;0 Move Right
;1 Move Down
;2 Move Left
;3 Move Up
RegionID	.byt 0

DisplayRegionStats
	;Display Region Template
	ldx #79
.(
loop1	lda RegionTemplateText,x
	sta $BB80+15*40,x
	lda #9
	sta $BB80+19*40,x
	dex
	bpl loop1
.)
	;Display Region name
	ldx RegionID
	lda RegionNameVectorLo,x
	sta source
	lda RegionNameVectorHi,x
	sta source+1
	ldy #00
.(
loop1	lda (source),y
	php
	and #127
	sta $BB8D+15*40,y
	iny
	plp
	bpl loop1
.)	
	
	;Display Creatures text
	ldy RegionCreatures,x
	lda CreatureNamesVectorLo,y
.(
	sta vector1+1
	lda CreatureNamesVectorHi,y
	sta vector1+2
	ldy #00
vector1	lda $dead,y
	php
	and #127
	sta $BB8D+16*40,y
	iny
	plp
	bpl vector1
.)	
	
	;Display Region Info
	lda RegionInfosVectorLo,x
	sta source
	lda RegionInfosVectorHi,x
	sta source+1
	ldy #00
.(
loop1	lda (source),y
	php
	and #127
	sta $BB80+17*40,y
	iny
	plp
	bpl loop1
.)	
	rts

RegionTemplateText
;       0123456789012345678901234567890123456789
 .byt 9,"   Region :                            "
 .byt 9,"Creatures :                            "
DrawBorder
	ldx RegionID
	lda RegionStartX,x
	sta bX
	lda RegionStartY,x
	sta bY
	lda RegionBytes,x
	sta bByteCount
	lda RegionDataLo,x
	sta bData
	lda RegionDataHi,x
	sta bData+1
	
	lda #3
	sta bNibbleIndex
	lda #00
	sta bByteIndex
.(	
loop2	ldy bByteIndex
	lda (bData),y
	sta bNibbleByte
	
loop1	lda PixelShift
	adc #9
	sta PixelShift
	bcc skip1
	jsr PlotPixelAtXY
	
skip1	;Progress pixel
	asl bNibbleByte
	rol
	asl bNibbleByte
	rol
	and #3
	tax
	lda bX
	clc
	adc bXStep,x
	sta bX
	lda bY
	clc
	adc bYStep,x
	sta bY
	
	dec bNibbleIndex
	bpl loop1
	lda #3
	sta bNibbleIndex
	inc bByteIndex
	dec bByteCount
	bne loop2
.)
	rts

PlotPixelAtXY
	ldx bX
	ldy bY
	lda ScreenOffsetLo,y
	sta screen
	lda ScreenOffsetHi,y
	ora #$A0
	sta screen+1
	ldy XLOC,x
	lda (screen),y
	eor BITPOS,x
	sta (screen),y
	rts
PixelShift	.byt 0
bXStep
 .byt 1,0,255,0
bYStep
 .byt 0,1,0,255
	
XLOC
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39
BITPOS
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
 .byt 32,16,8,4,2,1	
RegionStartX
 .byt 121		;Borders_DarkForest     
 .byt 226           ;Borders_TempleOfAngor  
 .byt 119           ;Borders_CratorWald     
 .byt 123           ;Borders_Dessert        
 .byt 159           ;Borders_EnchantedForest
 .byt 34            ;Borders_Equinox        
 .byt 164           ;Borders_TheMeres       
 .byt 180           ;Borders_TempleMead     
 .byt 90            ;Borders_Eralan         
 .byt 195           ;Borders_Ganestor       
 .byt 176           ;Borders_Hampton        
 .byt 81            ;Borders_Lankwell       
 .byt 141           ;Borders_Rhyder         
 .byt 138           ;Borders_SleepyRiver    
 .byt 173           ;Borders_Treela         
RegionNameVectorLo
 .byt <RegionName0
 .byt <RegionName1
 .byt <RegionName2
 .byt <RegionName3
 .byt <RegionName4
 .byt <RegionName5
 .byt <RegionName6
 .byt <RegionName7
 .byt <RegionName8
 .byt <RegionName9
 .byt <RegionName10
 .byt <RegionName11
 .byt <RegionName12
 .byt <RegionName13
 .byt <RegionName14
RegionNameVectorHi
 .byt >RegionName0
 .byt >RegionName1
 .byt >RegionName2
 .byt >RegionName3
 .byt >RegionName4
 .byt >RegionName5
 .byt >RegionName6
 .byt >RegionName7
 .byt >RegionName8
 .byt >RegionName9
 .byt >RegionName10
 .byt >RegionName11
 .byt >RegionName12
 .byt >RegionName13
 .byt >RegionName14
RegionName0
 .byt "Dark Fores","t"+128
RegionName1
 .byt "Temple Of Ango","r"+128
RegionName2
 .byt "Crator Wal","d"+128     
RegionName3
 .byt "Deser","t"+128        
RegionName4
 .byt "Enchanted Fores","t"+128
RegionName5
 .byt "Equino","x"+128        
RegionName6
 .byt "The Great lake","s"+128
RegionName7
 .byt "Temple Mea","d"+128
RegionName8
 .byt "Erala","n"+128
RegionName9
 .byt "Ganesto","r"+128
RegionName10
 .byt "Hampto","n"+128
RegionName11
 .byt "Lankwel","l"+128
RegionName12
 .byt "Rhyde","r"+128
RegionName13
 .byt "Sleepy Rive","r"+128
RegionName14
 .byt "Treel","a"+128
CreatureNamesVectorLo
 .byt <CreatureNames0
 .byt <CreatureNames1
 .byt <CreatureNames2
 .byt <CreatureNames3
 .byt <CreatureNames4
 .byt <CreatureNames5
CreatureNamesVectorHi
 .byt >CreatureNames0
 .byt >CreatureNames1
 .byt >CreatureNames2
 .byt >CreatureNames3
 .byt >CreatureNames4
 .byt >CreatureNames5

CreatureNames0
 .byt "Serfs & Guard","s"+128
CreatureNames1
 .byt "Serfs & Orc","s"+128
CreatureNames2
 .byt "Orcs & Archer","s"+128
CreatureNames3
 .byt "Ghosts & Slim","e"+128
CreatureNames4
 .byt "Skeletons & Orc","s"+128
CreatureNames5
 .byt "Black Asp","s"+128

RegionCreatures
;0 Serf & Guard (Towns)
;1 Serf & Orcs (Moors)
;2 Orc & Archer (Forest)
;3 Ghost & Slime (Underwurlde)
;4 Skeleton & Orc (Dessert)
;5 Black Asp & Black Asp (Monastaries)
 .byt 2		;Dark Forest     
 .byt 5          	;Temple Of Angor  
 .byt 1          	;Crator Wald     
 .byt 4          	;Dessert        
 .byt 2          	;Enchanted Forest
 .byt 1          	;Equinox        
 .byt 1          	;The Meres       
 .byt 1          	;TempleMead     
 .byt 0          	;Eralan         
 .byt 0          	;Ganestor       
 .byt 0          	;Hampton        
 .byt 0          	;Lankwell       
 .byt 0          	;Rhyder         
 .byt 0          	;Sleepy River    
 .byt 0          	;Treela
RegionInfosVectorLo
 .byt <RegionInfo0
 .byt <RegionInfo1
 .byt <RegionInfo2
 .byt <RegionInfo3
 .byt <RegionInfo4
 .byt <RegionInfo5
 .byt <RegionInfo6
 .byt <RegionInfo7
 .byt <RegionInfo8
 .byt <RegionInfo9
 .byt <RegionInfo10
 .byt <RegionInfo11
 .byt <RegionInfo12
 .byt <RegionInfo13
 .byt <RegionInfo14
RegionInfosVectorHi
 .byt >RegionInfo0
 .byt >RegionInfo1
 .byt >RegionInfo2
 .byt >RegionInfo3
 .byt >RegionInfo4
 .byt >RegionInfo5
 .byt >RegionInfo6
 .byt >RegionInfo7
 .byt >RegionInfo8
 .byt >RegionInfo9
 .byt >RegionInfo10
 .byt >RegionInfo11
 .byt >RegionInfo12
 .byt >RegionInfo13
 .byt >RegionInfo14
RegionInfos
;      012345678901234567890123456789012345678 012345678901234567890123456789012345678 012345678901234567890123456789012345678 012345678901234567890123456789012345678
RegionInfo0
 .byt 9,"A vast swaith of deep green covers most"
 .byt 9,"of this land.Whilst being the main path"
 .byt 9,"to Rhyder and the Meres it is also home"
 .byt 9,"to the Orcs","."+128		;Dark Forest
RegionInfo1
 .byt 9,"The Temple is now occupied by the Black"
 .byt 9,"Asps. They do not welcome visitors but "
 .byt 9,"prefer a hermit existance in their self"
 .byt 9,"enclosed fortress","."+128		;TempleOfAngor
RegionInfo2
 .byt 9,"Whilst being the main thoroughfare from"
 .byt 9,"Eralan to southern and eastern marches "
 .byt 9,"The Wald is a dangerous place to travel"
 .byt 9,"through","."+128			;CratorWald
RegionInfo3
 .byt 9,"The vastness and emptiness of this land"
 .byt 9,"makes it treacherous to get across. The"
 .byt 9,"few who do return alive mention seeing "
 .byt 9,"great ruins in the sand","."+128	;Desert
RegionInfo4
 .byt 9,"The name may entice the unwary but such"
 .byt 9,"bramble and creatures exist within that"
 .byt 9,"few have profited from the escapade but"
 .byt 9,"lost their way to never return","."+128	;EnchantedForest
RegionInfo5
 .byt 9,"This land can only be reached by a very"
 .byt 9,"long and winding Dark forest path. Some"
 .byt 9,"People claim it holds a tunnel entrance"
 .byt 9,"that reaches the western isles","."+128	;Equinox
RegionInfo6
 .byt 9,"These great reservoirs are home to the "
 .byt 9,"very best fresh water fish in Alboreth."
 .byt 9,"The fishermen dug deep watery dikes to "
 .byt 9,"harvest the fish","."+128		;TheMeres
RegionInfo7
 .byt 9,"It has been said of Templemead there is"
 .byt 9,"no finer nor remote place more close to"
 .byt 9,"nature. Nothing is known of the ancient"
 .byt 9,"stones that lye at its centre","."+128	;TempleMead
RegionInfo8
 .byt 9,"The beating heart of Alboreth. The fine"
 .byt 9,"walled city used to house the High King"
 .byt 9,"Valwyn and it is here that you grew up "
 .byt 9,"and where you start your quest","."+128	;Eralan
RegionInfo9
 .byt 9,"The Fortress City where the soldiers & "
 .byt 9,"guards learn their art.Ganestor is also"
 .byt 9,"home to Lord Heidric who resides in the"
 .byt 9,"Great Castle","."+128		;Ganestor
RegionInfo10
 .byt 9,"The village is a halfway house for the "
 .byt 9,"main trade route between the two cities"
 .byt 9,"but is also the first stop of the route"
 .byt 9,"to Treela and Sleepy River","."+128	;Hampton
RegionInfo11
 .byt 9,"The fishing town of Lankwell used to   "
 .byt 9,"serve both the mainland and the western"
 .byt 9,"isles but since the war no ships anchor"
 .byt 9,"in its bay anymore","."+128		;Lankwell       
RegionInfo12
 .byt 9,"Rhyder was a market town. Selling fresh"
 .byt 9,"water fish from the Meres,Meat from the"
 .byt 9,"Forest and grain from the home counties"
 .byt 9,"but now only serves Travellers","."+128	;Rhyder         
RegionInfo13
 .byt 9,"The village lies due south of the inner"
 .byt 9,"isle and is thought the most difficult "
 .byt 9,"region to reach on foot. Its only trade"
 .byt 9,"is with the inner isle","."+128	;SleepyRiver    
RegionInfo14
 .byt 9,"Treela lies at the very centre of the  "
 .byt 9,"enchanted Forest and is only reachable "
 .byt 9,"by Forest path. Treela is known for its"
 .byt 9,"Mead and wooden houses","."+128	;Treela
RegionStartY
 .byt 8		;Borders_DarkForest     
 .byt 35            ;Borders_TempleOfAngor  
 .byt 80            ;Borders_CratorWald     
 .byt 87            ;Borders_Dessert        
 .byt 46            ;Borders_EnchantedForest
 .byt 3             ;Borders_Equinox        
 .byt 9             ;Borders_TheMeres       
 .byt 10            ;Borders_TempleMead     
 .byt 49            ;Borders_Eralan         
 .byt 89            ;Borders_Ganestor       
 .byt 74            ;Borders_Hampton        
 .byt 97            ;Borders_Lankwell       
 .byt 13            ;Borders_Rhyder         
 .byt 48            ;Borders_SleepyRiver    
 .byt 55            ;Borders_Treela         
RegionBytes
 .byt 109		;Borders_DarkForest     
 .byt 23            ;Borders_TempleOfAngor  
 .byt 41            ;Borders_CratorWald     
 .byt 61            ;Borders_Dessert        
 .byt 66            ;Borders_EnchantedForest
 .byt 16            ;Borders_Equinox        
 .byt 59            ;Borders_TheMeres       
 .byt 24            ;Borders_TempleMead     
 .byt 38            ;Borders_Eralan         
 .byt 22            ;Borders_Ganestor       
 .byt 15            ;Borders_Hampton        
 .byt 15            ;Borders_Lankwell       
 .byt 17            ;Borders_Rhyder         
 .byt 15            ;Borders_SleepyRiver    
 .byt 9             ;Borders_Treela         
RegionDataLo
 .byt <Borders_DarkForest
 .byt <Borders_TempleOfAngor
 .byt <Borders_CratorWald
 .byt <Borders_Dessert
 .byt <Borders_EnchantedForest
 .byt <Borders_Equinox
 .byt <Borders_TheMeres
 .byt <Borders_TempleMead
 .byt <Borders_Eralan
 .byt <Borders_Ganestor
 .byt <Borders_Hampton
 .byt <Borders_Lankwell
 .byt <Borders_Rhyder
 .byt <Borders_SleepyRiver
 .byt <Borders_Treela

RegionDataHi
 .byt >Borders_DarkForest
 .byt >Borders_TempleOfAngor
 .byt >Borders_CratorWald
 .byt >Borders_Dessert
 .byt >Borders_EnchantedForest
 .byt >Borders_Equinox
 .byt >Borders_TheMeres
 .byt >Borders_TempleMead

 .byt >Borders_Eralan
 .byt >Borders_Ganestor
 .byt >Borders_Hampton
 .byt >Borders_Lankwell
 .byt >Borders_Rhyder
 .byt >Borders_SleepyRiver
 .byt >Borders_Treela
