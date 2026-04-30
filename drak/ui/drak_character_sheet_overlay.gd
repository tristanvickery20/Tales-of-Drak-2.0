extends CanvasLayer

const ABILITY_SCORES_SCRIPT := preload("res://drak/rules/drak_ability_scores.gd")
const DICE_ROLLER_SCRIPT := preload("res://drak/rules/drak_dice_roller.gd")
const SKILL_REGISTRY_SCRIPT := preload("res://drak/rules/drak_skill_registry.gd")
const PASSIVE_SCORES_SCRIPT := preload("res://drak/rules/drak_passive_scores.gd")
const HIT_POINTS_SCRIPT := preload("res://drak/rules/drak_hit_points.gd")
const ARMOR_CLASS_SCRIPT := preload("res://drak/rules/drak_armor_class.gd")
const SAVING_THROWS_SCRIPT := preload("res://drak/rules/drak_saving_throws.gd")
const CONDITION_TRACKER_SCRIPT := preload("res://drak/rules/drak_condition_tracker.gd")
const ACTION_ECONOMY_SCRIPT := preload("res://drak/rules/drak_action_economy.gd")
const COOLDOWN_TRACKER_SCRIPT := preload("res://drak/rules/drak_cooldown_tracker.gd")
const DAMAGE_TYPES_SCRIPT := preload("res://drak/rules/drak_damage_types.gd")
const REST_TRACKER_SCRIPT := preload("res://drak/rules/drak_rest_tracker.gd")
const LEVEL_PROGRESSION_SCRIPT := preload("res://drak/rules/drak_level_progression.gd")
const SPELLCASTING_SCRIPT := preload("res://drak/rules/drak_spellcasting.gd")

const CURRENT_STAGE_TITLE := "Tales of Drak — Stage 2O"
const CURRENT_STAGE_STATUS := "Stage 2O: spellcasting resource shell."
const CURRENT_LEVEL := 1

var _ability_scores: DrakAbilityScores = ABILITY_SCORES_SCRIPT.new()
var _dice_roller: DrakDiceRoller = DICE_ROLLER_SCRIPT.new()
var _skill_registry: DrakSkillRegistry = SKILL_REGISTRY_SCRIPT.new()
var _passive_scores: DrakPassiveScores = PASSIVE_SCORES_SCRIPT.new()
var _hit_points: DrakHitPoints = HIT_POINTS_SCRIPT.new()
var _armor_class: DrakArmorClass = ARMOR_CLASS_SCRIPT.new()
var _saving_throws: DrakSavingThrows = SAVING_THROWS_SCRIPT.new()
var _condition_tracker: DrakConditionTracker = CONDITION_TRACKER_SCRIPT.new()
var _action_economy: DrakActionEconomy = ACTION_ECONOMY_SCRIPT.new()
var _cooldown_tracker: DrakCooldownTracker = COOLDOWN_TRACKER_SCRIPT.new()
var _damage_types: DrakDamageTypes = DAMAGE_TYPES_SCRIPT.new()
var _rest_tracker: DrakRestTracker = REST_TRACKER_SCRIPT.new()
var _level_progression: DrakLevelProgression = LEVEL_PROGRESSION_SCRIPT.new()
var _spellcasting: DrakSpellcasting = SPELLCASTING_SCRIPT.new()
var _root: Control
var _sheet_button: Button
var _sheet_panel: Panel
var _sheet_text: Label
var _check_result_text: Label
var _last_scene: Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	_action_economy.reset_turn()
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
	_sheet_panel.offset_top = -280.0
	_sheet_panel.offset_right = 170.0
	_sheet_panel.offset_bottom = 280.0
	_sheet_panel.visible = false
	_sheet_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_sheet_panel)

	var box := VBoxContainer.new()
	box.name = "CharacterSheetBox"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 18.0
	box.offset_top = 10.0
	box.offset_right = -18.0
	box.offset_bottom = -10.0
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	_sheet_panel.add_child(box)

	var title := Label.new()
	title.name = "CharacterSheetTitle"
	title.text = "Stage 2O Character Sheet"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(title)

	_sheet_text = Label.new()
	_sheet_text.name = "AbilityScoresText"
	_sheet_text.text = _get_sheet_text()
	_sheet_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sheet_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_sheet_text)

	var preview_spellcasting_button := Button.new()
	preview_spellcasting_button.name = "PreviewSpellcastingButton"
	preview_spellcasting_button.text = "Preview Spellcasting"
	preview_spellcasting_button.custom_minimum_size = Vector2(270, 34)
	preview_spellcasting_button.mouse_filter = Control.MOUSE_FILTER_STOP
	preview_spellcasting_button.pressed.connect(_preview_spellcasting)
	box.add_child(preview_spellcasting_button)

	var preview_level_button := Button.new()
	preview_level_button.name = "PreviewLevelFiveButton"
	preview_level_button.text = "Preview Level 5"
	preview_level_button.custom_minimum_size = Vector2(270, 34)
	preview_level_button.mouse_filter = Control.MOUSE_FILTER_STOP
	preview_level_button.pressed.connect(_preview_level_five)
	box.add_child(preview_level_button)

	var spend_hit_die_button := Button.new()
	spend_hit_die_button.name = "SpendHitDieButton"
	spend_hit_die_button.text = "Spend Hit Die"
	spend_hit_die_button.custom_minimum_size = Vector2(270, 34)
	spend_hit_die_button.mouse_filter = Control.MOUSE_FILTER_STOP
	spend_hit_die_button.pressed.connect(_spend_hit_die)
	box.add_child(spend_hit_die_button)

	var long_rest_button := Button.new()
	long_rest_button.name = "LongRestButton"
	long_rest_button.text = "Long Rest"
	long_rest_button.custom_minimum_size = Vector2(270, 34)
	long_rest_button.mouse_filter = Control.MOUSE_FILTER_STOP
	long_rest_button.pressed.connect(_long_rest)
	box.add_child(long_rest_button)

	var preview_fire_button := Button.new()
	preview_fire_button.name = "PreviewFireDamageButton"
	preview_fire_button.text = "Preview Fire Damage"
	preview_fire_button.custom_minimum_size = Vector2(270, 34)
	preview_fire_button.mouse_filter = Control.MOUSE_FILTER_STOP
	preview_fire_button.pressed.connect(_preview_fire_damage)
	box.add_child(preview_fire_button)

	var start_cooldown_button := Button.new()
	start_cooldown_button.name = "StartCooldownButton"
	start_cooldown_button.text = "Start 5s Cooldown"
	start_cooldown_button.custom_minimum_size = Vector2(270, 34)
	start_cooldown_button.mouse_filter = Control.MOUSE_FILTER_STOP
	start_cooldown_button.pressed.connect(_start_test_cooldown)
	box.add_child(start_cooldown_button)

	_check_result_text = Label.new()
	_check_result_text.name = "CheckResultText"
	_check_result_text.text = "No preview yet."
	_check_result_text.custom_minimum_size = Vector2(270, 46)
	_check_result_text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_check_result_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_check_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_check_result_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_check_result_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_check_result_text)

	var note := Label.new()
	note.name = "CharacterSheetNote"
	note.text = "Stage 2O shell only. No spells/class lists yet."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(note)

	var close_button := Button.new()
	close_button.name = "CloseCharacterSheetButton"
	close_button.text = "Close"
	close_button.custom_minimum_size = Vector2(220, 38)
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.pressed.connect(_hide_sheet)
	box.add_child(close_button)

