# Stage 3 Handoff — Race/Species + Class Foundation

Stage 3 should begin only after Stage 2 remains stable on iPhone.

## Stage 3 Goal

Create the first tiny race/species and class foundation without breaking the existing playable loop.

## Important Restrictions

- Do not build combat yet.
- Do not build the hotbar yet.
- Do not build inventory, crafting, taming, quests, or dialogue yet.
- Do not add extra races/species beyond the approved first set.
- Do not add extra classes beyond the approved first set.
- Do not implement full class progression all at once.
- Keep data modular under `res://drak/`.
- Keep every pass iPhone-testable through GitHub Pages/Safari.
- Keep Skelerealms untouched until an adapter is intentionally added later.

## Approved First Race/Species Set

- Elf
- Variant Human
- Dwarf
- Orc

## Approved First Class Set

- Fighter
- Wizard
- Cleric
- Warlock
- Rogue
- Barbarian
- Ranger

## Recommended Stage 3 First Step

Stage 3A should add a tiny character identity shell only:

- Selected race/species ID placeholder.
- Selected class ID placeholder.
- Current level placeholder.
- Character summary display in the mobile Sheet.
- No class features yet.
- No race traits yet.
- No combat changes yet.

## Stage 3 Success Test

The iPhone build should still open, move, jump, interact, enter/exit cave, and open the Sheet. The Sheet should show a character identity shell without changing gameplay yet.
