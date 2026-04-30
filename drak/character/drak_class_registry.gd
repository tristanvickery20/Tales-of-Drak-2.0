extends Resource
class_name DrakClassRegistry

const APPROVED_CLASSES := [
	{"id": "fighter", "name": "Fighter"},
	{"id": "wizard", "name": "Wizard"},
	{"id": "cleric", "name": "Cleric"},
	{"id": "warlock", "name": "Warlock"},
	{"id": "rogue", "name": "Rogue"},
	{"id": "barbarian", "name": "Barbarian"},
	{"id": "ranger", "name": "Ranger"},
]

func get_count() -> int:
	return APPROVED_CLASSES.size()

func has_class_id(class_id: String) -> bool:
	for entry in APPROVED_CLASSES:
		if String(entry.get("id", "")) == class_id:
			return true
	return false

func get_summary_text() -> String:
	return "Approved Classes: %d\nFighter, Wizard, Cleric, Warlock, Rogue, Barbarian, Ranger" % get_count()

func get_preview_text() -> String:
	return "Stage 3C registry: Fighter, Wizard, Cleric, Warlock, Rogue, Barbarian, Ranger. No features yet."
