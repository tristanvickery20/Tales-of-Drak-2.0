extends Control

const HotbarSlotScene := preload("res://scenes/hotbar_slot.tscn")

const TOP_KEYS := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", ""]
const BOTTOM_KEYS := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-", ""]
const SLOT_WIDTH := 72.0
const SLOT_HEIGHT := 96.0
const GAP := 1.0
const COLUMN_COUNT := 13
const COOLDOWN_SECONDS := 2.4

var main_frame: Control
var slot_grid: Control
var action_economy_bar: Control
var center_emblem: Control
var follow_button_panel: Control
var slots: Array[Node] = []
var slots_by_key: Dictionary = {}
var action_points := 4
var bonus_points := 4
var reaction_points := 1
var move_points := 3

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process_input(true)
	_build_named_structure()
	_build_slots()
	_layout_hotbar()
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout_hotbar()
		queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			_reset_fake_turn()
			return
		var key_text := OS.get_keycode_string(event.keycode).to_upper()
		if slots_by_key.has(key_text):
			_activate_slot(slots_by_key[key_text])

func _build_named_structure() -> void:
	main_frame = Control.new()
	main_frame.name = "MainFrame"
	main_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(main_frame)

	slot_grid = Control.new()
	slot_grid.name = "SlotGrid"
	slot_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(slot_grid)

	action_economy_bar = Control.new()
	action_economy_bar.name = "ActionEconomyBar"
	action_economy_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(action_economy_bar)

	center_emblem = Control.new()
	center_emblem.name = "CenterEmblem"
	center_emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center_emblem)

	follow_button_panel = Control.new()
	follow_button_panel.name = "FollowButtonPanel"
	follow_button_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(follow_button_panel)

func _build_slots() -> void:
	for child in slot_grid.get_children():
		child.queue_free()
	slots.clear()
	slots_by_key.clear()

	for index in range(TOP_KEYS.size()):
		_add_slot("top_%s" % str(index + 1), TOP_KEYS[index], index)
	for index in range(BOTTOM_KEYS.size()):
		_add_slot("bottom_%s" % str(index + 1), BOTTOM_KEYS[index], index + TOP_KEYS.size())

func _add_slot(slot_id: String, keybind: String, visual_index: int) -> void:
	var slot := HotbarSlotScene.instantiate()
	slot_grid.add_child(slot)
	slot.configure({
		"slot_id": slot_id,
		"keybind": keybind,
		"ability_id": _fake_ability_id(keybind, slot_id),
		"ability_name": _fake_ability_name(keybind),
		"icon_color_id": _icon_color_id(visual_index),
		"stack_count": _fake_stack_count(keybind, slot_id),
		"is_disabled": keybind.is_empty()
	})
	slot.slot_activated.connect(_activate_slot)
	slots.append(slot)
	if not keybind.is_empty() and not slots_by_key.has(keybind.to_upper()):
		slots_by_key[keybind.to_upper()] = slot_id

func _layout_hotbar() -> void:
	var grid_width := COLUMN_COUNT * SLOT_WIDTH + (COLUMN_COUNT - 1) * GAP
	var grid_height := SLOT_HEIGHT * 2.0 + GAP
	var start_x := (size.x - grid_width) * 0.5
	var start_y := maxf(30.0, size.y - 292.0)

	main_frame.position = Vector2(start_x - 18.0, start_y - 8.0)
	main_frame.size = Vector2(grid_width + 36.0, grid_height + 22.0)

	slot_grid.position = Vector2(start_x, start_y)
	slot_grid.size = Vector2(grid_width, grid_height)

	action_economy_bar.position = Vector2(start_x + 76.0, start_y + grid_height - 2.0)
	action_economy_bar.size = Vector2(grid_width - 152.0, 78.0)

	center_emblem.position = Vector2(size.x * 0.5 - 42.0, start_y + grid_height - 22.0)
	center_emblem.size = Vector2(84.0, 104.0)

	follow_button_panel.position = Vector2(start_x + grid_width + 36.0, start_y + grid_height - 12.0)
	follow_button_panel.size = Vector2(110.0, 58.0)

	for index in range(slots.size()):
		var row := int(index / COLUMN_COUNT)
		var col := index % COLUMN_COUNT
		slots[index].position = Vector2(col * (SLOT_WIDTH + GAP), row * (SLOT_HEIGHT + GAP))
		slots[index].size = Vector2(SLOT_WIDTH, SLOT_HEIGHT)
	queue_redraw()

func _activate_slot(slot_id: String) -> void:
	var target_slot = _find_slot(slot_id)
	if target_slot == null:
		return
	if not target_slot.can_activate():
		return
	target_slot.activate_visuals(COOLDOWN_SECONDS)
	target_slot.use_stack_item()
	_consume_fake_action_cost(slot_id)
	queue_redraw()

func _find_slot(slot_id: String) -> Node:
	for slot in slots:
		if slot.slot_id == slot_id:
			return slot
	return null

