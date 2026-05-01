extends CanvasLayer

const TOP_ROW := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const BOTTOM_ROW := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]
const PREVIEW_LABELS := ["Weapon", "Class", "Range", "Guard", "Heal", "Control", "Tame", "Dodge"]

var _root: Control
var _holder: Control
var _background: Panel
var _slots: Array[Panel] = []
var _key_labels: Array[Label] = []
var _preview_labels: Array[Label] = []
var _strip_labels: Array[Label] = []
var _sword_label: Label
var _last_scene: Node
var _last_viewport_size := Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 12
	_build_overlay()
	_update_visibility()
	_layout_hotbar()

func _process(_delta: float) -> void:
	if get_tree().current_scene != _last_scene:
		_last_scene = get_tree().current_scene
		_update_visibility()
	var size := get_viewport().get_visible_rect().size
	if size != _last_viewport_size:
		_last_viewport_size = size
		_layout_hotbar()

func _build_overlay() -> void:
	_root = Control.new()
	_root.name = "DrakHotbarOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_holder = Control.new()
	_holder.name = "Stage4CGuaranteedHotbarHolder"
	_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_holder)

	_background = Panel.new()
	_background.name = "Stage4CCodedGothicFrame"
	_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_background.add_theme_stylebox_override("panel", _make_frame_style())
	_holder.add_child(_background)

	_build_slots_and_labels()
	_build_bottom_strip()

func _build_slots_and_labels() -> void:
	for i in range(24):
		var key_text := TOP_ROW[i] if i < 12 else BOTTOM_ROW[i - 12]

		var key_label := Label.new()
		key_label.text = key_text
		key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		key_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		key_label.add_theme_font_size_override("font_size", 13)
		key_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
		_holder.add_child(key_label)
		_key_labels.append(key_label)

		var slot := Panel.new()
		slot.name = "HotbarFrameSlot%d" % [i + 1]
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_theme_stylebox_override("panel", _make_slot_style())
		_holder.add_child(slot)
		_slots.append(slot)

	for text in PREVIEW_LABELS:
		var label := Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(0.08, 0.08, 0.08, 0.92))
		_holder.add_child(label)
		_preview_labels.append(label)

func _build_bottom_strip() -> void:
	for text in ["ACTION\n◆ ◆ ◆ ◆", "BONUS\n◇ ◇ ◇ ◇", "REACTION\n◆", "MOVE\n◆ ◆ ◆ ◆"]:
		var label := Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
		_holder.add_child(label)
		_strip_labels.append(label)

	_sword_label = Label.new()
	_sword_label.text = "⚔"
	_sword_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sword_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_sword_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_sword_label.add_theme_font_size_override("font_size", 26)
	_sword_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	_holder.add_child(_sword_label)

func _layout_hotbar() -> void:
	if _holder == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var is_landscape := viewport_size.x > viewport_size.y
	var width := min(viewport_size.x * 0.60, 780.0)
	if not is_landscape:
		width = min(viewport_size.x * 0.82, 520.0)
	width = max(width, 430.0)
	var height := width * 0.31
	var left := (viewport_size.x - width) * 0.5
	var bottom_margin := 78.0 if is_landscape else 122.0
	var top := viewport_size.y - height - bottom_margin
	if top < viewport_size.y * 0.40:
		top = viewport_size.y * 0.40

	_holder.set_position(Vector2(left, top))
	_holder.set_size(Vector2(width, height))
	_background.set_position(Vector2.ZERO)
	_background.set_size(Vector2(width, height))

	var side_pad := width * 0.035
	var slot_gap := width * 0.006
	var slot_w := (width - side_pad * 2.0 - slot_gap * 11.0) / 12.0
	var slot_h := height * 0.245
	var top_label_y := height * 0.045
	var top_slot_y := height * 0.150
	var bottom_label_y := height * 0.405
	var bottom_slot_y := height * 0.510

	for i in range(24):
		var row := 0 if i < 12 else 1
		var col := i if row == 0 else i - 12
		var x := side_pad + col * (slot_w + slot_gap)
		var label_y := top_label_y if row == 0 else bottom_label_y
		var slot_y := top_slot_y if row == 0 else bottom_slot_y
		_key_labels[i].set_position(Vector2(x, label_y))
		_key_labels[i].set_size(Vector2(slot_w, height * 0.09))
		_slots[i].set_position(Vector2(x, slot_y))
		_slots[i].set_size(Vector2(slot_w, slot_h))

	for i in range(_preview_labels.size()):
		var row := 0 if i < 4 else 1
		var col := i if row == 0 else i - 4
		var slot_index := col if row == 0 else 12 + col
		var slot_pos := _slots[slot_index].position
		_preview_labels[i].set_position(slot_pos + Vector2(0, slot_h * 0.28))
		_preview_labels[i].set_size(Vector2(slot_w, slot_h * 0.44))

	var strip_y := height * 0.795
	_layout_strip_label(0, width * 0.20, strip_y, width * 0.16, height * 0.18)
	_layout_strip_label(1, width * 0.38, strip_y, width * 0.16, height * 0.18)
	_layout_strip_label(2, width * 0.62, strip_y, width * 0.18, height * 0.18)
	_layout_strip_label(3, width * 0.80, strip_y, width * 0.16, height * 0.18)
	_sword_label.set_position(Vector2(width * 0.465, height * 0.735))
	_sword_label.set_size(Vector2(width * 0.07, height * 0.20))

func _layout_strip_label(index: int, center_x: float, y: float, w: float, h: float) -> void:
	_strip_labels[index].set_position(Vector2(center_x - w * 0.5, y))
	_strip_labels[index].set_size(Vector2(w, h))

func _make_frame_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.018, 0.015, 0.012, 0.94)
	style.border_color = Color(0.44, 0.38, 0.30, 1.0)
	style.set_border_width_all(4)
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	return style

func _make_slot_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.96, 0.96, 0.93, 0.98)
	style.border_color = Color(0.0, 0.0, 0.0, 1.0)
	style.set_border_width_all(3)
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
