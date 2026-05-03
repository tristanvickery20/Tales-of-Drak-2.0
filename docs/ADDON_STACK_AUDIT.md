# Tales of Drak 2.0 - Addon Stack Audit

Audit date: 2026-05-02
Repository: `tristanvickery20/Tales-of-Drak-2.0`

## Scope

This audit inspected the current Godot project for addon readiness only.

No addons were installed. No gameplay systems were rewritten. No files were deleted. No folders were reorganized.

## Current Project State

`project.godot` exists.

Observed project settings:

- Project name: `Tales of Drak 2.0`
- Main scene: `res://scenes/main_menu/main_menu.tscn`
- Godot feature tag: `4.3`
- Rendering: `gl_compatibility`
- Autoloads:
  - `DrakCharacterSheetOverlay` at `res://drak/ui/drak_character_sheet_overlay.gd`
  - `DrakHotbarOverlay` at `res://drak/ui/drak_hotbar_overlay.gd`

The project currently appears to be a small playable foundation, not a full RPG stack.

Confirmed current pieces:

- `res://scenes/main_menu/main_menu.tscn`
- `res://scripts/main_menu.gd`
- `res://scenes/test_world/test_world.tscn`
- `res://scripts/mobile_test_player.gd`
- `res://scripts/follow_camera.gd`
- `res://scripts/mobile_test_controls.gd`
- `res://scripts/test_resource_pickup.gd`
- `res://drak/ui/drak_character_sheet_overlay.gd`
- `res://drak/ui/drak_hotbar_overlay.gd`

The test project has a main menu, a test world, flat ground, placeholder capsule player, simple follow camera, mobile controls, basic interact/pickup behavior, and Drak UI overlay scripts.

It does not yet appear to contain production combat, crafting, taming, quests, dialogue, character creation, D&D-style rules, or Skelerealms integration.

## Existing Addons Found

No installed addons were confirmed in the repository.

Checked expected addon paths:

- `res://addons/skelerealms/plugin.cfg` - not found
- `res://addons/phantom_camera/plugin.cfg` - not found
- `res://addons/dialogue_manager/plugin.cfg` - not found
- `res://addons/quest_system/plugin.cfg` - not found

No enabled addon list was found in `project.godot`.

## Skelerealms Status

Skelerealms does not appear to be installed in the repository at `res://addons/skelerealms/`.

A Skelerealms addon zip exists as an external/uploaded reference, but that is not the same as being installed in this Godot project.

Skelerealms does not appear enabled in `project.godot`.

Safe rule: do not treat Skelerealms as installed until the folder exists inside `res://addons/` and the project is verified afterward.

## Godot Version / Compatibility Notes

The project appears to target Godot 4.3.

This matters because some current addon releases target Godot 4.4+ or newer.

Before installing any addon, confirm the exact addon version supports Godot 4.3 or explicitly upgrade the project in a separate task.

Important notes:

- Phantom Camera is still the safest first addon, but confirm the version supports Godot 4.3 before installing.
- Dialogue Manager 3 should be used instead of newer major versions if the newer version requires a later Godot release.
- QuestSystem 2 should not be installed yet unless the project is upgraded or compatibility is confirmed.
- Terrain3D should wait until the base project and addon workflow are stable.
- LimboAI should wait until Skelerealms AI limits are understood.

## Existing Scenes / Scripts

### Player

Current player is a placeholder:

- Node: `PlaceholderPlayer`
- Type: `CharacterBody3D`
- Script: `res://scripts/mobile_test_player.gd`

Do not replace this during addon installation.

### Camera

Current camera is simple and custom:

- Node: `Camera3D`
- Script: `res://scripts/follow_camera.gd`

Phantom Camera should be tested beside this camera first. Do not delete the current camera script during installation.

### UI

Current UI includes:

- Mobile HUD/control layer in `res://scripts/mobile_test_controls.gd`
- Drak overlay autoloads under `res://drak/ui/`

The current hotbar overlay is visual only. Do not let addon UI replace it yet.

### Inventory

No production inventory was confirmed.

The placeholder player has Wood/Stone pickup counters only. This is not a final inventory system.

Preferred future direction: use Skelerealms inventory/save/entity systems as the backend if integration succeeds.

### World / Test Scene

Current smoke-test scene:

- `res://scenes/test_world/test_world.tscn`

Every addon step should preserve the ability to open the main menu, press Start Game, enter the test world, move, use the camera, interact, and see the overlay.

### `res://drak/`

`res://drak/` already exists at least for UI overlay scripts.

