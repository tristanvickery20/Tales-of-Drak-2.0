extends Control

const TOP_KEYS := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
const BOTTOM_KEYS := ["Q", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "-"]

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	var viewport_size := size
	var slot_size := 58.0
	var gap := 5.0
	var cols := 12
	var grid_width := cols * slot_size + (cols - 1) * gap
	var grid_height := slot_size * 2.0 + gap
	var start_x := (viewport_size.x - grid_width) * 0.5
	var start_y := viewport_size.y - 205.0
	var frame_rect := Rect2(start_x - 16.0, start_y - 18.0, grid_width + 32.0, grid_height + 34.0)

	_draw_main_frame(frame_rect)
	_draw_slot_row(Vector2(start_x, start_y), TOP_KEYS, 4)
	_draw_slot_row(Vector2(start_x, start_y + slot_size + gap), BOTTOM_KEYS, -1)
	_draw_action_bar(Vector2(start_x + 55.0, start_y + grid_height + 18.0), grid_width - 110.0)
	_draw_center_emblem(Vector2(viewport_size.x * 0.5, start_y + grid_height + 59.0))
	_draw_follow_panel(Vector2(start_x + grid_width + 38.0, start_y + grid_height - 12.0))

func _draw_main_frame(rect: Rect2) -> void:
	draw_rect(rect, Color(0.015, 0.013, 0.014, 0.94), true)
	draw_rect(rect, Color(0.34, 0.30, 0.27, 0.95), false, 2.0)
	draw_rect(rect.grow(-4.0), Color(0.08, 0.07, 0.065, 1.0), false, 1.0)
	_draw_corner_caps(rect)

func _draw_corner_caps(rect: Rect2) -> void:
	var c := Color(0.42, 0.38, 0.34, 1.0)
	var s := 13.0
	draw_line(rect.position, rect.position + Vector2(s, 0), c, 2.0)
	draw_line(rect.position, rect.position + Vector2(0, s), c, 2.0)
	draw_line(rect.position + Vector2(rect.size.x, 0), rect.position + Vector2(rect.size.x - s, 0), c, 2.0)
	draw_line(rect.position + Vector2(rect.size.x, 0), rect.position + Vector2(rect.size.x, s), c, 2.0)
	draw_line(rect.position + Vector2(0, rect.size.y), rect.position + Vector2(s, rect.size.y), c, 2.0)
	draw_line(rect.position + Vector2(0, rect.size.y), rect.position + Vector2(0, rect.size.y - s), c, 2.0)
	draw_line(rect.position + rect.size, rect.position + rect.size - Vector2(s, 0), c, 2.0)
	draw_line(rect.position + rect.size, rect.position + rect.size - Vector2(0, s), c, 2.0)

func _draw_slot_row(origin: Vector2, keys: Array, selected_index: int) -> void:
	var slot_size := 58.0
	var gap := 5.0
	for i in keys.size():
		var pos := origin + Vector2(i * (slot_size + gap), 0)
		_draw_slot(Rect2(pos, Vector2(slot_size, slot_size)), str(keys[i]), i == selected_index, i)

func _draw_slot(rect: Rect2, key_text: String, selected: bool, index: int) -> void:
	var fill := Color(0.035, 0.031, 0.032, 0.96)
	var inner := Color(0.11, 0.095, 0.09, 1.0)
	var border := Color(0.38, 0.34, 0.31, 0.96)
	draw_rect(rect, fill, true)
	draw_rect(rect, border, false, 2.0)
	draw_rect(rect.grow(-5.0), inner, true)
	draw_rect(rect.grow(-5.0), Color(0.18, 0.15, 0.13, 1.0), false, 1.0)

	if selected:
		draw_rect(rect.grow(3.0), Color(0.95, 0.06, 0.04, 0.30), true)
		draw_rect(rect.grow(3.0), Color(1.0, 0.11, 0.07, 0.95), false, 2.0)
		draw_rect(rect.grow(-6.0), Color(0.7, 0.03, 0.02, 0.18), true)

	_draw_placeholder_icon(rect.grow(-13.0), index)
	_draw_key_label(rect, key_text)

func _draw_key_label(rect: Rect2, text: String) -> void:
	var font := get_theme_default_font()
	var font_size := 17
	var text_pos := Vector2(rect.position.x, rect.position.y - 6.0)
	draw_string(font, text_pos, text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color(0.88, 0.84, 0.76, 1.0))

