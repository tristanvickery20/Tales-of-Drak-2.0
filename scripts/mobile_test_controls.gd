extends CanvasLayer

const MAIN_MENU_SCENE := "res://scenes/main_menu/main_menu.tscn"

@onready var player: Node = get_node_or_null("../PlaceholderPlayer")
@onready var camera: Node = get_node_or_null("../Camera3D")
@onready var status_label: Label = get_node_or_null("Controls/StatusLabel") as Label
@onready var debug_label: Label = get_node_or_null("Controls/DebugLabel") as Label
@onready var pause_panel: Control = get_node_or_null("Controls/PausePanel") as Control
@onready var pause_button: Button = get_node_or_null("Controls/PauseButton") as Button

var _move_input := Vector2.ZERO
var _orbit_input := 0.0
var _paused := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_mobile_debug_controls_exist()
	_refresh_optional_nodes()

	_connect_button("Controls/MovePad/UpButton", Vector2(0, -1))
	_connect_button("Controls/MovePad/DownButton", Vector2(0, 1))
	_connect_button("Controls/MovePad/LeftButton", Vector2(-1, 0))
	_connect_button("Controls/MovePad/RightButton", Vector2(1, 0))
	_connect_orbit_button("Controls/CameraButtons/CameraLeftButton", -1.0)
	_connect_orbit_button("Controls/CameraButtons/CameraRightButton", 1.0)

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
	_set_status("Move, jump, interact, pause, reset, or rotate camera.")

func _process(_delta: float) -> void:
	if not _paused and player != null and player.has_method("set_move_input"):
		player.set_move_input(_move_input)

	if camera != null and camera.has_method("set_orbit_input"):
		camera.set_orbit_input(_orbit_input if not _paused else 0.0)

	if debug_label != null and player != null and player.has_method("get_debug_summary"):
		debug_label.text = str(player.get_debug_summary())

func _ensure_mobile_debug_controls_exist() -> void:
	var controls := get_node_or_null("Controls") as Control
	if controls == null:
		return

	if get_node_or_null("Controls/DebugLabel") == null:
		var new_debug_label := Label.new()
		new_debug_label.name = "DebugLabel"
		new_debug_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
		new_debug_label.offset_left = 20.0
		new_debug_label.offset_top = 96.0
		new_debug_label.offset_right = -20.0
		new_debug_label.offset_bottom = 130.0
		new_debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_debug_label.text = "Stage 1C debug ready"
		controls.add_child(new_debug_label)

	if get_node_or_null("Controls/PauseButton") == null:
		var new_pause_button := Button.new()
		new_pause_button.name = "PauseButton"
		new_pause_button.custom_minimum_size = Vector2(150, 52)
		new_pause_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
		new_pause_button.offset_left = 20.0
		new_pause_button.offset_top = 20.0
		new_pause_button.offset_right = 170.0
		new_pause_button.offset_bottom = 72.0
		new_pause_button.text = "Pause"
		controls.add_child(new_pause_button)

	var action_buttons := get_node_or_null("Controls/ActionButtons") as VBoxContainer
	if action_buttons != null and get_node_or_null("Controls/ActionButtons/ResetButton") == null:
		var reset_button := Button.new()
		reset_button.name = "ResetButton"
		reset_button.custom_minimum_size = Vector2(150, 64)
		reset_button.text = "Reset"
		action_buttons.add_child(reset_button)

	if get_node_or_null("Controls/CameraButtons") == null:
		var camera_buttons := HBoxContainer.new()
		camera_buttons.name = "CameraButtons"
		camera_buttons.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		camera_buttons.offset_left = 270.0
		camera_buttons.offset_top = -92.0
		camera_buttons.offset_right = -190.0
		camera_buttons.offset_bottom = -20.0
		camera_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
		controls.add_child(camera_buttons)

		var camera_left_button := Button.new()
		camera_left_button.name = "CameraLeftButton"
		camera_left_button.custom_minimum_size = Vector2(90, 64)
		camera_left_button.text = "Cam ←"
		camera_buttons.add_child(camera_left_button)

		var camera_right_button := Button.new()
		camera_right_button.name = "CameraRightButton"
		camera_right_button.custom_minimum_size = Vector2(90, 64)
		camera_right_button.text = "Cam →"
		camera_buttons.add_child(camera_right_button)

	if get_node_or_null("Controls/PausePanel") == null:
		var panel := Panel.new()
		panel.name = "PausePanel"
		panel.set_anchors_preset(Control.PRESET_FULL_RECT)
		panel.visible = false
		controls.add_child(panel)

		var box := VBoxContainer.new()
		box.name = "PanelBox"
		box.set_anchors_preset(Control.PRESET_CENTER)
		box.offset_left = -120.0
		box.offset_top = -90.0
		box.offset_right = 120.0
		box.offset_bottom = 90.0
		box.alignment = BoxContainer.ALIGNMENT_CENTER
		panel.add_child(box)

		var title := Label.new()
		title.name = "PauseTitle"
		title.text = "Paused"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(title)

		var resume_button := Button.new()
		resume_button.name = "ResumeButton"
		resume_button.custom_minimum_size = Vector2(220, 58)
		resume_button.text = "Resume"
		box.add_child(resume_button)

		var menu_button := Button.new()
		menu_button.name = "MenuButton"
		menu_button.custom_minimum_size = Vector2(220, 58)
		menu_button.text = "Menu"
		box.add_child(menu_button)

func _refresh_optional_nodes() -> void:
	camera = get_node_or_null("../Camera3D")
	status_label = get_node_or_null("Controls/StatusLabel") as Label
	debug_label = get_node_or_null("Controls/DebugLabel") as Label
	pause_panel = get_node_or_null("Controls/PausePanel") as Control
	pause_button = get_node_or_null("Controls/PauseButton") as Button

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

func _connect_orbit_button(path: String, direction: float) -> void:
	var button := get_node_or_null(path)
	if button == null:
		push_warning("Missing camera orbit button: " + path)
		return
	button.button_down.connect(func() -> void:
		if _paused:
			return
		_orbit_input += direction
		_orbit_input = clampf(_orbit_input, -1.0, 1.0)
	)
	button.button_up.connect(func() -> void:
		_orbit_input -= direction
		_orbit_input = clampf(_orbit_input, -1.0, 1.0)
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
	_orbit_input = 0.0
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
	_orbit_input = 0.0
	if player != null and player.has_method("set_move_input"):
		player.set_move_input(Vector2.ZERO)
	if camera != null and camera.has_method("set_orbit_input"):
		camera.set_orbit_input(0.0)
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
