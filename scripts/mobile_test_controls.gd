extends CanvasLayer

const MAIN_MENU_SCENE := "res://scenes/main_menu/main_menu.tscn"
const TEST_WORLD_SCENE := "res://scenes/test_world/test_world.tscn"
const STAGE_1D_ZONE_SCRIPT := preload("res://scripts/test_zone_layout.gd")

@export var spawn_outdoor_test_zone := true
@export var stage_label := "Stage 1I: drag movement + cleaner mobile HUD."

@onready var player: Node = get_node_or_null("../PlaceholderPlayer")
@onready var camera: Node = get_node_or_null("../Camera3D")
@onready var status_label: Label = get_node_or_null("Controls/StatusLabel") as Label
@onready var debug_label: Label = get_node_or_null("Controls/DebugLabel") as Label
@onready var pause_panel: Control = get_node_or_null("Controls/PausePanel") as Control
@onready var pause_button: Button = get_node_or_null("Controls/PauseButton") as Button
@onready var joystick_area: Control = get_node_or_null("Controls/JoystickArea") as Control
@onready var joystick_knob: ColorRect = get_node_or_null("Controls/JoystickArea/JoystickKnob") as ColorRect

var _move_input := Vector2.ZERO
var _orbit_input := 0.0
var _paused := false
var _joystick_active := false
var _joystick_touch_id := -1
var _joystick_origin := Vector2.ZERO
var _joystick_radius := 72.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if spawn_outdoor_test_zone:
		_ensure_stage_1d_zone_exists()
	_ensure_mobile_debug_controls_exist()
	_refresh_optional_nodes()
	_connect_input_buttons()
	_set_paused(false)
	_set_status(stage_label)

func _input(event: InputEvent) -> void:
	_handle_drag_movement(event)

func _process(_delta: float) -> void:
	if not _paused and player != null and player.has_method("set_move_input"):
		player.set_move_input(_move_input)

	if camera != null and camera.has_method("set_orbit_input"):
		camera.set_orbit_input(_orbit_input if not _paused else 0.0)

	if debug_label != null and player != null and player.has_method("get_debug_summary"):
		debug_label.text = str(player.get_debug_summary()).replace("Stage 1E", "Stage 1I").replace("Stage 1F", "Stage 1I").replace("Stage 1G", "Stage 1I").replace("Stage 1H", "Stage 1I")

func _connect_input_buttons() -> void:
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

func _handle_drag_movement(event: InputEvent) -> void:
	if _paused or joystick_area == null:
		return

	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _point_inside_control(touch.position, joystick_area) and _joystick_touch_id == -1:
			_joystick_active = true
			_joystick_touch_id = touch.index
			_joystick_origin = _get_control_center(joystick_area)
			_update_joystick(touch.position)
		elif not touch.pressed and touch.index == _joystick_touch_id:
			_clear_joystick()

	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if _joystick_active and drag.index == _joystick_touch_id:
			_update_joystick(drag.position)

	elif event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index == MOUSE_BUTTON_LEFT:
			if mouse_button.pressed and _point_inside_control(mouse_button.position, joystick_area):
				_joystick_active = true
				_joystick_touch_id = 999
				_joystick_origin = _get_control_center(joystick_area)
				_update_joystick(mouse_button.position)
			elif not mouse_button.pressed and _joystick_touch_id == 999:
				_clear_joystick()

	elif event is InputEventMouseMotion:
		var mouse_motion := event as InputEventMouseMotion
		if _joystick_active and _joystick_touch_id == 999:
			_update_joystick(mouse_motion.position)

func _update_joystick(pointer_position: Vector2) -> void:
	var delta := pointer_position - _joystick_origin
	if delta.length() > _joystick_radius:
		delta = delta.normalized() * _joystick_radius

	_move_input = Vector2(delta.x / _joystick_radius, delta.y / _joystick_radius)
	_clamp_move_input()

	if joystick_knob != null:
		joystick_knob.position = Vector2(70, 70) + delta

func _clear_joystick() -> void:
	_joystick_active = false
	_joystick_touch_id = -1
	_move_input = Vector2.ZERO
	if joystick_knob != null:
		joystick_knob.position = Vector2(70, 70)

func _point_inside_control(point: Vector2, control: Control) -> bool:
	var rect := Rect2(control.global_position, control.size)
	return rect.has_point(point)

func _get_control_center(control: Control) -> Vector2:
	return control.global_position + (control.size * 0.5)

func _ensure_stage_1d_zone_exists() -> void:
	var world := get_parent() as Node3D
	if world == null:
		return
	if world.get_node_or_null("Stage1DZoneController") != null:
		return
	var zone_controller := Node3D.new()
	zone_controller.name = "Stage1DZoneController"
	zone_controller.set_script(STAGE_1D_ZONE_SCRIPT)
	world.add_child(zone_controller)

func _ensure_mobile_debug_controls_exist() -> void:
	var controls := get_node_or_null("Controls") as Control
	if controls == null:
		return

	_update_top_labels(controls)
	_ensure_pause_button(controls)
	_ensure_drag_joystick(controls)
	_ensure_action_buttons()
	_ensure_camera_buttons(controls)
	_ensure_pause_panel(controls)
	_hide_old_arrow_buttons()

