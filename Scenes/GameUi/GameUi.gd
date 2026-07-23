extends Control


@onready var v_box_complete: VBoxContainer = $VBoxComplete

var _total_cups: int = 0
var _completed_cups: int = 0


func _ready() -> void:
	subscribe_to_signals()
	_total_cups = get_tree().get_nodes_in_group(Cup.GROUP_NAME).size()
	

func subscribe_to_signals() -> void:
	SignalHub.on_cup_destroyed.connect(on_cup_destroyed)


func on_cup_destroyed() -> void:
	increment_completed_cups()
	
	if _completed_cups == _total_cups:
		v_box_complete.show()


func increment_completed_cups() -> void:
	_completed_cups += 1
