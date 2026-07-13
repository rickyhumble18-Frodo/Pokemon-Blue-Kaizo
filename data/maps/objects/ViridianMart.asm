	object_const_def
	const_export VIRIDIANMART_CLERK
	const_export VIRIDIANMART_YOUNGSTER
	const_export VIRIDIANMART_COOLTRAINER_M
	const_export VIRIDIANMART_CLERK2
	const_export VIRIDIANMART_CLERK3
	const_export VIRIDIANMART_CLERK4
	const_export VIRIDIANMART_CLERK5
	const_export VIRIDIANMART_CLERK6
	const_export VIRIDIANMART_CLERK7

ViridianMart_Object:
	db $0 ; border block

	def_warp_events
	warp_event  3,  7, LAST_MAP, 2
	warp_event  4,  7, LAST_MAP, 2

	def_bg_events

	def_object_events
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_VIRIDIANMART_CLERK
	object_event  5,  5, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_VIRIDIANMART_YOUNGSTER
	object_event  3,  3, SPRITE_COOLTRAINER_M, STAY, NONE, TEXT_VIRIDIANMART_COOLTRAINER_M
	; super-mart clerks along the walls (kept off the aisles so every tile
	; and every clerk stays reachable)
	object_event  0,  2, SPRITE_CLERK, STAY, DOWN, TEXT_VIRIDIANMART_CLERK2
	object_event  7,  2, SPRITE_CLERK, STAY, DOWN, TEXT_VIRIDIANMART_CLERK3
	object_event  7,  5, SPRITE_CLERK, STAY, LEFT, TEXT_VIRIDIANMART_CLERK4
	object_event  7,  6, SPRITE_CLERK, STAY, LEFT, TEXT_VIRIDIANMART_CLERK5
	object_event  7,  7, SPRITE_CLERK, STAY, LEFT, TEXT_VIRIDIANMART_CLERK6
	object_event  0,  7, SPRITE_CLERK, STAY, RIGHT, TEXT_VIRIDIANMART_CLERK7

	def_warps_to VIRIDIAN_MART
