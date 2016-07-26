*=$500

#define	via_portb	$0300
#define	via_t1cl  $0304
#define	via_t1ch  $0305
#define	via_t1ll  $0306
#define	via_t1lh  $0307
#define	via_t2ll  $0308
#define	via_t2ch  $0309
#define	via_shift $030a
#define	via_acr   $030b
#define	via_pcr   $030c
#define	via_ifr   $030d
#define	via_ier   $030e
#define	via_porta $030f


tolsfx_driver
	jsr irq_setup
	jsr setup_chars
	jsr clear_screen
tols_01	jsr display_effect_screen
	jsr display_help_for_channel
	jsr unflag_navigation_entry
	jsr control_driver
	jsr flag_navigation_entry
	jmp tols_01


key_ascii
 .byt 8,9,10,11
 .byt "CPEYVBN"
 .byt "-=",127," ",13
key_vector_lo
 .byt <navigate_left,<navigate_right,<navigate_down,<navigate_up
 .byt <control_control,<control_pitch,<control_period,<control_cycle
 .byt <control_volume,<control_pbend,<control_noise
 .byt <navigate_decrement,<navigate_increment,<navigate_delete,<navigate_toggle
 .byt <play_effect
key_vector_hi
 .byt >navigate_left,>navigate_right,>navigate_down,>navigate_up
 .byt >control_control,>control_pitch,>control_period,>control_cycle
 .byt >control_volume,>control_pbend,>control_noise
 .byt >navigate_decrement,>navigate_increment,>navigate_delete,>navigate_toggle
 .byt >play_effect

play_effect
	lda sfx_number
	sta $f3
	rts





clear_screen
	ldx #00
	lda #08
cscrn_01	sta $bb80,x
	sta $bc80,x
	sta $bd80,x
	sta $be80,x
	sta $bee0,x
	dex
	bne cscrn_01
	rts

add_00	clc
	adc 00
	sta 00
	lda 01
	adc #00
	sta 01
	rts




;In==
;A=lo
;X=hi
;Out==
;16 bit left justified decimal plotted to 00,y
display_decimal
	sty temp_y
	sta decimal_lo
	stx decimal_hi
	lda #48
	sta decimal_string
	sta decimal_string+1
	sta decimal_string+2
	sta decimal_string+3
	ldy #03
ddec_02	ldx #47
	sec
ddec_01	inx
	lda decimal_lo
	sbc exponential_table_lo,y
	sta decimal_lo
	lda decimal_hi
	sbc exponential_table_hi,y
	sta decimal_hi
	bcs ddec_01
	lda decimal_lo
	adc exponential_table_lo,y
	sta decimal_lo
	lda decimal_hi
	adc exponential_table_hi,y
	sta decimal_hi
	txa
	sta decimal_string,y
	dey
	bpl ddec_02
	ldx #03
ddec_03	lda decimal_string,x
	cmp #48
	bne ddec_05
	dex
	bne ddec_03
ddec_05	ldy temp_y
ddec_04	lda decimal_string,x
	ora highlight_flag
	sta (00),y
	iny
	dex
	bpl ddec_04
ddec_06	rts

exponential_table_lo
 .byt <1,<10,<100,<1000
exponential_table_hi
 .byt >1,>10,>100,>1000


sfx_address_lo
 .byt <effect_memory
 .byt <effect_memory+26*1
 .byt <effect_memory+26*2
 .byt <effect_memory+26*3
 .byt <effect_memory+26*4
 .byt <effect_memory+26*5
 .byt <effect_memory+26*6
 .byt <effect_memory+26*7
 .byt <effect_memory+26*8
 .byt <effect_memory+26*9
 .byt <effect_memory+26*10
 .byt <effect_memory+26*11
 .byt <effect_memory+26*12
 .byt <effect_memory+26*13
 .byt <effect_memory+26*14
 .byt <effect_memory+26*15
 .byt <effect_memory+26*16
 .byt <effect_memory+26*17
 .byt <effect_memory+26*18
 .byt <effect_memory+26*19
 .byt <effect_memory+26*20
 .byt <effect_memory+26*21
 .byt <effect_memory+26*22
 .byt <effect_memory+26*23
 .byt <effect_memory+26*24
 .byt <effect_memory+26*25
 .byt <effect_memory+26*26
 .byt <effect_memory+26*27
 .byt <effect_memory+26*28
 .byt <effect_memory+26*29
 .byt <effect_memory+26*30
 .byt <effect_memory+26*31
sfx_address_hi
 .byt >effect_memory
 .byt >effect_memory+26*1
 .byt >effect_memory+26*2
 .byt >effect_memory+26*3
 .byt >effect_memory+26*4
 .byt >effect_memory+26*5
 .byt >effect_memory+26*6
 .byt >effect_memory+26*7
 .byt >effect_memory+26*8
 .byt >effect_memory+26*9
 .byt >effect_memory+26*10
 .byt >effect_memory+26*11
 .byt >effect_memory+26*12
 .byt >effect_memory+26*13
 .byt >effect_memory+26*14
 .byt >effect_memory+26*15
 .byt >effect_memory+26*16
 .byt >effect_memory+26*17
 .byt >effect_memory+26*18
 .byt >effect_memory+26*19
 .byt >effect_memory+26*20
 .byt >effect_memory+26*21
 .byt >effect_memory+26*22
 .byt >effect_memory+26*23
 .byt >effect_memory+26*24
 .byt >effect_memory+26*25
 .byt >effect_memory+26*26
 .byt >effect_memory+26*27
 .byt >effect_memory+26*28
 .byt >effect_memory+26*29
 .byt >effect_memory+26*30
 .byt >effect_memory+26*31
