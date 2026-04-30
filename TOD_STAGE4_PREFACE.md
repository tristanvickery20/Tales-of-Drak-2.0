# Tales of Drak — Stage 4 Preface

You are working on Tales of Drak, a third-person fantasy survival/RPG in Godot.

## Current Stage

Stage 4 begins the real-time hotbar/combat foundation.

## Main Goal

Create a playable vertical slice that combines:

- Bethesda/Skyrim-style open-world RPG structure.
- ARK-inspired gathering, crafting, and creature taming.
- SWTOR-inspired hotbar/button combat with cooldowns.
- D&D-style rules and class progression.
- The user's original family-built D&D setting/lore.
- Skyrim-inspired character creation, starting with presets.

## Current Foundation

- Stage 1 created the playable iPhone test loop.
- Stage 2 created the tiny D&D rules foundation under `res://drak/rules/`.
- Stage 3 created the tiny character/race/class foundation under `res://drak/character/`.
- Stage 4 should now add the first tiny combat/hotbar foundation under `res://drak/combat/`.

## Stage 4 Rule

Combat is not turn-based.

The D&D rules layer provides resolution math and structure, but the game should play as real-time button/hotbar combat with cooldowns, closer to SWTOR than tabletop turn order.

## Hard Restrictions

- Do not try to build the whole game at once.
- Do not delete or rewrite existing working systems unless explicitly required.
- Keep Skelerealms as the future RPG/world-simulation backend where useful.
- Do not hack Skelerealms internals.
- Add Tales of Drak-specific systems in `res://drak/`.
- Prefer small adapter scripts that connect systems together.
- Keep every stage playable.
- No paid/external assets unless explicitly approved.
- No multiplayer.
- No massive procedural open world.
- No full face-slider character creator yet; use presets first.
- Do not invent major lore, factions, races, gods, regions, or history unless asked.
- Do not add extra playable races/classes unless asked.

## Stage 4A Safety Scope

Stage 4A should add only a hotbar/combat foundation shell:

- Hotbar slot labels.
- Combat foundation manifest.
- Sheet preview.
- No actual combat yet.
- No enemies yet.
- No damage application yet.
- No class features yet.
- No spells yet.
- No Skelerealms integration yet.
