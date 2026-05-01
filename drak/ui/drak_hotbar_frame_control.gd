extends Control

## Runtime-drawn fallback for the approved Tales of Drak two-row hotbar frame.
## This avoids web-export issues with imported image/SVG assets and guarantees the
## hotbar is visible in the browser build.

const SLOT_COUNT := 13
const SLOT_X_START := 0.039
const SLOT_X_END := 0.961
const TOP_SLOT_Y := 0.170
const BOTTOM_SLOT_Y := 0.435
const SLOT_H := 0.180

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	var w := size.x
	var h := size.y
	if w <= 0.0 or h <= 0.0:
		return
	_draw_main_frame(w, h)
	_draw_slots(w, h)
	_draw_bottom_plate(w, h)
	_draw_center_ornament(w, h)
	_draw_corner_ornaments(w, h)
	_draw_highlights(w, h)

func _draw_main_frame(w: float, h: float) -> void:
	var outer := PackedVector2Array([
		Vector2(w * 0.018, h * 0.095),
		Vector2(w * 0.982, h * 0.095),
		Vector2(w * 0.992, h * 0.135),
		Vector2(w * 0.992, h * 0.615),
		Vector2(w * 0.982, h * 0.655),
		Vector2(w * 0.018, h * 0.655),
		Vector2(w * 0.008, h * 0.615),
		Vector2(w * 0.008, h * 0.135),
	])
	draw_colored_polygon(outer, Color(0.005, 0.005, 0.005, 0.98))
	draw_polyline(outer + PackedVector2Array([outer[0]]), Color(0.16, 0.075, 0.06, 0.90), 3.0, true)
	var inner := Rect2(w * 0.026, h * 0.122, w * 0.948, h * 0.503)
	draw_rect(inner, Color(0.015, 0.014, 0.014, 0.96), false, 2.0)
	var divider := Rect2(w * 0.020, h * 0.355, w * 0.960, h * 0.052)
	draw_rect(divider, Color(0.0, 0.0, 0.0, 1.0), true)
	draw_rect(divider, Color(0.16, 0.075, 0.06, 0.70), false, 1.5)

func _draw_slots(w: float, h: float) -> void:
	var gap := w * 0.0065
	var total_slot_width := w * (SLOT_X_END - SLOT_X_START)
	var slot_w := (total_slot_width - (gap * float(SLOT_COUNT - 1))) / float(SLOT_COUNT)
	var slot_h := h * SLOT_H
	for row in range(2):
		var y_ratio := TOP_SLOT_Y if row == 0 else BOTTOM_SLOT_Y
		for column in range(SLOT_COUNT):
			var x := w * SLOT_X_START + float(column) * (slot_w + gap)
			var y := h * y_ratio
			var rect := Rect2(x, y, slot_w, slot_h)
			draw_rect(rect, Color(0.96, 0.96, 0.92, 0.04), true)
			draw_rect(rect, Color(0.0, 0.0, 0.0, 1.0), false, 3.0)
			var inset := rect.grow(-w * 0.003)
			draw_rect(inset, Color(0.22, 0.18, 0.16, 0.92), false, 1.2)
			draw_line(inset.position + Vector2(0, 1), inset.position + Vector2(inset.size.x, 1), Color(0.95, 0.82, 0.72, 0.18), 1.0)

func _draw_bottom_plate(w: float, h: float) -> void:
	var plate := PackedVector2Array([
		Vector2(w * 0.080, h * 0.655),
		Vector2(w * 0.920, h * 0.655),
		Vector2(w * 0.900, h * 0.812),
		Vector2(w * 0.575, h * 0.812),
		Vector2(w * 0.545, h * 0.958),
		Vector2(w * 0.515, h * 0.812),
		Vector2(w * 0.100, h * 0.812),
	])
	draw_colored_polygon(plate, Color(0.005, 0.005, 0.005, 0.98))
	draw_polyline(plate + PackedVector2Array([plate[0]]), Color(0.16, 0.075, 0.06, 0.88), 2.2, true)
	draw_line(Vector2(w * 0.105, h * 0.690), Vector2(w * 0.895, h * 0.690), Color(0.56, 0.18, 0.13, 0.32), 1.0)
	draw_line(Vector2(w * 0.120, h * 0.802), Vector2(w * 0.500, h * 0.802), Color(0.70, 0.60, 0.52, 0.20), 1.0)
	draw_line(Vector2(w * 0.585, h * 0.802), Vector2(w * 0.880, h * 0.802), Color(0.70, 0.60, 0.52, 0.20), 1.0)

func _draw_center_ornament(w: float, h: float) -> void:
	var c := Vector2(w * 0.545, h * 0.800)
	var s := min(w, h) * 0.115
	var diamond := PackedVector2Array([
		c + Vector2(0, -s * 1.45),
		c + Vector2(s * 0.32, -s * 0.30),
		c + Vector2(s * 1.20, 0),
		c + Vector2(s * 0.32, s * 0.30),
		c + Vector2(0, s * 1.45),
		c + Vector2(-s * 0.32, s * 0.30),
		c + Vector2(-s * 1.20, 0),
		c + Vector2(-s * 0.32, -s * 0.30),
	])
	draw_colored_polygon(diamond, Color(0.01, 0.01, 0.01, 1.0))
	draw_polyline(diamond + PackedVector2Array([diamond[0]]), Color(0.18, 0.075, 0.06, 0.95), 2.0, true)
	draw_line(c + Vector2(0, -s * 1.08), c + Vector2(0, s * 1.02), Color(0.82, 0.74, 0.68, 0.35), 1.1)
	draw_line(c + Vector2(-s * 0.83, 0), c + Vector2(s * 0.83, 0), Color(0.50, 0.17, 0.13, 0.44), 1.0)
	draw_circle(c, s * 0.13, Color(0.05, 0.035, 0.035, 1.0))

func _draw_corner_ornaments(w: float, h: float) -> void:
	_draw_corner(Vector2(w * 0.018, h * 0.110), 1.0, 1.0, w, h)
	_draw_corner(Vector2(w * 0.982, h * 0.110), -1.0, 1.0, w, h)
	_draw_corner(Vector2(w * 0.018, h * 0.625), 1.0, -1.0, w, h)
	_draw_corner(Vector2(w * 0.982, h * 0.625), -1.0, -1.0, w, h)

func _draw_corner(origin: Vector2, sx: float, sy: float, w: float, h: float) -> void:
	var a := min(w, h) * 0.045
	var p := PackedVector2Array([
		origin,
		origin + Vector2(sx * a * 0.80, sy * a * 0.20),
		origin + Vector2(sx * a * 1.18, sy * a * 0.88),
		origin + Vector2(sx * a * 0.45, sy * a * 1.20),
		origin + Vector2(sx * a * 0.05, sy * a * 0.72),
	])
	draw_colored_polygon(p, Color(0.01, 0.01, 0.01, 1.0))
	draw_polyline(p + PackedVector2Array([p[0]]), Color(0.17, 0.075, 0.06, 0.85), 1.8, true)

func _draw_highlights(w: float, h: float) -> void:
	draw_line(Vector2(w * 0.035, h * 0.116), Vector2(w * 0.965, h * 0.116), Color(0.86, 0.76, 0.68, 0.18), 1.0)
	draw_line(Vector2(w * 0.035, h * 0.640), Vector2(w * 0.965, h * 0.640), Color(0.56, 0.18, 0.13, 0.30), 1.0)
	draw_line(Vector2(w * 0.035, h * 0.100), Vector2(w * 0.965, h * 0.100), Color(0.56, 0.18, 0.13, 0.20), 1.0)
