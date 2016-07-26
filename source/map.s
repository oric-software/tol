// Map.s
// Map.s contains subroutines related to the map.
// fetch_map will get the map at the supplied map coordinates (test_xx).
// fetch_block will get the block at the supplied block coordinates (test_xx).
// fetch_character will get the character at the supplied character coordinates.
// character2ascii will return the ascii character for a supplied character
// character2Attribute will return the attribute for a supplied character.
//
// Some internal subroutines also exist.
// extract_TSMap extracts bigmap location from map coordinates
// extract_Map extracts map location from map coordinates
// extract_Block
//
// bbmmmsss ssss

;
fetch_character
	lda #00
          sta map_lo
          sta block_hi
          lda test_xl
          sta extracted_xl
          lda test_xh
          asl extracted_xl
          rol
          asl extracted_xl
          rol
          asl extracted_xl
          rol
          sta extracted_xh
          lda test_yh
          sta extracted_yh
          lda test_yl
          and #%11100000
          asl
          rol extracted_yh
          asl
          rol extracted_yh
          ora extracted_xh
          sta extracted_xh
          lda #<TSMAP_Vector
          adc extracted_xh
.(
          sta Vector1+1
          lda #>TSMAP_Vector
          adc extracted_yh
          sta Vector1+2
Vector1   lda $dead
.)
          sta MapNumber
          lsr
          ror map_lo
          lsr
          ror map_lo
          sta map_hi
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
          adc #<MAP_Vector
.(
          sta Vector1+1
          lda map_hi
          adc #>MAP_Vector
          sta Vector1+2
Vector1   lda $dead
.)
          sta BlockNumber
          asl
          rol block_hi
          asl
          rol block_hi
          asl
          rol block_hi
          asl
          rol block_hi
          sta block_lo
          lda test_xl
          and #%00000011
          sta block_x
          lda test_yl
          and #%00000011
          asl
          asl
          ora block_x
          ora block_lo
          adc #<BLOCK_Vector
          sta CharacterVector+1
          lda block_hi
          adc #>BLOCK_Vector
          sta CharacterVector+2
CharacterVector
	lda $dead
          rts

;x = bbbsssss ss
;y = bbbsssss s
fetch_block
	lda #00
	sta map_lo
	lda test_yh	;sxxxxxxx
	sta extracted_yh
	lda test_yl	;bbbsssss
	lsr extracted_yh
	ror
	lsr
	lsr
	sta tsmap_y

	lsr
	sta extracted_yh
	ror
	and #128
	sta extracted_yl
	lda test_xh
	sta extracted_xh
	lda test_xl
	lsr extracted_xh
	ror
	lsr extracted_xh
	ror
	lsr
	sta tsmap_x
	ora extracted_yl
	adc #<TSMAP_Vector
.(
	sta vector1+1
	lda extracted_yh
	adc #>TSMAP_Vector
	sta vector1+2
vector1	lda $dead	;screen number (0-178)
.)
          lsr
          ror map_lo
          lsr
          ror map_lo
          sta map_hi

          lda test_xl
          and #7
;          lsr
;          lsr
          sta map_x
          lda test_yl
          and #7
          asl
	asl
	asl
          ora map_x

          ora map_lo
          adc #<MAP_Vector
.(
          sta Vector1+1
          lda map_hi
          adc #>MAP_Vector
          sta Vector1+2
Vector1   lda $dead
.)
	rts


calc_tsmapxy
	// X == aabbbccc cccc
	lda hero_xl
	sta temp_01
	lda hero_xh
	asl temp_01
	rol
	asl temp_01
	rol
	asl temp_01
	rol
	sta temp_01
	// Y == aabbbccc ccc
	lda hero_yl
	sta temp_02
	lda hero_yh
	asl temp_02
	rol
	asl temp_02
	rol
	asl temp_02
	rol
	sta temp_02
	rts

//Characters from 224 to 255 are always inversed. Inversed characters must always be
//obstructions, to prevent hero corruption when standing over them.
//Inverse is useful for extra colour around certain objects such as fire pits.
//
//Blocks in TOL are all 4*4. Their are a total of 256 Blocks.
//
//The next tier is known as a Sector. Each Sector holds a definition of which blocks
//reside in it. Under normal curcumstances, this tier would be the last tier and would be
//classed as the Map.
//
//However, With TOL's enormous playing field, and the freedom of being able to travel the
//length and breadth of the land (and islands) without interruption required another
//tier.

