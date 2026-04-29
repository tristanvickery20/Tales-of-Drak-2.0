extends StaticBody3D

@export var resource_name := "Resource Sample"
@export var amount := 1

var _picked_up := false

func interact() -> String:
	if _picked_up:
		return resource_name + " already picked up."

	_picked_up = true
	visible = false
	set_process(false)
	set_physics_process(false)
	remove_from_group("test_interactable")

	var collision := get_node_or_null("CollisionShape3D")
	if collision != null:
		collision.set_deferred("disabled", true)

	queue_free()
	return "Picked up %s x%d" % [resource_name, amount]
