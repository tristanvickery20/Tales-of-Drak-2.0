# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 2F — Advantage / Disadvantage Foundation

Status: added, awaiting iPhone test confirmation.

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
