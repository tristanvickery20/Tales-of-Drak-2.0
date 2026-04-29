extends CharacterBody3D

@export var move_speed := 4.0
@export var jump_velocity := 6.0
@export var gravity := 18.0
@export var interact_range := 2.2
@export var camera_path: NodePath = NodePath("../Camera3D")

var _move_input := Vector2.ZERO
var _jump_requested := false
var _spawn_position := Vector3.ZERO
var _camera: Node

func _ready() -> void:
	_spawn_position = global_position
	_camera = get_node_or_null(camera_path)

func _physics_process(delta: float) -> void:
	var direction := _get_camera_relative_direction()
	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	if direction.length() > 0.05:
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, clampf(12.0 * delta, 0.0, 1.0))

	if is_on_floor():
		if _jump_requested:
			velocity.y = jump_velocity
		else:
			velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	_jump_requested = false
	move_and_slide()

func _get_camera_relative_direction() -> Vector3:
	var forward := Vector3.FORWARD
	var right := Vector3.RIGHT

	if _camera != null and _camera.has_method("get_forward_flat"):
		forward = _camera.get_forward_flat()
	if _camera != null and _camera.has_method("get_right_flat"):
		right = _camera.get_right_flat()

	return (right * _move_input.x) + (forward * -_move_input.y)

func set_move_input(input: Vector2) -> void:
	_move_input = input

func request_jump() -> void:
	_jump_requested = true

func reset_to_spawn() -> void:
	global_position = _spawn_position
	velocity = Vector3.ZERO
	_move_input = Vector2.ZERO
	_jump_requested = false

func get_debug_summary() -> String:
	return "Stage 1C | FPS: %d | Pos: %.1f, %.1f, %.1f" % [
		Engine.get_frames_per_second(),
		global_position.x,
		global_position.y,
		global_position.z,
	]

func try_interact() -> String:
	var interactables := get_tree().get_nodes_in_group("test_interactable")
	var closest: Node3D = null
	var closest_distance := interact_range

	for node in interactables:
		var interactable := node as Node3D
		if interactable == null:
			continue
		var distance := global_position.distance_to(interactable.global_position)
		if distance <= closest_distance:
			closest = interactable
			closest_distance = distance

	if closest == null:
		return "Move closer to the test object."

	if closest.has_method("interact"):
		return str(closest.interact())

	return "Interacted with Test Object"
