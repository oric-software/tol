'Animations.s holds code and data for all background Game animations.
'This covers ascii character codes 40 to 43.
'The animation set changes for each character set, and their are two.
'The number of frames may also be different.

'Animations will run as quickly as this routine is called (probably about 10Hz)

'We'll  first need a large outer loop that will count the ascii character.
          ldx #03
'We'll also need the ascii address.
          lda ascii_character_address_lo+8,x
          sta Zero_00
          lda ascii_character_address_hi+8,x
          sta Zero_01
'We then need some sort of index that combines the character with its current set
'loop2     txa
          asl
          ora current_character_set+8,x   '// 32+8 = 40
          tay
'Y may contain 8 values which represent an index to a unique character animation.
'0 Character set 0, Ascii 40
'1 Character set 1, Ascii 40
'2 Character set 0, Ascii 41
'3 Character set 1, Ascii 41
'4 Character set 0, Ascii 42
'5 Character set 1, Ascii 42
'6 Character set 0, Ascii 43
'7 Character set 1, Ascii 43
'We can now use Y to fetch the frame index for the unique character animation.
          sty uca_index
          lda frame_index,y
'We can then use this as an index to getting the frame bitmap address.
          tay
          lda source_frame_address_lo,y
          sta Zero_02
          lda source_frame_address_hi,y
          sta Zero_03
'And that's all we need to copy the frame
          '// Copy frame to Ascii
          ldy #07
loop1     lda (Zero_02),y
          sta (Zero_00),y
          dey
          bpl loop1
'Finally, we must update the frame index.
          '// Update frame index
          ldy uca_index
          lda frame_index,y
          adc #01
          cmp end_frame_for_animation,y
          bcc skip
          lda first_frame_for_animation,y
skip      sta frame_index,y
          dex
          bpl loop2
          rts

'We now need to review the tables and decide how to populate them.
'Their are a total of 56 Animation Frames, each one 8 bytes long.

'source_frame_address_lo   (56)
'source_frame_address_hi   (56)
'frame_index               (8)
'end_frame_for_animation   (8)
'first_frame_for_animation (8)

'The table below was taken from the map analysis (mapbg.txt) that was done earlier.

'Animation       Frames  Bytes_Total
'Fire Pit        8       (2*8)*8 = 128
'Sea             4       (1*8)*4 = 32
'Waves           12      (1*8)*12= 96
'Floor           12      (1*8)*12= 96
'Falls           8       (1*8)*8 = 64
'River           6       (1*8)*6 = 48
'Twig            6       (1*8)*6 = 48

'Total Memory for all frames == 512 Bytes

'From this, we could calculate all tables. However, as a precaution, we should
'design all frames before progressing. We may find just 6 frames are sufficient for
'Waves, or more frames are needed for the Sea.

'But what do we use to edit the frames? Well, i would use the 1990 program CHARED for
'all except the fire pit where i would use OBED91.
'Note that both CHARED and OBED91 have animation facilities.
'Both these programs will generate character sets for all the frames.
'We can then lprint the values in Euphoric to the printer.txt text file and insert them
'below in animation_frames.
'However, i found it easier to manually populate the binary fields.

'These two tables do not require the specific sequence observed by the animations but
'do require each frame-set to be in sequence. Also, All animations have been reduced
'to 4 frames.

'So...
'        Set1    Set2
'40      Pit     Sea      'Inversed
'41      Pit     Waves    'Inversed
'42      Floor   River
'43      Falls   Twig

'4 characters(8 bytes in each char) over 2 charsets is 64 bytes.
'4 frames = 256 Bytes

