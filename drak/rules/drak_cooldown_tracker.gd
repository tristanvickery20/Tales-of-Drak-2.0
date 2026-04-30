extends Resource
class_name DrakCooldownTracker

const TEST_ABILITY_ID := "test_ability"
const TEST_ABILITY_NAME := "Test Ability"

var _cooldowns := {}

func start_cooldown(ability_id: String, seconds: float) -> void:
	_cooldowns[ability_id] = maxf(seconds, 0.0)

func tick(seconds: float) -> void:
	var keys := _cooldowns.keys()
	for ability_id in keys:
		var remaining := float(_cooldowns.get(ability_id, 0.0))
		remaining = maxf(remaining - seconds, 0.0)
		if remaining <= 0.0:
			_cooldowns.erase(ability_id)
		else:
			_cooldowns[ability_id] = remaining

func is_on_cooldown(ability_id: String) -> bool:
	return float(_cooldowns.get(ability_id, 0.0)) > 0.0

func get_remaining(ability_id: String) -> float:
	return float(_cooldowns.get(ability_id, 0.0))

func clear_all() -> void:
	_cooldowns.clear()

func get_summary_text() -> String:
	var remaining := get_remaining(TEST_ABILITY_ID)
	if remaining <= 0.0:
		return "Cooldowns: none\nTest Ability: ready"
	return "Cooldowns: active\nTest Ability: %.1fs remaining" % remaining
