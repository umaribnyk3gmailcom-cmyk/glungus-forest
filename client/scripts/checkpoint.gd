extends Area3D
## A checkpoint pad. Touch it to save your progress and set your respawn point.
## (In the full game this is also where the weapon / potion / skins / healing
## stations live - see the design doc.)

var _used := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _used or not body.is_in_group("player"):
		return
	_used = true

	var world_root := get_tree().current_scene
	if world_root and world_root.has_method("set_respawn"):
		world_root.set_respawn(global_position + Vector3(0, 1.5, 0))

	Quests.save_progress()
	get_tree().call_group("hud", "flash_message", "Checkpoint saved!")

	# let it be used again after a few seconds
	await get_tree().create_timer(3.0).timeout
	_used = false
