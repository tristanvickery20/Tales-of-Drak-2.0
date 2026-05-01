extends CanvasLayer

const TOP_KEYS := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const BOTTOM_KEYS := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]
const SLOT_COUNT := 24

var _root: Control
var _frame: Panel
var _status: Label
var _buttons: Array[Button] = []
var _key_labels: Array[Label] = []
var _last_scene: Node
var _last_viewport_size := Vector2.ZERO
var _selected_index := -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 80
	_build_overlay()
	_update_visibility()
	_layout_hotbar()

func _process(_delta: float) -> void:
	if get_tree().current_scene != _last_scene:
		_last_scene = get_tree().current_scene
		_update_visibility()
	var current_size := get_viewport().get_visible_rect().size
	if current_size != _last_viewport_size:
		_last_viewport_size = current_size
		_layout_hotbar()

func _unhandled_input(event: InputEvent) -> void:
	if _root == null or not _root.visible:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var key_text := OS.get_keycode_string(event.keycode)
		var index := _get_slot_index_for_key(key_text)
		if index >= 0:
			_press_slot(index)

func _build_overlay() -> void:
	_root = Control.new()
	_root.name = "DrakHotbarOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_frame = Panel.new()
	_frame.name = "VisibleGothicHotbarFrame"
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame.add_theme_stylebox_override("panel", _make_frame_style())
	_root.add_child(_frame)

	_build_slots()
	_build_bottom_strip()

func _build_slots() -> void:
	for i in range(SLOT_COUNT):
		var row := 0 if i < TOP_KEYS.size() else 1
		var key := TOP_KEYS[i] if row == 0 else BOTTOM_KEYS[i - TOP_KEYS.size()]

		var key_label := Label.new()
		key_label.name = "HotbarKeyLabel%d" % [i + 1]
		key_label.text = key
		key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		key_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		key_label.add_theme_font_size_override("font_size", 14)
		key_label.add_theme_color_override("font_color", Color(0.96, 0.90, 0.78, 1.0))
		_frame.add_child(key_label)
		_key_labels.append(key_label)

		var button := Button.new()
		button.name = "HotbarSlot%d" % [i + 1]
		button.text = ""
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.add_theme_stylebox_override("normal", _make_slot_style(false))
		button.add_theme_stylebox_override("hover", _make_slot_style(false))
		button.add_theme_stylebox_override("pressed", _make_slot_style(true))
		button.pressed.connect(_press_slot.bind(i))
		_frame.add_child(button)
		_buttons.append(button)

func _build_bottom_strip() -> void:
	var strip_items := [
		["ACTION", "◆ ◆ ◆ ◆"],
		["BONUS", "◇ ◇ ◇ ◇"],
		["REACTION", "◆"],
		["MOVE", "◆ ◆ ◆ ◆"],
	]
	for i in range(strip_items.size()):
		var label := Label.new()
		label.name = "HotbarResource%d" % [i + 1]
		label.text = "%s\n%s" % [strip_items[i][0], strip_items[i][1]]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_size_override("font_size", 13)
		label.add_theme_color_override("font_color", Color(0.96, 0.90, 0.78, 1.0))
		_frame.add_child(label)

	var medallion := Label.new()
	medallion.name = "HotbarCenterMedallion"
	medallion.text = "⚔"
	medallion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	medallion.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	medallion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	medallion.add_theme_font_size_override("font_size", 26)
	medallion.add_theme_color_override("font_color", Color(0.96, 0.90, 0.78, 1.0))
	_frame.add_child(medallion)

	_status = Label.new()
	_status.name = "HotbarStatus"
	_status.text = "Stage 4C Fix: visible hotbar"
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_status.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_status.add_theme_font_size_override("font_size", 11)
	_status.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9, 1.0))
	_frame.add_child(_status)

func _layout_hotbar() -> void:
	if _frame == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var safe_side := 120.0
	var width := clamp(viewport_size.x - (safe_side * 2.0), 520.0, 980.0)
	if viewport_size.x < 900.0:
		width = viewport_size.x * 0.70
	var height := width * 0.24
	var left := (viewport_size.x - width) * 0.5
	var bottom_margin := 18.0
	var top := viewport_size.y - height - bottom_margin
	_frame.set_position(Vector2(left, top))
	_frame.set_size(Vector2(width, height))

	var padding_x := width * 0.018
	var label_h := height * 0.105
	var slot_w := (width - padding_x * 2.0) / 12.0
	var slot_h := height * 0.245
	var top_label_y := height * 0.03
	var top_slot_y := height * 0.15
	var bottom_label_y := height * 0.405
	var bottom_slot_y := height * 0.525

	for i in range(SLOT_COUNT):
		var row := 0 if i < 12 else 1
		var col := i if row == 0 else i - 12
		var x := padding_x + col * slot_w
		var label_y := top_label_y if row == 0 else bottom_label_y
		var slot_y := top_slot_y if row == 0 else bottom_slot_y
		_key_labels[i].set_position(Vector2(x, label_y))
		_key_labels[i].set_size(Vector2(slot_w, label_h))
		_buttons[i].set_position(Vector2(x + 2.0, slot_y))
		_buttons[i].set_size(Vector2(slot_w - 4.0, slot_h))

	var strip_y := height * 0.80
	_layout_named_label("HotbarResource1", Vector2(width * 0.10, strip_y), Vector2(width * 0.16, height * 0.18))
	_layout_named_label("HotbarResource2", Vector2(width * 0.30, strip_y), Vector2(width * 0.16, height * 0.18))
	_layout_named_label("HotbarCenterMedallion", Vector2(width * 0.48, strip_y - 6.0), Vector2(width * 0.05, height * 0.22))
	_layout_named_label("HotbarResource3", Vector2(width * 0.55, strip_y), Vector2(width * 0.16, height * 0.18))
	_layout_named_label("HotbarResource4", Vector2(width * 0.73, strip_y), Vector2(width * 0.16, height * 0.18))
	_layout_named_label("HotbarStatus", Vector2(width * 0.36, height * 0.965), Vector2(width * 0.28, height * 0.08))

func _layout_named_label(label_name: String, position: Vector2, size: Vector2) -> void:
	var node := _frame.get_node_or_null(label_name) as Control
	if node != null:
		node.set_position(position)
		node.set_size(size)

func _press_slot(index: int) -> void:
	_selected_index = index
	for i in range(_buttons.size()):
		_buttons[i].add_theme_stylebox_override("normal", _make_slot_style(i == _selected_index))
	var key := TOP_KEYS[index] if index < TOP_KEYS.size() else BOTTOM_KEYS[index - TOP_KEYS.size()]
	_status.text = "Slot %s pressed" % key

func _get_slot_index_for_key(key_text: String) -> int:
	var normalized := key_text.to_upper()
	for i in range(TOP_KEYS.size()):
		if TOP_KEYS[i].to_upper() == normalized:
			return i
	for i in range(BOTTOM_KEYS.size()):
		if BOTTOM_KEYS[i].to_upper() == normalized:
			return TOP_KEYS.size() + i
	return -1

func _make_frame_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.01, 0.009, 0.008, 0.96)
	style.border_color = Color(0.55, 0.48, 0.40, 1.0)
	style.set_border_width_all(4)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func _make_slot_style(selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.98, 0.98, 0.96, 0.98)
	style.border_color = Color(1.0, 0.04, 0.03, 1.0) if selected else Color(0.0, 0.0, 0.0, 1.0)
	style.set_border_width_all(4 if selected else 2)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	return style

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
	if in_playable_scene:
		_layout_hotbar()
