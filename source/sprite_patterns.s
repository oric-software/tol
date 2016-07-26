// Sprite patterns
// These set the configuration of each 6 allocated characters into the sprite frame
// for Hero and creatures. Patterns also exist for the searching of adjacent moves.

// The complete set of pattern tables (sprite and search) consume 529 Bytes

// The first set of tables are indexed by frame.
// They assign a pattern number to each frame (77 Frames).
knight_pattern_number	;(0-15)
 .byt 0,0,0,54,54,54,114,114,114,54,54,54,0,54,6,54
; .byt 0,0,0,9,9,9,19,19,19,9,9,9,0,9,1,9
barbarian_pattern_number     	;(0-15)
 .byt 12,114,114,54,54,30,114,114,18,54,54,54,12,30,114,36
; .byt 2,19,19,9,9,5,19,19,3,9,9,9,2,5,19,6
valkyrie_pattern_number      	;(0-15)
 .byt 30,54,6,54,54,30,60,60,60,48,0,78,42,72,54,36
; .byt 5,9,1,9,9,5,10,10,10,8,0,13,7,12,9,6
pattern_number		;Chosen Hero above copied here (Default is barbarian)
 .byt 12,114,114,54,54,30,114,114,18,54,54,54,12,30,114,36
; .byt 2,19,19,9,9,5,19,19,3,9,9,9,2,5,19,6
ghost_pattern_number	;(16-23)
 .byt 66,66,54,54,66,66,54,54
; .byt 11,11,9,9,11,11,9,9
guard_pattern_number	;(24-32)
 .byt 6,18,102,90,114,114,84,96,114
; .byt 1,3,17,15,19,19,14,16,19
orc_pattern_number		;(33-40)
 .byt 114,114,24,108,114,24,54,30
; .byt 19,19,4,18,19,4,9,5
asp_pattern_number		;(41-48)
 .byt 54,54,54,54,54,54,54,18
; .byt 9,9,9,9,9,9,9,3
rogue_pattern_number	;(49-56)
 .byt 114,114,114,114,114,114,114,114
; .byt 19,19,19,19,19,19,19,19
serf_pattern_number		;(57-64)
 .byt 12,18,54,54,12,30,54,54
; .byt 2,3,9,9,2,5,9,9
skeleton_pattern_number	;(65-72)
 .byt 54,54,54,54,30,54,54,54
; .byt 9,9,9,9,5,9,9,9
death_pattern_number	;(73-76)
 .byt 114,114,114,114
; .byt 19,19,19,19

// These are the patterns for each pattern number.
// Each pattern is 6 bytes long and their are a total of 20 Patterns.
// The tables are split into x and y offset patterns and their address is
// calculated (*6) rather than a vector reference table.

sprite_patternx0
 .byt 1,2,3,2,3,2
sprite_patternx1
 .byt 1,2,3,1,2,2
sprite_patternx2
 .byt 2,3,1,2,3,2
sprite_patternx3
 .byt 1,2,1,2,3,2
sprite_patternx4
 .byt 2,3,1,2,3,3
sprite_patternx5
 .byt 1,2,1,2,3,1
sprite_patternx6
 .byt 1,2,3,2,3,3
sprite_patternx7
 .byt 1,2,3,1,2,1
sprite_patternx8
 .byt 1,2,1,2,2,3
sprite_patternx9
 .byt 1,2,1,2,1,2
sprite_patternx10
 .byt 2,1,2,3,1,3
sprite_patternx11
 .byt 1,3,1,2,3,2
sprite_patternx12
 .byt 1,3,1,2,1,2
sprite_patternx13
 .byt 1,2,3,2,2,3
sprite_patternx14
 .byt 1,2,2,3,2,3
sprite_patternx15
 .byt 2,3,1,2,1,2
sprite_patternx16
 .byt 2,3,2,3,1,3
sprite_patternx17
 .byt 1,2,1,2,1,3
sprite_patternx18
 .byt 2,3,2,3,2,3
sprite_patternx19
 .byt 1,2,3,1,2,3
sprite_patterny0
 .byt 1,1,1,2,2,3
sprite_patterny1
 .byt 1,1,1,2,2,3
sprite_patterny2
 .byt 1,1,2,2,2,3
sprite_patterny3
 .byt 1,1,2,2,2,3
sprite_patterny4
 .byt 1,1,2,2,2,3
sprite_patterny5
 .byt 1,1,2,2,2,3
sprite_patterny6
 .byt 1,1,1,2,2,3
sprite_patterny7
 .byt 1,1,1,2,2,3
sprite_patterny8
 .byt 1,1,2,2,3,3
sprite_patterny9
 .byt 1,1,2,2,3,3
sprite_patterny10
 .byt 1,2,2,2,3,3
sprite_patterny11
 .byt 1,1,2,2,2,3
sprite_patterny12
 .byt 1,1,2,2,3,3
sprite_patterny13
 .byt 1,1,1,2,3,3
sprite_patterny14
 .byt 1,1,2,2,3,3
sprite_patterny15
 .byt 1,1,2,2,3,3
sprite_patterny16
 .byt 1,1,2,2,3,3
sprite_patterny17
 .byt 1,1,2,2,3,3
sprite_patterny18
 .byt 1,1,2,2,3,3
sprite_patterny19
 .byt 1,1,1,2,2,2

