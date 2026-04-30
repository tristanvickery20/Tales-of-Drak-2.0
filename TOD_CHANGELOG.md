# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 2H — Saving Throw Foundation

Status: added, awaiting iPhone test confirmation.

### Added
- Added `drak/rules/drak_saving_throws.gd`.
- Added saving throw names for STR, DEX, CON, INT, WIS, and CHA.
- Added `DEX Save DC 13` test button to the mobile Character Sheet.
- Added saving throw summary text to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2H`.

### Current Placeholder Rules
- Dexterity saving throw uses DEX modifier only.
- No saving throw proficiency is applied yet.
- Proficiency will be connected later through class data.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, and AC.

### Not Added Yet
- No damage system.
- No combat.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2G — HP + Armor Class Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_hit_points.gd`.
- Added `drak/rules/drak_armor_class.gd`.
- Added HP display to the mobile Character Sheet.
- Added Armor Class display to the mobile Character Sheet.
- Added `Show HP / AC` button to the mobile Character Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2G`.

### Current Placeholder Rules
- HP uses a level 1 placeholder formula: `hit die max + CON modifier`.
- Current placeholder hit die is `d10`.
- AC uses the unarmored placeholder formula: `10 + DEX modifier`.
- These are intentionally temporary until class, race, equipment, and armor systems exist.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, and advantage/disadvantage rolls.

### Not Added Yet
- No damage system.
- No combat.
- No classes or races.
- No saving throws.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2F — Advantage / Disadvantage Foundation

Status: confirmed working on iPhone.

### Added
- Added advantage and disadvantage dice support to `drak/rules/drak_dice_roller.gd`.
- Added roll modes:
  - `normal`
  - `advantage`
  - `disadvantage`
- Added two-roll display for advantage/disadvantage results, showing both d20 rolls and which value was used.
- Updated the Character Sheet overlay with Stage 2F test buttons:
  - Normal STR DC 12
  - Advantage STR DC 12
  - Disadvantage STR DC 12
  - Athletics DC 12
  - Show Passive Perception
- Updated the visible HUD stage label through the active overlay so it displays `Tales of Drak — Stage 2F` instead of the older Stage 1I text.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, and Passive Perception.

### Not Added Yet
- No combat.
- No classes or races.
- No saving throws.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. Runtime spawning is allowed later for proper systems, but only after the visible foundation remains stable and testable from iPhone.
