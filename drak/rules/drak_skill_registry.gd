extends Resource
class_name DrakSkillRegistry

const SKILL_TO_ABILITY := {
	"Acrobatics": "Dexterity",
	"Animal Handling": "Wisdom",
	"Arcana": "Intelligence",
	"Athletics": "Strength",
	"Deception": "Charisma",
	"History": "Intelligence",
	"Insight": "Wisdom",
	"Intimidation": "Charisma",
	"Investigation": "Intelligence",
	"Medicine": "Wisdom",
	"Nature": "Intelligence",
	"Perception": "Wisdom",
	"Performance": "Charisma",
	"Persuasion": "Charisma",
	"Religion": "Intelligence",
	"Sleight of Hand": "Dexterity",
	"Stealth": "Dexterity",
	"Survival": "Wisdom",
}

func get_ability_for_skill(skill_name: String) -> String:
	return str(SKILL_TO_ABILITY.get(skill_name, ""))

func has_skill(skill_name: String) -> bool:
	return SKILL_TO_ABILITY.has(skill_name)

func get_skill_names() -> Array[String]:
	var names: Array[String] = []
	for skill_name in SKILL_TO_ABILITY.keys():
		names.append(str(skill_name))
	names.sort()
	return names

func get_summary_text() -> String:
	return "Skill foundation loaded: %d standard skills. Test skill: Athletics." % SKILL_TO_ABILITY.size()
