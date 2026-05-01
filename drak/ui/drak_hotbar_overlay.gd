extends CanvasLayer

## Stage 4D realignment:
## The visible hotbar frame is drawn by drak_character_sheet_overlay.gd because
## that overlay is proven to load in the iPhone/GitHub Pages build.
## Keep this separate autoload harmless to prevent duplicate or invisible competing UI.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 1
