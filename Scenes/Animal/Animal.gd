class_name Animal


extends RigidBody2D


@onready var label: Label = $Debug


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	label.text = "Freeze: %s\nContactCount: %d\nSleeping: %s" % [
		freeze,
		get_contact_count(),
		sleeping
	]
