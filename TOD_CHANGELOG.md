# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 3B — Approved Race/Species Registry

Status: added, awaiting iPhone test confirmation.

### Added
- Added `drak/character/drak_race_species_registry.gd`.
- Added approved race/species registry with only:
  - Elf
  - Variant Human
  - Dwarf
  - Orc
- Added `Preview Race/Species Registry` button to the mobile Character Sheet.
- Added approved race/species summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3B`.

### Current Placeholder Rules
- Race/species registry is data-only for now.
- Current character still displays `Variant Human` as a label only.
- No race/species traits are active yet.
- No ability score changes are active yet.
- No movement, spell, proficiency, ancestry, or feature changes are active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3A character identity display.

### Not Added Yet
- No race/species traits.
- No class registry yet.
- No class features.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3A Fix — Sheet Overlay Preload Safety

Status: confirmed working on iPhone.

### Fixed
- Removed the risky direct preload dependency from the mobile Sheet overlay for the new character identity shell.
- Kept `drak/character/drak_character_identity.gd` in the project as the future modular identity shell.
- Added safe built-in fallback identity text inside the Sheet overlay so the Sheet button should not disappear if a new identity script has an export/web issue.
- Added replacement support for the old `Stage 11` HUD text so the visible HUD should update to `Stage 3A`.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3A character identity display.

### Not Added Yet
- No race/species traits.
- No class features.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3A — Character Identity Shell

Status: confirmed working on iPhone after overlay fix.

### Added
- Added `STAGE3_DELIVERABLE.md`.
- Added `drak/character/drak_character_identity.gd`.
- Added a tiny character identity shell with:
  - character name placeholder
  - selected race/species placeholder
  - selected class placeholder
  - current level placeholder
- Added `Preview Character Identity` button to the mobile Character Sheet.
- Added character identity summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3A`.

### Current Placeholder Rules
- Current placeholder character is `Drak Test Hero`.
- Current placeholder race/species is `Variant Human`.
- Current placeholder class is `Fighter`.
- Current placeholder level is `1`.
- No race/species traits are active yet.
- No class features are active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation, closeout checklist, Stage 3 handoff, rules manifest, and changelog.

### Not Added Yet
- No race/species traits.
- No class features.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2R — Stage 2 Final Lock + Stage 3 Handoff

Status: confirmed working on iPhone.

### Added
- Added `STAGE3_HANDOFF.md`.
- Added `Preview Stage 3 Handoff` button to the mobile Character Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2R`.
- Locked Stage 2 as the D&D rules foundation stage before Stage 3 begins.

### Current Placeholder Rules
- This stage is a final lock and handoff only.
- It does not add race/species features yet.
- It does not add class features yet.
- Stage 3 should begin with a tiny character identity shell only.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation, closeout checklist, rules manifest, and changelog.

### Not Added Yet
- No combat.
- No enemies.
- No class or race/species features.
- No XP system.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2Q — Mobile Sheet Cleanup + Closeout Checklist

Status: confirmed working on iPhone.

### Added
- Added `STAGE2_CLOSEOUT_CHECKLIST.md`.
- Added `Preview Stage 2 Closeout` button to the mobile Character Sheet.
- Updated Sheet text to act as a cleaner Stage 2 summary instead of a pile of loose tests.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2Q`.

### Current Placeholder Rules
- This stage is cleanup/documentation only.
- It does not add new gameplay rules.
- It prepares Stage 2 for closeout before Stage 3 race/species and class foundation.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, level range 1-5, proficiency bonus, HP, AC, hit dice/rest tracker, spellcasting shell, and rules manifest audit.

### Not Added Yet
- No combat.
- No enemies.
- No class or race/species features.
- No XP system.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. Runtime spawning is allowed later for proper systems, but only after the visible foundation remains stable and testable from iPhone.
