extends Resource
class_name DrakLevelProgression

const MIN_LEVEL := 1
const MAX_LEVEL := 5

func clamp_supported_level(level: int) -> int:
	return clampi(level, MIN_LEVEL, MAX_LEVEL)

func get_proficiency_bonus(level: int) -> int:
	var safe_level := clamp_supported_level(level)
	return 2 + floori(float(safe_level - 1) / 4.0)

func get_summary_text(current_level: int = 1) -> String:
	var safe_level := clamp_supported_level(current_level)
	return "Level Range: %d-%d\nCurrent Level: %d\nProficiency Bonus: +%d" % [
		MIN_LEVEL,
		MAX_LEVEL,
		safe_level,
		get_proficiency_bonus(safe_level),
	]

func preview_level(level: int) -> String:
	var safe_level := clamp_supported_level(level)
	return "Level %d Preview\nProficiency Bonus: +%d\nClass/race features are not added yet." % [
		safe_level,
		get_proficiency_bonus(safe_level),
	]
