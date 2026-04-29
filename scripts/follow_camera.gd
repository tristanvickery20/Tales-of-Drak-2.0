extends Camera3D

@export var target_path: NodePath = NodePath("../PlaceholderPlayer")
@export var follow_height := 4.0
@export var follow_distance := 8.0
@export var look_height := 1.0
@export var follow_smoothing := 8.0

var _target: Node3D

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node3D
	if _target == null:
		push_warning("Follow camera target was not found.")

func _process(delta: float) -> void:
	if _target == null:
		return

	var desired_position := _target.global_position + Vector3(0.0, follow_height, follow_distance)
	var blend := clampf(follow_smoothing * delta, 0.0, 1.0)
	global_position = global_position.lerp(desired_position, blend)
	look_at(_target.global_position + Vector3(0.0, look_height, 0.0), Vector3.UP)
