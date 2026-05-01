extends CanvasLayer

## Stage 4D proven overlay.
## This file is confirmed to load because it updates the visible Stage label.
## The approved hotbar frame is drawn here directly to avoid image/SVG import and
## separate autoload visibility failures in the iPhone web build.

const SLOT_COUNT := 13
const FRAME_ASPECT := 3.0
const FRAME_WIDTH_PERCENT := 0.84
const FRAME_HEIGHT_PERCENT := 0.32
const FRAME_MAX_WIDTH := 1180.0
const FRAME_BOTTOM_MARGIN := 0.0

var _root: Control
var _frame_root: Control
var _slots: Array[Panel] = []
var _bottom_plate: ColorRect
var _medallion: Label
var _sheet_button: Button
var _sheet_panel: Panel
var _last_size := Vector2(-1, -1)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 90
	_build_overlay()
	_update_visible()
	_layout_hotbar(true)

func _process(_delta: float) -> void:
	_update_visible()
	_update_stage_labels()
	_layout_hotbar(false)

func _build_overlay() -> void:
	_root = Control.new()
	_root.name = "Stage4DDirectOverlayRoot"
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)
	_build_hotbar_frame()
	_build_sheet_button()

func _build_hotbar_frame() -> void:
	_frame_root = Control.new()
	_frame_root.name = "Stage4DDirectHotbarFrame"
	_frame_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_frame_root)

	var main_back := ColorRect.new()
	main_back.name = "MainBlackIronFrame"
	main_back.color = Color(0.006, 0.005, 0.004, 0.98)
	main_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame_root.add_child(main_back)

	var divider := ColorRect.new()
	divider.name = "MiddleDivider"
	divider.color = Color(0, 0, 0, 1)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame_root.add_child(divider)

	_bottom_plate = ColorRect.new()
	_bottom_plate.name = "BottomBlackIronPlate"
	_bottom_plate.color = Color(0.006, 0.005, 0.004, 0.98)
	_bottom_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame_root.add_child(_bottom_plate)

	for i in range(SLOT_COUNT * 2):
		var slot := Panel.new()
		slot.name = "ArtSlot%02d" % [i + 1]
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_theme_stylebox_override("panel", _slot_style())
		_frame_root.add_child(slot)
		_slots.append(slot)

	_medallion = Label.new()
	_medallion.name = "CenterSwordMedallion"
	_medallion.text = "⚔"
	_medallion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_medallion.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_medallion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_medallion.add_theme_font_size_override("font_size", 28)
	_medallion.add_theme_color_override("font_color", Color(0.80, 0.72, 0.66, 0.9))
	_frame_root.add_child(_medallion)

func _slot_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.98, 0.98, 0.96, 0.05)
	style.border_color = Color(0.0, 0.0, 0.0, 1.0)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 1
	style.corner_radius_top_right = 1
	style.corner_radius_bottom_left = 1
	style.corner_radius_bottom_right = 1
	return style

func _build_sheet_button() -> void:
	_sheet_button = Button.new()
	_sheet_button.name = "Stage4DSheetButton"
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
	_sheet_panel.name = "Stage4DSheetPanel"
	_sheet_panel.set_anchors_preset(Control.PRESET_CENTER)
	_sheet_panel.offset_left = -170.0
	_sheet_panel.offset_top = -110.0
	_sheet_panel.offset_right = 170.0
	_sheet_panel.offset_bottom = 110.0
	_sheet_panel.visible = false
	_root.add_child(_sheet_panel)

	var label := Label.new()
	label.text = "Stage 4D direct hotbar loaded.\nFrame is drawn by the proven overlay.\nNo combat, damage, inventory, crafting, taming, quests, dialogue, or Skelerealms integration yet."
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 14.0
	label.offset_top = 14.0
	label.offset_right = -14.0
	label.offset_bottom = -14.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_sheet_panel.add_child(label)

func _layout_hotbar(force: bool) -> void:
	if _frame_root == null:
		return
	var viewport := get_viewport().get_visible_rect().size
	if not force and viewport == _last_size:
		return
	_last_size = viewport
	var width_from_screen := viewport.x * FRAME_WIDTH_PERCENT
	var width_from_height := viewport.y * FRAME_HEIGHT_PERCENT * FRAME_ASPECT
	var frame_w := min(width_from_screen, width_from_height, FRAME_MAX_WIDTH)
	var frame_h := frame_w / FRAME_ASPECT
	var frame_x := (viewport.x - frame_w) * 0.5
	var frame_y := viewport.y - frame_h - FRAME_BOTTOM_MARGIN
	_frame_root.position = Vector2(frame_x, frame_y)
	_frame_root.size = Vector2(frame_w, frame_h)
	_layout_direct_children(frame_w, frame_h)

func _layout_direct_children(w: float, h: float) -> void:
	var main_back := _frame_root.get_node("MainBlackIronFrame") as ColorRect
	var divider := _frame_root.get_node("MiddleDivider") as ColorRect
	main_back.position = Vector2(w * 0.010, h * 0.095)
	main_back.size = Vector2(w * 0.980, h * 0.565)
	divider.position = Vector2(w * 0.018, h * 0.355)
	divider.size = Vector2(w * 0.964, h * 0.055)
	_bottom_plate.position = Vector2(w * 0.080, h * 0.655)
	_bottom_plate.size = Vector2(w * 0.840, h * 0.175)
	_medallion.position = Vector2(w * 0.485, h * 0.705)
	_medallion.size = Vector2(w * 0.070, h * 0.180)
	_layout_slots(w, h)

func _layout_slots(w: float, h: float) -> void:
	var slot_x_start := 0.039
	var slot_x_end := 0.961
	var gap := 0.0065
	var total_w := w * (slot_x_end - slot_x_start)
	var slot_w := (total_w - (w * gap * float(SLOT_COUNT - 1))) / float(SLOT_COUNT)
	var slot_h := h * 0.180
	for i in range(_slots.size()):
		var row := int(i / SLOT_COUNT)
		var col := i % SLOT_COUNT
		var x := w * slot_x_start + float(col) * (slot_w + w * gap)
		var y := h * 0.170 if row == 0 else h * 0.435
		_slots[i].position = Vector2(x, y)
		_slots[i].size = Vector2(slot_w, slot_h)

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
		instruction.text = "Tales of Drak - Stage 4D"
	var status := controls.get_node_or_null("StatusLabel") as Label
	if status != null:
		status.text = "Stage 4D: direct approved hotbar frame."
	var debug := controls.get_node_or_null("DebugLabel") as Label
	if debug != null:
		debug.text = debug.text.replace("Stage 1I", "Stage 4D").replace("Stage 4C", "Stage 4D")
