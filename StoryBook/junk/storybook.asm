'Storybook MC
'0200 HOLDS SELECTED HERO
'all works!  call #9599

:PIC_CRUNCHED_LO
[00E6C54C0CBB2FC8B0BFA7]
:PIC_CRUNCHED_HI
[050C131920252D58343F4C]

'when we stick into buffer
':PIC_SLOCL
'[4212D24282104FD2D0D1C7]
':PIC_SLOCH
'[65646C656B6E6562626262]
:PIC_SLOCL
[C19151C1018FCE43514F51]
:PIC_SLOCH
[A3A2ABA3AAACA3A1A1A1A1]
:PIC_WIDTH
[171616171618191F141615]
:PIC_HEIGHT
[65655E5E55605E5FB6AEB6]
:TEXT_SOURCE_LO
[C1A6BBBEB2B275508734ED]
:TEXT_SOURCE_HI
[81838587898B8D8F909191]
:TEXT_DISPLAY_X
'FFFFFFFFFFFFFFFF
[960C0C960C0C0C0C0C0C0C]
:TEXT_DISPLAY_Y
[1010101010101078302030]

:LEFT_MARGIN
[0B8A90]
:CHAR_WIDTH	'32-127
[040404040404040404040404040404040404040404040404040404040404040404]
[0606060606060606060606060606060606060606060606060606]
[010101010101]
[0606060605040606040406040606060606060605060506060606]
:XLOC
[000000000000010101010101020202020202030303030303040404040404050505050505]
[0606060606060707070707070808080808080909090909090A0A0A0A0A0A0B0B0B0B0B0B]
[0C0C0C0C0C0C0D0D0D0D0D0D0E0E0E0E0E0E0F0F0F0F0F0F101010101010111111111111]
[121212121212131313131313141414141414151515151515161616161616171717171717]
[1818181818181919191919191A1A1A1A1A1A1B1B1B1B1B1B1C1C1C1C1C1C1D1D1D1D1D1D]
[1E1E1E1E1E1E1F1F1F1F1F1F202020202020212121212121222222222222232323232323]
[242424242424252525252525262626262626272727272727]
:XSHIFT
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405000102030405000102030405]
[000102030405000102030405000102030405000102030405]
:TOP_LEFT_CORNERR
<%01101100,%01101100,%01110000,%01011100,%01000100>
<%01110000,%01010000,%01100001,%01111101>
:BOTTOM_LEFT_CORNERR
<%01111101,%01100001,%01010000,%01110000,%01000100>
<%01011100,%01110000,%01101100,%01101100>
:TOP_RIGHT_CORNER
<%01001101,%01100010>
<%01001101,%01000010>
<%01000011,%01011010>
<%01001110,%01010110>
<%01001000,%01111100>
<%01000011,%01110000>
<%01000010,%01100010>
<%01100001,%01100100>
<%01101111,%01001010>
:BOTTOM_RIGHT_CORNER
<%01101111,%01001010>
<%01100001,%01100100>
<%01000010,%01100010>
<%01000011,%01110000>
<%01001000,%01111100>
<%01001110,%01010110>
<%01000011,%01011010>
<%01001101,%01000010>
<%01001101,%01100010>
:HERO_SCNL
[7FD0E7]
:HERO_SCNH
[A5A3A2]
:HERO_SOURCEL
[248800]
:HERO_SOURCEH
[636568]
:HERO_HEIGHT
[444F55]
:HERO_WIDTH
[09080B]
:X_GREYSCALE
<%000000,%001000,%100100,%101010,%101110,%110110,%111011,%111111>
:A_GREYSCALE
<%000000,%000001,%010010,%010101,%111010,%011011,%101111,%111111>

&DRIVER	LDA #00
	STA 0200
	STA 0201
	SEI
	JSR &SOFT_HIRES
	LDX #00
	STX FF
&DRV_01	JSR &CLEAR_HIRES
	JSR &PLOT_BORDERS
	JSR &ORIGINAL_OPEN
	LDX FF
	CPX #08
	BCC &DRV_21
	TXA
	CLC
	ADC 0200
	TAX
	STX FF
	JSR &DECRUNCH_PICTURE
	JSR &PLOT_TEXT
	JSR &GET_ANY_KEY
	JSR &ORIGINAL_CLOSE
	CLI
	RTS
