extends Node


signal on_animal_died
signal on_cup_destroyed


func emit_on_animal_died() -> void:
	on_animal_died.emit()


func emit_on_cup_destroyed() -> void:
	on_cup_destroyed.emit()
