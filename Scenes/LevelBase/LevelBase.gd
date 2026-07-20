extends Node

const ANIMAL = preload("uid://boo7p2dpokxia")

@onready var start: Marker2D = $Start


func _ready() -> void:
	subscribe_to_signals()
	spawn_animal()


func subscribe_to_signals() -> void:
	SignalHub.on_animal_died.connect(spawn_animal);


func spawn_animal() -> void:
	var animal: Animal = ANIMAL.instantiate()
	animal.position = start.position
	call_deferred("add_child", animal)
