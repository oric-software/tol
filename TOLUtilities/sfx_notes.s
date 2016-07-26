sfx notes

000-015 volume
016-047 Noise
048-167 Note
168-



;  B4-7	b0-3	NEXT	NOTES
;0 PITA	High	Low
;1 ENDT	Volume
;2 PITB	High	Low
;3 LOOP	LURZ	High Back
;4 PITC   High	Low
;5 BNDD	Register	Frac
;6 NOIS	B1-4	-	Crude set Noise
;7 STAT	T\N\E	-
;	 +1   Set Tone
;	 +2   Set Noise
;	 +4   -
;	 +8   Set Envelope
;8 VOLA	0-15      -
;9 VOLB    0-15      -
;A VOLC    0-15      -
;B PERS	High	Low
;C BNDU	Register	Frac
;D CYCS	0-15	-
;E WAIT	High	Low
;F XTRA


sfx_regi_birdsong

SFX_REGI_WILDWIND	;Regional
Low volume, slow noise sweep to random widths 0 to 31
SFX_REGI_WAVESONSHORE	;28 Bytes
;Noise width 4, volume sweep in to 10 then out, tone off
 .byt stat+2,nois+2
 .byt vola+0,bndu+8,16,wait+0,160
 .byt vola+10,bndd+8,16,wait+0,160
 .byt wait+0,16
;Noise Width 24, volume sweep in to 6 then out, tone off
 .byt nois+12
 .byt vola+0,bndu+8,16,wait+0,96
 .byt vola+6,bndd+8,16,wait+0,96
 .byt wait+0,32
 .byt
SFX_REGI_RIVERBABBLING
;Noise off, random high pitch, low volume
SFX_HERO_LEFTFOOTSAND
;Noise 31, volume sweep 6 to 0, Tone off

SFX_HERO_RIGHTFOOTSAND
Noise 28, volume sweep 6 to 0, Tone off
SFX_HERO_LEFTFOOTSTONE
;Noise 31,
SFX_HERO_RIGHTFOOTSTONE
SFX_HERO_LEFTFOOTGRASS
SFX_HERO_RIGHTFOOTGRASS
SFX_HERO_HITARM
;Sweep 23
SFX_HERO_HITMAGICALAXE
SFX_HERO_HITSCROLL
SFX_HERO_DIE
SFX_HERO_HURT
SFX_HERO_TELEPORTSTART	;USE ENVELOPE GENERATOR
SFX_HERO_TELEPORTFINISHED
SFX_HERO_CLOAKON
SFX_HERE_CLOAKOFF
SFX_HERO_ENTERBUILDING
SFX_HERO_EXITBUILDING
SFX_HERO_ENTERGATE
SFX_HERO_EXITGATE

SFX_CTRL_ICONMENU
SFX_CTRL_OPTIONS
SFX_CTRL_ABORT	;ICONS OR OPTIONS
SFX_CTRL_ICONSELECT
SFX_CTRL_OPTIONSELECT

SFX_CREA_LEFTFOOT
SFX_CREA_RIGHTFOOT
SFX_CREA_HIT
Noise sweep 4 to 16 fast, volume 8 then off
SFX_CREA_HURT

SFX_CREA_DIE
SFX_CREA_FIREARROW
SFX_CREA_SHUFFLE	;GHOST SFX INSTEAD OF FEET!

.)


proc_sfx	// Sort Game(Overall) Maximum Volume
	lda game_volume
	eor #15
	sta irq_zero04
	ldx #03
.(
loop1	lda effect_sample_frac,x
	sec
	adc effect_sample_rate,x
	sta effect_sample_frac,x
	bcc skip1
	jsr proc_sample
skip1	lda effect_ornament_frac,x
	sec
	adc effect_ornament_rate,x
	sta effect_ornament_frac,x
	bcc skip2
	jsr proc_ornament
skip2	// Sort Channel specific Maximum Volumes
	lda effect_sample_index,x
	bmi skip5	;Avoid if end of sample
	lda channel_maximum_volume,x
	eor #15
	sta irq_zero00
	lda ay_register+8,x
	and #15
	beq skip4
	sbc irq_zero00
	bcs skip3
	lda #00
	// Deal with Game Maximum Volume
skip3	beq skip4
	sbc irq_zero04
	bcs skip4
	lda #00
skip4     ora effect_envelope_flag,x	;Maximum volume does not alter Envelope!
	sta ay_register+8,x
skip5	dex
	bpl loop1
.)
	// send_ay
	ldx #13