channel4effect
 .dsb 32,0
effect_memory
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
 .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
decimal_string
 .byt 0,0,0,0,0

temp_y		.byt 0
temp_01		.byt 0
temp_02             .byt 0
temp_03		.byt 0
decimal_lo	.byt 0
decimal_hi	.byt 0








display_effect_screen
	jsr display_header
	jmp display_effect

display_header
	;Display just the template header
	lda #00
	sta highlight_flag
	ldx #39
dhead_01	lda header_text_overview,x
	sta $bb80,x
	dex
	bpl dhead_01
	;Now display effect number, remembering last position
	lda #<$bb80+10
	sta 00
	lda #>$bb80+10
	sta 01
	ldy #00
	lda sfx_number
	ldx #00
	jsr display_decimal
	ldx #00
	ldy #02
dhead_02	lda header_text_inlay,x
	iny
	sta (00),y
	inx
	cpx #12
	bcc dhead_02
	ldx sfx_number
	lda channel4effect,x
	adc #64
	sta (00),y
	jsr fetch_base_pitch	;into x(hi) and a(lo)
	ldy #22
	jsr display_decimal
	jsr fetch_base_volume
	ldx #00
	ldy #27
	jmp display_decimal

header_cursor
	ldx cursor_x
	ldy header_x,x
	lda header_x_length,x
	tax
hcurs_01	lda $bb80,y
	eor #128
	sta $bb80,y
	iny
	dex
	bne hcurs_01
	rts




hm_keyascii
 .byt 8,9,10,11
 .byt "-","=",127
hm_key_vector_lo
 .byt <hm_left,<hm_right,<hm_vert,<hm_vert
 .byt <hm_dec,<hm_inc,<hm_del
hm_key_vector_hi
 .byt >hm_left,>hm_right,>hm_vert,>hm_vert
 .byt >hm_dec,>hm_inc,>hm_del

hm_left
	lda cursor_x
	sec
	sbc #01
	and #03
	sta cursor_x
	rts
hm_right
	lda cursor_x
	clc
	adc #01
	and #03
	sta cursor_x
	rts
hm_vert   lda #00
	sta header_mode
	pla
	pla
	rts
hm_dec
	jsr fetch_hm_value
	sec
	sbc #01
	bcs hm_02
	dex
hm_02	jmp store_hm_value
hm_inc
	jsr fetch_hm_value
	clc
	adc #01
	bcc hm_01
	inx
hm_01	jmp store_hm_value
hm_del
	jsr fetch_hm_value
	lda #00
	ldx #00
	jmp store_hm_value

fetch_hm_value
	lda cursor_x
	beq hm_value0
	cmp #02
	beq hm_value2
	bcs hm_value3
hm_value1	ldx sfx_number
	lda channel4effect,x
	rts
hm_value0	lda sfx_number
	rts
hm_value2	jsr fetch_sfx_base
	ldy #01
	lda (02),y
	and #15
	tax
	dey
	lda (02),y
	rts
hm_value3	jsr fetch_sfx_base
	ldy #01
	lda (02),y
	lsr
	lsr
	lsr
	lsr
	rts

store_hm_value
	ldy cursor_x
	beq hms_v0
	cpy #02
	beq hms_v2
	bcs hms_v3
hms_v1	cmp #03
	bcc hms_01
	lda #02
hms_01	ldx sfx_number
	sta channel4effect,x
	rts
hms_v0	and #31
	sta sfx_number
	rts
hms_v2	pha
	txa
	and #15
	sta temp_01
	jsr fetch_sfx_base
	ldy #01
	lda (02),y
	and #%11110000
	ora temp_01
	sta (02),y
	dey
	pla
	sta (02),y
	rts
hms_v3    asl
	asl
	asl
	asl
	sta temp_01
	jsr fetch_sfx_base
	ldy #01
	lda (02),y
	and #%00001111
	ora temp_01
	sta (02),y
	rts

fetch_sfx_base
	ldx sfx_number
	lda sfx_address_lo,x
	sta 02
	lda sfx_address_hi,x
	sta 03
	rts



header_x
 .byt 10,24,32,37
header_x_length
 .byt 2,1,4,2

header_text_overview
 .byt "NM Effect                 Pitch     V   "
header_text_inlay
 .byt "on channel "

control_driver
	lda header_mode
	bne header_menu
cont_01	jsr $eb78
	bpl cont_01
	ldx #15
cont_02	cmp key_ascii,x
	beq cont_03
	dex
	bpl cont_02
	jmp cont_01
cont_03	lda key_vector_lo,x
	sta cont_04+1
	lda key_vector_hi,x
	sta cont_04+2
	ldx sfx_number
	lda sfx_address_lo,x
	clc
	adc #02
	sta 02
	lda sfx_address_hi,x
	adc #00
	sta 03
cont_04	jmp $bf00

header_menu
	jsr header_cursor
hmenu_01	jsr $eb78
	bpl hmenu_01
	ldx #06
hmenu_02	cmp hm_keyascii,x
	beq hmenu_03
	dex
	bpl hmenu_02
	jmp header_menu
hmenu_03  lda hm_key_vector_lo,x
	sta hmenu_04+1
	lda hm_key_vector_hi,x
	sta hmenu_04+2
hmenu_04	jsr $bf00
	jsr display_effect_screen
	jsr display_help_for_channel
	jmp header_menu

control_control
	ldy cursor_y
	lda (02),y
	and #%00000011
	beq change_control
set_control
	lda (02),y
	and #%11111100
	sta (02),y
	rts
