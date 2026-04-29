extends Camera3D

@export var target_path: NodePath = NodePath("../PlaceholderPlayer")
@export var follow_height := 4.0
@export var follow_distance := 8.0
@export var look_height := 1.0
@export var follow_smoothing := 8.0
@export var orbit_speed := 1.8

var _target: Node3D
var _orbit_angle := 0.0
var _orbit_input := 0.0

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node3D
	if _target == null:
		push_warning("Follow camera target was not found.")

func _process(delta: float) -> void:
	if _target == null:
		return

	_orbit_angle += _orbit_input * orbit_speed * delta

	var camera_offset := Vector3(
		sin(_orbit_angle) * follow_distance,
		follow_height,
		cos(_orbit_angle) * follow_distance
	)
	var desired_position := _target.global_position + camera_offset
	var blend := clampf(follow_smoothing * delta, 0.0, 1.0)
	global_position = global_position.lerp(desired_position, blend)
	look_at(_target.global_position + Vector3(0.0, look_height, 0.0), Vector3.UP)

func set_orbit_input(input: float) -> void:
	_orbit_input = clampf(input, -1.0, 1.0)

func get_forward_flat() -> Vector3:
	var forward := -global_transform.basis.z
	forward.y = 0.0
	if forward.length() <= 0.001:
		return Vector3.FORWARD
	return forward.normalized()

func get_right_flat() -> Vector3:
	var right := global_transform.basis.x
	right.y = 0.0
	if right.length() <= 0.001:
		return Vector3.RIGHT
	return right.normalized()
