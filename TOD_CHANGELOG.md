# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 3D Fix — Mobile Sheet Layout Cleanup

Status: added, awaiting iPhone test confirmation.

### Fixed
- Cleaned up the Stage 3D mobile Character Sheet layout.
- Shortened the main Sheet summary so it fits better on iPhone.
- Shortened button labels:
  - `Fighter 1`
  - `Classes`
  - `Races`
  - `Identity`
  - `Rules Audit`
- Removed lower-priority test buttons from the visible Sheet to reduce clutter.
- Kept Stage 3D as the active stage.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Character identity summary.
- Race/species registry summary.
- Class registry summary.
- Fighter level 1 shell summary.
- Stage 2 rules foundation summary.

### Not Added Yet
- No active Fighter features.
- No Second Wind.
- No Fighting Style.
- No class feature mechanics.
- No race/species traits.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3D — Fighter Level 1 Shell

Status: added, awaiting iPhone test confirmation after layout cleanup.

### Added
- Added `drak/character/classes/drak_fighter_level_one_shell.gd`.
- Added a tiny Fighter level 1 shell with placeholder labels for:
  - class ID: `fighter`
  - class name: `Fighter`
  - level: `1`
  - hit die: `d10`
  - saving throw proficiencies: STR, CON
- Added `Preview Fighter Level 1` button to the mobile Character Sheet.
- Added Fighter level 1 shell summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3D`.

### Current Placeholder Rules
- Fighter level 1 shell is data-only for now.
- Hit die and saving throw proficiencies are labels only.
- No Fighter class features are active yet.
- No Fighting Style is active yet.
- No Second Wind is active yet.
- No weapons, armor, equipment, attacks, hotbar abilities, or combat behavior are active yet.
- No HP calculation has been changed by this shell yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3A character identity display.
- Stage 3B approved race/species registry display.
- Stage 3C approved class registry display.

### Not Added Yet
- No class features.
- No race/species traits.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3C — Approved Class Registry

Status: confirmed working on iPhone.

### Added
- Added `drak/character/drak_class_registry.gd`.
- Added approved class registry with only:
  - Fighter
  - Wizard
  - Cleric
  - Warlock
  - Rogue
  - Barbarian
  - Ranger
- Added `Preview Class Registry` button to the mobile Character Sheet.
- Added approved class summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3C`.

### Current Placeholder Rules
- Class registry is data-only for now.
- Current character still displays `Fighter` as a label only.
- No class features are active yet.
- No spellcasting class behavior is active yet.
- No hit die/class HP changes are active yet.
- No proficiencies, saves, equipment, or starting features are active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3A character identity display.
- Stage 3B approved race/species registry display.

### Not Added Yet
- No class features.
- No race/species traits.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3B — Approved Race/Species Registry

Status: confirmed working on iPhone.

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

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. Runtime spawning is allowed later for proper systems, but only after the visible foundation remains stable and testable from iPhone.
