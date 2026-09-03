extends Area3D
## A glow-berry. Walk into it to pick it up.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	rotate_y(delta * 1.5)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Quests.collect_berry()
		get_tree().call_group("hud", "flash_message", "Glow-berry! (%d/%d)" % [Quests.berries, Quests.BERRIES_NEEDED])
		queue_free()
