# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 3A — Character Identity Shell

Status: added, awaiting iPhone test confirmation.

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

## Stage 2P — Rules Manifest + Audit Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_rules_manifest.gd`.
- Added a Stage 2 rules manifest listing the foundations currently loaded.
- Added `Preview Rules Audit` button to the mobile Character Sheet.
- Added rules manifest summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2P`.

### Current Placeholder Rules
- Rules manifest is an organization/audit layer only.
- It does not change gameplay.
- It confirms the current Stage 2 foundation modules exist before moving into later systems.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, level range 1-5, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, action economy tracker, cooldown tracker, damage type registry, hit dice/rest tracker, and spellcasting shell.

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

## Stage 2O — Spellcasting Resource Shell

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_spellcasting.gd`.
- Added a tiny spellcasting resource shell.
- Added `Preview Spellcasting` button to the mobile Character Sheet.
- Added spellcasting summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2O`.

### Current Placeholder Rules
- Spellcasting is not enabled by default.
- Spellcasting ability is `None`.
- Cantrips known are `0`.
- Level 1 spell slots are `0 / 0`.
- This stage only proves the shell exists for later Wizard, Cleric, Warlock, Ranger, and other class-specific spell logic.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, level range 1-5, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, action economy tracker, cooldown tracker, damage type registry, and hit dice/rest tracker.

### Not Added Yet
- No actual spells.
- No spell lists.
- No spell attacks.
- No spell save DC.
- No spell slot spending.
- No class or race/species features.
- No XP system.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No combat.
- No enemies.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. Runtime spawning is allowed later for proper systems, but only after the visible foundation remains stable and testable from iPhone.