Next Drak folders should be added gradually, especially `res://drak/adapters/`.

## Recommended Addon Install Order

1. Phantom Camera
2. Dialogue Manager 3
3. QuestSystem 2 only if compatible with the Godot version
4. Free low-poly placeholder assets
5. Terrain3D later
6. LimboAI only if needed later

## Safest First Addon

Safest first addon: Phantom Camera.

Reason: it has the smallest blast radius. It improves third-person camera infrastructure without touching inventory, save/load, quests, dialogue, combat, crafting, or taming.

Safe approach:

1. Install Phantom Camera into `res://addons/phantom_camera/`.
2. Enable it only after confirming compatibility.
3. Do not remove `res://scripts/follow_camera.gd`.
4. Create a small camera adapter/test.
5. Verify the main menu and test world still load.

## Addons To Avoid For Now

Avoid installing these right now:

- QuestSystem 2 unless Godot 4.4+ compatibility is solved.
- Terrain3D.
- LimboAI.
- Any full inventory addon that competes with Skelerealms inventory.
- Any crafting addon that requires a separate inventory backend.
- Any full character creator/morph system.
- Any large asset pack.
- Any paid addon or paid asset.
- Any addon that requires reorganizing the project.

## Proposed Folder Structure

```text
res://docs/
  ADDON_STACK_AUDIT.md
  ADDON_INSTALL_LOG.md
  INTEGRATION_DECISIONS.md

res://addons/
  skelerealms/
  phantom_camera/
  dialogue_manager/
  quest_system/

res://drak/
  core/
  rules/
  combat/
  crafting/
  taming/
  character_creator/
  progression/
  ui/
  data/
  adapters/
    skelerealms/
    camera/
    dialogue/
    quests/

res://content/
  races/
  classes/
  backgrounds/
  abilities/
  spells/
  recipes/
  crafting_disciplines/
  creature_defs/
  factions/
  quests/
  dialogue/
  lore/

res://worlds/
  village_test/
  wilds_test/
  cave_test/

res://entities/
  player/
  npcs/
  creatures/
  items/
  resources/

res://assets/
  third_party/
  drak_original/
  ui/
  icons/
  characters/
  environments/
```

## Files/Folders To Create Before Addon Integration Begins

Before installing the first addon, create or confirm:

1. `res://addons/`
2. `res://docs/ADDON_INSTALL_LOG.md`
3. `res://docs/INTEGRATION_DECISIONS.md`
4. `res://drak/adapters/`
5. `res://drak/adapters/skelerealms/`
6. `res://drak/adapters/camera/`
7. `res://drak/adapters/dialogue/`
8. `res://drak/adapters/quests/`
9. `res://content/`
10. A small smoke-test checklist

Do not create all gameplay systems at once. Folder scaffolding should be separate from addon installation.

## Risk Notes

- The project targets Godot 4.3, while some current addon versions may require 4.4+ or newer.
- Skelerealms should be treated as the RPG/world-simulation spine, not the whole game.
- Do not create two competing inventory/save systems.
- Do not overwrite the current Drak hotbar overlay.
- Do not replace the placeholder player/camera during addon installation.
- Track every addon by source, version, license, Godot compatibility, install date, and rollback plan.

## Next Prompt Recommendation

```text
TALES OF DRAK ALIGNMENT SOURCE

Tales of Drak is a Godot third-person fantasy survival/RPG vertical-slice project.
Keep every task small, modular, and playable.
Do not delete, rewrite, or reorganize working systems unless explicitly required.
Use Skelerealms as the RPG/world-simulation spine where useful, but keep Drak-specific systems under res://drak/.

TASK:
Prepare the project for safe addon installation, but do not install any addon yet.

Create only documentation/scaffold folders needed for addon integration:
- res://addons/
- res://drak/adapters/skelerealms/
- res://drak/adapters/camera/
- res://drak/adapters/dialogue/
- res://drak/adapters/quests/
- res://content/dialogue/
- res://content/quests/
- res://content/factions/
- res://content/lore/

Create exactly two docs:
- res://docs/ADDON_INSTALL_LOG.md
- res://docs/INTEGRATION_DECISIONS.md

Do not install Phantom Camera yet.
Do not install Skelerealms yet.
Do not modify player, camera, UI, test world, or gameplay scripts.

When finished, report:
1. Folders created
2. Files created
3. Files changed
4. Confirmation no gameplay was rewritten
5. Suggested commit message
```

## Suggested Commit Message

`docs: add addon stack readiness audit`
