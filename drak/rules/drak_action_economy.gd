extends Resource
class_name DrakActionEconomy

@export var max_movement_feet := 30

var action_available := true
var bonus_action_available := true
var reaction_available := true
var movement_remaining_feet := 30

func reset_turn() -> void:
	action_available = true
	bonus_action_available = true
	reaction_available = true
	movement_remaining_feet = max_movement_feet

func use_action() -> bool:
	if not action_available:
		return false
	action_available = false
	return true

func use_bonus_action() -> bool:
	if not bonus_action_available:
		return false
	bonus_action_available = false
	return true

func use_reaction() -> bool:
	if not reaction_available:
		return false
	reaction_available = false
	return true

func use_movement(feet: int) -> int:
	var used := clampi(feet, 0, movement_remaining_feet)
	movement_remaining_feet -= used
	return used

func get_summary_text() -> String:
	return "Action: %s\nBonus Action: %s\nReaction: %s\nMovement: %d ft" % [
		_available_text(action_available),
		_available_text(bonus_action_available),
		_available_text(reaction_available),
		movement_remaining_feet,
	]

func _available_text(value: bool) -> String:
	return "available" if value else "used"
