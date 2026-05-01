extends CanvasLayer

const CURRENT_STAGE_TITLE := "Tales of Drak — Stage 4C"
const CURRENT_STAGE_STATUS := "Stage 4C: image-backed hotbar frame shell."
const CHARACTER_NAME := "Drak Test Hero"
const RACE_SPECIES_NAME := "Variant Human"
const CLASS_NAME := "Fighter"
const CURRENT_LEVEL := 1

var _root: Control
var _sheet_button: Button
var _sheet_panel: Panel
var _sheet_text: Label
var _check_result_text: Label
var _last_scene: Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	_build_overlay()
	_update_visibility()

func _process(_delta: float) -> void:
	if get_tree().current_scene != _last_scene:
		_last_scene = get_tree().current_scene
		_update_visibility()
	_update_stage_hud_labels()

func _build_overlay() -> void:
	_root = Control.new()
	_root.name = "DrakCharacterSheetOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_sheet_button = Button.new()
	_sheet_button.name = "CharacterSheetButton"
	_sheet_button.text = "Sheet"
	_sheet_button.custom_minimum_size = Vector2(118, 48)
	_sheet_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_sheet_button.offset_left = -292.0
	_sheet_button.offset_top = 14.0
	_sheet_button.offset_right = -174.0
	_sheet_button.offset_bottom = 62.0
	_sheet_button.mouse_filter = Control.MOUSE_FILTER_STOP
	_sheet_button.pressed.connect(_toggle_sheet)
	_root.add_child(_sheet_button)

	_sheet_panel = Panel.new()
	_sheet_panel.name = "CharacterSheetPanel"
	_sheet_panel.set_anchors_preset(Control.PRESET_CENTER)
	_sheet_panel.offset_left = -180.0
	_sheet_panel.offset_top = -210.0
	_sheet_panel.offset_right = 180.0
	_sheet_panel.offset_bottom = 210.0
	_sheet_panel.visible = false
	_sheet_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_sheet_panel)

	var box := VBoxContainer.new()
	box.name = "CharacterSheetBox"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 18.0
	box.offset_top = 12.0
	box.offset_right = -18.0
	box.offset_bottom = -12.0
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	_sheet_panel.add_child(box)

	var title := Label.new()
	title.text = "Stage 4C Sheet"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(title)

	_sheet_text = Label.new()
	_sheet_text.text = _get_sheet_text()
	_sheet_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sheet_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_sheet_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_sheet_text)

	_add_button(box, "Hotbar Frame", _preview_hotbar_frame)
	_add_button(box, "Stage 4 Rules", _preview_stage4_rules)
	_add_button(box, "Skelerealms Alignment", _preview_skelerealms_alignment)
	_add_button(box, "Close", _hide_sheet, Vector2(220, 36))

	_check_result_text = Label.new()
	_check_result_text.text = "Stage 4C: image-backed hotbar frame shell only."
	_check_result_text.custom_minimum_size = Vector2(270, 92)
	_check_result_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_check_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_check_result_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_check_result_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_check_result_text)

func _add_button(parent: Control, text: String, callback: Callable, min_size := Vector2(270, 34)) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = min_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.pressed.connect(callback)
	parent.add_child(button)

func _get_sheet_text() -> String:
	return "%s — %s %s %d\nStage 4C retry: art frame anchored to the working 4B hotbar zone.\nNo enemies, damage, targeting, inventory, crafting, taming, quests, dialogue, or Skelerealms integration yet." % [CHARACTER_NAME, RACE_SPECIES_NAME, CLASS_NAME, CURRENT_LEVEL]

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible
	if _sheet_panel.visible:
		_sheet_text.text = _get_sheet_text()

func _hide_sheet() -> void:
	_sheet_panel.visible = false

func _preview_hotbar_frame() -> void:
	_check_result_text.text = "The visible hotbar should now use the embedded gothic frame art, with temporary labels on top."

func _preview_stage4_rules() -> void:
	_check_result_text.text = "Combat remains real-time SWTOR-style on the surface, with D&D rules as the later math backbone. This pass is UI shell only."

func _preview_skelerealms_alignment() -> void:
	_check_result_text.text = "Skelerealms stays the later RPG/world-simulation backend. This UI does not hack Skelerealms internals."

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
	if not in_playable_scene:
		_hide_sheet()

func _update_stage_hud_labels() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var controls := scene.get_node_or_null("MobileTestControls/Controls")
	if controls == null:
		return
	var instruction := controls.get_node_or_null("InstructionLabel") as Label
	if instruction != null:
		instruction.text = CURRENT_STAGE_TITLE
	var status := controls.get_node_or_null("StatusLabel") as Label
	if status != null and status.text.begins_with("Stage "):
		status.text = CURRENT_STAGE_STATUS
	var debug := controls.get_node_or_null("DebugLabel") as Label
	if debug != null:
		debug.text = _replace_stage_text(debug.text)

func _replace_stage_text(text: String) -> String:
	var updated := text
	for stage_name in ["Stage 11", "Stage 1I", "Stage 1E", "Stage 1F", "Stage 1G", "Stage 1H", "Stage 2A", "Stage 2B", "Stage 2C", "Stage 2D", "Stage 2E", "Stage 2F", "Stage 2G", "Stage 2H", "Stage 2I", "Stage 2J", "Stage 2K", "Stage 2L", "Stage 2M", "Stage 2N", "Stage 2O", "Stage 2P", "Stage 2Q", "Stage 2R", "Stage 3A", "Stage 3B", "Stage 3C", "Stage 3D", "Stage 3E", "Stage 3F", "Stage 3G", "Stage 4A", "Stage 4B"]:
		updated = updated.replace(stage_name, "Stage 4C")
	return updated
