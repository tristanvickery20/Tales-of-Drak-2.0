extends Control

const TEST_WORLD_SCENE := "res://scenes/test_world/test_world.tscn"

func _ready() -> void:
	var start_button := get_node_or_null("CenterContainer/VBoxContainer/StartGameButton")
	if start_button == null:
		push_error("StartGameButton was not found in the main menu scene.")
		return
	start_button.pressed.connect(_on_start_game_pressed)

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(TEST_WORLD_SCENE)
