extends Area3D
## Glungus, king of worlds 1-66. Walk up and press E to talk.
## He hands out the starter quest, then gets snatched at the end (design doc, Act 1).

var _player_near := false
var _stage := 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	$Body.rotate_y(delta * 0.6)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_near = true
		get_tree().call_group("hud", "show_prompt", "Press E to talk to Glungus")


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_near = false
		get_tree().call_group("hud", "hide_prompt")


func _unhandled_input(event: InputEvent) -> void:
	if not _player_near:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_talk()


func _talk() -> void:
	var line := ""

	match _stage:
		0:
			line = "Glungus: Welcome, newcomer! You're in world 1 of 66 - my forest."
			_stage = 1
		1:
			if Quests.current == Quests.Quest.NONE:
				Quests.start_berry_quest()
				line = "Glungus: Prove yourself. Bring me %d glow-berries from the trees." % Quests.BERRIES_NEEDED
			elif Quests.berries >= Quests.BERRIES_NEEDED:
				Quests.complete_berry_quest()
				line = "Glungus: All %d! The portal ahead is open. Go on th-" % Quests.BERRIES_NEEDED
				_stage = 2
			else:
				line = "Glungus: %d of %d glow-berries so far. Keep looking." % [Quests.berries, Quests.BERRIES_NEEDED]
		2:
			line = "A shadow falls over the forest. When it passes, Glungus is gone."
			_stage = 3
			var tween := create_tween()
			tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.5)
			tween.tween_callback(queue_free)
			get_tree().call_group("hud", "hide_prompt")
		_:
			line = "..."

	get_tree().call_group("hud", "show_dialogue", line)
