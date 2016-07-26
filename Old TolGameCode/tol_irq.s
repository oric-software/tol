;irq driver

*=$9800
#include "main.h"

irq_driver
	sei
	lda #<tol_irq
	sta $fffe
	lda #>tol_irq
	sta $ffff
	lda #$20
	sta via_t1ll
	lda #$4e
	sta via_t1lh
	lda #%01111111
	sta via_ier
	lda #%11000000
	sta via_ier
	cli
	rts

tol_irq	sta tirq_01+1
	stx tirq_02+1
	sty tirq_03+1
	lda via_t1cl	;Clear IRQ
	jsr proc_ani	;Process Game Animations
	jsr proc_cdl	;Process Candle Animation
	jsr proc_sfx	;Process Sound Effects
	jsr proc_key	;Store Key and increment index
	jsr send_ayt	;Send AY table
	jsr read_key	;Read key and Store Key event
	jsr proc_cyc	;Process Colour Cycling for Icon Menu
	jsr calc_env	;Calculate_region
	jsr read_joy	;Read joystick
	jsr proc_tod	;process Time Of Day
	jsr proc_rnd	;Generate random_element
tirq_01	lda #00
tirq_02	ldx #00
tirq_03	ldy #00
	rti


;*********************** Process Key *****************************
;Keyboard reading occurs every irq, but for only one key
;so all 8 keys are scanned every 8 irq's (12 Hz)
proc_key	ldx key_index
	lda key_assignments,x
	lsr
	lsr
	lsr
	lsr
	tay
	lda key_column,y
	sta ay_column
	lda key_assignments,x
	and #15
	sta via_portb
	inx
	txa
	and #07
	sta key_index
	rts

key_column
 .byt %11111110
 .byt %11111101
 .byt %11111011
 .byt %11110111
 .byt %11101111
 .byt %11011111
 .byt %10111111
 .byt %01111111
key_bit
 .byt 1,2,4,8,16,32,64,128

key_index		.byt 0


;*********************** Read Key ********************************
read_key	lda via_portb
	ldx key_index
	and #08
	beq key_up_event
key_down_event
	lda key_bit,x
	ora key_press_register
	sta key_press_register
	rts
key_up_event
	lda key_bit,x
	eor #255
	and key_press_register
	sta key_press_register
	rts

;****************** Process Game Animations **********************
;Game animations always act on characters 40,41,42,43
;Their are 3 sets of game animations, and 8 frames per set.
;32bytes per frame
;8 frames per set
;3 Sets
;768 bytes
;animation_set in main.h is used to select the set (0-2)
;Animations set usage...
;Set 0
; Waves & Shingle on Shore (3 chars)
; Ripples in sea and in river(1 Char)
;Set 1
; Fire pit flame (2 Chars)
; Wall Flame Torch (1 Char)
; Stars in Underwurlde (1 Char)
;Set2
; Ripples by Bridge (2 Chars)
; River Ripples (1 Char)
; River Twig Ripple (1 Char)

proc_ani	lda animation_set	;*192
	ora #$B0	;Animation base (Guess!)
	sta $E1
	lda animation_frame
	adc #01
	and #07
	sta animation_frame
	lsr
	ror
	ror
	ror
	sta $E0
	ldy #31
pani_01	lda ($e0),y
	sta $b400+8*40,y
	dey
	bpl pani_01
cffa_02	rts

animation_frame
;******************** Process Candle *********************
;Candle height is only updated when a change is detected
;Candle animation occurs every 8th interrupt?

proc_cdl	lda hero_health
	cmp candle_health
	beq cffa_02
	sta candle_health
plot_candle_and_stem
	lda #47
	sec
	sbc hero_health
	pha
	and #07
	sta ypos_in_char
	lda #<$bb80+36+40*18
	sta $80
	lda #>$bb80+36+40*18
	sta $81
	ldx #00
	pla
	lsr	;/8
	lsr
	lsr
	sta ypos_on_screen
	beq pcas_05
pcas_01	ldy #02	;Clear rows down to flame
	lda #09
	sta ($80),y
	dey
	sta ($80),y
	lda #40
	jsr add_80
	inx
	cpx ypos_on_screen
	bcc pcas_01
pcas_05	ldx #08	;Display Flame
pcas_02	ldy candle_offset,x
	lda candle_char,x
	sta ($80),y
	dex
	bpl pcas_02
	lda #120	;Display remaining Stem
	ldx ypos_on_screen
	inx
	inx
pcas_03	jsr add_80
	inx
	cpx #08
	bcs pcas_04
	ldy #02
	lda #64
	sta ($80),y
	dey
	lda #62
	sta ($80),y
	dey
	lda #07
	sta ($80),y
	lda #40
	jmp pcas_03
pcas_04	lda flame_anim_delay
	adc #64
	sta flame_anim_delay
	lda flame_anim_frame
	bcc pcas_06
	adc #00
	and #03
	sta flame_anim_frame
pcas_06	cmp #03
	bcc cffa_01
	lda #01
cffa_01	ldy ypos_in_char
redef_candle_anim_in_char
	asl	;*32
	asl
	asl
	asl
	asl
	sta pcaic_06+1
	ora #$10
	sta pcaic_05+1
	tya
	adc #16
	sta irq_temp_02
	sty irq_temp_01
	tya
	beq pcaic_02
	ldy #00
	;Clear Top of candle
	tya
