extends StaticBody3D

const CAVE_SCENE := "res://scenes/cave_test/cave_test.tscn"

@export var entrance_name := "Cave Entrance"
@export_multiline var interaction_line := "Entering cave test cell."

func _ready() -> void:
	name = "VisibleCaveEntrance"
	_make_existing_cube_look_like_cave_entrance()

func interact() -> String:
	get_tree().change_scene_to_file(CAVE_SCENE)
	return "%s: %s" % [entrance_name, interaction_line]

func _make_existing_cube_look_like_cave_entrance() -> void:
	var mesh_instance := get_node_or_null("InteractableMesh") as MeshInstance3D
	if mesh_instance != null:
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(0.55, 0.05, 0.05, 1.0)
		mesh_instance.material_override = material
		mesh_instance.scale = Vector3(1.6, 2.0, 0.6)

	var label := get_node_or_null("InteractableLabel") as Label3D
	if label != null:
		label.text = "CAVE ENTRANCE"
		label.position = Vector3(0, 1.55, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
