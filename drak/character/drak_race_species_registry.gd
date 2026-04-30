extends Resource
class_name DrakRaceSpeciesRegistry

const APPROVED_RACE_SPECIES := [
	{"id": "elf", "name": "Elf"},
	{"id": "variant_human", "name": "Variant Human"},
	{"id": "dwarf", "name": "Dwarf"},
	{"id": "orc", "name": "Orc"},
]

func get_count() -> int:
	return APPROVED_RACE_SPECIES.size()

func has_race_species_id(race_species_id: String) -> bool:
	for entry in APPROVED_RACE_SPECIES:
		if String(entry.get("id", "")) == race_species_id:
			return true
	return false

func get_summary_text() -> String:
	return "Approved Race/Species: %d\nElf, Variant Human, Dwarf, Orc" % get_count()

func get_preview_text() -> String:
	return "Stage 3B registry: Elf, Variant Human, Dwarf, Orc. No traits/stat changes yet."
