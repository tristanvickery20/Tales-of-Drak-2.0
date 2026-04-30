extends Resource
class_name DrakRulesManifest

const STAGE_ID := "Stage 2P"

const FOUNDATION_MODULES := [
	"Ability Scores",
	"Modifiers",
	"Proficiency Bonus",
	"D20 Checks",
	"Skill Registry",
	"Passive Perception",
	"Advantage / Disadvantage",
	"HP Placeholder",
	"Armor Class Placeholder",
	"Saving Throws",
	"Prone Condition Toggle",
	"Action Economy Backbone",
	"Cooldown Tracker",
	"Damage Type Registry",
	"Hit Dice / Rest Tracker",
	"Level Range 1-5",
	"Spellcasting Shell",
]

func get_summary_text() -> String:
	return "%s Rules Manifest\nModules: %d loaded" % [STAGE_ID, FOUNDATION_MODULES.size()]

func get_audit_text() -> String:
	return "Stage 2 rules audit: %d foundations loaded. No combat/classes/races/quests yet." % FOUNDATION_MODULES.size()
