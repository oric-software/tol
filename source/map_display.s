;map bitmap routines

;Animate pixels for Towns (Speed 1)
;Animate pixel for Hero (Speed 2)

;bbsssmmm mmmm
#define	bitpos		$b451
#define	hires_ylocl	$b3a8
#define	hires_yloch	$b3d8

mbm_show_hero
.(
	;First, check if current location should be shown (Island, underworld, etc)
	lda elsewhere_flag
	cmp #03
	bcc skip3
	ldy #00
	lda hero_mappeek
	sta (hero_maploclo),y
	rts
skip3	;Restore old pixel (if different loc or bitpos)
	lda hero_xl
	cmp old_hero_xl
	bne skip1
	lda hero_yl
	cmp old_hero_yl
	beq skip2
	// However, only update if new location is plottable
	// later!
skip1	ldy #00
	lda hero_mappeek
	sta (hero_maploclo),y
	jsr fetch_new_locNvalue	;Only update if newloc is not attribute
skip2	// 1) Don't plot if forbidden area (Underwurlde or Islands)
	// This is flagged as top bit in tsmap
	ldy #00
	lda (hero_maploclo),y
	eor hero_mapbitpos
	sta (hero_maploclo),y
.)
	rts

fetch_new_locNvalue
	// Calculate loc
.(
	lda #00
	sta irq_zero02
	// Fetch x and y
	lda hero_xl
	sta old_hero_xl
	sta irq_zero04
	lda hero_xh
	asl irq_zero04
	rol
	asl irq_zero04
	rol
	sta hero_x

	lda hero_yl
	sta old_hero_yl
	sta irq_zero04
	lda hero_yh
	asl irq_zero04
	rol
	asl irq_zero04
	rol
	// calc yloc
	tay
	lda hires_ylocl+1,y	;Set at x==24
	sta irq_zero00
	lda hires_yloch+1,y
	sta irq_zero01


;	asl
;	asl
;	asl
;	sta irq_zero03
;	asl
;	rol irq_zero02
;	asl
;	rol irq_zero02
;	adc irq_zero03
;	bcc skip1
;	inc irq_zero02
;skip1	clc
;	adc #<$a040	;a61a	screen
;	sta irq_zero00
;	lda irq_zero02
;	adc #>$a040	;a61a	screen
;	sta irq_zero01

	// calc xloc and bitpos
	lda hero_x
	ldy #255
	sec
loop1	iny
	sbc #06
	bcs loop1
	adc #06
	tax
	tya
	adc irq_zero00	;hero_maploclo
	sta irq_zero00	;hero_maploclo
	bcc skip2
	inc irq_zero01	;hero_maplochi
skip2     // Only update if peek is not attribute!
	ldy #00
	lda (irq_zero00),y
	and #127
	cmp #64
	bcc skip3
	// Update loc
	lda irq_zero00
	sta hero_maploclo
	lda irq_zero01
	sta hero_maplochi
	// update byte info
	lda (hero_maploclo),y
	sta hero_mappeek
	lda bitpos,x
	sta hero_mapbitpos
skip3	rts
.)
