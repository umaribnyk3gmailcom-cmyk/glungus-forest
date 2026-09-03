extends Node
## Autoload singleton ("Api"). Talks to the Glungus's Forest backend
## (the code in ../server, hosted on Railway).
##
## Once the server is deployed, change BASE_URL to your Railway URL, e.g.
##   const BASE_URL := "https://glungus-forest-production.up.railway.app"

const BASE_URL := "http://localhost:3000"
const _SESSION_PATH := "user://session.cfg"

## Set after a successful register/login. Sent on requests that need auth.
var token := ""
var username := ""

signal auth_succeeded(player: Dictionary)
signal save_loaded(save)              ## Dictionary, or null for a brand-new player
signal save_written(save: Dictionary)
signal leaderboard_loaded(rows: Array)
signal request_failed(message: String)


func _ready() -> void:
	_load_session()


func is_logged_in() -> bool:
	return token != ""


# --- public API -----------------------------------------------------------

func register(user: String, password: String) -> void:
	_send(HTTPClient.METHOD_POST, "/auth/register",
		{"username": user, "password": password}, _on_auth_response)


func login(user: String, password: String) -> void:
	_send(HTTPClient.METHOD_POST, "/auth/login",
		{"username": user, "password": password}, _on_auth_response)


func logout() -> void:
	token = ""
	username = ""
	_persist_session()


## Loads this player's save. Emits save_loaded (Dictionary, or null for new players).
func load_save() -> void:
	_send(HTTPClient.METHOD_GET, "/save", {}, _on_save_loaded, true)


## Overwrites this player's save. Call it at each checkpoint.
func write_save(level: int, world: int, currency: int, data: Dictionary) -> void:
	var body := {"level": level, "world": world, "currency": currency, "data": data}
	_send(HTTPClient.METHOD_PUT, "/save", body, _on_save_written, true)


## Loads the leaderboard. sort = "level" | "world" | "currency" | "bosses".
func load_leaderboard(sort: String = "level", limit: int = 25) -> void:
	var path := "/leaderboard?sort=%s&limit=%d" % [sort, limit]
	_send(HTTPClient.METHOD_GET, path, {}, _on_leaderboard_loaded)


## Tells the server the player just beat a boss.
func record_boss_kill() -> void:
	_send(HTTPClient.METHOD_POST, "/leaderboard/boss", {}, _on_ignored, true)


# --- internals ------------------------------------------------------------

func _send(method: int, path: String, body: Dictionary, callback: Callable, auth := false) -> void:
	var http := HTTPRequest.new()
	add_child(http)

	var on_done := func(result, code, _headers, response_body):
		http.queue_free()
		_handle_response(result, code, response_body, callback)
	http.request_completed.connect(on_done)

	var headers := PackedStringArray(["Content-Type: application/json"])
	if auth and token != "":
		headers.append("Authorization: Bearer " + token)

	var payload := "" if body.is_empty() else JSON.stringify(body)
	var err := http.request(BASE_URL + path, headers, method, payload)
	if err != OK:
		http.queue_free()
		request_failed.emit("Could not reach the server. Is it running?")


func _handle_response(result: int, code: int, response_body: PackedByteArray, callback: Callable) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		request_failed.emit("Network error - could not reach the server.")
		return

	var parsed = JSON.parse_string(response_body.get_string_from_utf8())

	if code >= 400:
		var message := "Request failed (%d)" % code
		if parsed is Dictionary and parsed.has("error"):
			message = str(parsed["error"])
		request_failed.emit(message)
		return

	callback.call(parsed)


# --- response callbacks --------------------------------------------------

func _on_auth_response(data) -> void:
	if data is Dictionary and data.has("token"):
		token = str(data["token"])
		var player: Dictionary = data.get("player", {})
		username = str(player.get("username", ""))
		_persist_session()
		auth_succeeded.emit(player)
	else:
		request_failed.emit("Unexpected response from server.")


func _on_save_loaded(data) -> void:
	save_loaded.emit(data)


func _on_save_written(data) -> void:
	save_written.emit(data if data is Dictionary else {})


func _on_leaderboard_loaded(rows) -> void:
	leaderboard_loaded.emit(rows if rows is Array else [])


func _on_ignored(_data) -> void:
	pass


# --- session persistence -----------------------------------------------

func _load_session() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(_SESSION_PATH) == OK:
		token = cfg.get_value("session", "token", "")
		username = cfg.get_value("session", "username", "")


func _persist_session() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("session", "token", token)
	cfg.set_value("session", "username", username)
	cfg.save(_SESSION_PATH)