change_control
	lda (02),y
	and #%11110011
	sta temp_01
	lda (02),y
	clc
	adc #04
	and #%00001100
	ora temp_01
	sta (02),y
	rts
control_pitch
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #1
	sta (02),y
	rts
control_period
	lda channel4effect,x
	bne cper_01	;branch if not A
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #2
	sta (02),y
cper_01	rts
control_cycle
	lda channel4effect,x
	bne cper_01	;branch if not A
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #3
	sta (02),y
	rts
control_volume
	lda channel4effect,x
	beq cper_01	;branch if A
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #2
	sta (02),y
	rts
control_pbend
	lda channel4effect,x
	cmp #1
	bne cper_01	;branch if not B
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #3
	sta (02),y
	rts
control_noise
	lda channel4effect,x
	cmp #2
	bne cper_01	;branch if not A
	ldy cursor_y
	lda (02),y
	and #%11111100
	ora #3
	sta (02),y
	rts

fetch_base_pitch
	ldy sfx_number
	lda sfx_address_lo,y
	sta 02
	lda sfx_address_hi,y
	sta 03
	ldy #01
	lda (02),y
	and #15
	tax
	dey
	lda (02),y
	rts
fetch_base_volume
	ldy sfx_number
	lda sfx_address_lo,y
	sta fbvol_01+1
	lda sfx_address_hi,y
	sta fbvol_01+2
	ldy #01
fbvol_01	lda $bf00,y
	lsr
	lsr
	lsr
	lsr
	rts


;C Control
;P Pitch
;V Volume (If channels B or C)
;E Env Period (If channel A)
;Y Env Cycle
;
display_help_for_channel
	ldx sfx_number
	ldy channel4effect,x
	lda channel_help_text_lo,y
	sta dhfc_01+1
	lda channel_help_text_hi,y
	sta dhfc_01+2
	ldy #25
dhfc_01	lda $bf00,y
	sta $bb80+27*40,y
	dey
	bpl dhfc_01
	rts

channel_help_text_lo
 .byt <channel_a_help,<channel_b_help,<channel_c_help
channel_help_text_hi
 .byt >channel_a_help,>channel_b_help,>channel_c_help
;Control Pitch pEriod cYcle
channel_a_help
 .byt "C"+128,"ontrol ","P"+128,"itch p","E"+128,"riod c","Y"+128,"cle"
channel_b_help
;Control Pitch Volume pBend
 .byt "C"+128,"ontrol ","P"+128,"itch ","V"+128,"olume p","B"+128,"end"
channel_c_help
;Control Pitch Volume Noise
 .byt "C"+128,"ontrol ","P"+128,"itch ","V"+128,"olume ","N"+128,"oise"

unflag_navigation_entry
	ldy cursor_y
;	beq top_line_navigation
;	dey	;position 0 is top line
	ldx sfx_number
	lda channel4effect,x
	asl
	asl
	sta temp_01
	lda sfx_address_lo,x
	clc
	adc #02	;ignore header bytes (2)
	sta 02
	lda sfx_address_hi,x
	adc #00
	sta 03
	jsr calc_label_table	;result is label table in 6/7
	ldy #00
ufne_01	lda (06),y
	and #127
	cmp #"$"
	beq ufne_02
	sta (06),y
	iny
	jmp ufne_01
ufne_02	rts


flag_navigation_entry
	ldy cursor_y
;	beq top_line_navigation
;	dey	;position 0 is top line
	ldx sfx_number
	lda channel4effect,x
	asl
	asl
	sta temp_01
	lda sfx_address_lo,x
	clc
	adc #02	;ignore header bytes (2)
	sta 02
	lda sfx_address_hi,x
	adc #00
	sta 03
	jsr calc_label_table	;result is label table in 6/7
clq_03	ldy #00	;count number of labels
	ldx #00
clq_02	lda (06),y
	and #127
	cmp #"$"
	beq lne_labelend
	cmp #"%"
	bne clq_01
	cpx cursor_x
	beq lne_foundlabelpos
	inx
clq_01	iny
	jmp clq_02
lne_labelend
	;if no label found, then assume highlight of complete line
	cpx #00
	bne lne_labelsexist
	lda #128
	sta highlight_whole_flag
	rts
lne_labelsexist
	lda #00
	sta cursor_x
	jmp clq_03
lne_foundlabelpos
	ora #128	;negate entry giving plot routine flag
	sta (06),y
	lda #00
	sta highlight_whole_flag
	rts







navigate_decrement
	jsr fetch_value
	sec
	sbc #01
	jmp store_value
navigate_increment
	jsr fetch_value
	clc
	adc #01
	jmp store_value
navigate_delete
	jsr fetch_value
	lda #00
	jmp store_value
navigate_toggle
	jsr fetch_value
	eor label_source_bitmask,x
	jmp store_value

fetch_value
	lda highlight_letter
	beq fval_04
	cmp #97
	bcc fval_01
	sbc #32
fval_01	sec
	sbc #65
	tax
	ldy cursor_y
	lda (02),y
	and label_source_shiftmask,x
	sta temp_02
	lda (02),y
	ldy label_source_bitstart,x
	beq fval_03
fval_02	lsr
	dey
	bne fval_02
fval_03	and label_source_bitmask,x
fval_04	rts

store_value
	ldy highlight_letter
	beq sval_03
	and label_source_bitmask,x
	ldy label_source_bitstart,x
	beq sval_02
sval_01	asl
	dey
	bne sval_01
sval_02	ora temp_02
	ldy cursor_y
	sta (02),y
sval_03	rts




