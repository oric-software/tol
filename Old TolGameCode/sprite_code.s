TOL Game areas
1)
TOL Sprite graphics must be optimised since each sprite needs to have a sister mask
to Mask it against the background.
The method devised is crude, but cheap on memory.
01234567
bbbbbbmm
01234512

m1/m2 define mask for b0-2 and b3-5 respectively.

to calculate mask, we use this code

        lda data
        pha
        and #%11000000
        asl
        rol
        rol
        tax
        pla

The result is that X will contain an index to a 4 byte mask image table and
A will contain the original 8 bit byte. However since a displayed TEXT graphic
ignores the top two bits, their is no need to exclude them.

2)
Their must also exist a further level of optimisation.
The character set is split into background and object areas.
The background consumes 63 TEXT STD characters
The Objects consume the remaining 33 Characters.

33 Characters for sprites is very limited. These must cover the main hero, objects dropped,
Arrows and weapons thrown and the enemy sprites.

4 Enemy Sprites should exist, not only because of the limited characters but also because
4 are about the maximum masked sprites possible in the TOL game engine under 6502 1Mhz.
Since observing the correct aspect ratio and size of the sprites to both the background
and the hero, they would usually occupy 9 characters (3*3 matrix).
This is obviously too much, so to optimise the space, Each sprite is mapped into 6 characters
with a seperate definition table to define the 6 character pattern.

012
34
 5

          ldx sprite_index
          lda sprites_first_char,x
          ldy sprite_creature,x         '0-7
          ldx sprite_layout_pattern,y
          ldx #05
          clc
loop      ldy sprite_pattern_table_lo,x 'Only lo address required
          sta (pre-screen),y
          adc #01
          dex
          bpl loop

The 32 spare characters are split up thus...
 95     Sprite thrown weapon
 96-101 Sprite 0
102-107 Sprite 1
108-113 Sprite 2
114-119 Sprite 3
120-125 Hero Sprite
126     Dropped Object
127     Hero Thrown Weapon

This means that only one or multiple of the same object may exist on the ground at any
instance during the game.

Their are actually two virtual screens and one real screen in TOL.
The first virtual screen holds the background only. This is scrolled (and populated)
and copied to the second virtual screen (Wiping its previous contents).
The sprites are then directly plotted on this, together with thrown armour, dropped
objects and the main hero (Always residing in centre-view).
the second virtual screen is finally outputted to the real screen.
All three screens are dimensioned differently.
The first virtual screen needs only to hold the viewable background, so is only 39 by
20 characters.
The second virtual screen needs to assist the plotting of sprites until only one character
is displayed. It also requires a leftmost colour column, so this screen is 43 by 24.
The third screen is the real screen so is 40 by 20 characters.



3)
Enemies and allies will be split into groups that reside in areas (or terratories)
dictated by a 16*12 table called the region table.
each byte in the table holds various aspects of the region.
Whilst enemies and allies may be restricted to these regions, a certain amount of
overlapping will be expected at the borders. This overlapping may present interesting
scenarios as Guards meet orcs, or serfs meet archers.

b0 - 2 Residing Sprite Groups
        0 Serf & Guard (Towns)
        1 Serf & Orcs (Moors)
        2 Orc & Archer (Forest)
        3 Ghost & Slime (Underwurlde)
        4 Skeleton & Orc (Dessert)
        5 Black Asp & Black Asp (Monastaries

This same byte will also hold information on the sound effects that will randomly
play during the game.
B3-4   Environment Sounds
          0 Dessert (Dessert Wind)
          1 Forest  (Bird Song)
          2 Underwurlde (Rustle of chains)
          3 Sea (Waves)
Sound Channels are split thus...
Channel A - Hero Walk and Weapon sfx (Also Icon or Menu SFX)
Channel B - Environment Sounds
Channel C - Sprite Creatures Walk and weapon sfx

B5-7   -


4) Sprites on screen
One of the main criticisms of the observed demo was the limited range of sprites on the
viewable screen. Once they moved beyond the screen, they instantly regenerated elsewhere.
The player could not expect to chase after them once they left the screen.
So it was decided to extend their playing area to around 60 characters.

