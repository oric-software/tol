'// Game IRQ (Page 2 Driver)
' Note that this IRQ routine is cloaded into Screen-Buffer then transferred to page 2 using
' InitGame routine which is also in the Screen Buffer.

'Functionality Breakdown
'1) Read Keys
'Bit      Control             Key
'0        Spare               Spare
'1        Left                Cursor Left
'2        Right               Cursor Right
'3        Up                  Cursor Up
'4        Down                Cursor Down
'5        Fire                Space
'6        Next Page           Return
'7        Icon Control        Ctrl
'2) Random Number Generator
'3) Call Sound Effects
'4) Call Animation
'5) Call Candle (Flame & Flicker Only)
'6) Time of Day (Night/Day Shading, Time events)

'Memory breakdown
'0200 IRQ Code (Part I)
'0244 IRQ Vector (0200)
'0247 NMI Vector
'024A IRQ Code (Part II)




irq_handler
          pha
          txa
          pha
          tya
          pha
          '// Reset IRQ
          lda irq_ifr
          '// Keys
          jsr read_keys
          '// Generate 16bit Random Number
          jsr generate_rnd
          '// SFX
          jsr proc_sfx
          '// Animation
          jsr proc_anim
          '// Candle Flame
          jsr proc_flame
          '// Time of Day
          jsr proc_tod
          pla
          tay
          pla
          tax
          pla
          rti

read_keys
          'Setup column register
          lda #$0E
          sta via_pcr
          lda #$ff
          sta via_pcr
          ldy #$dd
          sty via_pcr
          ldx #07
loop      ' Get Column
          lda key_column,x
          sta via_porta
          ' Get Row
          lda key_row,x
          sta via_portb
          ' Set Data
          lda #$fd
          sta via_pcr
          ' Reset pcr. This also acts as the delay
          lda #$dd
          sta via_pcr
          ' Get Key
          lda via_portb
          and #8
          cmp #8
          ' Shift into Key register
          rol key_register
          dex
          bpl loop
          rts

generate_rnd
          '// Fetch Key register
          lda key_register
          '// Add Top left corner of BG Buffer
          adc bg_buffer
          '// EOR with icon selector
          eor icon_pointer
          '//
          sta rnd_byte

'key_column and key_row should really go just above the Sprite Hero Memory
'
'0        Spare               Spare (Could be 'Map View' or Mode)
'1        Left                Cursor Left
'2        Right               Cursor Right
'3        Up                  Cursor Up
'4        Down                Cursor Down
'5        Fire                Space
'6        Next Page           Return
'7        Icon Control        Ctrl
key_column          'B0-7
 .byt 0,df,7f,f7,bf,fe,df,ef
key_row
 .byt 0,4,4,4,4,4,7,2


'Sound Channels are split thus...
'Channel A - Hero Walk and Weapon sfx (Also Icon or Menu SFX)
'0        None
'1        Walk on Grass (Thump)
'2        Walk on Gravel (Crunch)
'3        Walk on Stone (Tap)
'4        Walk on Water (Splash)
'5        Clash of weapon
'6
'Channel B - Environment Sounds
'Channel C - Sprite Creatures Walk and weapon sfx

proc_sfx
          lda effect_triggerA
          beq
          lda a_action
