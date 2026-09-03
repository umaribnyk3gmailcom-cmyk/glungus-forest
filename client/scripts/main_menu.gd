extends Control
## The sign-in screen. First scene the game loads.

@onready var username_field: LineEdit = %Username
@onready var password_field: LineEdit = %Password
@onready var status_label: Label = %Status


func _ready() -> void:
	Api.auth_succeeded.connect(_on_auth_succeeded)
	Api.request_failed.connect(_on_request_failed)

	# If we still have a saved session from last time, skip straight in.
	if Api.is_logged_in():
		status_label.text = "Welcome back, %s!" % Api.username


func _on_login_pressed() -> void:
	status_label.text = "Logging in..."
	Api.login(username_field.text.strip_edges(), password_field.text)


func _on_register_pressed() -> void:
	status_label.text = "Creating account..."
	Api.register(username_field.text.strip_edges(), password_field.text)


func _on_auth_succeeded(_player: Dictionary) -> void:
	status_label.text = "Welcome, %s!" % Api.username
	get_tree().change_scene_to_file("res://scenes/world_1.tscn")


func _on_request_failed(message: String) -> void:
	status_label.text = message + "  (or press Play offline)"


func _on_play_offline_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world_1.tscn")
