// ** Main SFX Tables **

;Runtime Tables
;For editor, each effect event will be 64 bytes long
;and 64 Effects (4096 Bytes)
;This may then be crunched when implemented into TOL
#include "tol33csh.s"	;32
#include "tol33csl.s"	;32

sfx_envelope_activity		;12
 .dsb 12,0
sfx_envelope_frac_table		;12
 .dsb 12,0
sfx_envelope_delay_table	;12
 .dsb 12,0
sfx_envelope_direction_table	;12
 .dsb 12,0
sfx_envelope_register_table	;12
 .dsb 12,0
sfx_envelope_step_table		;12
 .dsb 12,0
sfx_envelope_conditional_high	;12
 .dsb 12,0

sfx_event_action_vector_lo	;16
 .byt <sfx_eav_end,<sfx_eav_swm,<sfx_eav_evu,<sfx_eav_evd
 .byt <sfx_eav_ste,<sfx_eav_spr,<sfx_eav_per,<sfx_eav_set
 .byt <sfx_eav_zrg,<sfx_eav_ceu,<sfx_eav_ced,<sfx_eav_lpr
 .byt <sfx_eav_spr,<sfx_eav_rrb,<sfx_eav_16u,<sfx_eav_16d
sfx_event_action_vector_hi	;16
 .byt >sfx_eav_end,>sfx_eav_swm,>sfx_eav_evu,>sfx_eav_evd
 .byt >sfx_eav_ste,>sfx_eav_spr,>sfx_eav_per,>sfx_eav_set
 .byt >sfx_eav_zrg,>sfx_eav_ceu,>sfx_eav_ced,>sfx_eav_lpr
 .byt >sfx_eav_spr,>sfx_eav_rrb,>sfx_eav_16u,>sfx_eav_16d

sfx_ay_registers		;14
 .byt 0,0
 .byt 0,0
 .byt 0,0
 .byt 0
 .byt 64
 .byt 0,0,0
 .byt 0
 .byt 0
 .byt 0
sfx_ay_reference		;14
 .byt 255,255
 .byt 255,255
 .byt 255,255
 .byt 255
 .byt 255
 .byt 255,255,255
 .byt 255
 .byt 255
 .byt 255
sfx_ay_filter			;14
 .byt 255,15
 .byt 255,15
 .byt 255,15
 .byt 31
 .byt 255
 .byt 31,31,31
 .byt 255
 .byt 255
 .byt 15

sfx_step_sound
 .byt 4,4,4,4
; .byt 3,2,4,4