source_frame_address_lo   (32)
 .byt <FirePit_animation_tlbr0
 .byt <FirePit_animation_tlbr1
 .byt <FirePit_animation_tlbr2
 .byt <FirePit_animation_tlbr3
 .byt <FirePit_animation_trbl0
 .byt <FirePit_animation_trbl1
 .byt <FirePit_animation_trbl2
 .byt <FirePit_animation_trbl3
 .byt <MagicalFloor_animation0
 .byt <MagicalFloor_animation1
 .byt <MagicalFloor_animation2
 .byt <MagicalFloor_animation3
 .byt <WaterFall_animation0
 .byt <WaterFall_animation1
 .byt <WaterFall_animation2
 .byt <WaterFall_animation3
 .byt <Sea_animation0
 .byt <Sea_animation1
 .byt <Sea_animation2
 .byt <Sea_animation3
 .byt <Wave_animation0
 .byt <Wave_animation1
 .byt <Wave_animation2
 .byt <Wave_animation3
 .byt <River_animation0
 .byt <River_animation1
 .byt <River_animation2
 .byt <River_animation3
 .byt <twig_animation0
 .byt <twig_animation1
 .byt <twig_animation2
 .byt <twig_animation3
source_frame_address_hi   (32)
 .byt >FirePit_animation_tlbr0
 .byt >FirePit_animation_tlbr1
 .byt >FirePit_animation_tlbr2
 .byt >FirePit_animation_tlbr3
 .byt >FirePit_animation_trbl0
 .byt >FirePit_animation_trbl1
 .byt >FirePit_animation_trbl2
 .byt >FirePit_animation_trbl3
 .byt >MagicalFloor_animation0
 .byt >MagicalFloor_animation1
 .byt >MagicalFloor_animation2
 .byt >MagicalFloor_animation3
 .byt >WaterFall_animation0
 .byt >WaterFall_animation1
 .byt >WaterFall_animation2
 .byt >WaterFall_animation3
 .byt >Sea_animation0
 .byt >Sea_animation1
 .byt >Sea_animation2
 .byt >Sea_animation3
 .byt >Wave_animation0
 .byt >Wave_animation1
 .byt >Wave_animation2
 .byt >Wave_animation3
 .byt >River_animation0
 .byt >River_animation1
 .byt >River_animation2
 .byt >River_animation3
 .byt >twig_animation0
 .byt >twig_animation1
 .byt >twig_animation2
 .byt >twig_animation3

'0 Character set 0, Ascii 40
'1 Character set 1, Ascii 40
'2 Character set 0, Ascii 41
'3 Character set 1, Ascii 41
'4 Character set 0, Ascii 42
'5 Character set 1, Ascii 42
'6 Character set 0, Ascii 43
'7 Character set 1, Ascii 43
frame_index               '(8)
 .byt 0,16,4,20,8,24,12,28
first_frame_for_animation '(8)
 .byt 0,16,4,20,8,24,12,28
end_frame_for_animation   '(8)
 .byt 4,20,8,24,12,28,16,32

animation_frames
twig_animation0
 .byt %000000
 .byt %000100
 .byt %010010
 .byt %001100
 .byt %000010
 .byt %000100
 .byt %000000
 .byt %000010
twig_animation1
 .byt %000000
 .byt %001100
 .byt %010000
 .byt %001100
 .byt %000000
 .byt %001100
 .byt %000000
 .byt %001100
twig_animation2
 .byt %010000
 .byt %001000
 .byt %010000
 .byt %001100
 .byt %000000
 .byt %010100
 .byt %000000
 .byt %010000
twig_animation3
 .byt %010000
 .byt %000000
 .byt %010000
 .byt %001101
 .byt %000000
 .byt %100000
 .byt %000000
 .byt %000001

FirePit_animation_tlbr0
 .byt %100100
 .byt %010110
 .byt %010001
 .byt %001000
 .byt %000100
 .byt %000110
 .byt %100011
 .byt %010001
FirePit_animation_tlbr1
 .byt %101100
 .byt %100010
 .byt %010000
 .byt %001000
 .byt %001110
 .byt %000111
 .byt %100010
 .byt %001001
FirePit_animation_tlbr2
 .byt %000101
 .byt %100000
 .byt %010000
 .byt %010100
 .byt %001010
 .byt %000101
 .byt %010010
 .byt %001001