navigate_left	;look for
	dec cursor_x
	bpl nleft_01
	lda #00
	sta cursor_x
nleft_01	rts
navigate_right
	inc cursor_x
	rts
navigate_up
	dec cursor_y
	bpl nup_01
	lda #00
	sta cursor_y
	inc header_mode
nup_01	rts
navigate_down
	lda cursor_y
	cmp bottom_line
	bcs ndown_01
	inc cursor_y
ndown_01	rts



display_effect
	lda #25
	sta bottom_line
	ldx sfx_number
	lda sfx_address_lo,x
	clc
	adc #02
	sta 02
	lda sfx_address_hi,x
	adc #00
	sta 03
	lda #00
	sta 04
	lda #<$bb80+1*40
	sta 00
	lda #>$bb80+1*40
	sta 01
deffe_02	ldy #00
	lda 04
	ldx #00
	jsr display_decimal
	ldy sfx_number
	lda channel4effect,y
	asl
	asl
	sta temp_01
	ldy #00
	jsr calc_label_table
	lda #00
	sta 05	;label index
	ldy #03
	sty 08
	ldy #02
	lda #8
	sta (00),y
	jsr display_label_line
	lda byte_entity
	and #%00001111
	cmp #%00001000
	beq clear_remaining_lines
	cmp #%00000100
	beq clear_remaining_lines
;	jsr track_pitch
;	jsr track_volume
	inc 02
	bne deffe_01
	inc 03
deffe_01	lda #40
	jsr add_00
	inc 04
	lda 04
	cmp #26
	bcc deffe_02
	rts
clear_remaining_lines
	lda #40
	jsr add_00
	inc 04
	lda 04
	cmp #26
	bcs crln_02
	ldy #39
	lda #08
crln_01	sta (00),y
	dey
	bpl crln_01
	jmp clear_remaining_lines
crln_02	rts

calc_label_table
	lda (02),y
	sta byte_entity
	and #03
	bne deffe_03
;mode_control
	lda byte_entity
	and #12
	lsr
	lsr
	adc #12
	ldx #00
	stx temp_01
deffe_03	ora temp_01
	tax
	lda sfx_display_template_lo,x
	sta 06
	lda sfx_display_template_hi,x
	sta 07
	rts



sfx_display_template_lo
 .byt 0
 .byt <template_pitch
 .byt <template_period
 .byt <template_cycle
 .byt 0
 .byt <template_pitch
 .byt <template_volume
 .byt <template_pbend
 .byt 0
 .byt <template_pitch
 .byt <template_volume
 .byt <template_noise
 .byt <template_cont
 .byt <template_loop
 .byt <template_end
 .byt <template_wait
sfx_display_template_hi
 .byt 0
 .byt >template_pitch
 .byt >template_period
 .byt >template_cycle
 .byt 0
 .byt >template_pitch
 .byt >template_volume
 .byt >template_pbend
 .byt 0
 .byt >template_pitch
 .byt >template_volume
 .byt >template_noise
 .byt >template_cont
 .byt >template_loop
 .byt >template_end
 .byt >template_wait

fetch_base_sfx_byte0
	stx fbsb0_02+1
	ldx sfx_number
	lda sfx_address_lo,x
	sta fbsb0_01+1
	lda sfx_address_hi,x
	sta fbsb0_01+2
fbsb0_01	lda $bf00
fbsb0_02	ldx #00
	rts

fetch_base_sfx_byte1
	stx fbsb1_02+1
	ldx sfx_number
	lda sfx_address_lo,x
	sta fbsb1_01+1
	lda sfx_address_hi,x
	sta fbsb1_01+2
	ldx #01
fbsb1_01	lda $bf00,x
fbsb1_02	ldx #00
	rts

;****
;"NM EFFECT 3 ON CHANNEL A   PITCH 4095V15"
;"00 Pitch Normal Down scale 15    4080 15"
;"01 Pitch Bend Down Scale 15      4080 15"
;"02 Volume 15, Tone on, Noise off 4065 15"
;"04 Wait 15
;"05 loop back to 0
template_pitch
 .byt "Pitch %a %b %C$"
template_volume
 .byt "Volume %D,Tone %e,Noise %f$"
template_period
 .byt "H-Envelope Period of %G$"
template_cycle
 .byt "H-Envelope Cycle is %h$"
template_pbend
 .byt "Pitch bend %i at %J$"
template_noise
 .byt "Noise pulse-width of %K$"
template_cont
 .byt "Volume Bend %n at rate %O$"
template_loop
 .byt "Loop back %L steps$"
template_end
 .byt "End Here!$"
template_wait
 .byt "Wait for %M steps$"

label_source_bitstart
 ;    a b c d e f g h i j k l m n o
 .byt 2,3,4,2,6,7,2,2,2,3,2,4,4,7,4
label_source_bitmask
 ;    a b c  d  e f g  h  i j  k  l  m  n o
 .byt 1,1,15,15,1,1,63,15,1,31,31,15,15,1,7
;what to keep in the byte when modifying value
label_source_shiftmask
 .byt %11111011	; a
 .byt %11110111     ; b
 .byt %00001111     ; c
 .byt %11000011     ; d
 .byt %10111111     ; e
 .byt %01111111     ; f
 .byt %00000011     ; g
 .byt %11000011     ; h
 .byt %11111011     ; i
 .byt %00000111     ; j
 .byt %10000011     ; k
 .byt %00001111     ; l
 .byt %00001111     ; m
 .byt %01111111	; n
 .byt %10001111     ; o
;their is the requirement that something like...
;Wait should range 1-16
;Pitch step should range 1-16
;Volume should range 0 to 15
;Period should range 1 to 256 in steps of 4 !!

