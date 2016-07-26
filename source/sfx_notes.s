;SFX
;Environment(A)
; Waves
;	Volume controlled noise envelope
; Bird
;	No Noise, Tone based tune, with latent echo of response
; Wind
;	gradual rise and file of noise(not sure of this one)
; Water droplets (Dungeons)
;	Short plinks
; Enter Icons
; Select Icon/Option
; Back menu
;Hero(B)
; Footsteps
;	Momentary noise on/off, no effect on tone
; Hit
;	rapid volume rise then zero, noise on, no tone
; Magic
;
; Die
;	Single channel Funeral March with ornaments?
; Find token word
;NPC(C)
; Footsteps
;	Momentary noise on/off, no effect on tone
; Marching(heavy footsteps)
;	Momentary noise on/off, no effect on tone
; Die
; flute player
;	random tune ditty's

;Labels
; Label Address (Offset or Absolute)
; Label Address (Offset or Absolute)
;SFX Data

;Labels are used both for Gosubs, Jumps and SFX pointers.
;Up to 128 Labels can exist in an SFX module.


;V-OFS		-15 to +15	31 0-30					VOL +15	P
;P-OFS		-15 to +15	31 31-61					PTC +15	-
;N-OFS		-15 to +15	31 62-92					NTE +15	-
;O-OFS		-15 to +15	31 93-123					NOI +15	-
;E-OFS		-15 to +15	31 124-154				EGP +15	-
;T-Flag		Off or On		2  155-156				T-1	-
;N-Flag		Off or On		2  157-158				N-1	-
;E-Flag		Off or On		2  159-160				E-1	-
;Set Counter	0-31		32 161-202				CNT 31	-
;Set Condition Off	1		1  203-203				CON Off	-
;Set Condition Vol	1		1  204-204				CON Vol	-
;Set Condition Cnt	1		1  205-205				CON Cnt	-
;Filter		1-4		4  206-209				FLT 4	-
;Delay		1-31		31 210-241				DLY 31	P
;End SFX		1		1  242-242				END	-
;Conditional Loop	1		1  243-243,Offset				CLP	-
;Randomise Pitch	1		1  244-244				RND Pitch	-
;Randomise Note	1		1  245-245				RND Note	-
;Randomise Noise	1		1  246-246				RND Noise	-
;Randomise Volume	1		1  247-247				RND Volume-
;Randomise EG Low	1		1  248-248				RND EGPer	-
;Set Note		1		1  249-249,Note				SNT 127	-
;Set Noise	1                   1  250-250,Noise				SNO 31	-
;Set Volume	1                   1  251-251,Volume				SVO 15	-
;Set EG		1                   1  252-252,EG Period low,EG Period high/Cycle	SEG 4095/F-
;Jump		1		1  253-253,LabelID				JMP Label1-
;Gosub		1		1  254-254,LabelID				JSR Label9-
;Return		1		1  255-255				RTS	-

;0123456789012345678901234567890123456789
; 00 JMP Label 00 JMP Label 00 JMP Label
; 01 JMP Label1
; 02 JMP Label1

StartIndexLo
StartIndexHi

	ldx #2
.(
loop3	lda EffectActivity,x
	bpl skip2
	lda EffectAddressLo,x
	sta effect
	lda EffectAddressHi,x
	sta effect+1
loop2	ldy #00
	lda (effect),y
	dey
loop1	iny
	cmp EffectRangeThreshhold,y
	bcc loop1
	sbc EffectRangeThreshhold,y
	sta sfxTemp01
	lda EffectCommandVectorLo,y
	sta vector1+1
	lda EffectCommandVectorHi,y
	sta vector1+2
	inc EffectAddressLo,x
	bne skip1
	inc EffectAddressHi,x
skip1	lda sfxTemp01
vector1	jsr $dead
	bcs loop2
skip2	dex
	bpl loop3
.)
	rts
	
efc_VOFS		;-15 to +15	31 0-30
	tay
	lda ayVolume,x
	adc TwosStep,y
	sta ayVolume,x
	clc
	rts
efc_POFS		;-15 to +15	31 31-61
	tay
	cmp #16
