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
const RULES_MANIFEST_SCRIPT := preload("res://drak/rules/drak_rules_manifest.gd")

const CURRENT_STAGE_TITLE := "Tales of Drak — Stage 4B"
const CURRENT_STAGE_STATUS := "Stage 4B: inactive mobile hotbar shell."
const CURRENT_LEVEL := 1

const CHARACTER_NAME := "Drak Test Hero"
const RACE_SPECIES_NAME := "Variant Human"
const CLASS_NAME := "Fighter"

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
var _rules_manifest: DrakRulesManifest = RULES_MANIFEST_SCRIPT.new()
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
	_sheet_panel.offset_left = -180.0
	_sheet_panel.offset_top = -240.0
	_sheet_panel.offset_right = 180.0
	_sheet_panel.offset_bottom = 240.0
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
	title.text = "Stage 4B Sheet"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(title)

	_sheet_text = Label.new()
	_sheet_text.name = "SheetSummaryText"
	_sheet_text.text = _get_sheet_text()
	_sheet_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_sheet_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_sheet_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_sheet_text)

	_add_button(box, "Hotbar Shell", _preview_hotbar_shell)
	_add_button(box, "Stage 4 Plan", _preview_stage4_plan)
	_add_button(box, "Stage 3 Audit", _preview_stage3_audit)
	_add_button(box, "Fighter 1", _preview_fighter_level_one_shell)
	_add_button(box, "Classes", _preview_class_registry)
	_add_button(box, "Races", _preview_race_species_registry)
	_add_button(box, "Identity", _preview_character_identity)
	_add_button(box, "Rules Audit", _preview_rules_audit)

	_check_result_text = Label.new()
	_check_result_text.name = "CheckResultText"
	_check_result_text.text = "Tap a button for details."
	_check_result_text.custom_minimum_size = Vector2(270, 44)
	_check_result_text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_check_result_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_check_result_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_check_result_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_check_result_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_check_result_text)

	var note := Label.new()
	note.name = "CharacterSheetNote"
	note.text = "Hotbar is visible but inactive. No combat/damage/enemies yet."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(note)

	_add_button(box, "Close", _hide_sheet, Vector2(220, 36))

func _add_button(parent: Control, text: String, callback: Callable, min_size := Vector2(270, 32)) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = min_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.pressed.connect(callback)
	parent.add_child(button)

func _get_sheet_text() -> String:
	return "%s\nStage 4B: inactive mobile hotbar shell\nVisible hotbar: 8 labels / 2 rows\nCombat style: SWTOR-style buttons + cooldowns\nRules: D&D math backbone, not turn-based" % [_get_character_identity_summary()]

func _get_character_identity_summary() -> String:
	return "%s — %s %s %d" % [CHARACTER_NAME, RACE_SPECIES_NAME, CLASS_NAME, CURRENT_LEVEL]

func _toggle_sheet() -> void:
	_sheet_panel.visible = not _sheet_panel.visible
	if _sheet_panel.visible:
		_sheet_text.text = _get_sheet_text()

func _hide_sheet() -> void:
	_sheet_panel.visible = false

func _preview_hotbar_shell() -> void:
	_check_result_text.text = "Stage 4B: visible 2-row hotbar shell only. Slots are labels; no actions yet."

func _preview_stage4_plan() -> void:
	_check_result_text.text = "Stage 4 plan: retry art only after baseline placement is confirmed."

func _preview_stage3_audit() -> void:
	_check_result_text.text = "Stage 3 preserved: identity, approved races/classes, and class shells."

func _preview_fighter_level_one_shell() -> void:
	_check_result_text.text = "Fighter 1 shell preserved. No active features/combat yet."

func _preview_class_registry() -> void:
	_check_result_text.text = "Approved classes: Fighter, Wizard, Cleric, Warlock, Rogue, Barbarian, Ranger."

func _preview_race_species_registry() -> void:
	_check_result_text.text = "Approved races: Elf, Variant Human, Dwarf, Orc. No traits/stat changes."

func _preview_character_identity() -> void:
	_check_result_text.text = "Identity: Variant Human Fighter 1. Labels only for now."

func _preview_rules_audit() -> void:
	_check_result_text.text = "Stage 2 rules foundation preserved for future real-time combat."

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
	for stage_name in ["Stage 11", "Stage 1I", "Stage 1E", "Stage 1F", "Stage 1G", "Stage 1H", "Stage 2A", "Stage 2B", "Stage 2C", "Stage 2D", "Stage 2E", "Stage 2F", "Stage 2G", "Stage 2H", "Stage 2I", "Stage 2J", "Stage 2K", "Stage 2L", "Stage 2M", "Stage 2N", "Stage 2O", "Stage 2P", "Stage 2Q", "Stage 2R", "Stage 3A", "Stage 3B", "Stage 3C", "Stage 3D", "Stage 3E", "Stage 3F", "Stage 3G", "Stage 4A", "Stage 4C"]:
		updated = updated.replace(stage_name, "Stage 4B")
	return updated
