
/*Game values*/


/*Hero struct */
/*x=0-4095 y=0-3071                          Default*/
#define		hero_xl					$200	/* 25  */
#define		hero_xh					$201    /* 5   */
#define		hero_yl					$202    /* 96  */
#define		hero_yh					$203    /* 9   */
/*0==North 1==West 2==South 3==East*/
#define		hero_dir				$204    /* 0   */
/*Animation frame (Independant of Direction) 0,1,2,3*/
#define 	hero_frame				$205    /* 0   */
/*Flag when hero hits something*/
#define 	hero_hit				$206    /* 0   */
/*Hero health is from 0 to 47*/
#define 	hero_health 			$207    /* 47  */
/*The speed of the hero (255==Fast)*/
#define 	hero_delay				$208    /* 50  */
/*If hero health is +128 then b0-b1==Death frame, 192==Dead Proper!!*/
#define		key_assignments			$210
/*All keys held in col/row format*/
#define		key4left				$210    /* $54 */
#define		key4right				$211    /* $74 */
#define		key4down				$212    /* $64 */
#define		key4up					$213    /* $34 */
#define		key4fire				$214    /* $42 */
#define		key4menu				$215    /* $04 */
#define		key4smart1				$216    /* $35 */
#define 	key4smart2  			$217    /* $66 */
#define		hour_of_day				$218	/* $09 */
/* 0==Knight 1==Valkyrie 2==Warrior*/
#define 	hero_sprite				$21A	/* 0   */
#define 	all_creatures_hate_me	$21B    /* 0   */
#define 	animation_set			$21c    /* 0   */
#define 	sfx_number				$21d    /* 0   */
/* +128==disable 0-11==Frame */
#define 	colour_cycle			$21e    /* 0   */
/* Icon Number (0-7) */
#define 	icon_number				$21f    /* 0   */
/*All high priority creatures are susceptable to death in that once killed/dead, they may not re-appear*/
/*in the game again, this is decided by hp_creature_multiple==0 (Single Creature)*/
#define 	hp_creature_alive		$220	/* 1   */
/*Object (Item) Tables (16 each)*/
#define 	ls_object_xl			$230    /* 0   */
#define 	ls_object_xh			$240    /* 0   */
#define 	ls_object_yl			$250    /* 0   */
#define 	ls_object_yh			$260    /* 0   */
#define 	ls_object_number		$270    /* 0   */

#define 	region_byte0			$280    /* 5   */
#define 	region_byte1			$281    /* 0   */
/* 0==Keyboard Joystick*/
#define 	control_type			$282    /* 0   */
/*
#define 	key_press_register		$283    /* 0   */
#define		tod_counter_lo			$284  	/* $b8 */
#define		tod_counter_hi			$285  	/* $b  */
#define		tod_alarm				$286	/* 0   */
#define		random_element			$287	/* 87  */
/* 0==Atmos  1==Telestrat  2==Euphoric*/
#define		machine_type			$288	/* 0   */
/* 289-28F Spare */
#define		Current_types			$290
#define		Current_Creature        $290    /* 0  */
#define		Current_Object          $291    /* 0  */
#define		Current_Location        $292    /* 0  */
#define		Current_Action          $293    /* 0  */
/* 294-297 reserved for further types */
#define		Current_Gold_lo			$298	/* 0  */
#define		Current_Gold_hi			$299	/* 0  */
#define		Current_Food_Parcels    $29A    /* 0  */
#define		Current_Food_Parcels    $29B    /* 0  */
/* 29c-29f reserved for further types */
#define		keyword_inventory		$2A0
/* 2A0-2BF reserved for 32 keywords */
/* 2C0 Free */


/*;location specific objects                                                             */
/*;This is perfect, since it also allows special objects to be dropped somewhere and the */
/*;system will remember.                                                                 */
/*                                                                                       */
/*ls_object_xl                                                                           */
/* .byt                                                                                  */
/*ls_object_xh                                                                           */
/*ls_object_yl                                                                           */
/*ls_object_yh                                                                           */
/*;128 indicates object has already been picked up                                       */
/*;128+64+Object indicates object is in possesion of a creature                          */
/*ls_object_number                                                                       */
/* .dsb 8,128		;Low priority Objects (Killed Creature Possessions) (8)             */
/* .byt 1,4,7,8,9,10,13,128	;Location Specific                                  (8)     */
/*Next loc is 280*/
#define		via_portb				$300
#define		via_ddrb				$302
#define		via_ddra				$303
#define		via_t1cl  				$304
#define		via_t1ch  				$305
#define		via_t1ll  				$306
#define		via_t1lh  				$307
#define		via_t2ll  				$308
#define		via_t2ch  				$309
#define		via_shift 				$30a
#define		via_acr   				$30b
#define		via_pcr   				$30c
#define		via_ifr   				$30d
#define		via_ier   				$30e
#define		via_porta 				$30f

#define		tel_joystick			$320
#define		tel_secondfire			$32f

#define	temp_01	$f5
#define	temp_02	$f6
#define	temp_03	$f7

#define GAME_MAX_GOLD 	1000 /*Value*/
#define GAME_MAX_FOOD	15 /*Value*/
#define GAME_MAX_OBJECT	8 /*Value*/

#define DIRECTION_NORTH	0 /*Value*/
#define DIRECTION_WEST	1 /*Value*/
#define DIRECTION_SOUTH	2 /*Value*/
#define DIRECTION_EAST	3 /*Value*/


#define zptext $50
#define ptr16_1 zptext
#define ptr1 zptext+2
#define ptr2 zptext+4
#define ptr3 zptext+6
