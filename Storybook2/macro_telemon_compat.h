



#define CALL_HIRES\
	.byt 00,$1A;
#define CALL_TEXT\
	.byt 00,$19;	

	
#define CALL_KBDCLICK1\
	nop
	
#define CALL_KBDCLICK2\
	nop

; This is crap
#define CALL_LORES0\
	.byt 00,$1A:\
	.byt 00,$19;	

#define CALL_READKEYBOARD\
	.byt $00,$08
	


	
	