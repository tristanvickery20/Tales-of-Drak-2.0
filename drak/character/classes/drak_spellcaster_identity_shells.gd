extends Resource
class_name DrakSpellcasterIdentityShells

const SPELLCASTER_CLASSES := [
	{"id": "wizard", "name": "Wizard", "spell_ability": "Intelligence"},
	{"id": "cleric", "name": "Cleric", "spell_ability": "Wisdom"},
	{"id": "warlock", "name": "Warlock", "spell_ability": "Charisma"},
]

func get_count() -> int:
	return SPELLCASTER_CLASSES.size()

func get_summary_text() -> String:
	return "Caster Shells: Wizard INT, Cleric WIS, Warlock CHA"

func get_preview_text() -> String:
	return "Stage 3E caster shells only. Wizard/Cleric/Warlock labels; no spells or slots yet."
