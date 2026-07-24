extends TextureButton


@export var level_number: int = 0
@onready var level_label: Label = $MarginContainer/VBox/LevelLabel

var _original_scale: Vector2
var _scale_multiplier: float = 1.1


func _ready() -> void:
	set_original_scale()
	set_level_text()


func _on_mouse_entered() -> void:
	var updated_scale = scale * _scale_multiplier
	set_scale(updated_scale)


func _on_mouse_exited() -> void:
	reset_scale()


func set_original_scale() -> void:
	_original_scale = scale


func reset_scale() -> void:
	set_scale(_original_scale)


func set_level_text() -> void:
	level_label.text = "LV: %s" % str(level_number)


func _on_pressed() -> void:
	open_level(level_number)


func open_level(level: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level%d.tscn" % level)
