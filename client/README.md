# Glungus's Forest - Client

The game itself. Built in **Godot 4** (GDScript).

## Opening it

1. Install [Godot 4](https://godotengine.org/download) (standard build, 4.2 or newer, not .NET).
2. Open Godot, click **Import**, and pick this `client/` folder (`project.godot`).
   If it offers to convert the project to your version, say yes.
3. Press **F5** to run. You get the sign-in screen.
   - With the server running, register a name + password to play.
   - Without a server, click **Play offline** (progress won't save).

## How to play the test level (World 1)

- **Arrow keys** move, **Space** jumps, **mouse** looks, **Esc** frees the cursor.
- Walk up to **Glungus** (the blue creature) and press **E** to talk. He gives you
  a quest: collect **3 glow-berries** (the glowing dots near the trees).
- Walk into berries to pick them up.
- Step on the **blue pad** to save your progress (checkpoint).
- Talk to Glungus again once you have all 3. He opens the **portal**... and then
  gets snatched (that's the Act 1 hook from the design doc).
- Walk into the portal.

## What's here

| Files | What it is |
|---|---|
| `scripts/api.gd` | Autoload `Api`. Every backend call lives here. |
| `scripts/quest_manager.gd` | Autoload `Quests`. Tracks the current quest, berries, currency; pushes saves to the backend. |
| `scenes/main_menu.tscn` + `scripts/main_menu.gd` | Sign-in screen. |
| `scenes/world_1.tscn` + `scripts/world_1.gd` | **World 1 - Glungus's Forest.** The playable level. |
| `scenes/player.tscn` + `scripts/player.gd` | 3rd-person character controller. |
| `scenes/glungus.tscn` + `scripts/glungus.gd` | Glungus NPC - gives the starter quest, then vanishes. |
| `scenes/hud.tscn` + `scripts/hud.gd` | Quest tracker, currency, prompts, dialogue box. |
| `scenes/props/berry.tscn` + `scripts/berry.gd` | Collectible glow-berry. |
| `scenes/props/checkpoint.tscn` + `scripts/checkpoint.gd` | Save point. |
| `scenes/props/portal.tscn` + `scripts/portal.gd` | End-of-world portal (sealed until the quest is done). |
| `scenes/props/tree.tscn` | A tree. |

## Using the backend from anywhere in the game

`Api` and `Quests` are globals. Examples:

```gdscript
Api.login("player1", "hunter2")
Api.auth_succeeded.connect(func(player): print("logged in as ", player.username))

Api.load_save()
Api.save_loaded.connect(func(save): print(save))   # save is null for new players

Api.write_save(level, world, currency, {"skin": "gold", "pets": ["forest_cat"]})

Api.load_leaderboard("level")
Api.leaderboard_loaded.connect(func(rows): print(rows))

Api.record_boss_kill()
```

**After deploying the server** (see [../docs/DEPLOY.md](../docs/DEPLOY.md)), change
`BASE_URL` at the top of `scripts/api.gd` to your Railway URL.

## Next steps

- Replace the capsules with real character models.
- Give World 1 real terrain and a path instead of a flat box.
- Add enemies that scale with level (Blox Fruits style).
- Build the checkpoint's weapon / potion / skins / healing stations.
- Build World 2, set the portal's `target_scene` to it.
- Multiplayer comes later - get single-player fun first (design doc section 6).
