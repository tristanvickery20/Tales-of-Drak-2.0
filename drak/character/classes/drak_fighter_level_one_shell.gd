extends Resource
class_name DrakFighterLevelOneShell

const CLASS_ID := "fighter"
const CLASS_NAME := "Fighter"
const LEVEL := 1
const HIT_DIE := "d10"
const PRIMARY_ROLE := "martial front-line placeholder"
const SAVING_THROW_PROFICIENCIES := ["Strength", "Constitution"]

func get_summary_text() -> String:
	return "Fighter Level 1 Shell\nHit Die: %s\nSaves: STR, CON\nFeatures: not active yet" % HIT_DIE

func get_preview_text() -> String:
	return "Stage 3D Fighter shell only. Hit die/saves are labels; no features, gear, or combat yet."
