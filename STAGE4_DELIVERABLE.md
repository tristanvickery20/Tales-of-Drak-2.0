# Stage 4 Deliverable — Real-Time Hotbar Combat Foundation

## Stage 4 Goal

Create the first tiny real-time hotbar/combat foundation for Tales of Drak without breaking the playable iPhone test loop.

Stage 4 should not build full combat. It should establish the safe foundation for SWTOR-style button combat powered by the D&D-style rules layer from Stage 2 and the character/class shell from Stage 3.

## Required Playable Loop Preservation

The project must still:

- Open through GitHub Pages/Safari on iPhone.
- Start from the main menu.
- Load the test world.
- Move with the current mobile movement controls.
- Jump.
- Interact.
- Pick up existing test resources.
- Enter and exit the cave.
- Open and close the mobile Sheet.
- Keep Stage 2 rules foundation available.
- Keep Stage 3 character/race/class foundation available.

## Stage 4 Combat Direction

Combat is real-time button/hotbar combat, not turn-based combat.

The D&D-style rules layer should support combat resolution, but the player-facing loop should feel closer to SWTOR:

1. Target or face an enemy later.
2. Press an ability button.
3. Ability checks cooldown/action/resource availability.
4. Ability resolves through D&D-style attack/check/save logic.
5. Damage/effects apply later.
6. Ability enters cooldown.

## Stage 4A Target

Add a tiny hotbar/combat foundation shell only:

- Hotbar foundation manifest.
- Eight future ability slot labels.
- Sheet display for Stage 4 plan.
- One harmless Sheet preview button.
- No actual abilities yet.
- No enemies yet.
- No damage application yet.
- No combat state machine yet.

## Proposed Eight Hotbar Slots

These are labels only at first:

1. Weapon Attack
2. Class Feature
3. Cantrip / Ranged
4. Defensive Ability
5. Heal / Recovery
6. Control Ability
7. Tame / Pet Command
8. Dodge / Utility

## Stage 4 Later Passes

Recommended sequence:

- 4A: Hotbar/combat foundation manifest only.
- 4B: Mobile hotbar UI shell with inactive buttons.
- 4C: Targeting placeholder only.
- 4D: Weapon attack preview roll only, no damage.
- 4E: Cooldown wiring for one harmless test ability.
- 4F: Damage preview only, no enemy health changes.
- 4G: Stage 4 audit and cleanup.

## Explicitly Not In Stage 4A

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

## Exit Criteria

Stage 4 is successful when the project can show the first hotbar/combat foundation while the iPhone playable loop still works and no unrelated systems are rewritten.
