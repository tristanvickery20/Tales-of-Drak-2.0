extends CanvasLayer

const HOTBAR_SLOTS := [
	"1 Weapon",
	"2 Class",
	"3 Range",
	"4 Guard",
	"5 Heal",
	"6 Control",
	"7 Tame",
	"8 Dodge",
]

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
	_panel.name = "InactiveHotbarPanel"
	_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_panel.offset_left = 74.0
	_panel.offset_top = -128.0
	_panel.offset_right = -74.0
	_panel.offset_bottom = -36.0
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_panel)

	var box := VBoxContainer.new()
	box.name = "HotbarRows"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 8.0
	box.offset_top = 6.0
	box.offset_right = -8.0
	box.offset_bottom = -6.0
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.add_child(box)

	var row_one := HBoxContainer.new()
	row_one.name = "HotbarRowOne"
	row_one.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(row_one)

	var row_two := HBoxContainer.new()
	row_two.name = "HotbarRowTwo"
	row_two.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(row_two)

	for index in HOTBAR_SLOTS.size():
		var slot := Label.new()
		slot.name = "HotbarSlot%d" % [index + 1]
		slot.text = HOTBAR_SLOTS[index]
		slot.custom_minimum_size = Vector2(74, 32)
		slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if index < 4:
			row_one.add_child(slot)
		else:
			row_two.add_child(slot)

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
