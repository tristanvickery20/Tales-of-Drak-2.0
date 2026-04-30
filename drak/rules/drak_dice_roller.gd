extends Resource
class_name DrakDiceRoller

const ROLL_NORMAL := "normal"
const ROLL_ADVANTAGE := "advantage"
const ROLL_DISADVANTAGE := "disadvantage"

var _rng := RandomNumberGenerator.new()

func _init() -> void:
	_rng.randomize()

func roll_d20() -> int:
	return _rng.randi_range(1, 20)

func roll_d20_with_mode(roll_mode: String = ROLL_NORMAL) -> Dictionary:
	var first_roll := roll_d20()
	var second_roll := 0
	var chosen_roll := first_roll
	var mode := roll_mode

	if mode == ROLL_ADVANTAGE or mode == ROLL_DISADVANTAGE:
		second_roll = roll_d20()
		if mode == ROLL_ADVANTAGE:
			chosen_roll = maxi(first_roll, second_roll)
		else:
			chosen_roll = mini(first_roll, second_roll)
	else:
		mode = ROLL_NORMAL

	return {
		"roll_mode": mode,
		"d20": chosen_roll,
		"first_roll": first_roll,
		"second_roll": second_roll,
	}

func get_proficiency_bonus(level: int) -> int:
	var safe_level := clampi(level, 1, 20)
	return 2 + floori(float(safe_level - 1) / 4.0)

func roll_ability_check(ability_name: String, ability_modifier: int, level: int = 1, proficient: bool = false, dc: int = 10, roll_mode: String = ROLL_NORMAL) -> Dictionary:
	var roll_data := roll_d20_with_mode(roll_mode)
	var d20 := int(roll_data.get("d20", 0))
	var proficiency_bonus := get_proficiency_bonus(level) if proficient else 0
	var total := d20 + ability_modifier + proficiency_bonus
	return {
		"ability_name": ability_name,
		"d20": d20,
		"first_roll": int(roll_data.get("first_roll", d20)),
		"second_roll": int(roll_data.get("second_roll", 0)),
		"roll_mode": str(roll_data.get("roll_mode", ROLL_NORMAL)),
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
	var roll_mode := str(result.get("roll_mode", ROLL_NORMAL))
	var d20 := int(result.get("d20", 0))
	var first_roll := int(result.get("first_roll", d20))
	var second_roll := int(result.get("second_roll", 0))
	var ability_modifier := int(result.get("ability_modifier", 0))
	var proficiency_bonus := int(result.get("proficiency_bonus", 0))
	var total := int(result.get("total", 0))
	var dc := int(result.get("dc", 10))

	return "%s Check (%s)\nRoll: %s\nAbility Mod: %s\nProficiency: %s\nTotal: %d vs DC %d\n%s" % [
		ability_name,
		proficient_text,
		_format_roll_text(roll_mode, d20, first_roll, second_roll),
		_format_signed(ability_modifier),
		_format_signed(proficiency_bonus),
		total,
		dc,
		success_text,
	]

func _format_roll_text(roll_mode: String, d20: int, first_roll: int, second_roll: int) -> String:
	if roll_mode == ROLL_ADVANTAGE:
		return "advantage %d/%d -> %d" % [first_roll, second_roll, d20]
	if roll_mode == ROLL_DISADVANTAGE:
		return "disadvantage %d/%d -> %d" % [first_roll, second_roll, d20]
	return "d20 %d" % d20

func _format_signed(value: int) -> String:
	if value >= 0:
		return "+%d" % value
	return str(value)