;NM Area        LFormat
;a  Pitch type  0 (N/A)
;b  Direction   0 (N/A)
;C  Step/Rate   1 (1-16)
;D  Volume      0 (0-15)
;e  Tone Flag   0 (N/A)
;f  Noise Flag  0 (N/A)
;G  Period      2 (1 to 256 (Step4))
;h  Cycle       0 (N/A)
;i  PBend Dir.  0 (N/A)
;J  Pbend rate  1 (1-32)
;K  Noise PW    1 (1-32)
;L  Loop Step   1 (1-16)
;M  Wait period 1 (1-16)
;n  VBend Dir.  0 (N/A)
;o  Vbend rate  1 (1-8)
value_adjust_vector_lo
 .byt <value_normal,<value_plusone,<value_step4
value_adjust_vector_hi
 .byt >value_normal,>value_plusone,>value_step4

uc_label_pointer	;upper case are value formats
;0==Decimal
 ;    a b c d e f g h i j k l     m n o
 .byt 0,0,1,0,0,0,2,0,0,1,1,128+1,1,0,1	;128 flag triggers loop plotting
lc_label_pointer	;lower case are text pointers
 ;    a b c d e f g h i j k l m n  o
 .byt 0,2,0,0,4,4,0,6,2,0,0,0,0,22,0
label_text_vector_lo
  .byt <label_text1
  .byt <label_text2
  .byt <label_text3
  .byt <label_text4
  .byt <label_text5
  .byt <label_text6
  .byt <label_text7
  .byt <label_text8
  .byt <label_text9
  .byt <label_text10
  .byt <label_text11
  .byt <label_text12
  .byt <label_text13
  .byt <label_text14
  .byt <label_text15
  .byt <label_text16
  .byt <label_text17
  .byt <label_text18
  .byt <label_text19
  .byt <label_text20
  .byt <label_text21
  .byt <label_text22
  .byt <label_text23
  .byt <label_text24
label_text_vector_hi
  .byt >label_text1
  .byt >label_text2
  .byt >label_text3
  .byt >label_text4
  .byt >label_text5
  .byt >label_text6
  .byt >label_text7
  .byt >label_text8
  .byt >label_text9
  .byt >label_text10
  .byt >label_text11
  .byt >label_text12
  .byt >label_text13
  .byt >label_text14
  .byt >label_text15
  .byt >label_text16
  .byt >label_text17
  .byt >label_text18
  .byt >label_text19
  .byt >label_text20
  .byt >label_text21
  .byt >label_text22
  .byt >label_text23
  .byt >label_text24


label_text1
 .byt "Norma","l"+128
label_text2
 .byt "Ben","d"+128
label_text3
 .byt "Down scal","e"+128
label_text4
 .byt "Up Scal","e"+128
label_text5
 .byt "of","f"+128
label_text6
 .byt "o","n"+128
label_text7
 .byt 94,126,126+128
label_text8
 .byt 94,126,126+128
label_text9
 .byt 94,126,126+128
label_text10
 .byt 94,126,126+128
label_text11
 .byt 127,126,126+128
label_text12
 .byt 127,126,126+128
label_text13
 .byt 127,126,126+128
label_text14
 .byt 127,126,126+128
label_text15
 .byt 94,94,94+128
label_text16
 .byt 94,126,126+128
label_text17
 .byt 124,123,124+128
label_text18
 .byt 94,95,125+128
label_text19
 .byt 127,127,127+128
label_text20
 .byt 123,125,125+128
label_text21
 .byt 123,124,123+128
label_text22
 .byt 127,126,126+128
label_text23
 .byt "Ris","e"+128
label_text24
 .byt "Fal","l"+128

char_defs1	;Cycle Graphic
 .byt 0,1,2,4,8,16,32,0	;123 rise
 .byt 0,32,16,8,4,2,1,0	;124 fall
 .byt 0,63,0,0,0,0,0,0	;125 max
 .byt 0,0,0,0,0,0,63,0	;126 min
 .byt 0,1,3,5,9,17,33,0	;127 Rise with vert

char_defs2	;Loop Graphic
 .byt 8,8,8,14,14,14,14,0	;91 Start
 .byt 8,8,8,8,8,8,8,8	;92 link
 .byt 0,14,14,14,14,8,8,8	;93 End
 .byt 0,32,48,40,36,34,33,0	;94 Fall with vert
 .byt 0,63,32,32,32,32,32,0	;95 Max with vert left
setup_chars
	ldx #39
such_01	lda char_defs1,x
	sta $b400+8*123,x
	lda char_defs2,x
	sta $b400+8*91,x
	dex
	bpl such_01
	rts

display_label_line
	ldy 05
	lda (06),y
	and #128
	ldx 04
	cpx cursor_y
	beq dlln_01
	lda #00
dlln_01	sta highlight_flag
	lda (06),y
	and #127
	cmp #"$"
	beq uchek_end
	cmp #"%"
	bne display_character
	inc 05	;adjust index to look after label
	inc 05
	iny
	lda (06),y
	cmp #97
	bcs lowercase_check
uppercase_check	;display value
	ldy highlight_flag
	beq uchek_04
	sta highlight_letter
uchek_04	sbc #64
	tay
	lda byte_entity
	ldx label_source_bitstart,y
	beq uchek_02
uchek_01	lsr
	dex
	bne uchek_01
uchek_02	and label_source_bitmask,y
	ldx uc_label_pointer,y	;upper case are value formats
	bpl uchek_06
	jmp loop_plotter
