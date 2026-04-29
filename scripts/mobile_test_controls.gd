extends CanvasLayer

const MAIN_MENU_SCENE := "res://scenes/main_menu/main_menu.tscn"

@onready var player: Node = get_node_or_null("../PlaceholderPlayer")

var _move_input := Vector2.ZERO

func _ready() -> void:
	_connect_button("Controls/MovePad/UpButton", Vector2(0, -1))
	_connect_button("Controls/MovePad/DownButton", Vector2(0, 1))
	_connect_button("Controls/MovePad/LeftButton", Vector2(-1, 0))
	_connect_button("Controls/MovePad/RightButton", Vector2(1, 0))

	var back_button := get_node_or_null("Controls/BackToMenuButton")
	if back_button != null:
		back_button.pressed.connect(_on_back_to_menu_pressed)

func _process(_delta: float) -> void:
	if player != null and player.has_method("set_move_input"):
		player.set_move_input(_move_input)

func _connect_button(path: String, direction: Vector2) -> void:
	var button := get_node_or_null(path)
	if button == null:
		push_warning("Missing mobile test button: " + path)
		return
	button.button_down.connect(func() -> void:
		_move_input += direction
		_clamp_move_input()
	)
	button.button_up.connect(func() -> void:
		_move_input -= direction
		_clamp_move_input()
	)

func _clamp_move_input() -> void:
	_move_input.x = clampf(_move_input.x, -1.0, 1.0)
	_move_input.y = clampf(_move_input.y, -1.0, 1.0)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