&DRV_21	LDX FF
	CPX #07
	BNE &DRV_10
	JSR &DRV_08
	LDX FF
&DRV_10	JSR &DECRUNCH_PICTURE
	JSR &PLOT_TEXT
	LDX FF
	CPX #07
	BNE &DRV_02
	JSR &SELECT
	JMP &DRV_20
&DRV_02	JSR &GET_ANY_KEY
&DRV_20	JSR &ORIGINAL_CLOSE
	INC FF
	JMP &DRV_01

&ORIGINAL_OPEN
	LDA #78
	STA BD
	LDA #A0
	STA BB
	LDA #AF
	STA BC
	STA BE
	LDA #$00
	STA BF
	LDX #$99
&OO_01	LDY #27
&OO_02	LDA (BD),Y
	EOR #3F
	STA (BD),Y
	LDA (BB),Y
	EOR #3F
	STA (BB),Y
	DEY
	BNE &OO_02
	LDA 625C,X
	STA (BD),Y
	LDY BF
	LDA 62C0,Y
	LDY #00
	STA (BB),Y
	INC BF
	JSR &LL_BD
	JSR &NL_BB
	JSR &DELAY
	DEX
	BPL &OO_01
	RTS

&LL_BD	LDA BD
	SEC
	SBC #28
	STA BD
	BCS 02
	DEC BE
	RTS

&ORIGINAL_CLOSE
	JSR &SETUP_HLOC
	LDA #18
	STA BD
	LDA #BF
	STA BE
	LDX #$99
&OC_02	LDY #27
	LDA #40
&OC_01	STA (BB),Y
	STA (BD),Y
	DEY
	BNE &OC_01
	TYA
	STA (BB),Y
	STA (BD),Y
	JSR &NL_BB
	JSR &LL_BD
	JSR &DELAY
	DEX
	BPL &OC_02
	RTS

&SELECT	JSR &GET_LRKEYS
	CMP #01
	BNE &SLC_04
	LDA 0200
	BEQ &SLC_01
	DEC 0200
	JMP &SLC_03
&SLC_04	CMP #02
	BNE &SLC_05
	LDA 0200
	CMP #02
	BEQ &SLC_01
	INC 0200
	JMP &SLC_03
&SLC_05	CMP #04
	BNE &SLC_01
	RTS
&SLC_03	LDA #07
	STA 0205
	LDX #07
	JSR &DECRUNCH_PICTURE
&SLC_01	JSR &CONTROL_SELECTION
	LDA 0205
	BEQ &SLC_02
	DEC 0205
&SLC_02	JMP &SELECT

&CONTROL_SELECTION
	LDA #00
	STA B6
	LDA 0200
	CMP #01
	BNE &CS_01
	JSR &SETUP_XAFADE
	LDY #00
	JSR &SHADE_HERO
&CS_02	JSR &SETUP_XAFADE
	LDY #02
	JMP &SHADE_HERO
&CS_01	BCS &CS_03
	JSR &CS_02
&CS_04	JSR &SETUP_XAFADE
	LDY #01
	JMP &SHADE_HERO
&CS_03	JSR &CS_04
	JSR &SETUP_XAFADE
	LDY #00
	JMP &SHADE_HERO

&SETUP_XAFADE
	LDY 0205
	LDA :A_GREYSCALE,Y
	LDX :X_GREYSCALE,Y
	RTS

&SHADE_HERO
	STA B9
	STX B8
	LDA :HERO_SCNL,Y
	STA BB
	LDA :HERO_SCNH,Y
	STA BC
	LDA :HERO_SOURCEL,Y
	STA BD
	LDA :HERO_SOURCEH,Y
	STA BE

	LDA :HERO_WIDTH,Y
	STA BF
	LDX :HERO_HEIGHT,Y
&HBH_03	LDA B6
	EOR #01
	STA B6
	TAY
	LDA 00B8,Y
	STA B7
	LDY BF
	DEY