// Search patterns not used anymore, nice idea but wasteful of mem and accuracy not req'


// Each frame has an associated search pattern, logically the assocated side of the
// direction the frame is intended to move or be facing.
;knight_search_pattern	;(0-15)
; .byt 0,0,0,16,16,16,34,34,34,39,39,39,0,16,22,35
;barbarian_search_pattern	;(0-15)
; .byt 1,0,0,16,16,13,34,34,23,39,39,39,1,13,34,40
;valkyrie_search_pattern	;(0-15)
; .byt 2,4,0,16,16,13,30,30,30,36,35,35,0,10,33,40
;search_pattern_number	;Chosen Hero above copied here
; .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;ghost_search_pattern	;(16-23)
; .byt 6,6,16,16,23,23,39,39
;guard_search_pattern	;(24-32)
; .byt 0,2,15,10,34,34,35,42,0	;Last entry is guard to attention, with search north
;orc_search_pattern		;(33-40)
; .byt 0,0,12,12,34,24,39,39
;asp_search_pattern		;(41-48)
; .byt 8,8,16,16,33,33,43,36
;rogue_search_pattern	;(49-56)
; .byt 0,0,20,20,34,34,44,44
;serf_search_pattern		;(57-64)
; .byt 1,2,16,16,23,25,43,43
;skeleton_search_pattern	;(65-72)
; .byt 8,8,16,16,25,33,43,43
;death_search_pattern	;(73-76)
;No Search patterns required

;To fetch search_patternXX table address...
;	// Fetch search pattern number
;	ldx sprite_frame
;	lda search_pattern_number,x
;	// Multiply by 3...
;	asl
;	adc search_pattern_number,x
;	// Add Base Address...
;	adc #<search_pattern0
;	sta table_address_lo
;	lda #>search_pattern0
;	adc #00
;	sta table_address_hi
;	// Done!

;The search patterns themselves are stored a 3(x)/3(y)/2(-) nibbles (135 Bytes)
;search_pattern0	;North Exits (0-8)
; .byt 1,2,3
;search_pattern1
; .byt 1+1*16,2,3
;search_pattern2
; .byt 1,2,3+1*16
;search_pattern3
; .byt 1,2,3+2*16
;search_pattern4
; .byt 1,2,2
;search_pattern5
; .byt 1+1*16,2,3+1*16
;search_pattern6
; .byt 1,2+1*16,3
;search_pattern7
; .byt 1+2*16,2,3
;search_pattern8
; .byt 2,3,3
;search_pattern9	;East Exits (9-20)
; .byt 4+1*16,4+2*16,3+3*16
;search_pattern10
; .byt 4+1*16,3+2*16,3+3*16
;search_pattern11
; .byt 3+1*16,4+2*16,3+3*16
;search_pattern12
; .byt 4+1*16,4+2*16,4+3*16
;search_pattern13
; .byt 3+1*16,4+2*16,2+3*16
;search_pattern14
; .byt 4+1*16,3+2*16,2+3*16
;search_pattern15
; .byt 3+1*16,3+2*16,4+3*16
;search_pattern16
; .byt 3+1*16,3+2*16,3+3*16
;search_pattern17
; .byt 3+1*16,4+2*16,4+3*16
;search_pattern18
; .byt 4+1*16,4+2*16,3+3*16
;search_pattern19
; .byt 4+1*16,3+2*16,4+3*16
;search_pattern20
; .byt 4+1*16,4+2*16,4+2*16
;search_pattern21	;South Exits (21-34)
; .byt 1+2*16,2+4*16,3+3*16
;search_pattern22
; .byt 1+3*16,2+4*16,3+2*16
;search_pattern23
; .byt 1+3*16,2+4*16,3+3*16
;search_pattern24
; .byt 1+3*16,2+3*16,3+4*16
;search_pattern25
; .byt 1+4*16,2+3*16,3+3*16
;search_pattern26
; .byt 1+2*16,2+3*16,3+4*16
;search_pattern27
; .byt 1+4*16,2+3*16,3+2*16
;search_pattern28
; .byt 1+3*16,2+4*16,3+4*16
;search_pattern29
; .byt 1+4*16,2+4*16,2+4*16
;search_pattern30
; .byt 1+4*16,2+3*16,3+4*16
;search_pattern31
; .byt 1+4*16,2+4*16,3+2*16
;search_pattern32
; .byt 1+2*16,2+4*16,3+4*16
;search_pattern33
; .byt 2+4*16,3+4*16,3+4*16
;search_pattern34
; .byt 1+3*16,2+3*16,3+3*16
;search_pattern35	;West Exits (35-44)
; .byt 0+1*16,1+2*16,1+3*16
;search_pattern36
; .byt 0+1*16,0+2*16,1+3*16
;search_pattern37
; .byt 1+1*16,0+2*16,1+3*16
;search_pattern38
; .byt 1+1*16,0+2*16,2+3*16
;search_pattern39
; .byt 0+1*16,0+2*16,0+3*16
;search_pattern40
; .byt 0+1*16,1+2*16,2+3*16
;search_pattern41
; .byt 1+1*16,0+2*16,0+3*16
;search_pattern42
; .byt 1+1*16,1+2*16,0+3*16
;search_pattern43
; .byt 1+1*16,1+2*16,1+3*16
;search_pattern44
; .byt 0+1*16,0+2*16,0+2*16
