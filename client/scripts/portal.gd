extends Area3D
## The portal at the end of the world. Sealed until world 1's quest is done.

## Set this in the Inspector to the next world's scene, e.g.
## "res://scenes/world_2.tscn". Leave empty until that scene exists.
@export_file("*.tscn") var target_scene := ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	$Frame/Ring.rotate_y(delta * 2.0)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	if not Quests.is_world_1_complete():
		get_tree().call_group("hud", "flash_message", "The portal is sealed. Help Glungus first.")
		return

	if target_scene == "":
		get_tree().call_group("hud", "flash_message", "World 2 isn't built yet - nice work though!")
		return

	get_tree().call_group("hud", "flash_message", "Entering the next world...")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(target_scene)