FirePit_animation_tlbr3
 .byt %100001
 .byt %100100
 .byt %100010
 .byt %010101
 .byt %001000
 .byt %100100
 .byt %010011
 .byt %001001

FirePit_animation_trbl0
 .byt %001000
 .byt %000100
 .byt %000100
 .byt %100010
 .byt %010001
 .byt %011000
 .byt %001000
 .byt %001000
FirePit_animation_trbl1
 .byt %000100
 .byt %100100
 .byt %100010
 .byt %010001
 .byt %001000
 .byt %001100
 .byt %001110
 .byt %011010
FirePit_animation_trbl2
 .byt %001001
 .byt %000101
 .byt %100010
 .byt %010000
 .byt %001000
 .byt %010100
 .byt %100100
 .byt %001010
FirePit_animation_trbl3
 .byt %001000
 .byt %000101
 .byt %100000
 .byt %010000
 .byt %001000
 .byt %001001
 .byt %000100
 .byt %010010

MagicalFloor_animation0       'May change this is Torch?
 .byt %011011
 .byt %011000
 .byt %011011
 .byt %000011
 .byt %011011
 .byt %011000
 .byt %011011
 .byt %000011
MagicalFloor_animation1
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
MagicalFloor_animation2
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
MagicalFloor_animation3
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001
 .byt %010010
 .byt %001000
 .byt %010010
 .byt %000001

River_animation0
 .byt %100000
 .byt %000110
 .byt %011001
 .byt %100000
 .byt %000100
 .byt %100001
 .byt %010110
 .byt %001000
River_animation1
 .byt %100000
 .byt %001100
 .byt %110011
 .byt %000000
 .byt %011000
 .byt %000010
 .byt %101101
 .byt %010000
River_animation2
 .byt %000000
 .byt %011010
 .byt %100100
 .byt %000011
 .byt %100000
 .byt %000110
 .byt %001001
 .byt %110000
River_animation3
 .byt %000000
 .byt %001000
 .byt %110011
 .byt %001100
 .byt %000010
 .byt %000000
 .byt %111100
 .byt %000011

Sea_animation0
 .byt %000000
 .byt %000100
 .byt %000010
 .byt %000000
 .byt %010000
 .byt %001000
 .byt %000001
 .byt %100000
Sea_animation1
 .byt %001000
 .byt %000100
 .byt %000000
 .byt %000000
 .byt %100000
 .byt %010001
 .byt %000010
 .byt %000000
Sea_animation2
 .byt %010000
 .byt %001000
 .byt %000000
 .byt %000000
 .byt %000010
 .byt %100100
 .byt %010000
 .byt %000000
Sea_animation3
 .byt %000000
 .byt %001000
 .byt %000100
 .byt %000000
 .byt %001000
 .byt %000101
 .byt %000010
 .byt %000000

Wave_animation0
 .byt %001000
 .byt %001110
 .byt %000101
 .byt %000110
 .byt %001011
 .byt %010110
 .byt %001101
 .byt %001010
Wave_animation1
 .byt %000100
 .byt %000110
 .byt %100010
 .byt %000111
 .byt %100001
 .byt %000111
 .byt %100110
 .byt %000101
Wave_animation2
 .byt %000010
 .byt %000001
 .byt %010001
 .byt %100010
 .byt %110000
 .byt %100010
 .byt %010001
 .byt %100010
Wave_animation3
 .byt %000100
 .byt %000010
 .byt %000000
 .byt %000101
 .byt %100000
 .byt %000101
 .byt %000010
 .byt %000100

'This should not be a vertical animation, but a surf explosion of water
WaterFall_animation0
 .byt %010010
 .byt %001001
 .byt %001010
 .byt %010010
 .byt %001010
 .byt %001001
 .byt %001010
 .byt %010010
WaterFall_animation0
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
WaterFall_animation0
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
WaterFall_animation0
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %
 .byt %