.(
loop1	lda ay_register,x
	cmp ay_register_reference,x
	beq skip1
	sta ay_register_reference,x
	ldy #$ff
	sty $030c
	stx $030f
	ldy #$dd
	sty $030c
	sta $030f
	lda #$fd
	sta $030c
	sty $030c
skip1	dex
	bpl loop1
.)
	rts


;Samples
;0 B0-3 Volume (1-15)
;When B0-3 is >0, B4-7 sets Noise Width
;  B4-7 Noise
;When B0-3 is =0, B4-7 has following definition...
;  0    End Sample
;  1    End Sample and Ornament, and Silence
;  2    LSB Noise Off
;  3    LSB Noise On
;  4    Loop to start
;  5    Volume Zero
;  6    Env Off
;  7    Env On
;  8-15 Predefined Envelope & Cycle Set

proc_sample
	ldy effect_sample,x
	lda sample_vector_lo,y
	sta irq_zero00
	lda sample_vector_hi,y
	sta irq_zero01
	ldy effect_sample_index,x
.(
	bmi skip4
	lda (irq_zero00),y
	beq skip3	;end sample
	pha
	and #15
	beq skip5
	ora effect_envelope_flag,x
	sta ay_register+8,x
	pla
	and #240
	beq skip1	;noise off
	lsr
	lsr
	lsr
	ora effect_lsb_noise,x
	sta ay_register+6
	lda ay_register+7
	and noise_mask,x
	sta ay_register+7
	jmp skip2
skip1	lda ay_register+7
	ora noise_bit,x
	sta ay_register+7
skip2	inc effect_sample_index,x
	rts
skip3	lda effect_endbehaviour,x
	bmi skip4
	sta ay_register+8,x	;Zero Volume
skip4	rts
skip5	pla
	lsr
	lsr
	lsr
	lsr
	tay
	lda smp_command_vector_lo,y
	sta vector1+1
	lda smp_command_vector_hi,y
	sta vector1+2
	lda #00
vector1   jmp $dead


;  0    End Sample
;  1    End Sample and Ornament, and Silence
scmd_00	tya
	lsr
	lda #128
	sta effect_sample_index,x
	bcc skip7	;0
	;1
	sta effect_ornament_index,x
	asl
	sta ay_register+8,x
skip7	rts
;  2    LSB Noise Off
;  3    LSB Noise On
scmd_02	tya
	and #01
	sta effect_lsb_noise,x
	jmp skip2
;  4    Loop to start
scmd_04	sta effect_sample_index,x
	rts
;  5    Volume Zero
scmd_05	sta ay_register+8,x
	jmp skip2
;  6    Env Off
;  7    Env On
scmd_06	tya
	and #01
	beq skip6
	lda #16
skip6	sta effect_envelope_flag,x
	jmp skip2
;  8-15 Predefined Envelope & Cycle Set
scmd_08	lda predefined_envelope_period_lo-8,y
	sta ay_register+11
	lda predefined_envelope_period_hi-8,y
	sta ay_register+12
	lda predefined_envelope_cycle-8,y
	sta ay_register+13
	jmp skip2
.)



;Ornaments
;0 B0   Note/Pitch
;  B1   Plus/Minus
;  B2-5 Offset
proc_ornament
	ldy effect_ornament,x
	lda ornament_vector_lo,y
	sta irq_zero00
	lda ornament_vector_hi,y
	sta irq_zero01
	ldy effect_ornament_index,x