func _draw_placeholder_icon(rect: Rect2, index: int) -> void:
	var colors := [
		Color(0.86, 0.05, 0.06, 1.0), Color(0.55, 0.05, 0.08, 1.0),
		Color(0.95, 0.22, 0.17, 1.0), Color(0.62, 0.12, 0.95, 1.0),
		Color(0.82, 0.05, 0.06, 1.0), Color(0.9, 0.06, 0.04, 1.0),
		Color(0.72, 0.05, 0.05, 1.0), Color(0.5, 0.1, 0.9, 1.0),
		Color(0.85, 0.12, 0.08, 1.0), Color(0.75, 0.04, 0.04, 1.0),
		Color(0.7, 0.08, 0.08, 1.0), Color(0.22, 0.35, 0.95, 1.0)
	]
	var c: Color = colors[index % colors.size()]
	var center := rect.position + rect.size * 0.5
	draw_rect(rect, Color(c.r * 0.22, c.g * 0.22, c.b * 0.22, 0.84), true)
	draw_circle(center, rect.size.x * 0.32, Color(c.r, c.g, c.b, 0.23))
	draw_line(rect.position + Vector2(4, rect.size.y - 5), rect.position + Vector2(rect.size.x - 4, 5), c, 3.0)
	draw_line(rect.position + Vector2(10, 6), rect.position + Vector2(rect.size.x - 10, rect.size.y - 8), Color(c.r, c.g, c.b, 0.72), 2.0)
	draw_circle(center, 4.0, Color(1, 0.92, 0.82, 0.9))

func _draw_action_bar(origin: Vector2, width: float) -> void:
	var height := 58.0
	var points := PackedVector2Array([
		origin + Vector2(32, 0),
		origin + Vector2(width - 32, 0),
		origin + Vector2(width, 20),
		origin + Vector2(width - 38, height),
		origin + Vector2(38, height),
		origin + Vector2(0, 20)
	])
	draw_polygon(points, PackedColorArray([Color(0.018, 0.015, 0.016, 0.95)]))
	draw_polyline(points + PackedVector2Array([points[0]]), Color(0.32, 0.29, 0.25, 1.0), 2.0)

	var labels := ["ACTION", "BONUS", "REACTION", "MOVE"]
	var offsets := [85.0, 245.0, width - 240.0, width - 85.0]
	for i in labels.size():
		_draw_economy_group(origin + Vector2(offsets[i], 22.0), labels[i], i)

func _draw_economy_group(center: Vector2, label: String, index: int) -> void:
	var font := get_theme_default_font()
	draw_string(font, center + Vector2(-58, -5), label, HORIZONTAL_ALIGNMENT_CENTER, 116, 15, Color(0.88, 0.82, 0.72, 1.0))
	var diamond_count := 4
	if label == "REACTION":
		diamond_count = 1
	elif label == "MOVE":
		diamond_count = 3
	var start_x := center.x - (diamond_count - 1) * 9.0
	for i in diamond_count:
		var color := Color(0.86, 0.08, 0.09, 1.0)
		if label == "BONUS":
			color = Color(0.42, 0.40, 0.38, 1.0)
		elif label == "MOVE":
			color = Color(0.95, 0.72, 0.38, 1.0)
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

func _draw_center_emblem(center: Vector2) -> void:
	var outer := PackedVector2Array([
		center + Vector2(0, -48), center + Vector2(32, -8), center + Vector2(0, 42), center + Vector2(-32, -8)
	])
	draw_polygon(outer, PackedColorArray([Color(0.035, 0.03, 0.03, 1.0)]))
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.45, 0.40, 0.34, 1.0), 2.0)
	draw_line(center + Vector2(0, -34), center + Vector2(0, 26), Color(0.78, 0.68, 0.55, 1.0), 3.0)
	draw_line(center + Vector2(-12, -6), center + Vector2(12, -6), Color(0.78, 0.68, 0.55, 1.0), 2.0)

func _draw_follow_panel(origin: Vector2) -> void:
	var rect := Rect2(origin, Vector2(96, 48))
	draw_rect(rect, Color(0.018, 0.015, 0.016, 0.95), true)
	draw_rect(rect, Color(0.35, 0.31, 0.27, 1.0), false, 2.0)
	var font := get_theme_default_font()
	draw_string(font, origin + Vector2(54, 34), "F", HORIZONTAL_ALIGNMENT_CENTER, 32, 16, Color(0.9, 0.86, 0.78, 1.0))
	draw_string(font, origin + Vector2(47, 50), "Follow", HORIZONTAL_ALIGNMENT_CENTER, 60, 13, Color(0.84, 0.80, 0.72, 1.0))
	draw_line(origin + Vector2(14, 14), origin + Vector2(39, 25), Color(0.72, 0.70, 0.66, 1.0), 2.0)
	draw_line(origin + Vector2(14, 24), origin + Vector2(39, 35), Color(0.72, 0.70, 0.66, 1.0), 2.0)
