extends CanvasLayer

## Tales of Drak art hotbar overlay.
## Uses the approved two-row dark fantasy frame as the visible UI, then lays invisible
## buttons over the slot openings so it can become a real combat/tool hotbar later.

const FRAME_ASPECT := 900.0 / 300.0
const SLOT_COUNT := 13
const SLOT_X_START := 0.040
const SLOT_X_END := 0.964
const TOP_SLOT_Y := 0.205
const BOTTOM_SLOT_Y := 0.455
const SLOT_H := 0.185
const FRAME_BOTTOM_MARGIN := 10.0
const FRAME_MAX_WIDTH := 1500.0
const FRAME_SCREEN_WIDTH_PERCENT := 0.94
const MODE_COMBAT := "Combat Hotbar"
const MODE_TOOLS := "Tool Hotbar"

var _root: Control
var _frame: TextureRect
var _slot_buttons: Array[Button] = []
var _mode_label: Label
var _is_tool_bar := false
var _last_size := Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 90
	_build_ui()
	_update_visible()

func _process(_delta: float) -> void:
	_update_visible()
	_layout_overlay()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey:
		var key := event as InputEventKey
		if not key.pressed or key.echo:
			return
		if key.keycode == KEY_TAB:
			_toggle_hotbar_mode()
			get_viewport().set_input_as_handled()
			return
		var slot_index := _slot_index_for_key(key.keycode)
		if slot_index >= 0:
			_activate_slot(slot_index)
			get_viewport().set_input_as_handled()

func _build_ui() -> void:
	_root = Control.new()
	_root.name = "DrakHotbarArtRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_frame = TextureRect.new()
	_frame.name = "ApprovedDarkFantasyHotbarFrame"
	_frame.texture = load("res://drak/ui/art/drak_hotbar_frame.svg")
	_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_frame.stretch_mode = TextureRect.STRETCH_SCALE
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_frame)

	for index in range(SLOT_COUNT * 2):
		var button := Button.new()
		button.name = "HotbarSlot%02d" % [index + 1]
		button.flat = true
		button.text = ""
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.modulate = Color(1, 1, 1, 0)
		button.pressed.connect(_activate_slot.bind(index))
		_slot_buttons.append(button)
		_root.add_child(button)

	_mode_label = Label.new()
	_mode_label.name = "HotbarModeLabel"
	_mode_label.text = MODE_COMBAT
	_mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_mode_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_mode_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mode_label.add_theme_font_size_override("font_size", 12)
	_mode_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.70, 0.88))
	_root.add_child(_mode_label)

func _layout_overlay() -> void:
	if _root == null or _frame == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size == _last_size:
		return
	_last_size = viewport_size
	var frame_width := min(viewport_size.x * FRAME_SCREEN_WIDTH_PERCENT, FRAME_MAX_WIDTH)
	var frame_height := frame_width / FRAME_ASPECT
	var frame_pos := Vector2((viewport_size.x - frame_width) * 0.5, viewport_size.y - frame_height - FRAME_BOTTOM_MARGIN)
	_frame.position = frame_pos
	_frame.size = Vector2(frame_width, frame_height)
	_layout_slots(frame_pos, Vector2(frame_width, frame_height))
	_layout_mode_label(frame_pos, Vector2(frame_width, frame_height))

func _layout_slots(frame_pos: Vector2, frame_size: Vector2) -> void:
	var total_slot_width := SLOT_X_END - SLOT_X_START
	var gap := 0.007
	var slot_w := (total_slot_width - (gap * float(SLOT_COUNT - 1))) / float(SLOT_COUNT)
	for index in range(_slot_buttons.size()):
		var row := int(index / SLOT_COUNT)
		var column := index % SLOT_COUNT
		var x_ratio := SLOT_X_START + (float(column) * (slot_w + gap))
		var y_ratio := TOP_SLOT_Y if row == 0 else BOTTOM_SLOT_Y
		_slot_buttons[index].position = frame_pos + Vector2(frame_size.x * x_ratio, frame_size.y * y_ratio)
		_slot_buttons[index].size = Vector2(frame_size.x * slot_w, frame_size.y * SLOT_H)

func _layout_mode_label(frame_pos: Vector2, frame_size: Vector2) -> void:
	_mode_label.position = frame_pos + Vector2(frame_size.x * 0.38, frame_size.y * 0.805)
	_mode_label.size = Vector2(frame_size.x * 0.24, frame_size.y * 0.07)

func _update_visible() -> void:
	var scene := get_tree().current_scene
	var active := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	visible = active
	if _root != null:
		_root.visible = active

func _toggle_hotbar_mode() -> void:
	_is_tool_bar = not _is_tool_bar
	_mode_label.text = MODE_TOOLS if _is_tool_bar else MODE_COMBAT

func _activate_slot(index: int) -> void:
	var mode := MODE_TOOLS if _is_tool_bar else MODE_COMBAT
	print("Drak hotbar slot ", index + 1, " selected in ", mode, ".")

func _slot_index_for_key(keycode: int) -> int:
	var top_keys := [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0, KEY_MINUS, KEY_EQUAL, KEY_BACKSPACE]
	var bottom_keys := [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P, KEY_BRACKETLEFT, KEY_BRACKETRIGHT, KEY_BACKSLASH]
	var top_index := top_keys.find(keycode)
	if top_index >= 0:
		return top_index
	var bottom_index := bottom_keys.find(keycode)
	if bottom_index >= 0:
		return SLOT_COUNT + bottom_index
	return -1
