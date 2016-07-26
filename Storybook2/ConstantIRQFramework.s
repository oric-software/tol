;Process 2 Interrupt requests without interruption.

;One variable frequency SID but low cpu usage(29 cycles) on T1
;One fixed 50Hz Music but higher cpu usage on T2

;If the IRQ is 50Hz Modify the return address to process
;the music and at end of music routine restore registers
;and jump back to main code.

;This means that the variable speed IRQ will always be constant
;and since the music routine is run as outside irq will also be
;constant (albeit a little slower) and the main background code
;will be none the wiser :)

;Ideally 50Hz IRQ would be driven from CB1 VBL hack and variable
;IRQ by T1 so allowing full control over SID by writing to T1
;Latches.
#define	STACK_LO	$100+?
#define	STACK_HI	$100+?
#define	STACK_SR	$100+?

#define	VIA_PORTB	$0300
#define	VIA_DDRB
#define	VIA_PAh
#define	VIA_DDRA
#define	VIA_T1CL	$0304
#define	VIA_T1CH	$0305
#define	VIA_T1LL	$0306
#define	VIA_T1LH	$0307
#define	VIA_T2LL	$0308
#define	VIA_T2CH	$0309
#define	VIA_SR	$030A
#define	VIA_ACR	$030B
#define	VIA_PCR	$030C
#define	VIA_IFR	$030D
#define	VIA_IER	$030E
#define	VIA_PORTA	$030F

IRQDriver	;Check which IRQ occurred
	bit VIA_IFR
	bvc T2IRQEvent
	
	;T1 variable frequency irq event
	sta IRQ2RegisterA+1
	
	;Reset IRQ event and set latch
	lda VIA_T1CL
	
	;It is assumed the SID register is always
	;set up and that CB2 pulse mode set up.
SIDValue	lda #00
SIDEOR	eor #00
	sta SIDValue+1
	sta VIA_PORTA
	lda VIA_PORTB
	
	;Restore Accumulator and end
IRQ2RegisterA
	lda #00
	rti
;~42 Cycles

T2IRQEvent
	;This is the interesting Event
	;First store all registers
	sta IRQ1RegisterA+1
	stx IRQ1RegisterX+1
	sty IRQ1RegisterY+1
	
	;Reset IRQ event
	lda #<20000
	sta VIA_T2CL
	lda #>20000
	sta VIA_T2CH
	
	;next record the return address in the jump
	;vector at the end of the music routine.
	;Note the return address is -1 of the actual
	;next instruction so we correct that.
	tsx
	lda STACK_LO,x
	clc
	adc #1
	sta MainVector+1
	lda STACK_HI,x
	adc #00
	sta MainVector+2
	
	;Also capture the status register
	lda STACK_SR,x
	sta StackVector+1
	
	;Now redirect the return address to the Music
	;routine
	lda #<MusicRoutine
	sta STACK_LO,x
	lda #>MusicRoutine
	sta STACK_HI,x
	
	;Finally restore used registers and End
IRQ1RegisterA
	lda #00
IRQ1RegisterX
	lda #00
	rti
	
MusicRoutine
	;Process music blahblahblah
	
	...
	
	;At end though we first restore original
	;register values and jump back to it
StackVector
	lda #00
	pha
	
	ldx IRQ1RegisterX+1
IRQ1RegisterY
	ldy #00
	lda IRQ1RegisterA+1
	plp
MainVector
	jmp $DEAD

;Reading Keyboard is a bit tricky since this takes
;place in the MusicRoutine service and will upset PORTA
;So keyboard is (by default) setup with Zero in Columm
;Register then we only need to write to PortB Row to sense
;a key then upset SID IRQ to locate exact key.

;Sending AYBank will also be tricky since (again) it is called
;at end of music routine. The way to handle it is to allow cpu
;to intercept with irq only after a register is sent.
;The IRQ will not be called more than onc or twice during the
;AY Bank send.
SendAYBank
	ldx #14
	lda AYBankWorking,x
	cmp AYBankReference,x
	beq
	sei
	stx VIA_PORTA
	ldy #$FF
	sty VIA_PCR
	ldy #$DD
	sty VIA_PCR
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	lda #$