func _update_top_labels(_controls: Control) -> void:
	var instruction := get_node_or_null("Controls/InstructionLabel") as Label
	if instruction != null:
		instruction.text = "Tales of Drak — Stage 1I"
		instruction.offset_top = 12.0
		instruction.offset_bottom = 44.0

	var status := get_node_or_null("Controls/StatusLabel") as Label
	if status != null:
		status.offset_top = 44.0
		status.offset_bottom = 76.0

	if get_node_or_null("Controls/DebugLabel") == null:
		var new_debug_label := Label.new()
		new_debug_label.name = "DebugLabel"
		new_debug_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
		new_debug_label.offset_left = 20.0
		new_debug_label.offset_top = 76.0
		new_debug_label.offset_right = -20.0
		new_debug_label.offset_bottom = 106.0
		new_debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_debug_label.text = "Stage 1I debug ready"
		get_node("Controls").add_child(new_debug_label)

func _ensure_pause_button(controls: Control) -> void:
	if get_node_or_null("Controls/PauseButton") != null:
		return
	var new_pause_button := Button.new()
	new_pause_button.name = "PauseButton"
	new_pause_button.custom_minimum_size = Vector2(120, 48)
	new_pause_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	new_pause_button.offset_left = 14.0
	new_pause_button.offset_top = 14.0
	new_pause_button.offset_right = 134.0
	new_pause_button.offset_bottom = 62.0
	new_pause_button.text = "Pause"
	controls.add_child(new_pause_button)

func _ensure_drag_joystick(controls: Control) -> void:
	if get_node_or_null("Controls/JoystickArea") != null:
		return

	var area := Control.new()
	area.name = "JoystickArea"
	area.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	area.offset_left = 24.0
	area.offset_top = -210.0
	area.offset_right = 188.0
	area.offset_bottom = -46.0
	controls.add_child(area)

	var base := ColorRect.new()
	base.name = "JoystickBase"
	base.color = Color(0.9, 0.9, 0.9, 0.18)
	base.position = Vector2(0, 0)
	base.size = Vector2(164, 164)
	area.add_child(base)

	var knob := ColorRect.new()
	knob.name = "JoystickKnob"
	knob.color = Color(1.0, 1.0, 1.0, 0.45)
	knob.position = Vector2(70, 70)
	knob.size = Vector2(24, 24)
	area.add_child(knob)

	var label := Label.new()
	label.name = "JoystickLabel"
	label.text = "Drag Move"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	label.offset_top = -26.0
	label.offset_bottom = 0.0
	area.add_child(label)

func _ensure_action_buttons() -> void:
	var action_buttons := get_node_or_null("Controls/ActionButtons") as VBoxContainer
	if action_buttons == null:
		return
	action_buttons.offset_left = -160.0
	action_buttons.offset_top = -218.0
	action_buttons.offset_right = -18.0
	action_buttons.offset_bottom = -20.0

	var jump := get_node_or_null("Controls/ActionButtons/JumpButton") as Button
	if jump != null:
		jump.custom_minimum_size = Vector2(142, 58)

	var interact := get_node_or_null("Controls/ActionButtons/InteractButton") as Button
	if interact != null:
		interact.custom_minimum_size = Vector2(142, 58)

	if get_node_or_null("Controls/ActionButtons/ResetButton") == null:
		var reset_button := Button.new()
		reset_button.name = "ResetButton"
		reset_button.custom_minimum_size = Vector2(142, 52)
		reset_button.text = "Reset"
		action_buttons.add_child(reset_button)

func _ensure_camera_buttons(controls: Control) -> void:
	if get_node_or_null("Controls/CameraButtons") != null:
		return
	var camera_buttons := HBoxContainer.new()
	camera_buttons.name = "CameraButtons"
	camera_buttons.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	camera_buttons.offset_left = 210.0
	camera_buttons.offset_top = -78.0
	camera_buttons.offset_right = -180.0
	camera_buttons.offset_bottom = -18.0
	camera_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_child(camera_buttons)

	var camera_left_button := Button.new()
	camera_left_button.name = "CameraLeftButton"
	camera_left_button.custom_minimum_size = Vector2(92, 56)
	camera_left_button.text = "Cam ←"
	camera_buttons.add_child(camera_left_button)

	var camera_right_button := Button.new()
	camera_right_button.name = "CameraRightButton"
	camera_right_button.custom_minimum_size = Vector2(92, 56)
	camera_right_button.text = "Cam →"
	camera_buttons.add_child(camera_right_button)

func _ensure_pause_panel(controls: Control) -> void:
	if get_node_or_null("Controls/PausePanel") != null:
		return
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

func _hide_old_arrow_buttons() -> void:
	var move_pad := get_node_or_null("Controls/MovePad") as Control
	if move_pad != null:
		move_pad.visible = false

func _refresh_optional_nodes() -> void:
	camera = get_node_or_null("../Camera3D")
	status_label = get_node_or_null("Controls/StatusLabel") as Label
	debug_label = get_node_or_null("Controls/DebugLabel") as Label
	pause_panel = get_node_or_null("Controls/PausePanel") as Control
	pause_button = get_node_or_null("Controls/PauseButton") as Button
	joystick_area = get_node_or_null("Controls/JoystickArea") as Control
	joystick_knob = get_node_or_null("Controls/JoystickArea/JoystickKnob") as ColorRect

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
	get_tree().paused = false
	_move_input = Vector2.ZERO
	_orbit_input = 0.0
	var current_scene_path := TEST_WORLD_SCENE
	if get_tree().current_scene != null and not get_tree().current_scene.scene_file_path.is_empty():
		current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)

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
	_clear_joystick()
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
