Score covers...
1) HIRES Character set (for displaying Window messages)
2) Map Display
3) Icon Control
4) Messages and window handling
5) Candle Code and animations.


1) HIRES Character set (for displaying Window messages)
All characters displayed in the message window are in HIRES and therefore may be made 6*6 pixels.
They will need to cover both upper and lowercase font together with numbers and some punctuation.

ABCDEFGHIJKLMNOPQRSTUVWXYZ      26
abcdefghijklmnopqrstuvwxyz      26
0123456789                      10
!"&()-:'/,.?                    12
Colours 0 through 7 (No 6 because that is the colour of the window BG)
Flash On  (Hardware Flashing)
Flash Off (Hardware Flashing)
Page Fold (To indicate next Page request to player)

The latter character is important because scrolling the HIRES message window is time
consuming, and would drastically slow gameplay if expected to be done in realtime.
When the bottom line is reached and used, this character will appear bottom-right
and the player will be expected to press a button/key to clear the window and start
displaying messages from the top again.


This makes a total of 85 Characters, which evaluates as 510(85*6) or #1FE Bytes.


All the text for TOL will be held in a single area known as message memory.
The characters used will be reformatted from ASCII to the 85 characters.
Plotting a character is easy as pie, but we need to keep track of the current
position which is known as the Carat.


On entering the routine, the accumulator will contain the character code (0-86).
Valid character codes may actually be from 1 to 86 whilst 0 is a space.
zero_TextCaratLo and zero_TextCaratHi are consecutive locations in zero page
that hold the current Carat location on the HIRES screen.

Note that plotting a character does not corrupt X or Y Registers.

plot_character
          stx temp_x
          sty temp_y
          '// multiply character by 6 and add base address of character set
          ldx #00
          stx zero_sourcehi
          sec
          sbc #01
          bcc detected_space
          asl
          sta zero_sourcelo
          asl
          rol zero_sourcehi
          adc zero_sourcelo
          bcc skip1
          inc zero_sourcehi
skip1     adc #CharacterSetBaseLo
          sta Vector+1
          lda zero_sourcehi
          adc #CharacterSetBaseHi
          sta Vector+2
          '// now display the character
          ldx #05
loop      ldy screen_offset,x
Vector    lda $DEAD,x
          sta (zero_TextCaratLo),y
          dex
          bpl loop
          ldx temp_x
          ldy temp_y
detected_space
          rts

The new text window layout allows 21*8 characters.
This will used for all text based messages and prompts.

The system of displaying text must contain some intelligence, such
as...
1) ensure that a word does not span beyond a line (is taken to a new line).

All text plotting uses pointers tspointerlo/tspointerhi that point to the text
location. Text may either be terminated with a special flag or the routine is
provided with a length.

Spaces are always code 0.

display_word_by_length        'length in Acc
          '// Check for word length
          pha
          clc
          adc TextCaratX
          cmp #tc_XOverun
          bcc skip
          '// Word too long for current line, so move to next
          jsr ts_carriagereturn
skip
display_word_by_terminator



The new Displayed Map size will be 48*45 Pixels with clipped corners.
The map will always be displayed in green.
