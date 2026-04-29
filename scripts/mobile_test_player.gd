extends CharacterBody3D

@export var move_speed := 4.0

var _move_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction := Vector3(_move_input.x, 0.0, _move_input.y)
	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	if not is_on_floor():
		velocity.y -= 18.0 * delta
	else:
		velocity.y = 0.0

	move_and_slide()

func set_move_input(input: Vector2) -> void:
	_move_input = input
