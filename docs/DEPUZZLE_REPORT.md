# Blue Kaizo De-Puzzle — Phase 1 Recon Report

Comparison base: vanilla `pret/pokered` @ `fbcf7d0e19a3a2db505440d3ccd3d40ca996c15c`
(the commit this repo's README states it was forked from), fetched as a
reference copy. Diffed: `maps/*.blk` (block layouts) and
`data/maps/objects/*.asm` (warps / signs / NPCs / trainers / items).

## Headline findings

- **90 of ~248 maps** have redesigned block layouts vs vanilla.
- **Rocket Hideout B2F/B3F and Viridian Gym: the spinner *graphics* were
  removed from the Kaizo layouts, but the vanilla coordinate-driven spinner
  scripts are untouched** (`scripts/RocketHideoutB2F.asm`,
  `scripts/RocketHideoutB3F.asm`, `scripts/ViridianGym.asm` are byte-identical
  to vanilla). Any redesigned floor square that lands on a vanilla arrow
  coordinate is an **invisible spin trap**. De-puzzling must neuter the
  `map_coord_movement` tables, not just tiles.
- Blocksets (`gfx/blocksets/*.bst`) are identical to vanilla, so block IDs
  mean the same thing as in vanilla pokered.
- Rock Tunnel darkness is hard-coded at `home/overworld.asm` (entering
  `ROCK_TUNNEL_1F` sets `wMapPalOffset = 6`); one patch site disables it.

## Boulder (Strength) puzzles

| Map | Boulders | Notes |
|---|---|---|
| SeafoamIslands1F | 2 | drop-through-hole current puzzle |
| SeafoamIslandsB1F | 2 | " |
| SeafoamIslandsB2F | 2 | " |
| SeafoamIslandsB3F | 6 | " (2 must go down holes to stop the B4F current) |
| SeafoamIslandsB4F | 2 | current blocks Articuno until B3F boulders dropped |
| VictoryRoad1F | 3 | switch puzzle gates TM item + exit |
| VictoryRoad2F | 3 | switch puzzles gate progress |
| VictoryRoad3F | 4 | switch puzzles gate progress |

## Spinner / arrow tiles

| Map | Visible arrows | Script table | Status |
|---|---|---|---|
| RocketHideoutB2F | 0 (removed by SHF) | vanilla, ~50 coords | invisible spin traps |
| RocketHideoutB3F | 0 (removed by SHF) | vanilla | invisible spin traps |
| ViridianGym | 0 (removed by SHF) | vanilla | invisible spin traps |

(Facility-tileset tiles $20/$21/$30/$31 detected in Silph Co / Saffron Gym are
teleporter pads sharing the same VRAM slots, not spinners.)

## Flagged dungeons (redesign intensity, % of layout blocks changed)

| Dungeon | Change vs vanilla | Tedium present |
|---|---|---|
| Rock Tunnel 1F / B1F | 81.7% / 66.1% | maze + darkness (Flash) |
| Mt Moon 1F / B1F / B2F | 44.2% / 88.3% / 41.4% | maze |
| Seafoam 1F/B1F/B2F/B3F/B4F | 82.2%/60.7%/57.8%/(B3F warp-heavy)/... | boulder-hole + current puzzle |
| Victory Road 1F/2F/3F | 17.8% / 27.4% / 18.5% | boulder-switch puzzles |
| Rocket Hideout B1F–B4F | 14.3% / 34.3% / 25.2% / 1.7% | invisible spinner mazes, lift |
| Silph Co 1F–11F | mostly <15%, 2F/3F/5F ~26% | teleporter/warp maze + Card Key doors |
| Pokemon Mansion 1F–B1F | ~11–12.6% | switch-statue routing |
| Viridian Gym | 72.2% | invisible spinner maze |
| Cerulean Cave (bonus) | 93–95% | heavy maze (not in scope list) |

## Full .blk diff table

| Map | % blocks changed |
|---|---|
| CeruleanCaveB1F | 94.8% |
| CeruleanGym | 94.3% |
| Route17 | 94.2% |
| CeruleanCave1F | 93.3% |
| MtMoonB1F | 88.3% |
| Route8 | 85.2% |
| BrunosRoom | 83.3% |
| SeafoamIslands1F | 82.2% |
| RockTunnel1F | 81.7% |
| FightingDojo | 80.0% |
| Route18 | 78.2% |
| VermilionGym | 77.8% |
| Route11 | 75.2% |
| Route21 | 72.7% |
| Route2 | 72.5% |
| ViridianGym | 72.2% |
| DiglettsCave | 69.7% |
| SafariZoneCenter | 68.7% |
| CeruleanCave2F | 68.1% |
| ViridianForest | 67.2% |
| RockTunnelB1F | 66.1% |
| SafariZoneNorth | 66.1% |
| CeruleanCity | 62.2% |
| PewterCity | 60.8% |
| SeafoamIslandsB1F | 60.7% |
| CeladonGym | 60.0% |
| FuchsiaGym | 60.0% |
| SafariZoneWest | 59.5% |
| SeafoamIslandsB2F | 57.8% |
| Route14 | 56.3% |
| Route16 | 55.0% |
| Route23 | 54.6% |
| PewterGym | 54.3% |
| Route24 | 52.8% |
| SafariZoneEast | 51.3% |
| Route6 | 45.6% |
| Route7 | 45.6% |
| Route9 | 44.8% |
| Route19 | 44.4% |
| MtMoon1F | 44.2% |
| Route20 | 44.2% |
| Route4 | 42.7% |
| MtMoonB2F | 41.4% |
| Route12 | 41.1% |
| Route15 | 38.1% |
| Route22 | 36.7% |
| CinnabarIsland | 34.4% |
| RocketHideoutB2F | 34.3% |
| Route25 | 31.9% |
| VermilionDock | 31.0% |
| Route1 | 30.6% |
| Route10 | 30.0% |
| Route3 | 29.2% |
| VictoryRoad2F | 27.4% |
| SilphCo3F | 26.7% |
| SilphCo2F | 25.9% |
| RocketHideoutB3F | 25.2% |
| VermilionCity | 23.6% |
| Route13 | 21.1% |
| FuchsiaCity | 20.3% |
| Route5 | 20.0% |
| VictoryRoad3F | 18.5% |
| VictoryRoad1F | 17.8% |
| PalletTown | 16.7% |
| RocketHideoutB1F | 14.3% |
| SilphCo5F | 14.1% |
| ViridianCity | 13.9% |
| SilphCo7F | 13.7% |
| LavenderTown | 13.3% |
| PokemonTower4F | 13.3% |
| PokemonMansion3F | 12.6% |
| PokemonMansion1F | 11.0% |
| PokemonMansion2F | 11.0% |
| CeladonHotel | 10.7% |
| PokemonTower3F | 7.8% |
| SaffronCity | 7.2% |
| SilphCo4F | 6.7% |
| MrPsychicsHouse | 6.2% |
| NameRatersHouse | 6.2% |
| ViridianNicknameHouse | 6.2% |
| PokemonTower5F | 5.6% |
| SilphCo6F | 4.3% |
| SilphCo1F | 3.7% |
| SilphCo8F | 3.4% |
| PokemonTower6F | 3.3% |
| RocketHideoutB4F | 1.7% |
| SilphCo10F | 1.4% |
| SilphCo11F | 1.2% |
| SilphCo9F | 0.9% |
| CeladonCity | 0.4% |

---

# Phase 2/3 — Implemented changes

All changes below keep battle data byte-identical: no trainer parties,
movesets, DVs, wild encounter tables, or item contents were modified, and
every trainer, item ball, hidden item and warp remains reachable (verified
by BFS over the collision data of each edited map).

## Engine / script changes

| Change | Files |
|---|---|
| Rock Tunnel darkness removed (no Flash needed) | `home/overworld.asm` |
| All spinner squares removed (tables emptied; Kaizo had invisible spin traps) | `scripts/RocketHideoutB2F.asm`, `scripts/RocketHideoutB3F.asm`, `scripts/ViridianGym.asm` |
| Seafoam strong currents disabled (boulder-drop no longer gates Articuno) | `data/maps/force_bike_surf.asm` |
| Pokemon Mansion switch-gates always open (switches now inert) | `scripts/PokemonMansion{1F,2F,3F,B1F}.asm` |
| Max DVs ($FF $FF) for player-obtained mons: gifts/trades, wild catches, box catches | `engine/pokemon/add_mon.asm`, `engine/items/item_effects.asm` |

## Map layout changes (one commit per map)

- **Rock Tunnel 1F/B1F, Mt Moon 1F/B1F/B2F, Rocket Hideout B1F–B4F,
  Viridian Gym, Victory Road 1F–3F, Seafoam 1F–B4F** — rebuilt as single
  gauntlet corridors: entrance → every trainer/item → exit. Boulders are
  entombed in walls (switch/hole events can never fire); the Victory Road
  switch-gated blocks and Rocket Hideout B4F remain script-compatible
  (the two-guard door before Giovanni still works).
- **Silph Co 1F–8F, 11F** — layouts kept; minimal wall blocks opened so the
  already-direct 1F→11F stair climb also reaches every trainer/item/teleport
  pad on foot (Blue Kaizo had already removed the Card Key doors; teleport
  pads remain as shortcuts). 9F/10F needed no changes.
- **Pokemon Mansion 1F–B1F** — layouts kept; gates baked open, plus one wall
  opened on 2F and 3F for full on-foot reachability.

Known quirk kept from stock Blue Kaizo: the Silph Co 7F elevator door is
blocked by a Rocket standing on its only approach square (pre-existing).
