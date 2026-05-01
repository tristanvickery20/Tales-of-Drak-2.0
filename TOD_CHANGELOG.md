# Tales of Drak Change Log

## Stage 4C Retry — Image-Backed Gothic Hotbar Frame

Status: added, awaiting iPhone test confirmation.

### Added
- Added `drak/ui/drak_hotbar_frame_texture.gd`.
- Embedded the cleaned gothic hotbar frame as a Godot-generated texture.
- Rebuilt `drak/ui/drak_hotbar_overlay.gd` from the confirmed Stage 4B placement baseline instead of the failed viewport-math layout.
- Added a TextureRect-based visible hotbar frame anchored near the same safe bottom area as Stage 4B.
- Added temporary text placeholders over the frame:
  - `1 Weapon`
  - `2 Class`
  - `3 Range`
  - `4 Guard`
  - `5 Heal`
  - `6 Control`
  - `7 Tame`
  - `8 Dodge`
- Added bottom action strip placeholder labels:
  - ACTION
  - BONUS
  - REACTION
  - MOVE
- Updated `drak/ui/drak_character_sheet_overlay.gd` to Stage 4C retry labels.
- Updated Sheet notes to clearly say this is an image-backed hotbar frame shell only.

### Current Placeholder Rules
- This is still a UI shell only.
- No active combat behavior is added.
- No enemies, targeting, damage, cooldown application, weapon inventory, spells, class features, crafting, taming, quests, dialogue, or Skelerealms integration are active yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Pause, Sheet, and Menu buttons.
- Drag movement.
- Jump, Interact, Reset, and Camera buttons.
- Pickups.
- Cave entrance and exit transitions.
- Stage 2 rules foundation.
- Stage 3 character/race/class foundation.

### Alignment Notes
- Skelerealms remains the later RPG/world-simulation backend.
- This hotbar UI does not edit or hack Skelerealms internals.
- The hotbar is being built as a Tales of Drak UI layer under `res://drak/` so it can later call Drak combat/rules adapters cleanly.

## Stage 4B Restore — Safe Hotbar Baseline

Status: confirmed visible on iPhone.

### Restored
- Restored the previous simple Stage 4B hotbar after the first Stage 4C attempt failed to show correctly.
- Restored Stage 4B Sheet/HUD labels before retrying the art frame.
- Confirmed the simple 8-label bottom hotbar was visible again before the retry.

## Stage 4C — Failed Coded Gothic Shell Attempt

Status: replaced by Stage 4C Retry.

### Problem
- The first Stage 4C coded shell did not appear correctly on the iPhone viewport.
- The project was restored to Stage 4B before retrying.

## Stage 4B — Visible Inactive Mobile Hotbar Shell

Status: confirmed working on iPhone.

## Stage 4A — Hotbar Foundation Plan

Status: confirmed working on iPhone.

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. When a visual upgrade fails, restore the last confirmed working baseline before retrying.
