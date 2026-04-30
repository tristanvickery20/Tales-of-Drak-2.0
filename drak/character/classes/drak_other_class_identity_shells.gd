extends Resource
class_name DrakOtherClassIdentityShells

const OTHER_CLASSES := [
	{"id": "rogue", "name": "Rogue", "role": "skill/expert placeholder"},
	{"id": "barbarian", "name": "Barbarian", "role": "martial durability placeholder"},
	{"id": "ranger", "name": "Ranger", "role": "martial/nature placeholder"},
]

func get_count() -> int:
	return OTHER_CLASSES.size()

func get_summary_text() -> String:
	return "Other Shells: Rogue, Barbarian, Ranger"

func get_preview_text() -> String:
	return "Stage 3F class shells only. Rogue/Barbarian/Ranger labels; no features or combat yet."
