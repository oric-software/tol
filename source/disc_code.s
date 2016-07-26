//Disc Code (TIMESLORE.COM)

// Files         Description    Area            Size    Notes		Saveo/Loaded
// DAT001.MEM    Game Snapshot  $0600-$BFFF     $BB00   80% Complete            SL
// DAT002.MEM    Preferences    $02F0-$02FF     $10     90%			SL
// DAT003.MEM    Title          $0600-$BFFF     $BB00   90% Complete            L
// DAT004.MEM    Options        $0600-$BFFF     $BB00   Not Written yet         L
// DAT005.MEM    Storybook      $0600-$BFFF     $BB00   75% Complete            L
// DAT006.MEM    Game Complete  $0600-$BFFF     $BB00   Not Written Yet         L
// DAT007.MEM    Original Game  $0600-$BFFF     $BB00   (See Game Snapshot)     L
//
// I will always put the actual code vector jump into $bffd
// I will also put conditions in $02EF
// All Saves overwrite the existing file.
//
// Game Boot
;Game Boot file DAT000.MEM autoloads from Sedoric into $0500 - $05FF
// LOOP
//   LOAD DAT001.MEM     ;Load Preferences which will immediately adjust the volume before the Title
//     LOAD DAT002.MEM     ;Title
//   CALL $BFFD
//   IF PEEK($02EF)=1    'Options
//     LOAD DAT003.MEM    ;Options
//     CALL $BFFD
//     SAVE DAT001.MEM    ;Save Preferences
//     JMP LOOP
//   IF PEEK($02EF)=2    'Return to Times of Lore
//     LOAD DAT005.MEM    ;Load current game
//     CALL $BFFD
//     JMP SKIP
//   ELSE                'Start new Game
//     LOAD DAT007.MEM    ;Restore original Game
//     SAVE DAT005.MEM
//     LOAD DAT004.MEM    ;StoryBook
//     CALL $BFFD
//     SAVE DAT001.MEM    ;Save Choice of Hero
// LOOP2
//     LOAD DAT005.MEM    ;Game
//     CALL $BFFD
//     JMP SKIP
//   END IF
//
// SKIP
//   IF PEEK($02EF)=0    ;Game Over
//     LOAD DAT007.MEM    ;Restore original Game
//     SAVE DAT005.MEM
//     JMP LOOP
//   IF PEEK($02EF)=1    ;Game Save
//     SAVE DAT005.MEM
//     CALL CONTGAME_VECTOR
//     JUMP SKIP
//   ELSE
//     LOAD DAT006.MEM   ;Game Complete
//     CALL $BFFD
//     JMP LOOP
//   END IF

// DAT001.MEM    Game Snapshot  $0600-$BFFF     $BB00   80% Complete            SL
// DAT002.MEM    Preferences    $02F0-$02FF     $10     90%			SL
// DAT003.MEM    Title          $0600-$BFFF     $BB00   90% Complete            L
// DAT004.MEM    Options        $0600-$BFFF     $BB00   Not Written yet         L
// DAT005.MEM    Storybook      $0600-$BFFF     $BB00   75% Complete            L
// DAT006.MEM    Game Complete  $0600-$BFFF     $BB00   Not Written Yet         L
// DAT007.MEM    Original Game  $0600-$BFFF     $BB00   (See Game Snapshot)     L

#define	title_vector	$bfff	;Test
#define	options_vector	$bfff     ;Test
#define	storybook_vector    $bfff     ;Test
#define	game_vector         $0600
#define	contgame_vector     $bfff     ;Test
#define	completed_vector    $bfff     ;Test

*=$500	;to $5FF?

disc_handler
.(
loop1
	lda #48+2
	jsr load_dat	//   LOAD DAT002.MEM     ;Load Preferences which will immediately adjust the volume before the Title
	lda #48+3
	jsr load_dat	//   LOAD DAT003.MEM     ;Title
	jsr title_vector	//   CALL $BFFD
	lda $00		//   IF PEEK($00)=0    'Options
	bne skip1
	lda #48+4
	jsr load_dat	//     LOAD DAT004.MEM    ;Options
	jsr options_vector	//     CALL $BFFD
	lda #48+2
	jsr save_dat	//     SAVE DAT002.MEM    ;Save Preferences
	jmp loop1		//     JMP LOOP
skip1	bpl skip2		//   IF PEEK($00)=128    'Return to Times of Lore
skip3	lda #48+1
	jsr load_dat	//     LOAD DAT001.MEM    ;Load current game
	jsr game_vector     //     CALL $BFFD
	jmp skip4		//     JMP SKIP
skip2			//   ELSE                'Start new Game
	jsr restore_game    //     LOAD DAT007.MEM    ;Restore original Game
	lda #48+5		//     SAVE DAT001.MEM
	jsr load_dat	//     LOAD DAT005.MEM    ;StoryBook
	jsr storybook_vector//     CALL $BFFD
	lda #48+2
	jsr save_dat	//     SAVE DAT002.MEM    ;Save Choice of Hero
loop2			// LOOP2
	jmp skip3		//     LOAD DAT001.MEM    ;Game
			//     CALL $BFFD
skip4			// SKIP
	lda $00		//   IF PEEK($00)=0    ;Game Over
	bne skip5
	jsr restore_game	//     LOAD DAT007.MEM    ;Restore original Game
			//     SAVE DAT001.MEM
	jmp loop1		//     JMP LOOP
skip5	bpl skip6		//   IF PEEK($02EF)=128    ;Game Save
	lda #48+2
	jsr save_dat	//     SAVE DAT002.MEM
	jsr contgame_vector	//     CALL CONTGAME_VECTOR
	jmp skip4		//     JUMP SKIP
skip6	lda #48+6		//   ELSE
	jsr load_dat	//     LOAD DAT006.MEM   ;Game Complete
	jsr completed_vector//     CALL $BFFD
	jmp loop1		//     JMP LOOP
.)

restore_game
	lda #48+7
	jsr load_dat
	lda #48+1
	jmp save_dat

;In...
;A	Dat00x to load (48-55)
load_dat	sei
	jsr setup_fpointer
	jsr $04f2
	lda #$00
	jsr $dff9
	jsr $04f2
	cli
	rts

;In...
;A	Dat00x to load (48-55)
save_dat	sei
	jsr setup_fpointer
	jsr $04f2
	lda #$00
	jsr $d454
	lda file_number	;1 or 2
	lda file_start_lo-49,x
	sta $c052
	lda file_start_hi-49,x
	sta $c053
	lda file_end_lo-49,x
	sta $c054
	lda file_end_hi-49,x
	sta $c055
	lda #$00
	sta $c04d
	sta $c04e
	lda #$40
	jsr $de0b
	jsr $04f2
	cli
	rts

setup_fpointer
	sta file_number
	lda #<filename_text
	sta $e9
	lda #>filename_text
	sta $ea
	rts

filename_text
 .byt "DAT00"
file_number
 .byt "3"
 .byt ".MEM"
file_start_lo
 .byt <$600
 .byt <$b800
file_start_hi
 .byt >$600
 .byt >$b800
file_end_lo
 .byt <$bfff
 .byt <$BB1F
file_end_hi
 .byt >$bfff
 .byt >$BB1F
end_of_disc_code