check_sprite_within_bounds
          ldx sprite_index
          '// Test far west bounds
          lda hero_xl
          sec
          sbc #30
          tay
          lda hero_xh
          sbc #00
          cmp sprite_xh,x
          beq check_xw_lowBounds
          bcs out_of_Bounds
          jmp within_xw_bounds
check_xw_lowBounds
          tya
          cmp sprite_xl,x
          bcs out_of_bounds
within_xw_bounds
          '// Test far east bounds
          lda hero_xl
          clc
          adc #30
          tay
          lda hero_xh
          adc #00
          cmp sprite_xh,x
          beq check_xe_lowBounds
          bcc out_of_Bounds
          jmp within_xe_bounds
check_xe_lowBounds
          tya
          cmp sprite_xl,x
          bcc out_of_bounds
within_xe_bounds
          '// Test far north bounds
          lda hero_yl
          sec
          sbc #15
          tay
          lda hero_yh
          sbc #00
          cmp sprite_yh,x
          beq check_yn_lowBounds
          bcs out_of_Bounds
          jmp within_yn_bounds
check_yn_lowBounds
          tya
          cmp sprite_yl,x
          bcs out_of_bounds
within_yn_bounds
          '// Test far south bounds
          lda hero_yl
          clc
          adc #15
          tay
          lda hero_yh
          adc #00
          cmp sprite_yh,x
          beq check_ys_lowBounds
          bcc out_of_Bounds
          jmp within_ys_bounds
check_ys_lowBounds
          tya
          cmp sprite_yl,x
          bcc out_of_bounds
within_ys_bounds


5) Sprite behaviour
Behaviour depends on the enemy.
Archers do not like one on one contact (fisticuffs), preferring to keep a good distance
to shoot their arrows.
Orcs prefer one on one, but will retreat at every hit, and attempt to attack from a
different angle.
White Monks prefer a similar tactic as archers, they use orbs to attack the hero. But will
assume one on one if provoked.
Serfs (If one is killed) will attack once then run away, but like orcs they will attack
again if cornered.
Ghosts will always attack regardless of retaliation. They put up a higher level of
resistance so are inherently more difficult to kill.
Guards will attack one on one, their weapons being appropriately more powerful than
other enemies. However like Serfs they will not attack unless provoked.
Slime only knows one on one and will attack at all costs, in fact only holy water can
destroy (dissolve) them.

          ldx sprite_index
          ldy sprite_creature,x
          lda sprite_action_vector_lo,y
          sta smove+1
          lda sprite_action_vector_hi,y
          sta smove+2
smove     jsr $DEAD

Serfs and Guards that are not provoked will always travel in a straight line until they
reach an obstacle, when this occurs, they will turn clockwise or counterClockwise (Random)
and continue in the new direction (Like in Magnetix).

smc_serf  lda sprite_foe_flag,x
          bne attack
          lda sprite_direction,x
          jsr move_in_Direction_of_A

for tables, i would usually pair up bits to keep a tight format on just a few tables.
However, since only 4 sprites can exist, this rule has been wavered, and each attribute has
its own table


sprite_direction
B0-1 Direction
          0 North
          1 East
          2 South
          3 West

B7   Foe Flag


Once B7 has been set and the Friend turns to Foe, the Sprite_tactic table will come into
play.

sprite_tactic
B0-1      Attack Posture
          0 Attack toward Hero
          1 Retreat
          2 Run Away


Many sprites will hold items on their person, be it trinkets or valuable objects.
Status usually decrees a particular sprite holding an item or not. However Orcs tend
to hold money more than artefacts, whilst Archers are more likely to posess weapon Artefacts.

Sprite_posession
B0-5      Items Posessed
          0 Money
          1 Food
          2 Potion
          3 Knife
          4 Shield
          5 Invisibility Cloak
          6 Magical Shoes

