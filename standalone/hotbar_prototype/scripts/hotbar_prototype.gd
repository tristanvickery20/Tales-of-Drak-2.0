extends Control

const HotbarSlotScene := preload("res://scenes/hotbar_slot.tscn")

const TOP_KEYS := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const BOTTOM_KEYS := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]
const SLOT_SIZE := 58.0
const SLOT_CONTROL_HEIGHT := 80.0
const GAP := 5.0
const COLUMN_COUNT := 12
const COOLDOWN_SECONDS := 2.4

var main_frame: Control
var slot_grid: Control
var action_economy_bar: Control
var center_emblem: Control
var follow_button_panel: Control
var slots: Array[Node] = []
var slots_by_key: Dictionary = {}
var selected_slot_id := "top_5"
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
		_add_slot("top_%s" % str(index + 1), TOP_KEYS[index], index, index == 4)
	for index in range(BOTTOM_KEYS.size()):
		_add_slot("bottom_%s" % str(index + 1), BOTTOM_KEYS[index], index + TOP_KEYS.size(), false)

func _add_slot(slot_id: String, keybind: String, visual_index: int, selected: bool) -> void:
	var slot := HotbarSlotScene.instantiate()
	slot_grid.add_child(slot)
	slot.configure({
		"slot_id": slot_id,
		"keybind": keybind,
		"ability_id": _fake_ability_id(keybind),
		"ability_name": _fake_ability_name(keybind),
		"icon_color_id": _icon_color_id(visual_index),
		"stack_count": _fake_stack_count(keybind),
		"is_selected": selected,
		"is_disabled": false
	})
	slot.slot_activated.connect(_activate_slot)
	slots.append(slot)
	slots_by_key[keybind.to_upper()] = slot_id
	if selected:
		selected_slot_id = slot_id

func _layout_hotbar() -> void:
	var grid_width := COLUMN_COUNT * SLOT_SIZE + (COLUMN_COUNT - 1) * GAP
	var grid_height := SLOT_CONTROL_HEIGHT * 2.0 + GAP
	var start_x := (size.x - grid_width) * 0.5
	var start_y := size.y - 230.0

	main_frame.position = Vector2(start_x - 16.0, start_y + 4.0)
	main_frame.size = Vector2(grid_width + 32.0, grid_height - 10.0)

	slot_grid.position = Vector2(start_x, start_y)
	slot_grid.size = Vector2(grid_width, grid_height)

	action_economy_bar.position = Vector2(start_x + 55.0, start_y + 140.0)
	action_economy_bar.size = Vector2(grid_width - 110.0, 64.0)

	center_emblem.position = Vector2(size.x * 0.5 - 38.0, start_y + 150.0)
	center_emblem.size = Vector2(76.0, 86.0)

	follow_button_panel.position = Vector2(start_x + grid_width + 38.0, start_y + 134.0)
	follow_button_panel.size = Vector2(96.0, 48.0)

	for index in range(slots.size()):
		var row := index / COLUMN_COUNT
		var col := index % COLUMN_COUNT
		slots[index].position = Vector2(col * (SLOT_SIZE + GAP), row * (SLOT_CONTROL_HEIGHT + GAP))
		slots[index].size = Vector2(SLOT_SIZE, SLOT_CONTROL_HEIGHT)

func _activate_slot(slot_id: String) -> void:
	var target_slot = _find_slot(slot_id)
	if target_slot == null:
		return
	if not target_slot.can_activate():
		return

	for slot in slots:
		slot.set_selected(slot.slot_id == slot_id)
	selected_slot_id = slot_id
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
	draw_rect(rect, Color(0.015, 0.013, 0.014, 0.94), true)
	draw_rect(rect, Color(0.34, 0.30, 0.27, 0.95), false, 2.0)
	draw_rect(rect.grow(-4.0), Color(0.08, 0.07, 0.065, 1.0), false, 1.0)

