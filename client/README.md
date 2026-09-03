# Glungus's Forest - Client

The game itself. Built in **Godot 4** (GDScript).

## Opening it

1. Install [Godot 4](https://godotengine.org/download) (the standard build, not .NET).
2. Open Godot, click **Import**, and pick this `client/` folder (`project.godot`).
3. Press **F5** to run. You'll get the sign-in screen.

To sign in you need the backend running - see the [root README](../README.md#running-the-server-locally).
With no server, the buttons will just show a "could not reach the server" message.

## What's here so far

| File | What it is |
|---|---|
| `scripts/api.gd` | Autoload singleton `Api`. All backend calls live here. |
| `scenes/main_menu.tscn` + `scripts/main_menu.gd` | Sign-in screen (register / log in). |
| `scenes/game.tscn` + `scripts/game.gd` | Placeholder level. Loads your save on start; press **F5** in-game to fake a checkpoint save. |
| `scenes/player.tscn` + `scripts/player.gd` | 3rd-person capsule you can walk around. Arrow keys + Space + mouse. |

## Using the backend from anywhere in the game

`Api` is a global. Examples:

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

**After deploying to Railway**, change `BASE_URL` at the top of `scripts/api.gd`
to your Railway URL.

## Shared data

World and item definitions live in `../shared/` (`worlds.json`, `items.json`).
Load them at runtime so the client and server never disagree:

```gdscript
var worlds := JSON.parse_string(FileAccess.get_file_as_string("res://../shared/worlds.json"))
```

(or copy those files into `client/` and load with a normal `res://` path.)

## Next steps

- Replace the capsule with a real character model.
- Build world 1 (Glungus's Forest) as its own scene, with a portal at the end.
- Add a Glungus NPC that hands out the starter quests.
- Add a checkpoint object (weapon / potion / skins / healing stations).
- Multiplayer comes later - get single-player fun first (see design doc section 6).
