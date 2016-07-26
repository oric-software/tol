;Animations.s holds code and data for all background Game animations.
;This covers ascii character codes 40 to 43.
;The animation set changes for each character set, and their are two.
;All animations have 4 frames

; The current character set is always based on character 40's set.
; We have blocks of 32 bytes for 4 character 4 frame animations,
; so we just need to do the following...
; 2) Increment and calc frame address (or wrap-scroll character)
; 2) combine with set 0 or 1 based on current charset for 40
; 3) send 32 bytes to character 40-43
#define	hero_axe_frame0	$b4a2

proc_animate
	// 1) Increment Frame
	lda aniframe_index
	clc
	adc #32
	and #127
	sta aniframe_index
	//
	ldx #03
.(
loop2	lda second_set+8,x	; The second_set gives direct indicator of correct anim-set
	lsr		; Place this into Carry Flag
	lda aniframe_index	; Fetch the animation frame (B5-6)
	bcc skip1
	ora #128		; Add B7
skip1     adc ascii_character_address_lo,x	; Add B3-4 (use as offset table)
	tay
	lda ascii_character_address_lo+8,x
	sta vector1+1
	stx irq_zero00
	// Update character
	ldx #00
loop1	lda animation_frames,y
vector1	sta $b500,x
	iny
	inx
	cpx #08
	bcc loop1
	// Now loop to update all 4 characters
	ldx irq_zero00
	dex
	bpl loop2
.)
	// We also need to animate the hero weapon
	// But since it's either the axe or Dagger, we'll just use one anim
	// We'll use bit 5 of aniframe_index as frame interleave
	lda aniframe_index
	and #32
	// Shift to 0/8
	lsr
	lsr
.(
skip1	tax
	ldy #07	;We'll actually display vertical mirror image of anim
loop1	lda hero_axe_frame0,x
	sta 46080+8*95,y
	inx
	dey
	bpl loop1
.)
	rts



;We now need a list of the graphics for each set
;Character	SET #0		SET #1	NOTES
;40		firepit #1	Sea	This character is inversed
;41		firepit #2         	Waves     This character is inversed
;42		floor              	River
;43		Flame?             	Twig

;2 sets
;4 frames
;32 bytes per frame(4 characters)
;
;Note; Total Memory for all frames  ((8*4)*4)*2 == 256 Bytes


animation_frames
FirePit_animation_tlbr0	;Set 0, Frame 0
 .byt %100100
 .byt %010110
 .byt %010001
 .byt %001000
 .byt %000100
 .byt %000110
 .byt %100011
 .byt %010001
FirePit_animation_trbl0
 .byt %001000
 .byt %000100
 .byt %000100
 .byt %100010
 .byt %010001
 .byt %011000
 .byt %001000
 .byt %001000
MagicalFloor_animation0
 .byt %011011
 .byt %011000
 .byt %011011
 .byt %000011
 .byt %011011
 .byt %011000
 .byt %011011
 .byt %000011
Torch_animation0
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000

FirePit_animation_tlbr1	;Set 0, Frame 1
 .byt %101100
 .byt %100010
 .byt %010000
 .byt %001000
 .byt %001110
 .byt %000111
 .byt %100010
 .byt %001001
FirePit_animation_trbl1
 .byt %000100
 .byt %100100
 .byt %100010
 .byt %010001
 .byt %001000
 .byt %001100
 .byt %001110
 .byt %011010
MagicalFloor_animation1
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
Torch_animation1
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000

FirePit_animation_tlbr2	;Set 0, Frame 2
 .byt %000101
 .byt %100000
 .byt %010000
 .byt %010100
 .byt %001010
 .byt %000101
 .byt %010010
 .byt %001001
FirePit_animation_trbl2
 .byt %001001
 .byt %000101
 .byt %100010
 .byt %010000
 .byt %001000
 .byt %010100
 .byt %100100
 .byt %001010
MagicalFloor_animation2
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
Torch_animation2
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000

FirePit_animation_tlbr3	;Set 0, Frame 3
 .byt %100001
 .byt %100100
 .byt %100010
 .byt %010101
 .byt %001000
 .byt %100100
 .byt %010011
 .byt %001001
FirePit_animation_trbl3
 .byt %001000
 .byt %000101
 .byt %100000
 .byt %010000
 .byt %001000
 .byt %001001
 .byt %000100
 .byt %010010
MagicalFloor_animation3
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
Torch_animation3
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000

Sea_animation0		;Set 1, Frame 0
 .byt %000000
 .byt %000100
 .byt %000010
 .byt %000000
 .byt %010000
 .byt %001000
 .byt %000001
 .byt %100000
Wave_animation0
 .byt %001000
 .byt %001110
 .byt %000101
 .byt %000110
 .byt %001011
 .byt %010110
 .byt %001101
 .byt %001010
River_animation0
 .byt %100000
 .byt %000110
 .byt %011001
 .byt %100000
 .byt %000100
 .byt %100001
 .byt %010110
 .byt %001000
twig_animation0
 .byt %000000
 .byt %000100
 .byt %010010
 .byt %001100
 .byt %000010
 .byt %000100
 .byt %000000
 .byt %000010

Sea_animation1		;Set 1, Frame 1
 .byt %001000
 .byt %000100
 .byt %000000
 .byt %000000
 .byt %100000
 .byt %010001
 .byt %000010
 .byt %000000
Wave_animation1
 .byt %000100
 .byt %000110
 .byt %100010
 .byt %000111
 .byt %100001
 .byt %000111
 .byt %100110
 .byt %000101
River_animation1
 .byt %100000
 .byt %001100
 .byt %110011
 .byt %000000
 .byt %011000
 .byt %000010
 .byt %101101
 .byt %010000
twig_animation1
 .byt %000000
 .byt %001100
 .byt %010000
 .byt %001100
 .byt %000000
 .byt %001100
 .byt %000000
 .byt %001100

Sea_animation2		;Set 1, Frame 2
 .byt %010000
 .byt %001000
 .byt %000000
 .byt %000000
 .byt %000010
 .byt %100100
 .byt %010000
 .byt %000000
Wave_animation2
 .byt %000010
 .byt %000001
 .byt %010001
 .byt %100010
 .byt %110000
 .byt %100010
 .byt %010001
 .byt %100010
River_animation2
 .byt %000000
 .byt %011010
 .byt %100100
 .byt %000011
 .byt %100000
 .byt %000110
 .byt %001001
 .byt %110000
twig_animation2
 .byt %010000
 .byt %001000
 .byt %010000
 .byt %001100
 .byt %000000
 .byt %010100
 .byt %000000
 .byt %010000

Sea_animation3		;Set 1, Frame 3
 .byt %000000
 .byt %001000
 .byt %000100
 .byt %000000
 .byt %001000
 .byt %000101
 .byt %000010
 .byt %000000
Wave_animation3
 .byt %000100
 .byt %000010
 .byt %000000
 .byt %000101
 .byt %100000
 .byt %000101
 .byt %000010
 .byt %000100
River_animation3
 .byt %000000
 .byt %001000
 .byt %110011
 .byt %001100
 .byt %000010
 .byt %000000
 .byt %111100
 .byt %000011
twig_animation3
 .byt %010000
 .byt %000000
 .byt %010000
 .byt %001101
 .byt %000000
 .byt %100000
 .byt %000000
 .byt %000001




