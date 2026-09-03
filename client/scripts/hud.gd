extends CanvasLayer
## In-world UI: quest tracker, currency, interaction prompt, dialogue, flash messages.
## Other nodes talk to it via the "hud" group, e.g.
##   get_tree().call_group("hud", "flash_message", "Saved!")

@onready var quest_label: Label = %QuestLabel
@onready var currency_label: Label = %CurrencyLabel
@onready var prompt: Label = %Prompt
@onready var dialogue_panel: PanelContainer = %DialoguePanel
@onready var dialogue_label: Label = %DialogueLabel
@onready var flash: Label = %Flash


func _ready() -> void:
	add_to_group("hud")
	prompt.hide()
	dialogue_panel.hide()
	flash.modulate.a = 0.0
	Quests.quest_changed.connect(_on_state_changed)
	Quests.berry_count_changed.connect(_on_state_changed)
	_refresh()


func _on_state_changed(_v: int) -> void:
	_refresh()


func _refresh() -> void:
	quest_label.text = "Quest: " + Quests.quest_text()
	currency_label.text = "%d c" % Quests.currency


func show_prompt(text: String) -> void:
	prompt.text = text
	prompt.show()


func hide_prompt() -> void:
	prompt.hide()


func show_dialogue(line: String) -> void:
	dialogue_label.text = line
	dialogue_panel.show()
	_refresh()


func flash_message(text: String) -> void:
	flash.text = text
	flash.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_interval(1.2)
	tween.tween_property(flash, "modulate:a", 0.0, 0.6)
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if not dialogue_panel.visible:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode in [KEY_E, KEY_ESCAPE, KEY_ENTER, KEY_SPACE]:
			dialogue_panel.hide()