func _consume_fake_action_cost(slot_id: String) -> void:
	if slot_id.begins_with("bottom_"):
		if bonus_points > 0:
			bonus_points -= 1
		return
	if action_points > 0:
		action_points -= 1

func _reset_fake_turn() -> void:
	action_points = 4
	bonus_points = 4
	reaction_points = 1
	move_points = 3
	queue_redraw()

func _draw() -> void:
	_draw_main_frame(Rect2(main_frame.position, main_frame.size))
	_draw_action_bar(Rect2(action_economy_bar.position, action_economy_bar.size))
	_draw_center_emblem(Rect2(center_emblem.position, center_emblem.size))
	_draw_follow_panel(Rect2(follow_button_panel.position, follow_button_panel.size))

func _draw_main_frame(rect: Rect2) -> void:
	var outer := PackedVector2Array([
		rect.position + Vector2(0, 10),
		rect.position + Vector2(12, 0),
		rect.position + Vector2(rect.size.x - 12, 0),
		rect.position + Vector2(rect.size.x, 10),
		rect.position + Vector2(rect.size.x, rect.size.y - 10),
		rect.position + Vector2(rect.size.x - 12, rect.size.y),
		rect.position + Vector2(12, rect.size.y),
		rect.position + Vector2(0, rect.size.y - 10)
	])
	draw_polygon(outer, PackedColorArray([Color(0.005, 0.005, 0.006, 0.985)]))
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.18, 0.16, 0.14, 1.0), 3.0)
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.55, 0.49, 0.42, 0.35), 1.0)
	draw_rect(rect.grow(-8.0), Color(0.055, 0.050, 0.048, 0.88), false, 1.0)
	var divider_y := rect.position.y + rect.size.y * 0.505
	draw_line(Vector2(rect.position.x + 9, divider_y - 2), Vector2(rect.position.x + rect.size.x - 9, divider_y - 2), Color(0.0, 0.0, 0.0, 1.0), 5.0)
	draw_line(Vector2(rect.position.x + 12, divider_y - 6), Vector2(rect.position.x + rect.size.x - 12, divider_y - 6), Color(0.70, 0.62, 0.54, 0.30), 1.0)
	draw_line(Vector2(rect.position.x + 12, divider_y + 3), Vector2(rect.position.x + rect.size.x - 12, divider_y + 3), Color(0.42, 0.11, 0.08, 0.34), 1.0)
	_draw_corner_flourish(rect.position + Vector2(4, 4), 1, 1)
	_draw_corner_flourish(rect.position + Vector2(rect.size.x - 4, 4), -1, 1)
	_draw_corner_flourish(rect.position + Vector2(4, rect.size.y - 4), 1, -1)
	_draw_corner_flourish(rect.position + Vector2(rect.size.x - 4, rect.size.y - 4), -1, -1)

func _draw_corner_flourish(origin: Vector2, sx: int, sy: int) -> void:
	var pts := PackedVector2Array([
		origin,
		origin + Vector2(sx * 14, sy * 3),
		origin + Vector2(sx * 22, sy * 13),
		origin + Vector2(sx * 8, sy * 20)
	])
	draw_polyline(pts, Color(0.64, 0.58, 0.50, 0.46), 1.4)

func _draw_action_bar(rect: Rect2) -> void:
	var points := PackedVector2Array([
		rect.position + Vector2(36, 0),
		rect.position + Vector2(rect.size.x - 36, 0),
		rect.position + Vector2(rect.size.x, 22),
		rect.position + Vector2(rect.size.x - 42, rect.size.y - 4),
		rect.position + Vector2(rect.size.x * 0.56, rect.size.y - 4),
		rect.position + Vector2(rect.size.x * 0.50, rect.size.y + 18),
		rect.position + Vector2(rect.size.x * 0.44, rect.size.y - 4),
		rect.position + Vector2(42, rect.size.y - 4),
		rect.position + Vector2(0, 22)
	])
	draw_polygon(points, PackedColorArray([Color(0.010, 0.009, 0.010, 0.97)]))
	draw_polyline(points + PackedVector2Array([points[0]]), Color(0.35, 0.30, 0.25, 0.98), 2.0)
	draw_line(rect.position + Vector2(60, 7), rect.position + Vector2(rect.size.x - 60, 7), Color(0.72, 0.61, 0.48, 0.22), 1.0)
	_draw_economy_group(rect.position + Vector2(96.0, 22.0), "ACTION", action_points, 4, Color(0.86, 0.08, 0.09, 1.0))
	_draw_economy_group(rect.position + Vector2(272.0, 22.0), "BONUS", bonus_points, 4, Color(0.55, 0.55, 0.55, 1.0))
	_draw_economy_group(rect.position + Vector2(rect.size.x - 282.0, 22.0), "REACTION", reaction_points, 1, Color(0.86, 0.08, 0.09, 1.0))
	_draw_economy_group(rect.position + Vector2(rect.size.x - 104.0, 22.0), "MOVE", move_points, 3, Color(0.95, 0.72, 0.38, 1.0))

