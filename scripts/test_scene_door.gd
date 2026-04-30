extends StaticBody3D

@export var door_name := "Door"
@export var target_scene := ""
@export_multiline var use_message := "Traveling..."

func interact() -> String:
	if target_scene.is_empty():
		return door_name + ": target scene is not set."

	get_tree().change_scene_to_file(target_scene)
	return "%s: %s" % [door_name, use_message]
