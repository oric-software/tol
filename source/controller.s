// Controller Drivers
// To reduce memory wastage, each type of Controller has separate code.

// Each controller runs in parallel of the keyboard Controller linking in to the same Controller
// key-down register

#define	via1_portb	 $0300	;Oric/Atmos/Telestrat
#define	via1_portahs         $0301
#define	via1_ddrb            $0302
#define	via1_ddra            $0303
#define	via1_t1cl            $0304
#define	via1_t1ch            $0305
#define	via1_t1ll            $0306
#define	via1_t1lh            $0307
#define	via1_t2ll            $0308
#define	via1_t2ch            $0309
#define	via1_sr              $030a
#define	via1_acr             $030b
#define	via1_pcr             $030c
#define	via1_ifr             $030d
#define	via1_ier             $030e
#define	via1_porta           $030f

#define	via2_portb	 $0320	;Telestrat Only
#define	via2_portahs         $0321
#define	via2_ddrb            $0322
#define	via2_ddra            $0323
#define	via2_t1cl            $0324
#define	via2_t1ch            $0325
#define	via2_t1ll            $0326
#define	via2_t1lh            $0327
#define	via2_t2ll            $0328
#define	via2_t2ch            $0329
#define	via2_sr              $032a
#define	via2_acr             $032b
#define	via2_pcr             $032c
#define	via2_ifr             $032d
#define	via2_ier             $032e
#define	via2_porta           $032f

// Generic table required by all Joystick Driver Routines
key_equiv
 .byt 1,2,4,8
 .byt 1+16,2+16,4+16,8+16,16,32


// Controller: IJK Left Joystick
ijk_driver_left
	ldy #%00010000
	sty via1_ddrb
	lda #%00000000
	sta via1_portb
	lda #%11000000
	sta via1_ddra
	lda #%01111111
	sta via1_porta
	lda via1_porta
	ldx #%11111111
	stx via1_ddra
	ldx #%10110111
	stx via1_ddrb
	sty via1_portb
	ldx #08
