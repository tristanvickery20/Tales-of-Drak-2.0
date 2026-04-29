extends Node3D

const TEST_RESOURCE_PICKUP_SCRIPT := preload("res://scripts/test_resource_pickup.gd")

func _ready() -> void:
	_build_stage_1d_zone()

func _build_stage_1d_zone() -> void:
	var existing := get_node_or_null("Stage1DZone")
	if existing != null:
		existing.queue_free()

	var zone_root := Node3D.new()
	zone_root.name = "Stage1DZone"
	add_child(zone_root)

	_add_label(zone_root, "ZoneLabel", "Stage 1E Tiny Outdoor Test Zone", Vector3(0, 1.4, -6.5))
	_add_block(zone_root, "NorthWall", Vector3(0, 1, -8), Vector3(12, 2, 0.6))
	_add_block(zone_root, "WestWall", Vector3(-6, 1, -1), Vector3(0.6, 2, 14))
	_add_block(zone_root, "EastWall", Vector3(6, 1, -1), Vector3(0.6, 2, 14))
	_add_block(zone_root, "ShortRuinWallA", Vector3(-2.8, 0.75, -3.2), Vector3(3.0, 1.5, 0.5))
	_add_block(zone_root, "ShortRuinWallB", Vector3(2.8, 0.75, -3.2), Vector3(3.0, 1.5, 0.5))
	_add_block(zone_root, "BrokenPillarLeft", Vector3(-3.8, 1.1, 2.7), Vector3(0.8, 2.2, 0.8))
	_add_block(zone_root, "BrokenPillarRight", Vector3(3.8, 1.1, 2.7), Vector3(0.8, 2.2, 0.8))
	_add_block(zone_root, "LowStep", Vector3(0, 0.25, 4.5), Vector3(3.0, 0.5, 1.2))
	_add_block(zone_root, "StoneMarker", Vector3(-4.4, 0.5, -6), Vector3(1.0, 1.0, 1.0))
	_add_block(zone_root, "RockA", Vector3(4.3, 0.35, -5.4), Vector3(1.3, 0.7, 1.0))
	_add_block(zone_root, "RockB", Vector3(-4.5, 0.3, 5.0), Vector3(1.1, 0.6, 1.4))
	_add_label(zone_root, "LandmarkLabel", "Move around the ruins. Test collision + camera.", Vector3(0, 1.15, 4.5))
	_add_pickup(zone_root, "WoodPickup", "Wood", 1, Vector3(-2.2, 0.35, 1.8), Vector3(0.7, 0.7, 0.7))
	_add_pickup(zone_root, "StonePickup", "Stone", 1, Vector3(2.2, 0.35, 1.8), Vector3(0.7, 0.7, 0.7))
	_add_label(zone_root, "PickupLabel", "Walk near a pickup and press Interact.", Vector3(0, 1.2, 1.8))

func _add_block(parent: Node, block_name: String, position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = block_name
	body.position = position
	parent.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = block_name + "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	collision.name = block_name + "Collision"
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)

func _add_pickup(parent: Node, pickup_name: String, resource_name: String, amount: int, position: Vector3, size: Vector3) -> void:
	var pickup := StaticBody3D.new()
	pickup.name = pickup_name
	pickup.position = position
	pickup.add_to_group("test_interactable")
	pickup.set_script(TEST_RESOURCE_PICKUP_SCRIPT)
	pickup.resource_name = resource_name
	pickup.amount = amount
	parent.add_child(pickup)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "PickupMesh"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	pickup.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	pickup.add_child(collision)

	_add_label(pickup, "PickupLabel", resource_name, Vector3(0, 0.75, 0))

func _add_label(parent: Node, label_name: String, text: String, position: Vector3) -> void:
	var label := Label3D.new()
	label.name = label_name
	label.text = text
	label.position = position
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	parent.add_child(label)
