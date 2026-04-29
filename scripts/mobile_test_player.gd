extends CharacterBody3D

@export var move_speed := 4.0
@export var jump_velocity := 6.0
@export var gravity := 18.0
@export var interact_range := 2.2

var _move_input := Vector2.ZERO
var _jump_requested := false

func _physics_process(delta: float) -> void:
	var direction := Vector3(_move_input.x, 0.0, _move_input.y)
	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	if is_on_floor():
		if _jump_requested:
			velocity.y = jump_velocity
		else:
			velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	_jump_requested = false
	move_and_slide()

func set_move_input(input: Vector2) -> void:
	_move_input = input

func request_jump() -> void:
	_jump_requested = true

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
