# Tales of Drak Change Log

## Stage 4C Safe Realignment Patch

Status: pushed, awaiting iPhone/GitHub Pages confirmation.

### Real Cause Found
- The visible iPhone UI is created by `scripts/mobile_test_controls.gd`.
- Earlier Stage 4C attempts were too focused on separate UI autoloads.
- The live visible screen staying on Stage 1I proved the build was still showing the scene's built-in mobile controls.
- The correct strategy is to keep the visible scene UI stable and use a tiny safe overlay only as a test layer until the hotbar can be integrated directly.

### Changed
- `drak/ui/drak_hotbar_overlay.gd` was reduced to a harmless no-op autoload so it cannot crash or duplicate UI during realignment.
- `drak/ui/drak_character_sheet_overlay.gd` was replaced with a small safe Stage 4C overlay.

### Added Back Safely
- Stage 4C title/status label override.
- A visible bottom hotbar shell.
- A Sheet button and simple Sheet panel.

### Preserved
- Movement.
- Drag joystick.
- Jump.
- Interact.
- Reset.
- Pause/Menu.
- Pickups.
- Cave transitions.
- Stage 2 rules foundation.
- Stage 3 character/race/class foundation.

### Still Not Added
- No real enemies.
- No real damage.
- No targeting.
- No cooldown execution.
- No inventory/equipment.
- No spell attacks or spell saves.
- No real class features or race traits.
- No crafting.
- No taming.
- No quests or dialogue.
- No Skelerealms integration yet.

### Alignment Notes
- Skelerealms remains the later RPG/world-simulation backend.
- The hotbar is a Tales of Drak UI layer only.
- No Skelerealms internals were edited.

## Stage 4C Retry — Image-Backed Gothic Hotbar Frame

Status: superseded by Stage 4C Safe Realignment Patch.

### Added
- Added `drak/ui/drak_hotbar_frame_texture.gd`.
- Embedded the cleaned gothic hotbar frame as a Godot-generated texture.
- Rebuilt `drak/ui/drak_hotbar_overlay.gd` from the confirmed Stage 4B placement baseline instead of the failed viewport-math layout.
- Added temporary text placeholders over the frame.

### Problem
- The image-backed approach did not reliably appear in the iPhone Safari build.
- The project was realigned to a smaller safe overlay approach.

## Stage 4B Restore — Safe Hotbar Baseline

Status: confirmed visible on iPhone.

### Restored
- Restored the previous simple Stage 4B hotbar after the first Stage 4C attempt failed to show correctly.
- Restored Stage 4B Sheet/HUD labels before retrying the art frame.
- Confirmed the simple 8-label bottom hotbar was visible again before the retry.

## Stage 4C — Failed Coded Gothic Shell Attempt

Status: replaced.

### Problem
- The first Stage 4C coded shell did not appear correctly on the iPhone viewport.
- The project was restored to Stage 4B before retrying.

## Stage 4B — Visible Inactive Mobile Hotbar Shell

Status: confirmed working on iPhone.

## Stage 4A — Hotbar Foundation Plan

Status: confirmed working on iPhone.

## Build Rule Going Forward

Visible foundation objects should stay directly visible and testable in the scene whenever possible. When a visual upgrade fails, restore the last confirmed working baseline before retrying.
