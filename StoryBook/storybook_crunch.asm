;Storybook MC
;0200 HOLDS SELECTED HERO

*=$500
/*FIXME Crash on the seven screen !*/


#define	tmp0 $00

; Destination adress where we depack
#define		tmp1	$02

; Point on the end of the depacked stuff
#define	tmp2 $04

; Temporary used to hold a pointer on depacked stuff
#define 	tmp3 $06

; Temporary
#define tmp4 $08

#define reg0 $0a
#define reg1 $0c
#define reg2 $0e
#define reg3 $10

;#define sp 12


#define	ptr_source			tmp0

; Destination adress where we depack
#define	ptr_destination		tmp1

; Point on the end of the depacked stuff
#define	ptr_destination_end	tmp2

; Temporary used to hold a pointer on depacked stuff
#define ptr_source_back		tmp3




DRIVER
	LDA #$00
	STA $0200
	STA $0201
	SEI
	JSR SOFT_HIRES ; Switch to Hires
	LDX #$00
	STX $FF
DRV_01
	JSR CLEAR_HIRES
	JSR PLOT_BORDERS
	JSR ORIGINAL_OPEN
	LDX $FF
	CPX #$08
	BCC DRV_21
	TXA
	CLC
	ADC $0200
	TAX
	STX $FF
	JSR DECRUNCH_PICTURE
	JSR PLOT_TEXT
	JSR GET_ANY_KEY
	JSR ORIGINAL_CLOSE
	CLI
	RTS
DRV_21
	LDX $FF
	CPX #$07
	BNE DRV_10
	JSR DRV_08
	LDX $FF
DRV_10
	JSR DECRUNCH_PICTURE
	JSR PLOT_TEXT
	LDX $FF
	CPX #$07
	BNE DRV_02
	JSR SELECT
	JMP DRV_20
DRV_02
	JSR GET_ANY_KEY
DRV_20
	JSR ORIGINAL_CLOSE
	INC $FF
	JMP DRV_01

ORIGINAL_OPEN
	LDA #$78
	STA $BD
	LDA #$A0
	STA $BB
	LDA #$AF
	STA $BC
	STA $BE
	LDA #00
	STA $BF
	LDX #99
OO_01
	LDY #$27
OO_02
	LDA ($BD),Y
	EOR #$3F
	STA ($BD),Y
	LDA ($BB),Y
	EOR #$3F
	STA ($BB),Y
	DEY
	BNE OO_02
	lda datas_hcol,x
	STA ($BD),Y
	LDY $BF
	lda datas_hcol+100,y
	LDY #$00
	STA ($BB),Y
	INC $BF
	JSR LL_BD
	JSR NL_BB
	JSR DELAY
	DEX
	BPL OO_01
	RTS

LL_BD
	LDA $BD
	SEC
	SBC #$28
	STA $BD
	BCS j1
	DEC $BE
j1
	RTS

ORIGINAL_CLOSE
	JSR SETUP_HLOC
	LDA #$18
	STA $BD
	LDA #$BF
	STA $BE
	LDX #99
OC_02
	LDY #$27
	LDA #$40
OC_01
	STA ($BB),Y
	STA ($BD),Y
	DEY
	BNE OC_01
	TYA
	STA ($BB),Y
	STA ($BD),Y
	JSR NL_BB
	JSR LL_BD
	JSR DELAY
	DEX
	BPL OC_02
	RTS

SELECT
	JSR GET_LRKEYS
	CMP #$01
	BNE SLC_04
	LDA $0200
	BEQ SLC_01
	DEC $0200
	JMP SLC_03
SLC_04
	CMP #$02
	BNE SLC_05
	LDA $0200
	CMP #$02
	BEQ SLC_01
	INC $0200
	JMP SLC_03
SLC_05
	CMP #$04
	BNE SLC_01
	RTS
SLC_03
	LDA #$07
	STA $0205
	LDX #$07
	JSR DECRUNCH_PICTURE
SLC_01
	JSR CONTROL_SELECTION
	LDA $0205

	BEQ SLC_02
	DEC $0205

SLC_02
	JMP SELECT

CONTROL_SELECTION
	LDA #$00
	STA $B6
	LDA $0200
	CMP #$01
	BNE CS_01
	JSR SETUP_XAFADE
	LDY #$00
	JSR SHADE_HERO
CS_02
	JSR SETUP_XAFADE
	LDY #$02
	JMP SHADE_HERO
CS_01
	BCS CS_03
	JSR CS_02
