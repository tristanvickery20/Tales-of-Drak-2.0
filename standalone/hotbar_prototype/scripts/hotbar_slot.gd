extends TextureButton

signal slot_activated(slot_id: String)

const SLOT_SIZE := 58.0
const LABEL_HEIGHT := 22.0
const CONTROL_HEIGHT := 80.0

var slot_id := ""
var keybind := ""
var ability_id := ""
var ability_name := ""
var icon_color_id := "red"
var stack_count := 0
var is_selected := false
var is_disabled := false
var cooldown_total := 0.0
var cooldown_remaining := 0.0
var flash_time := 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(SLOT_SIZE, CONTROL_HEIGHT)
	size = Vector2(SLOT_SIZE, CONTROL_HEIGHT)
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	pressed.connect(_on_pressed)
	queue_redraw()

func configure(data: Dictionary) -> void:
	slot_id = str(data.get("slot_id", ""))
	keybind = str(data.get("keybind", ""))
	ability_id = str(data.get("ability_id", ""))
	ability_name = str(data.get("ability_name", ability_id))
	icon_color_id = str(data.get("icon_color_id", "red"))
	stack_count = int(data.get("stack_count", 0))
	is_selected = bool(data.get("is_selected", false))
	is_disabled = bool(data.get("is_disabled", false))
	tooltip_text = ability_name
	queue_redraw()

func _process(delta: float) -> void:
	var needs_redraw := false
	if cooldown_remaining > 0.0:
		cooldown_remaining = maxf(0.0, cooldown_remaining - delta)
		needs_redraw = true
	if flash_time > 0.0:
		flash_time = maxf(0.0, flash_time - delta)
		needs_redraw = true
	if needs_redraw:
		queue_redraw()

func can_activate() -> bool:
	return not is_disabled and cooldown_remaining <= 0.0

func activate_visuals(cooldown_seconds: float) -> void:
	flash_time = 0.18
	if cooldown_seconds > 0.0:
		cooldown_total = cooldown_seconds
		cooldown_remaining = cooldown_seconds
	queue_redraw()

func use_stack_item() -> void:
	if stack_count > 0:
		stack_count -= 1
		queue_redraw()

func set_selected(value: bool) -> void:
	is_selected = value
	queue_redraw()

func set_disabled(value: bool) -> void:
	is_disabled = value
	queue_redraw()

func _on_pressed() -> void:
	slot_activated.emit(slot_id)

func _draw() -> void:
	var slot_rect := Rect2(0.0, LABEL_HEIGHT, SLOT_SIZE, SLOT_SIZE)
	_draw_key_label(slot_rect)
	_draw_slot_frame(slot_rect)
	_draw_icon(slot_rect.grow(-8.0))
	if cooldown_remaining > 0.0 and cooldown_total > 0.0:
		_draw_cooldown(slot_rect)
	if is_selected or flash_time > 0.0:
		_draw_selected_glow(slot_rect)
	if is_disabled:
		_draw_disabled(slot_rect)
	_draw_stack_count(slot_rect)

func _draw_key_label(slot_rect: Rect2) -> void:
	var font := get_theme_default_font()
	draw_string(font, Vector2(slot_rect.position.x, 16.0), keybind, HORIZONTAL_ALIGNMENT_CENTER, slot_rect.size.x, 17, Color(0.88, 0.84, 0.76, 1.0))

