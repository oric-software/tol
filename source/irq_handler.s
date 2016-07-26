;// Game IRQ (Page 2 Driver)
; Note that this IRQ routine is cloaded into Screen-Buffer then transferred to page 2 using
; InitGame routine which is also in the Screen Buffer.

;However it cannot be placed into hi-mem until everything else has been sorted, since it
;calls out to various lo-mem routine vectors.

; ////////////////////////////////////////////////
; ///////////// MEMORY SENSITIVE CODE ////////////
; ////////////////////////////////////////////////

;Functionality Breakdown
// Whilst irq remains at 50hz, none of the following 4 areas need to operate at this
// speed. Therefore each will be executed in turn, so each runs at 12.5Hz
;Random Number Generator
;
;Split IRQ(4)
; sound effects
; animations
; keyboard & Icon Glow
; candle flame, Map Pixel Hero & TOD (Night&Day Shading, Time of day events)

;Memory breakdown
;0200 IRQ Code (Part I)
;0244 IRQ Vector (0200)
;0247 NMI Vector
;024A IRQ Code (Part II)
#define	via_portb	$0300
#define	via_handa $0301
#define	via_t1ll	$0304
#define	via_pcr	$030c
#define	via_ifr	$030e
#define	via_porta $030F

;all code here must equal 256 bytes exactly

#define	generate_rnd	$0200
#define	proc_tod		$0216
#define	read_keys		$0273

#define	glow_ink		$b296
;0200
;The RND Generator generates a new random number every 100Hz IRQ
exclusion_mask
//generate_rnd
          lda key_register
          adc BackgroundBuffer
	sbc rnd_counter0
	adc rnd_counter1
	sta rnd_byte0
	inc rnd_counter0
	dec rnd_counter1
          adc hero_frame,x
	adc rnd_byte1
          sta rnd_byte1
	rts

// A Day(24 Hours) lasts for 8 Minutes
// This is split into...
// Dawn      (1 Minute) *
// Morning   (1 Minute)
// Noon      (1 Minute) *
// Afternoon (2 Minutes)
// Dusk      (1 Minute) *
// Night     (2 Minutes)*
// * This marks an event change, which entails a change of lighting and a new message
//   However, every minute also resets the creature rotation bitmaps
//   The actual Event change takes place in the main program, since we don't want to
//   catch it halfway through forming the screen.
//
// TOD interval must count for 1 minute before timing out.
//
// The TOD Routine is called every 1/8 of a second, so the routine must wait 480(8*60)
// intervals.
//
// The interval mechanism is a 16 bit fractional counter, so the fractional
// values need to be $59(Low) and $1(High) ~ (65536/480)=345($159)
//


//proc_tod	// 1 minute interval counter
	lda oneminute_fraclo
	clc
	adc #$59
	sta oneminute_fraclo
	lda oneminute_frachi
	adc #$01
	sta oneminute_frachi
.(
	bcc skip1
	; 1 Minute Interval Reached
	lda #00	;tod_quarter
	adc #00
	and #07
	nop
	nop
	;sta $00	;tod_quarter
	lda #00
	sta creature_repeatrotate_bitmap
	sta creature_repeatrotate_bitmap+1
	sta creature_repeatrotate_bitmap+2
skip1	rts
.)
page2_spare1	;Use for Code only
 .dsb 14,0

irq_handler
	nop
	nop
	nop
nmi_handler
          pha
          txa
          pha
          tya
          pha
	php
	cld
          ;// Reset IRQ
          lda via_t1ll
	// Process fast routines (33Hz)
	jsr proc_sfx
	// Process Mid routines (33Hz)
	jsr read_keys
;	jsr generate_rnd (Now done in key_read)
	// The following routines run at quarter speed (8Hz)
	lda irq_fracspeed
	sec
	adc #64
	sta irq_fracspeed
.(
	bcc skip1
	// Process slow routines (8Hz)
	jsr mbm_show_hero
	jsr proc_animate
	jsr update_candle
	jsr proc_regional_sfx
skip1
.)
	plp
          pla
          tay
          pla
          tax
          pla
          rti

//read_keys - Routines within page 2 are location-exact
          ;Setup column register
          lda #$0E
          sta via_porta
          lda #$ff
          sta via_pcr
          ldy #$dd
          sty via_pcr
          ldx #07
.(
loop1     ; Get Column
          lda $b800,x	;key_column,x
          sta via_porta
          ; Get Row
          lda $b808,x	;key_row,x
          sta via_portb
          ; Set Data
          lda #$fd
          sta via_pcr
          ; Reset pcr. also delays
          lda #$dd
          sta via_pcr
	jsr generate_rnd
          ; Get Key
          lda via_portb
          and #8
          cmp #8
          ; Shift into Key register
          rol key_register
          dex
          bpl loop1
	;Glow icon patterns
	dec icg_glow_index
	ldx icg_glow_index
	bpl skip1
	ldx #13
	stx icg_glow_index
skip1	lda glow_ink,x
	sta $a001
	sta $a2d1
	rts
.)
;temp_irq
;	jsr mbm_show_hero	;Show hero in map bitmap
;	rts

page2_spare2	;Use for Code only
 .dsb 67,0
end_of_page2
