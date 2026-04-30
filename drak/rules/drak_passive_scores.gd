extends Resource
class_name DrakPassiveScores

func get_passive_score(ability_modifier: int, proficiency_bonus: int = 0, proficient: bool = false) -> int:
	var applied_proficiency := proficiency_bonus if proficient else 0
	return 10 + ability_modifier + applied_proficiency

func get_passive_perception(wisdom_modifier: int, proficiency_bonus: int = 0, proficient: bool = false) -> int:
	return get_passive_score(wisdom_modifier, proficiency_bonus, proficient)

func get_summary_text(wisdom_modifier: int, proficiency_bonus: int = 0, perception_proficient: bool = false) -> String:
	var passive_perception := get_passive_perception(wisdom_modifier, proficiency_bonus, perception_proficient)
	var proficiency_text := "proficient" if perception_proficient else "not proficient"
	return "Passive Perception: %d\nPerception: %s" % [passive_perception, proficiency_text]
