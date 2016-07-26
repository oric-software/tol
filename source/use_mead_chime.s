//Use Mead Chime - Generates gold randomly over bg-buffer

// To prevent overuse, can only use 10 times.
// Generated values are always 99 Gold
// Gold is deposited into
use_mead_chime
	lda meadchime_count
	beq
	dec meadchime_count
