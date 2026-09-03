extends Node3D
## The playable scene (placeholder). Right now it just wires the backend in:
## it loads your save when the level starts, and saves when you press F5.

var level := 1
var world := 1
var currency := 0
var extra := {}


func _ready() -> void:
	Api.save_loaded.connect(_on_save_loaded)
	Api.save_written.connect(func(_s): print("[save] written"))
	Api.request_failed.connect(func(msg): push_warning("[api] " + msg))
	Api.load_save()


func _on_save_loaded(save) -> void:
	if save == null:
		print("[save] new player - starting fresh")
		return
	level = int(save.get("level", 1))
	world = int(save.get("world", 1))
	currency = int(save.get("currency", 0))
	extra = save.get("data", {})
	print("[save] loaded: level %d, world %d, %d currency" % [level, world, currency])


func _unhandled_input(event: InputEvent) -> void:
	# F5 = pretend we hit a checkpoint and save progress.
	if event is InputEventKey and event.pressed and event.keycode == KEY_F5:
		currency += 10
		Api.write_save(level, world, currency, extra)
		print("[save] saving... (currency now %d)" % currency)
