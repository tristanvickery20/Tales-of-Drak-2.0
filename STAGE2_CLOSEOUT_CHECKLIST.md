# Stage 2 Closeout Checklist

Stage 2 is the first tiny Drak D&D rules foundation.

## Confirmed Direction

- Keep Tales of Drak playable on iPhone through GitHub Pages/Safari.
- Keep the current movement, interaction, and cave transition loop working.
- Keep D&D rules under `res://drak/rules/`.
- Keep the rules modular and separate from Skelerealms internals.
- Skelerealms remains the future RPG/world-simulation backend, not something to hack directly in this stage.
- Combat is not turn-based; the D&D rules layer supports future real-time SWTOR-style hotbar combat with cooldowns.

## Stage 2 Foundations Present

- Ability scores and modifiers.
- Level range 1-5 and proficiency bonus helper.
- D20 checks.
- Skill registry and Athletics test.
- Passive Perception.
- Advantage/disadvantage.
- Placeholder HP and Armor Class.
- Saving throw foundation.
- Prone test condition.
- Action economy backbone.
- Cooldown tracker.
- Damage type registry.
- Hit dice/rest tracker.
- Spellcasting shell.
- Rules manifest/audit.

## Still Not In Stage 2

- No XP system.
- No class features.
- No race/species features.
- No combat.
- No enemies.
- No real HP damage or healing.
- No inventory.
- No crafting.
- No taming.
- No quests.
- No dialogue.
- No Skelerealms integration yet.

## Suggested Exit Criteria

Stage 2 can be considered complete when:

1. The iPhone build still opens from GitHub Pages.
2. Movement still works.
3. Interact still works.
4. Cave entrance and cave exit still work.
5. The Sheet opens and closes without blocking other mobile controls.
6. The Sheet displays the main Stage 2 rules summary.
7. The change log is updated.
8. No unrelated systems were rewritten.

## Next Major Stage

Stage 3 should begin race/species and class foundation only after Stage 2 is stable.
