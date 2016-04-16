;PrintModule.s


PrintMemoryRange
	ldx #00	;TextByteIndex
.(
loop1	ldy #00
	lda (StartAddress),y
	sta Byte2Print
	jsr LPrintByte
	
	inx
	txa
	and #15
	tax
	
	lda StartAddress
	clc
	adc #1
	sta StartAddress
	lda StartAddress+1
	adc #00
	sta StartAddress+1
	
	cmp EndAddress+1
	bcc loop1
	bne skip1
	lda StartAddress
	cmp EndAddress
	beq loop1
	bcc loop1
skip1	;End with CRLF
.)
	jmp LPrintCRLF

LPrintByte
	;Print depends on current text byte index
	cpx #00
.(
	bne skip1
	;LPrint " .byt $HL"
	lda #" "
	jsr LPrintCharacter
	lda #"."
	jsr LPrintCharacter
	lda #"b"
	jsr LPrintCharacter
	lda #"y"
	jsr LPrintCharacter
	lda #"t"
	jsr LPrintCharacter
	lda #" "
	jsr LPrintCharacter
	lda Byte2Print
	jmp DisplayDollarHL
	
skip1	cpx #15
	bne skip2
	;LPrint ",$HL"+CRLF
	jsr DisplayCommaDollarHL
	jmp LPrintCRLF
	
skip2	;LPrint ",$HL"
.)
DisplayCommaDollarHL
	lda #","
	jsr LPrintCharacter
DisplayDollarHL
	lda #"$"
	jsr LPrintCharacter
DisplayHL
	lda Byte2Print
	lsr
	lsr
	lsr
	lsr
	jsr LPrintHexDigit
	lda Byte2Print
LPrintHexDigit
	and #15
	cmp #10
.(
	bcc skip1
	adc #6
skip1	adc #48
.)	
	jmp LPrintCharacter

LPrintCRLF
	lda #13
	jsr LPrintCharacter
	lda #10
	jmp LPrintCharacter
	
Byte2Print	.byt 0

	
	
