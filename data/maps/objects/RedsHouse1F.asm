	object_const_def
	const_export REDSHOUSE1F_MOM
IF DEF(_DEBUG)
	const_export REDSHOUSE1F_ITEM_GOD
	const_export REDSHOUSE1F_POKEMON_GOD
	const_export REDSHOUSE1F_FLAG_GOD
ENDC

RedsHouse1F_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  7,  1, REDS_HOUSE_2F, 1

	def_bg_events
	bg_event  3,  1, TEXT_REDSHOUSE1F_TV

	def_object_events
	object_event  5,  4, SPRITE_MOM, STAY, LEFT, TEXT_REDSHOUSE1F_MOM
IF DEF(_DEBUG)
	object_event  5,  2, SPRITE_SCIENTIST, STAY, DOWN, TEXT_REDSHOUSE1F_ITEM_GOD
	object_event  6,  2, SPRITE_OAK, STAY, DOWN, TEXT_REDSHOUSE1F_POKEMON_GOD
	object_event  6,  3, SPRITE_GAMBLER, STAY, DOWN, TEXT_REDSHOUSE1F_FLAG_GOD
ENDC

	def_warps_to REDS_HOUSE_1F
