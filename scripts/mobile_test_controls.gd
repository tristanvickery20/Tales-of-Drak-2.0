extends CanvasLayer

const MAIN_MENU_SCENE := "res://scenes/main_menu/main_menu.tscn"

@onready var player: Node = get_node_or_null("../PlaceholderPlayer")
@onready var status_label: Label = get_node_or_null("Controls/StatusLabel") as Label
@onready var debug_label: Label = get_node_or_null("Controls/DebugLabel") as Label
@onready var pause_panel: Control = get_node_or_null("Controls/PausePanel") as Control
@onready var pause_button: Button = get_node_or_null("Controls/PauseButton") as Button

var _move_input := Vector2.ZERO
var _paused := false

func _ready() -> void:
	_connect_button("Controls/MovePad/UpButton", Vector2(0, -1))
	_connect_button("Controls/MovePad/DownButton", Vector2(0, 1))
	_connect_button("Controls/MovePad/LeftButton", Vector2(-1, 0))
	_connect_button("Controls/MovePad/RightButton", Vector2(1, 0))

	var jump_button := get_node_or_null("Controls/ActionButtons/JumpButton")
	if jump_button != null:
		jump_button.pressed.connect(_on_jump_pressed)

	var interact_button := get_node_or_null("Controls/ActionButtons/InteractButton")
	if interact_button != null:
		interact_button.pressed.connect(_on_interact_pressed)

	var reset_button := get_node_or_null("Controls/ActionButtons/ResetButton")
	if reset_button != null:
		reset_button.pressed.connect(_on_reset_pressed)

	var back_button := get_node_or_null("Controls/BackToMenuButton")
	if back_button != null:
		back_button.pressed.connect(_on_back_to_menu_pressed)

	if pause_button != null:
		pause_button.pressed.connect(_on_pause_pressed)

	var resume_button := get_node_or_null("Controls/PausePanel/PanelBox/ResumeButton")
	if resume_button != null:
		resume_button.pressed.connect(_on_resume_pressed)

	var pause_menu_button := get_node_or_null("Controls/PausePanel/PanelBox/MenuButton")
	if pause_menu_button != null:
		pause_menu_button.pressed.connect(_on_back_to_menu_pressed)

	_set_paused(false)
	_set_status("Move, jump, interact, pause, or reset.")

func _process(_delta: float) -> void:
	if not _paused and player != null and player.has_method("set_move_input"):
		player.set_move_input(_move_input)

	if debug_label != null and player != null and player.has_method("get_debug_summary"):
		debug_label.text = str(player.get_debug_summary())

func _connect_button(path: String, direction: Vector2) -> void:
	var button := get_node_or_null(path)
	if button == null:
		push_warning("Missing mobile test button: " + path)
		return
	button.button_down.connect(func() -> void:
		if _paused:
			return
		_move_input += direction
		_clamp_move_input()
	)
	button.button_up.connect(func() -> void:
		_move_input -= direction
		_clamp_move_input()
	)

func _clamp_move_input() -> void:
	_move_input.x = clampf(_move_input.x, -1.0, 1.0)
	_move_input.y = clampf(_move_input.y, -1.0, 1.0)

func _on_jump_pressed() -> void:
	if _paused:
		return
	if player != null and player.has_method("request_jump"):
		player.request_jump()
		_set_status("Jump")

func _on_interact_pressed() -> void:
	if _paused:
		return
	if player != null and player.has_method("try_interact"):
		_set_status(str(player.try_interact()))
	else:
		_set_status("Interact is not ready.")

func _on_reset_pressed() -> void:
	if player != null and player.has_method("reset_to_spawn"):
		player.reset_to_spawn()
	_move_input = Vector2.ZERO
	_set_status("Player reset to spawn.")

func _on_pause_pressed() -> void:
	_set_paused(true)

func _on_resume_pressed() -> void:
	_set_paused(false)

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _set_paused(value: bool) -> void:
	_paused = value
	get_tree().paused = value
	process_mode = Node.PROCESS_MODE_ALWAYS
	_move_input = Vector2.ZERO
	if player != null and player.has_method("set_move_input"):
		player.set_move_input(Vector2.ZERO)
	if pause_panel != null:
		pause_panel.visible = value
	if pause_button != null:
		pause_button.visible = not value
	if value:
		_set_status("Paused")
	else:
		_set_status("Resumed")

func _set_status(message: String) -> void:
	if status_label != null:
		status_label.text = message