func _get_sheet_text() -> String:
	return "%s\n%s\n%s\n%s\n%s\n%s\n%s" % [
		_ability_scores.get_summary_text(),
		_level_progression.get_summary_text(CURRENT_LEVEL),
		_hit_points.get_summary_text(_ability_scores.get_constitution_modifier()),
		_armor_class.get_summary_text(_ability_scores.get_dexterity_modifier()),
		_rest_tracker.get_summary_text(),
		_spellcasting.get_summary_text(),
		_cooldown_tracker.get_summary_text(),
	]

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible
	if _sheet_panel.visible:
		_sheet_text.text = _get_sheet_text()

func _hide_sheet() -> void:
	_sheet_panel.visible = false

func _preview_spellcasting() -> void:
	_check_result_text.text = "Spellcasting shell ready. No spells or spell slots active yet."

func _preview_level_five() -> void:
	_check_result_text.text = "Level 5 preview: Proficiency Bonus +3. No class/race features yet."

func _spend_hit_die() -> void:
	var result := _rest_tracker.spend_hit_die(_ability_scores.get_constitution_modifier())
	_sheet_text.text = _get_sheet_text()
	if bool(result.get("spent", false)):
		_check_result_text.text = "Hit Die spent. Preview healing: %d. HP unchanged." % int(result.get("preview_healing", 0))
	else:
		_check_result_text.text = "No hit dice left. Use Long Rest to restore."

func _long_rest() -> void:
	_rest_tracker.long_rest()
	_sheet_text.text = _get_sheet_text()
	_check_result_text.text = "Long Rest: hit dice restored. HP unchanged."

func _preview_fire_damage() -> void:
	_check_result_text.text = "Preview: 4 Fire damage. HP unchanged."

func _start_test_cooldown() -> void:
	_cooldown_tracker.start_cooldown(DrakCooldownTracker.TEST_ABILITY_ID, 5.0)
	_sheet_text.text = _get_sheet_text()
	_check_result_text.text = "Test Ability cooldown: 5.0s started."

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
	for stage_name in ["Stage 1E", "Stage 1F", "Stage 1G", "Stage 1H", "Stage 1I", "Stage 2A", "Stage 2B", "Stage 2C", "Stage 2D", "Stage 2E", "Stage 2F", "Stage 2G", "Stage 2H", "Stage 2I", "Stage 2J", "Stage 2K", "Stage 2L", "Stage 2M", "Stage 2N"]:
		updated = updated.replace(stage_name, "Stage 2O")
	return updated