Their may be the possibility of allowing foes or friends to pick up weapons they pass over.

Whilst bushes, rivers and trees may lessen the neccesity for collision accuracy, Buildings
and colour attribute changes need to be precisely observed. Therefore whilst slowing down
the engine, character level collision detection (From the map itself) must exist.

The actual collision detection process is somewhat more complicated by the uneven character
patterns for each frame of each sprite.
This is another reason for placing the pattern (Akin to Tetris shapes) into groups, so
that an easy cross-reference table can be determined for every combination.

for example, take a Serf frame north 0 (Two North heading frames), this may appear as...

123
45
 6

their are obviously three checks to perform (Above characters 1,2 and 3)
But what about...

12
345
 6

The checks would then change to above 1,2 and 5

Note that a common origin is always assumed as one beyond topmost and one beyond leftmost.

move_north
          ldx sprite_index
          '// Whilst sprite_creature determines the pattern, it is not a sequence like 0,1,2
          '// but in steps of 6, this enables both easy pattern table indexing and
          '// provides an easy way here to scan through the offsets
          lda #03
          sta temp_counter
          ldy sprite_creature,x

loop      lda sprite_xl,x
          clc
          adc sprite_collision_north_offset_x,y
          sta test_xl
          lda sprite_xh,x
          adc #00
          sta test_xh
          lda sprite_yl,x
          adc sprite_collision_north_offset_y,y
          sta test_yl
          lda sprite_yh,x
          adc #00
          sta test_yh
          jsr check_bg_collision_coordinates
          bcs Collision_Detected

          iny
          dec temp_counter
          bne loop
          '// No collision




Both Friends and Enemies may move at a different pace to the main hero. This depends on
whether they are fighting, or if a serf has found himself outside of his region or running
from an attack.
Usually, the hero will move faster than the sprites around him. However, if an important
event is about to take place, their movement may accelerate beyond the heroes.

sprite_driver
          ldx #03
loop      lda sprite_speed_256,x
          adc sprite_speed_frac,x
          sta sprite_speed_256,x
          bcc next_sprite
          lda sprite_active,x

          beq sprite_inactive
          lda sprite_foe_flag,x
          bne handle_foe
handle_friend
          jsr friend_control  'Refer to **Friend_control
          jmp next_sprite
handle_foe
          jsr foe_control     'Refer to **Foe_Control
next_sprite
          dex
          bpl loop
          '// Finished
          rts

Word travels quickly, as soon as the hero attacks a guard, all
guards will be on the lookout for the hero.
This same rule applies to Serfs/Peasants.



The final conversion of Bitmap, Mask, background and Character set will take this form

          lda Background
          and Mask
          ora Bitmap
          sta CharacterSet

However to get to this stage, we will need to capture the Sprite background, direct mask,
bitmap and pattern configuration to the correct sprite frame and choose the correct
Sprite characters.

Sprite Characters
This is a fairly easy bit.

          lda sprite_index
          '// Multiply sprite index (0-3) by 6 and add 96 to get first character
          asl
          sta temp
          asl
          adc temp
          pha
          adc #96
          sta sprite_character0
          '// now convert to character's address by multiplying by 8
          pla
          asl
          asl
          asl
          sta sprite_character_address+1

Sprite Background
Capturing the background is actually quite easy.
Previous versions of TOL engine relied on picking up the background from the map, but
this proved slow and laborius. Instead we should pick up from the pre-screen buffer
once the background has been copied onto it.

Collision detection processes should (must) prevent us picking up attributes or inverse
characters.
the pattern configuration for the sprite frame is always indexed by the logical
character sequence so this makes it easier to determine which characters to capture
as background.

.
 012
 34
  5

          ldx #05
loop
patofs    ldy $DEAD,x
          lda (calculated_sprite_prescreen_loc),y
          '// with A(32-95) now holding the background character,
          '// calculate the character address
          sec
          sbc #32
          '// A is now from 0 to 63
          asl
          asl
          asl
          sta sprite_background_charloc+1
          lda #$b5
          adc #00
          sta sprite_background_charloc+2

