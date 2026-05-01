extends CanvasLayer

const FRAME_TEXTURE_SCRIPT := preload("res://drak/ui/drak_hotbar_frame_texture.gd")

const SLOT_LABELS := [
	{"text": "1 Weapon", "x": 0.055, "y": 0.205},
	{"text": "2 Class", "x": 0.165, "y": 0.205},
	{"text": "3 Range", "x": 0.275, "y": 0.205},
	{"text": "4 Guard", "x": 0.385, "y": 0.205},
	{"text": "5 Heal", "x": 0.055, "y": 0.520},
	{"text": "6 Control", "x": 0.165, "y": 0.520},
	{"text": "7 Tame", "x": 0.275, "y": 0.520},
	{"text": "8 Dodge", "x": 0.385, "y": 0.520},
]

const STRIP_LABELS := [
	{"text": "ACTION\n◆ ◆ ◆ ◆", "x": 0.205, "y": 0.785, "w": 0.150},
	{"text": "BONUS\n◇ ◇ ◇ ◇", "x": 0.370, "y": 0.785, "w": 0.150},
	{"text": "REACTION\n◆", "x": 0.615, "y": 0.785, "w": 0.165},
	{"text": "MOVE\n◆ ◆ ◆ ◆", "x": 0.775, "y": 0.785, "w": 0.150},
]

var _root: Control
var _frame_holder: Control
var _frame_texture: TextureRect
var _labels: Array[Label] = []
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

	_frame_holder = Control.new()
	_frame_holder.name = "Stage4CImageHotbarHolder"
	_frame_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_frame_holder)

	_frame_texture = TextureRect.new()
	_frame_texture.name = "Stage4CHotbarFrameImage"
	_frame_texture.texture = FRAME_TEXTURE_SCRIPT.create_texture()
	_frame_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_frame_texture.stretch_mode = TextureRect.STRETCH_SCALE
	_frame_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame_holder.add_child(_frame_texture)

	_build_labels()

func _build_labels() -> void:
	for label_data in SLOT_LABELS:
		var label := _make_hotbar_label(label_data.text, 11)
		_frame_holder.add_child(label)
		_labels.append(label)

	for label_data in STRIP_LABELS:
		var label := _make_hotbar_label(label_data.text, 11)
		_frame_holder.add_child(label)
		_labels.append(label)

	var sword_label := _make_hotbar_label("⚔", 23)
	sword_label.name = "HotbarCenterSwordPlaceholder"
	_frame_holder.add_child(sword_label)
	_labels.append(sword_label)

func _make_hotbar_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.76, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 1.0))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	return label

func _layout_hotbar() -> void:
	if _frame_holder == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var is_landscape := viewport_size.x > viewport_size.y
	var width := min(viewport_size.x * 0.54, 760.0)
	if not is_landscape:
		width = min(viewport_size.x * 0.54, 520.0)
	width = max(width, 360.0)
	var height := width * (143.0 / 450.0)
	var bottom_margin := 88.0 if is_landscape else 136.0
	var left := (viewport_size.x - width) * 0.5
	var top := viewport_size.y - height - bottom_margin
	if top < viewport_size.y * 0.43:
		top = viewport_size.y * 0.43

	_frame_holder.set_position(Vector2(left, top))
	_frame_holder.set_size(Vector2(width, height))
	_frame_texture.set_position(Vector2.ZERO)
	_frame_texture.set_size(Vector2(width, height))

	for i in range(SLOT_LABELS.size()):
		var label_data := SLOT_LABELS[i]
		var label := _labels[i]
		label.set_position(Vector2(width * label_data.x - width * 0.045, height * label_data.y - 8.0))
		label.set_size(Vector2(width * 0.090, height * 0.115))

	for i in range(STRIP_LABELS.size()):
		var label_data := STRIP_LABELS[i]
		var label := _labels[SLOT_LABELS.size() + i]
		label.set_position(Vector2(width * label_data.x - width * (label_data.w * 0.5), height * label_data.y))
		label.set_size(Vector2(width * label_data.w, height * 0.17))

	var sword_label := _labels[_labels.size() - 1]
	sword_label.set_position(Vector2(width * 0.477, height * 0.735))
	sword_label.set_size(Vector2(width * 0.07, height * 0.17))

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
	if in_playable_scene:
		_layout_hotbar()
