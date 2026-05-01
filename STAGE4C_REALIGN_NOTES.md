# Stage 4C Realignment Notes

The visible iPhone build is currently controlled by `scripts/mobile_test_controls.gd`.

The prior hotbar attempts edited autoload overlay files, but the active visible scene controls are created by the MobileTestControls node and its script.

Next safe fix:
- Patch `scripts/mobile_test_controls.gd` directly.
- Do not rely on UI autoloads for the hotbar shell.
- Keep movement, jump, interact, reset, pause, menu, pickups, and cave transition intact.