After working out the sprite background for a character, we must then copy this bitmap
to a buffer (for easy access when we update the sprite).
          ldy #07
loop2     lda (sprite_background_charloc),y
          sta (sprite_background_buffer),y
          dey
          bpl loop2
          lda sprite_background_buffer+1
          adc #8
          sta sprite_background_buffer+1
          lda sprite_background_buffer+2
          adc #00
          sta sprite_background_buffer+2

          dex
          bpl loop

Note that PATOFS is the offset from the origin (in the above pattern configuration)
to each consecutive character position.
Because the physical virtual pre-screen is 43 bytes wide, so too must be each line
offset.
PATOFS and the pattern_configuration_table is used both for fetching the correct background
bitmaps and for plotting the finished 6 character Sprite.

Sprite Mask, Bitmap and Pattern configuration
These are based on the sprite_index(0-3), its current frame (0/1 in Sprite_frame), its
current direction (0-3 in Sprite_direction) and the Creature the sprite is representing
(in sprite_creature).
In TOL, these are the visibly distinct creatures (VDC)...
The Sprite Mask is held within the Sprite bitmap definition (As explained previously).

0 Serf
1 Prior
2 Guard
3 Archer
4 Skeletal
5 Orc
6 (Slime has been cancelled)
7 Ghost

Note: If a creature is found alone, they are usually a friend, otherwise if
they are with others, they may be a foe.

We use the Sprite_definition table to hold this information together with other information
about the creature.

Sprite_Creature
B0-2 Creature shape (VDC)

The sequence of sprite definitions is very important too...
Orc Bitmap North-Facing Frame 0 (48 Bytes)
Orc Bitmap East-Facing Frame 0
Orc Bitmap South-Facing Frame 0
Orc Bitmap West-Facing Frame 0
Orc Bitmap North-Facing Frame 1 (48 Bytes)
Orc Bitmap East-Facing Frame 1
Orc Bitmap South-Facing Frame 1
Orc Bitmap West-Facing Frame 1

The sprite frame is either 0 or 192
Whilst the direction frame is stored from 0-3, it will be converted to 0,48,96,144
This makes the grand total for each Creatures graphics 384 bytes (Excluding tables).
With 8 Creatures to contend with, that's 3072 Bytes.
          '// Calculate Bitmap
          ldx sprite_index
          lda sprite_bitmap_base_lo,y
          clc
          adc sprite_frame,x
          sta sBitmap+1
          lda sprite_bitmap_base_hi,y
          adc #00
          sta sBitmap+2
          '
          ldy sprite_direction,x
          lda sBitmap+1
          adc sprite_direction_step,y
          sta sBitmap+1
          bcc skip1
          inc sBitmap+2
skip1     '// Calculate pattern_configuration_table
          '// pct = table((frame*8)+shape)
          lda sprite_shape,x
          asl
          asl
          asl
          ldy sprite_frame,x  '0 or 96
          beq skip2
          ora #4
skip2     ora sprite_direction,x
          tay
          '// Y will be 8 shapes * 2 frames * 4 directions (0-63)
          lda pattern_configuration_table_vector_lo,y
          sta patofs+1
          sta patplt+1
          lda pattern_configuration_table_vector_hi,y
          sta patofs+2
          sta patplt+2

The pattern_configuration_table_vector_lo may point to a new or an existing
pattern configuration table and will be ordered such...

Serf frame 0 North
Serf frame 0 East
Serf frame 0 South
Serf frame 0 West
Serf frame 1 North
Serf frame 1 East
Serf frame 1 South
Serf frame 1 West
Prior frame 0 North
Prior frame 0 East
Prior frame 0 South
Prior frame 0 West
Prior frame 1 North
Prior frame 1 East
Prior frame 1 South
Prior frame 1 West
Etc.


The Mixing of a single sprite may then occur

          ldy #47