CS_04
	JSR SETUP_XAFADE
	LDY #$01
	JMP SHADE_HERO
CS_03
	JSR CS_04
	JSR SETUP_XAFADE
	LDY #$00
	JMP SHADE_HERO

SETUP_XAFADE
	LDY $0205
	LDA A_GREYSCALE,Y
	LDX X_GREYSCALE,Y
	RTS

SHADE_HERO
	STA $B9
	STX $B8
	LDA HERO_SCNL,Y
	STA $BB
	LDA HERO_SCNH,Y
	STA $BC
	LDA HERO_SOURCEL,Y
	STA $BD
	LDA HERO_SOURCEH,Y
	STA $BE
	LDA HERO_WIDTH,Y
	STA $BF
	LDX HERO_HEIGHT,Y
HBH_03
	LDA $B6
	EOR #$01
	STA $B6
	TAY
	LDA $00B8,Y
	STA $B7
	LDY $BF
	DEY
HBH_02
;	LDA ($BD),Y
;	STA ($BB),Y
	LDA ($BB),Y	;SCREEN
	AND #$7F
	CMP #$40
	BCC HBH_01
	AND $B7
	STA $BA
	LDA ($BB),Y
	AND ($BD),Y	;MASK
	ORA $BA

	STA ($BB),Y
HBH_01
	DEY
	BPL HBH_02
	LDA $B9
	EOR #%111111
	STA $B9
	LDA $BD
	CLC
	ADC $BF
	STA $BD
	BCC j2
	INC $BE
j2
	JSR NL_BB
	DEX
	BNE HBH_03
	RTS








DELAY
	PHA
	TYA
	PHA
	TXA
	PHA
	LDX #$00
DLY_02
	LDY #$10
DLY_01
	DEY
	BPL DLY_01
	DEX
	BNE DLY_02
	PLA
	TAX
	PLA
	TAY
	PLA
	RTS
DLY_03
	PHA
	TYA
	PHA
	TXA
	PHA
	LDX #$04
	LDY #$00
DLY_04
	NOP
	INY
	BNE DLY_04
	DEX
	BNE DLY_04
	PLA
	TAX
	PLA
	TAY
	PLA
	RTS


GET_ANY_KEY
	JSR INKEY
	BCC GET_ANY_KEY
	RTS

INKEY
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA #$00
	JSR SETUP_KEY
GAK_02
	LDX #$07
GAK_01
	STX $0300

	LDA $0300

	AND #$08
	CMP #$08
	BCS GAK_03
	DEX
	BPL GAK_01
GAK_03
	PLA
	TAY
	PLA
	TAX
	PLA
	RTS


GET_LRKEYS
	LDA #$00
	STA $0208
	LDA #$04
	STA $0300
	LDA #$DF
	JSR SETUP_KEY
	LDA $0300
	AND #$08
	BEQ GLRK_01
	LDA #$01
	STA $0208
	RTS
GLRK_01
	LDA #$7F
	JSR SETUP_KEY
	LDA $0300
	AND #$08
	BEQ GLRK_02
	LDA #$02
	STA $0208
	RTS
GLRK_02
	LDA #$FE
	JSR SETUP_KEY
	LDA $0300
	AND #$08
	BEQ GLRK_03
	LDA #$04
	STA $0208
GLRK_03
	RTS

SETUP_KEY
	LDX #$0E
	STX $030F
	LDX #$FF
	STX $030C
	LDX #$DD
	STX $030C
	STA $030F
	LDY #$FD
	STY $030C
	STX $030C
	RTS

DRV_08
	LDA #$62
	STA $BB
	LDA #$A1
	STA $BC
	LDX #$5F
	LDY #$00
DRV_09
	LDA #%10000111
	STA ($BB),Y
	JSR NL_BB
	DEX
	BNE DRV_09
	RTS


SOFT_HIRES
	CLC
	JSR SETUP_HLOC     ;CLEAR DOWN ALL MEMORY AREA WITH ZERO
	LDY #$00
	TYA
	LDX #$20
SHR_01
	STA ($BB),Y
	INY
	BNE SHR_01
	INC $BC
	DEX
	BNE SHR_01
	LDA #30		;WRITE HIRES SWITCH
	STA $BF40
	JSR SETUP_HLOC	;CLEAR HIRES WITH #$40
	LDX #200
SHR_04
	LDY #39
SHR_05
	LDA #$40
	STA ($BB),Y
	DEY
	BPL SHR_05
	JSR NL_BB
