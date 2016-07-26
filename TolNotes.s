;TOL Notes and locations
;To load game, CLOAD"TOLTOP":CLOAD"TOLGAME"
;These are taken from CompileTopOfMemory.bat and BuildIt4Game.bat in C:\OSDK\Projects\TimesOfLore\tol\source

;TOL Game inlay
;TOLGFX.DSK TOLINLAY2.HRS

;TOL Storybook Section
;TOL.DSK	TRY.COM

;TOL Storybook Characters
;TOLGFX.DSK TOLINLCHS.HRS (questionable)

;TOL Storybook Original Story screens
;TOL.DSK	STORY1.HRS
;	STORY2.HRS
;	STORY3.HRS
;	STORY4.HRS
;	STORY5.HRS
;	STORY6.HRS
;	STORY7.HRS
;	KNIGHT.HRS
;	VALKYRIE.HRS
;	WARRIOR.HRS
;	SELECT9.HRS

;TOL Storybook Template
;TOL.DSK
;	TEMPLATE.HRS	HIRES Template with border graphics only
;TOLDEMO2.DSK
;	CORNER.HRS	HIRES Top left corner border graphic



;TOL Storybook Letters not found but TOL.DSK/FORCOL.HRS has some.

;TOL Title DoorFrames(33x120)
;TOLDEMO2.DSK
;	TOLDF02.HRS
;	TOLDF12.HRS
;	TOLDF22.HRS
;	TOLDF32.HRS

;TOL b/w Tixxxxxx/'tle
;TOLDEMO2.DSK
;	WHITE.HRS
;	CANVAS.HRS
;TOL Colour Title(38x120)
;TOLDEMO2.DSK
;	TOL992.HRS(Old)
;	GOLD.HRS
;TOL Title text
;TOLDEMO2.DSK
;	LETTERS.HRS
;	LETTERS.CHS
;	HAND.HRS
;	STTL.COM Converts hires to text and saves LETTERS.CHS
;	TOLTITLE.SCN (Contains second under HIRES overlay to restore Hand Characters)

;TOL Title Chisel Frames
;TOLDEMO2.DSK
;	CHISEL.HRS

;Tape Game files
;SideA 00 Title(For game, "Flip tape and rewind")
;SideA 01 Storybook
;SideB 00 Game(Return to Title, "Flip tape and rewind")
;SideB 01 Outro

;Title Sequence
; Display Twilighte logo
; Display Phase out
; Display bw Title
; Display Options
; Display Hand
; Chisel TOL
; Init Music
; Colour TOL
;Do
; Display Door Sequence
; Display Colour TOL
; Detect/control hand
;Loop
;On Map&Options
; Display Map
; Display Options
;On Return
; (Flip Tape, Rewind Prompt)
; Load Game
;On New
; Load Storybook
 

;Storybook Sequence
;For Screen=1 to 6
; Display Template with Filagree
; Open screen
; Decrunch Picture
; Init Music
; Display Text
; Wait on Key/Joy
; Close Screen
;next
; Display Template with Filagree
; Open screen
; Decrunch Selection Picture
; Init Music
; Display Text
; Wait on Character Selection
; Close Screen
;Display Template with Filagree
;Open screen
;Decrunch Character Picture
;Display Character Synopsis

VIA view (26x19)

   01234567890123456789012345
01 R1 IORAH $00 %00000000
02 R2 DDRB       ^^^^^^^^(-)
03 R3 DDRA       ^^^^^^^^(-)

04 R4 T1CL  $00 20000
05 R5 T1CH  $00 Cont IRQ
06 R6 T1LL  $00 65535
07 R7 T1LH  $00

08 R8 T2LL  $FF 255
09 R9 T2CH  $00 Timed IRQ

10 RA SR    $00 %00000000
11 RB ACR   00 0 000 0 0
12 RC PCR   000 0 000 0
13              C C   C C
14          T T B B S A A
15          1 2 1 2 R 1 2
16 RD IFR   0 0 0 0 0 0 0
17 RE IER   1 0 0 0 0 0 0
18 RF IORA

01234567890123456789012345
===== CONTROL LINES ======
CB1 - Cass In    : 0
 Negative Active Edge(0)
CB2 - AY Ctrl    : 0
 110 Low Output
PB7 - Cass Out   : 0 >
PB6 - Cass Motor : 0 >
PB5 - Not Used   : 0 >
PB4 - Prt Strobe : 0 >
PB3 - Key State  : 0 <
PB2 - Key Row B2 : 0 >
PB1 - Key Row B1 : 0 >
PB0 - Key Row B0 : 0 >

CA1 - Prt Ack    : 0
 Negative Active Edge(0)
CA2 - AY Ctrl    : 0
 110 Low Output
PAH - Port A HS  : 00
PA  - Port A     : 00

===== 6522 TIMERS