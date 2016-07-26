Map.s
Map.s contains subroutines related to the map.
fetch_map will get the map at the supplied map coordinates.
fetch_block will get the block at the supplied block coordinates.
fetch_character will get the character at the supplied character coordinates.
character2ascii will return the ascii character for a supplied character
character2Attribute will return the attribute for a supplied character.

Some internal subroutines also exist.
extract_TSMap extracts bigmap location from map coordinates
extract_Map extracts map location from map coordinates
extract_Block

bbmmmsss ssss

Note: Routine does not use X and Y.

fetch_character
          lda test_xl
          sta extracted_xl
          lda test_xh
          sta extracted_xh

          asl extracted_xl
          rol extracted_xh
          asl extracted_xl
          rol extracted_xh
          asl extracted_xl
          rol extracted_xh
          '// extracted_xh now contains TSMap X
          lda test_yl
          and #%11100000
          sta extracted_yl
          lda test_yh
          sta extracted_yh

          asl extracted_yl
          rol extracted_yh
          asl extracted_yl
          rol extracted_yh
'          asl extracted_yl
'          rol extracted_yh
          '// extracted_yh now contains TSMap Y
Note that the last 16 bit shift is remmed out. This is a shortcut, since we need
extracted_yl and extracted_yh to form xxxxxxxB BBBBBB, then we can simply OR it with
extracted_xh to get the correct offset.

We now need to convert...
xxxxxxx yyyyyyy
into...
01234567 012345
xxxxxxxy yyyyyy

          lda extracted_yl
          ora extracted_xh
          sta extracted_xh

So now extracted_xh and extracted_yh form a 14 bit offset within the TSMap.
So just add to base address of TSMap and fetch (using self-modified code) the
byte at that location.

          lda TSMAP_Vector_lo
          adc extracted_xh
          sta Vector+1
          lda TSMAP_Vector_hi
          adc extracted_yh
          sta Vector+2
          lda #00             '// These three lines are actually required
          sta Map_lo          '// by the next section and the section
          sta block_hi        '// After.
Vector    lda $dead
          sta Map_Number
TSMAP_Byte points to the map number, which we'll need to multiply by the map size (64)
and add to the map base to get the map location
Their are around 120 maps in TOL, so we'll need to use 16 bit again.
Rather than shifting left 6 times, it will be better to shift right 3 times

mmmmmmm
to
xxxxxxmm mmmmm

          lsr
          ror Map_lo
          lsr
          ror Map_lo
          sta Map_hi

We now need to capture the offset in the 8*8 map with will create a 6 bit position that we
combine with map_lo and map_hi to get the map offset

bbmmmsss ssss
          lda test_xl
          and #%00011100
          lsr
          lsr
          sta map_x
          lda test_yl
          and #%00011100
          asl
          ora map_x
          ora map_lo
          adc MAP_Vector_lo
          sta Vector+1
          lda map_hi
          adc MAP_Vector_hi
          sta Vector+2
Vector    lda $dead
          sta Block_Number

Block_Number points to the Block number, which we'll need to multiply by the block size (16)
and add to the block base to get the block location.
Their are a total of around 180 blocks, so we'll need to work in 16 bit again.
          asl
          rol block_hi
          asl
          rol block_hi
          asl
          rol block_hi
          asl
          rol block_hi
          sta block_lo


Finally, we need to capture the offset in the 4*4 block
So again
bbmmmsss ssss

          lda test_xl
          and #%00000011
          sta block_x
          lda test_yl
          and #%00000011
          asl                 '000000VV >> 00000VV0
          asl                 '00000VV0 >> 0000VV00
          ora block_x         '0000VV00 OR 000000VV

          ora block_lo        'VVVV0000 OR 0000VVVV

          adc BLOCK_Vector_lo
          sta Vector+1
          lda block_hi
          adc BLOCK_Vector_hi
          sta Vector+2
Vector    lda $dead
          sta Character_Number
          rts


Character2ascii is the routine that converts the character held either in the map or
the background buffer into a displayable ascii character (or attribute).

The routine is also responsible for redefining any character that requires a different
character set than it is currently using.

Characters are from 0 to 158
000-031 Attributes
032-094 Characters taken from Set1 (40-43 are animated, 40-41 are inversed)
095     Reserved (Used for Enemy Weapon thrown)
096-158 Characters taken from Set2 (104-107 are animated, 104-105 are inversed)

6 Tables are used...
CURRENT_CHARACTER_SET holds the charset flag to indicate if Set1 or 2 is currently in use
CHARACTER_CODE holds the true code, which effectively adds 128 to ascii 40 and 41
CHARACTER_SET1_ADDRESS_LO holds the character addresses for set1 (-512 for set0)
CHARACTER_SET1_ADDRESS_HI holds the character addresses for set1 (-512 for set0)
ASCII_CHARACTER_ADDRESS_LO holds the actual ascii address of a given character
ASCII_CHARACTER_ADDRESS_HI holds the actual ascii address of a given character