&HBH_02
'	LDA (BD),Y
'	STA (BB),Y
	LDA (BB),Y	'SCREEN
	AND #7F
	CMP #40
	BCC &HBH_01
	AND B7
	STA BA
	LDA (BB),Y
	AND (BD),Y	'MASK
	ORA BA
	STA (BB),Y
&HBH_01	DEY
	BPL &HBH_02
	LDA B9
	EOR #%111111
	STA B9
	LDA BD
	CLC
	ADC BF
	STA BD
	BCC 02
	INC BE
	JSR &NL_BB
	DEX
	BNE &HBH_03
	RTS








&DELAY	PHA
	TYA
	PHA
	TXA
	PHA
	LDX #00
&DLY_02	LDY #10
&DLY_01	DEY
	BPL &DLY_01
	DEX
	BNE &DLY_02
	PLA
	TAX
	PLA
	TAY
	PLA
	RTS
&DLY_03	PHA
	TYA
	PHA
	TXA
	PHA
	LDX #04
	LDY #00
&DLY_04	NOP
	INY
	BNE &DLY_04
	DEX
	BNE &DLY_04
	PLA
	TAX
	PLA
	TAY
	PLA
	RTS


&GET_ANY_KEY
	JSR &INKEY
	BCC &GET_ANY_KEY
	RTS

&INKEY	PHA
	TXA
	PHA
	TYA
	PHA
	LDA #00
	JSR &SETUP_KEY
&GAK_02	LDX #07
&GAK_01	STX 0300
	LDA 0300
	AND #08
	CMP #08
	BCS &GAK_03
	DEX
	BPL &GAK_01
&GAK_03	PLA
	TAY
	PLA
	TAX
	PLA
	RTS


&GET_LRKEYS
	LDA #00
	STA 0208
	LDA #04
	STA 0300
	LDA #DF
	JSR &SETUP_KEY
	LDA 0300
	AND #08
	BEQ &GLRK_01
	LDA #01
	STA 0208
	RTS
&GLRK_01	LDA #7F
	JSR &SETUP_KEY
	LDA 0300
	AND #08
	BEQ &GLRK_02
	LDA #02
	STA 0208
	RTS
&GLRK_02	LDA #FE
	JSR &SETUP_KEY
	LDA 0300
	AND #08
	BEQ &GLRK_03
	LDA #04
	STA 0208
&GLRK_03	RTS

&SETUP_KEY
	LDX #0E
	STX 030F
	LDX #FF
	STX 030C
	LDX #DD
	STX 030C
	STA 030F
	LDY #FD
	STY 030C
	STX 030C
	RTS



&DRV_08	LDA #62
	STA BB
	LDA #A1
	STA BC
	LDX #5F
	LDY #00
&DRV_09	LDA #%10000111
	STA (BB),Y
	JSR &NL_BB
	DEX
	BNE &DRV_09
	RTS


&SOFT_HIRES
	CLC
	JSR &SETUP_HLOC     'CLEAR DOWN ALL MEMORY AREA WITH ZERO
	LDY #00
	TYA
	LDX #20
&SHR_01
	STA (BB),Y
	INY
	BNE &SHR_01
	INC BC
	DEX
	BNE &SHR_01
	LDA #$30		'WRITE HIRES SWITCH
	STA BF40
	JSR &SETUP_HLOC	'CLEAR HIRES WITH #40
	LDX #$200
&SHR_04
	LDY #$39
&SHR_05
	LDA #40
	STA (BB),Y
	DEY
	BPL &SHR_05
	JSR &NL_BB
&SHR_02
	DEX
	BNE &SHR_04
	RTS

&CLEAR_HIRES
	JSR &SETUP_HLOC
	LDX #$200
&CHR_02	LDY #27
	LDA #40
&CHR_01	STA (BB),Y
	DEY
	BNE &CHR_01
	LDA #00
	STA (BB),Y
	JSR &NL_BB
	DEX
	BNE &CHR_02
	RTS

&NL_BB	LDA BB
	CLC
	ADC #28
	STA BB
	LDA BC
	ADC #00
	STA BC
	RTS

&SETUP_HLOC
	LDA #00
	STA BB
	LDA #A0
	STA BC
	RTS


