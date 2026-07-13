; Per-class base offsets into sRematchWins, generated from the party
; counts in data/trainers/parties.asm (one win counter per party).
; If parties are added or removed, regenerate this table.
RematchPartyBases:
	table_width 2
	dw 0   ; YoungsterData
	dw 13  ; BugCatcherData
	dw 27  ; LassData
	dw 45  ; SailorData
	dw 53  ; JrTrainerMData
	dw 62  ; JrTrainerFData
	dw 86  ; PokemaniacData
	dw 93  ; SuperNerdData
	dw 105 ; HikerData
	dw 119 ; BikerData
	dw 134 ; BurglarData
	dw 143 ; EngineerData
	dw 146 ; UnusedJugglerData
	dw 146 ; FisherData
	dw 157 ; SwimmerData
	dw 172 ; CueBallData
	dw 181 ; GamblerData
	dw 188 ; BeautyData
	dw 203 ; PsychicData
	dw 207 ; RockerData
	dw 209 ; JugglerData
	dw 217 ; TamerData
	dw 223 ; BirdKeeperData
	dw 240 ; BlackbeltData
	dw 249 ; Rival1Data
	dw 258 ; ProfOakData
	dw 261 ; ChiefData
	dw 261 ; ScientistData
	dw 274 ; GiovanniData
	dw 276 ; RocketData
	dw 317 ; CooltrainerMData
	dw 327 ; CooltrainerFData
	dw 335 ; BrunoData
	dw 336 ; BrockData
	dw 337 ; MistyData
	dw 338 ; LtSurgeData
	dw 339 ; ErikaData
	dw 340 ; KogaData
	dw 341 ; BlaineData
	dw 342 ; SabrinaData
	dw 343 ; GentlemanData
	dw 348 ; Rival2Data
	dw 360 ; Rival3Data
	dw 363 ; LoreleiData
	dw 363 ; ChannelerData
	dw 387 ; AgathaData
	dw 387 ; LanceData
	assert_table_length NUM_TRAINERS
ASSERT NUM_TRAINER_PARTIES == 388 ; keep constants/trainer_constants.asm in sync