func _draw_economy_group(center: Vector2, label: String, active_count: int, max_count: int, active_color: Color) -> void:
	var font := get_theme_default_font()
	draw_string(font, center + Vector2(-60, -2), label, HORIZONTAL_ALIGNMENT_CENTER, 120, 16, Color(0.91, 0.86, 0.77, 1.0))
	var start_x := center.x - (max_count - 1) * 10.0
	for i in range(max_count):
		var color := active_color if i < active_count else Color(0.25, 0.25, 0.25, 1.0)
		_draw_diamond(Vector2(start_x + i * 20.0, center.y + 22.0), 6.5, color)

func _draw_diamond(center: Vector2, radius: float, color: Color) -> void:
	var pts := PackedVector2Array([
		center + Vector2(0, -radius),
		center + Vector2(radius, 0),
		center + Vector2(0, radius),
		center + Vector2(-radius, 0)
	])
	draw_polygon(pts, PackedColorArray([color]))
	draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.96, 0.88, 0.77, 0.78), 1.0)

func _draw_center_emblem(rect: Rect2) -> void:
	var center := rect.position + rect.size * 0.5
	var outer := PackedVector2Array([
		center + Vector2(0, -52),
		center + Vector2(36, -12),
		center + Vector2(20, 18),
		center + Vector2(0, 52),
		center + Vector2(-20, 18),
		center + Vector2(-36, -12)
	])
	draw_polygon(outer, PackedColorArray([Color(0.020, 0.018, 0.018, 1.0)]))
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.55, 0.49, 0.42, 1.0), 2.0)
	draw_line(center + Vector2(0, -36), center + Vector2(0, 34), Color(0.82, 0.72, 0.57, 1.0), 3.0)
	draw_line(center + Vector2(-16, -8), center + Vector2(16, -8), Color(0.82, 0.72, 0.57, 1.0), 2.0)
	draw_circle(center + Vector2(0, -4), 4.0, Color(0.12, 0.04, 0.03, 1.0))

func _draw_follow_panel(rect: Rect2) -> void:
	var pts := PackedVector2Array([
		rect.position + Vector2(8, 0),
		rect.position + Vector2(rect.size.x - 8, 0),
		rect.position + Vector2(rect.size.x, 8),
		rect.position + Vector2(rect.size.x, rect.size.y - 8),
		rect.position + Vector2(rect.size.x - 8, rect.size.y),
		rect.position + Vector2(8, rect.size.y),
		rect.position + Vector2(0, rect.size.y - 8),
		rect.position + Vector2(0, 8)
	])
	draw_polygon(pts, PackedColorArray([Color(0.010, 0.009, 0.010, 0.97)]))
	draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.38, 0.34, 0.30, 1.0), 2.0)
	var font := get_theme_default_font()
	draw_string(font, rect.position + Vector2(rect.size.x - 34, 28), "F", HORIZONTAL_ALIGNMENT_CENTER, 28, 16, Color(0.92, 0.86, 0.76, 1.0))
	draw_string(font, rect.position + Vector2(24, 56), "Follow", HORIZONTAL_ALIGNMENT_CENTER, 72, 13, Color(0.88, 0.82, 0.72, 1.0))
	draw_line(rect.position + Vector2(16, 17), rect.position + Vector2(48, 29), Color(0.72, 0.70, 0.66, 1.0), 2.0)
	draw_line(rect.position + Vector2(16, 30), rect.position + Vector2(48, 42), Color(0.72, 0.70, 0.66, 1.0), 2.0)
	draw_rect(Rect2(rect.position + Vector2(rect.size.x - 40, 10), Vector2(28, 24)), Color(0.0, 0.0, 0.0, 0.45), false, 1.0)

func _fake_ability_id(keybind: String, slot_id: String) -> String:
	if keybind.is_empty():
		return "decorative_%s" % slot_id
	return "ability_%s" % keybind.to_lower().replace("[", "left_bracket").replace("]", "right_bracket").replace("-", "minus").replace("=", "equals")

func _fake_ability_name(keybind: String) -> String:
	match keybind:
		"1": return "Slash"
		"2": return "Heavy Strike"
		"3": return "Fire Bolt"
		"4": return "Guard"
		"5": return "Potion"
		"Q": return "Dodge"
		"E": return "Tame Command"
		"R": return "Taunt"
		"": return "Decorative Slot"
		_: return "Prototype Ability %s" % keybind

func _fake_stack_count(keybind: String, slot_id: String) -> int:
	match keybind:
		"0": return 12
		"=": return 8
		"P": return 3
		"[": return 2
		_: return 0

func _icon_color_id(index: int) -> String:
	var colors := ["red", "gray", "red", "purple", "red", "red", "red", "purple", "red", "red", "red", "blue", "gray", "gray", "gray", "gold", "purple", "red", "red", "green", "gold", "gold", "red", "blue", "gray", "gray"]
	return colors[index % colors.size()]
