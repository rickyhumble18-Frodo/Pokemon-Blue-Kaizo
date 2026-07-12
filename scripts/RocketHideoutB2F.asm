RocketHideoutB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RocketHideout2TrainerHeaders
	ld de, RocketHideoutB2F_ScriptPointers
	ld a, [wRocketHideoutB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideoutB2FCurScript], a
	ret

RocketHideoutB2F_ScriptPointers:
	def_script_pointers
	dw_const RocketHideoutB2FDefaultScript,         SCRIPT_ROCKETHIDEOUTB2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKETHIDEOUTB2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKETHIDEOUTB2F_END_BATTLE
	dw_const RocketHideoutB2FPlayerSpinningScript,  SCRIPT_ROCKETHIDEOUTB2F_PLAYER_SPINNING

RocketHideoutB2FDefaultScript:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, RocketHideout2ArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	jp z, CheckFightingMapTrainers
	ld hl, wMovementFlags
	set BIT_SPINNING, [hl]
	call StartSimulatingJoypadStates
	ld a, SFX_ARROW_TILES
	call PlaySound
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_ROCKETHIDEOUTB2F_PLAYER_SPINNING
	ld [wCurMapScript], a
	ret

RocketHideout2ArrowTilePlayerMovement:
	; spinner squares removed - floors are normal now
	db -1 ; end

RocketHideoutB2FPlayerSpinningScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, LoadSpinnerArrowTiles
	xor a
	ld [wJoyIgnore], a
	ld hl, wMovementFlags
	res BIT_SPINNING, [hl]
	ld a, SCRIPT_ROCKETHIDEOUTB2F_DEFAULT
	ld [wCurMapScript], a
	ret

INCLUDE "engine/overworld/spinners.asm"

RocketHideoutB2F_TextPointers:
	def_text_pointers
	dw_const RocketHideoutB2FRocketText, TEXT_ROCKETHIDEOUTB2F_ROCKET
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_MOON_STONE
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_NUGGET
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_TM_HORN_DRILL
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_SUPER_POTION

RocketHideout2TrainerHeaders:
	def_trainers
RocketHideout2TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_2_TRAINER_0, 4, RocketHideoutB2FRocketBattleText, RocketHideoutB2FRocketEndBattleText, RocketHideoutB2FRocketAfterBattleText
	db -1 ; end

RocketHideoutB2FRocketText:
	text_asm
	ld hl, RocketHideout2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideoutB2FRocketBattleText:
	text_far _RocketHideoutB2FRocketBattleText
	text_end

RocketHideoutB2FRocketEndBattleText:
	text_far _RocketHideoutB2FRocketEndBattleText
	text_end

RocketHideoutB2FRocketAfterBattleText:
	text_far _RocketHideoutB2FRocketAfterBattleText
	text_end