&PLOT_BORDERS
	LDA #29		'PLOT TOP LEFT CORNER
	STA BB
	LDA #A0
	STA BC
	LDX #$08
	LDY #00
&PCORN_01
	LDA :TOP_LEFT_CORNERR,X
	STA (BB),Y
'	LDA :TOP_LEFT_CORNERL,X
'	STA 625D,X
	JSR &NL_BB
	DEX
	BPL &PCORN_01
	LDA #4E		'PLOT TOP RIGHT CORNER
	STA BB
	LDA #A0
	STA BC
	LDX #$17
&PCORN_02	LDA :TOP_RIGHT_CORNER,X
	LDY #01
	STA (BB),Y
	DEY
	DEX
	LDA :TOP_RIGHT_CORNER,X
	STA (BB),Y
	JSR &NL_BB
	DEX
	BPL &PCORN_02
	LDA #B0		'PLOT BOTTOM LEFT CORNER
	STA BB
	LDA #BD
	STA BC
	LDX #$08
	LDY #01
&PCORN_03
	LDA :BOTTOM_LEFT_CORNERR,X
	STA (BB),Y
'	LDA :BOTTOM_LEFT_CORNERL,X
'	STA 631B,X
	JSR &NL_BB
	DEX
	BPL &PCORN_03
	LDA #D6		'PLOT BOTTOM RIGHT CORNER
	STA BB
	LDA #BD
	STA BC
	LDX #$17
&PCORN_04
	LDA :BOTTOM_RIGHT_CORNER,X
	LDY #01
	STA (BB),Y
	DEY
	DEX
	LDA :BOTTOM_RIGHT_CORNER,X
	STA (BB),Y
	JSR &NL_BB
	DEX
	BPL &PCORN_04
	LDA #B8		'PLOT SIDE BORDERS
	STA BB
	LDA #A1
	STA BC
	LDX #$176
	LDY #27
	LDA #%01000110
	STA (BB),Y
	JSR &NL_BB
&PLS_01
	LDA #%01010110
	STA (BB),Y
	JSR &NL_BB
	DEX
	BNE &PLS_01
	LDA #%01000110
	STA (BB),Y
	LDA #%01111111	'PLOT TOP/BOTTOM BORDERS
	LDX #$35
&PLS_02
	STA A02A,X
	STA A052,X
	STA A0A2,X
	STA BEF2,X
	STA BECA,X
	STA BE7A,X
	DEX
	BPL &PLS_02
	RTS


&DECRUNCH_PICTURE	'X=PICTURE INDEX
	LDA :PIC_CRUNCHED_LO,X
	STA BD
	LDA :PIC_CRUNCHED_HI,X
	STA BE
	LDA :PIC_SLOCL,X
	STA BB
	LDA :PIC_SLOCH,X
	STA BC
	LDA :PIC_WIDTH,X
	STA BA
	LDA :PIC_HEIGHT,X
	STA BF
	LDA #$40
	SEC
	SBC BA
	STA B9

	LDY #00
	STY 0202

	LDX BA
&DEPIC_01	LDY #00
	LDA (BD),Y
	CMP #$32
	BCC &DEPIC_08
	CMP #$64
	BCC &DEPIC_03
&DEPIC_08	STA (BB),Y
	JSR &INC_BD
	JSR &SORT_SCRN
	BCC &DEPIC_01
&DEPIC_07	RTS

&DEPIC_03 SEC
	SBC #$32
	STA B8
	JSR &INC_BD
	LDA (BD),Y
&DEPIC_04	STA (BB),Y
	PHA
	JSR &SORT_SCRN
	PLA
	BCS &DEPIC_07
	DEC B8
	BNE &DEPIC_04
	JSR &INC_BD
	JMP &DEPIC_01

&SORT_SCRN
	INC BB
	BNE 02
	INC BC
	DEX
	BNE &DEPIC_02
	LDX BA
	LDA BB
	CLC
	ADC B9
	STA BB
	LDA BC
	ADC #00
	STA BC
	DEC BF
	BEQ &DEPIC_06
&DEPIC_02	CLC
	RTS
&DEPIC_06 SEC
	RTS

