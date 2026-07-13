; Debug facilities for Blue Kaizo, only assembled into the _DEBUG build.
; Three "God" NPCs stand in the player's house (Red's House 1F) and hand out
; items, Pokemon and story flags through simple menus. Everything here is
; behind IF DEF(_DEBUG) at the include site, so the clean ROM contains none
; of it.

; ----------------------------------------------------------------------------
; Shared menu helper
; hl = "@"-terminated option string (options separated by `next`)
;  b = number of options
;  c = interior width in tiles
; Returns: a = selected index (0-based); carry set if the player pressed B.
; ----------------------------------------------------------------------------
DebugChoiceMenu:
	push hl
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, b
	dec a
	ld [wMaxMenuItem], a
	ld a, 1
	ld [wTopMenuItemY], a
	ld [wTopMenuItemX], a
	hlcoord 0, 0
	inc b ; interior height = options + 1
	call TextBoxBorder
	call UpdateSprites
	pop de
	hlcoord 2, 1
	call PlaceString
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, .cancel
	ld a, [wCurrentMenuItem]
	and a ; clear carry
	ret
.cancel
	scf
	ret

; Give quantity d of every item id in the 0-terminated list at hl.
DebugGiveItemList:
.loop
	ld a, [hli]
	and a
	ret z
	ld b, a
	ld c, d
	push hl
	push de
	call GiveItem
	pop de
	pop hl
	jr .loop

DebugDoneText:
	text "Done!"
	done

DebugNothingText:
	text "...maybe later."
	done

; ============================================================================
; Item God
; ============================================================================
DebugItemGodScript:
	ld hl, DebugItemGodMenu
	ld b, 6
	ld c, 10
	call DebugChoiceMenu
	jr c, .cancel
	add a
	ld d, 0
	ld e, a
	ld hl, .handlers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.handlers
	dw .balls
	dw .healing
	dw .stats
	dw .keyItems
	dw .tms1
	dw .tms2
.balls
	ld hl, DebugBallsList
	ld d, 99
	jr .giveAndDone
.healing
	ld hl, DebugHealingList
	ld d, 99
	jr .giveAndDone
.stats
	ld hl, DebugStatsList
	ld d, 99
	jr .giveAndDone
.keyItems
	ld hl, DebugKeyItemsList
	ld d, 1
	jr .giveAndDone
.tms1
	ld hl, DebugTMs1List
	ld d, 1
	jr .giveAndDone
.tms2
	ld hl, DebugTMs2List
	ld d, 1
.giveAndDone
	call DebugGiveItemList
	ld hl, DebugDoneText
	jp PrintText
.cancel
	ld hl, DebugNothingText
	jp PrintText

DebugItemGodMenu:
	db   "BALLS"
	next "HEALING"
	next "STAT ITEMS"
	next "KEY ITEMS"
	next "TMs 01-25"
	next "TMs 26-50@"

DebugBallsList:
	db POKE_BALL, GREAT_BALL, ULTRA_BALL, SAFARI_BALL, MASTER_BALL
	db 0

DebugHealingList:
	db POTION, SUPER_POTION, HYPER_POTION, MAX_POTION, FULL_RESTORE
	db REVIVE, MAX_REVIVE, FULL_HEAL, ANTIDOTE, BURN_HEAL, ICE_HEAL
	db PARLYZ_HEAL, AWAKENING, ESCAPE_ROPE, REPEL, SUPER_REPEL, MAX_REPEL
	db 0

DebugStatsList:
	db HP_UP, PROTEIN, IRON, CARBOS, CALCIUM, PP_UP, RARE_CANDY
	db ETHER, MAX_ETHER, ELIXER, MAX_ELIXER
	db 0

DebugKeyItemsList:
	db BICYCLE, OLD_ROD, GOOD_ROD, SUPER_ROD, ITEMFINDER, SILPH_SCOPE
	db POKE_FLUTE, CARD_KEY, SECRET_KEY, LIFT_KEY, EXP_ALL, COIN_CASE
	db GOLD_TEETH, S_S_TICKET, TOWN_MAP, BIKE_VOUCHER, DOME_FOSSIL
	db HELIX_FOSSIL, OAKS_PARCEL
	db HM_CUT, HM_FLY, HM_SURF, HM_STRENGTH, HM_FLASH
	db 0

DebugTMs1List:
	db TM_MEGA_PUNCH, TM_RAZOR_WIND, TM_SWORDS_DANCE, TM_WHIRLWIND, TM_MEGA_KICK
	db TM_TOXIC, TM_HORN_DRILL, TM_BODY_SLAM, TM_TAKE_DOWN, TM_DOUBLE_EDGE
	db TM_BUBBLEBEAM, TM_WATER_GUN, TM_ICE_BEAM, TM_BLIZZARD, TM_HYPER_BEAM
	db TM_PAY_DAY, TM_SUBMISSION, TM_COUNTER, TM_SEISMIC_TOSS, TM_RAGE
	db TM_MEGA_DRAIN, TM_SOLARBEAM, TM_DRAGON_RAGE, TM_THUNDERBOLT, TM_THUNDER
	db 0