.(
	bmi skip8
	lda (irq_zero00),y
	lsr
	bcs skip3	;Pitch Step
	lsr
	sta irq_zero02
	bcs skip1	;negative note
	;Positive note
	beq skip8	;+00N
	adc effect_note,x
	jsr calc_pitch
	jsr store_aypitch
	jmp skip2
skip1	;Negative note
	;-00N
	lda effect_note,x
	sbc irq_zero02
	jsr calc_pitch
	jsr store_aypitch
	jmp skip2
skip3	lsr
	sta irq_zero02
	bcs skip4
	;Positive Pitch
	beq skip6	;+00P
	adc effect_pitch_lo,x
	pha
	lda effect_pitch_hi,x
	adc #00
skip5	tay
	pla
	jsr store_aypitch
	jmp skip2
skip4	;Negative Pitch
	;beq skip7	;-00P Spare
	lda effect_pitch_lo,x
	sbc irq_zero02
	pha
	lda effect_pitch_hi,x
	sbc #00
	jmp skip5
skip2	;Do remainder
	inc effect_ornament_index,x
skip8	rts
skip6	;+00P - Loop
.)
	sta effect_ornament_index,x
	rts

;In...
;A == Note 0-127
;Out...
;A == Pitch Low
;Y == Pitch High
calc_pitch
	// Divide by 12 to get Note 0-11 and Octave 0-10
	ldy #255
	clc
.(
loop1	iny
	sbc #12
	bcs loop1
	adc #12
	// Fetch Base Pitch by Note 0-11
	sty irq_zero03
	tay
	lda base_pitch_hi,y
	sta irq_zero02
	lda base_pitch_lo,y
	ldy irq_zero03
	beq skip1
	// Shift base pitch up scale to Octave
loop2	lsr irq_zero02
	ror
	dey
	bne loop2
skip1	ldy irq_zero02
.)
	rts

;In...
;A == Pitch Low
;Y == Pitch High
;Out...
;Store pitch to registers based on Channel in X
store_aypitch
	pha
	tya
	pha
	// Calculate Register Base Number
	txa
	asl
	tay
	// Store High
	pla
	sta ay_register+1,y
	// Store Low
	pla
	sta ay_register,y
	rts

;Header
;0 B0-6 Note
;  B7
;     0 Silence at end
;     1 Continue at end
;1 B0-3 Ornament
;  B4-7 Ornament Rate(Tempo)
;2 B0-3 Sample
;  B4-7 Sample Rate(Tempo)

;A == New Effect
;X == Channel
init_sfx	;1 of 85 possible effects
	sta zero_00
	asl
	adc zero_00
	adc #<effect_headers
	sta zero_00
	lda #>effect_headers
	adc #00
	sta zero_01
	ldy #00
	sty effect_envelope_flag,x
	sty effect_ornament_frac,x
	sty effect_sample_frac,x
	sty effect_ornament_index,x
	sty effect_sample_index,x
	lda (zero_00),y
	pha
	and #127
	sta effect_note,x
	jsr calc_pitch
	sta effect_pitch_lo,x	;Let Ornament deal totally with storing pitch
	sty effect_pitch_hi,x
	pla
	and #128
	sta effect_endbehaviour,x
	ldy #01
	lda (zero_00),y
	and #15
	sta effect_ornament,x
	lda (zero_00),y
	and #240
	sta effect_ornament_rate,x
	iny
	lda (zero_00),y
	and #15
	sta effect_sample,x
	lda (zero_00),y
	and #240
	sta effect_sample_rate,x
	// Ensure Status Tones are enabled
	rts


;Runtime Tables
game_volume
channel_maximum_volume
 .byt 15,15,15
effect_sample
 .byt 0,0,0
sample_vector_lo
 .byt 0,0,0
sample_vector_hi
 .byt 0,0,0
effect_sample_index
 .byt 128,128,128
effect_envelope_flag
 .byt 0,0,0
ay_register
 .byt 1,1
 .byt 1,1
 .byt 1,1
 .byt 0
 .byt %01111000
 .byt 0,0,0
 .byt 0,0
 .byt 0