&INC_BD	INC BD
	BNE 02
	INC BE
	RTS

'BB-BC TEXT SOURCE
'BD X
'BE Y
&PLOT_TEXT	'X=SCREEN NO.
	JSR &SETUP_KEY
	LDX FF
	LDA :TEXT_SOURCE_LO,X
	STA BB
	LDA :TEXT_SOURCE_HI,X
	STA BC
	LDA :TEXT_DISPLAY_X,X
	STA BD
	LDA :TEXT_DISPLAY_Y,X
	STA BE
&PLX_08	LDY #00
	STY B1
	LDA (BB),Y
	STA B3
	BPL &PLX_09
'80 = Standard Left Margin CR (=)
'81 = Left Margin for Page 5 (+)
'82 = Left Margin for Pages 1 and 4 (*)
'FF = END OF TEXT ())
	CMP #FF
	BNE &PLX_10
	RTS
&PLX_10	AND #03
	TAY
	LDA :LEFT_MARGIN,Y
	STA BD
	LDA BE
	CLC
	ADC #$08
	STA BE
	JMP &PLX_11
&PLX_09	SEC
	SBC #$32
	STA B4
	ASL
	ASL
	ROL B1
	ASL
	ROL B1
	STA B0
	LDA B1
	ADC #9D
	STA B1	'NOW GOT CHARACTER ADDRESS
	LDY #07
&PLX_01	LDA (B0),Y	'STORE CHARACTER IN BUFFER
	AND #3F
	STA 0240,Y
	LDA #00
	STA 0248,Y
	DEY
	BPL &PLX_01
	LDY BD
	LDA :XSHIFT,Y
	BEQ &PLX_04
	STA B2	'Now shift right for xshift steps
&PLX_03	LDX #07
&PLX_02	LSR 0240,X
	LDA 0248,X
	BCC 02
	ORA #40
	LSR
	STA 0248,X
	DEX
	BPL &PLX_02
	DEC B2
	BNE &PLX_03
&PLX_04	LDY #0F	'NOW MAKE SUITABLE FOR DISPLAYING ON HIRES SCREEN
&PLX_05	LDA 0240,Y
	ORA #40
	STA 0240,Y
	DEY
	BPL &PLX_05
	LDX BD    'NOW WORK OUT SCREEN LOCATION
	LDY BE
	JSR &CALC_SLOC
	LDY #00	'NOW GOT SCREEN LOCATION, SO PLOT CHARACTER
	LDX #00
&PLX_06	LDA 0240,X
	EOR #3F
	AND (B0),Y
	STA (B0),Y
	LDA 0248,X
	EOR #3F
	INY
	AND (B0),Y
	STA (B0),Y
	LDA 0202
	BNE &PLX_13
	JSR &DLY_03
	PHA
	JSR &INKEY
	BCC &PLX_12
	INC 0202
&PLX_12	LDA B3
	CMP #"."
	BNE &PLX_14
	JSR &DELAY
&PLX_14	CLC
	PLA
&PLX_13	DEY
	LDA B0
	ADC #28
	STA B0
	LDA B1
	ADC #00
	STA B1
	INX
	CPX #$08
	BCC &PLX_06
	LDY B4	'NOW GET CHAR AGAIN
	LDA :CHAR_WIDTH,Y	'AND MOVE RIGHT BY CHARACTER WIDTH
	CLC
	ADC BD
	STA BD
&PLX_11	INC BB	'INC TEXT
	BNE 02
	INC BC
	JMP &PLX_08

&CALC_SLOC
	LDA #00	'YPOS *40
	STA B1
	TYA
	ASL
	ROL B1
	ASL
	ROL B1
	ASL
	ROL B1
	STA B6	'STORE THE *8
	LDA B1
	STA B7
	LDA B6	'*32
	ASL
	ROL B1
	ASL
	ROL B1
	ADC B6    'ADD *8 TO GET *40
	STA B0
	LDA B1
	ADC B7
	STA B1
	LDA B0	'ADD XPOS
	ADC :XLOC,X
	STA B0
	LDA B1    'ADD REMAINDER + HIRES BASE
	ADC #A0
	STA B1
	RTS
~END
