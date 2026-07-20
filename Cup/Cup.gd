class_name Cup

extends StaticBody2D

const VANISH_ANIMATION = "vanish"

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func die() -> void:
	animation_player.play(VANISH_ANIMATION)


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == VANISH_ANIMATION:
		queue_free()