func _draw_action_bar(rect: Rect2) -> void:
	var points := PackedVector2Array([
		rect.position + Vector2(32, 0),
		rect.position + Vector2(rect.size.x - 32, 0),
		rect.position + Vector2(rect.size.x, 20),
		rect.position + Vector2(rect.size.x - 38, rect.size.y),
		rect.position + Vector2(38, rect.size.y),
		rect.position + Vector2(0, 20)
	])
	draw_polygon(points, PackedColorArray([Color(0.018, 0.015, 0.016, 0.95)]))
	draw_polyline(points + PackedVector2Array([points[0]]), Color(0.32, 0.29, 0.25, 1.0), 2.0)
	_draw_economy_group(rect.position + Vector2(85.0, 20.0), "ACTION", action_points, 4, Color(0.86, 0.08, 0.09, 1.0))
	_draw_economy_group(rect.position + Vector2(245.0, 20.0), "BONUS", bonus_points, 4, Color(0.86, 0.08, 0.09, 1.0))
	_draw_economy_group(rect.position + Vector2(rect.size.x - 240.0, 20.0), "REACTION", reaction_points, 1, Color(0.86, 0.08, 0.09, 1.0))
	_draw_economy_group(rect.position + Vector2(rect.size.x - 85.0, 20.0), "MOVE", move_points, 3, Color(0.95, 0.72, 0.38, 1.0))

func _draw_economy_group(center: Vector2, label: String, active_count: int, max_count: int, active_color: Color) -> void:
	var font := get_theme_default_font()
	draw_string(font, center + Vector2(-58, -5), label, HORIZONTAL_ALIGNMENT_CENTER, 116, 15, Color(0.88, 0.82, 0.72, 1.0))
	var start_x := center.x - (max_count - 1) * 9.0
	for i in range(max_count):
		var color := active_color if i < active_count else Color(0.24, 0.23, 0.22, 1.0)
		_draw_diamond(Vector2(start_x + i * 18.0, center.y + 18.0), 6.0, color)

func _draw_diamond(center: Vector2, radius: float, color: Color) -> void:
	var pts := PackedVector2Array([
		center + Vector2(0, -radius),
		center + Vector2(radius, 0),
		center + Vector2(0, radius),
		center + Vector2(-radius, 0)
	])
	draw_polygon(pts, PackedColorArray([color]))
	draw_polyline(pts + PackedVector2Array([pts[0]]), Color(0.95, 0.85, 0.78, 0.85), 1.0)

func _draw_center_emblem(rect: Rect2) -> void:
	var center := rect.position + rect.size * 0.5
	var outer := PackedVector2Array([
		center + Vector2(0, -42),
		center + Vector2(31, -8),
		center + Vector2(0, 42),
		center + Vector2(-31, -8)
	])
	draw_polygon(outer, PackedColorArray([Color(0.035, 0.03, 0.03, 1.0)]))
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.45, 0.40, 0.34, 1.0), 2.0)
	draw_line(center + Vector2(0, -30), center + Vector2(0, 26), Color(0.78, 0.68, 0.55, 1.0), 3.0)
	draw_line(center + Vector2(-12, -6), center + Vector2(12, -6), Color(0.78, 0.68, 0.55, 1.0), 2.0)

func _draw_follow_panel(rect: Rect2) -> void:
	draw_rect(rect, Color(0.018, 0.015, 0.016, 0.95), true)
	draw_rect(rect, Color(0.35, 0.31, 0.27, 1.0), false, 2.0)
	var font := get_theme_default_font()
	draw_string(font, rect.position + Vector2(54, 34), "F", HORIZONTAL_ALIGNMENT_CENTER, 32, 16, Color(0.9, 0.86, 0.78, 1.0))
	draw_string(font, rect.position + Vector2(47, 50), "Follow", HORIZONTAL_ALIGNMENT_CENTER, 60, 13, Color(0.84, 0.80, 0.72, 1.0))
	draw_line(rect.position + Vector2(14, 14), rect.position + Vector2(39, 25), Color(0.72, 0.70, 0.66, 1.0), 2.0)
	draw_line(rect.position + Vector2(14, 24), rect.position + Vector2(39, 35), Color(0.72, 0.70, 0.66, 1.0), 2.0)

func _fake_ability_id(keybind: String) -> String:
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
		_: return "Prototype Ability %s" % keybind

func _fake_stack_count(keybind: String) -> int:
	match keybind:
		"0": return 12
		"-": return 8
		"P": return 3
		"[": return 2
		_: return 0

func _icon_color_id(index: int) -> String:
	var colors := ["red", "gray", "red", "purple", "red", "red", "red", "purple", "red", "red", "red", "blue", "gray", "gray", "gold", "purple", "red", "red", "green", "gold", "gold", "red", "blue", "gray"]
	return colors[index % colors.size()]
