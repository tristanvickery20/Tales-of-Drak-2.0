extends CanvasLayer

const HOTBAR_TOP := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const HOTBAR_BOTTOM := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]
const ABILITY_NAMES := ["Weapon", "Class", "Range", "Guard", "Heal", "Control", "Tame", "Dodge"]

var root
var holder
var frame
var key_labels := []
var slots := []
var ability_labels := []
var strip_labels := []
var sword_label
var last_scene
var last_size := Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 90
	build_overlay()
	update_visibility()
	layout_hotbar()

func _process(_delta: float) -> void:
	if get_tree().current_scene != last_scene:
		last_scene = get_tree().current_scene
		update_visibility()
	var size := get_viewport().get_visible_rect().size
	if size != last_size:
		last_size = size
		layout_hotbar()

func build_overlay() -> void:
	root = Control.new()
	root.name = "DrakHotbarOverlayRoot"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	holder = Control.new()
	holder.name = "Stage4CFailSafeHotbar"
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(holder)

	frame = ColorRect.new()
	frame.name = "VisibleHotbarFrame"
	frame.color = Color(0.015, 0.012, 0.01, 0.94)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(frame)

	build_slot_rows()
	build_action_strip()

func build_slot_rows() -> void:
	for i in range(24):
		var row := 0 if i < 12 else 1
		var key_text := HOTBAR_TOP[i] if row == 0 else HOTBAR_BOTTOM[i - 12]

		var key_label := Label.new()
		key_label.text = key_text
		key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		key_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		key_label.add_theme_font_size_override("font_size", 13)
		key_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72, 1.0))
	holder.add_child(key_label)
		key_labels.append(key_label)

		var slot := ColorRect.new()
		slot.name = "HotbarSlot%d" % [i + 1]
		slot.color = Color(0.97, 0.97, 0.94, 0.98)
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(slot)
		slots.append(slot)

	for text in ABILITY_NAMES:
		var label := Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color(0.06, 0.05, 0.04, 1.0))
		holder.add_child(label)
		ability_labels.append(label)

func build_action_strip() -> void:
	for text in ["ACTION\n◆ ◆ ◆ ◆", "BONUS\n◇ ◇ ◇ ◇", "REACTION\n◆", "MOVE\n◆ ◆ ◆ ◆"]:
		var label := Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72, 1.0))
		holder.add_child(label)
		strip_labels.append(label)

	sword_label = Label.new()
	sword_label.text = "⚔"
	sword_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sword_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sword_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sword_label.add_theme_font_size_override("font_size", 24)
	sword_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72, 1.0))
	holder.add_child(sword_label)

func layout_hotbar() -> void:
	if holder == null:
		return
	var viewport := get_viewport().get_visible_rect().size
	var width := min(viewport.x * 0.58, 780.0)
	width = max(width, 520.0)
	var height := width * 0.28
	var left := (viewport.x - width) * 0.5
	var top := viewport.y - height - 72.0
	if top < viewport.y * 0.42:
		top = viewport.y * 0.42

	holder.position = Vector2(left, top)
	holder.size = Vector2(width, height)
	frame.position = Vector2.ZERO
	frame.size = Vector2(width, height)

	var side := width * 0.035
	var gap := width * 0.006
	var slot_w := (width - side * 2.0 - gap * 11.0) / 12.0
	var slot_h := height * 0.24
	var top_key_y := height * 0.04
	var top_slot_y := height * 0.16
	var bottom_key_y := height * 0.39
	var bottom_slot_y := height * 0.51

	for i in range(24):
		var row := 0 if i < 12 else 1
		var col := i if row == 0 else i - 12
		var x := side + col * (slot_w + gap)
		var key_y := top_key_y if row == 0 else bottom_key_y
		var slot_y := top_slot_y if row == 0 else bottom_slot_y
		key_labels[i].position = Vector2(x, key_y)
		key_labels[i].size = Vector2(slot_w, height * 0.09)
		slots[i].position = Vector2(x, slot_y)
		slots[i].size = Vector2(slot_w, slot_h)

	for i in range(ability_labels.size()):
		var row := 0 if i < 4 else 1
		var col := i if row == 0 else i - 4
		var slot_index := col if row == 0 else 12 + col
		ability_labels[i].position = slots[slot_index].position
		ability_labels[i].size = slots[slot_index].size

	layout_strip_label(0, width * 0.20, height * 0.79, width * 0.16, height * 0.18)
	layout_strip_label(1, width * 0.38, height * 0.79, width * 0.16, height * 0.18)
	layout_strip_label(2, width * 0.62, height * 0.79, width * 0.18, height * 0.18)
	layout_strip_label(3, width * 0.80, height * 0.79, width * 0.16, height * 0.18)
	sword_label.position = Vector2(width * 0.465, height * 0.73)
	sword_label.size = Vector2(width * 0.07, height * 0.20)

func layout_strip_label(index: int, center_x: float, y: float, w: float, h: float) -> void:
	strip_labels[index].position = Vector2(center_x - w * 0.5, y)
	strip_labels[index].size = Vector2(w, h)

func update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	root.visible = in_playable_scene
	if in_playable_scene:
		layout_hotbar()
