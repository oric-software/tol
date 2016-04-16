;Detect Controller by detecting Fire
;1) Set up Soft key column
;2) Detect Telestrat
;3) Check for Telestrat Fire Left Joystick
;4) Check for Telestrat Fire Right Joystick
;5) Sense IJK Interface
;6) Check for IJK Fire Left Joystick
;7) Check for IJK Fire Right Joystick
;8) Check for Altai Fire Left Joystick
;9) Check for Altai Fire Right Joystick
;10) Check for Key Set 1 Fire (Left Control)
;11) Check for Key Set 2 Fire (Function)

;BFE0
; 0 Telestrat Left Joystick
; 1 Telestrat Right Joystick
; 2 IJK Left Joystick
; 3 IJK Right Joystick
; 4 Altai Left Joystick
; 5 Altai Right Joystick
; 6 Keyset #1 LeftCtrl Cursors
; 7 Keyset #2 Funct Cursors

SenseFire
	ldx #00
	;Set up Key Soft Column
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$FD
	sta VIA_PCR
	lda #%00001000
	sta VIA_PORTA
	lda #$DD
	sta VIA_PCR
.(
loop1	;Is this a telestrat?
	lda VIA2_DDRA
	cmp #%00010111
	bne NotTelestrat

	;Sense Telestrats Left Joystick movement
	lda #%01000000
	sta VIA2_PORTB
	lda VIA2_PORTB
	and #%00011111
	bne ControllerDetected

	;Sense Telestrats Right Joystick movement
	inx
	lda #%10000000
	sta VIA2_PORTB
	lda VIA2_PORTB
	and #%00011111
	bne ControllerDetected

	;Is there an IJK Interface attached?
	lda #$C0
	sta VIA_PORTA
	lda VIA_PORTA
	cmp #$FF
	bne SenseAltai

	;Sense IJK Left Joystick
	inx
	lda #%10110111
	sta VIA_DDRB
	lda #%00000000
	sta VIA_PORTB
	lda #%11000000
	sta VIA_DDRA
	lda #%01111111
	sta VIA_PORTA
	lda VIA_PORTA
	and #%00011111
	eor #%00011111
	bne ControllerDetected

	;Sense IJK Right Joystick
	inx
	lda #%10111111
	sta VIA_PORTA
	lda VIA_PORTA
	and #%00011111
	eor #%00011111
	bne ControllerDetected
	jmp DetectKeys

	;Sense Altai Left Joystick
	ldx #4
	lda #%11000000
	sta VIA_DDRA
	lda #%10000000
	sta VIA_PORTA
	lda VIA_PORTA
	and #%00011111
	eor #%00011111
	bne ControllerDetected

	;Sense Altai Right Joystick
	inx
	lda #%01000000
	sta VIA_PORTA
	lda VIA_PORTA
	and #%00011111
	eor #%00011111
	bne ControllerDetected

DetectKeys
	;Sense Left Control Key
	lda #2
	sta VIA_PORTB
	ldx #6
	lda #8
	and VIA_PORTB
	bne ControllerDetected

	;Sense Funct Key
	lda #5
	sta VIA_PORTB
	inx
	lda #8
	and VIA_PORTB
	bne ControllerDetected
	jmp loop1
ControllerDetected
.)
	stx $BFE0
	rts

