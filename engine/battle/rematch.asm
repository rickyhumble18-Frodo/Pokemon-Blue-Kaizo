; Trainer rematch and level-scaling engine (Phases 7b/7c).
;
; Storage lives in SRAM bank 1 in the padding before sGameData (see
; ram/sram.asm): one win counter per trainer party (sRematchWins, indexed
; through RematchPartyBases), a single Elite Four clear counter
; (sEliteFourClears), and a magic byte (sRematchMagic) that guards against
; uninitialized SRAM.

DEF REMATCH_MAGIC EQU $A7

RematchOpenSRAM:
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	ld a, BMODE_ADVANCED
	ld [rBMODE], a
	ASSERT BANK("Save Data") == BMODE_ADVANCED
	ld [rRAMB], a
	; fallthrough: make sure the block is initialized
EnsureRematchInit:
	ld a, [sRematchMagic]
	cp REMATCH_MAGIC
	ret z
	; first use (or garbage SRAM): zero the whole block
	ld hl, sRematchWins
	ld bc, NUM_TRAINER_PARTIES + 1 ; wins + sEliteFourClears
	xor a
.clearLoop
	ld [hli], a
	dec bc
	ld a, b
	or c
	ld a, 0
	jr nz, .clearLoop
	ld a, REMATCH_MAGIC
	ld [sRematchMagic], a
	ret

RematchCloseSRAM:
	xor a
	ld [rBMODE], a
	ld [rRAMG], a
	ret

; Is the trainer class in a (0-based) an Elite Four member or the Champion?
; Returns carry if so.
IsEliteFourClass:
	inc a ; back to 1-based class ids
	cp LORELEI
	jr z, .yes
	cp BRUNO
	jr z, .yes
	cp AGATHA
	jr z, .yes
	cp LANCE
	jr z, .yes
	cp RIVAL3 ; Champion
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

; hl = sRematchWins entry for trainer class e (0-based) and party [wTrainerNo]
; (requires SRAM to be open)
GetRematchWinAddr:
	ld a, e
	add a
	ld c, a
	ld b, 0
	ld hl, RematchPartyBases
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = base index for this class
	ld a, [wTrainerNo]
	dec a ; 0-based party number
	ld c, a
	ld b, 0
	add hl, bc
	ld bc, sRematchWins
	add hl, bc
	ret

; Scale a trainer mon's level for rematches.
; in:  a = base level from the party data
; out: a = base level + 2 * wins (or + 5 * Elite Four clears), capped at 255
; preserves hl, de, bc
ScaleTrainerLevel::
	push hl
	push de
	push bc
	ld d, a ; d = base level
	call RematchOpenSRAM
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET + 1
	ld e, a ; e = 0-based class
	call IsEliteFourClass
	jr c, .eliteFour
	call GetRematchWinAddr
	ld a, [hl] ; wins vs this trainer
	ld e, a    ; stash: RematchCloseSRAM clobbers a
	call RematchCloseSRAM
	; bonus = 2 * wins, saturated
	ld a, e
	add e
	jr nc, .gotBonus
	ld a, $ff
	jr .gotBonus
.eliteFour
	ld a, [sEliteFourClears]
	ld e, a    ; stash: RematchCloseSRAM clobbers a
	call RematchCloseSRAM
	; bonus = 5 * clears, saturated
	ld a, e
	add a ; *2
	jr c, .satBonus
	add a ; *4
	jr c, .satBonus
	add e ; *5
	jr nc, .gotBonus
.satBonus
	ld a, $ff
.gotBonus
	add d ; base level + bonus
	jr nc, .noCap
	ld a, $ff
.noCap
	pop bc
	pop de
	pop hl
	ret

; Record a victory against the current trainer (farcalled from
; EndTrainerBattle after the beaten flag is set). Elite Four members are
; excluded: their scaling comes solely from sEliteFourClears.
RecordTrainerWin::
	ld a, [wEnemyMonOrTrainerClass]
	cp OPP_ID_OFFSET
	ret c ; wild battle, nothing to record
	ld a, [wEnemyMonOrTrainerClass]
	sub OPP_ID_OFFSET + 1
	ld e, a ; e = 0-based class
	call IsEliteFourClass
	ret c ; Elite Four scaling is handled by the clear counter alone
	call RematchOpenSRAM
	call GetRematchWinAddr
	ld a, [hl]
	inc a
	jr z, .saturated ; wrapped to 0: leave at 255
	ld [hl], a
.saturated
	jp RematchCloseSRAM

; Increment the Elite Four clear counter (farcalled after beating the
; Champion, so a mid-run wipe never raises the scaling).
IncrementE4Clears::
	call RematchOpenSRAM
	ld a, [sEliteFourClears]
	inc a
	jr z, .saturated
	ld [sEliteFourClears], a
.saturated
	jp RematchCloseSRAM

; Zero all rematch data (farcalled when starting a new game so a fresh
; playthrough never inherits the previous run's scaling).
ResetRematchData::
	call RematchOpenSRAM
	xor a
	ld [sRematchMagic], a ; invalidate, then re-init from scratch
	call EnsureRematchInit
	jp RematchCloseSRAM

; Ask the player if they want a rematch against an already-beaten trainer.
; Returns carry if they accept. Farcalled from TalkToTrainer.
AskRematch::
	ld hl, RematchAskText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .no
	scf
	ret
.no
	and a
	ret

RematchAskText:
	text "Want to battle"
	line "again?"
	done

INCLUDE "data/trainers/rematch_bases.asm"
