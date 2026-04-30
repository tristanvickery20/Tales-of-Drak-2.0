extends Resource
class_name DrakDiceRoller

var _rng := RandomNumberGenerator.new()

func _init() -> void:
	_rng.randomize()

func roll_d20() -> int:
	return _rng.randi_range(1, 20)

func get_proficiency_bonus(level: int) -> int:
	var safe_level := clampi(level, 1, 20)
	return 2 + floori(float(safe_level - 1) / 4.0)

func roll_ability_check(ability_name: String, ability_modifier: int, level: int = 1, proficient: bool = false, dc: int = 10) -> Dictionary:
	var d20 := roll_d20()
	var proficiency_bonus := get_proficiency_bonus(level) if proficient else 0
	var total := d20 + ability_modifier + proficiency_bonus
	return {
		"ability_name": ability_name,
		"d20": d20,
		"ability_modifier": ability_modifier,
		"proficiency_bonus": proficiency_bonus,
		"level": level,
		"proficient": proficient,
		"dc": dc,
		"total": total,
		"success": total >= dc,
	}

func format_check_result(result: Dictionary) -> String:
	var proficient_text := "proficient" if bool(result.get("proficient", false)) else "not proficient"
	var success_text := "SUCCESS" if bool(result.get("success", false)) else "FAIL"
	var ability_name := str(result.get("ability_name", "Ability"))
	var d20 := int(result.get("d20", 0))
	var ability_modifier := int(result.get("ability_modifier", 0))
	var proficiency_bonus := int(result.get("proficiency_bonus", 0))
	var total := int(result.get("total", 0))
	var dc := int(result.get("dc", 10))

	return "%s Check (%s)\nd20: %d\nAbility Mod: %s\nProficiency: %s\nTotal: %d vs DC %d\n%s" % [
		ability_name,
		proficient_text,
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
