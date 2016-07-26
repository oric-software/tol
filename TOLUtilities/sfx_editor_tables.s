;sfx_editor_tables

cursor_x		.byt 1
cursor_y		.byt 1

source_index	.byt 1
screen_index	.byt 1
next_byte		.byt 1
first_byte	.byt 1
sfx_number	.byt 0

;Each effect max 48 bytes
effect_memory
 .byt $00,0
 .byt $20,2
 .byt $30,3
 .byt $40,4
 .byt $50,5
 .byt $60
 .byt $70
 .byt $80
 .byt $90
 .byt $a0
 .byt $b0,11
 .byt $c0,12
 .byt $d0
 .byt $e0,14
 .byt $f0
 .byt $10
 .dsb 48*64,0

command_text
 .asc "PITAENDTPITBLOOPPITCBNDDNOISSTATVOLAVOLBVOLCPERSBNDUCYCSWAITXTRA"
number_of_bytes
 .byt 2,1,2,2,2,2,1,1,1,1,1,2,2,1,2,1
ylocl
 .byt $80,$A8,$D0,$F8,$20,$48,$70,$98
 .byt $C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18
 .byt $40,$68,$90,$B8
yloch
 .byt $BB,$BB,$BB,$BB,$BC,$BC,$BC,$BC
 .byt $BC,$BC,$BD,$BD,$BD,$BD,$BD,$BD
 .byt $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BF
 .byt $BF,$BF,$BF,$BF
line_source_index
 .dsb 24,0

ascii_code
 .byt 8,9,10,11,27
 .byt "-=NL"
 .byt "123"
key_vector_lo
 .byt <key_l,<key_r,<key_d,<key_u,<key_esc
 .byt <key_minus,<key_plus,<key_next,<key_last
 .byt <key_play0,<key_play1,<key_play2
key_vector_hi
 .byt >key_l,>key_r,>key_d,>key_u,>key_esc
 .byt >key_minus,>key_plus,>key_next,>key_last
 .byt >key_play0,>key_play1,>key_play2

reserved	.byt 0

offset_x
 .byt 0,5,8
end_of_field
 .byt 3,1,1

sfxn_text
 .byt "SFX:"

rem_buffer
 .dsb 48,0
