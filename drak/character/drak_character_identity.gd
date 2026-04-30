extends Resource
class_name DrakCharacterIdentity

@export var character_name := "Drak Test Hero"
@export var race_species_id := "variant_human"
@export var race_species_name := "Variant Human"
@export var class_id := "fighter"
@export var class_name := "Fighter"
@export var level := 1

func get_summary_text() -> String:
	return "Character: %s\nRace/Species: %s\nClass: %s\nLevel: %d" % [
		character_name,
		race_species_name,
		class_name,
		level,
	]

func get_preview_text() -> String:
	return "Stage 3A identity shell: %s, %s %d. No traits/features/combat yet." % [
		race_species_name,
		class_name,
		level,
	]
