extends Resource
class_name DrakHotbarFoundationManifest

const STAGE_ID := "Stage 4A"

const HOTBAR_SLOTS := [
	"Weapon Attack",
	"Class Feature",
	"Cantrip / Ranged",
	"Defensive Ability",
	"Heal / Recovery",
	"Control Ability",
	"Tame / Pet Command",
	"Dodge / Utility",
]

func get_summary_text() -> String:
	return "%s Hotbar Foundation\nSlots: %d planned" % [STAGE_ID, HOTBAR_SLOTS.size()]

func get_preview_text() -> String:
	return "Stage 4A hotbar plan: 8 inactive slots. No combat, damage, enemies, or abilities yet."
