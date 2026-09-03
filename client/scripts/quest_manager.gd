extends Node
## Autoload singleton ("Quests"). Tracks the player's current quest and stats,
## and pushes progress to the backend when a checkpoint is touched.

enum Quest { NONE, COLLECT_BERRIES, DONE }

const BERRIES_NEEDED := 3

var current: int = Quest.NONE
var berries := 0
var currency := 0
var level := 1
var world := 1

signal berry_count_changed(count: int)
signal quest_changed(quest: int)


func start_berry_quest() -> void:
	current = Quest.COLLECT_BERRIES
	berries = 0
	quest_changed.emit(current)
	berry_count_changed.emit(berries)


func collect_berry() -> void:
	if current != Quest.COLLECT_BERRIES:
		return
	berries += 1
	currency += 5
	berry_count_changed.emit(berries)


func complete_berry_quest() -> void:
	current = Quest.DONE
	currency += 50
	quest_changed.emit(current)


func is_world_1_complete() -> bool:
	return current == Quest.DONE


func quest_text() -> String:
	match current:
		Quest.NONE:
			return "Find Glungus"
		Quest.COLLECT_BERRIES:
			return "Glow-berries: %d / %d" % [berries, BERRIES_NEEDED]
		Quest.DONE:
			return "Head to the portal"
	return ""


## Send everything to the backend (called from a checkpoint).
func save_progress() -> void:
	if Api.is_logged_in():
		Api.write_save(level, world, currency, {"quest": current, "berries": berries})


## Restore from a backend save (called when the world loads).
func apply_save(save) -> void:
	if save == null:
		return
	level = int(save.get("level", 1))
	world = int(save.get("world", 1))
	currency = int(save.get("currency", 0))
	var data: Dictionary = save.get("data", {})
	current = int(data.get("quest", Quest.NONE))
	berries = int(data.get("berries", 0))
	quest_changed.emit(current)
	berry_count_changed.emit(berries)