.(
loop1	cmp idl_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
ijk_driver_init
	rts

idl_code
 .byt %10101111,%10110111,%10111101,%10111110	;udlr No Fire
 .byt %10101011,%10110011,%10111001,%10111010     ;udir With Fire
 .byt %10111011                                   ;Fire Only

1 Right
2 Left
4 Fire
8 Down
16 Up


// Controller: IJK Right Joystick
ijk_driver_right
	ldy #%00010000
	sty via1_ddrb
	lda #%00000000
	sta via1_portb
	lda #%11000000
	sta via1_ddra
	lda #%10111111
	sta via1_porta
	lda via1_porta
	ldx #%11111111
	stx via1_ddra
	ldx #%10110111
	stx via1_ddrb
	sty via1_portb
	ldx #08
.(
loop1	cmp idr_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
ijk_driver_init
	rts

idr_code
 .byt %01101111,%01110111,%01111101,%01111110	;udlr No Fire
 .byt %01101011,%01110011,%01111001,%01111010     ;udir With Fire
 .byt %01111011                                   ;Fire Only

// Controller: PASE Left Joystick
pase_driver_init
	lda #c0
	sta via1_ddra
	rts

pase_driver_left
	lda #80
	sta via1_porta
	lda via1_porta
	ldx #07
.(
loop1	cmp pdl_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
	rts

pdl_code
 .byt %10101111,%10110111,%10111110,%10111101	;udlr No Fire
 .byt %10001111,%10010111,%10011110,%10011101	;udir With Fire
 .byt %10011111				;Fire Only


// Controller: PASE Right Joystick
pase_driver_right
	lda #40
	sta via1_porta
	lda via1_portahs
	ldx #08
.(
loop1	cmp pdr_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
	rts

pdr_code
 .byt %01101111,%01110111,%01111110,%01111101     ;udlr No Fire
 .byt %01001111,%01010111,%01011110,%01011101     ;udir With Fire
 .byt %01011111                                   ;Fire Only


// Controller: Telestrat Left Joystick
telestrat_driver_left
	lda #%01000000
	sta via2_portb
	lda via2_portb
	and #%00011111
	ldy via2_porta
	bmi skip2
	ora #%00100000
skip2	ldx #09	;cursors,cursors+fire1,fire1,fire2
.(
loop1	cmp tdl_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
telestrat_driver_init
	rts


tdl_code
 .byt %10010000,%10001000,%10000010,%10000001     ;udlr No Fire
 .byt %10010100,%10001100,%10000110,%10000101     ;udir With Fire
 .byt %10000100,%10100000                         ;Fire1 Only, Fire2 Only


// Controller: Telestrat Right Joystick
telestrat_driver_right
	lda #%10000000
	sta via2_portb
	lda via2_portb
	and #%00011111
	ldy via2_porta
	bmi skip2
	ora #%00100000
skip2	ldx #08
.(
loop1	cmp tdr_code,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	lda key_equiv,x
.)
	ora key_register
	sta key_register
	rts


tdr_code
 .byt %01010000,%01001000,%01000010,%01000001     ;udlr No Fire
 .byt %01010100,%01001100,%01000110,%01000101     ;udir With Fire
 .byt %01000100,%01100000                         ;Fire1 Only, Fire2 Only


;This is the contents of the key_register
;0        Up		Move Up				Options Up
;1	Down		Move Down				Options Down
;2	Left		Move Left		Icon Left
;3	Right		Move Right	Icon Right
;4	Fire		Use / Hit		Select Icon	Select Option
;5	Space		Icon Menu		Resume Game	Options Exit



;Autodetect:-
; Keyset #1 (Traditional) ZX/' and Space
; Keyset #2 (Oric) Cursors + Function
; Keyset #3 (Emulator) Cursors + Left Ctrl
; IJK Left Joystick
; IJK Right Joystick
; PASE Left Joystick
; PASE Right Joystick
; Telestrat Left Joystick
; Telestrat Right Joystick

autodetect_controller
	lda #


Display_porta_readings

ijk_driver_right
	ldy #%00010000
	sty via1_ddrb
	lda #%00000000
	sta via1_portb
	lda #%11000000
	sta via1_ddra
	lda #%10111111
	sta via1_porta
	lda via1_porta
	ldx #%11111111


;DADB  PORT A
;>0>0  00000000
;>1>1
;>2>2  PORT B
;>3<3  00000000
;>4>4
;>5>5
;>6>6
;>7>7
;OUT>>

;Cursor to nav, space to toggle

driver
display_settings
	lda #
control_editor


strobe_setting
	lda ddra_setting
	sta via_ddrb
	lda ddrb_setting
	sta via_ddra
	lda portb_setting
	sta via_portb
	lda porta_setting
	sta via_porta
	lda via_portb
	ldx #
	jsr display_binary
	lda via_porta
	ldx #
	jsr display_binary
	;Restore ports
	lda #%11111000
	sta via_ddrb
	lda #%11111111
	sta via_ddra
	lda #00
	sta via_porta
	sta via_portb
	rts



detect_controller
	ldy #%00010000
	sty via1_ddrb
	lda #%00000000
	sta via1_portb
	lda #%11000000
	sta via1_ddra
	lda #%11111111
	sta via1_porta
	lda via1_porta
	and #%00111111
	cmp #%00011111
	beq ijk_interface
	cmp #%00111111
	beq pase_interface
	;No Joystick
	ldx #00
	jmp display_interface
ijk_interface
	ldx #04
	jmp display_interface
pase_interface
	ldx #08
display_interface
	ldy #00
loop1	lda interface_text,x
	sta $bb80,y
	inx
	iny
	cpy #04
	bcc loop1
	rts

interface_text
 .byt "NONE"
 .byt "IJK "
 .byt "PASE"
