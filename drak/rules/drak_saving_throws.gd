extends Resource
class_name DrakSavingThrows

const SAVE_ABILITIES := [
	"Strength",
	"Dexterity",
	"Constitution",
	"Intelligence",
	"Wisdom",
	"Charisma",
]

func has_saving_throw(ability_name: String) -> bool:
	return SAVE_ABILITIES.has(ability_name)

func get_summary_text() -> String:
	return "Saving Throws: STR, DEX, CON, INT, WIS, CHA\nTest Save: Dexterity DC 13"

func format_save_name(ability_name: String) -> String:
	if has_saving_throw(ability_name):
		return ability_name + " Saving Throw"
	return "Unknown Saving Throw"