pcaic_01	sta $bad8,y
	sta $baf0,y
	iny
	cpy irq_temp_01
	bcc pcaic_01
pcaic_02	ldx #00
pcaic_06	lda $b800,x ;Store frame to chardef
	sta $bad8,y
pcaic_05	lda $b800,x
	sta $baf0,y
	inx
	iny
	cpy irq_temp_02
	bcc pcaic_06
	ldx temp_01
pcaic_03	cpy #24	  ;Fill remainder with Stem
	bcs pcaic_04
	lda $b800+8*62,x
	sta $bad8,y
	lda $b800+8*64,x
	sta $baf0,y
	inx
	iny
	jmp pcaic_03
pcaic_04	rts

add_80	clc
	adc $80
	sta $80
	bcc add_801
	inc $81
	clc
add_801	rts

candle_offset
 .byt 0,40,80
 .byt 1,41,81
 .byt 2,42,82
candle_char
 .byt 1,4,3
 .byt 91,92,93
 .byt 94,95,96
flame_anim_frame	.byt 0
flame_anim_delay	.byt 0
ypos_on_screen	.byt 0
ypos_in_char	.byt 0
candle_health	.byt 0
irq_temp_01	.byt 0
irq_temp_02	.byt 0


;The actual number of frames displayed
;is 4, in sequence of 0,1,2,1

;y==Ypos in char(0-7)
;A==Flame Frame(0-2)
;   B800 - Flame Frame 0
;   B820 - Flame Frame 1
;   B840 - Flame Frame 2

;************************* Process Sfx ************************

proc_sfx	rts

;************************* Send AY ****************************
send_ayt	;Send AY table
	ldx #14
say_02	lda ay_table,x
	cmp ay_refer,x
	beq say_01
	sta ay_refer,x
	ldy ay_register,x
	sty via_porta
	ldy #$ff
	sty via_pcr
	ldy #$dd
	sty via_pcr
	sta via_porta
	lda #$FD
	sta via_pcr
	sty via_pcr
say_01	dex
	bpl say_02
	rts

ay_table
 .byt 0,0,0	;ay pitch lo
 .byt 0,0,0	;ay pitch hi
 .byt 0		;ay noise
 .byt %01000000	;ay status
 .byt 0,0,0	;ay Volume
 .byt 0,0		;ay period
 .byt 0		;ay cycle
ay_column
 .byt 0		;ay key column
ay_refer
 .byt 0,0,0
 .byt 0,0,0
 .byt 0
 .byt %01000000
 .byt 0,0,0
 .byt 0,0
 .byt 0
 .byt 0
ay_register
 .byt 0,3,1,4,2,5
 .byt 6
 .byt 7
 .byt 8,9,10
 .byt 11,12
 .byt 13
 .byt 14

;********************* Process Colour Cycling **********************
;6 frames of 5 bytes
proc_cyc	lda colour_cycle
	bmi pcyc_02
	dec colour_cycle
	bpl pcyc_01
	lda #11
	sta colour_cycle
pcyc_01	ldy colour_cycle
	lda colour_for_frame,y
	sta $a000+40
	sta $a000+40*19
pcyc_02	rts

colour_for_frame
 .byt 4,1,5,2,6,3,7,3,6,2,5,1

;********************** Calculate region ***********************
;Calculate region bytes 0 and 1 from hero x/y

calc_env	lda hero_yl
	asl
	lda hero_yh
	rol
	asl
	asl
	asl
	asl
	ora hero_xh
	tay
	lda $0900,y
	sta region_byte0
	lda $0a00,y
	sta region_byte1
	rts

;********************** Read Joystick *************************

read_joy	lda control_type
	beq
	lda machine_type
	cmp #01
	bne Read IJK joystick
read_telestrat_joystick
	lda control_type	;1/2 >> 64/128
	lsr
	ror
	ror
	sta tel_joystick
	nop
	nop
	lda tel_joystick
	and #31
	tay
	lda tel_secondfire
	and #80
	eor #80
	lsr
	lsr
	ora tele_code,y
	ora key_press_register
	sta key_press_register
	rts
Read IJK joystick
	rts

tele_code
 .dsb 32,0	;replace with actual codes, when known!!



;******************* Process Time Of Day **********************
;time of day...
;period of one day is 24 minutes,one hour is therefore 1 minute (everything measured in 1 hour periods)
;irq operates at 50hz, so need to count 3000(50*60) for 1 minute
proc_tod
	lda tod_counter_lo
	bne tod_03
	dec tod_counter_hi
	beq hour_expired
tod_03	dec tod_counter_lo
	rts
hour_expired
	lda #$b8
	sta tod_counter_lo
	lda #$0b
	sta tod_counter_hi
	inc hour_of_day
	lda hour_of_day
	cmp #24
	bcc tod_04
	lda #00
	sta hour_of_day
tod_04    ldx #03
tod_05	cmp time_of_day-1,x
	beq tod_06
	dex
	bne tod_05
tod_06	stx tod_alarm
tod_03	rts

time_of_day
 .byt 04	;1 Morning
 .byt 12	;2 Midday
 .byt 20	;3 Nightfall

;******************** Generate random_element **********************

proc_rnd	lda via_t1cl
	eor via_t2ch
	sbc key_press_register
	adc tod_counter_lo
	sta random_element
	rts
