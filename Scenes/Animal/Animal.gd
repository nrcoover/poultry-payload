class_name Animal


extends RigidBody2D


const DRAG_LIMIT_MIN: Vector2 = Vector2(-85, 0)
const DRAG_LIMIT_MAX: Vector2 = Vector2(0, 85)
const IMPULSE_MULTIPLIER: float = 25.0
const IMPULSE_MAX: float = 3000.0

@onready var label: Label = $Debug
@onready var arrow: Sprite2D = $Arrow
@onready var stretch_sound: AudioStreamPlayer2D = $Audio/StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $Audio/LaunchSound
@onready var kick_sound: AudioStreamPlayer2D = $Audio/KickSound

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _is_dragging: bool = false
var _arrow_scale_x: float = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("drag") and _is_dragging:
		call_deferred("start_release")


func _ready() -> void:
	_start = position
	_arrow_scale_x = arrow.scale.x


func _process(_delta: float) -> void:
	var debug_string: String = "Freeze: %s\nContactCount: %d\nSleeping: %s" % [
		freeze,
		get_contact_count(),
		sleeping
	]
	
	debug_string += "\nis_dragging: %s \ndrag_start: %.0f, %.0f" % [
		_is_dragging, _drag_start.x, _drag_start.y
	]
	debug_string += "\ndragged_vector: %.0f, %.0f" % [
		_dragged_vector.x, _dragged_vector.y,
	]
	debug_string += "\nimpulse: %.0f" % [
		calculate_impulse().length()
	]
	
	label.text = debug_string


func _physics_process(_delta: float) -> void:
	if _is_dragging: handle_dragging()


func calculate_impulse() -> Vector2:
	var direction_reverser = -1
	return _dragged_vector * IMPULSE_MULTIPLIER * direction_reverser


func handle_dragging() -> void:
	var new_dragged_vector: Vector2 = get_global_mouse_position() - _drag_start
	new_dragged_vector = new_dragged_vector.clamp(DRAG_LIMIT_MIN, DRAG_LIMIT_MAX)
	
	var drag_difference: Vector2 = new_dragged_vector - _dragged_vector
	
	if drag_difference.length() > 0 and !stretch_sound.playing:
		stretch_sound.play()
	
	scale_arrow()
	_dragged_vector = new_dragged_vector
	position = _start + _dragged_vector


func start_dragging() -> void:
	arrow.show()
	_is_dragging = true
	_drag_start = get_global_mouse_position()


func start_release() -> void:
	launch_sound.play()
	arrow.hide()
	_is_dragging = false
	freeze = false
	apply_central_impulse(calculate_impulse())


func scale_arrow() -> void:
	var impulse_length: float = calculate_impulse().length()
	var minimum_variation = 0
	var maximum_variation = 1
	var percent_change: float = clamp(impulse_length / IMPULSE_MAX, minimum_variation, maximum_variation)
	
	var scale_multiplier = 2
	arrow.scale.x = lerpf(_arrow_scale_x, _arrow_scale_x * scale_multiplier, percent_change)
	
	arrow.rotation = (_start - position).angle()


func die() -> void:
	SignalHub.emit_on_animal_died()
	queue_free()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		input_event.disconnect(_on_input_event)
		start_dragging()


func _on_body_entered(body: Node) -> void:
	if not kick_sound.is_playing():
		kick_sound.play()


func _on_sleeping_state_changed() -> void:
	if sleeping:
		for body in get_colliding_bodies():
			if body is Cup:
				body.die()
		
		die()
