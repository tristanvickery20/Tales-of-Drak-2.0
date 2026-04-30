extends StaticBody3D

const CAVE_SCENE := "res://scenes/cave_test/cave_test.tscn"
const ABILITY_SCORES_SCRIPT := preload("res://drak/rules/drak_ability_scores.gd")
const DICE_ROLLER_SCRIPT := preload("res://drak/rules/drak_dice_roller.gd")

@export var entrance_name := "Cave Entrance"
@export var check_dc := 15
@export var check_level := 1
@export var check_is_proficient := false
@export var success_transition_delay := 1.25
@export_multiline var success_line := "The stone gives way. Entering cave test cell..."
@export_multiline var failure_line := "The entrance does not budge. Try again."

var _ability_scores: DrakAbilityScores = ABILITY_SCORES_SCRIPT.new()
var _dice_roller: DrakDiceRoller = DICE_ROLLER_SCRIPT.new()
var _transition_started := false

func _ready() -> void:
	name = "VisibleCaveEntrance"
	_make_existing_cube_look_like_cave_entrance()

func interact() -> String:
	if _transition_started:
		return "Entering cave test cell..."

	var result := _dice_roller.roll_ability_check(
		"Strength",
		_ability_scores.get_strength_modifier(),
		check_level,
		check_is_proficient,
		check_dc
	)

	var result_text := _format_world_check_result(result)
	if bool(result.get("success", false)):
		_transition_started = true
		_enter_cave_after_delay()
		return result_text + "\n" + success_line

	return result_text + "\n" + failure_line

func _enter_cave_after_delay() -> void:
	var timer := get_tree().create_timer(success_transition_delay)
	timer.timeout.connect(func() -> void:
		get_tree().change_scene_to_file(CAVE_SCENE)
	)

func _format_world_check_result(result: Dictionary) -> String:
	var d20 := int(result.get("d20", 0))
	var ability_modifier := int(result.get("ability_modifier", 0))
	var proficiency_bonus := int(result.get("proficiency_bonus", 0))
	var total := int(result.get("total", 0))
	var dc := int(result.get("dc", check_dc))
	var success_text := "SUCCESS" if bool(result.get("success", false)) else "FAIL"
	return "STR Check: d20 %d + STR %s + Prof %s = %d vs DC %d — %s" % [
		d20,
		_format_signed(ability_modifier),
		_format_signed(proficiency_bonus),
		total,
		dc,
		success_text,
	]

func _format_signed(value: int) -> String:
	if value >= 0:
		return "+%d" % value
	return str(value)

func _make_existing_cube_look_like_cave_entrance() -> void:
	var mesh_instance := get_node_or_null("InteractableMesh") as MeshInstance3D
	if mesh_instance != null:
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(0.55, 0.05, 0.05, 1.0)
		mesh_instance.material_override = material
		mesh_instance.scale = Vector3(1.6, 2.0, 0.6)

	var label := get_node_or_null("InteractableLabel") as Label3D
	if label != null:
		label.text = "CAVE ENTRANCE\nSTR CHECK DC 15"
		label.position = Vector3(0, 1.55, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
