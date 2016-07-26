;Game Preferences (32 Bytes)

;Keyboard Assignments
; If Joystick enabled, then assignments are set to 0 where joystick is used
up_column         	.byt $f7	;00       Key Up
right_column      	.byt $bf  ;01	Key Right
down_column       	.byt $df  ;02	Key Down
left_column       	.byt $7f  ;03	Key Left
fire_column       	.byt $ef  ;04	Key CTRL
icon_column	.byt $fe  ;05	SpaceBar
replenish_column    .byt $f7  ;06	Key E
use_item_column    	.byt $fe  ;07	Key U

up_row         	.byt 4    ;08
right_row      	.byt 4    ;09
down_row       	.byt 4    ;0A
left_row       	.byt 4    ;0B
fire_row       	.byt 2    ;0C
icon_row		.byt 4    ;0D
replenish_row       .byt 6    ;0E
use_item_row  	.byt 5    ;0F
; $b26e - 0 to 3
;  0 - Keyboard
;  1 - Telestrat Joystick
;  2 - IJK Joystick
;  3 - PASE Joystick
game_controller 	.byt 0	;10
; $b277 - 0-2
;  0F - Knight
;  1F - Barbarian
;  2F - Valkyrie
game_hero		.byt $1f	;11
; $b278 - 0-15
game_volume     	.byt 15	;12
; $b279 - $b27d (Spare)
game_spares	.dsb 13,0	;13-1F


