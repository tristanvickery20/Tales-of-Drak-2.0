extends CanvasLayer

const ABILITY_SCORES_SCRIPT := preload("res://drak/rules/drak_ability_scores.gd")
const DICE_ROLLER_SCRIPT := preload("res://drak/rules/drak_dice_roller.gd")
const SKILL_REGISTRY_SCRIPT := preload("res://drak/rules/drak_skill_registry.gd")
const PASSIVE_SCORES_SCRIPT := preload("res://drak/rules/drak_passive_scores.gd")

const CURRENT_STAGE_TITLE := "Tales of Drak — Stage 2F"
const CURRENT_STAGE_STATUS := "Stage 2F: advantage/disadvantage rules test."

var _ability_scores: DrakAbilityScores = ABILITY_SCORES_SCRIPT.new()
var _dice_roller: DrakDiceRoller = DICE_ROLLER_SCRIPT.new()
var _skill_registry: DrakSkillRegistry = SKILL_REGISTRY_SCRIPT.new()
var _passive_scores: DrakPassiveScores = PASSIVE_SCORES_SCRIPT.new()
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
	_sheet_panel.offset_left = -170.0
	_sheet_panel.offset_top = -252.0
	_sheet_panel.offset_right = 170.0
	_sheet_panel.offset_bottom = 252.0
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
	title.name = "CharacterSheetTitle"
	title.text = "Stage 2F Character Sheet"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(title)

	_sheet_text = Label.new()
	_sheet_text.name = "AbilityScoresText"
	_sheet_text.text = _get_sheet_text()
	_sheet_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sheet_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_sheet_text)

	var normal_button := Button.new()
	normal_button.name = "RollNormalStrengthCheckButton"
	normal_button.text = "Normal STR DC 12"
	normal_button.custom_minimum_size = Vector2(270, 42)
	normal_button.mouse_filter = Control.MOUSE_FILTER_STOP
	normal_button.pressed.connect(_roll_normal_strength_check)
	box.add_child(normal_button)

	var advantage_button := Button.new()
	advantage_button.name = "RollAdvantageStrengthCheckButton"
	advantage_button.text = "Advantage STR DC 12"
	advantage_button.custom_minimum_size = Vector2(270, 42)
	advantage_button.mouse_filter = Control.MOUSE_FILTER_STOP
	advantage_button.pressed.connect(_roll_advantage_strength_check)
	box.add_child(advantage_button)

	var disadvantage_button := Button.new()
	disadvantage_button.name = "RollDisadvantageStrengthCheckButton"
	disadvantage_button.text = "Disadvantage STR DC 12"
	disadvantage_button.custom_minimum_size = Vector2(270, 42)
	disadvantage_button.mouse_filter = Control.MOUSE_FILTER_STOP
	disadvantage_button.pressed.connect(_roll_disadvantage_strength_check)
	box.add_child(disadvantage_button)

	var athletics_button := Button.new()
	athletics_button.name = "RollAthleticsCheckButton"
	athletics_button.text = "Athletics DC 12"
	athletics_button.custom_minimum_size = Vector2(270, 42)
	athletics_button.mouse_filter = Control.MOUSE_FILTER_STOP
	athletics_button.pressed.connect(_roll_athletics_check)
	box.add_child(athletics_button)

	var perception_button := Button.new()
	perception_button.name = "ShowPassivePerceptionButton"
	perception_button.text = "Show Passive Perception"
	perception_button.custom_minimum_size = Vector2(270, 42)
	perception_button.mouse_filter = Control.MOUSE_FILTER_STOP
	perception_button.pressed.connect(_show_passive_perception)
	box.add_child(perception_button)

	_check_result_text = Label.new()
	_check_result_text.name = "CheckResultText"
	_check_result_text.text = "No check rolled yet."
	_check_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_check_result_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_check_result_text)

	var note := Label.new()
	note.name = "CharacterSheetNote"
	note.text = "Stage 2F: advantage/disadvantage added to checks. No combat/classes/races yet."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(note)

	var close_button := Button.new()
	close_button.name = "CloseCharacterSheetButton"
	close_button.text = "Close"
	close_button.custom_minimum_size = Vector2(220, 44)
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.pressed.connect(_hide_sheet)
	box.add_child(close_button)

func _get_sheet_text() -> String:
	var proficiency_bonus := _dice_roller.get_proficiency_bonus(1)
	return "%s\nLevel 1 Proficiency Bonus: +%d\n%s\n%s" % [
		_ability_scores.get_summary_text(),
		proficiency_bonus,
		_skill_registry.get_summary_text(),
		_passive_scores.get_summary_text(_ability_scores.get_wisdom_modifier(), proficiency_bonus, false),
	]

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible
	if _sheet_panel.visible:
		_sheet_text.text = _get_sheet_text()

func _hide_sheet() -> void:
	_sheet_panel.visible = false

func _roll_normal_strength_check() -> void:
	var result := _dice_roller.roll_ability_check("Strength", _ability_scores.get_strength_modifier(), 1, false, 12)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _roll_advantage_strength_check() -> void:
	var result := _dice_roller.roll_ability_check("Strength", _ability_scores.get_strength_modifier(), 1, false, 12, DrakDiceRoller.ROLL_ADVANTAGE)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _roll_disadvantage_strength_check() -> void:
	var result := _dice_roller.roll_ability_check("Strength", _ability_scores.get_strength_modifier(), 1, false, 12, DrakDiceRoller.ROLL_DISADVANTAGE)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _roll_athletics_check() -> void:
	var skill_name := "Athletics"
	var ability_name := _skill_registry.get_ability_for_skill(skill_name)
	var result := _dice_roller.roll_ability_check(skill_name + " (" + ability_name + ")", _ability_scores.get_modifier_for_ability(ability_name), 1, true, 12)
	_check_result_text.text = _dice_roller.format_check_result(result)

func _show_passive_perception() -> void:
	var proficiency_bonus := _dice_roller.get_proficiency_bonus(1)
	_check_result_text.text = "Passive Perception = 10 + WIS %s + Prof +0 = %d" % [
		_ability_scores.format_modifier(_ability_scores.get_wisdom_modifier()),
		_passive_scores.get_passive_perception(_ability_scores.get_wisdom_modifier(), proficiency_bonus, false),
	]

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
	for stage_name in ["Stage 1E", "Stage 1F", "Stage 1G", "Stage 1H", "Stage 1I", "Stage 2A", "Stage 2B", "Stage 2C", "Stage 2D", "Stage 2E"]:
		updated = updated.replace(stage_name, "Stage 2F")
	return updated