loop      lda (sBitmap),y
          '// Extract Mask
          asl
          rol
          rol
          and #03
          tax
          lda mask_pair,x
          and (sprite_background_buffer),y
          ora (sBitmap),y
sprite_character_address
          sta $B700,y
          dey
          bpl loop

To optimise the Mask decoding required , one may use a 256 byte table instead...
          ldy #47
loop      lda (sBitmap),y
          tax
          lda mask256,x
          and (sprite_background_buffer),y
          ora (sBitmap),y
sprite_character_address
          sta $B700,y
          dey
          bpl loop
However, it would save 384 Clock Cycles and a maximum of 1536 cycles over 4 sprites.
As always, memory or speed?

The mask_pair table is a simple widening of the top two bits over the bottom 6 and looks
like this...

mask_pair
index     Value(Top)       Data Value(Binary)
0         00                  000000
1         01                  000111
2         10                  111000
3         11                  111111

Finally, the sprite needs to be displayed. It is set against the pattern_configuration to
decide where to plot characters.

          lda sprite_character0
          ldx #05
loop
patplt    ldy $DEAD,x         'Correct Pattern configuration table
          sta (calculated_sprite_prescreen_loc),y
          adc #01
          dex
          bpl loop
          rts

Sprite movement
The sprite movement routine needs to perform the following tests before even attempting to
move the sprite.
1) Is the sprite active?
2) Is the sprite a friend or a foe
3) Does the sprite occupy the screen?

          ldx #03
loop      lda sprite_active,x
          bpl inactive_sprite

          lda sprite_foe_flag,x
          beq friendly_sprite
          jsr sprite_foe
          jmp next_sprite
friendly_sprite
          jsr sprite_friend
next_sprite
          dex
          bpl loop
          rts

if it is not, then we may want to introduce it to this region.


Introducing sprites is another difficult bit of programming.
we must first locate a block where the sprite may start.
Note:We search by block because it is faster than searching 6 characters.
This must exist outside of the players view initially, but the sprite may then
traverse into his space (Background permitting).
To cut down on processing time, the routine will always randomly select a location around
the perimeter of the screen, and outside the normal view.

Also, the search is further refined by observing the current direction
of the hero.
For example, if the hero is heading north, then we ought not place the
sprite on the south most point.
So we may approximate 32 positions where a creature may appear from.

S   S   S   S   S   S   S   S   S   S   S   S

    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
S   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA S
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
S   AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA S
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAOHHAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAHHHAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAHHHAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

The distance between positions has been selected to avoid searching duplicate blocks.
Blocks in TOL are always 4*4 character.
The distance from the screen to the search instance (Called the Slot) has also been
adjusted to compensate for the block. If the slot was any closer, a sprite may suddenly
appear on screen, which is something we'll want to avoid.

From here-on in, we'll be using block co-ordinates. We'll fetch the heroes X/Y co-ordinate
and convert it to a block co-ordinate.
The heroes position using two 12 bit co-ordinates.
The X-coordinate is from 0 to 4095 whilst the Y is from 0 to 3071.
The actual structure of both co-ordinates can be shown as bits in each 12 bit entity...

BBMMMSSS SSSS

S is a 7 bit (0-127) entity for the position in the Big-Map
M is a 3 bit (0-7) entity for the position in a Map
B is a 2 bit (0-3) entity for the position in a Block.

So to capture just the block position, we'll need to divide by 4(LSR twice)
          '// Convert hero x/y to block x/y
          lda hero_xl
          sta blockXl
          lda hero_xh
          sta blockXh

          lsr blockXh
          ror blockXl
          lsr blockXh
          ror blockXl
Now determine the correct table for the heroes current direction
          lda hero_direction
          asl
          asl
          asl
          asl
          sta temp
Now select a random position from 0 to 15
          lda random_seed
          and #15
          sta slot_index
