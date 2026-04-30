extends StaticBody3D

@export var npc_name := "Test NPC"
@export_multiline var interaction_line := "The road ahead is not ready yet."

func interact() -> String:
	return "%s: %s" % [npc_name, interaction_line]
