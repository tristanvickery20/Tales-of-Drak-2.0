extends CanvasLayer

const ABILITY_SCORES_SCRIPT := preload("res://drak/rules/drak_ability_scores.gd")
const DICE_ROLLER_SCRIPT := preload("res://drak/rules/drak_dice_roller.gd")

var _ability_scores: DrakAbilityScores = ABILITY_SCORES_SCRIPT.new()
var _dice_roller: DrakDiceRoller = DICE_ROLLER_SCRIPT.new()
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
	_sheet_panel.offset_left = -165.0
	_sheet_panel.offset_top = -210.0
	_sheet_panel.offset_right = 165.0
	_sheet_panel.offset_bottom = 210.0
	_sheet_panel.visible = false
	_sheet_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_sheet_panel)

	var box := VBoxContainer.new()
	box.name = "CharacterSheetBox"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 18.0
	box.offset_top = 16.0
	box.offset_right = -18.0
	box.offset_bottom = -16.0
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	_sheet_panel.add_child(box)

	var title := Label.new()
	title.name = "CharacterSheetTitle"
	title.text = "Stage 2B Character Sheet"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(title)

	_sheet_text = Label.new()
	_sheet_text.name = "AbilityScoresText"
	_sheet_text.text = _get_sheet_text()
	_sheet_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sheet_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_sheet_text)

	var roll_button := Button.new()
	roll_button.name = "RollStrengthCheckButton"
	roll_button.text = "Roll STR Check DC 10"
	roll_button.custom_minimum_size = Vector2(260, 52)
	roll_button.mouse_filter = Control.MOUSE_FILTER_STOP
	roll_button.pressed.connect(_roll_strength_check)
	box.add_child(roll_button)

	var proficient_roll_button := Button.new()
	proficient_roll_button.name = "RollProficientDexCheckButton"
	proficient_roll_button.text = "Roll Proficient DEX Check DC 12"
	proficient_roll_button.custom_minimum_size = Vector2(260, 52)
	proficient_roll_button.mouse_filter = Control.MOUSE_FILTER_STOP
	proficient_roll_button.pressed.connect(_roll_proficient_dex_check)
	box.add_child(proficient_roll_button)

	_check_result_text = Label.new()
	_check_result_text.name = "CheckResultText"
	_check_result_text.text = "No check rolled yet."
	_check_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_check_result_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_check_result_text)

	var note := Label.new()
	note.name = "CharacterSheetNote"
	note.text = "Stage 2B only: ability mods, proficiency bonus, and simple d20 checks."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(note)

	var close_button := Button.new()
	close_button.name = "CloseCharacterSheetButton"
	close_button.text = "Close"
	close_button.custom_minimum_size = Vector2(220, 52)
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.pressed.connect(_hide_sheet)
	box.add_child(close_button)

func _get_sheet_text() -> String:
	return "%s\nLevel 1 Proficiency Bonus: +%d" % [
		_ability_scores.get_summary_text(),
		_dice_roller.get_proficiency_bonus(1),
	]

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible
	if _sheet_panel.visible:
		_sheet_text.text = _get_sheet_text()

func _hide_sheet() -> void:
	_sheet_panel.visible = false

func _roll_strength_check() -> void:
	var result := _dice_roller.roll_ability_check("Strength", _ability_scores.get_strength_modifier(), 1, false, 10)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _roll_proficient_dex_check() -> void:
	var result := _dice_roller.roll_ability_check("Dexterity", _ability_scores.get_dexterity_modifier(), 1, true, 12)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _update_visibility() -> void:
	var scene := get_tree().current_scene
	var in_playable_scene := scene != null and scene.get_node_or_null("PlaceholderPlayer") != null
	_root.visible = in_playable_scene
	if not in_playable_scene:
		_hide_sheet()
