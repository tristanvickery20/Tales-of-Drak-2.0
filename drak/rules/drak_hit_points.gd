extends Resource
class_name DrakHitPoints

@export var level := 1
@export var hit_die_size := 10
@export var current_hit_points := 11

func get_max_hit_points(constitution_modifier: int) -> int:
	# Stage 2G placeholder: level 1 max HP = hit die max + CON modifier.
	# Later class data will provide the correct hit die size.
	return max(1, hit_die_size + constitution_modifier)

func get_current_hit_points(constitution_modifier: int) -> int:
	return clampi(current_hit_points, 0, get_max_hit_points(constitution_modifier))

func get_summary_text(constitution_modifier: int) -> String:
	return "HP: %d / %d\nHit Die: d%d" % [
		get_current_hit_points(constitution_modifier),
		get_max_hit_points(constitution_modifier),
		hit_die_size,
	]