DebugTMs2List:
	db TM_EARTHQUAKE, TM_FISSURE, TM_DIG, TM_PSYCHIC_M, TM_TELEPORT
	db TM_MIMIC, TM_DOUBLE_TEAM, TM_REFLECT, TM_BIDE, TM_METRONOME
	db TM_SELFDESTRUCT, TM_EGG_BOMB, TM_FIRE_BLAST, TM_SWIFT, TM_SKULL_BASH
	db TM_SOFTBOILED, TM_DREAM_EATER, TM_SKY_ATTACK, TM_REST, TM_THUNDER_WAVE
	db TM_PSYWAVE, TM_EXPLOSION, TM_ROCK_SLIDE, TM_TRI_ATTACK, TM_SUBSTITUTE
	db 0

; ============================================================================
; Pokemon God: pick a Pokedex number, then a level; get that Pokemon (its DVs
; are maxed automatically by the Phase 3 add_mon patch).
; ============================================================================
DebugPokemonGodScript:
	call DebugPickDexNumber
	jr c, .cancel
	; wPokedexNum currently holds the chosen dex number; convert to species
	farcall PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	; level menu
	ld hl, DebugLevelMenu
	ld b, 2
	ld c, 6
	call DebugChoiceMenu
	jr c, .cancel
	and a
	ld a, 5
	jr z, .gotLevel
	ld a, 100
.gotLevel
	ld c, a
	ld a, [wCurPartySpecies]
	ld b, a
	call GivePokemon
	ld hl, DebugDoneText
	jp PrintText
.cancel
	ld hl, DebugNothingText
	jp PrintText

; Scroll a Pokedex number 1..151 with Up/Down, A confirms, B cancels.
; Result left in wPokedexNum. Carry set on cancel.
DebugPickDexNumber:
	ld a, 1
	ld [wPokedexNum], a
.redraw
	hlcoord 0, 0
	ld b, 2
	ld c, 9
	call TextBoxBorder
	hlcoord 1, 1
	ld de, DebugDexLabel
	call PlaceString
	hlcoord 5, 1
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	call UpdateSprites
.input
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and a
	jr z, .input
	ld b, a
	bit B_PAD_A, b
	jr nz, .confirm
	bit B_PAD_B, b
	jr nz, .cancel
	ld a, [wPokedexNum]
	bit B_PAD_UP, b
	jr z, .checkDown
	inc a
	cp NUM_POKEMON + 1
	jr c, .store
	ld a, NUM_POKEMON
	jr .store
.checkDown
	bit B_PAD_DOWN, b
	jr z, .input
	dec a
	jr nz, .store
	ld a, 1
.store
	ld [wPokedexNum], a
	jr .redraw
.confirm
	and a
	ret
.cancel
	scf
	ret

DebugDexLabel:
	db "#@"

DebugLevelMenu:
	db   "LV 5"
	next "LV100@"

; ============================================================================
; Flag God: toggle badges, fly points, and key story flags.
; ============================================================================
DebugFlagGodScript:
	ld hl, DebugFlagGodMenu
	ld b, 4
	ld c, 9
	call DebugChoiceMenu
	jr c, .cancel
	and a
	jr z, .badges
	dec a
	jr z, .flyMaps
	dec a
	jr z, .story
	jr .dex
.badges
	ld a, $ff
	ld [wObtainedBadges], a
	ld [wBeatGymFlags], a
	jr .done
.flyMaps
	ld hl, wTownVisitedFlag
	ld c, (NUM_CITY_MAPS + 7) / 8
	ld a, $ff
.flyLoop
	ld [hli], a
	dec c
	jr nz, .flyLoop
	jr .done
.story
	SetEvent EVENT_OAK_GOT_PARCEL
	SetEvent EVENT_GOT_OAKS_PARCEL
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_GOT_OLD_AMBER
	SetEvent EVENT_RESCUED_MR_FUJI
	SetEvent EVENT_RESCUED_MR_FUJI_2
	SetEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	SetEvent EVENT_GOT_MASTER_BALL
	jr .done
.dex
	ld hl, wPokedexOwned
	ld c, wPokedexSeenEnd - wPokedexOwned
	ld a, $ff
.dexLoop
	ld [hli], a
	dec c
	jr nz, .dexLoop
.done
	ld hl, DebugDoneText
	jp PrintText
.cancel
	ld hl, DebugNothingText
	jp PrintText

DebugFlagGodMenu:
	db   "BADGES"
	next "FLY MAPS"
	next "STORY"
	next "DEX@"
