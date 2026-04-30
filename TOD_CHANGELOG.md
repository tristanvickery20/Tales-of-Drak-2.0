# Tales of Drak Change Log

This file tracks the small verified stages added to the Godot/iPhone test build.

## Stage 2O — Spellcasting Resource Shell

Status: added, awaiting iPhone test confirmation.

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

## Stage 2N — Level Progression Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_level_progression.gd`.
- Added supported level range for the current vertical-slice rules foundation: levels 1 through 5.
- Added level-based proficiency bonus helper.
- Added `Preview Level 5` button to the mobile Character Sheet.
- Added level/proficiency progression display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2N`.

### Current Placeholder Rules
- Supported level range is 1-5 only.
- Current displayed level is level 1.
- Level 1 proficiency bonus is +2.
- Level 5 preview shows proficiency bonus +3.
- No XP, leveling UI, class features, race/species features, spell progression, hit dice scaling, or ability score improvements are connected yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, action economy tracker, cooldown tracker, damage type registry, and hit dice/rest tracker.

### Not Added Yet
- No XP system.
- No class or race/species features.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No combat.
- No enemies.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2M — Hit Dice + Rest Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_rest_tracker.gd`.
- Added hit dice tracking for short-rest style testing.
- Added `Spend Hit Die` button to the mobile Character Sheet.
- Added `Long Rest` button to the mobile Character Sheet.
- Added hit dice / rest display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2M`.

### Current Placeholder Rules
- Current placeholder hit die is `d10`.
- Current placeholder max hit dice is `1`.
- `Spend Hit Die` rolls a d10, adds CON modifier, and shows preview healing.
- Preview healing does not change HP yet.
- `Long Rest` restores hit dice only in this stage.
- No damage, real healing, class hit dice, rest duration, exhaustion, spell recovery, or resource recovery is connected yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, action economy tracker, cooldown tracker, and damage type registry.

### Not Added Yet
- No HP reduction.
- No real healing.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No combat.
- No enemies.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2L — Damage Type Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_damage_types.gd`.
- Added a standard damage type registry.
- Added `Preview Fire Damage` button to the mobile Character Sheet.
- Added damage type foundation display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2L`.

### Current Placeholder Rules
- Damage types are registered but do not affect HP yet.
- `Preview Fire Damage` shows a harmless preview only.
- No enemy, combat, attack, spell, resistance, immunity, vulnerability, or HP reduction system uses this yet.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, action economy tracker, and cooldown tracker.

### Not Added Yet
- No HP reduction.
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage application system.
- No combat.
- No enemies.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2K — Cooldown Tracker Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_cooldown_tracker.gd`.
- Added a simple cooldown tracker for future real-time hotbar abilities.
- Added `Start 5s Cooldown` button to the mobile Character Sheet.
- Added `Tick Cooldown -1s` button to the mobile Character Sheet.
- Added cooldown display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2K`.

### Current Placeholder Rules
- Test Ability starts ready.
- `Start 5s Cooldown` sets Test Ability to 5.0 seconds remaining.
- `Tick Cooldown -1s` manually reduces remaining cooldown by 1 second.
- This is manual for testing only. Later gameplay can tick cooldowns automatically in real time.
- Important design note: Tales of Drak combat is not turn-based. D&D action economy is a rules backbone; player-facing combat is intended to be real-time SWTOR-style hotbar/button combat with cooldowns.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, Prone condition toggle, and action economy tracker.

### Not Added Yet
- No hotbar UI.
- No automatic real-time cooldown ticking.
- No damage system.
- No combat.
- No enemies.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2J — Action Economy Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_action_economy.gd`.
- Added action economy tracking for:
  - Action
  - Bonus Action
  - Reaction
  - Movement remaining in feet
- Added `Use Action` button to the mobile Character Sheet.
- Added `Reset Turn` button to the mobile Character Sheet.
- Added action economy display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2J`.

### Current Placeholder Rules
- A turn starts with Action, Bonus Action, Reaction, and 30 feet of movement available.
- `Use Action` spends the Action only.
- `Reset Turn` restores the turn resources.
- No hotbar, combat, enemy, damage, ability, or cooldown system uses this yet.
- Important design note: this does not mean Tales of Drak combat is turn-based. It is a D&D rules resource tracker that can later support real-time hotbar combat.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, Dexterity saving throw test, and Prone condition toggle.

### Not Added Yet
- No hotbar.
- No damage system.
- No combat.
- No enemies.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2I — Condition Tracker Foundation

Status: confirmed working on iPhone.

### Added
- Added `drak/rules/drak_condition_tracker.gd`.
- Added a tiny condition tracker foundation.
- Added `Toggle Prone` button to the mobile Character Sheet.
- Added active condition display to the Sheet.
- Updated visible HUD stage labels to `Tales of Drak — Stage 2I`.

### Current Placeholder Rules
- Only the `Prone` condition is implemented for testing.
- Prone can be toggled on/off in the Sheet.
- No mechanical effects are applied yet.
- The fuller D&D condition registry will be expanded later in smaller safe chunks.

### Preserved
- iPhone Safari/GitHub Pages test loop.
- Main menu and Start Game flow.
- Drag movement.
- Jump, Interact, Reset, Pause, Menu, Camera buttons.
- Cave entrance and exit cave transitions.
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, Passive Perception, advantage/disadvantage rolls, HP, AC, and Dexterity saving throw test.

### Not Added Yet
- No condition mechanical effects.
- No damage system.
- No combat.
- No classes or races.
- No inventory, crafting, taming, quests, or dialogue.
- No Skelerealms integration yet.

## Stage 2H — Saving Throw Foundation

Status: confirmed working on iPhone.

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
- Ability scores, modifiers, proficiency bonus, skill registry, Athletics test, and Passive Perception.

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