ay_register_reference
 .byt 1,1
 .byt 1,1
 .byt 1,1
 .byt 0
 .byt %01111000
 .byt 0,0,0
 .byt 0,0
 .byt 0
effect_lsb_noise
 .byt 0,0,0
effect_endbehaviour
 .byt 0,0,0
effect_ornament
 .byt 0,0,0
ornament_vector_lo
 .byt 0,0,0
ornament_vector_hi
 .byt 0,0,0
effect_ornament_index
 .byt 128,128,128
effect_note
 .byt 0,0,0
effect_pitch_lo
 .byt 0,0,0
effect_pitch_hi
 .byt 0,0,0

;Reference Tables
noise_mask
 .byt %11110111
 .byt %11101111
 .byt %11011111
noise_bit
 .byt %00001000
 .byt %00010000
 .byt %00100000
base_pitch_hi

base_pitch_lo

;Vector Reference Tables
smp_command_vector_lo
smp_command_vector_hi

// SFX Data

;Predefined Envelopes
predefined_envelope_period_lo
predefined_envelope_period_hi
predefined_envelope_cycle

;0 B0-6 Note
;  B7
;     0 Silence at end
;     1 Continue at end
;1 B0-3 Ornament
;  B4-7 Ornament Rate(Tempo)
;2 B0-3 Sample
;  B4-7 Sample Rate(Tempo)
effect_headers	;Up to 85 Effect Headers
 .byt 120,32+0,32+0		;Effect 0 - SeaShore Waves
 .byt 120,240+0,240+1	;Effect 1 - Footstep Sand(L)
 .byt 120,240+0,240+2	;Effect 2 - Footstep Sand(R)
 .byt 120,240+0,240+3	;Effect 3 - Foe Attack


Sample0	;Seashore Waves
 .byt


Sample#0	;SeaWaves
=	      	!==
===                 !========
=====               !========
=======             !========
=========           !========
===========         !========
=============       !========
===============     !===========
================    !=============
===============     !=============
==============      !=============
==============      !=============
=============       !=============
============        !=============
===========         !=============
==========          !=============
=========           !=============
=========           !=============
========            !=============
========            !=============
=======             !=============
=======             !=============
======              !=============
======              !=============
=====               !=============
====                !=============
====                !=============
===                 !=============
==                  !=============
==                  !=============
=                   !=============
=                   !=============
		!=============
		!=============
		!=
		!=
		!=
		!=
		!=
		!=
		!=
		!=
		!=
=                   !=
=                   !=
=                   !=
=                   !=
==                  !=
==                  !=
==                  !=
==                  !=
===                 !=
===                 !=
===                 !=
===                 !=
===                 !=
===                 !=
===                 !=
===                 !=
===                 !=
==                  !=
==                  !=
==                  !=
==                  !=
=                   !=
=                   !=
=                   !=
=                   !=
=                   !=
=                   !=
=                   !=
=                   !=
EndBoth

Sample#1	;Foe Hit
=		!===============
==		!==============
===		!=============
====		!============
=====		!===========
======		!==========
=======		!=========
========		!========
=========		!=======
==========	!======
===========	!=====
============	!====
=============	!===
==============	!==
===============	!=
EndBoth

sample#2	;Left FootStep
=======		!===
======              !===
====                !===
==                  !===
EndBoth

sample#3	;Right FootStep
=======		!============
======              !============
====                !============
==                  !============
EndBoth

sample#4	;Hero hit BG obstacle

sample#5	;Shoot Arrow


sample#6	;Icon Menu
===============	!
==============      !
=============       !
============        !
===========         !
==========          !
=========           !
========            !
=======             !
======              !
=====               !
====                !
===                 !
==                  !
=                   !
EndBoth

sample#7
======              !
=====               !
====                !
===                 !
==                  !
=                   !
EndBoth


;End
;EndBoth
;NoiseLSB On
;NoiseLSB Off
;Loop
;Zero Volume
;Envelope On
;Envelope Off
;Envelope #7


Ornament#0
-00P
End
Ornament#1
-01N
-05N
-10N
-15N
-20N
-25N
End