func _draw_slot_frame(rect: Rect2) -> void:
	var fill := Color(0.035, 0.031, 0.032, 0.98)
	var inner := Color(0.11, 0.095, 0.09, 1.0)
	var border := Color(0.38, 0.34, 0.31, 0.98)
	draw_rect(rect, fill, true)
	draw_rect(rect, border, false, 2.0)
	draw_rect(rect.grow(-5.0), inner, true)
	draw_rect(rect.grow(-5.0), Color(0.18, 0.15, 0.13, 1.0), false, 1.0)

	var corner := 8.0
	var c := Color(0.58, 0.51, 0.42, 0.55)
	draw_line(rect.position, rect.position + Vector2(corner, 0.0), c, 1.0)
	draw_line(rect.position, rect.position + Vector2(0.0, corner), c, 1.0)
	draw_line(rect.position + Vector2(rect.size.x, 0.0), rect.position + Vector2(rect.size.x - corner, 0.0), c, 1.0)
	draw_line(rect.position + Vector2(rect.size.x, 0.0), rect.position + Vector2(rect.size.x, corner), c, 1.0)
	draw_line(rect.position + Vector2(0.0, rect.size.y), rect.position + Vector2(corner, rect.size.y), c, 1.0)
	draw_line(rect.position + Vector2(0.0, rect.size.y), rect.position + Vector2(0.0, rect.size.y - corner), c, 1.0)
	draw_line(rect.position + rect.size, rect.position + rect.size - Vector2(corner, 0.0), c, 1.0)
	draw_line(rect.position + rect.size, rect.position + rect.size - Vector2(0.0, corner), c, 1.0)

func _draw_icon(rect: Rect2) -> void:
	var c := _icon_color()
	var bg := Color(c.r * 0.22, c.g * 0.18, c.b * 0.18, 0.96)
	var center := rect.position + rect.size * 0.5
	draw_rect(rect, bg, true)
	draw_rect(rect, Color(0.75, 0.66, 0.52, 0.16), false, 1.0)
	draw_circle(center, rect.size.x * 0.45, Color(c.r, c.g, c.b, 0.18))
	draw_line(rect.position + Vector2(3.0, rect.size.y - 5.0), rect.position + Vector2(rect.size.x - 3.0, 5.0), c, 3.0)
	draw_line(rect.position + Vector2(9.0, 5.0), rect.position + Vector2(rect.size.x - 9.0, rect.size.y - 7.0), Color(c.r, c.g, c.b, 0.68), 2.0)
	draw_circle(center, 4.0, Color(1.0, 0.92, 0.82, 0.9))

func _draw_cooldown(slot_rect: Rect2) -> void:
	var inset := 6.0
	var inner := slot_rect.grow(-inset)
	var ratio := cooldown_remaining / cooldown_total
	var cooldown_height := inner.size.y * ratio
	var overlay := Rect2(inner.position.x, inner.position.y + inner.size.y - cooldown_height, inner.size.x, cooldown_height)
	draw_rect(overlay, Color(0.0, 0.0, 0.0, 0.68), true)

func _draw_selected_glow(slot_rect: Rect2) -> void:
	var alpha := 0.32
	if flash_time > 0.0:
		alpha = 0.52
	draw_rect(slot_rect.grow(3.0), Color(1.0, 0.08, 0.04, alpha), true)
	draw_rect(slot_rect.grow(3.0), Color(1.0, 0.12, 0.07, 0.95), false, 2.0)
	draw_rect(slot_rect.grow(-6.0), Color(0.7, 0.03, 0.02, 0.16), true)

func _draw_disabled(slot_rect: Rect2) -> void:
	draw_rect(slot_rect.grow(-5.0), Color(0.0, 0.0, 0.0, 0.58), true)

func _draw_stack_count(slot_rect: Rect2) -> void:
	if stack_count <= 0:
		return
	var font := get_theme_default_font()
	draw_string(font, slot_rect.position + Vector2(slot_rect.size.x - 21.0, slot_rect.size.y - 5.0), str(stack_count), HORIZONTAL_ALIGNMENT_RIGHT, 18.0, 15, Color(0.96, 0.92, 0.86, 1.0))

func _icon_color() -> Color:
	match icon_color_id:
		"purple":
			return Color(0.62, 0.12, 0.95, 1.0)
		"green":
			return Color(0.72, 0.9, 0.36, 1.0)
		"gold":
			return Color(0.95, 0.72, 0.32, 1.0)
		"blue":
			return Color(0.25, 0.55, 1.0, 1.0)
		"gray":
			return Color(0.62, 0.60, 0.56, 1.0)
		_:
			return Color(0.9, 0.06, 0.05, 1.0)