And combine with the direction (Which will give us the correct index
          ora temp
          tax
We'll then need to search through the 16 long table which contains a
single byte that is all that is needed to specify the signed offset.
B0-2 X Offset
B3   X Sign
B4-6 Y Offset
B7   Y Sign
Note that the complete set of tables use 64 Bytes (Slots*Directions).
          lda slot_offset,x
          and #15
          cmp #8  '// Place b7 into carry flag
          and #7
          sta block_offset
          bcs skip2
          lda blockXl
          adc block_offset
          sta blockXl
          bcc skip1
          inc blockXh
skip1     jmp skip3
skip2     lda blockXl
          sbc block_offset
          sta blockXl
          bcs skip3
          dec blockXh
skip3
          lda slot_offset,x
          lsr
          lsr
          lsr
          lsr
          cmp #8
          and #7
          sta block_offset
          bcs skip12
          lda blockYl
          adc block_offset
          sta blockYl
          bcc skip11
          inc blockYh
skip11    jmp skip13
skip12    lda blockYl
          sbc block_offset
          sta blockYl
          bcs skip13
          dec blockYh
skip13
We'll now need to fetch the block at this position.
Note that the map is designed in such a way as to never allow the screen to reach
any map boundaries, so preventing errors like searching block co-ordinates outside.
We will use a generic subroutine that can fetch the block, refer to map_code.s for
specific code.
          jsr fetch_block
Referring to the map analysis done in Mapbg.txt, we can check if the block is terra-
firma (Ground) or not.
          ldx #31
loop      cmp background_block_list,x
          beq terra_firma
          dex
          bpl loop
          '// Not ground
          rts
Now convert block co-ordinates back to map co-ordinates but multiplying by 4 (two ASL)
terra_firma
          asl blockXl
          rol blockXh
          asl blockYl
          rol blockYh

We now have a suitable x/y coordinate for a sprite creature.
However, We don't yet know the following...

1) Which direction the sprite should be facing
2) What the sprite creature should be
3) Whether the creature should be friend or Foe

We will break;these down as follows
>>1) Which direction the sprite should be facing
The direction the sprite should be facing is fairly easy.
The sprite should always face at least 90 degrees towards the hero.
We know which side the sprite will start by looking at slot_index.
We will use the terms Bow(Front), Port(Left), Stern(Back) and Starboard(Right)
since it all depends on point of view of the hero direction.
slot_index
0-2       Port(0)
3-12      Bow(1)
13-15     Starboard(2)

we will form a 12 byte table which will be based on the current hero direction (4)
and the slot heading (3).

          '// Convert slot_index (0-15) to slot heading (0-2)
          ldy #02
          lda slot_index
          cmp #13
          bcs skip
          dey
          cmp #3
          bcs skip
          dey
skip      tya
          '// Merge with Hero Direction
          asl
          asl
          ora hero_direction
          tax
          lda initial_sprite_direction,x

this is based on the hero direction.
hero_direction
0 Facing North
1 Facing East
2 Facing South
3 Facing West
and the slot heading, so the complete table looks like this...
initial_sprite_direction
Entry 00 is [Hero North, slot port] so sprite should move east
1
Entry 01 is [Hero East, slot port] so sprite should move south
2
Entry 02 is [Hero South, slot port] so sprite should move west
3
Entry 03 is [Hero West, slot port] so sprite should move north
0
Entry 04 is [Hero North, slot bow] so sprite should move south
2
etc.

          ldx sprite_index
          sta sprite_direction,x
          '// Store the sprites new position
          lda blockXl
          sta sprite_xl,x
          lda blockXh
          sta sprite_xh,x
          lda blockYl
          sta sprite_Yl,x
          lda blockYh
          sta sprite_Yh,x

>>2) What the sprite creature should be
The sprite creature is decided by the regional map and/or a story specific rule.
A story specific Sprite is one that occurs either at a specific place, region or
time during the game. The creature may be required as a liason to a quest or
someone to guide the player to the next stage in the plot development.
We will not deal with it here, since that area of the game has not yet been set.

          lda Story_sprite_required_flag
          bne process_store_sprite

