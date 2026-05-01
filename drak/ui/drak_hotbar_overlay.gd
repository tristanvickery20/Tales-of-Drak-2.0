extends CanvasLayer

const TOP_ROW := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const BOTTOM_ROW := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]
const FIRST_ABILITIES := ["Weapon", "Class", "Range", "Guard", "Heal", "Control", "Tame", "Dodge"]

var _root: Control
var _panel: Panel
var _last_scene: Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 12
	_build_overlay()
	_update_visibility()

func _process(_delta: float) -> void:
	if get_tree().current_scene != _last_scene:
		_last_scene = get_tree().current_scene
		_update_visibility()

func _build_overlay() -> void:
	_root = Control.new()
	_root.name = "DrakHotbarOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_panel = Panel.new()
	_panel.name = "Stage4CFixedHotbarPanel"
	_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_panel.offset_left = 74.0
	_panel.offset_top = -170.0
	_panel.offset_right = -74.0
	_panel.offset_bottom = -36.0
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_panel)

	var main_box := VBoxContainer.new()
	main_box.name = "HotbarMainBox"
	main_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_box.offset_left = 10.0
	main_box.offset_top = 6.0
	main_box.offset_right = -10.0
	main_box.offset_bottom = -6.0
	main_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.add_child(main_box)

	var top_row := HBoxContainer.new()
	top_row.name = "HotbarTopRow"
	top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_box.add_child(top_row)

	var bottom_row := HBoxContainer.new()
	bottom_row.name = "HotbarBottomRow"
	bottom_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_box.add_child(bottom_row)

	var strip := HBoxContainer.new()
	strip.name = "HotbarActionStrip"
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_box.add_child(strip)

	for i in range(TOP_ROW.size()):
		var ability := FIRST_ABILITIES[i] if i < 4 else ""
		top_row.add_child(_make_slot_label(TOP_ROW[i], ability))

	for i in range(BOTTOM_ROW.size()):
		var ability_index := i + 4
		var ability := FIRST_ABILITIES[ability_index] if ability_index < FIRST_ABILITIES.size() else ""
		bottom_row.add_child(_make_slot_label(BOTTOM_ROW[i], ability))

	strip.add_child(_make_strip_label("ACTION\n◆ ◆ ◆ ◆"))
	strip.add_child(_make_strip_label("BONUS\n◇ ◇ ◇ ◇"))
	strip.add_child(_make_strip_label("⚔"))
	strip.add_child(_make_strip_label("REACTION\n◆"))
	strip.add_child(_make_strip_label("MOVE\n◆ ◆ ◆ ◆"))

func _make_slot_label(key_text: String, ability_text: String) -> Label:
	var label := Label.new()
	label.name = "HotbarSlot_%s" % key_text.replace("[", "LBracket").replace("]", "RBracket").replace("-", "Minus").replace("=", "Equals")
	label.text = "%s\n%s" % [key_text, ability_text]
	label.custom_minimum_size = Vector2(64, 38)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.08, 0.07, 0.05, 1.0))
	return label

func _make_strip_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(128, 30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72, 1.0))
	return label

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
