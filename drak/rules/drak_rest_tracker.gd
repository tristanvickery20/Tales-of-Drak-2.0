extends Resource
class_name DrakRestTracker

@export var hit_die_size := 10
@export var max_hit_dice := 1

var hit_dice_remaining := 1
var _rng := RandomNumberGenerator.new()

func _init() -> void:
	_rng.randomize()
	hit_dice_remaining = max_hit_dice

func spend_hit_die(constitution_modifier: int) -> Dictionary:
	if hit_dice_remaining <= 0:
		return {
			"spent": false,
			"roll": 0,
			"constitution_modifier": constitution_modifier,
			"preview_healing": 0,
			"hit_dice_remaining": hit_dice_remaining,
		}

	hit_dice_remaining -= 1
	var roll := _rng.randi_range(1, hit_die_size)
	var preview_healing := max(1, roll + constitution_modifier)
	return {
		"spent": true,
		"roll": roll,
		"constitution_modifier": constitution_modifier,
		"preview_healing": preview_healing,
		"hit_dice_remaining": hit_dice_remaining,
	}

func long_rest() -> void:
	hit_dice_remaining = max_hit_dice

func get_summary_text() -> String:
	return "Hit Dice: %d / %d d%d\nRest Test: spend hit die / long rest" % [
		hit_dice_remaining,
		max_hit_dice,
		hit_die_size,
	]

func format_spend_result(result: Dictionary) -> String:
	if not bool(result.get("spent", false)):
		return "No hit dice remaining. Use Long Rest to restore.\n" + get_summary_text()

	return "Spent 1 Hit Die.\nRoll: d%d = %d\nCON Mod: %s\nPreview Healing: %d\nNo HP is changed in Stage 2M." % [
		hit_die_size,
		int(result.get("roll", 0)),
		_format_signed(int(result.get("constitution_modifier", 0))),
		int(result.get("preview_healing", 0)),
	]

func _format_signed(value: int) -> String:
	if value >= 0:
		return "+%d" % value
	return str(value)