The region can be found by extracting the top 4 bits of both x and y positions
ie. region_index = x+(y*16)
The region is 0 to 15 in the x-coordinate but only 0 to 11 in the y.
This reduces the size of the region map to 192 bytes.
A region grid overlays the map in the image sourcesafe/games/tol/images/regions.bmp

          lda blockXh
          asl
          asl
          asl
          asl
          ora blockYh
          tay
          lda region,x
          and #7

Since each region shares its space with two different creatures, the random seed is
used again to decide which one we shall use.
b0 - 2 Residing Sprite Groups
        0 Serf & Guard (Towns)
        1 Serf & Orcs (Moors)
        2 Orc & Archer (Forest)
        3 Ghost & Slime (Underwurlde)
        4 Skeleton & Orc (Dessert)
        5 Black Asp & Black Asp (Monastaries

Each of the individual types are known as Creatures.
So Serf, Orc, Guard, Slime, etc. are all creatures.

          ldy random_seed
          cpy #128
          rol
          tay
          lda common_creature,y
          sta sprite_creature,x

The list of common creatures is...
Idx Type  Data
0  Serf     0
1  Guard    1
2  Serf     0
3  Orc      2
4  Orc      2
5  Archer   3
6  Ghost    4
7  Slime    5
8  Skeleton 6
9  B-Asp    7
10 B-Asp    7

And the list of sprite creatures is...
0  Serf
1  Guard
2  Orc
3  Archer
4  Ghost
5  Slime
6  Skeleton
7  Black Asp
Each having its own Graphic animation.

>>3) Whether the creature should be friend or Foe
We can determine whether the creature is friendly or not by simply examining
the sprite_creature. Creatures under 2 are always friendly.
          ldy #00
          cmp #03
          bcc skip
          iny
If it is a foe, then we might aswell set up sprite_tactic here too.
          lda #0
          sta sprite_tactic,x
skip      tya
          sta sprite_foe_flag,x

To finish setting up the new sprite, we'll need to set the folowing tables
sprites_first_char
Sprite_posession
sprite_speed_256
sprite_speed_frac
sprite_frame
sprite_active

sprites_first_char is based on 96+(sprite_index*6)
          lda sprite_index
          asl
          sta temp
          asl
          adc temp
          adc #96
          sta sprites_first_char,x
Sprite_posession will depend on a high random factor, so a comparison is required.
          ldy #00
          lda random_seed
          cmp #220
          bcc skip
          and #07
          tay
skip      tya
          sta Sprite_posession,x
We will need to reset both sprite_speed_256 and sprite_speed_frac.
          lda #00
          sta sprite_speed_256,x
          lda #128                      '// Make half speed of Hero
          sta sprite_speed_frac,x
sprite_frame simply starts as 0.
          lda #00
          sta sprite_frame,x
Whilst sprite_active starts as 1.
          lda #01
          sta sprite_active,x
And that's it for initialising a new sprite!
          rts




**Friend_control
When controlling the friend, as previously detailed, the sprite needs to follow this
pseudo-code

if sprite + direction = collision
          direction = random seed
else
          move in direction
end if

Note: Sprite collision is handled at block level, not character level

friend_control
          ldx sprite_index
          '// Fetch Sprites Map X/Y
          ldy sprite_direction,x
          lda sprite_Xl,x
          sta blockXl
          lda sprite_Xh,x
          sta blockXh
          lda sprite_Yl,x
          sta blockYl
          lda sprite_Yh,x
          sta blockYh
          '// Convert Map X/Y to Block X/Y
          lsr blockXh
          ror blockXl
          lsr blockXh
          ror blockXl
          lsr blockYh
          ror blockYl
          lsr blockYh
          ror blockYl
          '// Look at adjacent block in respect to direction
          ldy sprite_direction,x
          bne check_esw
look_block_north
          lda BlockYl
          bne skip1
          dec blockYh
skip1     dec blockYl
          jmp skip0
