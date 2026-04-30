extends Resource
class_name DrakSpellcasting

@export var spellcasting_enabled := false
@export var spellcasting_ability := "None"
@export var cantrips_known := 0
@export var prepared_spells := 0
@export var level_1_slots_max := 0
@export var level_1_slots_remaining := 0

func get_summary_text() -> String:
	return "Spellcasting: %s\nSpell Ability: %s\nCantrips: %d\nLevel 1 Slots: %d / %d" % [
		"enabled" if spellcasting_enabled else "not enabled",
		spellcasting_ability,
		cantrips_known,
		level_1_slots_remaining,
		level_1_slots_max,
	]

func preview_spellcasting_shell() -> String:
	return "Spellcasting shell ready.\nNo class selected yet.\nNo spells, slots, spell lists, spell attacks, or spell saves are active in Stage 2O."
