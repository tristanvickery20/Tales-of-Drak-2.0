extends CanvasLayer

## Stage 4C safe overlay test.
## This is intentionally small and non-invasive.
## It does not touch movement, pickups, cave transitions, Skelerealms, combat math, or gameplay state.

var _root: Control
var _hotbar: Panel
var _sheet_button: Button
var _sheet_panel: Panel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 80
	_build_ui()
	_update_visible()

func _process(_delta: float) -> void:
	_update_visible()
	_update_stage_labels()

func _build_ui() -> void:
	_root = Control.new()
	_root.name = "Stage4CSafeOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)
	_build_hotbar()
	_build_sheet_button()

func _build_hotbar() -> void:
	_hotbar = Panel.new()
	_hotbar.name = "Stage4CSafeHotbar"
	_hotbar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_hotbar.offset_left = 250.0
	_hotbar.offset_top = -212.0
	_hotbar.offset_right = -300.0
	_hotbar.offset_bottom = -96.0
	_hotbar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_hotbar)

	var box := VBoxContainer.new()
	box.name = "Stage4CHotbarBox"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 10.0
	box.offset_top = 7.0
	box.offset_right = -10.0
	box.offset_bottom = -7.0
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hotbar.add_child(box)

	var top := HBoxContainer.new()
	top.name = "Stage4CHotbarTopRow"
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(top)

	var bottom := HBoxContainer.new()
	bottom.name = "Stage4CHotbarBottomRow"
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(bottom)

	var strip := HBoxContainer.new()
	strip.name = "Stage4CHotbarActionStrip"
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(strip)

	var top_labels := ["1 Weapon", "2 Class", "3 Range", "4 Guard", "5", "6", "7", "8", "9", "0", "-", "="]
	var bottom_labels := ["Q Heal", "E Control", "R Tame", "T Dodge", "Y", "U", "I", "O", "P", "[", "]", "-"]
	for text in top_labels:
		top.add_child(_slot(text))
	for text in bottom_labels:
		bottom.add_child(_slot(text))
	for text in ["ACTION", "BONUS", "SWORD", "REACTION", "MOVE"]:
		strip.add_child(_strip(text))

func _slot(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(58, 30)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_theme_font_size_override("font_size", 9)
	return button

func _strip(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(104, 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72, 1.0))
	return label

func _build_sheet_button() -> void:
	_sheet_button = Button.new()
	_sheet_button.name = "Stage4CSheetButton"
	_sheet_button.text = "Sheet"
	_sheet_button.custom_minimum_size = Vector2(118, 48)
	_sheet_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_sheet_button.offset_left = -292.0
	_sheet_button.offset_top = 14.0
	_sheet_button.offset_right = -174.0
	_sheet_button.offset_bottom = 62.0
	_sheet_button.pressed.connect(_toggle_sheet)
	_root.add_child(_sheet_button)

	_sheet_panel = Panel.new()
	_sheet_panel.name = "Stage4CSheetPanel"
	_sheet_panel.set_anchors_preset(Control.PRESET_CENTER)
	_sheet_panel.offset_left = -170.0
	_sheet_panel.offset_top = -110.0
	_sheet_panel.offset_right = 170.0
	_sheet_panel.offset_bottom = 110.0
	_sheet_panel.visible = false
	_root.add_child(_sheet_panel)

	var label := Label.new()
	label.text = "Stage 4C safe overlay loaded.\nReal-time hotbar shell only.\nNo enemies, damage, inventory, crafting, taming, quests, dialogue, or Skelerealms integration yet."
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 14.0
	label.offset_top = 14.0
	label.offset_right = -14.0
	label.offset_bottom = -14.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_sheet_panel.add_child(label)

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible

func _update_visible() -> void:
	var scene := get_tree().current_scene
	var active := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = active
	if not active and _sheet_panel != null:
		_sheet_panel.visible = false

func _update_stage_labels() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var controls := scene.get_node_or_null("MobileTestControls/Controls")
	if controls == null:
		return
	var instruction := controls.get_node_or_null("InstructionLabel") as Label
	if instruction != null:
		instruction.text = "Tales of Drak - Stage 4C"
	var status := controls.get_node_or_null("StatusLabel") as Label
	if status != null:
		status.text = "Stage 4C: tightened safe hotbar shell."
	var debug := controls.get_node_or_null("DebugLabel") as Label
	if debug != null:
		debug.text = debug.text.replace("Stage 1I", "Stage 4C")