SHR_02
	DEX
	BNE SHR_04
	RTS

CLEAR_HIRES

	JSR SETUP_HLOC
	LDX #200
CHR_02
	LDY #$27
	LDA #$40
CHR_01
	STA ($BB),Y
	DEY
	BNE CHR_01
	LDA #$00
	STA ($BB),Y
	JSR NL_BB
	DEX
	BNE CHR_02
	RTS
/*Checked*/
NL_BB
	LDA $BB
	CLC
	ADC #$28
	STA $BB
	LDA $BC
	ADC #$00
	STA $BC
	RTS
/*Checked*/
SETUP_HLOC
	LDA #$00
	STA $BB
	LDA #$A0
	STA $BC
	RTS

/*Checked*/
PLOT_BORDERS
	LDA #$29		;PLOT TOP LEFT CORNER
	STA $BB
	LDA #$A0
	STA $BC
	LDX #08
	LDY #$00
PCORN_01
	LDA TOP_LEFT_CORNERR,X
	STA ($BB),Y
;	LDA TOP_LEFT_CORNERL,X
;	STA $625D,X
	JSR NL_BB
	DEX
	BPL PCORN_01
	LDA #$4E		;PLOT TOP RIGHT CORNER
	STA $BB
	LDA #$A0
	STA $BC
	LDX #17

PCORN_02
	LDA TOP_RIGHT_CORNER,X
	LDY #$01
	STA ($BB),Y
	DEY
	DEX
	LDA TOP_RIGHT_CORNER,X
	STA ($BB),Y
	JSR NL_BB
	DEX
	BPL PCORN_02
	LDA #$B0		;PLOT BOTTOM LEFT CORNER
	STA $BB
	LDA #$BD
	STA $BC
	LDX #08
	LDY #$01
PCORN_03
	LDA BOTTOM_LEFT_CORNERR,X
	STA ($BB),Y
;	LDA BOTTOM_LEFT_CORNERL,X
;	STA $631B,X
	JSR NL_BB
	DEX
	BPL PCORN_03
	LDA #$D6		;PLOT BOTTOM RIGHT CORNER
	STA $BB
	LDA #$BD
	STA $BC
	LDX #17
PCORN_04
	LDA BOTTOM_RIGHT_CORNER,X
	LDY #$01
	STA ($BB),Y
	DEY
	DEX
	LDA BOTTOM_RIGHT_CORNER,X
	STA ($BB),Y
	JSR NL_BB
	DEX
	BPL PCORN_04
	LDA #$B8		;PLOT SIDE BORDERS
	STA $BB
	LDA #$A1
	STA $BC
	LDX #176
	LDY #$27
	LDA #%01000110
	STA ($BB),Y
	JSR NL_BB
PLS_01
	LDA #%01010110
	STA ($BB),Y
	JSR NL_BB
	DEX
	BNE PLS_01
	LDA #%01000110
	STA ($BB),Y
	LDA #%01111111	;PLOT TOP/BOTTOM BORDERS
	LDX #35
PLS_02
	STA $A02A,X
	STA $A052,X
	STA $A0A2,X
	STA $BEF2,X
	STA $BECA,X
	STA $BE7A,X
	DEX
	BPL PLS_02
	RTS


DECRUNCH_PICTURE
	;X=PICTURE INDEX

	LDA PIC_CRUNCHED_LO,X
	sta ptr_source

	LDA PIC_CRUNCHED_HI,X
	sta ptr_source+1

	lda #<buffer_decrunch
	STA $BD
	sta ptr_destination
	lda #>buffer_decrunch
	STA $BE
	sta ptr_destination+1
	txa
	pha
	jsr _file_unpack
	pla
	tax
	LDA PIC_SLOCL,X
	STA $BB
	LDA PIC_SLOCH,X
	STA $BC
	LDA PIC_WIDTH,X
	STA $BA
	LDA PIC_HEIGHT,X
	STA $BF
	LDA #40
	SEC
	SBC $BA
	STA $B9
	LDY #$00
	STY $0202
	LDX $BA
DEPIC_01
	LDY #$00
	LDA ($BD),Y
	CMP #32
	BCC DEPIC_08
	CMP #64
	BCC DEPIC_03
DEPIC_08
	STA ($BB),Y
	JSR INC_BD
	JSR SORT_SCRN
	BCC DEPIC_01
DEPIC_07
	RTS
