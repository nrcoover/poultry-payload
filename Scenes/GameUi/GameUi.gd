extends Control


const MAIN = preload("uid://b25pl3t83oyr")

@onready var v_box_complete: VBoxContainer = $VBoxComplete
@onready var music: AudioStreamPlayer = $Music
@onready var attempts_label: Label = $MarginContainer/VBoxStats/HBoxAttempts/AttemptsLabel


var _total_cups: int = 0
var _completed_cups: int = 0
var _attempts: int = 0


func _ready() -> void:
	get_tree().paused = false
	subscribe_to_signals()
	_total_cups = get_tree().get_nodes_in_group(Cup.GROUP_NAME).size()
	update_attempts_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(MAIN)


func subscribe_to_signals() -> void:
	SignalHub.on_cup_destroyed.connect(on_cup_destroyed)
	SignalHub.on_attempt_made.connect(on_attempt_made)


func on_cup_destroyed() -> void:
	increment_completed_cups()
	
	if _completed_cups == _total_cups:
		engage_end_screen()


func increment_completed_cups() -> void:
	_completed_cups += 1


func on_attempt_made() -> void:
	_attempts += 1
	update_attempts_ui()


func update_attempts_ui() -> void:
	attempts_label.text = "%d" % _attempts


func engage_end_screen() -> void:
	v_box_complete.show()
	music.play()
	get_tree().paused = true