uchek_06	ldy value_adjust_vector_lo,x
	sty uchek_05+1
	ldy value_adjust_vector_hi,x
	sty uchek_05+2
uchek_05	jsr $bf00
	ldy 08
	jsr display_decimal
	sty 08	; store new screen index
	jmp display_label_line
uchek_end	ldy 08
uchek_10	cpy #31
	bcs uchek_11
	lda #08
	sta (00),y
	iny
	jmp uchek_10
uchek_11	rts
display_character	;just Display directly
	ldy 08
	ldx highlight_whole_flag
	beq dchar_01
	ldx 04
	cpx cursor_y
	bne dchar_01
	ora #128
	ldx #00
	stx highlight_letter
dchar_01	sta (00),y
	inc 05
	inc 08
	jmp display_label_line
lowercase_check	;Display value in text form
	ldy highlight_flag
	beq lchek_04
	sta highlight_letter
lchek_04	sbc #97
	tay
	lda byte_entity
	ldx label_source_bitstart,y
	beq lchek_02
lchek_01	lsr
	dex
	bne lchek_01
lchek_02	and label_source_bitmask,y
	clc
	adc lc_label_pointer,y
	tay
	lda label_text_vector_lo,y
	sta lchek_03+1
	lda label_text_vector_hi,y
	sta lchek_03+2
	ldy 08
	ldx #00
lchek_03	lda $bf00,x
	php
	and #127
	ora highlight_flag
	sta (00),y
	inx
	iny
	plp
	bpl lchek_03
	sty 08
	jmp display_label_line

loop_plotter
	sta lplot_01+1
	pha
	stx lplot_02+1
	lda 04
	sta bottom_line
	ldy #02
	lda #91	;Start
	sta (0),y
	lda $0
	sta $9
	lda $1
	sta $a
	pla	;a holds offset
	tax
	inx
	ldy #2
	lda 4
	sta temp_03
lplot_03	lda $9
	sec
	sbc #40
	sta $9
	lda $a
	sbc #00
	sta $a
	dec temp_03
	bmi lplot_02
	dex
	beq lplot_04
	lda #92	;link
	sta ($9),y
	jmp lplot_03
lplot_04	lda #93	;Destination
	sta ($9),y
lplot_02	lda #00
	and #127
	tax
lplot_01	lda #00
	jmp uchek_06

value_normal
	ldx #00
	rts
value_plusone
	clc
	adc #01
	ldx #00
	rts
value_step4
	ldx #00
	stx temp_02
	asl
	rol temp_02
	asl
	rol temp_02
	ldx temp_02
	rts


sfx_number	.byt 31
byte_entity	.byt 0
highlight_flag	.byt 0
highlight_whole_flag .byt 0
highlight_letter	.byt 0
cursor_x		.byt 0
cursor_y		.byt 0
bottom_line	.byt 25
header_mode	.byt 1

;********************** IRQ Handler Software ***********************

irq_setup	sei
	lda #$4c
	sta $024a
	lda #<irq_handler
	sta $024b
	lda #>irq_handler
	sta $024c
	lda #128	;Reset sfx number
	sta $f3
	cli
	rts

irq_handler
	sta irqh_01+1
	stx irqh_02+1
	sty irqh_03+1
	lda #00
	sta infinite_counter
	jsr irq_monitor_sfx_activity
	jsr irq_process_sfx		;Perform Sound effects
irqh_01	lda #00
irqh_02	ldx #00
irqh_03	ldy #00
	rti

infinite_counter	.byt 0
;Monitor $f3
;Different to game in that the channel is selectable from channel4effect table and sfx range is 32, not 16
;$F3
;>>	B0-4 == Sound Effect
;		0-31 == Sound Effect Number
;	B7   == Taken Flag
;		0 == Not Taken
;		1 == Sound Effect Taken
;
irq_monitor_sfx_activity
	lda $f3
	bmi imsa_01
	ora #128
	sta $f3
	and #31
setup_new_sfx
	tax
	;reset existing sfx bits
	ldy channel4effect,x
	sta irq_effect_number,y
	lda #00
	sta irq_ctrl_wait,y
	sta irq_channel_activity,y
	sta irq_pitchbend_flag,y
	sta irq_volumebend_flag,y
	sta irq_effect_index,y
	cpy #00
	bne imsa_01
	;reset cycle refer if channel a
	lda #255
	sta ay_refer+13
imsa_01	rts

irq_pitchbend_flag
 .dsb 3,0
irq_pitchbend_step
 .dsb 3,0
irq_volumebend_flag
 .dsb 3,0
irq_volumebend_rate
 .dsb 3,0
irq_volumebend_rate_ref
 .dsb 3,0


irq_process_sfx
	ldx #02
ipsfx_03	lda irq_ctrl_wait,x	;Check effect wait
	beq ipsfx_01
	dec irq_ctrl_wait,x
	jmp ipsfx_02
ipsfx_01	lda irq_channel_activity,x
	bmi ipsfx_02
	jsr irq_manage_effect
ipsfx_02	jsr irq_check_pitchbend
	jsr irq_check_volumebend
	dex
	bpl ipsfx_03	;Check effect gate
send_ay	ldx #13
say_02	ldy ay_pseudo_index,x
	lda ay_pseudo_table,y
	cmp ay_refer,x
	beq say_01
	sta ay_refer,x
	stx via_porta
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

ay_pseudo_index
 .byt 0,3,1,4,2,5,6,7,8,9,10,11,12,13
ay_pseudo_table
ay_pitch_lo
 .byt 0,0,0	;pitch lo