character2ascii
          cmp #32
          bcc skip1
          cmp #96   'make carry hold character set
          bcc character_set0
character_set1
          tax
          lda current_character_set-96,x          '64 bytes long
          beq Change_character2set1
          lda character_code-96,x                 '64 bytes long
          rts
character_set0
          tax
          lda current_character_set-32,x
          bne Change_character2set0
          lda character_code-32,x   '//this will add the 128 if appropriate
skip1     rts

Change_character2set1
          '// Flag Character Set 1
          lda #01
          sta current_character_set-96,x
          '// fetch character address from 1
          lda character_set1_address_lo-96,x      '64 long
          sta Vector1+1
          lda character_set1_address_hi-96,x      '64 long
          sta Vector1+2
          '// fetch actual ascii address
          lda ascii_character_address_lo-96,x     '64 long
          sta Vector2+1
          lda ascii_character_address_hi-96,x     '64 long
          sta Vector2+2
          lda character_code-96,x
          pha
          ldx #07
Loop
Vector1   lda $DEAD,x
Vector2   sta $DEAD,x
          dex
          bpl Loop
          pla
          rts

Change_character2set0
          '// Flag Character Set 0
          lda #00
          sta current_character_set-32,x
          '// fetch character address from 1
          lda character_set1_address_lo-32-512,x      '64 long
          sta Vector1+1
          lda character_set1_address_hi-32-512,x      '64 long
          sta Vector1+2
          '// fetch actual ascii address
          lda ascii_character_address_lo-32,x     '64 long
          sta Vector2+1
          lda ascii_character_address_hi-32,x     '64 long
          sta Vector2+2
          lda character_code-32,x
          pha
          ldx #07
Loop
Vector1   lda $DEAD,x
Vector2   sta $DEAD,x
          dex
          bpl Loop
          pla
          rts





character2attribute
          sta Vector+1
Vector    lda XX00  'where XX is character_attribute_table high byte
          rts

fetch_block
Fetch block is significantly different to fetch character not only because their is not
so much processing to do, but also block-coordinates are supplied, not character
coordinates.




3)
Furthermore, because of colour position limitations when dealing with building interiors,
the decision was made to not allow the Hero to enter any buildings (caves and tunnels
excluded).
This also means that Sprites that would usually reside only inside buildings (Barkeeper,
Soup Drinker, Beer Drinker, Hero Sleeping) need not exist anymore.
if a Hero wishes to take lodgings in a bar, they may approach it's door (Needs some
special identification as an Inn) and take the neccesary action on attempting to enter.



5)
The Memory will be limited to 48K, not the full 64K. This will allow a tape version to
exist.
The map is the crucual part of the project. This contains all the background graphics used
in the game.
Even so, only 64 characters are ever displayed.
Because TOL arena is so vast, it was decided to add an extra level of mapping.
for this reason, i chose Mike Wiering's Tile Studio as the Top level map editor.
I could potentially have also done all the mapping in Tile Studio but because of the
special colour requirements and extended character sets (More on this later) i enhanced
an older map utility on the Oric.
Maps are a way to form large expanses of background graphics whilst reducing the amount
of memory.
Typical maps consist of two tiers.
The first tier is the character graphic. Because of the 64 character limitation,
each character will have an associated attribute (held in the 256 character_attribute table)

The first two bits define the character set that the Oric character (32-95) takes its
definition from.

character_attribute_table
b0-1 Character Set
          0 Character set 0
          1 Character set 1
          2 Character set 2

The second three bits contain the associated colour of the character. I cannot go into
too much detail but the colour column (leftmost on the screen) needs to represent the
colours associated to the characters adjacent to it.

B2-4 Character Colour

The last 3 bits specify the collision and surface types

B5-7 Character surface definition
          0 Pass      Gravel
          1 Pass      Grass
          2 Pass      Stone
          3 Pass      Water (Shallow)
          4 Resistant Wall/Attribute crossover
          5 Entrance  Door, Gate (Conditional)
          6 Damage    Rock Incline/Magical Field
          7 Kill      Fire Pit

The type of surface will have a bearing on the type of sound each footprint makes.
Stone will create a click, Grass a thud, Water a splash, etc.

The first tier of the map is typically called a Block and each block holds an element
whose range is from 0 to 255.
This element directly indexes the character_attribute_table, whilst the character can be
derived from the following equation...

Displayed Character = 32+(Element / 4)

Characters from 224 to 255 are always inversed. Inversed characters must always be
obstructions, to prevent hero corruption when standing over them.
Inverse is useful for extra colour around certain objects such as fire pits.

Blocks in TOL are all 4*4. Their are a total of 256 Blocks.

The next tier is known as a Sector. Each Sector holds a definition of which blocks
reside in it. Under normal curcumstances, this tier would be the last tier and would be
classed as the Map.

However, With TOL's enormous playing field, and the freedom of being able to travel the
length and breadth of the land (and islands) without interruption required another
tier.

