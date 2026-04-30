extends StaticBody3D

@export var npc_name := "Test NPC"
@export_multiline var interaction_line := "The road ahead is not ready yet."

func _ready() -> void:
	name = "VisibleTestNPC"
	_make_existing_cube_look_like_npc()

func interact() -> String:
	return "%s: %s" % [npc_name, interaction_line]

func _make_existing_cube_look_like_npc() -> void:
	var mesh_instance := get_node_or_null("InteractableMesh") as MeshInstance3D
	if mesh_instance != null:
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(1.0, 0.85, 0.05, 1.0)
		mesh_instance.material_override = material
		mesh_instance.scale = Vector3(1.25, 1.6, 1.25)

	var label := get_node_or_null("InteractableLabel") as Label3D
	if label != null:
		label.text = "BIG YELLOW NPC"
		label.position = Vector3(0, 1.45, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
