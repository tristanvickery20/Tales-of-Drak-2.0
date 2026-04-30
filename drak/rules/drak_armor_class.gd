extends Resource
class_name DrakArmorClass

@export var base_armor_class := 10
@export var shield_bonus := 0
@export var armor_bonus := 0

func get_unarmored_armor_class(dexterity_modifier: int) -> int:
	# Stage 2G placeholder: base 10 + DEX modifier.
	# Later class/race/equipment systems can override this through adapters.
	return base_armor_class + dexterity_modifier + shield_bonus + armor_bonus

func get_summary_text(dexterity_modifier: int) -> String:
	return "Armor Class: %d\nFormula: 10 + DEX %s" % [
		get_unarmored_armor_class(dexterity_modifier),
		_format_signed(dexterity_modifier),
	]

func _format_signed(value: int) -> String:
	if value >= 0:
		return "+%d" % value
	return str(value)