check_esw dey
          bne check_sw
look_block_east
          inc blockXl
          bne skip2
          inc blockXh
skip2     jmp skip0
check_sw  dey
          bne look_block_west
look_block_south
          inc blockYl
          bne skip3
          inc blockYh
skip3     jmp skip0
look_block_west
          lda blockXl
          bne skip4
          dec blockXh
skip4     dec blockXl

skip0     '// fetch block value
          jsr fetch_block
          '// Check if BG
          jsr is_bg
          ldx sprite_index
          bcs move_sprite

This part of the code must turn the sprite in a new direction. I had thought that
the sprite would either rotate clockwise or anticlockwise, but that is too predictable.
So instead, the direction is completely set by the random seed. The sprite could
potentially remain standing, double back or turn which is fine.
Once the sprites new direction has been chosen, then we will wait for the next game cycle
to move it.

turn_creature
          lda random_seed
          and #03
          sta sprite_direction,x
          jmp plot_sprite

When the adjacent background (Also known as BG or bg) is terra-firma (Ground), then we
can reliably move the sprite in that direction. Although we have the co-ordinates for
the position to the right, the units are in blocks so we'll need to repeat the move in
map coordinates.

move_sprite
          '// Inverse Sprite Frame
          lda sprite_frame,x
          eor #01
          sta sprite_frame,x
          '// Now move it
          ldy sprite_direction,x
          bne check_esw
          '// Move North
          lda sprite_yl,x
          bne skip1
          dec sprite_yh,x
skip1     dec sprite_yl,x
          jmp plot_sprite
check_esw
          dey
          bne check_sw
          '// Move East
          inc sprite_xl,x
          bne skip2
          inc sprite_xh,x
skip2     jmp plot_sprite
check_sw
          dey
          bne move_w
          '// Move South
          inc sprite_yl,x
          bne skip3
          inc sprite_yh,x
skip3     jmp plot_sprite
move_w    '// Move West
          lda sprite_xl,x
          bne skip4
          dec sprite_xh,x
skip4     dec sprite_xl,x
          jmp plot_sprite

**Foe_Control
This part is a little more complex, since we must observe character precision rather than
block presision, to ensure collision is top-notch.

for each direction, a set of search patterns must exist.
Since their exists patterns for each group when combined with direction, we can
create a set of search patterns for each of these instead.

The origin for all sprites is always set at 1 position up-left of the actual sprite.
This means that all checks can be made by relative addition only.
The example below shows an orc travelling north, o marks its origin (the x/y position
held for that sprite).

oCCC
 012
 34
  5

C marks each instance of a check north.
So for every sprite, only ever 3 checks take place in order to establish that direction
to be successful or not.
All x and y positions use 12 bit addressing, therefore the offsets will need to do the
same.


          ldx sprite_index
          ldy #02   '// Number of checks
loop      lda sprite_xl,x
          adc (search_pattern_xoffset),y
          sta test_coord_xl
          lda sprite_xh,x
          adc #00
          sta test_coord_xh
          lda sprite_yl,x
          adc (search_pattern_yoffset),y
          sta test_coord_yl
          lda sprite_yh,x
          adc #00
          sta test_coord_yh
          jsr check_collision_at_test_coord
          bcs sprite_collision    '// Could be sprite/sprite, sprite/bg or sprite/hero
          dey
          bpl loop


foe_control

The plot sprite code is actually detailed above, however, before plotting the sprite,
we must check if it falls within the pre-screen boundaries.
to do so, we'll need to calculate the boundary extremes.


check_collision_at_test_coord
This is possibly the most complex part of the project.
For any instance of the supplied test_coord x or y, the routine must check for
background collision, sprite collision or hero collision.
If any collision takes place, the carry flag is set.
To distinguish between collisions, the Accumulator will return 1,2 or 3 respectively.
The routine must also preserve the x and y register.

It is assumed that if a sprite makes contact with another sprite or the hero, this will
indicate that an attack took place.
