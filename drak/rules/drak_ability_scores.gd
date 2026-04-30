extends Resource
class_name DrakAbilityScores

@export var strength := 15
@export var dexterity := 14
@export var constitution := 13
@export var intelligence := 12
@export var wisdom := 10
@export var charisma := 8

func get_modifier(score: int) -> int:
	return floori((float(score) - 10.0) / 2.0)

func get_strength_modifier() -> int:
	return get_modifier(strength)

func get_dexterity_modifier() -> int:
	return get_modifier(dexterity)

func get_constitution_modifier() -> int:
	return get_modifier(constitution)

func get_intelligence_modifier() -> int:
	return get_modifier(intelligence)

func get_wisdom_modifier() -> int:
	return get_modifier(wisdom)

func get_charisma_modifier() -> int:
	return get_modifier(charisma)

func get_modifier_for_ability(ability_name: String) -> int:
	match ability_name:
		"Strength":
			return get_strength_modifier()
		"Dexterity":
			return get_dexterity_modifier()
		"Constitution":
			return get_constitution_modifier()
		"Intelligence":
			return get_intelligence_modifier()
		"Wisdom":
			return get_wisdom_modifier()
		"Charisma":
			return get_charisma_modifier()
		_:
			return 0

func format_modifier(modifier: int) -> String:
	if modifier >= 0:
		return "+%d" % modifier
	return str(modifier)

func get_summary_text() -> String:
	return "STR %d (%s)\nDEX %d (%s)\nCON %d (%s)\nINT %d (%s)\nWIS %d (%s)\nCHA %d (%s)" % [
		strength, format_modifier(get_strength_modifier()),
		dexterity, format_modifier(get_dexterity_modifier()),
		constitution, format_modifier(get_constitution_modifier()),
		intelligence, format_modifier(get_intelligence_modifier()),
		wisdom, format_modifier(get_wisdom_modifier()),
		charisma, format_modifier(get_charisma_modifier()),
	]
