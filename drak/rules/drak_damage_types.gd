extends Resource
class_name DrakDamageTypes

const DAMAGE_TYPES := [
	"Acid",
	"Bludgeoning",
	"Cold",
	"Fire",
	"Force",
	"Lightning",
	"Necrotic",
	"Piercing",
	"Poison",
	"Psychic",
	"Radiant",
	"Slashing",
	"Thunder",
]

func has_damage_type(damage_type: String) -> bool:
	return DAMAGE_TYPES.has(damage_type)

func get_damage_type_count() -> int:
	return DAMAGE_TYPES.size()

func get_summary_text() -> String:
	return "Damage Types: %d loaded\nPreview Type: Fire" % get_damage_type_count()

func preview_damage(damage_type: String, amount: int) -> String:
	if not has_damage_type(damage_type):
		return "Unknown damage type: " + damage_type
	return "Preview only: %d %s damage\nNo HP is reduced in Stage 2L." % [amount, damage_type]