ay_pitch_hi
 .byt 0,0,0	;pitch hi
 .byt 0,64	;Noise + Status
ay_volume
 .byt 0,0,0	;Volumes
 .byt 0,0,0	;Env + Cycle
ay_refer
 .dsb 14,0


irq_ctrl_wait
 .dsb 3,0
irq_channel_activity
 .dsb 3,0


irq_check_pitchbend
	lda irq_pitchbend_flag,x
	beq icpb_01
	asl
	bcs negate_pitch
posate_pitch
	lda irq_pitchbend_step,x
	adc ay_pitch_lo,x
	sta ay_pitch_lo,x
	lda ay_pitch_hi,x
	adc #00
	and #15
	sta ay_pitch_hi,x
	rts
negate_pitch
	lda ay_pitch_lo,x
	sbc irq_pitchbend_step,x
	sta ay_pitch_lo,x
	lda ay_pitch_hi,x
	sbc #00
	and #15
	sta ay_pitch_hi,x
icpb_01	rts

irq_check_volumebend
	lda irq_volumebend_flag,x
	beq icvb_01
	dec irq_volumebend_rate,x
	bpl icvb_01
	lda irq_volumebend_rate_ref,x
	sta irq_volumebend_rate,x
	lda irq_volumebend_flag,x
	asl
	bcs negate_volume
posate_volume
	lda ay_volume,x
	adc #01
	cmp #15
	bcc icvb_02
	lda #15
icvb_02	sta ay_volume,x
	rts
negate_volume
	lda ay_volume,x
	sbc #01
	bpl icvb_03
	lda #00
icvb_03	sta ay_volume,x
icvb_01	rts

pb_flag
 .dsb 3,0
pb_step
 .dsb 3,0

irq_manage_effect
	ldy irq_effect_number,x
	bmi imsfx_04
	lda sfx_address_lo,y
	sta $f6
	lda sfx_address_hi,y
	sta $f7
	ldy irq_effect_index,x
	bne imsfx_03
	lda ($f6),y	;initialise by setting pitch
	sta ay_pitch_lo,x
	iny
	lda ($f6),y
	pha
	and #15
	sta ay_pitch_hi,x
	pla
	lsr
	lsr
	lsr
	lsr
	sta ay_volume,x
	iny
	tya
	sta irq_effect_index,x
imsfx_03	lda ($f6),y
	lsr
	lsr
	pha
	txa
	asl
	asl
	sta imsfx_01+1
	lda ($f6),y
	and #03
imsfx_01	ora #00
	tay
	lda irq_sfx_vector_lo,y
	sta imsfx_02+1
	lda irq_sfx_vector_hi,y
	sta imsfx_02+2
	pla
	clc
imsfx_02	jsr $bf00
	inc irq_effect_index,x
;protect against infinite loop here!!!
	inc infinite_counter
	beq imsfx_04
;
	bcc irq_manage_effect
imsfx_04	rts

irq_effect_number
 .dsb 3,0
irq_effect_index
 .dsb 3,0
irq_sfx_vector_lo	;indexed by (channel*4)+mode (12 long)
 .byt <irq_mode_control	;a
 .byt <irq_mode_pitch   ;a
 .byt <irq_mode_period  ;a
 .byt <irq_mode_cycle   ;a
 .byt <irq_mode_control ;b
 .byt <irq_mode_pitch   ;b
 .byt <irq_mode_volume  ;b
 .byt <irq_mode_pbend   ;b
 .byt <irq_mode_control ;c
 .byt <irq_mode_pitch   ;c
 .byt <irq_mode_volume  ;c
 .byt <irq_mode_noise   ;c
irq_sfx_vector_hi
 .byt >irq_mode_control
 .byt >irq_mode_pitch
 .byt >irq_mode_period
 .byt >irq_mode_cycle
 .byt >irq_mode_control
 .byt >irq_mode_pitch
 .byt >irq_mode_volume
 .byt >irq_mode_pbend
 .byt >irq_mode_control
 .byt >irq_mode_pitch
 .byt >irq_mode_volume
 .byt >irq_mode_noise

;one channel+env+noise
;volume,pitch,noise,env_period,cycle

;0 Specify New Volume/Bit
;1 Specify New noise/Bit
;2 Specify New pitch change
;3 Specify New env change

;CH-a	;Creatures (Footsteps, Hits, Menu sounds) 	Channel A Pitch + Env + Cycle + NBit + TBit
;CH-b	;Land (Forest)				Channel B Pitch + Volume + NBit +TBit
;CH-c	;Water (Sea,River,Shore,Wind)			Channel C Pitch + Volume + Noise + NBit + TBit

;*1 (Control)
;B2-3
;0 Continue
;1 Loop Back	Length(B4-7)
;2 End
;3 Wait		Period(B4-7)
irq_mode_control
	pha
	and #03
	beq irq_volbend
	cmp #02
	bcc irq_ctrl_loop
	bne irq_ctrl_wait_routine
irq_ctrl_end
	lda #128
	sta irq_channel_activity,x
	sta irq_effect_number,x
	lda #00
	sta irq_ctrl_wait,x
;	sta irq_pitchbend_flag,x
;	sta irq_volumebend_flag,x
	sec
	pla
	rts

irq_ctrl_loop
	pla
	lsr
	lsr
	sta imct_01+1
	lda irq_effect_index,x
	sec
imct_01	sbc #00
	sta irq_effect_index,x
	clc
	rts

irq_ctrl_wait_routine
	pla
	lsr
	lsr
	sta irq_ctrl_wait,x
	sec
	rts

