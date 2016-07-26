// underwurlde_switches

// Control underworld doors using the provided switches
// Technique is similar to ZipNZap but only one switch to one gate

// Unlike original plan
//  Switches should now only reside in deadend-right
//  Beam Gates in vertical passage ways (So that we can act on map to toggle Gate)

// Beam gate list (2 Each)
// TSMapX,TSMapY


// Switch list (3 Each) Refer to switchgate.bmp in tol//images
// TSMapX,TSMapY,beamIndex(Steps of 2)
#define	beam_gate	$b4d6
beam_switches
 .byt 31,26,0	;Equinox - Top switches not used
 .byt 22,26,20	;Top left switch toggles beam gate in Angor Passage (Nasty!)
 .byt 22,27,2*1

 .byt 5,39,2*2	;Tempus Gate
 .byt 8,43,2*3
 .byt 2,45,2*4	;Bottom Switch for Secret Chamber

 .byt 12,60,2*8	;First top Switch in Silderon Underworld (4Switches)
 .byt 12,62,2*5	;First gate
 .byt 21,60,2*6	;Right switches both close exit beam
 .byt 21,62,2*6
 .byt 16,59,2*7	;Last switch for secret chamber

 .byt 120,2,2*12	;Agrechant Labyrinth - first switch opens last gate for #1
 .byt 119,4,2*9	;next switch opens first gate
 .byt 117,4,2*10	;next switch opens next first gate to #1
 .byt 113,3,2*11	;#1 Switches
 .byt 113,5,2*11
 .byt 119,15,2*13	;Next accessable switch
 .byt 114,15,2*14	;switch behind gate
 .byt 122,6,2*18	;switch after gate down tunnel 4 last gate switch #3
 .byt 122,15,2*15	;Bottom switch of group - next gate
 .byt 121,8,2*16	;switch after that to #2
 .byt 126,10,2*17	;penultimate switch to #3
 .byt 126,1,2*19	;ultimate switch to #3


switch_detected ;Chr 92
	;Delete switch so that hero does not toggle more than once
	lda #111
	sta (zero_00),y
	;
	jsr calc_tsmapxy
	ldx #22
.(
loop1	stx temp_03
	txa
	asl
	adc temp_03
	tay
	lda beam_switches,y
	cmp temp_01
	bne skip2
	lda beam_switches+1,y
	cmp temp_02
	beq skip1
skip2	dex
	bpl loop1
	clc
	rts	;Switch doesn't do anything
skip1	;Found switch, now find beam
	ldx beam_switches+2,y
	lda beam_gate,x	;X
	ldy beam_gate+1,x	;Y
	jsr calc_tsmapaddressY0	;into zero_00-01
	;Found beam, now toggle it
	lda (zero_00),y
	ldx #22
	cmp #53	;(53 for No Beam) (22 for Beam)
	beq skip3
	clc
	ldx #53
skip3	txa
.)
	sta (zero_00),y
	;Toggled, now mention what happened
	; A Beam Gate has opened
	; A Beam Gate has Closed
	lda #212
	adc #00
	jsr message2window
	; sound Effect
;	lda #
;	jmp ?
	clc	;
	rts

;In...
;A	TSMap X pos (0-127)
;Y	TSMap Y pos (0-63)
;Out...
;Zero_00-01	TSMap Address
calc_tsmapaddressY0
	sta zero_00
	;Multiply Y by 128 (16 Bit)
	tya
	lsr
	sta zero_01
	lda #00
	tay	;Zero Y for after RTS
	ror
	;Add X
	ora zero_00
	;Add Base Address of TSMap
	adc #<TSMAP_Vector
	sta zero_00
	lda zero_01
	adc #>TSMAP_Vector
	sta zero_01
	rts
