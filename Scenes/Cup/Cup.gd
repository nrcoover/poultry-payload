class_name Cup

extends StaticBody2D

const VANISH_ANIMATION = "vanish"
const GROUP_NAME: String = "Cup"

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)


func die() -> void:
	animation_player.play(VANISH_ANIMATION)


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == VANISH_ANIMATION:
		SignalHub.emit_on_cup_destroyed()
		queue_free()
