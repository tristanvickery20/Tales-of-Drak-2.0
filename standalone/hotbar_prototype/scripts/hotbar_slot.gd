extends TextureButton

signal slot_activated(slot_id: String)

const SLOT_WIDTH := 72.0
const SLOT_HEIGHT := 96.0
const KEY_STRIP_HEIGHT := 22.0
const ICON_INSET := 7.0

var slot_id := ""
var keybind := ""
var ability_id := ""
var ability_name := ""
var icon_color_id := "red"
var stack_count := 0
var is_disabled := false
var cooldown_total := 0.0
var cooldown_remaining := 0.0
var flash_time := 0.0
var flash_total := 0.24

func _ready() -> void:
	custom_minimum_size = Vector2(SLOT_WIDTH, SLOT_HEIGHT)
	size = Vector2(SLOT_WIDTH, SLOT_HEIGHT)
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
	flash_total = 0.24
	flash_time = flash_total
	if cooldown_seconds > 0.0:
		cooldown_total = cooldown_seconds
		cooldown_remaining = cooldown_seconds
	queue_redraw()

func use_stack_item() -> void:
	if stack_count > 0:
		stack_count -= 1
		queue_redraw()

func set_disabled(value: bool) -> void:
	is_disabled = value
	queue_redraw()

func _on_pressed() -> void:
	slot_activated.emit(slot_id)

func _draw() -> void:
	var full_rect := Rect2(Vector2.ZERO, size)
	var key_rect := Rect2(0.0, 0.0, size.x, KEY_STRIP_HEIGHT)
	var icon_rect := Rect2(0.0, KEY_STRIP_HEIGHT, size.x, size.y - KEY_STRIP_HEIGHT)
	_draw_outer_slot(full_rect)
	_draw_key_label(key_rect)
	_draw_icon_window(icon_rect)
	_draw_icon_art(icon_rect.grow(-ICON_INSET))
	if cooldown_remaining > 0.0 and cooldown_total > 0.0:
		_draw_cooldown(icon_rect)
	if flash_time > 0.0:
		_draw_activation_flash(full_rect, icon_rect)
	if is_disabled:
		_draw_disabled(full_rect)
	_draw_stack_count(icon_rect)

func _draw_outer_slot(rect: Rect2) -> void:
	var bg := Color(0.010, 0.010, 0.012, 0.98)
	var bevel_dark := Color(0.0, 0.0, 0.0, 1.0)
	var bevel_mid := Color(0.21, 0.19, 0.17, 1.0)
	var bevel_light := Color(0.56, 0.51, 0.45, 0.58)
	draw_rect(rect, bg, true)
	draw_rect(rect, bevel_dark, false, 3.0)
	draw_rect(rect.grow(-3.0), bevel_mid, false, 1.2)
	draw_line(rect.position + Vector2(4, 3), rect.position + Vector2(rect.size.x - 5, 3), bevel_light, 1.0)
	draw_line(rect.position + Vector2(3, 4), rect.position + Vector2(3, rect.size.y - 5), Color(0.38, 0.34, 0.30, 0.38), 1.0)
	draw_line(rect.position + Vector2(5, rect.size.y - 4), rect.position + Vector2(rect.size.x - 4, rect.size.y - 4), Color(0.50, 0.15, 0.12, 0.28), 1.0)

func _draw_key_label(rect: Rect2) -> void:
	if keybind.is_empty():
		return
	var font := get_theme_default_font()
	draw_rect(rect.grow(-3.0), Color(0.018, 0.016, 0.017, 0.96), true)
	draw_rect(rect.grow(-3.0), Color(0.16, 0.13, 0.11, 0.9), false, 1.0)
	draw_string(font, rect.position + Vector2(0.0, 16.0), keybind, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 16, Color(0.91, 0.86, 0.77, 1.0))
	draw_string(font, rect.position + Vector2(1.0, 17.0), keybind, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 16, Color(0.0, 0.0, 0.0, 0.55))