DEPIC_03
	SEC
	SBC #32
	STA $B8
	JSR INC_BD
	LDA ($BD),Y
DEPIC_04
	STA ($BB),Y
	PHA
	JSR SORT_SCRN
	PLA
	BCS DEPIC_07
	DEC $B8
	BNE DEPIC_04
	JSR INC_BD
	JMP DEPIC_01

SORT_SCRN
	INC $BB
	BNE j3
	INC $BC
j3
	DEX
	BNE DEPIC_02
	LDX $BA
	LDA $BB
	CLC
	ADC $B9
	STA $BB

	LDA $BC
	ADC #$00
	STA $BC
	DEC $BF
	BEQ DEPIC_06
DEPIC_02
	CLC
	RTS
DEPIC_06
	SEC
	RTS
INC_BD
	INC $BD
	BNE j4
	INC $BE
j4
	RTS

;BB-BC TEXT SOURCE
;BD X
;BE Y
PLOT_TEXT
	;X=SCREEN NO.
	JSR SETUP_KEY
	LDX $FF
	LDA TEXT_SOURCE_LO,X
	STA $BB
	LDA TEXT_SOURCE_HI,X
	STA $BC
	LDA TEXT_DISPLAY_X,X
	STA $BD
	LDA TEXT_DISPLAY_Y,X
	STA $BE
PLX_08
	LDY #$00 ;FIXME
	STY $B1
	LDA ($BB),Y
	STA $B3
	BPL PLX_09
;80 = Standard Left Margin CR (=)
;81 = Left Margin for Page 5 (+)
;82 = Left Margin for Pages 1 and 4 (*)
;FF = END OF TEXT ())
	CMP #$FF
	BNE PLX_10
	RTS
PLX_10
	AND #$03
	TAY
	LDA LEFT_MARGIN,Y
	STA $BD
	LDA $BE
	CLC
	ADC #08
	STA $BE
	JMP PLX_11
PLX_09
	SEC
	SBC #32 ; We 'sbc'  in order to have the caracter index
	STA $B4 ; store in $b4
	ASL ; *2
	ASL ; *2
	ROL $B1
	ASL ;*2 (8)
	ROL $B1
	STA $B0
	; Add pos fonte
	lda #<datas_fonte /*Maybe a bug FIXME If $b0 >$ff after adc. if matter does not appear don't correct ! earn CPU time !!! JEDE*/
	adc $b0
 	sta $B0
	LDA $B1
	ADC #>datas_fonte ; High value
	;ADC #$9D ; High value FIXME
	STA $B1	;NOW
	LDY #$07
PLX_01
	LDA ($B0),Y;STORE	AND #$3F
	STA $0240,Y
	LDA #$00
	STA $0248,Y
	DEY
	BPL PLX_01
	LDY $BD
	LDA XSHIFT,Y
	BEQ PLX_04
	STA $B2	;Now
PLX_03
	LDX #$07
PLX_02
	LSR $0240,X
	LDA $0248,X
	BCC j5
	ORA #$40
j5
	LSR
	STA $0248,X
	DEX
	BPL PLX_02
	DEC $B2
	BNE PLX_03
PLX_04
	LDY #$0F;NOW MAKE SUITABLE FOR DISPLAYING ON HIRES SCREEN
PLX_05
	LDA $0240,Y
	ORA #$40
	STA $0240,Y
	DEY
	BPL PLX_05
	LDX $BD
	LDY $BE

	JSR CALC_SLOC

	LDY #$00	;NOW GOT SCREEN LOCATION, SO PLOT CHARACTER
	LDX #$00
PLX_06
	LDA $0240,X
	EOR #$3F
	AND ($B0),Y
	STA ($B0),Y
	LDA $0248,X
	EOR #$3F
	INY
	AND ($B0),Y
	STA ($B0),Y
	LDA $0202
	BNE PLX_13
	JSR DLY_03
	PHA
	JSR INKEY
	BCC PLX_12
	INC $0202

PLX_12
	LDA $B3
	CMP #"."
	BNE PLX_14
	JSR DELAY

PLX_14
	CLC
	PLA
PLX_13
	DEY
	LDA $B0
	ADC #$28
	STA $B0
	LDA $B1
	ADC #$00
	STA $B1
	INX
	CPX #08
	BCC PLX_06
	LDY $B4	;NOW
	LDA CHAR_WIDTH,Y	;AND MOVE RIGHT BY CHARACTER WIDTH
	CLC
	ADC $BD
	STA $BD

