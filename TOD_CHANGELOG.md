# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 4B — Visible Inactive Mobile Hotbar Shell

Status: added, awaiting iPhone test confirmation.

### Added
- Added `drak/ui/drak_hotbar_overlay.gd`.
- Added `DrakHotbarOverlay` autoload in `project.godot`.
- Added visible 2-row inactive hotbar shell in playable scenes only.
- Added 8 visible inactive slot labels:
  - 1 Weapon
  - 2 Class
  - 3 Range
  - 4 Guard
  - 5 Heal
  - 6 Control
  - 7 Tame
  - 8 Dodge
- Added `Hotbar Shell` button to the mobile Character Sheet.
- Updated Sheet summary for Stage 4B.
- Updated visible HUD stage labels to `Tales of Drak — Stage 4B`.

### Current Placeholder Rules
- Hotbar shell is visual only.
- Hotbar slots are labels, not active buttons.
- No attacks are active yet.
- No target selection is active yet.
- No cooldown UI is active yet.
- No abilities, class features, spells, damage, enemy health, or combat state logic is active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Pickups.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3 character/race/class foundation.
- Stage 4A deliverable and preface files.
- Cleaned mobile Sheet layout.

### Not Added Yet
- No real enemy combat.
- No enemy AI.
- No damage application.
- No HP reduction.
- No weapon/equipment inventory.
- No spell attacks.
- No spell saving throws.
- No real class features.
- No real race traits.
- No loot.
- No crafting.
- No taming.
- No quests.
- No dialogue.
- No Skelerealms integration yet.

## Stage 4A — Hotbar / Combat Foundation Plan

Status: confirmed working on iPhone.

### Added
- Added `STAGE4_DELIVERABLE.md`.
- Added `TOD_STAGE4_PREFACE.md`.
- Added `drak/combat/drak_hotbar_foundation_manifest.gd`.
- Added Stage 4 hotbar foundation manifest with 8 planned inactive slot labels:
  - Weapon Attack
  - Class Feature
  - Cantrip / Ranged
  - Defensive Ability
  - Heal / Recovery
  - Control Ability
  - Tame / Pet Command
  - Dodge / Utility
- Added `Stage 4 Plan` button to the mobile Character Sheet.
- Updated Sheet summary for Stage 4A.
- Updated visible HUD stage labels to `Tales of Drak — Stage 4A`.

### Current Placeholder Rules
- This stage is a hotbar/combat planning shell only.
- Combat direction is real-time SWTOR-style button/hotbar combat with cooldowns.
- D&D rules are the math/resolution backbone, not a turn-based gameplay loop.
- No hotbar buttons are visible in gameplay yet.
- No actual abilities are active yet.
- No target, enemy, damage, weapon, spell, class feature, or combat state logic is active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Pickups.
- Cave entrance and exit cave transitions.
- Stage 2 rules foundation.
- Stage 3 character/race/class foundation.
- Cleaned mobile Sheet layout.

### Not Added Yet
- No real enemy combat.
- No enemy AI.
- No damage application.
- No HP reduction.
- No weapon/equipment inventory.
- No spell attacks.
- No spell saving throws.
- No real class features.
- No real race traits.
- No loot.
- No crafting.
- No taming.
- No quests.
- No dialogue.
- No Skelerealms integration yet.

## Stage 3G — Character Foundation Audit + Closeout Checklist

Status: confirmed working on iPhone.

### Added
- Added `STAGE3_CLOSEOUT_CHECKLIST.md`.
- Added `drak/character/drak_character_foundation_manifest.gd`.
- Added Stage 3 character foundation manifest listing:
  - Character Identity Shell
  - Approved Race/Species Registry
  - Approved Class Registry
  - Fighter Level 1 Shell
  - Wizard/Cleric/Warlock Caster Shells
  - Rogue/Barbarian/Ranger Shells
- Added `Stage 3 Audit` button to the mobile Character Sheet.
- Added Stage 3 audit summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3G`.

### Current Placeholder Rules
- This stage is an audit/closeout foundation only.
- No race/species traits are active yet.
- No class features are active yet.
- No combat, hotbar, inventory, crafting, taming, quests, dialogue, or Skelerealms integration is active yet.

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
- Stage 3D Fighter level 1 shell display.
- Stage 3E caster shell display.
- Stage 3F Rogue/Barbarian/Ranger shell display.
- Cleaned mobile Sheet layout.

### Not Added Yet
- No active race/species traits.
- No active class features.
- No XP system.
- No full character creator UI.
- No face/body sliders.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory/equipment.
- No crafting.
- No taming.
- No quests.
- No dialogue.
- No Skelerealms integration yet.

## Stage 3F — Rogue / Barbarian / Ranger Identity Shells

Status: confirmed working on iPhone.

### Added
- Added `drak/character/classes/drak_other_class_identity_shells.gd`.
- Added tiny identity shells for approved classes only:
  - Rogue
  - Barbarian
  - Ranger
- Added `Other Classes` button to the mobile Character Sheet.
- Added other class shell summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3F`.

### Current Placeholder Rules
- Other class shells are data-only labels for now.
- Rogue, Barbarian, and Ranger are not selectable yet.
- No Rogue features are active yet.
- No Barbarian features are active yet.
- No Ranger features or Ranger spellcasting are active yet.
- No class features are active yet.

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
- Stage 3D Fighter level 1 shell display.
- Stage 3E caster shell display.
- Cleaned mobile Sheet layout.

### Not Added Yet
- No Rage.
- No Sneak Attack.
- No Favored Enemy.
- No Natural Explorer.
- No Ranger spellcasting.
- No class features.
- No race/species traits.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3E — Spellcasting Class Identity Shells

Status: confirmed working on iPhone.

### Added
- Added `drak/character/classes/drak_spellcaster_identity_shells.gd`.
- Added tiny identity shells for approved caster classes only:
  - Wizard uses INT label
  - Cleric uses WIS label
  - Warlock uses CHA label
- Added `Casters` button to the mobile Character Sheet.
- Added caster shell summary display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 3E`.

### Current Placeholder Rules
- Caster shells are data-only labels for now.
- Wizard, Cleric, and Warlock are not selectable yet.
- No spells are active yet.
- No spell slots are active yet.
- No spell attacks, spell save DCs, prepared spell lists, cantrips, pact magic, domains, or arcane recovery are active yet.
- No class features are active yet.

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
- Stage 3D Fighter level 1 shell display.
- Cleaned mobile Sheet layout.

### Not Added Yet
- No spells.
- No spell slots.
- No class features.
- No race/species traits.
- No XP system.
- No combat.
- No enemies.
- No hotbar UI.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 3D Fix — Mobile Sheet Layout Cleanup

Status: confirmed working on iPhone.

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

Status: confirmed working on iPhone after layout cleanup.

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

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. Runtime spawning is allowed later for proper systems, but only after the visible foundation remains stable and testable from iPhone.