irq_volbend
	pla
	lsr
	lsr
	cmp #8
	and #7
	sta irq_volumebend_rate,x
	sta irq_volumebend_rate_ref,x
	lda #02
	ror
	sta irq_volumebend_flag,x
	cpx #00			;if channel a
	bne ivbnd_01
	lda irq_effect_index,x        ;If not at entry 0
	beq ivbnd_01
	lda irq_volumebend_flag,x	;then set volume to either min or max
	rol	;get direction
	lda #00
	bcc ivbnd_02
	lda #15
ivbnd_02	sta ay_volume,x
ivbnd_01	rts



;*2 (Pitch)
;B2
;0 Normal		Direction(B3)	Offset(B4-7)
;1 Pitch Bend	Direction(B3)	Rate(B4-7)
irq_mode_pitch
	lsr
	bcc irq_pitch_step
;PBend    Dir(B2)	Rate(B3-7)
irq_mode_pbend
	lsr
	sta irq_pitchbend_step,x
	lda #02
	ror
	sta irq_pitchbend_flag,x
	rts
irq_pitch_step
	lsr
	bcc irq_pitch_raise
irq_pitch_fall
	sta ipfall_01+1
	lda ay_pitch_lo,x
ipfall_01	sbc #00
	sta ay_pitch_lo,x
	lda ay_pitch_hi,x
	sbc #00
	and #15
	sta ay_pitch_hi,x
ipfall_02	jmp ipraise_01
irq_pitch_raise
	adc ay_pitch_lo,x
	sta ay_pitch_lo,x
	lda ay_pitch_hi,x
	adc #00
	and #15
	sta ay_pitch_hi,x
ipraise_01
	lda #00		;if pitch step chosen, disable pitch bend
	sta irq_pitchbend_flag,x
	clc
	rts

;Period	B2-7
irq_mode_period
	sta ay_pseudo_table+11
	lda ay_volume,x
	ora #10
	sta ay_volume,x
	rts
;Cycle	B2-5	NBit(B6)	TBit(B7)
irq_mode_cycle
	pha
	and #15
	sta ay_pseudo_table+13
	lda ay_volume,x
	ora #10
	sta ay_volume,x
	pla
	jmp irq_tn_bit
;Volume	B2-5	Nbit(B6)	Tbit(B7)
irq_mode_volume
	pha
	and #15
	sta ay_volume,x
	pla
irq_tn_bit
	sta itn_02+1
	and #%00100000	;extract Tone Bit
	beq itn_01
;Opposite of ay, tone bit needs reset for ON
	lda ay_pseudo_table+7
	and irq_tone_mask,x
	sta ay_pseudo_table+7
	jmp itn_02
itn_01	lda ay_pseudo_table+7
	ora irq_tone_bmap,x
	sta ay_pseudo_table+7
itn_02	lda #00
	and #%00010000	;extract Noise Bit
	beq itn_03
	lda ay_pseudo_table+7
	and irq_noise_mask,x
	sta ay_pseudo_table+7
	jmp itn_04
itn_03	lda ay_pseudo_table+7
	ora irq_noise_bmap,x
	sta ay_pseudo_table+7
itn_04	clc
	rts

irq_tone_mask
 .byt %11111110,%11111101,%11111011
irq_tone_bmap
 .byt %00000001,%00000010,%00000100
irq_noise_mask
 .byt %11110111,%11101111,%11011111
irq_noise_bmap
 .byt %00001000,%00010000,%00100000


;Noise	B2-6
irq_mode_noise
	sta ay_pseudo_table+6
	rts



;B0-1
;A
;Control	*1
;Pitch	B2-7 *2
;Period	B2-7
;Cycle	B2-5	NBit(B6)	TBit(B7)
;B
;Control	*1
;Pitch	B2-7 *2
;Volume	B2-5	Nbit(B6)	Tbit(B7)
;PBend    Dir(B2)	Rate(B3-7)
;C
;Control	*1
;Pitch	B2-7 *2
;Volume	B2-5	Nbit(B6)	Tbit(B7)
;Noise	B2-6
;
;*1 (Control)
;B2-3
;0 Continue
;1 Loop Back	Length(B4-7)
;2 End
;3 Wait		Period(B4-7)
;
;*2 (Pitch)
;B2
;0 Normal		Direction(B3)	Offset(B4-7)
;1 Pitch Bend	Direction(B3)	Rate(B4-7)





















;P  Abs,bend,ofs
;N  Abs,bend,ofs
;V  Abs,Bend
;Ct Abs,Cycle,


;0-1 Mode
;2-3 Type
;4-7 Wait (0-Don't Wait)

;Mode 0 - Control
;Type 0 - Wait

;Mode 1 -


;type B0-1
; Ctrl
; Absl
; Bend
; Ofst

;Wait period B4-7

;Ctrl (0) b0-1
; B2
; B3
; B4
; B5 Loop Flag
; B6 end!
; B7 Wait

;   b4-7 -
; loop
;   B4-7 + C0-7 (12 bit loop step)
; Bits (3) b2-3
;   b4 Envelope
;   b5 Tone
;   b6 Noise
;   B7 -
; bend (1) b0-1
;  pitch
;   B4-7 Lo
;   C0-7 Hi

;bend
; pitch   ;13
; noise   ;6
; volume  ;5
; Period  ;17
;abs      ;
; pitch   ;12
; noise   ;5
; volume  ;4
; Period  ;16
;ofs      ;
; pitch   ;13
; noise   ;6
; volume  ;5
; Period  ;17
;Control  ;
; end!    ;0
; wait    ;8
; loop    ;8
; Bits    ;3



pitch
volume
noise
mixer
period
pitchbend




















