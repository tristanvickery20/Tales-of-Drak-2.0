extends CanvasLayer

## Character sheet overlay is intentionally dormant while the approved art hotbar
## is owned by DrakHotbarOverlay. This prevents duplicate placeholder hotbars.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 80

func _process(_delta: float) -> void:
	_update_stage_labels()

func _update_stage_labels() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var controls := scene.get_node_or_null("MobileTestControls/Controls")
	if controls == null:
		return
	var instruction := controls.get_node_or_null("InstructionLabel") as Label
	if instruction != null:
		instruction.text = "Tales of Drak - Stage 4D"
	var status := controls.get_node_or_null("StatusLabel") as Label
	if status != null:
		status.text = "Stage 4D: approved hotbar art integrated."
	var debug := controls.get_node_or_null("DebugLabel") as Label
	if debug != null:
		debug.text = debug.text.replace("Stage 1I", "Stage 4D").replace("Stage 4C", "Stage 4D")
