extends CanvasLayer

## Stage 4C realignment:
## Keep this autoload harmless while the visible hotbar is owned by the active UI layer.
## This prevents duplicate hotbars or export-breaking UI experiments.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 1