PLX_11
	INC $BB;INC
	BNE j6
	INC $BC
j6
	JMP PLX_08

CALC_SLOC
	LDA #$00	;YPOS *40
	STA $B1
	TYA
	ASL
	ROL $B1
	ASL
	ROL $B1
	ASL
	ROL $B1
	STA $B6	;STORE
	LDA $B1
	STA $B7
	LDA $B6	;*32
	ASL
	ROL $B1
	ASL
	ROL $B1
	ADC $B6
	STA $B0
	LDA $B1
	ADC $B7
	STA $B1
	LDA $B0	;ADD
	ADC XLOC,X
	STA $B0
	LDA $B1
	ADC #$A0
	STA $B1
	RTS
/*DATAS*********************************/
;~END



;when we stick into buffer
;PIC_SLOCL
;[4212D24282104FD2D0D1C7]
;PIC_SLOCH
;[65646C656B6E6562626262]
PIC_SLOCL
;1
.byt $C1
;2
.byt $91
;3
.byt $51
;4
.byt $C1
;5
.byt $01
;6
.byt $8F
;7
.byt $CE
/*8*/

.byt $43
;.byt $49
.byt $51
.byt $4F
.byt $51
PIC_SLOCH
;1
.byt $A3
;2
.byt $A2
;3
.byt $AB
;4
.byt $A3
;5
.byt $AA
;6
.byt $AC
;7
.byt $A3
;8
.byt $A1
.byt $A1
.byt $A1
.byt $A1

PIC_WIDTH
;1
.byt $17
;2
.byt $16
;3
.byt $16
;4
.byt $17
;5
.byt $16
;6
.byt $18
;7
.byt $19
;8
.byt $1F
.byt $14
.byt $16
.byt $15
PIC_HEIGHT
.byt $65,$65,$5E,$5E,$55,$60,$5E,$5F,$B6,$AE,$B6

PIC_CRUNCHED_LO
/*OK Collines 1*/
.byt <datas_picture1
/*OK Combattants 2*/
.byt <datas_picture2
/*OK 3 Phare*/
.byt <datas_picture3
/*OK Chateau 4*/
.byt <datas_picture4
/*OK 2 hommes parlent 5*/
.byt <datas_picture5
/*OK  ROI 6*/
.byt <datas_picture6
/*OK Personne de dos 7*/

.byt <datas_picture7

.byt <datas_picture11
/*Erreur*/

.byt <datas_picture8

.byt <datas_picture9
.byt <datas_picture10
.byt <datas_picture11
PIC_CRUNCHED_HI
.byt >datas_picture1
.byt >datas_picture2
.byt >datas_picture3
.byt >datas_picture4
.byt >datas_picture5
.byt >datas_picture6
/*OK Personne de dos 7*/
.byt >datas_picture7
.byt >datas_picture11
.byt >datas_picture8
;.byt >datas_pictures+$3d05
.byt >datas_picture9
.byt >datas_picture10
.byt >datas_picture11

TEXT_SOURCE_LO
.byt <datas_text
.byt <datas_text+$1e5
.byt <datas_text+$3fa
.byt <datas_text+$5fd
.byt <datas_text+$7f1
/*OK Personne de dos 7*/
.byt <datas_text+$9f1
.byt <datas_text+$bb4
.byt <datas_text+$d8f
.byt <datas_text+$ec6
.byt <datas_text+$f73
.byt <datas_text+$102C

TEXT_SOURCE_HI
.byt >datas_text
.byt >datas_text+$1e5
.byt >datas_text+$3fa
.byt >datas_text+$5fd
.byt >datas_text+$7f1
/*OK Personne de dos 7*/
.byt >datas_text+$9f1

.byt >datas_text+$bb4
.byt >datas_text+$d8f

.byt >datas_text+$ec6
.byt >datas_text+$f73
.byt >datas_text+$102C


TEXT_DISPLAY_X
.byt $96,$0C,$0C,$96,$0C,$0C,$0C,$0C,$0C,$0C,$0C
TEXT_DISPLAY_Y
.byt $10,$10,$10,$10,$10,$10,$10,$78,$30,$20,$30