.(
	bcs skip1
	lda ayPitchLo,x
	adc AbsolutePositiveStep,y
	sta ayPitchLo,x
	lda ayPitchHi,x
	adc #00
	sta ayPitchHi,x
	rts
skip1	sta sfxTemp01
.)
	lda ayPitchLo,x
	sbc AbsolutePositiveStep,y
	sta ayPitchLo,x
	lda ayPitchHi,x
	sbc #00
	sta ayPitchHi,x
	
	rts
	
	
efc_NOFS		;-15 to +15	31 62-92
	tay
	lda EffectNote,x
	adc TwosStep,y
	sta EffectNote,x
	sec
	rts
	
efc_OOFS		;-15 to +15	31 93-123
	tay
	lda ayNoise,x
	adc TwosStep,y
	sta ayNoise,x
	sec
	rts

efc_EOFS		;-15 to +15	31 124-154
	tay
	lda ayEGPeriod
	adc TwosStep,y
	sta ayEGPeriod
	sec
	rts

efc_TFlag		;Off or On		2  155-156
	lsr
	lda ayStatus
	and ToneMask,x
	bcs skip1
	ora ToneBit,x
skip1	sta ayStatus
	sec
	rts

efc_NFlag		;Off or On		2  157-158
	lsr
	lda ayStatus
	and NoiseMask,x
	bcs skip1
	ora NoiseBit,x
skip1	sta ayStatus
	sec
	rts

efc_EFlag		;Off or On		2  159-160
	asl
	asl
	asl
	asl
	sta EGFlag,x
	sec
	rts
efc_SetCounter	;0-31		32 161-202
	sta sfxCounter,x
	sec
	rts
efc_SetCondition
	sta sfxCondition,x
	sec
	rts
efc_Filter	;1-4		4  206-209
	sta sfxFilter,x
	sec
	rts
efc_Delay		;1-31		31 210-241
	sta sfxDelay,x
	sec
	rts
efc_EndSFX	;1		1  242-242
	lda #00
	sta EffectActivity,x
	clc
	rts

efc_ConditionalLoop	;1		1  243-243,Offset
	lda sfxCounter,x
	beq skip1
	dec sfxCounter,x
skip1	ldy sfxCondition,x
	beq DoBranch
	dey
	beq skip2
	lda sfxCounter,x
	bne DoBranch
Continue	?
skip2	lda ayVolume,x
	cmp #16
	bcs Continue
DoBranch	
	ldy #1
	lda (effect),y
	adc
	?
	
efc_Randomise
	tay
	jsr GetRandomNumber
	and RandomElementMask,y
	sta Temp01
	lda RandomElementRegister,y
	tay
	lda Temp01
	sta ayRegister,y
	rts

efc_SetNote	;1		1  249-249,Note
	ldy #1
	lda (effect),y
	sta EffectNote,x
	rts
	
efc_SetNoise
	ldy #1
	lda (effect),y
	sta ayNoise
	rts

efc_SetVolume	;1                   1  251-251,Volume
	ldy #1
	lda (effect),y
	sta ayVolume,x
	rts

efc_SetEG		;1                   1  252-252,EG Period low,EG Period high/Cycle
	ldy #1
	lda (effect),y
	sta ayEGPeriodLo
	iny
	lda (effect),y
	and #15
	sta ayEGPeriodHi
	lda (effect),y
	lsr
	lsr
	lsr
	lsr
	sta ayCycle
	rts

efc_Jump		;1		1  253-253,Address low,Address high
	ldy #01
	lda (effect),y
	sta EffectAddressLo,x
	iny
	lda (effect),y
	sta EffectAddressHi,x
	rts

efc_Gosub		;1		1  254-254,Address low,Address high
	;Calculate Stack Offset
	txa
	;The stack accomodates up to 4 embedded levels of gosubs
	asl
	asl
	ora StackPointer,x	;0-3
	asl
	tay
	;Fetch and store the next effect command address on the stack
	lda effect
	clc
	adc #3
	sta EffectGosubStack,y
	lda effect+1
	adc #0
	sta EffectGosubStack+1,y
	inc StackPointer,x
	jmp efc_Jump

efc_Return	;1		1  255-255
	lda StackPointer,x
	beq
	dec StackPointer,x
	txa
	;The stack accomodates up to 4 embedded levels of gosubs
	asl
	asl
	ora StackPointer,x	;0-3
	asl
	tay
	;Fetch the previous address
	lda EffectGosubStack,y
	sta EffectAddressLo,x
	lda EffectGosubStack+1,y
	sta EffectAddressHi,x
	rts
	
	