extends Node3D
## World 1 - Glungus's Forest.
## Loads the player's save on start, and handles falling off the map.

@onready var player: CharacterBody3D = $Player

var _respawn := Vector3.ZERO


func _ready() -> void:
	_respawn = player.global_position
	Api.save_loaded.connect(_on_save_loaded)
	Api.request_failed.connect(func(msg): push_warning("[api] " + msg))
	if Api.is_logged_in():
		Api.load_save()
	else:
		get_tree().call_group("hud", "flash_message", "Playing offline - progress won't save.")


func _on_save_loaded(save) -> void:
	Quests.apply_save(save)
	if save != null:
		get_tree().call_group("hud", "flash_message", "Welcome back, %s." % Api.username)


func set_respawn(pos: Vector3) -> void:
	_respawn = pos


func _physics_process(_delta: float) -> void:
	if player.global_position.y < -10.0:
		player.velocity = Vector3.ZERO
		player.global_position = _respawn