LEFT_MARGIN
.byt $0B,$8A,$90
CHAR_WIDTH	;32-127
.byt $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
.byt $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
.byt $01,$01,$01,$01,$01,$01
.byt $06,$06,$06,$06,$05,$04,$06,$06,$04,$04,$06,$04,$06,$06,$06,$06,$06,$06,$06,$05,$06,$05,$06,$06,$06,$06
XLOC
.byt $00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05
.byt $06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$08,$08,$08,$08,$08,$08,$09,$09,$09,$09,$09,$09,$0A,$0A,$0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0B,$0B
.byt $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D,$0D,$0D,$0E,$0E,$0E,$0E,$0E,$0E,$0F,$0F,$0F,$0F,$0F,$0F,$10,$10,$10,$10,$10,$10,$11,$11,$11,$11,$11,$11
.byt $12,$12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$14,$14,$14,$14,$14,$15,$15,$15,$15,$15,$15,$16,$16,$16,$16,$16,$16,$17,$17,$17,$17,$17,$17
.byt $18,$18,$18,$18,$18,$18,$19,$19,$19,$19,$19,$19,$1A,$1A,$1A,$1A,$1A,$1A,$1B,$1B,$1B,$1B,$1B,$1B,$1C,$1C,$1C,$1C,$1C,$1C,$1D,$1D,$1D,$1D,$1D,$1D
.byt $1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F,$1F,$1F,$1F,$1F,$20,$20,$20,$20,$20,$20,$21,$21,$21,$21,$21,$21,$22,$22,$22,$22,$22,$22,$23,$23,$23,$23,$23,$23
.byt $24,$24,$24,$24,$24,$24,$25,$25,$25,$25,$25,$25,$26,$26,$26,$26,$26,$26,$27,$27,$27,$27,$27,$27
XSHIFT
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05
.byt $00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05,$00,$01,$02,$03,$04,$05

TOP_LEFT_CORNERR
.byt %01101100,%01101100,%01110000,%01011100,%01000100
.byt %01110000,%01010000,%01100001,%01111101
BOTTOM_LEFT_CORNERR
.byt %01111101,%01100001,%01010000,%01110000,%01000100
.byt %01011100,%01110000,%01101100,%01101100

TOP_RIGHT_CORNER
.byt %01001101,%01100010
.byt %01001101,%01000010
.byt %01000011,%01011010
.byt %01001110,%01010110
.byt %01001000,%01111100
.byt %01000011,%01110000
.byt %01000010,%01100010
.byt %01100001,%01100100
.byt %01101111,%01001010
BOTTOM_RIGHT_CORNER
.byt %01101111,%01001010
.byt %01100001,%01100100
.byt %01000010,%01100010
.byt %01000011,%01110000
.byt %01001000,%01111100
.byt %01001110,%01010110
.byt %01000011,%01011010
.byt %01001101,%01000010
.byt %01001101,%01100010
HERO_SCNL
.byt $7F,$D0,$E7
HERO_SCNH
.byt $A5,$A3,$A2

HERO_SOURCEL
.byt <datas_mask+1,<datas_mask+$264+1,<datas_mask+$4dc+1
HERO_SOURCEH
.byt >datas_mask+1,>datas_mask+$264+1,>datas_mask+$4dc+1
/*
HERO_SOURCEL
.byt $24,$88,$00
HERO_SOURCEH
.byt $63,$65,$68
*/
HERO_HEIGHT
.byt $44,$4F,$55
HERO_WIDTH
.byt $09,$08,$0B
X_GREYSCALE
.byt %000000,%001000,%100100,%101010,%101110,%110110,%111011,%111111
A_GREYSCALE
.byt %000000,%000001,%010010,%010101,%111010,%011011,%101111,%111111
; PICTURES.MEM
;

datas_pictures
datas_picture1
#include "include/picture1cru.h"
datas_picture2
#include "include/picture2cru.h"
datas_picture3
#include "include/picture3cru.h"
datas_picture4
#include "include/picture4cru.h"
datas_picture5
#include "include/picture5cru.h"
datas_picture6
#include "include/picture6cru.h"
datas_picture7
#include "include/picture7cru.h"
datas_picture8
#include "include/picture8cru.h"
datas_picture9
#include "include/picture9cru.h"
datas_picture10
#include "include/picture10cru.h"
datas_picture11
#include "include/picture11cru.h"

; HCOL.MEM
datas_hcol
#include "include/hcol.h"
datas_mask
#include "include/maskmem.h"
/*TEXT ASCII for history*/
datas_fonte
#include "include/fonte.h"
datas_text
#include "include/text.h"
; Original source  9D00
; include UNPACKER !
/*ROUTINES !*/
#include "lib/unpack.asm"
buffer_decrunch
.dsb 2400,17


; 63 ???