func _draw_icon_window(rect: Rect2) -> void:
	var inset := rect.grow(-5.0)
	draw_rect(rect.grow(-2.0), Color(0.0, 0.0, 0.0, 0.95), true)
	draw_rect(inset, Color(0.045, 0.039, 0.038, 1.0), true)
	draw_rect(inset, Color(0.22, 0.19, 0.16, 0.88), false, 1.0)
	draw_line(inset.position + Vector2(2, 1), inset.position + Vector2(inset.size.x - 2, 1), Color(0.85, 0.76, 0.62, 0.18), 1.0)

func _draw_icon_art(rect: Rect2) -> void:
	var c := _icon_color()
	var background := Color(c.r * 0.18, c.g * 0.14, c.b * 0.14, 0.98)
	var center := rect.position + rect.size * 0.5
	draw_rect(rect, background, true)
	draw_circle(center, rect.size.x * 0.55, Color(c.r, c.g, c.b, 0.18))
	draw_circle(center + Vector2(4, -4), rect.size.x * 0.28, Color(c.r, c.g, c.b, 0.12))
	_draw_icon_glyph(rect, c)
	draw_rect(rect, Color(0.82, 0.72, 0.58, 0.16), false, 1.0)

func _draw_icon_glyph(rect: Rect2, c: Color) -> void:
	var p1 := rect.position + Vector2(rect.size.x * 0.20, rect.size.y * 0.78)
	var p2 := rect.position + Vector2(rect.size.x * 0.78, rect.size.y * 0.22)
	draw_line(p1, p2, Color(c.r, c.g, c.b, 0.95), 4.0)
	draw_line(rect.position + Vector2(rect.size.x * 0.27, rect.size.y * 0.28), rect.position + Vector2(rect.size.x * 0.72, rect.size.y * 0.72), Color(c.r, c.g, c.b, 0.64), 2.5)
	draw_circle(rect.position + rect.size * 0.5, 4.5, Color(1.0, 0.92, 0.82, 0.88))

func _draw_cooldown(icon_rect: Rect2) -> void:
	var inner := icon_rect.grow(-7.0)
	var ratio := cooldown_remaining / cooldown_total
	var cooldown_height := inner.size.y * ratio
	var overlay := Rect2(inner.position.x, inner.position.y + inner.size.y - cooldown_height, inner.size.x, cooldown_height)
	draw_rect(overlay, Color(0.0, 0.0, 0.0, 0.68), true)
	draw_rect(inner, Color(0.8, 0.8, 0.78, 0.11), false, 1.0)

func _draw_activation_flash(full_rect: Rect2, icon_rect: Rect2) -> void:
	var strength := flash_time / flash_total
	var alpha := 0.16 + (0.44 * strength)
	draw_rect(full_rect.grow(3.0), Color(1.0, 0.03, 0.02, alpha), true)
	draw_rect(full_rect.grow(2.0), Color(1.0, 0.11, 0.06, 0.95 * strength), false, 3.0)
	draw_rect(icon_rect.grow(-6.0), Color(0.9, 0.03, 0.02, 0.18 * strength), true)

func _draw_disabled(rect: Rect2) -> void:
	draw_rect(rect.grow(-4.0), Color(0.0, 0.0, 0.0, 0.60), true)
	draw_rect(rect.grow(-4.0), Color(0.2, 0.2, 0.2, 0.50), false, 1.0)

func _draw_stack_count(icon_rect: Rect2) -> void:
	if stack_count <= 0:
		return
	var font := get_theme_default_font()
	var text := str(stack_count)
	var pos := icon_rect.position + Vector2(icon_rect.size.x - 27.0, icon_rect.size.y - 7.0)
	draw_string(font, pos + Vector2(1, 1), text, HORIZONTAL_ALIGNMENT_RIGHT, 24.0, 17, Color(0.0, 0.0, 0.0, 0.9))
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_RIGHT, 24.0, 17, Color(0.98, 0.94, 0.86, 1.0))

func _icon_color() -> Color:
	match icon_color_id:
		"purple": return Color(0.62, 0.12, 0.95, 1.0)
		"green": return Color(0.72, 0.9, 0.36, 1.0)
		"gold": return Color(0.95, 0.72, 0.32, 1.0)
		"blue": return Color(0.25, 0.55, 1.0, 1.0)
		"gray": return Color(0.62, 0.60, 0.56, 1.0)
		_: return Color(0.9, 0.06, 0.05, 1.0)
