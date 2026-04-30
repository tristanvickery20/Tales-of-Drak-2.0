extends Resource
class_name DrakConditionTracker

const TEST_CONDITION := "Prone"

var _is_prone := false

func has_condition(condition_name: String) -> bool:
	return condition_name == TEST_CONDITION and _is_prone

func toggle_prone() -> bool:
	_is_prone = not _is_prone
	return _is_prone

func clear_prone() -> void:
	_is_prone = false

func get_summary_text() -> String:
	if _is_prone:
		return "Conditions: Prone"
	return "Conditions: none"

func get_registry_summary_text() -> String:
	return "Condition foundation loaded. Test condition: Prone."
