# Tales of Drak 2.0

Tiny Stage 0 Godot foundation for iPhone-friendly testing.

## What this is

This is only the project foundation:

- valid `project.godot`
- simple main menu
- Start Game button
- simple 3D test world
- flat ground with collision
- basic light
- placeholder player capsule
- simple camera
- GitHub Actions web preview workflow

## What this is not yet

This does not include combat, crafting, taming, quests, dialogue, character creation, D&D rules, or Skelerealms integration yet.

## iPhone testing path

Because iPhone cannot comfortably run the Godot desktop editor, the testing path is:

1. Code lives in GitHub.
2. GitHub Actions exports the Godot project to Web.
3. GitHub Pages hosts the exported build.
4. You open the GitHub Pages link in Safari on iPhone.

## First-time GitHub Pages setup

On GitHub mobile web:

1. Open this repo.
2. Tap **Settings**.
3. Tap **Pages**.
4. Under **Build and deployment**, set **Source** to **GitHub Actions**.
5. Go to **Actions**.
6. Open **Build Web Preview**.
7. Run it or wait for it to run after a push.
8. Open the Pages link when it finishes.

## What you should see

First screen: `Tales of Drak 2.0` menu with a Start Game button.

After pressing Start Game: a simple 3D test world with ground, light, camera, and a capsule placeholder player.
